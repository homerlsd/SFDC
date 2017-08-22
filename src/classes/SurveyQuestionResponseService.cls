@RestResource(urlMapping='/createQuestions/*')
global class SurveyQuestionResponseService {

    @HttpPost   
    global static String createQs() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        res.statusCode = 200;

        string jresp = req.requestBody.toString();

        SurveyQuestionResponse questionResp = new SurveyQuestionResponse();
        
        try{
            questionResp = SurveyQuestionResponse.parse(jresp);
        }
        catch(exception ex){
            res.statusCode = 400;
            return ex.getMessage();
        }

        system.debug('SURVEY QUESTION RESPONSE POST IS ' + questionResp);

        if(questionResp != null){

            List<SurveyQuestionResponse__c> newResps = new List<SurveyQuestionResponse__c>();

            system.debug(questionResp);

            //Key value set of strings (NPS, text) to their matching question
            Map<String, ID> qMap = new Map<String,ID>();

            //Loop through the questions for this survey ID and map the NPS and Text Question IDs to be assigned below
            for(Survey_Question__c qq : [select id, name, type__c, NPS__c from Survey_Question__c where Survey__c = :questionResp.surveyID]){
                if(qq.NPS__c)
                    qMap.put(Label.SurveyQuestionResponseService_NPSKeyValue,qq.id);
                else if(qq.type__c == 'Free Text')
                    qMap.put(Label.SurveyQuestionResponseService_TextKeyValue, qq.id);
            }

            system.debug('QMAP IS  ' + qMap);

            //If we don't hav at least an NPS and Comments question we call it off
            if(qMap.size() == 2){

                SurveyTaker__c survTaker = new SurveyTaker__c(Rally_ID__c = questionResp.rallyid, Community_ID__c = questionResp.sessionID, Survey__c = questionResp.surveyID, Source__c = questionResp.appID, Platform_ID__c = questionResp.platformID, Version__c = questionResp.appVersion, Transaction_ID__c = questionResp.TransactionID, Client_ID__c = questionResp.clientID);

                try{
                    if(questionResp.surveyDate != null && questionResp.surveyDate != ''){
                        string survDate = questionResp.surveyDate.replace('T', ' ');
                        system.debug(survDate);
                        survDate = survDate.substring(0,survDate.length()-5);
                        system.debug(survDate);
                        Datetime survDT = DateTime.valueOf(survDate);
                        system.debug(survDT);

                        survTaker.Survey_Date__c = survDT;
                    }
                }
                catch(exception ex){
                    try{
                        string survDate = questionResp.surveyDate.replace('T', ' ');
                        system.debug(survDate);
                        survDate = survDate.replace('Z', '');
                        system.debug(survDate);
                        Datetime survDT = DateTime.valueOf(survDate);
                        system.debug(survDT);

                        survTaker.Survey_Date__c = survDT;
                    }
                    catch(exception ex2){
                        List<Utils.ApexError> aes = new List<Utils.ApexError>();
                        Utils.ApexError ae = new Utils.ApexError();

                        String errString = ex2.getMessage();
                        ae.pageOrProcess = 'SurveyQuestionResponseService - Bad Date: ' + questionResp.surveyDate;
                        ae.userId = UserInfo.getUserId();  
                        ae.errorString = errString;
                        ae.timeStamp = date.today();
                        aes.add(ae);

                        Utils.addSingleErrorLog(aes);

                        res.statusCode = 400;
                        return 'INVALID DATE TIME FORMAT';  
                    }
                }
                
                //Key value set of survey question ids to surveyquestionresponse records stored in the system
                Map<id, SurveyQuestionResponse__c> existingQsMap = new Map<id, SurveyQuestionResponse__c>();

                system.debug('TRANSACTION ID IS ' + questionResp.transactionID);

                SurveyTaker__c[] survCheck = [select id, (select id, Response__c, Text_Response__c, Survey_Question__c, Survey_Question__r.NPS__c, Survey_Question__r.type__c from Survey_Question_Answers__r)
                                                        from SurveyTaker__c WHERE (Transaction_ID__c != NULL AND Transaction_ID__c = : questionResp.TransactionID)];

                if(!survCheck.isEmpty()){

                    system.debug('EXISTING RESPONSE IS ' + survCheck);

                    for(SurveyQuestionResponse__c srq : survCheck[0].Survey_Question_Answers__r){
                        existingQsMap.put(srq.Survey_Question__c, srq);
                    }
                }
                else{
                    try{
                        insert survTaker;
                    }
                    catch(DmlException dml){
                        res.statusCode = 400;
                        return dml.getMessage();
                    }
                }

                id surveyTakeID = !survCheck.isEmpty() ? survCheck[0].id : survTaker.id;
                
                for(SurveyQuestionResponse.Questions sv : questionResp.Questions){
                    SurveyQuestionResponse__c svr = new SurveyQuestionResponse__c();

                    if(sv.question_type == Label.SurveyQuestionResponseService_NPSKeyValue){
                        system.debug('NPS QUESTION RESPONSE' + sv.response);

                        if(existingQsMap.get(qMap.get(Label.SurveyQuestionResponseService_NPSKeyValue)) != null){
                           svr = existingQsMap.get(qMap.get(Label.SurveyQuestionResponseService_NPSKeyValue)); 
                        }
                        else{
                            svr.SurveyTaker__c = surveyTakeID;
                            svr.Survey_Question__c = qMap.get(Label.SurveyQuestionResponseService_NPSKeyValue);
                        }

                        svr.Response__c = sv.Response;
                        system.debug('NPS ANSWER IS ' + svr.Response__c);
                        newResps.add(svr);
                    }
                    else if(sv.question_type == Label.SurveyQuestionResponseService_TextKeyValue){
                        system.debug('TEXT QUESTION RESPONSE' + sv.response);

                        if(existingQsMap.get(qMap.get(Label.SurveyQuestionResponseService_TextKeyValue)) != null)
                           svr = existingQsMap.get(qMap.get(Label.SurveyQuestionResponseService_TextKeyValue)); 
                        else{
                            svr.SurveyTaker__c = surveyTakeID;
                            svr.Survey_Question__c = qMap.get(Label.SurveyQuestionResponseService_TextKeyValue);
                        }
                        
                        svr.Text_Response__c = sv.Response;
                        system.debug('TEXT ANSWER IS ' + svr.Text_Response__c);
                        newResps.add(svr);
                    }
                }

                if(!newResps.isEmpty()){
                    try{
                        upsert newResps;
                        res.statusCode = 201;
                        return 'Success';
                    }
                    catch(DmlException dml){
                        res.statusCode = 400;
                        return dml.getMessage();
                    }
                }
                else{
                    res.statusCode = 201;
                    return 'Success - No Responses';
                }
            }
            else{
                res.statusCode = 400;
                return 'Incorrect Survey ID/Post Payload - Unable to find survey configuration.';
            }
        }
        else{
            res.statusCode = 400;
            return Label.SurveyQuestionResponseService_NoPostBody;
        }
    }
}