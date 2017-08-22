public class ResourcePageEntryController {
    
    public string impID                                                     {get;set;}
    public string recPrefix                                                 {get;set;}
    public string objName                                                   {get;set;}
    public string fieldsetName                                              {get;set;}
    public string rtype                                                     {get;set;}
    public string fielddescription                                          {get;set;}
    public string header                                                    {get;set;}
    public string pageTitle                                                 {get;set;}
    public string rtName                                                    {get;set;}
    public string rewardType                                                {get;set;}
    public string entryType                                                 {get;set;}
    public string entryMethod                                               {get;set;}
    
    public boolean showSuccess                                              {get;set;}

    public Milestone1_Project__c impl                                       {get;set;}
    public Resource_Page_Requirement__c resource                            {get;set;}
    public List<promo> currentPromos                                        {get;set;}
    public List<promo> featuredPromos                                       {get;set;}
    public List<Resource_Page_Category__c> categories                       {get;set;}

    public List<selectOption> allAffiliations                               {get;set;}
    public List<selectOption> selectedAffiliation                           {get;set;}
    public List<sObject> childObjs                                          {get;set;}
    public List<Schema.FieldSetMember> objFields                            {get;set;}
    public List<Schema.FieldSetMember> childFields_current                  {get;set;}
    public List<Schema.FieldSetMember> childFields_featured                 {get;set;}
    public List<Schema.FieldSetMember> categoryfields                       {get;set;}

    public Map<id, id> affilMap                                             {get;set;}
    public Map<string, string> descriptionMap                               {get;set;}
    public Map<string, string> headermap                                    {get;set;}
    public Map<string, Integer> lengthMap                                   {get;set;}

    public Attachment att                                                   {get;set;}

    public List<String> objectfieldNames                                    {get;set;}
    public List<String> childfieldNames                                     {get;set;}

    public integer fieldCount                                               {get;set;}

    public ResourcePageEntryController() {
        impID = Apexpages.currentPage().getParameters().get('impID');

        impl = [select id, Partner__r.name from Milestone1_Project__c where ID =:impID];

        showSuccess = false;

        fielddescription = '';
        header = '';

        //att = new Attachment();
        objectfieldNames = new List<String>();
        childfieldNames = new List<String>();
        

        allAffiliations = new List<SelectOption>();
        affilMap = new Map<id,id>();
        lengthMap = new Map<string,integer>();
        descriptionMap = new Map<String, String>();
        headerMap = new Map<String, String>();


        pageTitle = 'Rally Resources Page Order Form';
        header = Label.ResourcePageForm_Header;


        for (Client_Affiliation__c seg : [select id, name from Client_Affiliation__c where Implementation__c = :impID AND Affiliation_type__c = 'Production']) {
            allAffiliations.add(new SelectOption(seg.id,seg.name));
        }

        resource = new Resource_Page_Requirement__c(Implementation__c=impID);
        currentPromos = new List<promo>();
        featuredPromos = new List<promo>();
        categories = new List<Resource_Page_Category__c>();

        currentPromos.add(new promo( new Resource_Page_Promotion__c(recordTypeID = Label.ResourcePageForm_CurrentRtypeID, Current_Promo_Type__c = 'Left Side'), allAffiliations));
        currentPromos.add(new promo( new Resource_Page_Promotion__c(recordTypeID = Label.ResourcePageForm_CurrentRtypeID, Current_Promo_Type__c = 'Right Side'), allAffiliations));
        
        for(Integer i=0;i<5;i++){
            featuredPromos.add(new promo( new Resource_Page_Promotion__c(recordTypeID = Label.ResourcePageForm_RtypeID), allAffiliations));
        }
        
        for(Integer i=0;i<3;i++){
            categories.add( new Resource_Page_Category__c());
        }

        findObjfields();
        findChildfields();
        findCategoryfields();
    }

    public class promo{
        public Resource_Page_Promotion__c pagePromo {get;set;}
        public List<SelectOption> allAffils {get;set;}
        public List<SelectOption> selectedAffils {get;set;}
        public integer mapCount {get;set;}

        public promo(Resource_Page_Promotion__c promoParam, List<SelectOption> paramOptions){
            this.pagePromo = promoParam;
            
            this.allAffils = new List<selectOption>();
            this.allAffils.addAll(paramOptions); 

            this.selectedAffils = new List<selectOption>();
            this.mapCount = 0;
        }
    }

    public void addFeaturedPromo(){
        featuredPromos.add(new promo( new Resource_Page_Promotion__c(recordTypeID = Label.ResourcePageForm_RtypeID), allAffiliations));
    }

    public void findObjfields() {

        Schema.DescribeSObjectResult DescribeSObjectResultObj = Resource_Page_Requirement__c.SObjectType.getDescribe();
        objfields = new List<Schema.FieldSetMember>();

        objfields = SObjectType.Resource_Page_Requirement__c.FieldSets.ResourcePageForm_ResourceFields.getFields();

        system.debug('OBJECT FIELDS ' + objfields);

        for(Schema.FieldSetMember fsm : objfields){
            objectfieldNames.add(fsm.getFieldPath());
            
            system.debug('FIELD NAME IS ' + fsm.getFieldPath());
            system.debug('FIELD DESCRIBE IS ' + DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe());

            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }
        
        findFieldDescription(objectfieldNames,'Resource_Page_Requirement__c');

    }

    public void findChildfields() {

        Schema.DescribeSObjectResult DescribeSObjectResultObj = Resource_Page_Promotion__c.SObjectType.getDescribe();

        childFields_current = SObjectType.Resource_Page_Promotion__c.FieldSets.ResourcePage_ResourcePromoCurrent.getFields();
        childFields_featured = SObjectType.Resource_Page_Promotion__c.FieldSets.ResourcePage_ResourcePromoFeatured.getFields();

        for(Schema.FieldSetMember fsm : childFields_current){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        for(Schema.FieldSetMember fsm : childFields_featured){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        findFieldDescription(childfieldNames, 'Resource_Page_Promotion__c');

    }

    public void findCategoryfields() {

        categoryFields = new List<Schema.FieldSetMember>();

        categoryFields = SObjectType.Resource_Page_Category__c.FieldSets.resourcepage_categoryfields.getFields();
        
        Schema.DescribeSObjectResult DescribeSObjectResultObj = Resource_Page_Category__c.SObjectType.getDescribe();

        for(Schema.FieldSetMember fsm : categoryFields){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        findFieldDescription(childfieldNames, 'Resource_Page_Category__c');

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
            system.debug('DESC MAP TEST ' + descriptionMap.get('Featured_Promo_Headline__c'));
            system.debug('HEADER MAP IS ' + headerMap);
            system.debug('LENGTH MAP IS ' + lengthMap);
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
        }
        
    }

    public void submitResults(){

        try{
            system.debug('DO WE GET INTO SUBMIT - Currents' + currentPromos);
            system.debug('DO WE GET INTO SUBMIT - Features ' + featuredPromos);

            for(schema.fieldsetmember fm : objfields){
                string tempField = fm.getFieldPath();
                if(tempField.contains('DateString__c')){
                    system.debug('DATE VALUE IS ' + String.valueOf(resource.get(tempField)));
                    string dt = String.valueOf(resource.get(tempField));
                    String[] str = dt.split('/');
                    date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                    string dateFieldPath = tempField.remove('String__c');
                    dateFieldPath = dateFieldPath + '__c';
                    resource.put(dateFieldPath,dtTemp);
                }
            }
            resource.put('Implementation__c', impID);
            insert resource;

            if(!categories.isEmpty()){
                for(Resource_Page_Category__c ca : categories){
                    ca.Resource_Page_Requirement__c = resource.id;
                }

                insert categories;
            }

            Map<Integer,Resource_Page_Promotion__c> newPromos = new Map<Integer,Resource_Page_Promotion__c>();
            List<Affiliation_Join__c> newAffils = new List<Affiliation_Join__c>();
            
            for(schema.fieldsetmember fm : childFields_current){
                string tempField = fm.getFieldPath();
                if(tempField.contains('DateString__c')){
                    for(promo ppd : currentPromos){
                        system.debug('DATE VALUE IS ' + String.valueOf(ppd.pagePromo.get(tempField)));
                        string dt = String.valueOf(ppd.pagePromo.get(tempField));
                        if(dt != null && dt != ''){
                            String[] str = dt.split('/');
                            date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                            string dateFieldPath = tempField.remove('String__c');
                            dateFieldPath = dateFieldPath + '__c';
                            ppd.pagePromo.put(dateFieldPath,dtTemp);
                        }
                    }
                }
            }

            for(schema.fieldsetmember fm : childFields_featured){
                string tempField = fm.getFieldPath();
                if(tempField.contains('DateString__c')){
                    for(promo ppd1 : featuredPromos){
                        system.debug('DATE VALUE IS ' + String.valueOf(ppd1.pagePromo.get(tempField)));
                        string dt = String.valueOf(ppd1.pagePromo.get(tempField));
                        if(dt != null && dt != ''){
                            String[] str = dt.split('/');
                            date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                            string dateFieldPath = tempField.remove('String__c');
                            dateFieldPath = dateFieldPath + '__c';
                            ppd1.pagePromo.put(dateFieldPath,dtTemp);
                        }
                    }
                }
            }
            
            integer countforMap = 0;
            
            for(promo pp : currentPromos){
                if(pp.pagePromo.Current_Promo_Headline__c != null){
                    countforMap++;
                    pp.mapCount = countforMap;
                    pp.pagePromo.Resource_Page_Requirement__c = resource.id;
                    //pp.pagePromo.External_ID__c = countforMap;
                    newPromos.put(countForMap,pp.pagePromo);
                }
            }

            for(promo pp1 : featuredPromos){
                if(pp1.pagePromo.Featured_Promo_Headline__c != null){
                    countforMap++;
                    pp1.mapCount = countforMap;
                    pp1.pagePromo.Resource_Page_Requirement__c = resource.id;
                    //pp1.pagePromo.External_ID__c = countforMap;
                    newPromos.put(countForMap,pp1.pagePromo);
                }
            }

            insert newPromos.values();

            system.debug('DO WE INSERT THE NEW PROMOS ' + newPromos);

            for(promo pp2 : currentPromos){
                if(newPromos.containsKey(pp2.mapCount)){
                    system.debug('DO WE GET HERE - PROMO ID' + newPromos.get(pp2.mapCount));
                    system.debug('DO WE GET HERE - SELECTED AFFILIATIONS' + newPromos.get(pp2.mapCount));
                    
                    for ( SelectOption so : pp2.selectedAffils ) {
                        Affiliation_Join__c aj = new Affiliation_Join__c();
                        aj.Client_Affiliation__c = so.getValue();
                        aj.Resource_Page_Promotion__c = newPromos.get(pp2.mapCount).id;
                        newAffils.add(aj);
                    }
                }
            }

            for(promo pp3 : featuredPromos){
                if(newPromos.containsKey(pp3.mapCount)){
                    system.debug('DO WE GET HERE - PROMO ID' + newPromos.get(pp3.mapCount));
                    system.debug('DO WE GET HERE - SELECTED AFFILIATIONS' + newPromos.get(pp3.mapCount));
                    
                    for ( SelectOption so : pp3.selectedAffils ) {
                        Affiliation_Join__c aj = new Affiliation_Join__c();
                        aj.Client_Affiliation__c = so.getValue();
                        aj.Resource_Page_Promotion__c = newPromos.get(pp3.mapCount).id;
                        newAffils.add(aj);
                    }
                }
            }

            if(!newAffils.isEmpty())
                insert newAffils;

            system.debug('NEW AFFILIATION JOINS ARE ' + newAffils);

            resource.Notification_to_optum__c=true;
            update resource;

            showSuccess = true;

        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return ;
        }
    }
}