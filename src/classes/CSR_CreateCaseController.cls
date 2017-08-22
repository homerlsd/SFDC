public class CSR_CreateCaseController {
    
    public case c {get;set;}
    public Contact con {get;set;}
    public List<contact> cons {get;set;}
    public Map<id,contact> conMap {get;set;}
    public boolean showCons {get;set;}
    public boolean needCon {get;set;}
    public boolean showError {get;set;}
    public boolean showInfo {get;set;}
    public boolean step2 {get;set;}
    public boolean caseClose {get;set;}
    public boolean casePending {get;set;}

    public string transToOptum {get;set;}
    public String toSelect {get; set;}
    public String toCreate {get; set;}
    public String dnisID {get; set;}
    public String cfID {get; set;}
    public string caseID {get;set;}
    public string phoneID {get;set;}
    
    public string searchURL {get;set;}

    public String dateExperiencedString {get;set;}

    public list<list<sObject>> soslResults {get;set;}
    public list<searchResultRow> searchResults {get;set;}
    public string searchString {get;set;}

    public string errorMessage {get;set;}
    public string infoMessage {get;set;}
    
    public pageReference pg {get;set;}

    public List<Schema.FieldSetMember> getContactFields() {
        return SObjectType.Contact.FieldSets.CSRContactInformation.getFields();
    }

    public List<Schema.FieldSetMember> getContactFields1() {
        return SObjectType.Contact.FieldSets.CSR_CreateCase_ContactFields_ENGAGE.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields1() {
        return SObjectType.Case.FieldSets.CSR_EditCaseFields.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields2() {
        return SObjectType.Case.FieldSets.CSR_CreateCase_Case_Detail_ENGAGE.getFields();
    }   

    public List<Schema.FieldSetMember> getCaseFields2a() {
        return SObjectType.Case.FieldSets.CSR_CreateCase_Case_Detail_CHOICE.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields3() {
        return SObjectType.Case.FieldSets.CSRCaseCloseInformation.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields4() {
        return SObjectType.Case.FieldSets.CSRCasePendingInformation.getFields();
    }

    public void onLoad(){
        string tempID = ApexPages.currentPage().getParameters().get('cfID');
        string existing = ApexPages.currentPage().getParameters().get('existing');
        string dnisTemp = ApexPages.currentPage().getParameters().get('DNIS');

        system.debug('existing? ' + existing);

        if(existing == null || existing == ''){

            List<case> c1 = [select id from Case where Connect_First_ID__c = : tempID AND (Connect_First_ID__c != null AND Connect_First_ID__c != '')];

            if(c1.isEmpty()){
                id chanID;
                id rtypeID;
                id partnerID;

                if(dnisTemp != null && dnisTemp != ''){
                    Sales_Channel__c sc = Utils.GetChannelFromDNIS(dnisTemp);
                    if(sc == null){
                        chanID = CC_Constants.DEFAULT_CHANNEL_ID;
                        rtypeID = CC_Constants.DEFAULT_CASE_RECORDTYPE_ID;
                    }
                    else{
                        chanID = sc.id;
                        rtypeID = sc.Case_Record_Type_ID__c;
                    }

                    Partner__c p = Utils.GetPartnerFromDNIS(dnisTemp);
                    if(p != null)
                        partnerID = p.id;

                }
                else{
                    chanID = CC_Constants.DEFAULT_CHANNEL_ID;
                    rtypeID = CC_Constants.DEFAULT_CASE_RECORDTYPE_ID;
                }

                Case ca = new Case(origin='Phone', Connect_First_ID__c = tempID, Channel__c = chanID, RecordTypeID = rtypeID);
                try{
                    
                    if(partnerID != null)
                        ca.Partner_Lookup__c = partnerID;

                    upsert ca;
                    system.debug('CASE ID AFTER INSERT IS ' + ca.id);
                    caseID = ca.id;
                    init();
                }
                catch(exception ex){
                    showError = true;
                    errorMessage = ex.getMessage();
                }
            }
            else{
                init();
            }
        }
        else{
            init();
        }
    }

    public void init(){
        //bools
        showCons = false;
        showError = false;
        showInfo = false;
        needCon = false;
        step2 = false;
        caseClose = false;
        casePending = false;

        //strings
        errorMessage = '';
        infoMessage = '';
        searchString = '';
        searchURL = '';
        transToOptum = 'Transfered to Optum';
        dateExperiencedString = '';
        //objs
        c = new Case();
        cons = new List<contact>();
        conMap = new Map<Id,contact>();
        con = new Contact();
        soslResults = new List<List<sObject>>();
        searchResults = new List<searchResultRow>();


        //get the CF id for finding the case
        cfID = ApexPages.currentPage().getParameters().get('cfID');

        //DYNAMIC CASE QUERY WORK
        List<string> caseStandardFieldList = new List<string>{'id'};
        string queryString_case = '';
        
        for(Schema.FieldSetMember fsm: this.getCaseFields1()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields2()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields2a()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields3()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        for(Schema.FieldSetMember fsm: this.getCaseFields4()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        // Add to set to de-dup field listing
        Set<string> fieldSet_case = new Set<string>();
        for(string s: caseStandardFieldList){
            fieldSet_case.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList_case = new List<string>(fieldSet_case);
        for (Integer i=0; i<fieldList_case.size(); i++) {
            if(i == 0) {
                    queryString_case = 'select ' + fieldList_case[i];
            } else {
                    queryString_case += ', ' + fieldList_case[i];
            }
        }

        if(cfID != null && cfID != '')
            queryString_case += ', Channel__r.name, First_Time_Contact__c from Case where Connect_First_ID__c = \'' + cfid +'\' ORDER BY CreatedDate DESC LIMIT 1';
        else
            queryString_case += ', Channel__r.name, First_Time_Contact__c from Case where ID = \'' + caseID +'\' ORDER BY CreatedDate DESC LIMIT 1';

        system.debug('QUERY CASE FIELDS ARE ' + queryString_case);

        c = Database.query(queryString_case);

        system.debug('QUERIED CASE FIELDS ARE ' + c);

        if(c.id != null)
            searchURL = '/apex/knowledgesearch?caseid='+c.id;

        //END CASE QUERY

        //START CASE QUERY
        List<string> contactStandardFieldList = new List<string>{'lastname','Date_of_Birth__c','firstname', 'salutation', 'name'};
        string queryString = '';

        string existingConID = ApexPages.currentPage().getParameters().get('def_contact_id');
        
        phoneID = ApexPages.currentPage().getParameters().get('str');
        
        dnisID = ApexPages.currentPage().getParameters().get('DNIS');

        if((phoneID != null && phoneID != '') || (existingConID != null && existingConID != '')){
        
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
            if(phoneID != null && phoneID != '')
                queryString += ' from Contact where query_phone__c = \'' + phoneID + '\' ';
            else if(existingConID != null && existingConID != '')
                queryString += ' from Contact where id = \'' + existingConID +'\'';
            queryString += ' limit 200';
            
            cons = Database.query(queryString);

            system.debug('CONS ARE ' + cons);   

            if(!cons.isEmpty()){
                
                for(contact co : cons){
                    conMap.put(co.id, co);
                }
                
                if(phoneID != null && phoneID != '')
                    showCons = true;
                else{
                    toSelect = cons[0].id;
                    selectCon();
                }

                if(cons.size() > 1)
                    infoMessage = 'Multiple Contacts found for Phone Number: ' + phoneID;
                else
                    infoMessage = 'Contact found for Phone Number: ' + phoneID;
            }
            else{
                needCon = true;
                step2 = true;
                con.phone = phoneID;
                infoMessage = 'No Contact found for Phone Number: ' + phoneID;
                showInfo = true;
            }
        }
        else{
            needCon = true;
            step2 = true;
        }
    }

    public void noContact(){
        needCon=true;
        showCons=false;
        con.phone = phoneID;
    }

    public CSR_CreateCaseController() {
        
    }

    public void selectCon(){
        con = conMap.get(toSelect);
        c.contactid = con.id;
        if(con.Date_of_Birth__c != null){
            datetime dt = Datetime.newInstance(con.Date_of_Birth__c.year(), con.Date_of_Birth__c.month(),con.Date_of_Birth__c.day());
            dateExperiencedString = dt.format('MM/dd/YYYY');
        }
        system.debug('DATE STRING IS ' + dateExperiencedString);
        showCons = false;
    }

    public void clearError(){
        showError = false;
        errorMessage = '';
    }

    public void clearinfo(){
        showinfo = false;
        infoMessage = '';
    }

    public PageReference saveAnd(){     
        boolean continuing = false;
        if(needCon){
            c.contactid = createContact();
            c.First_Time_Contact__c = true;
            continuing = true;
        }
        else
            continuing = updateContact();

        if(continuing){

            try{

                upsert c;       

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
                if(con.Date_of_Birth__c != null)
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

    public void createCase(){
        step2 = false;
    }

    public void searchString(){
    }   

    public void closeCase(){
        c.status = label.csr_createcase_closed;
        caseClose = true;
    }

    public void needInfo(){
        c.status = Label.csr_createcase_pendingtier2;
        casePending = true;
        //return saveAnd();
    }

    public void transferToOptum(){
        c.status = Label.csr_create_case_transferredtooptum;
        caseClose = true;
        //return saveAnd();
    }

    public void findsoslResults() {
        if(!soslResults.isEmpty())
            soslResults.clear();
        if(!searchResults.isEmpty())
            searchResults.clear();

        if(searchString != null && searchString != '') {
            soslResults = [FIND :searchString IN ALL FIELDS RETURNING  case(casenumber, subject,createddate, status), Contact(name, email)];
            findsearchResults();
        }
    }
    
    public class searchResultRow{
        public string sObjectTypeName {get;set;}
        public sObject record {get;set;}
        
        public searchResultRow(sObject pObject) {
            record = pObject;
            sObjectTypeName = pObject.getSObjectType().getDescribe().getLabel();
        }
    }   
    
    public void findsearchResults() {
        if(soslResults != null) {
            //Loop through the list of list of sObjects from our sosl query
            for(list<sObject> objectList : soslResults) {
                for(sObject obj : objectList) {
                    searchResults.add(
                        new searchResultRow(obj)
                    );
                }
            }
        }
    }
}