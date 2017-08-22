public class CustomSurveyEntryController {
    
    public string impID                                                     {get;set;}
    public string surveyid                                                  {get;set;}
    public string fielddescription                                          {get;set;}
    public string header                                                    {get;set;}
    public string pageTitle                                                 {get;set;}
    
    public boolean showSuccess                                              {get;set;}

    public Custom_Survey_Requirement__c survey                              {get;set;}
    public List<question> questions               					        {get;set;}
    public List<question_cust> questions_custom               					{get;set;}
    public List<Custom_Survey_Question__c> newQuestions               		{get;set;}

    public List<Schema.FieldSetMember> objFields                            {get;set;}
    public List<Schema.FieldSetMember> QuestionFields_Clientdefined         {get;set;}
    public List<Schema.FieldSetMember> QuestionFields_Catalog 		        {get;set;}

    public Map<id, id> affilMap                                             {get;set;}
    public Map<string, string> descriptionMap                               {get;set;}
    public Map<string, string> headermap                                    {get;set;}
    public Map<string, Integer> lengthMap                                   {get;set;}

    public Attachment att                                                   {get;set;}
    public Milestone1_Project__c imp                                        {get;set;}

    public List<String> objectfieldNames                                    {get;set;}
    public List<String> childfieldNames                                     {get;set;}

    public integer fieldCount                                               {get;set;}

    public CustomSurveyEntryController() {
        impID = Apexpages.currentPage().getParameters().get('impID');
        surveyid = Apexpages.currentPage().getParameters().get('surveyid');

        List<Milestone1_Project__c> imps = [select id, Initial_Approval_Date__c from Milestone1_Project__c where ID =: impid];

        if(!imps.isEmpty()){
            imp = imps[0];
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'The implementation ID you are using is no longer valid please contact Salesforce Administration with any issues.'));
            return;
        }

        showSuccess = false;

        fielddescription = '';
        header = '';

        //att = new Attachment();
        objectfieldNames = new List<String>();
        childfieldNames = new List<String>();
        
		newQuestions = new List<Custom_Survey_Question__c>();
        affilMap = new Map<id,id>();
        lengthMap = new Map<string,integer>();
        descriptionMap = new Map<String, String>();
        headerMap = new Map<String, String>();


        pageTitle = 'Rally Custom Survey Order Form';
        header = Label.CustomSuveyEntry_Header;

        findObjfields();
        findQuestionFields();

        survey = new Custom_Survey_Requirement__c(Implementation__c=impID);

        if(surveyid != null && surveyid != ''){
            survey = [select id, name, Post_Approval_Change_Control__c from Custom_Survey_Requirement__c where ID =:surveyID];
        }

        questions  = new List<question>();
        questions_custom  = new List<question_cust>();
        
        findPicklistInfo();

    }

    public void findObjfields() {

        Schema.DescribeSObjectResult DescribeSObjectResultObj = Custom_Survey_Requirement__c.SObjectType.getDescribe();
        objfields = new List<Schema.FieldSetMember>();

        objfields = SObjectType.Custom_Survey_Requirement__c.FieldSets.CustomSurveyEntry_Fields.getFields();

        system.debug(LoggingLevel.Info,'OBJECT FIELDS ' + objfields);

        for(Schema.FieldSetMember fsm : objfields){
            objectfieldNames.add(fsm.getFieldPath());
            
            system.debug(LoggingLevel.Info,'FIELD NAME IS ' + fsm.getFieldPath());
            system.debug(LoggingLevel.Info,'FIELD DESCRIBE IS ' + DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe());

            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }
        
        findFieldDescription(objectfieldNames,'Custom_Survey_Requirement__c');

    }

    public void findQuestionFields() {

        QuestionFields_Clientdefined = new List<Schema.FieldSetMember>();
        QuestionFields_Clientdefined = new List<Schema.FieldSetMember>();

        QuestionFields_Clientdefined = SObjectType.Custom_Survey_Question__c.FieldSets.ClientDefined.getFields();
        QuestionFields_Catalog = SObjectType.Custom_Survey_Question__c.FieldSets.Catalog.getFields();
        
        Schema.DescribeSObjectResult DescribeSObjectResultObj = Custom_Survey_Question__c.SObjectType.getDescribe();

        for(Schema.FieldSetMember fsm : QuestionFields_Clientdefined){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        for(Schema.FieldSetMember fsm : QuestionFields_Catalog){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        findFieldDescription(childfieldNames, 'Custom_Survey_Question__c');

    }

    public void findFieldDescription(List<string> fields, string ObjType){

        try{            
            if(descriptionMap.isEmpty())
                descriptionMap = Utils_Implementation.getFieldInfoMap(ObjType,fields);
            else
                descriptionMap = Utils_Implementation.getFieldInfoMap_existing(ObjType,fields,descriptionMap);
            
            if(headermap.isEmpty())
                headerMap = Utils_Implementation.getHeaderMap(ObjType,fields);
            else
                headermap = Utils_Implementation.getFieldHeaderMap_existing(ObjType,fields,headerMap);
      
            system.debug('DESC MAP IS ' + descriptionMap);
            system.debug('HEADER MAP IS ' + headerMap);
            system.debug('LENGTH MAP IS ' + lengthMap);
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
        }
        
    }

    public void addCustomQ(){
    	string empty = '';
        questions_custom.add( new question_cust( new Custom_Survey_Question__c(recordTypeID=Label.CustomSurveyQuestion_ClientDefinedRtypeID)));
    	system.debug('questions_custom size is ' + questions_custom);
    }

    public void removeCustomQ(){
    	integer i = questions_custom.size();
		questions_custom.remove(i-1);
        
        system.debug('questions_custom size is ' + questions_custom);
    }

    public void findPicklistInfo(){
    	Map<String, List<String>> dependencyMap = Utils_Implementation.catalogQuestions();
    	
    	for(string s : dependencyMap.keySet()){
    		List<string> tempList = dependencyMap.get(s);
    		string tempstring = 'Possible Answers: ';
    		for(string tl : tempList){

    			tempstring += tl.normalizeSpace() + '; ';
    		}
    		questions.add(new question( new Custom_Survey_Question__c(recordTypeID=Label.CustomSurveyQuestion_CatalogRtypeID), s, tempstring));
    	}

    	system.debug('QUESTIONS ARE ' + questions);
    }

    public class question{
        public Custom_Survey_Question__c quest 			{get;set;}
        public string question_string					{get;set;}
        public string answers 							{get;set;}

        public question(Custom_Survey_Question__c questp, string questionp, string answersp	){
            this.quest = questp;
            if(answers != ''){
            	this.question_string = questionp;
            	this.answers = answersp;
            }
            else{
            	this.question_string = '';
            	this.answers = '';
            }
        }
    }

    public class question_cust{
        public Custom_Survey_Question__c quest 			{get;set;}

        public question_cust(Custom_Survey_Question__c questp){
            this.quest = questp;
        }
    }

    public pageReference submitResults(){

        try{
        	integer count = 0;

        	system.debug(questions_custom);

            for(question q : questions){
            	if(q.quest.selected__c == true){
            		count++;
            		q.quest.Pre_defined_Question__c = q.question_string;
            		q.quest.Answers__c = q.answers.remove('Possible Answers: ');
            		q.quest.Answers__c = q.quest.Answers__c.replace('; ',';').replace(';', '\n');
            		system.debug('ANSWERS ARE ' + q.quest.Answers__c);

            		if(count > Integer.valueOf(label.CustomSurveyEntry_QuestionLimit)){
	            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.CustomSurveyEntry_QuestionLimitErrorMess));
	            		return null;
	            	}
	            	else{
	               		newQuestions.add(q.quest);
	            	}
            	}
            }

            for(question_cust q2 : questions_custom){
            	count++;	
            	if(count > Integer.valueOf(label.CustomSurveyEntry_QuestionLimit)){
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.CustomSurveyEntry_QuestionLimitErrorMess));
            		return null;
            	}
            	else{
            		newQuestions.add(q2.quest);
            	}
            }

            boolean needApp = false;

            if(imp.Initial_Approval_Date__c != null){
                survey.Post_Approval_Change_Control__c = Label.CustomSurveyEntryController_ChangeControlDescription;
                needApp = true;
            }

            upsert survey;

			for(Custom_Survey_Question__c nw : newQuestions){
				system.debug(nw);
				nw.Custom_Survey_Requirement__c = survey.id;
                if(needApp == true)
                    nw.Post_Approval_Change_Control__c = 'Added Survey Question';
            }

			insert newQuestions;

            string gotoID = surveyid != null && surveyid != '' ? surveyid : impID;
            
            pageReference pg = new pageReference('/'+gotoID);
            pg.setRedirect(true);
            return pg;

        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return null;
        }
    }
}