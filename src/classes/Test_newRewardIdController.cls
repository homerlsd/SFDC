@istest(seealldata=false)
public class Test_newRewardIdController {
  //CREATE PAGE TESTS
  @isTest(SeeAllData=false) static void unittest() {  
    
    Account a = new Account(name='test');
    insert a;

    Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, partner__c=Label.DEFAULT_PARTNER_ID);
    insert imp;
    
    Activity_Id__c actid = new Activity_Id__c(Name='something', Activity_name__c='testactivity', Reward_Sub_Activities__c='testreward', Incentive_Ownership__c='Optum Incentives Engine', Activity_Type__c='Bundle', Partner__c = Label.DEFAULT_PARTNER_ID );
    insert actid;
    
    PageReference pageRef = page.NewRewardID;
        pageRef.getParameters().put('id', imp.id);
        Test.setCurrentPage(pageRef);

        NewRewardIDController  cont = new NewRewardIDController ();
        
        cont.Activity_IDWrapperList [0].activityID.name = 'something';
        System.assertEquals(true,cont.showOptumPanel);
        cont.addActivity_IDRow();
        cont.removeActivity_ID();
        cont.addCust_IDRow();
        cont.saveactivityIDs();
        cont.removeCust_IDRow();
        pageRef.getParameters().put('g','0');
        cont.findActID();
  }
}