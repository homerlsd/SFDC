public class CSR_EditCaseController {
	
	public case c {get;set;}
	public Contact con {get;set;}

	public boolean showError {get;set;}
	public boolean showInfo {get;set;}
	public boolean caseClose {get;set;}
	public boolean needCon {get;set;}

    public String caseid {get; set;}

    public String toSelect {get; set;}
    public String toCreate {get; set;}

    public String dateExperiencedString {get;set;}

	public string errorMessage {get;set;}
	public string infoMessage {get;set;}
	
	public pageReference pg {get;set;}

	public List<Schema.FieldSetMember> getContactFields() {
        return SObjectType.Contact.FieldSets.CSR_CreateCase_ContactFields_CHOICE.getFields();
    }

    public List<Schema.FieldSetMember> getContactFields1() {
        return SObjectType.Contact.FieldSets.CSR_CreateCase_ContactFields_ENGAGE.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields() {
        return SObjectType.Case.FieldSets.CSR_CreateCase_Case_Detail_CHOICE.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields4() {
        return SObjectType.Case.FieldSets.CSR_CreateCase_Case_Detail_ENGAGE.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields1() {
        return SObjectType.Case.FieldSets.CSRCaseInformation.getFields();
    }

     public List<Schema.FieldSetMember> getCaseFields2() {
        return SObjectType.Case.FieldSets.CSRCaseCloseInformation.getFields();
    }

	public CSR_EditCaseController() {
		//bools
		showError = false;
		showInfo = false;
		caseClose = false;
		needCon = false;

		//strings
		errorMessage = '';
		infoMessage = '';
		dateExperiencedString = '';

		caseid = ApexPages.currentPage().getParameters().get('id');
		queryCase();
		
		if(c != null){	
			if(c.contactid != null){
				queryContact();

				if(con != null){
					if(con.Date_of_Birth__c != null){
						datetime dt = Datetime.newInstance(con.Date_of_Birth__c.year(), con.Date_of_Birth__c.month(),con.Date_of_Birth__c.day());
						dateExperiencedString = dt.format('MM/dd/YYYY');
					}
				}
				else{
					errorMessage = 'Error Querying Contact: Could not access associated contact - Please contact your administrator: ' + label.SFDC_CSR_ADMIN_INFO;
					showerror = true;
					return;
				}
			}
			else{
				needCon = true;
				con = new Contact();
			}
	    }
		else{
			errorMessage = 'Error Querying Case: No Case Found - Please contact your administrator: ' + label.SFDC_CSR_ADMIN_INFO;
			showerror = true;
			return;
		}
		
	}

	public void queryCase(){
		List<string> caseStandardFieldList = new List<string>{'casenumber','contactid'};
		string queryString = '';

		for(Schema.FieldSetMember fsm: this.getCaseFields()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields1()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields2()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields4()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

		// Add to set to de-dup field listing
        Set<string> fieldSet = new Set<string>();
        for(string s: caseStandardFieldList){
            fieldSet.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList = new List<string>(fieldSet);
        for (Integer i=0; i<fieldList.size(); i++) {
            if(i == 0) {
                    queryString = 'select ' + fieldList[i];
            } else {
                    queryString += ', ' + fieldList[i];
            }
        }
        
        queryString += ',(select id, textbody,fromname,status from EmailMessages)';
        queryString += ' ,Channel__r.name from Case where id = \'' + caseid +'\'';
        
        c = Database.query(queryString);

        system.debug('CASE IS ' + c);
	}

	public void queryContact(){
		List<string> contactStandardFieldList = new List<string>{'lastname','Date_of_Birth__c','firstname', 'salutation', 'name', 'Partner__c'};
		string queryString = '';

		for(Schema.FieldSetMember fsm: this.getContactFields()){
            contactStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getContactFields1()){
            contactStandardFieldList.add(fsm.getfieldPath());
        }

		// Add to set to de-dup field listing
        Set<string> fieldSet = new Set<string>();
        for(string s: contactStandardFieldList){
            fieldSet.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList = new List<string>(fieldSet);
        for (Integer i=0; i<fieldList.size(); i++) {
            if(i == 0) {
                    queryString = 'select ' + fieldList[i];
            } else {
                    queryString += ', ' + fieldList[i];
            }
        }

        queryString += ' ,(select id,status,subject,createddate from cases ORDER BY createddate DESC LIMIT 5)';
        queryString += ' from Contact where id = \'' + c.contactid +'\'';
        
        con = Database.query(queryString);

        system.debug('con is ' + con);	
	}

	public void clearError(){
		showError = false;
		errorMessage = '';
	}

	public void clearinfo(){
		showinfo = false;
		infoMessage = '';
	}

	public pageReference saveAnd(){		
		
		boolean continuing = false;

		if(needCon){
			c.contactid = createContact();
			continuing = true;
		}
		else
			continuing = updateContact();

		system.debug('ARE WE ALLOWED TO CONTINUE? '+ continuing);

		if(continuing){
			try{
				update c;		
				pg = new PageReference('/'+c.id);
				pg.setRedirect(true);
				return pg;
			}
			catch(exception ex){
				showError = true;
				errorMessage = 'Error Creating Case: ' + ex.getMessage();
				return null;
			}
		}
		else{
			showError = true;
			return null;
		}
	}

	public id createContact(){

		system.debug('CONTACT PHONE IS ' + con.phone);
		system.debug('CONTACT NAME IS ' + con.lastname);
		system.debug('CONTACT NAME IS ' + con.firstname);
		system.debug('CONTACT NAME IS ' + con.name);

		try{
			try{
				if(dateExperiencedString != null && dateExperiencedString != '')
                	con.Date_of_Birth__c = Date.parse(dateExperiencedString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date Experienced - Invalid Date format.'));
                return null;
            }
			
			if(con.accountid == null)
				con.accountid = Utils.getNextAccountID();

			insert con;
			return con.id;
		}
		catch(exception ex){
			showError = true;
			errorMessage = 'Error Creating Contact: ' + ex.getMessage();
			return null;
		}
	}

	public boolean updateContact(){
		try{
			
			try{
				if(dateExperiencedString != null && dateExperiencedString != '')
                	con.Date_of_Birth__c = Date.parse(dateExperiencedString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date Experienced - Invalid Date format.'));
                return null;
            }

			update con;
			return true;
		}
		catch(exception ex){
			errorMessage = 'Error Creating Contact: ' + ex.getMessage();
			return false;
		}
	}

	public void sendEmail(){
		pageReference pg = new PageReference('/');
	}

	public void closeCase(){
		c.status = label.csr_createcase_closed;
		caseClose = true;
	}

	public void needInfo(){
		c.status = Label.csr_createcase_pendingtier2;
		caseClose = true;
		//saveAnd();
	}

	public void transferToOptum(){
		c.status = Label.csr_create_case_transferredtooptum;
		saveAnd();
	}
}