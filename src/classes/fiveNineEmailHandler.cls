Global class fiveNineEmailHandler implements Messaging.InboundEmailHandler
{
    Global string nameFile{get;set;}
    Global blob contentFile{get;set;}
    String[] filelines = new String[]{};
        Boolean processSheet = True;
    List<task> tsk;  
    List<Case> lcases;

    List <Messaging.SingleEmailMessage> Mail = new List <Messaging.SingleEmailMessage>();
    List <Messaging.SingleEmailMessage> Mails = new List <Messaging.SingleEmailMessage>();

    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope)
    {   
        Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        String dayOfWeek=dt.format('EEEE');
        
        if(dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday'){
            nameFile = email.toString();         
            filelines = nameFile.split('\n');
            System.debug(' filelines... ' + filelines);
            tsk = new List<task>();
            //Here I'm writing a map since I've 2 lookup fields
            Map<String,Task> taskMap = New Map<String, Task>();
            Map<String, Case> CaseMap = New Map<string, Case>();
            Map<String,Partner__c> partnerMap = New Map<String, Partner__c>();
            Map<String,String> SH_map = New Map<String, String>();
            String a1= '';
            
            //DYNAMIC task QUERY WORK
            List<string> taskStandardFieldList = new List<string>{'id'};
            string queryString_task = '';
            
            for(Schema.FieldSetMember fsm: SObjectType.Task.FieldSets.five9ServiceFields.getFields()){
                taskStandardFieldList.add(fsm.getfieldPath());
            }

            // Add to set to de-dup field listing
            Set<string> fieldSet_task = new Set<string>();
            for(string s: taskStandardFieldList){
                fieldSet_task.add(s.toLowerCase());
            }
            
            // Build SOQL query (for ContactInformation)
            List<string> fieldList_task = new List<string>(fieldSet_task);
            for (Integer i=0; i<fieldList_task.size(); i++) {
                if(i == 0) {
                        queryString_task = 'select ' + fieldList_task[i];
                } else {
                        queryString_task += ', ' + fieldList_task[i];
                }
            }

            queryString_task += ' from task where Five9__Five9SessionId__c != null ORDER BY CreatedDate DESC LIMIT 1000';

            system.debug('QUERY task FIELDS ARE ' + queryString_task);

            tsk = Database.query(queryString_task);

            lcases=[select Id, Call_ID__c From Case where Origin='Phone' and Call_ID__c!=Null and CreatedDate = Today];



            system.debug('QUERIED task FIELDS ARE ' + tsk);

            system.debug('QUERIED case FIELDS ARE ' + lcases);

            for(task ts : tsk){
                taskMap.put(ts.Five9__Five9SessionId__c, ts);
            }

            for(case cs: lcases){
                CaseMap.put(cs.Call_ID__c, cs);
            }

            for(Partner__c p : [select id, Support_Number_Formula__c from Partner__c]){
                partnerMap.put(p.Support_Number_Formula__c, p);
            }

            Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
            System.debug(' >email< ' + email);
            String fileAttachments = '';

            System.debug(' email attachments ' + email.TextAttachments);
            Messaging.InboundEmail.textAttachment[] tAttachments = email.TextAttachments;
            System.debug(' size of tAttachments ' + tAttachments.size() + 'Text Attachement from the email.' + tAttachments);
            Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments;
            System.debug(' Binary Attachement from the email. ' + bAttachments);
            String csvbody = '';
            for(integer i=0; i < tAttachments.size(); i++)
            {
                System.debug(' attacments... ' + tAttachments[i]);
                fileAttachments = String.valueOf(tAttachments[i]);
            }
            List<task> updatetsks = new List<task>();
            set<id> updatetskSet = new set<id>();
            List<task> insertTasks = new List<task>();

            List<String> badrows = new List<String>();
            String csvBody1 = '';
            String[] lineByCsvBody = new String[]{};
            List<String> linebycsvdata = new List<String>();

            If(tAttachments != Null && tAttachments.size() > 0)
            {
                For(Messaging.InboundEmail.textAttachment ttt : tAttachments)
                {
                    csvBody1 = ttt.body;
                    lineByCsvBody = csvBody1.split('\n');
                    System.debug('CSV BODY'+ csvBody1 + 'lines' +lineByCsvBody +' size of lineByCsvBody ' + lineByCsvBody.size() + ' This is a Text Attachment from the email parsed. ' + ttt);

                    For(Integer j = 0; j < lineByCsvBody.size(); j++)
                    {
                        System.debug(' lineByCsvBody data...... ' + lineByCsvBody[j]);
                        If(j==0)
                        { 
                            /*Here I'm checking and splitting the header values*/
                            String headerRow = lineByCsvBody[j];
                            System.debug(' headerRow DATA ...  ' + headerRow);
                            String hvalue = csvbody1;
                            String[] headervalue = headerRow.split(',');
                            System.debug(' size of headervalue ' + headervalue.size());
                            System.debug(' headervalue1 '+ headervalue[0] + ' headervalue2 ' + headervalue[1]
                                        + ' headervalue3 ' + headervalue[2] + ' headervalue4 ' + headervalue[3]
                                        + ' headervalue5 ' + headervalue[4] + ' headervalue6 ' + headervalue[5]);

                            if(headervalue[0] == Null || headervalue[0] == '' || headervalue[0].trim().length() < 1)
                            {
                                badrows.add('Column 1 : SESSION ID Column name is null.');
                            }    
                            Else if(headervalue[0] != 'SESSION ID')
                            {
                                badrows.add('Column 1 : SESSION ID Column name should be accurate.');
                            }

                            System.debug(' badrows ' + badrows.size());
                           
                            Messaging.SingleEmailMessage Errormail = new Messaging.SingleEmailMessage();

                            List <String> sendTo = new List <String>();
                            sendTo.add('alex.roth@rallyhealth.com');
                            Errormail.setToAddresses(sendTo);

                            Errormail.setReplyTo('alex.roth@rallyhealth.com');
                            Errormail.setSenderDisplayName('five9 Email Service');

                            Errormail.setSubject('ERROR :: Failed to process five9 Upload template (CSV)');

                            String body = '<html><body>Dear Supplier,' + '<br>' + '<br>' +'The five9 Upload CSV Template failed to process because the below header values are missing in the sheet.' + '<br>' + '<br>';

                            if(badrows.size() > 0)
                            {
                                processSheet = false;
                                for(String str:badrows)
                                {
                                    System.debug('value of str ' + str);
                                    body += str + '<br>' +'<br>';
                                }
                            }
                            body += '<br>' + '<br>' + 'Correct the header columns and re-send for uploading again.' 
                                    + '<br>' + 'Reach out to  Admin for further assistance.' 
                                + '<br>' + '<br>' + '<br>' + '-  Team.</body></html>';

                            Errormail.setHtmlBody(body);

                            Mail.add(Errormail);

                            System.debug(' size of list ' + lineByCsvBody.size());
                            System.debug(' processSheet ' + processSheet);
                            if(badrows.size() > 0)
                            {
                                Messaging.sendEmail(Mail);
                                break;
                            }
                        }
                        if(j>0 && processSheet)
                        {
                            linebycsvdata.add(lineByCsvBody[j]);
                            System.debug('inside j>0'+linebycsvdata);
                        }
                    }
                }
            }
            System.debug(' size of list ' + lineByCsvBody.size());
            System.debug(' size of list of linebycsvdata ' + linebycsvdata.size());
            System.debug(' processSheet ' + processSheet);
            if( processSheet ) 
            {
                System.debug('inside insertion part ' + linebycsvdata.size());
                Try
                {
                    id tempAccountID = Utils.getNextAccountID();

                    integer rowCount=0;
                    for(String svalue:linebycsvdata)
                    {
                        /*Here I'm checking and splitting the values / data contained in the .csv file*/
                        rowCount++;
                        String[] splitvalue = svalue.split(','); 
                        System.debug(' size of splitvalue ' + splitvalue.size());
                        task customobject = new task();

                        if(splitvalue.size() == 21){
                            System.debug(' splitvalue1 ' + splitvalue[0] + ' splitvalue2 ' + splitvalue[1]
                                         + ' splitvalue3 ' + splitvalue[2] + ' splitvalue4 ' + splitvalue[3]
                                         + ' splitvalue5 ' + splitvalue[4] + ' splitvalue6 ' + splitvalue[5]
                                         + ' splitvalue7 ' + splitvalue[6] + ' splitvalue8 ' + splitvalue[7]
                                         + ' splitvalue9 ' + splitvalue[8] + ' splitvalue10 ' + splitvalue[9]
                                         + ' splitvalue11 ' + splitvalue[10] + ' splitvalue12' + splitvalue[11]
                                         + ' splitvalue13' + splitvalue[12] + ' splitvalue14' + splitvalue[13]
                                         + ' splitvalue15' + splitvalue[14] + ' splitvalue16' + splitvalue[15]
                                         + ' splitvalue17' + splitvalue[16] + ' splitvalue18' + splitvalue[17]
                                         + ' splitvalue19' + splitvalue[18] + ' splitvalue20' + splitvalue[19] + + ' splitvalue21' + splitvalue[20]);


                            if(splitvalue[0] == '' || splitvalue[0].trim().length() < 1 || splitvalue[0] == Null)
                            {
                                badrows.add('row number'+rowCount+' field value is missing');
                                continue;
                            }
                            if(splitvalue[1] == '' || splitvalue[1].trim().length() < 1 || splitvalue[1] == Null)
                            {
                                badrows.add('row number'+rowCount+' field value is missing');
                                continue;
                            }
                            
                            system.debug('taskMap'+taskmap);

                            if(taskMap.containsKey(splitvalue[0]) && taskMap.get(splitvalue[0]).Processed__c == false){
                                task tt = taskMap.get(splitvalue[0]);
                                
                                tt.Processed__c = true;
                                tt.Gate_Name__c = splitvalue[20];

                                system.debug('TASK IN LOOP TO BE UPATED ' + tt);
                                system.debug('tempAccountID'+tempAccountID);

                                //based on the headers we know we have 10 time based fields in a row, get all of them at once to save script statments
                                List<string> tempList = new List<String>{splitvalue[1],splitvalue[2],splitvalue[3],splitvalue[4],splitvalue[5],splitvalue[6],splitvalue[7],splitvalue[8],splitvalue[9],splitvalue[10],splitvalue[11],splitvalue[12]};
                                
                                Map<string,integer> tempMap = Utils.findSecondsMapFromString(tempList);

                                if(!tempMap.isEmpty()){
                                    if(tempMap.containsKey(splitvalue[1])){
                                        tt.Queue_Duration__c = tempMap.get(splitvalue[1]);
                                    }
                                    if(tempMap.containsKey(splitvalue[2])){
                                        tt.Call_Time__c = tempMap.get(splitvalue[2]);
                                    }
                                    if(tempMap.containsKey(splitvalue[3])){
                                        tt.IVR_Time__c = tempMap.get(splitvalue[3]);
                                    }
                                    if(tempMap.containsKey(splitvalue[4])){
                                        tt.Ring_Time__c = tempMap.get(splitvalue[4]);
                                    }
                                    if(tempMap.containsKey(splitvalue[5])){
                                        tt.Answer_Time__c = tempMap.get(splitvalue[5]);
                                    }
                                    if(tempMap.containsKey(splitvalue[6])){
                                        tt.Talk_time__c = tempMap.get(splitvalue[6]);
                                    }
                                    if(tempMap.containsKey(splitvalue[7])){
                                        tt.Hold_Time__c = tempMap.get(splitvalue[7]);
                                    }
                                    if(tempMap.containsKey(splitvalue[8])){
                                        tt.Consult_Time__c = tempMap.get(splitvalue[8]);
                                    }
                                    if(tempMap.containsKey(splitvalue[9])){
                                        tt.Time_to_Abandon__c = tempMap.get(splitvalue[9]);
                                    }
                                    if(tempMap.containsKey(splitvalue[10])){
                                        tt.Third_Party_Talk_Time__c = tempMap.get(splitvalue[10]);
                                    }
                                    if(tempMap.containsKey(splitvalue[11])){
                                        tt.Talk_Time_Less_Hold_and_Park__c = tempMap.get(splitvalue[11]);
                                    }
                                    if(tempMap.containsKey(splitvalue[12])){
                                        tt.Conference_Time__c = tempMap.get(splitvalue[12]);
                                    }
                                }

                                if(splitvalue[13] != null && splitvalue[13] != '')
                                    tt.Transfers__c = integer.valueOf(splitvalue[13]);
                                if(splitvalue[14] != null && splitvalue[14] != '')
                                    tt.Holds__c = integer.valueOf(splitvalue[14]);
                                if(splitvalue[15] != null && splitvalue[15] != '')
                                    tt.Conferences__c = integer.valueOf(splitvalue[15]);

                                tt.Disconnected__c = (splitvalue[16] == NULL || splitvalue[16] == '' || splitvalue[16] == '0') ? false : true;
                                tt.Service_Level__c = (splitvalue[17] == NULL || splitvalue[17] == '' || splitvalue[17] == '0') ? false : true;
                                tt.Abandoned__c = (splitvalue[18] == NULL || splitvalue[18] == '' || splitvalue[18] == '0') ? false : true;
                                
                                if(updatetskSet.isEmpty() || !updatetskSet.contains(tt.id)){
                                    updatetsks.add(tt);
                                    updatetskSet.add(tt.id);
                                }
                            }
                            else if(!taskMap.containsKey(splitvalue[0])){
                                task tt = new Task();
                                
                                if(splitvalue[19] != null && splitvalue[19] != '' && partnerMap.containsKey(splitvalue[19])){
                                    tt.Partner__c = partnerMap.get(splitvalue[19]).id;
                                }
                                if(!CaseMap.isEmpty() && CaseMap.containsKey(splitvalue[0])){
                                    tt.WhatId=CaseMap.get(splitvalue[0]).Id;
                                }
                                else{
                                    tt.WhatId = tempAccountID;    
                                }

                                tt.Five9__Five9SessionId__c = splitvalue[0];
                                tt.Five9__Five9DNIS__c = splitvalue[19];
                                tt.Subject = 'Orphaned/Abandoned Call';
                                tt.Status = 'Completed';
                                tt.Priority = 'Normal';
                                tt.Processed__c = true;
                                tt.ActivityDate = date.today();
                                tt.Gate_Name__c = splitvalue[20];

                                system.debug('TASK IN LOOP TO BE UPATED ' + tt);

                                //based on the headers we know we have 10 time based fields in a row, get all of them at once to save script statments
                                List<string> tempList = new List<String>{splitvalue[1],splitvalue[2],splitvalue[3],splitvalue[4],splitvalue[5],splitvalue[6],splitvalue[7],splitvalue[8],splitvalue[9],splitvalue[10],splitvalue[11],splitvalue[12]};
                                
                                Map<string,integer> tempMap = Utils.findSecondsMapFromString(tempList);

                                if(!tempMap.isEmpty()){
                                    if(tempMap.containsKey(splitvalue[1])){
                                        tt.Queue_Duration__c = tempMap.get(splitvalue[1]);
                                    }
                                    if(tempMap.containsKey(splitvalue[2])){
                                        tt.Call_Time__c = tempMap.get(splitvalue[2]);
                                    }
                                    if(tempMap.containsKey(splitvalue[3])){
                                        tt.IVR_Time__c = tempMap.get(splitvalue[3]);
                                    }
                                    if(tempMap.containsKey(splitvalue[4])){
                                        tt.Ring_Time__c = tempMap.get(splitvalue[4]);
                                    }
                                    if(tempMap.containsKey(splitvalue[5])){
                                        tt.Answer_Time__c = tempMap.get(splitvalue[5]);
                                    }
                                    if(tempMap.containsKey(splitvalue[6])){
                                        tt.Talk_time__c = tempMap.get(splitvalue[6]);
                                    }
                                    if(tempMap.containsKey(splitvalue[7])){
                                        tt.Hold_Time__c = tempMap.get(splitvalue[7]);
                                    }
                                    if(tempMap.containsKey(splitvalue[8])){
                                        tt.Consult_Time__c = tempMap.get(splitvalue[8]);
                                    }
                                    if(tempMap.containsKey(splitvalue[9])){
                                        tt.Time_to_Abandon__c = tempMap.get(splitvalue[9]);
                                    }
                                    if(tempMap.containsKey(splitvalue[10])){
                                        tt.Third_Party_Talk_Time__c = tempMap.get(splitvalue[10]);
                                    }
                                    if(tempMap.containsKey(splitvalue[11])){
                                        tt.Talk_Time_Less_Hold_and_Park__c = tempMap.get(splitvalue[11]);
                                    }
                                    if(tempMap.containsKey(splitvalue[12])){
                                        tt.Conference_Time__c = tempMap.get(splitvalue[12]);
                                    }
                                }

                                if(splitvalue[13] != null && splitvalue[13] != '')
                                    tt.Transfers__c = integer.valueOf(splitvalue[13]);
                                if(splitvalue[14] != null && splitvalue[14] != '')
                                    tt.Holds__c = integer.valueOf(splitvalue[14]);
                                if(splitvalue[15] != null && splitvalue[15] != '')
                                    tt.Conferences__c = integer.valueOf(splitvalue[15]);

                                tt.Disconnected__c = (splitvalue[16] == NULL || splitvalue[16] == '' || splitvalue[16] == '0') ? false : true;
                                tt.Service_Level__c = (splitvalue[17] == NULL || splitvalue[17] == '' || splitvalue[17] == '0') ? false : true;
                                tt.Abandoned__c = (splitvalue[18] == NULL || splitvalue[18] == '' || splitvalue[18] == '0') ? false : true;
                                
                                insertTasks.add(tt);
                            }
                        }
                    }

                    System.debug('insertTa tasks final ' + insertTasks);

                    if(!insertTasks.isEmpty())
                        database.insert(insertTasks, false);
                    
                    System.debug('Updates tasks final ' + updatetsks);

                    if(!updatetsks.isEmpty())
                        database.update(updatetsks, false);

                    For(string u:badrows)
                    {
                        a1 += u;
                    }
                    System.debug(' Badrows ' + a1);
                    result.success = true;
                    System.debug(' Result '  + result.success);         
                }
                catch (Exception e)
                {
                    System.debug(' Exception ' + e);
                    result.success = false;
                    System.debug(' Result '  + result.success);
                }
                Messaging.SingleEmailMessage SuccessMail = new Messaging.SingleEmailMessage();

                List <String> sendTo1 = new List <String>();
                sendTo1.add('alex.roth@rallyhealth.com');
                SuccessMail.setToAddresses(sendTo1);

                SuccessMail.setReplyTo('alex.roth@rallyhealth.com');
                SuccessMail.setSenderDisplayName('five9 Email Service');
          
                SuccessMail.setSubject('five9 Hourly Upload :: Update Success :: '+ updatetsks.size() + ' records. ' + 'Insert Success :: ' + insertTasks.size() + ' records.' + 'ERROR :: ' + badrows.size() + ' records.');

                String body1 = '<html><body>Dear Admin,' + '<br>' + '<br>' + 'Update Records sucessfully processed :: '+ updatetsks + '<br>' + '<br>' + 'Insert Records sucessfully processed :: '+ insertTasks + '<br>' + '<br>' + 'Number of Records failed to process :: ' + badrows + '<br>' + '<br>' + '<br>' + '- Team.</body></html>';
                /*result.message = ('The following number of records '+ updatetsks.size() + ' got created successfuly by the Email Service and ' + '<br>' + a1 + ' number of records got failed by the Email Service.');*/

                SuccessMail.setHtmlBody(body1);

                Mails.add(SuccessMail);
                if(updatetsks.size() > 0)
                {
                    Messaging.sendEmail(Mails);
                }
            }
            return result;
        }
        else{
            return null;
        }
    }
}