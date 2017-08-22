public class RewardReceiptController {
	public Id rewardPlanid{get; set;}
	public string fieldSetName {get;set;}

	public List<Schema.FieldSetMember> getpPlanFields() {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Reward_Plan_Design__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }

    public List<Schema.FieldSetMember> getpActivityFields() {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Reward_Plan_Activity__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(Label.RewardReceiptController_ActivityFieldSetName);
        return fieldSetObj.getFields();
    }
	
	public Reward_Plan_Design__c getobjpPlan(){
		system.debug('rewardPlanId' +rewardPlanId);
		Reward_Plan_Design__c objpPlan = new Reward_Plan_Design__c();

		 //DYNAMIC CASE QUERY WORK
        List<string> pPlanStandardFieldList = new List<string>{'id'};
        string queryString_pPlan = '';
        
        for(Schema.FieldSetMember fsm: this.getpPlanFields()){
            pPlanStandardFieldList.add(fsm.getfieldPath());
        }

        // Add to set to de-dup field listing
        Set<string> fieldSet_pPlan = new Set<string>();
        for(string s: pPlanStandardFieldList){
            fieldSet_pPlan.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList_pPlan = new List<string>(fieldSet_pPlan);
        for (Integer i=0; i<fieldList_pPlan.size(); i++) {
            if(i == 0) {
                    queryString_pPlan = 'select ' + fieldList_pPlan[i];
            } else {
                    queryString_pPlan += ', ' + fieldList_pPlan[i];
            }
        }

        queryString_pPlan += ' from Reward_Plan_Design__c where ID = \'' + rewardPlanid +'\'';

        system.debug('QUERY pPlan FIELDS ARE ' + queryString_pPlan);

        objpPlan = Database.query(queryString_pPlan);

		//objpPlan=[select Business_Sector_Segment__c, CES_Client_Number__c, Client_Preferred_Name__c, Client_Book_of_Business__c, Client_Legal_Name__c, Client_Type__c, Sales_Package__c, Rally_rewardPlanementation_Start_Date__c, Employees__c, Total_Membership__c, Incentives_Package__c, Incentive_Plan_Start_Date__c, Survey_Reset__c, Survey_Reset_Date__c, Campaign__c, Private_Challenges__c, Public_Communities_Off__c, Private_Communities__c, Public_Sweepstakes_Off__c, Private_Sweepstakes__c, Donations__c, Private_Donations__c, Additional_Custom_Configuration_Detail__c, External_Comments__c from Reward_Plan_Design__c where Id=:rewardPlanid];
		system.debug('objpPlan' +objpPlan);
		return objpPlan;
	}
	
	public List<Reward_Plan_Activity__c> getActivityDetails(){
	
		system.debug('Activity Field Set' + Label.RewardReceiptController_ActivityFieldSetName);
		Reward_Plan_Activity__c[] planActivitys = new List<Reward_Plan_Activity__c>();

		//DYNAMIC CASE QUERY WORK
        List<string> pPlanStandardFieldList = new List<string>{'id','name'};
        string queryString_pPlan = '';
        
        for(Schema.FieldSetMember fsm: this.getpActivityFields()){
            pPlanStandardFieldList.add(fsm.getfieldPath());
        }

        // Add to set to de-dup field listing
        Set<string> fieldSet_pPlan = new Set<string>();
        for(string s: pPlanStandardFieldList){
            fieldSet_pPlan.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList_pPlan = new List<string>(fieldSet_pPlan);
        for (Integer i=0; i<fieldList_pPlan.size(); i++) {
            if(i == 0) {
                    queryString_pPlan = 'select ' + fieldList_pPlan[i];
            } else {
                    queryString_pPlan += ', ' + fieldList_pPlan[i];
            }
        }

        queryString_pPlan += ' from Reward_Plan_Activity__c where Reward_Plan_Design__c = \'' + rewardPlanid +'\'';

        system.debug('QUERY ACTIVITY FIELDS ARE ' + queryString_pPlan);

        planActivitys = Database.query(queryString_pPlan);

		//planActivitys=[select Business_Sector_Segment__c, CES_Client_Number__c, Client_Preferred_Name__c, Client_Book_of_Business__c, Client_Legal_Name__c, Client_Type__c, Sales_Package__c, Rally_rewardPlanementation_Start_Date__c, Employees__c, Total_Membership__c, Incentives_Package__c, Incentive_Plan_Start_Date__c, Survey_Reset__c, Survey_Reset_Date__c, Campaign__c, Private_Challenges__c, Public_Communities_Off__c, Private_Communities__c, Public_Sweepstakes_Off__c, Private_Sweepstakes__c, Donations__c, Private_Donations__c, Additional_Custom_Configuration_Detail__c, External_Comments__c from Reward_Plan_Design__c where Id=:rewardPlanid];
		system.debug('planActivitys' +planActivitys);
		return planActivitys;
	}
}