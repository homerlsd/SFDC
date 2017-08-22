public class RallyOrderFormController{
    
    public Milestone1_Project__c impl                                                   {get;set;}
    public account client                                                               {get;set;}
    public partner__c p                                                                 {get;set;}
    public Rally_Order_Form_FS_Mapping__mdt fsMap                                       {get;set;}
    
    public string rtn                                                                   {get;set;}
    public string accID                                                                 {get;set;}
    public string selectedAffil                                                         {get;set;}
    public string implDateString                                                        {get;set;}
    
    public boolean showSuccess                                                          {get;set;}
    public boolean showError                                                            {get;set;}
    public boolean needsAccount                                                         {get;set;}
    
    public List<clientAffiliation> newClientAffils                                      {get;set;}
    public List<SelectOption> affilOptions                                              {get;set;}
    public List<String> fieldnames                                                      {get;set;}
    public string formID                                                                {get;set;}
    public string header                                                                {get;set;}
    public string pagetitle                                                             {get;set;}
    public string fieldSetName                                                          {get;set;}
    public Map<string, Integer>    lengthMap                                            {get;set;}
    public Map<string, string> descriptionMap                                           {get;set;}
    public Map<string, string> headermap                                                {get;set;}

    public Attachment att {
        get;set;
    }

    public List<SelectOption> getAffilRoles(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = affiliation__c.Affiliation_Role__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add( new SelectOption('-Select-', '-Select-'));
        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;

        system.debug('AFFILIATION ROLES ARE ' + options);

        return options;
    }

    public RallyOrderFormController(){
        system.debug('IN RALLY ORDER FORM ');
        
        lengthMap = new Map<string,integer>();
        descriptionMap = new Map<string,string>();
        headermap = new Map<string,string>();
        fieldnames = new List<String>();

        showSuccess = false;
        needsAccount = false;
        rtn = '';

        formID =  Apexpages.currentPage().getParameters().get('formID');

        accID =  Apexpages.currentPage().getParameters().get('accid');
        
        string pID =  Apexpages.currentPage().getParameters().get('pID');
        
        if(accID == null || accID == ''){
            needsAccount = true;
        }
        
        Partner__c[] ps = [select id, name from Partner__c where ID = : pid];
        

        List<Rally_Order_Form_FS_Mapping__mdt> mapping = Utils_Implementation.findFormfromID(formID);

        system.debug('MAPPING IS ' + mapping);
        system.debug('Partner IS ' + ps);

        if(ps.isEmpty() || mapping.isEmpty()){
            showError = true;
        }
        else{
            p = ps[0];
            fsMap = mapping[0];

            RecordType[] rt = [select id, name from RecordType where ID =:fsMap.record_type_id__c];

            if(rt.isEmpty()){
                showError = true;
            }
            else{
                rtn = rt[0].name;

                if(!needsAccount){
                    client = [select id, name, partner__c, Partner__r.name, OwnerId from account where ID = : accID];
                }
                else{
                    client = new Account(Partner__c = p.id);
                }

                impl = new Milestone1_Project__c(RecordTypeID = fsMap.Record_Type_ID__c, Partner__c = p.id, Channel__c = Label.CC_Default_Channel_ID);
                
                att = new Attachment();

                selectedAffil = '';

                pagetitle = fsMap.Page_Title__c;
                fieldSetName = fsMap.DeveloperName;

                system.debug('FIELD SET FINAL NAME IS ' + fieldSetName);
                system.debug('PAGE TITLE IS ' + fieldSetName);

                //pagetitle = (formID == Label.ROF_HIAID ? Label.ROF_HIA_TITLE : (formID == Label.ROF_MidMarketID ? Label.ROF_OMM_TITLE : Label.ROF_TITLE));
                //fieldSetName = (formID == Label.ROF_HIAID ? 'ClientFormController_HIAFields' : (formID == Label.ROF_MidMarketID ? 'ClientFormController_OMMFields' : 'ClientFormController_ROFFields'));

                string labelName = fsMap.Header_Name__c;

                system.debug('FIELD SET FINAL NAME IS ' + fieldSetName);
                system.debug('LABEL FINAL NAME IS ' + labelName);

                if(!test.isRunningTest()){
                    Component.Apex.OutputText output;
                    output = new Component.Apex.OutputText();
                    output.expressions.value = '{!$Label.' + labelName + '}';
                    header = string.valueOf(output.value);
                }

                if(fsMap.Number_Of_Affiliations__c != null && fsMap.Number_Of_Affiliations__c > 0){
                    setupClientAffils();
                    setupAffiliations();
                }
                    
                findFieldLengths();
            }   
        }     
    }

    public List<Schema.FieldSetMember> getAccFields() {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Account');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }

    public List<Schema.FieldSetMember> getImplFields() {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Milestone1_Project__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }

    public List<Schema.FieldSetMember> getAffilFields() {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Client_Affiliation__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }

    public void setupClientAffils(){

        newClientAffils = new List<clientAffiliation>();
        
        integer loopNums = integer.valueOf(fsMap.Number_of_Affiliations__c);

        for(Integer i=0;i<loopNums;i++){
            Client_Affiliation__c ca = new Client_Affiliation__c();
            newClientAffils.add(new clientAffiliation(ca,formID,p.name));
        }
    }

    public List<SelectOption> setupAffiliations(){
        affilOptions = new List<SelectOption>();
        affilOptions.add( new SelectOption('-Select-', '-Select-'));

        for(Affiliation__c af : [select id, name, Form_Options__c from Affiliation__c where partner__c = : p.id]){
            if((formID == Label.ROF_ROFID || formID == Label.ROF_HIAID) && formID == af.Form_Options__c){
               affilOptions.add( new SelectOption(af.name,af.name));
            }
            else if(formID != Label.ROF_ROFID && formID != Label.ROF_HIAID){
                affilOptions.add( new SelectOption(af.name,af.name));
            }
        }
        
        system.debug('AFFILIATION OPTIONS ARE ' + affilOptions);

        return affilOptions;
    }

    public class clientAffiliation{
        public Client_Affiliation__c affil {get;set;}
        public List<segmentID> segmentList {get;set;}
        public string prefIx               {get;set;}
        public string suffix               {get;set;}
        public string affilID              {get;set;}

        public clientAffiliation(Client_Affiliation__c affilParam, string formID, string partnerName){
            this.affil = affilParam;
            Segmentation_ID__c segid = new Segmentation_ID__c();
            this.segmentList = new List<segmentID>();
            this.segmentList.add(new segmentID(new Segmentation_ID__c(), partnerName));
            if(formID == Label.ROF_ROFID){
                this.segmentList.add(new segmentID(new Segmentation_ID__c(), partnerName));
                this.segmentList.add(new segmentID(new Segmentation_ID__c(), partnerName));
                this.segmentList.add(new segmentID(new Segmentation_ID__c(), partnerName));
            }
            system.debug('SEGMENT LIST IS ' + this.segmentList);
            this.prefix = '';
            this.suffix = '';
            this.affilID = '';
        }

    }

    public class segmentID{
        public Segmentation_ID__c segID          {get;set;}
        public String prefix                     {get;set;}
        public String suffix                     {get;set;}
        public String segRangeorNumber           {get;set;}

        public segmentID(Segmentation_ID__c segParam, string partnerName){
            this.segID = segParam;
            if(partnerName == 'BCBS South Carolina')
                this.segID.Segmentation_Suffix__c = 'MED';
        }
    }

    public void findFieldLengths() {

        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 

        Schema.SObjectType SObjectType_imp = GlobalDescribeMap.get('Milestone1_Project__c');        
        Schema.DescribeSObjectResult DescribeSObjectResult_Imp = SObjectType_imp.getDescribe();
        Schema.SObjectType SObjectType_acc = GlobalDescribeMap.get('Account');
        Schema.DescribeSObjectResult DescribeSObjectResult_acc = SObjectType_acc.getDescribe();

        for(Schema.FieldSetMember fsm : getImplFields()){
            fieldnames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResult_Imp.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        for(Schema.FieldSetMember fsm : getAccFields()){
            fieldnames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResult_acc.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }


        if(fsMap.Number_Of_Affiliations__c != null && fsMap.Number_Of_Affiliations__c > 0){
            Schema.SObjectType SObjectType_affil = GlobalDescribeMap.get('Client_Affiliation__c');
            Schema.DescribeSObjectResult DescribeSObjectResult_affil = SObjectType_affil.getDescribe();
            for(Schema.FieldSetMember fsm : getAffilFields()){
                fieldnames.add(fsm.getFieldPath());
                Schema.DescribeFieldResult TestField = DescribeSObjectResult_affil.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
                lengthMap.put(fsm.getFieldPath(),TestField.getLength());
            }
        }

        findFieldDescription();

    }

    public void findFieldDescription(){

        try{
            descriptionMap = new Map<String, String>();
            Map<String, String> descriptionMap2 = new Map<String, String>();
            headerMap = new Map<String, String>();

            descriptionMap2 = Utils_Implementation.getFieldInfoMap_ROF('Milestone1_Project__c',fieldnames, descriptionMap);
            descriptionMap.putall(descriptionMap2);
            headerMap = Utils_Implementation.getHeaderMap('Milestone1_Project__c',fieldnames);

            descriptionMap2 = Utils_Implementation.getFieldInfoMap_ROF('Account',fieldnames,descriptionMap);
            descriptionMap.putall(descriptionMap2);
            headerMap = Utils_Implementation.getHeaderMap('Account',fieldnames);
            
            if(fsMap.Number_Of_Affiliations__c != null && fsMap.Number_Of_Affiliations__c > 0){

                descriptionMap2 = Utils_Implementation.getFieldInfoMap_ROF('Client_Affiliation__c',fieldnames, descriptionMap);
                descriptionMap.putall(descriptionMap2);
                headerMap = Utils_Implementation.getHeaderMap('Client_Affiliation__c',fieldnames);
            }

            system.debug('DESC MAP IS ' + descriptionMap);
            system.debug('HEADER MAP IS ' + headerMap);
            system.debug('LENGTH MAP IS ' + lengthMap);
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
        }
        
    }

    public void submitResults(){

        if(needsAccount){
            accID = createNewAccount();
        }

        try{
            for(schema.fieldsetmember fm : getImplFields()){
                string tempField = fm.getFieldPath();
                system.debug('TEMPFIELD IS ' + tempField);
                if(tempField.contains('DateString__c') && String.valueOf(impl.get(tempField)) != null && String.valueOf(impl.get(tempField)) !=''){
                    system.debug('DATE VALUE IS ' + String.valueOf(impl.get(tempField)));
                    string dt = String.valueOf(impl.get(tempField));
                    String[] str = dt.split('/');
                    date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                    string dateFieldPath = tempField.remove('String__c');
                    dateFieldPath = dateFieldPath + '__c';
                    impl.put(dateFieldPath,dtTemp);
                }
            }
        }catch (Exception pe){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Date format.'));
            return;
        }

        impl.Account__c = accID;

        string namey = client.name + ' - ' + impl.Rally_Implementation_Start_DateString__c;

        if(namey.length() > 80){
            namey = namey.substring(0,80);
        }

        system.debug('NAMEY IS ' + namey);

        impl.name = namey;

        system.debug('IMPLEMENTATION START DATE ' + impl.Rally_Implementation_Start_Date__c);
        system.debug('IMPLEMENTATION NAME ' + impl.name);

        try{
            insert impl;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()+'LINE NUMBER - ' + ex.getLineNumber()));
            return;
        }

        //insert an attachment
        if(att.body != null){
            att.OwnerId = client.OwnerId;
            att.ParentId = impl.Id; 

            try {
               // if(!Test.isRunningTest()) {
                 insert att;
              //}
            } catch (DMLException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment - please remove and email kate.tompkins@rallyhealth.com the client logo.'));
                return;
            }
        }

        if(fsMap.Number_of_Affiliations__c != null && fsMap.Number_of_Affiliations__c > 0){
            List<Segmentation_ID__c> newSegs = new List<Segmentation_ID__c>();

            Map<String, List<Segmentation_ID__c>> segmap = new Map<String, List<Segmentation_ID__c>>();

            try{
                for(clientAffiliation c : newClientAffils){
                    system.debug('DO WE HAVE AN AFFILIATION TO ADD? ' + c.affil.affiliation__c);
                    /*if(p.name != 'Optum' && p.name != 'Excellus'){
                        if(c.affilID != null && c.affilID != '-Select-'){
                            c.affil.name = c.affilID;
                            c.affil.Implementation__c = impl.id;
                            c.affil.account__c = client.id;
                            
                            ID caID = createNewAffil(c.affil);

                            for(segmentID seg : c.segmentList){
                                if(seg.segID.name != null && seg.segID.name != ''){
                                    seg.segID.Client_Affiliation__c = caID;
                                    newSegs.add(seg.segID);
                                }
                            }
                        }
                    }
                    else{
                        if(c.affilID != null && c.affilID != ''){
                            c.affil.Implementation__c = impl.id;
                            c.affil.account__c = client.id;
                            c.affil.name = c.affilID;

                            ID caID = createNewAffil(c.affil);

                            for(segmentID seg : c.segmentList){
                                if(seg.segID.name != null && seg.segID.name != ''){
                                    seg.segID.Client_Affiliation__c = caID;
                                    newSegs.add(seg.segID);
                                }
                            }
                        }
                    }*/
                    if(c.affilID != null && c.affilID != '' && c.affilID != '-Select-'){
                        c.affil.Implementation__c = impl.id;
                        c.affil.account__c = accID;
                        c.affil.name = c.affilID;
                        
                        ID caID = createNewAffil(c.affil);

                        for(segmentID seg : c.segmentList){
                            if(seg.segID.name != null && seg.segID.name != ''){
                                seg.segID.Client_Affiliation__c = caID;
                                newSegs.add(seg.segID);
                            }
                        }
                    }
                }

                if(!newSegs.isEmpty()){
                    insert newSegs;
                }
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()+'LINE NUMBER - ' + ex.getLineNumber()));
                return;
            }
        }

        impl = [select id, Channel__c, Record_Submitted__c,Client_Logo_Id__c from Milestone1_Project__c where ID = :impl.id];
        
        impl.Record_Submitted__c = true;

        if(att.id != null){
            impl.Client_logo_ID__c = att.id;
        }
    
        update impl;

        showSuccess=true;
        
    }

    public id createNewAffil(Client_Affiliation__c caf){
        insert caf;
        return caf.id;
    }

    public id createNewAccount(){
        try{
            List<account> checkAcc = [select id, name from account where (name =: client.name OR (Client_ID__c != null AND client_id__c =: impl.CES_Client_Number__c))];
            
            if(!checkAcc.isEmpty()){
                client = checkAcc[0];
                return checkAcc[0].id;
            }
            else{
                if(string.valueOf(p.id).contains(Label.ManageAffiliations_BCBSPartnerID))
                    client.Client_ID__c = impl.CES_Client_Number__c;
                insert client;
                client = [select id, name, OwnerId from Account where ID = : client.id];
                return client.id;
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()+'LINE NUMBER - ' + ex.getLineNumber()));
            return null;
        }
        
    }

    public pageReference goToLink(){
        pageReference pg = Page.ClientSearch;
        pg.getParameters().put('id', p.id);
        pg.getParameters().put('chan', impl.Channel__c);
        pg.getParameters().put('accID', accID);
        pg.setRedirect(true);
        return pg;
    }

}