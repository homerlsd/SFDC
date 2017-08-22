/*********************EDIT LOG***************************/
//AMR - ADDING LOGIC FOR NPS QUESTION SCORING - 7/7/16
/********************************************************/
public with sharing class QACasesController 
{
    private ApexPages.StandardSetController standardController;
    public string currentQAID                                                           {get;set;}
    public string selectedType                                                          {get;set;}

    public case c                                                                       {get;set;}
    public decimal score                                                                {get;set;}
    public integer npsScore                                                                {get;set;}
    public decimal total                                                                {get;set;}
    public decimal nps                                                                  {get;set;}

    public boolean isExisting                                                           {get;set;}
    public boolean isSuccess                                                            {get;set;}
    public boolean isAdmin                                                              {get;set;}
    public boolean allzero                                                              {get;set;}

    public Quality_Assurance_Review__c qaNew                                            {get;set;}
    public List<Quality_Assurance_Review__c> allQAs                                     {get;set;}
    public List<Case> selectedCaseNumbers                                               {get;set;}
    public List<Quality_Assurance_Response__c> respList                                 {get;set;}
    public Quality_Assurance_Response__c selectedResp                                   {get;set;}
    public Map<id, List<Quality_Assurance_Response__c>> caseToResponseMap               {get;set;}
    public Map<string, decimal> scoremap                                                {get;set;}
    public Map<string, decimal> zeroedQs                                                {get;set;}
    public Map<string, Quality_Assurance_Response__c> respMap                           {get;set;}
    public Map<string, List<Quality_Assurance_Response__c>> catMap                            {get;set;}
    public List<Quality_Assurance_Review__c> existingResp                               {get;set;}

    public QACasesController()
    {
    	score = 0;
    	total = 0;
        npsScore = 0;
    	
    	selectedType = '';

    	isExisting = false;
		isSuccess = false;
        isAdmin = false;
		allzero = false;

    	currentQAID = ApexPages.currentPage().getParameters().get('id');

    	qaNew = new Quality_Assurance_Review__c(case__c=currentQAID,Review_Date__c=date.Today());
        allQAs = new List<Quality_Assurance_Review__c>();
        existingResp = new List<Quality_Assurance_Review__c>();
    	selectedResp = new Quality_Assurance_Response__c();
        scoremap = new Map<string,decimal>();
    	zeroedQs = new Map<string,decimal>();
        respMap = new Map<String,Quality_Assurance_Response__c>();
    	catMap = new Map<String, List<Quality_Assurance_Response__c>>();

        c = [select id,
        			ownerid,
        			owner.name,
        			createdDate,
        			casenumber,
                    origin,
                    initial_case_closer__c,
        			Call_id__c
        			from Case
        			where ID = : currentQAID];

        Set<String> tempSet = Utils.findUserPermissions(UserInfo.getUserId());

        if(!tempSet.isEmpty() && tempSet.contains(Label.QACasesController_AdminPermissionString))
        	isAdmin = true;

        system.debug('ARE WE AN ADMIN ' + isAdmin);

        existingResp = [select id,
								 score__c,
								 agent__c,
								 case__c,
								 total_points_earned__c,
								 total_points_available__c,
								 (select
								 id,
								 response__c,
	                             category__c,
	                             sub_category__c,
	                             definition__c,
	                             maximum_score__c,
	                             score__c,
                                 comments__c
	                             from Quality_Assurance_Responses__r
                                 ORDER BY Category__c)
								 from Quality_Assurance_Review__c
								 where Case__c = : c.id];


    	if(!existingResp.isEmpty()){
        	system.debug('ARE WE EXISTING ' + isExisting);
    		isExisting = true;
    		setSelectedType();
    	}
    	else if(!isAdmin){
    		system.debug('DO WE THROW THE ADMIN ERROR - Line 86');
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.QACasesController_NonAdminCreateError));
            return;
    	}

    }

    public List<SelectOption> getQATypes(){
	    Schema.DescribeFieldResult fieldResult = Quality_Assurance_Review__c.QA_Type__c.getDescribe();
        List<SelectOption> qaTyps = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        qaTyps.add(new SelectOption('Select...', 'Select...'));
        for( Schema.PicklistEntry f : ple)
        {
              qaTyps.add(new SelectOption(f.getValue(), f.getValue()));
        }       

       return qaTyps;
    }

    public void setSelectedType(){
    	respList = new List<Quality_Assurance_Response__c>();

        if(qaNew.Agent__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select an Agent to QA before selecting QA Type.'));
            return;
        }
        else{
            string orig = qaNew.QA_Type__c != 'Select...' ? qaNew.QA_Type__c : 'Phone';

            system.debug('ORIGIN IS ' + orig);

            //TODO - REPLACE WITH NEW FIELD??
            nps = Utils.getNPSScore(qaNew.Agent__c, orig, date.valueOf(c.createdDate));
            
            npsScore = 0;

            if(nps >= 75)
                npsScore = 12;
            else if(nps >= 65)
                npsScore = 9;
            else if (nps >=55)
                npsScore = 6;
            else if (nps >=45)
                npsScore = 3;
            else
                npsScore = 0;

            if(!isExisting && isAdmin){					
            	system.debug('WHAT TYPE OF REVIEW IS THIS ' + qaNew.QA_Type__c);

    	        for(Quality_Assurance_Category__c cats : [select id,
    	                                                         category__c,
    	                                                         sub_category__c,
    	                                                         definition__c,
    	                                                         maximum_score__c,
                                                                 score_logic__c
    	                                                         from Quality_Assurance_Category__c
    	                                                         where Active__c = true
    	                                                         AND Type__c = : qaNew.QA_Type__c
                                                                 ORDER BY Category__c DESC]){
    	            Quality_Assurance_Response__c resp = new Quality_Assurance_Response__c();
    	            resp.category__c = cats.category__c;
    	            resp.sub_category__c = cats.sub_category__c;
    	            resp.definition__c = cats.definition__c;
                    resp.maximum_score__c = cats.maximum_score__c;
    	            resp.score_logic__c = cats.score_logic__c;

                    if(cats.Category__c == 'NPS'){
                        score += npsScore;
                        total += cats.maximum_score__c;
                    }

    	            resp.quality_Assurance_Category__c = cats.id;
    	            respList.add(resp);
    	            respMap.put(resp.sub_category__c, resp);

                    if(catMap.isEmpty() || !catMap.containsKey(resp.category__c))
                        catMap.put(resp.category__c, new List<Quality_Assurance_Response__c>{resp});
                    else if(catMap.containsKey(resp.category__c))
                        catMap.get(resp.category__c).add(resp);

                    system.debug('SCORE IS ' + score);
                    system.debug('TOTAL IS ' + total);

                    system.debug('CAT MAP IS ' + catMap);
    	        }
    	    }
    	    else if(!isExisting && !isAdmin){
            	system.debug('DO WE THROW THE ADMIN ERROR - Line 125');
    	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.QACasesController_NonAdminCreateError));
                return;
    	    }
    	    else{
    	    	qaNew = existingResp[0].clone(true);
    	    	for(Quality_Assurance_Response__c exResp : existingResp[0].Quality_Assurance_Responses__r){
    	    		respList.add(exResp);
    	    		respMap.put(exResp.sub_category__c, exResp);
    	    		scoremap.put(exResp.sub_category__c, exResp.Score__c);
    	    	}
    	    	score = qaNew.total_points_earned__c;
    	    	total = qaNew.total_points_available__c;
    	    }
        }

        system.debug('RESP MAP IS ' + respMap);
    }

    public void updateScore (){

    	string subC = ApexPages.currentPage().getParameters().get('subCat');

    	system.debug('SUB CAT PARAM IS ' + subC);

    	selectedResp = respMap.get(subC);

    	system.debug('SELECTED RESPONSE IS ' + selectedResp);

    	if(selectedResp.Category__c != 'NPS' && !scoremap.isEmpty() && scoremap.containsKey(selectedResp.sub_category__c)){
            if(selectedResp.score_logic__c == 'All Categories'){
                score = 0;
            }
            else if(selectedResp.score_logic__c == 'Category'){
                decimal tempNeg = 0;

                for(Quality_Assurance_Response__c qr : catMap.get(selectedResp.Category__c)){
                    tempNeg = tempNeg + qr.Maximum_Score__c;
                    zeroedQs.put(qr.Sub_Category__c, qr.Maximum_Score__c);
                }

                score = score - tempNeg;
            }
            else{
                score = score - scoreMap.get(selectedResp.sub_category__c);
                total = total - selectedResp.maximum_score__c;
            }
    	}
    	else if(selectedResp.Category__c != 'NPS' && (scoreMap.isEmpty() || !scoremap.containsKey(selectedResp.sub_category__c))){
            boolean zeroed = allzero || (!zeroedQs.isEmpty() && zeroedQs.containsKey(selectedResp.sub_category__c));

            decimal newResponse = !zeroed && (selectedResp.Response__c == 'Yes' || selectedResp.Response__c == 'N/A') ? selectedResp.maximum_score__c : 0;
            
            if(newResponse == 0 && !zeroed){
                 if(selectedResp.score_logic__c == 'All Categories'){
                    score = 0;
                    allzero = true;
                }
                else if(selectedResp.score_logic__c == 'Category'){
                    for(Quality_Assurance_Response__c qr : catMap.get(selectedResp.Category__c)){
                        zeroedQs.put(qr.Sub_Category__c, qr.Maximum_Score__c);
                    }
                }
            }
            
            score += newResponse;
            total += selectedResp.maximum_score__c;
           
            system.debug('SCORE AND TOTAL: ' + score + ' - ' + total);

            scoremap.put(selectedResp.sub_category__c, newResponse);
        }
    }

    public PageReference saveQA()
    {       
        try{
        	if(qaNew.Agent__c == null){
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Agent Name Cannot be Blank!'));
            	return null;
        	}

        	for(Quality_Assurance_Response__c qar : respList){
        		if((qar.Response__c == null || qar.Response__c == '') && qar.category__c != 'NPS'){
        			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'You must address all categories before submitting your review!'));
            		return null;
        		}
        		
                boolean zeroed = allzero || (!zeroedQs.isEmpty() && zeroedQs.containsKey(qar.sub_category__c));

                decimal newResponse = 0;

                if(!zeroed && (qar.Response__c == 'Yes' || qar.Response__c == 'N/A') && qar.Category__c != 'NPS')
                    newResponse = qar.Maximum_Score__c;
                else if(!zeroed && qar.Category__c == 'NPS')
                    newResponse = npsScore;

                qar.Score__c = newResponse;
                
        	}

        	upsert qaNew;

        	for(Quality_Assurance_Response__c qar : respList){
        		qar.Quality_Assurance_Review__c = qaNew.id;
        	}
    		
    		upsert respList;

    		system.debug('RESPLIST IS ' + resplist);
        	isSuccess = true;
			
			PageReference pg = new PageReference('/'+currentQAID);
			pg.setRedirect(true);
			return pg;

        }
        catch(exception ex){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return null;
        }
    }
}