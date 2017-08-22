public without sharing class CC_ClientCaseController {
    
    public Case NewCase {get;set;}
    public String CaseSubmittedMessage {get;set;}
    public String EnrollStartString {get;set;}
    public String EnrollEndString {get;set;}
    public String EffectiveDateString {get;set;}
    public String pageDomain {get;set;}
    public id chanID {get;set;}
    public Knowledge_Group__c kgroup {get;set;}
    public string chanName {get;set;}
    public string rtypeid {get;set;}
    public string bType {get;set;}
    public string selectedClient {get;set;}

    public List<Attachment> attList {get;set;}
    public List<Attachment> newAtts {get;set;}

    public Map<string, Account> clientMap {get;set;}
    public Set<String> clientNames   {get;set;}

    private String groupName {get;set;}
   
	public CC_ClientCaseController() {
        pageDomain = '';
        bType = '';
        selectedClient = '';
        attList = new List<Attachment>();
        clientNames = new Set<String>();
        clientMap = new Map<String, Account>();

        for(Integer i=1; i <= 5; i++){
        	attList.add(new attachment());
        }

	    String thankyou = ApexPages.CurrentPage().getparameters().get('thankyou');
	    
	    system.debug('THANK YOU IS ' + thankyou);

        if(thankyou != null && thankyou=='true'){
	        CaseSubmittedMessage=Label.CC_ClientCase_Submitted_Message;
	    }
        else{

        	groupName = CC_Util.getGroupName('','','','Choice');

            sales_channel__c chan = [select id from sales_channel__c where NAME = : 'Choice'];

            system.debug('RTYPE ID IS ' + rtypeid);

	   		NewCase = new Case(Recordtypeid = label.Test_ParentCaseSearch_ClientSupportID, Channel__c = chan.id);

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
        return new PageReference('/client/');
    }
    
    
    public void Rerender(){
        	clear();
    }        
    public PageReference CreateCase(){
        
        if(!String.isEmpty(EnrollStartString)){
            try{
                NewCase.Open_Enrollment_Start_Date__c = Date.parse(EnrollStartString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Enrollment Start Date - Invalid Date format.'));
                return null;
            }
        }

        if(!String.isEmpty(EnrollEndString)){
            try{
                NewCase.Open_Enrollment_End_Date__c = Date.parse(EnrollEndString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Enrollment End Date - Invalid Date format.'));
                return null;
            }
        }
        
        
        if(!String.isEmpty(EffectiveDateString)){
            try{
                NewCase.Effective_Date__c = Date.parse(EffectiveDateString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Effective Date - Invalid Date format.'));
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
            string aId = '';
            
            List<Account> Clients = [select id, name from Account where Name = : selectedClient];

            if(conid == ''){
                Contact cont = new Contact(LastName=NewCase.Last_Name__c, FirstName =NewCase.First_Name__c, Email=NewCase.Email__c, phone = NewCase.phone__c);

                if(!clients.isEmpty()){
                    aId = clients[0].id;
                    cont.AccountId = aId; 
                }
                else{
                    aId = createAcct();
                    cont.AccountId = aId;
                }

                insert cont; 
                conid = cont.id;
            }
            else{
                if(!clients.isEmpty()){
                    aId = clients[0].id;
                }
                else{
                    aId = createAcct();
                }
            }
            
            NewCase.AccountID = aId;
            NewCase.ContactId=conId;
            NewCase.Origin='Web';
            NewCase.Sub_Origin__c='UHC Client Form';
            NewCase.First_Time_Contact__c = newCon;
            NewCase.Partner__c = Label.CC_ClientCaseController_OptumPartnerID;

            string attchName = '';
            Integer index = 0;

            for(attachment att : attList){
                index++;
                if(att.body != null && att.name != null && att.name != ''){
                    attchName += 'Attachment ' + index + ': ' + att.name + '\n';
                }
            }

            if(attchName != '')
                newcase.Attachments__c = attchName;
                
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
            ae.pageOrProcess = 'CC CLIENT CASE - CreateCase() method';
            ae.userId = UserInfo.getUserId();  
            ae.errorString = errString;
            ae.timeStamp = date.today();
            aes.add(ae);

            Utils.addSingleErrorLog(aes);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''));
            return null;

        }
    
        newAtts = new List<Attachment>();
         
        for(attachment att : attList){
	        if(att.body != null && att.name != null && att.name != ''){
	        	system.debug('ATTACHMENT NAME IS ' + att.name);
	        	att.OwnerId = UserInfo.getUserId();
	        	att.ParentId = NewCase.Id; 

	        	newAtts.add(att);
	        }
	    }

	    if(!newAtts.isEmpty()){
            try {
                if(!Test.isRunningTest()) {
                	insert newAtts;
                }
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment(s)'));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,de.getMessage()));
                return null;
            } 
	    }
        
        NewCase = new Case();
        clear();
        
        // rerender is not working well with apex:inputFile 
        // so i will pass thank you message to this page. 
        system.debug('#### Case Ends');
        return  new PageReference('/CC_ClientCase?thankyou=true&DataCategoryGroupName='+groupName);
    }

    public id createAcct(){
        try{
            Account a = new Account(name = selectedClient, ParentId = label.CC_Client_Case_Optum_Default_Account_ID,Partner__c = Label.CC_ClientCaseController_OptumPartnerID);
            insert a;
            return a.id;
        }
        catch (Exception pe){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating record.  Please contact Rally with following detials: ' + pe.getMessage()));
            return null;
        }
    }
}