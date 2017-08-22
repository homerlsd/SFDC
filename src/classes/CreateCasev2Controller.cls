public  class CreateCasev2Controller {
            
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
    public string forceCon {get;set;}
    public boolean casePending {get;set;}
    public boolean showCreateButton {get;set;}
    public boolean showpicklistpanel {get;set;}

    public string transToOptum {get;set;}
    public String toSelect {get; set;}
    public String toCreate {get; set;}
    public String dnisID {get; set;}
    public String callID {get; set;}
    public string caseID {get;set;}
    public string phoneID {get;set;}
    public string selectedTab {get;set;}
    public string existing {get;set;}
    public string existingConID {get;set;}
    
    public string accountid {get;set;}
    public string accountname {get;set;}

    public string selectedStep1 {get;set;}
    public string selectedStep2 {get;set;}
    public string selectedStep3 {get;set;}
    public string selectedStep4 {get;set;}
    public string selectedStep5 {get;set;}
    public string selectedStep6 {get;set;}

    public List<SelectOption> rTypeOptions {get;set;}

    public List<SelectOption> step1options {get;set;}
    public List<SelectOption> step2options {get;set;}
    public List<SelectOption> step3options {get;set;}
    public List<SelectOption> step4options {get;set;}
    public List<SelectOption> step5options {get;set;}
    public List<SelectOption> step6options {get;set;}
    
    public string searchURL {get;set;}

    public String dateExperiencedString {get;set;}

    public list<list<sObject>> soslResults {get;set;}
    public list<searchResultRow> searchResults {get;set;}
    public string searchString {get;set;}

    public string errorMessage {get;set;}
    public string infoMessage {get;set;}
    
    public pageReference pg {get;set;}

    public Integer requiredStep {get;set;}

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
        return SObjectType.Case.FieldSets.CreateCasev2_ENGAGE.getFields();
    }   

    public List<Schema.FieldSetMember> getCaseFields2a() {
        return SObjectType.Case.FieldSets.CreateCasev2_CHOICE.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields3() {
        return SObjectType.Case.FieldSets.CSRCaseCloseInformation.getFields();
    }

    public List<Schema.FieldSetMember> getCaseFields4() {
        return SObjectType.Case.FieldSets.CSRCasePendingInformation.getFields();
    }

    public void onLoad(){

        Map<string,string> tempMap = ApexPages.currentPage().getParameters();
        
        system.debug('PARAMS ARE ' + tempMap);

        string tempID = ApexPages.currentPage().getParameters().get('Call_ID');
        existing = ApexPages.currentPage().getParameters().get('existing');
        string dnisTemp = ApexPages.currentPage().getParameters().get('DNIS');
        string aniTemp = ApexPages.currentPage().getParameters().get('ANI');
        string number1 = ApexPages.currentPage().getParameters().get('number1');
        string tempCaseID = ApexPages.currentPage().getParameters().get('Case_ID');

        string calltype = 'Inbound';

        if(number1 != null && number1 != '' && dnisTemp != null && dnisTemp != '' && number1 == dnisTemp){
            dnisTemp = aniTemp;
            aniTemp = number1;
            calltype = 'Outbound';
        }
        
        system.debug('existing? ' + existing);

        if(existing == null || existing == ''){

            boolean doQuery = false;

            string query1 = 'select id, ownerID from Case where ';
            
            if(tempCaseID != null && tempCaseID != ''){
                query1 += 'ID = \'' + tempCaseID +'\' ORDER BY CreatedDate DESC LIMIT 1';
                doQuery = true;
            }
            else if(tempID != null && tempID != ''){
                doQuery = true;
                query1 += 'Call_ID__c = \'' + tempID +'\' ORDER BY CreatedDate DESC LIMIT 1';
            }
            
            if(!doQuery){
                string badID = 'SomeBadIDWHatevs';
                query1 += 'Call_ID__c = \'' + badID +'\' ORDER BY CreatedDate DESC LIMIT 1';
            }

            List<case> c1 = Database.query(query1);

            if(c1.isEmpty()){   
                id chanID;
                id rtypeID;
                id partnerID;

                if(dnisTemp != null && dnisTemp != ''){
                    Map<String,String> sc = Utils.GetChannelIDFromDNIS(dnisTemp);
                    
                    system.debug('WHAT IS THE CHANNEL MAP ' + sc);

                    if(sc.get('empty') == 'set'){
                        chanID = CC_Constants.DEFAULT_CHANNEL_ID;
                        rtypeID = CC_Constants.DEFAULT_CASE_RECORDTYPE_ID;
                    }
                    else{
                        system.debug('DID WE FIND A DNIS GATEWAY ' + sc);
                        
                        List<String> temp1 = new List<String>();
                        temp1.addAll(sc.keySet());
                        List<String> temp2 = sc.values();
                        chanID = temp1[0];
                        rtypeID = temp2[0];
                    }

                    ID p = Utils.GetPartnerIDFromDNIS(dnisTemp);
                    if(p != null)
                        partnerID = p;

                }
                else{
                    chanID = CC_Constants.DEFAULT_CHANNEL_ID;
                    rtypeID = CC_Constants.DEFAULT_CASE_RECORDTYPE_ID;
                }



                Case ca = new Case(origin='Phone', Call_ID__c = tempID, Channel__c = chanID, RecordTypeID = rtypeID, Phone__c = aniTemp, Call_Type__c = calltype);
                
                try{
                    
                    if(partnerID != null)
                        ca.Partner_Lookup__c = partnerID;

                    String GateID = Utils.GetGatewayID(dnisTemp);

                    if(GateID != null)
                        ca.Gateway__c = GateID;

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
                id userID = UserInfo.getUserID();

                if(userID != c1[0].OwnerID){
                    c1[0].ownerID = userID;
                    update c1;
                }

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
        showCreateButton = false;
        showpicklistpanel = false;

        //strings
        errorMessage = '';
        infoMessage = '';
        searchString = '';
        searchURL = '';
        transToOptum = 'Transfered to Optum';
        dateExperiencedString = '';
        accountid = '';
        accountname = '';

        selectedTab = 'name2';

        requiredStep = 6;

        //dependency strings
        //selectedStep2 = '';
        //selectedStep3 = '';
        //selectedStep4 = '';
        //selectedStep5 = '';
        //selectedStep6 = '';

        //objs
        c = new Case();
        cons = new List<contact>();
        conMap = new Map<Id,contact>();
        con = new Contact();
        soslResults = new List<List<sObject>>();
        searchResults = new List<searchResultRow>();

        //see if we need a contact from the prior page load
        forceCon = ApexPages.currentPage().getParameters().get('forceCon');

        //get the CF id for finding the case
        callID = ApexPages.currentPage().getParameters().get('Call_ID');

        if(ApexPages.currentPage().getParameters().get('Case_ID') != null && ApexPages.currentPage().getParameters().get('Case_ID') != '')
            caseID = ApexPages.currentPage().getParameters().get('Case_ID');

        //DYNAMIC CASE QUERY WORK
        List<string> caseStandardFieldList = new List<string>{'id','contactid','RecordTypeID','recordtype.name','step_1__c', 'step_2__c', 'step_3__c', 'step_4__c', 'step_5__c', 'step_6__c', 'First_Call_Resolution__c'};
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

        system.debug('callID IS ' + callID);

        if(callID != null && callID != '')
            queryString_case += ', Channel__r.name, First_Time_Contact__c, Call_Type__c from Case where Call_ID__c = \'' + callID +'\' ORDER BY CreatedDate DESC LIMIT 1';
        else
            queryString_case += ', Channel__r.name, First_Time_Contact__c, Call_Type__c from Case where ID = \'' + caseID +'\' ORDER BY CreatedDate DESC LIMIT 1';

        system.debug('QUERY CASE FIELDS ARE ' + queryString_case);

        c = Database.query(queryString_case);

        system.debug('QUERIED CASE FIELDS ARE ' + c);

        if(c.id != null)
            searchURL = '/apex/knowledgesearch?caseid='+c.id;

        //END CASE QUERY

        //START CASE QUERY
        List<string> contactStandardFieldList = new List<string>{'lastname','Date_of_Birth__c','firstname', 'salutation', 'name'};
        string queryString = '';

        existingConID = ApexPages.currentPage().getParameters().get('def_contact_id');

        if(c.contactId != null)
            existingConID = c.contactID;

        system.debug('CONTACT ID IS ' + existingConID);
        
        phoneID = ApexPages.currentPage().getParameters().get('ANI');
        
        dnisID = ApexPages.currentPage().getParameters().get('DNIS');

        if(c.call_type__c == 'Outbound'){
            phoneID = dnisID;
        }

        system.debug('DO WE HAVE PHONE ID ' + phoneID);
        system.debug('DO WE HAVE CONTACT ID ' + existingConID);

        if((phoneID != null && phoneID != '') || (existingConID != null && existingConID != '')){

            system.debug('QUERYING CONTACT line 336');
        
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
            if(existingConID != null && existingConID != '')
                queryString += ' from Contact where id = \'' + existingConID +'\'';
            else if(phoneID != null && phoneID != '')
                queryString += ' from Contact where query_phone__c = \'' + phoneID + '\' ';

            queryString += ' limit 20';
            
            cons = Database.query(queryString);

            system.debug('CONS ARE ' + cons);   

            if(!cons.isEmpty()){
                step2 = true;
                selectedTab = 'name1';

                for(contact co : cons){
                    conMap.put(co.id, co);
                }
                
                if(existingConID == null || existingConID == '')
                    showCons = true;
                else if(cons.size() == 1){
                    toSelect = cons[0].id;
                    selectCon();
                }

                if(cons.size() > 1)
                    infoMessage = 'Multiple Contacts found for Phone Number: ' + phoneID;
                else
                    infoMessage = 'Contact found for Phone Number: ' + phoneID;

                if(forceCon == 'true'){
                    step2 = false;
                    selectedTab = 'name3';
                }

            }
            else{
                needCon = true;
                step2 = true;
                con.phone = phoneID;
                infoMessage = 'No Contact found for Phone Number: ' + phoneID;
                showInfo = true;
                if(forceCon == 'true'){
                    step2 = false;
                    selectedTab = 'name3';
                }
            }
        }
        else{
            needCon = true;
            step2 = true;
            if(forceCon == 'true'){
                step2 = false;
                selectedTab = 'name3';
            }
        }

        /*if(existing == 'true'){
            step2 = false;
            selectedTab = 'name2';
        }*/

        findStep1();
        findStep2();
        findStep3();
        findStep4();
        findStep5();
        findStep6();
        findRtypeOptions();
    }

    public List<SelectOption> findRtypeOptions(){
        Set<id> checkSet = new Set<ID>();

        rTypeOptions = new List<SelectOption>();
        
        if(c.RecordTypeID != null){
            rTypeOptions.add(new SelectOption(c.RecordTypeID, c.recordtype.name));
            checkset.add(c.RecordTypeID);
        }
        
        system.debug('CURRENT RECORDTYPE IS  ' + c.recordtype.name);

        for(RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable() && info.name != 'Master' && (checkset.isEmpty() || (!checkset.isEmpty() && !checkset.contains(info.getRecordTypeId())))){
                rTypeOptions.add(new SelectOption(info.getRecordTypeId(), info.getName())); 
            }
        }

        return rTypeOptions;
    }

    public pageReference setRtype(){
        
        try{
            update c;
        }
        catch(exception ex){
            showError = true;
            errorMessage = 'Error Setting RecordType: ' + ex.getMessage();
            return null;
        }

        Map<string,string> pageParams=ApexPages.currentPage().getParameters();
        system.debug('PARAMS ARE ' + pageParams);

        PageReference pageRef = page.CreateCasev2;
        
        if(existing=='true')
        pageRef.getParameters().put('existing', 'true');
        if(forceCon=='true')
            pageRef.getParameters().put('forceCon', 'true');
        if(c.id != null)
            pageRef.getParameters().put('Case_ID', c.id);
        if(existingConID!=null && existingConID!='')
            pageRef.getParameters().put('existingConID', con.id);
        
        pageRef.setRedirect(true);
        return pageRef;

    }

    public PageReference noContact(){

        PageReference pg = page.CreateCasev2;
        pg.getParameters().put('DNIS', dnisID);
        pg.getParameters().put('Call_ID', callID);
        pg.getParameters().put('Case_ID', c.id);
        pg.getParameters().put('ANI', phoneID);
        pg.getParameters().put('existing', 'true');
        pg.getParameters().put('forceCon', 'true');
        pg.setRedirect(true);
        return pg;

    }

    public CreateCasev2Controller() {
        selectedStep1 = '';
        
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
        selectedTab = 'name3';
        step2 = false;
    }

    public PageReference selectFound(){
        con = conMap.get(toSelect);

        PageReference pg = page.CreateCasev2;
        pg.getParameters().put('DNIS', dnisID);
        pg.getParameters().put('Call_ID', callID);
        pg.getParameters().put('Case_ID', c.id);
        pg.getParameters().put('existing', 'true');
        pg.getParameters().put('def_contact_id', con.id);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference selectFound1(){
        system.debug('CON ID SELECTED IS ' + toSelect);

        string conid = toSelect;

        PageReference pg = page.CreateCasev2;
        pg.getParameters().put('DNIS', dnisID);
        pg.getParameters().put('Call_ID', callID);
        pg.getParameters().put('Case_ID', c.id);
        pg.getParameters().put('existing', 'true');
        pg.getParameters().put('def_contact_id', conid);
        pg.getParameters().put('existingConID', conid);
        pg.setRedirect(true);
        return pg;
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

        if(con == null || con.id == null){
            c.First_Time_Contact__c = true;
            c.contactid = createContact();
            if(c.contactid == null)
                continuing = false;
            else
                continuing = true;
        }
        else
            continuing = updateContact();

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
            if(con.Rally_UID__c != null || con.email != null){
                Contact[] cc = [select id from contact where ((Rally_UID__c != NULL AND Rally_UID__c = :con.Rally_UID__c) OR (email != null AND email = : con.email)) limit 1];

                if(!cc.isEmpty()){
                    con.id = cc[0].id;
                    upsert con;
                    return con.id;
                }
            }
    
            try{
                if(dateExperiencedString != null && dateExperiencedString != '')
                    con.Date_of_Birth__c = Date.parse(dateExperiencedString);
                
            }catch (Exception pe){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date Experienced - Invalid Date format.'));
                return null;
            }
            
            if(con.accountid == null){
                showError = true;
                errorMessage = Label.CreateCaseV2_NeedAccountError;
                return null;
            }
            else{
                Account accc = [select id, recordtype.name from account where id =:con.accountid];
                
                if(accc.recordtype.name == 'Consumer Support'){
                    showError = true;
                    errorMessage = Label.CreateCaseV2_NeedAccountError;
                    return null;
                }

            }

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
                return false;
            }

            if(con.accountid == null){
                showError = true;
                errorMessage = Label.CreateCaseV2_NeedAccountError;
                return false;
            }
            else{
                Account accc = [select id, recordtype.name from account where id =:con.accountid];

                system.debug('ACCOUNT RECORD TYPE ' + accc.recordtype.name);

                if(accc.recordtype.name == 'Consumer Support'){
                    showError = true;
                    errorMessage = Label.CreateCaseV2_NeedAccountError;
                    return false;
                }

            }

            update con;
            return true;
        }
        catch(exception ex){
            errorMessage = 'Error Creating Contact: ' + ex.getMessage();
            return false;
        }
    }

    public void searchString(){
    }   

    public void closeCase(){
        if(c.Channel__r.name == 'Engage'){
            string stepString = 'Step_'+string.valueOf(requiredStep)+'__c';

            if(c.get(stepString) == null || c.get(stepString) == '' || c.get(stepString) == '-Select-'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CaseDependencyComponent_FieldRequired));
                return;
            }
        }
        c.status = label.csr_createcase_closed;
        c.First_Call_Resolution__c = true;
        caseClose = true;
    }

    public void needInfo(){
        if(c.Channel__r.name == 'Engage'){
            string stepString = 'Step_'+string.valueOf(requiredStep)+'__c';

            if(c.get(stepString) == null || c.get(stepString) == '' || c.get(stepString) == '-Select-'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CaseDependencyComponent_FieldRequired));
                return;
            }
        }
        c.status = Label.csr_createcase_pendingERTnew;
        casePending = true;
        //return saveAnd();
    }

    public void transferToOptum(){
        if(c.Channel__r.name == 'Engage'){
            string stepString = 'Step_'+string.valueOf(requiredStep)+'__c';

            if(c.get(stepString) == null || c.get(stepString) == '' || c.get(stepString) == '-Select-'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CaseDependencyComponent_FieldRequired));
                return;
            }
        }
        c.status = Label.csr_create_case_transferredtooptum;
        c.First_Call_Resolution__c = true;
        caseClose = true;
        //return saveAnd();
    }

    public void findsoslResults() {
        if(showCreateButton == false)
            showCreateButton = true;

        system.debug('show button is ' + showCreateButton);

        if(!soslResults.isEmpty())
            soslResults.clear();
        if(!searchResults.isEmpty())
            searchResults.clear();

        if(searchString != null && searchString != '' && searchString.length() > 1) {
            soslResults = [FIND :searchString IN ALL FIELDS RETURNING Contact(name, email)];
            findsearchResults();
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

    public class searchResultRow{
        public string sObjectTypeName {get;set;}
        public sObject record {get;set;}
        
        public searchResultRow(sObject pObject) {
            record = pObject;
            sObjectTypeName = pObject.getSObjectType().getDescribe().getLabel();
        }
    }  

public void setSelectedStep1(){
        requiredStep = 6;
        system.debug('SETTING STEP 1 VALUE ' + c.step_1__c);

        findStep2();
        findStep3();
        findStep4();
        findStep5();
        findStep6();

        if(step2options.size() == 1)
            requiredStep = 1;
    }

    public void setSelectedStep2(){
        requiredStep = 6;
        system.debug('SETTING STEP 2 VALUE ' + c.step_2__c);

        findStep3();
        findStep4();
        findStep5();
        findStep6();

        if(step3options.size() == 1)
            requiredStep = 2;

    }

    public void setSelectedStep3(){
        requiredStep = 6;
        system.debug('SETTING STEP 3 VALUE ' + c.step_3__c);

        findStep4();
        findStep5();
        findStep6();

        if(step4options.size() == 1)
            requiredStep = 3;
    }

    public void setSelectedStep4(){
        requiredStep = 6;
        system.debug('SETTING STEP 4 VALUE ' + c.step_4__c);

        findStep5();
        findStep6();

        if(step5options.size() == 1)
            requiredStep = 4;

    }

    public void setSelectedStep5(){
        requiredStep = 6;
        system.debug('SETTING STEP 5 VALUE ' + c.step_5__c);

        findStep6();

        if(step6options.size() == 1)
            requiredStep = 5;

    }

    public List<SelectOption> findStep1(){
        system.debug('STEP 1 SELECTION OPTIONS METHOD ');
        step1options = new List<SelectOption>();
        step1options.add( new SelectOption('-Select-', '-Select-'));

        List<SelectOption> tempSelects = Utils.findxxOptions('MagentoWasRight', '1',c.recordtype.name,c.Channel__r.name);

        if(tempSelects != null)
            step1options.addAll(tempSelects);
        
        system.debug('STEP 1 SELECTION OPTIONS ARE ' + step1options);

        return step1options;
    }

    public List<SelectOption> findStep2(){
        system.debug('STEP 2 SELECTION OPTIONS METHOD ');
        step2options = new List<SelectOption>();
        step2options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_1__c != null && c.Step_1__c != '' ? c.Step_1__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '2',c.recordtype.name,c.Channel__r.name);

        if(tempSelects != null)
            step2options.addAll(tempSelects);
        
        system.debug('STEP 2 SELECTION OPTIONS ARE ' + step2options);

        return step2options;
    }

    public List<SelectOption> findStep3(){
        system.debug('STEP 3 SELECTION OPTIONS METHOD ');
        step3options = new List<SelectOption>();
        step3options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_2__c != null && c.Step_2__c != '' ? c.Step_2__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '3',c.recordtype.name,c.Channel__r.name);

        if(tempSelects != null)
            step3options.addAll(tempSelects);
        
        system.debug('STEP 3 SELECTION OPTIONS ARE ' + step3Options);

        return step3options;
    }

    public List<SelectOption> findStep4(){
        system.debug('STEP 4 SELECTION OPTIONS METHOD ');
        step4options = new List<SelectOption>();
        step4options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_3__c != null && c.Step_3__c != '' ? c.Step_3__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '4',c.recordtype.name,c.Channel__r.name);

        if(tempSelects != null)
            step4options.addAll(tempSelects);
        
        system.debug('STEP 4 SELECTION OPTIONS ARE ' + step4Options);

        return step4options;
    }

    public List<SelectOption> findStep5(){
        system.debug('STEP 5 SELECTION OPTIONS METHOD ');
        step5options = new List<SelectOption>();
        step5options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_4__c != null && c.Step_4__c != '' ? c.Step_4__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '5',c.recordtype.name,c.Channel__r.name);

        if(tempSelects != null)
            step5options.addAll(tempSelects);
        
        system.debug('STEP 5 SELECTION OPTIONS ARE ' + step5Options);

        return step5options;
    }

    public List<SelectOption> findStep6(){
        system.debug('STEP 6 SELECTION OPTIONS METHOD ');
        step6options = new List<SelectOption>();
        step6options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_5__c != null && c.Step_5__c != '' ? c.Step_5__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '6',c.recordtype.name,c.Channel__r.name);

        if(tempSelects != null)
            step6options.addAll(tempSelects);
        
        system.debug('STEP 6 SELECTION OPTIONS ARE ' + step6Options);

        return step6options;
    }

    public void showPicklists(){
        showpicklistpanel = true;
    }

}