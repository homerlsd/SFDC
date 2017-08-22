@istest
public class Test_ClientAffiliationTriggerHandler {

    @istest(seealldata=false)
    static void TestClientAffil_after() {
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='Optum',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id, RecordTypeId=label.Optum_Engage_Implementation_Rtype_ID);
        insert imp;
        
        Client_Affiliation__c ca = new Client_Affiliation__c(account__c=a.id,Implementation__c=imp.id,Production_Affiliation_String__c = 'test', name='soemfsdsd',Affiliation_Roles__c='Coaching');
        insert ca;

        Client_Affiliation__c ca1 = new Client_Affiliation__c(account__c=a.id,Implementation__c=imp.id,name='soemfsdsddsfsdsdfd',Affiliation_Roles__c='Coaching');
        insert ca1;
        
        Client_Affiliation__c ca2 = new Client_Affiliation__c(account__c=a.id,Implementation__c=imp.id,name='soemfsdsddsfbgbgbg',Affiliation_Roles__c='Survey Reset');
        insert ca2;
        
        Client_Affiliation__c ca3 = new Client_Affiliation__c(account__c=a.id,Implementation__c=imp.id,name='soemfsdsddsfababab',Affiliation_Roles__c='Public Communities Ineligible');
        insert ca3;

        Milestone1_Project__c imp2 = [select id, Wellness_Coaching_Affiliations__c from Milestone1_Project__c where ID = :imp.id];

        system.assert(imp2.Wellness_Coaching_Affiliations__c != null);
    }
}