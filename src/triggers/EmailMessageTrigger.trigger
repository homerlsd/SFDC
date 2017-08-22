trigger EmailMessageTrigger on EmailMessage (after insert) {
	Set<ID> caseIds = new Set<Id>();
    Map<ID, EmailMessage> ToAddressMap = new Map<id, EmailMessage>();
    Map<id, string> bodyMap = new Map<id, string>();
    Map<id, string> filterMap = new Map<id, string>();
    Map<id, string> stringMap = new Map<id, string>();
    Map<id, string> subjectMap = new Map<id, string>();

    String matchString = Label.EmailMessageTrigger_CorporateEmailString;

    Set<String> checkEmails = Utils.getFilteredToAddresses();
    Map<String,String> checkTerms = Utils.getFilteredTerms();
    Set<String> checkSubjTerms = Utils.getFilteredSubjectTerms();

    for (EmailMessage e : trigger.new) {

    	if(e.parentID != null){
	    	boolean filterNeeded = true;

	        if (e.incoming == true) {
				ToAddressMap.put(e.ParentId, e);    
		    	caseIds.add(e.ParentId);

		    	if(e.htmlBody != null && e.htmlBody.contains(matchString)){
		    		bodyMap.put(e.parentID, e.htmlBody);
	    		}
	    		
	    		system.debug('TO ADDRESS IS ' + e.toaddress);
	    		system.debug('TEXT BODY IS ' + e.textbody);
	    		system.debug('HTML BODY IS ' + e.htmlbody);

	    		if((e.htmlBody != null || e.textBody != null) && checkEmails.contains(e.toAddress)){
			    	system.debug('DO WE GET IN THE FILTERED TO ADDRESS ' + e.toAddress);

			    	for(string sub : checkSubjTerms){
			    		if(filterNeeded && e.subject != null && e.subject.containsIgnoreCase(sub)){
			    			subjectMap.put(e.parentID, sub);
			    			//break;
			    		}
			    		if((e.htmlBody != null && e.htmlBody.containsIgnoreCase(sub)) ||
	    					(e.textBody != null && e.textBody.containsIgnoreCase(sub))){
			    			subjectMap.put(e.parentID, sub);
			    		}
			    	}
	    			//if we get here we need to check the body for certain terms and route appropriately.
	    			//if(filterNeeded){
	    			for(string s : checkTerms.keySet()){
	    				
	    				system.debug('CHECK TERM IS ' + s);
	    				
	    				if((e.htmlBody != null && e.htmlBody.containsIgnoreCase(s)) ||
	    					(e.textBody != null && e.textBody.containsIgnoreCase(s))){
		    					system.debug('CHECK TERM FOUND - ROUTING ID IS: ' + checkTerms.get(s));
		    					filterMap.put(e.parentID, checkTerms.get(s));
		    					stringMap.put(e.parentID, s);
	    				}
	    			}
		    		//}
	    		}
		    }
		}
    }

    if(!caseIds.isEmpty()){
       
	    List<case> cases = new List<case>();
	    Set<id> caseSet = new Set<id>();
	    
	    for (Case c : [select Id,description,origin,Sub_origin__c, Last_Inbound_Message_Date__c, To_Address__c from Case where Id in :CaseIds]) {
	    	
	    	if((c.To_Address__c == null || c.To_Address__c == '') && c.Origin == 'Email'){
	        	c.To_Address__c = ToAddressMap.get(c.id).toAddress;
	        	cases.add(c);
	        	caseSet.add(c.id);

		        if(!bodyMap.isEmpty() && bodyMap.containsKey(c.id)){
		    		c.Origin = 'Web';
		    		c.Sub_Origin__c = 'Corporate Site';
		    	}

		    	if(!subjectMap.isEmpty() && subjectMap.containsKey(c.id)){
		    		c.recordTypeID = Label.NoreplyCase_RecordTypeID;
		    		c.Filtered_Subject_Term__c = subjectMap.get(c.id).length() > 200 ? subjectMap.get(c.id).substring(0,200) : subjectMap.get(c.id);
		    	}
		    	if((subjectMap.isEmpty() || !subjectMap.containsKey(c.id)) 
		    		&& !filterMap.isEmpty() && filterMap.containsKey(c.id)){
			    		system.debug('DO WE GET IN THE FILTERED CASE - SETTING OWNER ');
			    		c.OwnerId = filterMap.get(c.id);
			    		c.RecordTypeID = Label.CC_Default_CASE_RECORDTYPE_ID;
			    		c.Sub_Origin__c = 'No Reply Address';
			    		c.Filtered_Email_Term__c = stringMap.get(c.id);
		    	}
	    	}

        	/*if(c.Last_Inbound_Message_Date__c == null && toAddressMap.get(c.id).incoming){
        		c.Last_Inbound_Message_Date__c = datetime.now();
        		if(caseSet.isEmpty() || (!caseSet.isEmpty() && !caseSet.contains(c.id))){
	        		cases.add(c);
	        		caseSet.add(c.id);
	        	}
        	}
        	else if(!toAddressMap.get(c.id).incoming){
        		c.last_inbound_message_date__c = null;
        		if(caseSet.isEmpty() || (!caseSet.isEmpty() && !caseSet.contains(c.id))){
		        	cases.add(c);
		        	caseSet.add(c.id);
		        }
        	}*/
	    }

	    system.debug('Cases are ' + cases);
	   
	    update cases;
	}
}