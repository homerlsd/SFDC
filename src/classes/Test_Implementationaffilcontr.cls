@istest(seealldata=false)
public class Test_Implementationaffilcontr {
  //CREATE PAGE TESTS
  @isTest(SeeAllData=false) static void unittest() {  
    Account a = new Account(name='test');
    insert a;

    Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, partner__c=Label.ManageAffiliations_BCBSPartnerID);
    insert imp;
        
    Client_Affiliation__c ca=new Client_Affiliation__c(Name = 'Clientafftest', Implementation__c = imp.Id, Account__c = a.Id);
    insert ca;

    Client_Affiliation__c ca1=new Client_Affiliation__c(Name = 'Clientafftest1', Implementation__c = imp.Id, Account__c = a.Id);
    insert ca1;

    Segmentation_ID__c seg=new Segmentation_ID__c(Client_Affiliation__c=ca.Id, Name='test', Segmentation_Prefix__c='test prefix');
    insert seg;

    Segmentation_ID__c seg2=new Segmentation_ID__c(Client_Affiliation__c=ca.Id, Name='test2', Segmentation_Prefix__c='test prefix2');
    insert seg2; 

     
    Implentationaffiliationcontr impcon=new Implentationaffiliationcontr();
    impcon.Implid=imp.Id;
    impcon.fieldSetName=Label.Test_Implementationaffilcontr_FSName;
    impcon.getobjimp();
    impcon.getpullrelated();
    }
}