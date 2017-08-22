public class RequirementFormController2 {
	
	public string impID														{get;set;}
	public string objName 													{get;set;}
	public string fieldsetName 												{get;set;}
	public string header 		 	 										{get;set;}
	public string pageTitle 		 	 									{get;set;}
	public string rewardType 	 		 									{get;set;}
	public string entryType 	 		 									{get;set;}
	public string entryMethod 			 									{get;set;}
	public string formID 	 			 									{get;set;}
	
	public boolean hasPVRC   												{get;set;}
	public boolean hasPolicys												{get;set;}
	public boolean hasAffils												{get;set;}
	public boolean hasRtypes												{get;set;}
	public boolean showSuccess												{get;set;}

	public List<sObject> newObjects											{get;set;}

	public Rally_Requirement_FS_Mapping__mdt fs 							{get;set;}
	public List<selectOption> allAffiliations								{get;set;}
	public List<selectOption> selectedAffiliation							{get;set;}
	public List<sObject> childObjs											{get;set;}
	public List<Schema.FieldSetMember> objFields							{get;set;}
	public List<Schema.FieldSetMember> rewardFields2						{get;set;}
	public List<Schema.FieldSetMember> rewardFields3			    		{get;set;}
	public List<Schema.FieldSetMember> rewardFields4 			    		{get;set;}

	public Map<id, id> affilMap												{get;set;}
	public Map<string, string> descriptionMap								{get;set;}
	public Map<string, string> headermap									{get;set;}
	public Map<string, Integer> lengthMap									{get;set;}

	public Milestone1_Project__c[] impQuery 									{get;set;}
	public Attachment att 													{get;set;}

	public List<String> fieldNames											{get;set;}

	public RequirementFormController2() {
		impID = Apexpages.currentPage().getParameters().get('impID');
        formID = Apexpages.currentPage().getParameters().get('formID');

        showSuccess = false;
        hasAffils = false;
        hasPolicys = false;
        hasPVRC = false;
        hasRtypes = false;

        header = '';
        
        rewardType = '';
        entrytype = '';
        entryMethod = '';

        fieldNames = new List<string>();
        
        newObjects = new List<sObject>();
        selectedAffiliation = new List<SelectOption>();
        allAffiliations = new List<SelectOption>();
        affilMap = new Map<id, id>();

        objFields = new List<Schema.Fieldsetmember>();
        rewardFields2 = new List<Schema.Fieldsetmember>();
        rewardFields3 = new List<Schema.Fieldsetmember>();
        rewardFields4 = new List<Schema.Fieldsetmember>();

        fs = new Rally_Requirement_FS_Mapping__mdt();

        att = new Attachment();
        

        Rally_Requirement_FS_Mapping__mdt[] fsMap = [select id,
        													Field_Set_Name__c,
        													Max_Number_of_Records__c,
        													Min_Number_of_Records__c,
        													Record_Type_ID__c,
        													Form_ID__c,
        													Object_Label__c,
        													Object_Name__c
        													from Rally_Requirement_FS_Mapping__mdt
        													where Form_ID__c = :formID];
        
        system.debug('FIELD SET DATA IS ' + fsMap);													

        if(fsMap.isEmpty()){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RequirementForm_BadFormID));
    		return;
        }
        else{

        	impQuery = [select id, name, Channel__c, Partner__c, ownerID,Account__c from Milestone1_Project__c where ID = : impID];

        	if(impQuery.isEmpty()){
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RequirementForm_BadFormID));
    			return;
        	}
        	else{
        		fs = fsMap[0];

	      		objName = fs.Object_Name__c;
		        fieldsetName = fs.Field_Set_Name__c;

		        system.debug('FIELD SET NAME IS ' + fieldSetName);
		        pageTitle = 'Rally ';

		        if(fs.Object_Label__c != null)
		        	pageTitle += fs.Object_Label__c+' ';
		        
		        if(fs.Record_Type_ID__c != null && fs.Record_Type_ID__c != ''){
		        	recordType[] rt = [select id, name from RecordType where ID =:fs.Record_Type_ID__c];
		        	if(rt != null){
		        		pageTitle += rt[0].Name+' ';
		        	}
		        	else{
		        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RequirementForm_BadFormID));
		    			return ;
		        	}
		        } 

		        pageTitle += 'Order Form';

		        if(fieldsetName != null){

		        	string labelName = fieldsetName+'_header';

		        	system.debug('FIELD SET FINAL NAME IS ' + fieldSetName);
		        	system.debug('LABEL FINAL NAME IS ' + labelName);

		            if(!test.isRunningTest()){
		                Component.Apex.OutputText output;
		                output = new Component.Apex.OutputText();
		                output.expressions.value = '{!$Label.' + labelName + '}';
		                header = string.valueOf(output.value);
		            }
		        }
			        
		        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 

		        Schema.SObjectType sobjType = gd.get(objName); 

		        sObject newObject_in = Schema.getGlobalDescribe().get(objName).newSObject();

		        Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 

		        List<Schema.ChildRelationship> Childs = describeResult.getChildRelationships(); 

		        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();

		        Map<String, Schema.RecordTypeInfo> TypeInfoMap = describeResult.getRecordTypeInfosByName();

		        if(!TypeInfoMap.isEmpty() && TypeInfoMap.size() > 1){
		        	hasRtypes = true;
		        	if(fs.Record_Type_ID__c != null){
		        		newObject_in.put('RecordTypeID',fs.Record_Type_ID__c);
		        	}
		        }

		        newObjects.add(newObject_in);

				Set<String> childStrings = new Set<String>();
				
				for(Schema.ChildRelationship Child : childs){
				    childStrings.add(child.getRelationshipname());
				}
				
				if(!childStrings.isEmpty() && childStrings.contains('Affiliation_Joins__r')){
				    hasAffils = true;
				    for (Client_Affiliation__c seg : [select id, name from Client_Affiliation__c where Implementation__c = :impID AND Affiliation_type__c = 'Production']) {
			            allAffiliations.add(new SelectOption(seg.id,seg.name));
			        }
				}

				findObjfields();
        	}
		}
	}

	public void addRecord(){
		Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
        Schema.SObjectType sobjType = gd.get(objName); 
        sObject newObject_in = Schema.getGlobalDescribe().get(objName).newSObject();
        if(hasRtypes){
    		newObject_in.put('RecordTypeID',fs.Record_Type_ID__c);
    	}
        newObjects.add(newObject_in);
	}

	public void removeRecord(){
        integer i = newObjects.size();
        newObjects.remove(i-1);
	}

	public void findObjfields() {
        
	    Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
	    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

	    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);

	    lengthMap = new Map<string,integer>();

	    for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
	    	fieldNames.add(fsm.getFieldPath());
	    	Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
	    	lengthMap.put(fsm.getFieldPath(),TestField.getLength());
	    }
	    objFields.addAll(fieldSetObj.getFields()); 
	    findFieldDescription();

    }

    public void findFieldDescription(){

    	try{
    		string removeMe = objName+'.';
    		descriptionMap = new Map<String, String>();
    		headerMap = new Map<String, String>();

    		descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
    		headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

			system.debug('DESC MAP IS ' + descriptionMap);
			system.debug('HEADER MAP IS ' + headerMap);
			system.debug('LENGTH MAP IS ' + lengthMap);
    	}
    	catch(exception ex){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
    		return;
    	}
    	
    }

	/*public void setRewardType(){
		if(!rewardFields2.isEmpty())
    		rewardFields2.clear();
    	if(rewardFields3.isEmpty())
    		rewardFields3.clear();
		if(rewardFields4.isEmpty())
    		rewardFields4.clear();

    	rewardType=string.valueOf(newObjects[0].get('Reward_Type__c'));
    	system.debug('REWARD TYPE IS ' + rewardType);
    	String tempFieldSet = fieldSetName+'_'+rewardType.remove(' ');
    	system.debug('2nd Field set name is ' + tempFieldSet);

    	Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
	    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    	
    	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(tempFieldSet);

    	for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
	    	fieldNames.add(fsm.getFieldPath());
	    	Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
	    	lengthMap.put(fsm.getFieldPath(),TestField.getLength());
	    }

	    descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
    	headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

    	rewardFields2.addAll(fieldSetObj.getFields());
    }

    public void setEntryMethod(){

    	if(rewardFields3.isEmpty())
    		rewardFields3.clear();
		if(rewardFields4.isEmpty())
    		rewardFields4.clear();
    		
    	entryMethod=string.valueOf(newObjects[0].get('Reward_Entry_Method__c'));
    	
    	system.debug('REWARD ENTRY METHOD IS ' + entryMethod);

    	String tempFieldSet = fieldSetName+'_'+entryMethod.remove(' ');

    	system.debug('3rd FIELD SET NAME IS ' + tempFieldSet);
    	
    	if(tempFieldSet != ''){
	    	Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
		    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
		    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
	    	
	    	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(tempFieldSet);

	    	for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
		    	fieldNames.add(fsm.getFieldPath());
		    	Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
		    	lengthMap.put(fsm.getFieldPath(),TestField.getLength());
		    }

		    descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
	    	headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

	    	rewardFields3.addAll(fieldSetObj.getFields());
	    }
    }

    public void setEntryType(){
    	if(!rewardFields4.isEmpty())
    		rewardFields4.clear();

    	entryType=string.valueOf(newObjects[0].get('Reward_Entry_Type__c'));
    	string entryActivity=string.valueOf(newObjects[0].get('Reward_Entry_Activity__c'));

    	system.debug('REWARD ENTRY Type IS ' + entrytype);
    	system.debug('REWARD ENTRY Activity IS ' + entryActivity);

    	String tempFieldSet = '';

    	if(entryMethod==Label.RequirementForm_RewardEntryMethod_Coins){
    		if(entrytype != null){
    			tempFieldSet = entryMethod.remove(' ')+'_'+entryType.remove(' ');
    		}
    	}
    	else{
    		if(entryActivity != null && newObjects[0].get('Activity_Type__c') != null){
    			string activityType = string.valueOf(newObjects[0].get('Activity_Type__c'));

    			tempFieldSet = entryActivity.remove(' ')+'_'+activityType.remove(' ');
    			
    			if(tempFieldSet.length() > 40)
    				tempFieldSet = tempFieldSet.substring(0,40);
    		}
    	}

    	system.debug('3rd FIELD SET NAME IS ' + tempFieldSet);
    	
    	if(tempFieldSet != ''){
	    	Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
		    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
		    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
	    	
	    	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(tempFieldSet);

	    	for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
		    	fieldNames.add(fsm.getFieldPath());
		    	Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
		    	lengthMap.put(fsm.getFieldPath(),TestField.getLength());
		    }

		    descriptionMap = Utils_Implementation.getFieldInfoMap(objName,fieldNames);
	    	headerMap = Utils_Implementation.getHeaderMap(objName,fieldNames);

	    	rewardFields4.addAll(fieldSetObj.getFields());
	    }
    }*/

    public void submitResults(){

    	try{
    		system.debug('DO WE GET INTO SUBMIT ' + objfields);

    		for(schema.fieldsetmember fm : objfields){
    			string tempField = fm.getFieldPath();
    			if(tempField.contains('DateString__c')){
    				for(sObject newObject : newObjects){
	    				system.debug('DATE VALUE IS ' + String.valueOf(newObject.get(tempField)));
	    				string dt = String.valueOf(newObject.get(tempField));
	                    if(dt != null && dt != ''){
	        				String[] str = dt.split('/');
	        				date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
	        				string dateFieldPath = tempField.remove('String__c');
	        				dateFieldPath = dateFieldPath + '__c';
	                        try {
	                            newObject.put(dateFieldPath,dtTemp);
	                        } catch (Exception ex) {
	                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error saving record - please remove and email jon.wu@rallyhealth.com with the following message:' + ex.getMessage()));
	                            return;
	                        }
	                    }
	                }
    			}
    		}
            
            for(sObject newObject : newObjects){
            	newObject.put('Implementation__c', impID);
        	}
            try{
                insert newObjectS;
            }
            catch(exception ex){
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0) );
                ApexPages.addMessage(msg);
                return ;
            }

    		system.debug('ATTACHMENT BODY ' + att.body);

    		//insert an attachment
	        if(att.body != null){
	            att.OwnerId = impQuery[0].OwnerId;
	            att.ParentId = newObjects[0].id; 

	            try {
	               //if(!Test.isRunningTest()) {
	                 insert att;
	              //}
	            } catch (DMLException de) {
	                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment - please remove and email kate.tompkins@rallyhealth.com the client logo.'));
	                return;
	            } finally {
	                att = new Attachment();
	            }
	        }

	        if(hasAffils && !selectedAffiliation.isEmpty()){
		        childObjs = new List<sObject>();
	
	    		for ( SelectOption so : selectedAffiliation ) {
	                Sobject o = Utils_Implementation.getsObjectType('Affiliation_Join__c').newSObject();
	                o.put('Client_Affiliation__c', so.getValue());
	                o.put(ObjName, newObjects[0].id);
	                childObjs.add(o);
		        }

		        if(!childObjs.isEmpty()){
		        	insert childObjs;
		        }
		    }


	        showSuccess = true;

    	}
    	catch(exception ex){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getmessage());
            ApexPages.addMessage(msg);
    		return ;
    	}
    }
    
    public pageReference goToLink(){
        pageReference pg = Page.ClientSearch;
        pg.getParameters().put('id', impQuery[0].Partner__c);
        pg.getParameters().put('chan', impQuery[0].Channel__c);
        pg.getParameters().put('accID', impQuery[0].Account__c);
        pg.setRedirect(true);
        return pg;
    }
}