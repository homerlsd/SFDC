@istest(seealldata=false)
public class Test_RewardReceipt {
  //CREATE PAGE TESTS
  @isTest(SeeAllData=false) static void unittest() {  
    Account a = new Account(name='test');
    insert a;

    Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, partner__c=Label.ManageAffiliations_BCBSPartnerID);
    insert imp;
        
    Reward_Plan_Design__c ca=new Reward_Plan_Design__c(Name = 'Clientafftest', Implementation__c = imp.Id);
    insert ca;

    Reward_Plan_Activity__c act=new Reward_Plan_Activity__c(Reward_Plan_Design__c = ca.Id, Name='testy');
    insert act;
     
    RewardReceiptController rrec =new RewardReceiptController();
    rrec.rewardPlanid = ca.id;
    rrec.fieldSetName=Label.Test_RewardReceiptFSName;
    rrec.getobjpPlan();
    rrec.getActivityDetails();
    }
}