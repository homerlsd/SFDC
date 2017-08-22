public with sharing class NewRewardIDController {

    public List<Activity_ID> Activity_IDWrapperList {get;set;}
    public List<Activity_ID> cust_IDWrapperList {get;set;}
        
    public List<Reward_Activity_ID__c> newactivityIDs {get;set;}

    public Milestone1_Project__c impl {get;set;}

    List<Reward_Activity_ID__c> activityIDs {get;set;}

    public string implId {get;set;}
    public string errorMessage {get;set;}
    
    public List<Activity_ID__c> Activity_IDs {get;set;}
    public List<String> newactivityIDStrings {get;set;}
    public Set<string> Activity_IDNames {get;set;}

    public Map<string,Activity_ID__c> affmap {get;set;}
    public boolean showOptumPanel                                           {get;set;}

    public List<String> childfieldNames                                     {get;set;}

    public List<Schema.FieldSetMember> customID_Fields                      {get;set;}
    public List<Schema.FieldSetMember> customID_Fields1                      {get;set;}

    public Map<string, string> descriptionMap                               {get;set;}
    public Map<string, string> headermap                                    {get;set;}
    public Map<string, Integer> lengthMap                                   {get;set;}

    public NewRewardIDController() {
        implId = Apexpages.currentPage().getParameters().get('id');
        errorMessage = '';

        childfieldNames = new List<String>();
        lengthMap = new Map<string,integer>();
        descriptionMap = new Map<String, String>();
        headerMap = new Map<String, String>();
        cust_IDWrapperList = new List<Activity_ID>();

        showOptumPanel = false;

        impl = [select id, account__c, account__r.name, Partner__c from Milestone1_Project__c where ID = : implid];

        Activity_IDWrapperList = new List<Activity_ID>();
        Reward_Activity_ID__c rwa = new Reward_Activity_ID__c();
        Activity_IDWrapperList.add(new Activity_ID(rwa));

        Activity_IDNames = findActivity_IDName();

        if(impl.Partner__c == label.DEFAULT_PARTNER_ID)
            showOptumPanel = true;

        findRewardIDFields();

    }

    public class Activity_ID{
        public Reward_Activity_ID__c activityID {get;set;}

        public Activity_ID(Reward_Activity_ID__c activity){
            this.activityID = activity;
            this.activityID.RecordTypeID = Label.NewRewardIDController_StdRTypeID;
        }

    }

    public void addActivity_IDRow(){
        Reward_Activity_ID__c afnew = new Reward_Activity_ID__c();
        Activity_IDWrapperList.add(new Activity_ID(afnew));
        findActivity_IDName();
    }

    public void removeActivity_ID(){
        integer i = Activity_IDWrapperList.size();
        Activity_IDWrapperList.remove(i-1);
    }

    public class cust_ID{
        public Reward_Activity_ID__c activityID {get;set;}

        public cust_ID(Reward_Activity_ID__c activity){
            this.activityID = activity;
            this.activityID.RecordTypeID = Label.NewRewardIDController_CustomRTypeID;
        }

    }

    public void addCust_IDRow(){
        Reward_Activity_ID__c afnew = new Reward_Activity_ID__c();
        cust_IDWrapperList.add(new Activity_ID(afnew));
        findActivity_IDName();
    }

    public void removeCust_IDRow(){
        integer i = cust_IDWrapperList.size();
        cust_IDWrapperList.remove(i-1);
    }

    public void findRewardIDFields() {

        customID_Fields = new List<Schema.FieldSetMember>();

        customID_Fields = SObjectType.Reward_Activity_ID__c.FieldSets.NewRewardIDController_CustomIDFields.getFields();

        customID_Fields1 = new List<Schema.FieldSetMember>();

        customID_Fields1 = SObjectType.Reward_Activity_ID__c.FieldSets.NewRewardIDController_CustomIDFields1.getFields();
        
        Schema.DescribeSObjectResult DescribeSObjectResultObj = Reward_Activity_ID__c.SObjectType.getDescribe();

        for(Schema.FieldSetMember fsm : customID_Fields){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        for(Schema.FieldSetMember fsm : customID_Fields1){
            childfieldNames.add(fsm.getFieldPath());
            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }

        findFieldDescription(childfieldNames, 'Reward_Activity_ID__c');

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

    public PageReference saveactivityIDs(){

        try{
            newactivityIDs = new List<Reward_Activity_ID__c>();

            for(Activity_ID af : Activity_IDWrapperList){
                system.debug('STD ID IS BEFORE INSERT ' + af.activityID.name);
                
                if(af.activityID.name != null && af.activityID.name != ''){
                    af.activityID.Implementation__c = impl.id;
                    newactivityIDs.add(af.activityID);
                }
            }

            for(Activity_ID af : cust_IDWrapperList){
                system.debug('STD ID IS BEFORE INSERT ' + af.activityID.name);
                
                if(af.activityID.name != null && af.activityID.name != ''){
                    af.activityID.Implementation__c = impl.id;
                    newactivityIDs.add(af.activityID);
                }
            }

            insert newactivityIDs;

            PageReference pg = new PageReference('/'+impl.id);
            pg.setRedirect(true);
            return pg;

        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return null;
        }
    }

    public void findActID(){
    	system.debug('DO WE HAVE AN ACTIVITY ID ' + Apexpages.currentPage().getParameters().get('actID'));
    	system.debug('DO WE HAVE AN INDEX ' + Apexpages.currentPage().getParameters().get('g'));
       
        integer index = integer.valueOf(Apexpages.currentPage().getParameters().get('g'));
        
        system.debug(Activity_IDWrapperList[index].activityID.Name);

        string aid = Activity_IDWrapperList[index].activityID.Name;

        if(affMap.containsKey(aid)){
        	Activity_IDWrapperList[index].activityID.Activity_ID__c = affmap.get(aid).id;
        	Activity_IDWrapperList[index].activityID.Name = affmap.get(aid).name;
        	Activity_IDWrapperList[index].activityID.Activity_Name__c = affmap.get(aid).Activity_Name__c;
        	Activity_IDWrapperList[index].activityID.Main_Activity_ID_Sub_Activities__c = affmap.get(aid).Reward_Sub_Activities__c;
        	Activity_IDWrapperList[index].activityID.Reward_Activity_Type__c = affmap.get(aid).Activity_Type__c;
        }
        else{
        	errorMessage = 'Please find an existing activity ID before selecting.';
        }

        system.debug(Activity_IDWrapperList[index].activityID.Activity_Name__c);
    }

    public set<string> findActivity_IDName() {

        affmap = new Map<String,Activity_ID__c>();

        Activity_IDs = [select id, name, Activity_name__c, Reward_Sub_Activities__c,Incentive_Ownership__c, Activity_Type__c from Activity_ID__c WHERE Partner__c = :impl.Partner__c];
        for(Activity_ID__c af : Activity_IDs){
            affMap.put(af.name,af);
        }

        system.debug('Activity_IDS ARE ' + affMap);
        return affMap.keyset();
    }  
}