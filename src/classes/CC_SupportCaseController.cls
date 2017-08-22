public without sharing class CC_SupportCaseController {
    
    public Case NewCase {get;set;}
    public String CaseSubmittedMessage {get;set;}
    public String DateOfBirthString {get;set;}
    public String DateExperiencedString {get;set;}
    public String pageDomain {get;set;}
    public id chanID {get;set;}
    public Knowledge_Group__c kgroup {get;set;}
    public string chanName {get;set;}
    public string rtypeid {get;set;}
    public string bType {get;set;}

    public String groupName {get;set;}
    public Attachment att {
        get;set;
    }
	public CC_SupportCaseController() {
	    NewCase = new Case();
	    att = new Attachment();
        pageDomain = '';
        bType = '';

        groupName = ApexPages.currentPage().getParameters().get('DataCategoryGroupName');
	    String thankyou = ApexPages.CurrentPage().getparameters().get('thankyou');
	    
        system.debug('GROUP NAME ON CASE PAGE LOAD ' + groupName);

        if(thankyou != null && thankyou=='true'){
	        CaseSubmittedMessage=Label.CC_Case_Submitted_Message;
	    }
        else{

            if(String.isEmpty(groupName)){
                groupName= CC_Util.getGroupName('','','','');
            }

            kgroup = CC_Util.GetGroupInfo(groupName);

            chanName = (kgroup.Channel__r.Name != null ? kgroup.Channel__r.Name : CC_Constants.DEFAULT_CHANNEL_NAME);
            chanID = (kgroup.Channel__c != null ? kgroup.Channel__c : CC_Constants.DEFAULT_CHANNEL_ID);
            rtypeid = (kgroup.Channel__r.Case_Record_Type_ID__c != null ? kgroup.Channel__r.Case_Record_Type_ID__c : CC_Constants.DEFAULT_CASE_RECORDTYPE_ID);

            system.debug('CHAN NAME IS ' + chanName);
            system.debug('CHAN ID IS ' + chanid);
            system.debug('RTYPE ID IS ' + rtypeid);
        }

	}
	
	/**
	 *  Picklist values
	 */
	public List<SelectOption> getTopicValues(){
        List<SelectOption> lisValues = new List<SelectOption>();
        lisValues.add(new SelectOption('', '--Select One--'));
        lisValues.add(new SelectOption('Problem', 'Report an issue or bug'));
        lisValues.add(new SelectOption('Question', 'Provide Feedback/Ask a Question'));
       return lisValues;

    }

	public List<SelectOption> getIssueBugValues(){
	     Schema.DescribeFieldResult fieldResult = Case.Issue_Bug__c.getDescribe();
        List<SelectOption> lisValues = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        lisValues.add(new SelectOption('', '--Select One--'));
        for( Schema.PicklistEntry f : ple)
        {
              lisValues.add(new SelectOption(f.getValue(), f.getValue()));
        }       

       return lisValues;

    }
    //error message
    public String FirstNameRequired{get;set;}
    public String LastNameRequired{get;set;}
    public String DateOfBirthRequired{get;set;}
    public String EmailRequired{get;set;}
    public String CompanyRequired{get;set;}
    public String SubjectRequired{get;set;}
    public String MessageRequired{get;set;}
    public String TopicRequired{get;set;}
    public String IssueBugRequired{get;set;}
    public String DateExperiencedRequired{get;set;}

    // reCAPTCHA
    public String reCAPTCHAMessage {get;set;}
    public String publicKey {
        get{
            string tempString = ApexPages.currentPage().getHeaders().get('Host');
            if(tempString.contains('force')){
                return CC_reCAPTCHAUtil.publicKey_force;
            }
            else{
                return CC_reCAPTCHAUtil.publicKey;
            }
        }
    }

    public void clear(){
            FirstNameRequired = null;
            LastNameRequired = null;
            DateOfBirthRequired =null;
            EmailRequired = null;
            CompanyRequired = null;
            SubjectRequired=null;
            MessageRequired=null;   
            TopicRequired=null;
            IssueBugRequired=null;
            DateExperiencedRequired=null;
            reCAPTCHAMessage = null;
    }
	/**
	 * Action
	 */
	

    public PageReference NavigatesToHome (){
        return new PageReference('/?DataCategoryGroupName='+groupName );
    }
    
    
    public void Rerender(){
        	clear();
    }        
    public PageReference CreateCase(){
        
        if(!CC_reCAPTCHAUtil.verify() ){
            reCAPTCHAMessage = 'The system thinks this is spam. Fill out the captcha below and try again.';
           return null;
        }
        
        system.debug('BROWSER TYPE IS ' + bType);

        NewCase.Browser_Type__c = bType;
        
        if(!String.isEmpty(DateOfBirthString)){
            try{
                NewCase.Date_Of_Birth__c = Date.parse(DateOfBirthString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date of Birth - Invalid Date format.'));
                return null;
            }
        }
        
        
        if(!String.isEmpty(DateExperiencedString)){
            try{
                NewCase.Date_Experienced__c = Date.parse(DateExperiencedString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date Experienced - Invalid Date format.'));
                return null;
            }
        }

        boolean newCon = true;

        List<Contact> cons = [select id, email from contact where email = :NewCase.Email__c ORDER BY CreatedDate DESC];

        string conid = '';

        if(!cons.isEmpty()){
            conid = cons[0].id;
            newCon = false;
        }

        // insert a record
        try{ 
            if(conid == ''){
                Contact cont = new Contact(LastName=NewCase.Last_Name__c, FirstName =NewCase.First_Name__c, Email=NewCase.Email__c, phone = NewCase.phone__c);
                
                if(kgroup != null){
                    cont.Affiliation__c = kgroup.Affiliation__c;
                }

                if(!String.isEmpty(DateOfBirthString)){
                    try{
                        cont.Date_of_Birth__c = Date.parse(DateOfBirthString);
                        
                    }catch (Exception pe){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date Experienced - Invalid Date format.'));
                        return null;
                    }
                }

                if(NewCase.Company__c != null && NewCase.Company__c != ''){
                    List<Account> accCheck = [select id from account where name = : NewCase.Company__c ORDER BY CreatedDate DESC LIMIT 1];
                    if(!accCheck.isEmpty()){
                        cont.AccountId = accCheck[0].id;
                    }
                    else{
                        cont.AccountId = Utils.getNextAccountID();
                    }
                }
                else{
                    cont.AccountId = Utils.getNextAccountID();
                }

                insert cont; 
                conid = cont.id;
            }
            
            NewCase.ContactId=conId;
            NewCase.Origin='Web';
            NewCase.Sub_Origin__c='Consumer Site';
            NewCase.Channel__c = chanID;
            NewCase.Recordtypeid = rtypeid;
            NewCase.First_Time_Contact__c = newCon;

            if(kgroup != null){
                newcase.Affiliation__c = kgroup.Affiliation__c;
                
                if(kgroup.Partner_lookup__c != null && (kgroup.Partner_lookup__r.Name != Label.Default_Partner_Name))
                    NewCase.Partner_Lookup__c = kgroup.Partner_lookup__c;
            }

            insert NewCase; 
            system.debug('#### Case created');
            
            
        }catch(DMLException de){
            List<Utils.ApexError> aes = new List<Utils.ApexError>();
            Utils.ApexError ae = new Utils.ApexError();

            String errString = '';
            
            for (Integer i = 0; i < de.getNumDml(); i++) {
                errString += de.getDmlMessage(i)+'\n';
            }

            if(conid != null)
                ae.recordID = conid; 
            ae.pageOrProcess = 'CC SUPPORT CASE - CreateCase() method';
            ae.userId = UserInfo.getUserId();  
            ae.errorString = errString;
            ae.timeStamp = date.today();
            aes.add(ae);

            Utils.addSingleErrorLog(aes);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''));
            return null;

        }
         //insert an attachment 
        att.OwnerId = UserInfo.getUserId();
        att.ParentId = NewCase.Id; 

        if(att.body != null && att.ParentId != null){
            try {
               // if(!Test.isRunningTest()) {
                 insert att;
              //}
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'error uploading attachment'));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,de.getMessage()));
                return null;
            } finally {
                att = new Attachment();
            }
        }
        
        NewCase = new Case();
        clear();
        
        // rerender is not working well with apex:inputFile 
        // so i will pass thank you message to this page. 
        system.debug('#### Case Ends');
        return  new PageReference('/CC_SupportCase?thankyou=true&DataCategoryGroupName='+groupName);
    }
}