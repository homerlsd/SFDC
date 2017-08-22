public class RewardPlanEntryController {
    
    public string impID                                                     								{get;set;}
    public string rPlanid                                                   								{get;set;}
    public string fielddescription                                          								{get;set;}
    public string header                                                    								{get;set;}
    public string pageTitle                                                 								{get;set;}
    
    public boolean showSuccess                                              								{get;set;}

    public Reward_Plan_Design__c rPlan    		                            								{get;set;}
    public List<SelectOption> activityIds                                                                   {get;set;}
    public List<SelectOption> subActivityIds 				              										{get;set;}
    public List<activity> newActivities 				              										{get;set;}

    public List<Schema.FieldSetMember> designFields                            								{get;set;}
    public List<Schema.FieldSetMember> actFields 					         								{get;set;}

    public Map<id, Activity_ID__c> affmap                                             						{get;set;}
    public Map<string, string> descriptionMap                               								{get;set;}
    public Map<string, string> headermap                                    								{get;set;}
    public Map<string, Integer> lengthMap                                   								{get;set;}

    public Attachment att                                                   								{get;set;}
    public Milestone1_Project__c impl                                       								{get;set;}

    public List<String> fieldNames            		                        								{get;set;}
    public List<String> childfieldNames                                     								{get;set;}

    public integer fieldCount                                               								{get;set;}

    public RewardPlanEntryController() {
        impID = Apexpages.currentPage().getParameters().get('impID');

        impl = [select id, Partner__c from Milestone1_Project__c where ID =:impID];

        showSuccess = false;

        fielddescription = '';
        header = '';

        //att = new Attachment();
        activityIds = new List<SelectOption>();
        subActivityIds = new List<SelectOption>();
        fieldNames = new List<String>();
        childfieldNames = new List<String>();

        designFields = new List<Schema.FieldSetMember>();
        actFields = new List<Schema.FieldSetMember>();
        
		newActivities = new List<activity>();
        affmap = new Map<id,Activity_ID__c>();
        lengthMap = new Map<string,integer>();
        descriptionMap = new Map<String, String>();
        headerMap = new Map<String, String>();

        pageTitle = 'Rally Rewards Order Form';

        findObjfields();
        findActivityFields();

        rPlan = new Reward_Plan_Design__c(implementation__c = impl.id,recordTypeID=Label.RewardPlanEntryController_BCBSSCRtype);
        newActivities.add( new Activity( new Reward_Plan_Activity__c(recordTypeID=Label.NewRewardIDController_StdRTypeID, implementation__c = impl.id)));
        findActivity_IDs();
        findSubActivity_IDs();

        system.debug('WHAT ARE THE ACTIVITY IDS ' + activityIds);

    }

    public void findObjfields() {

        Schema.DescribeSObjectResult DescribeSObjectResultObj = Reward_Plan_Design__c.SObjectType.getDescribe();
        designFields = new List<Schema.FieldSetMember>();

        designFields = SObjectType.Reward_Plan_Design__c.FieldSets.Reward_Plan_Entry.getFields();

        system.debug('OBJECT FIELDS ' + designFields);

        for(Schema.FieldSetMember fsm : designFields){
            fieldNames.add(fsm.getFieldPath());
            
            system.debug('FIELD NAME IS ' + fsm.getFieldPath());
            system.debug('FIELD DESCRIBE IS ' + DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe());

            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }
        
        findFieldDescription(fieldNames,'Reward_Plan_Design__c');

    }

    public void findActivityfields() {

        Schema.DescribeSObjectResult DescribeSObjectResultObj = Reward_Plan_Activity__c.SObjectType.getDescribe();
        actFields = new List<Schema.FieldSetMember>();

        actFields = SObjectType.Reward_Plan_Activity__c.FieldSets.Reward_Plan_Entry.getFields();

        system.debug('OBJECT FIELDS ' + actFields);

        for(Schema.FieldSetMember fsm : actFields){
            childfieldNames.add(fsm.getFieldPath());
            
            system.debug('FIELD NAME IS ' + fsm.getFieldPath());
            system.debug('FIELD DESCRIBE IS ' + DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe());

            Schema.DescribeFieldResult TestField = DescribeSObjectResultObj.Fields.getMap().get(fsm.getFieldPath()).getDescribe();
            lengthMap.put(fsm.getFieldPath(),TestField.getLength());
        }
        
        findFieldDescription(childfieldNames,'Reward_Plan_Activity__c');

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

    public List<selectOption> findActivity_IDs() {

        activityIds.add(new selectOption(impl.id,'--Select ID--'));
        activityIds.add(new selectOption(impl.Partner__c, 'New/Custom ID'));
        
        for(Activity_ID__c af : [select id, name, Activity_name__c, Reward_Sub_Activities__c,Incentive_Ownership__c, Activity_Type__c from Activity_ID__c WHERE Active__c = true AND Partner__c = :impl.Partner__c]){
            affmap.put(af.id, af);
            activityIds.add(new selectOption(af.id,af.name));
        }

        system.debug('Activity_IDS ARE ' + activityIds);
        return activityIds;
    }  

    public List<selectOption> findSubActivity_IDs() {

        subActivityIds.add(new selectOption(impl.id,'--Select ID--'));
        
        for(Activity_ID__c af : [select id, name, Activity_name__c, Reward_Sub_Activities__c,Incentive_Ownership__c, Activity_Type__c from Activity_ID__c WHERE Active__c = true AND Partner__c = :impl.Partner__c]){
            affmap.put(af.id, af);
            subActivityIds.add(new selectOption(af.id,af.name));
        }

        system.debug('Sub Activity_IDS ARE ' + subActivityIds);
        return subActivityIds;
    }  

     public class activity{
        public Reward_Plan_Activity__c rpActivity {get;set;}
        public List<Sub_Activity_ID__c> subIds {get;set;}

        public activity(Reward_Plan_Activity__c rpActivity){
            this.rpActivity = rpActivity;
            subIds = new List<Sub_Activity_ID__c>();
            for(Integer i=1; i <= 4; i++){
             	subIds.add(new Sub_Activity_ID__c());
            }
        }
    }

    public void addActivityID(){
        system.debug('NEW ACTIVITY SIZE BEFORE IS ' + newActivities.size());
        newActivities.add( new Activity( new Reward_Plan_Activity__c(recordTypeID=Label.NewRewardIDController_StdRTypeID, implementation__c = impl.id)));
        system.debug('NEW ACTIVITY SIZE AFTER IS ' + newActivities.size());
    }

    public void removeActivity_ID(){
        integer i = newActivities.size();
        newActivities.remove(i-1);
    }

    public void submitResults(){
    	Map<ID, List<Sub_Activity_ID__c>> newRPAMap  = new Map<ID, List<Sub_Activity_ID__c>>();
    	List<Reward_Plan_Activity__c> newRPAs = new List<Reward_Plan_Activity__c>();
    	List<Sub_Activity_ID__c> newSubs  = new List<Sub_Activity_ID__c>();

        for(schema.fieldsetmember fm : designFields){
            string tempField = fm.getFieldPath();
            if(tempField.contains('DateString__c')){
                system.debug('DATE VALUE IS ' + String.valueOf(rPlan.get(tempField)));
                string dt = String.valueOf(rPlan.get(tempField));
                if(dt != null && dt != ''){
                    String[] str = dt.split('/');
                    date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                    string dateFieldPath = tempField.remove('String__c');
                    dateFieldPath = dateFieldPath + '__c';
                    try {
                        rPlan.put(dateFieldPath,dtTemp);
                    } catch (Exception ex) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error saving record - please remove and email jon.wu@rallyhealth.com with the following message:' + ex.getMessage()));
                        return;
                    }
                }
            }
        }
    	
        try{
    		insert rPlan;
    	}
    	catch(exception ex){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
    	}

        for(schema.fieldsetmember fm : actFields){
            string tempField = fm.getFieldPath();
            if(tempField.contains('DateString__c')){
                for(activity act : newActivities){
                    system.debug('DATE VALUE IS ' + String.valueOf(act.rpActivity.get(tempField)));
                    string dt = String.valueOf(act.rpActivity.get(tempField));
                    if(dt != null && dt != ''){
                        String[] str = dt.split('/');
                        date dtTemp = date.newInstance(integer.valueOf(str[2]),integer.valueOf(str[0]),integer.valueOf(str[1]));
                        string dateFieldPath = tempField.remove('String__c');
                        dateFieldPath = dateFieldPath + '__c';
                        try {
                            act.rpActivity.put(dateFieldPath,dtTemp);
                        } catch (Exception ex) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error saving record - please remove and email jon.wu@rallyhealth.com with the following message:' + ex.getMessage()));
                            return;
                        }
                    }
                }
            }
        }

    	for(Activity a : newActivities){
    		if(a.rpActivity.Activity_ID__c != impl.id){
                
                if(a.rpActivity.Activity_ID__c == impl.Partner__c){
                    a.rpActivity.Activity_ID__c = null;
                    a.rpActivity.recordTypeID = Label.RewardPlanEntryController_CustomRplanID;
                }

    			a.rpActivity.Reward_Plan_Design__c = rPlan.id;
    			newRPAs.add(a.rpActivity);
    			newRPAMap.put(a.rpActivity.Activity_ID__c,a.subIds);
    		}
    	}

        try{
            insert newRPAs;
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
        }
    	

    	for(Reward_Plan_Activity__c rpa : [select id, Activity_ID__c from Reward_Plan_Activity__c where ID IN : newRPAs]){
    		for(Sub_Activity_ID__c sub : newRPAMap.get(rpa.Activity_ID__c)){
    			system.debug('DO WE GET INTO THE SUB ACTIVITY IDS ' + sub);
    			if(sub.Activity_ID__c != impl.id){
    				sub.Reward_Plan_Activity__c = rpa.id;
    				newSubs.add(sub);
    			}
    		}
    	}


    	if(!newSubs.isEmpty()){
            try{
                insert newSubs;
            }
            catch(exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
                return;
            }
        }

        Reward_Plan_Design__c[] rplan2 = [select id, Record_Submitted__c from Reward_Plan_Design__c where ID =: rPlan.id];
        rplan2[0].Record_Submitted__c = true;
        update rplan2;

    	showSuccess = true;
    }
}