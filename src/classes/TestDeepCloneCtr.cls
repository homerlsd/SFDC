@IsTest
public class TestDeepCloneCtr{

    static testMethod void unittest() {
    
        Account acc=new Account(Name='test Account');
        insert acc;
        
        Contact con=new Contact(FirstName='test', AccountId=acc.Id, LastName='last');
        insert con;
        
        Case cs=new Case(OwnerId=UserInfo.getUserId(), Origin='Email', status='New', Issue_Bug__c='Challenges', RecordTypeId='012E0000000g2LV');
        insert cs;
        
        ApexPages.StandardController sc = new ApexPages.standardController(acc) ;
        DeepCloneCtrl dpct = new DeepCloneCtrl(sc);
        
        
        dpct.deepClone();
    }
}