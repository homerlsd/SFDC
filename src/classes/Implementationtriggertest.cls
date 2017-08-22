@isTest
private class Implementationtriggertest {
    
    @isTest(seealldata=false)
    static void test_method_one() {
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='Optum',partner_string__c='Optum');
        insert p;

        Sales_Channel__c sc = new Sales_Channel__c(Approved_Record_Type_Name__c = 'Engage Approved', Unapproved_Record_Type_Name__c = 'Engage', Case_Record_Type_Name__c = 'Engage', Name='Engage');
         insert sc;

        RecordType rt = [select id from RecordType where name = 'Engage - Optum' and sObjectType = 'Milestone1_Project__c'];

        Milestone1_Project__c imp=new Milestone1_Project__c(Name='imp test', Account__c=a.Id, Partner__c=p.ID, RecordTypeId=rt.id);
        insert imp;

        Policy_number__c pl = new Policy_number__c(name='policy123', implementation__c = imp.id);
        insert pl;

        Milestone1_Project__c impNew = [select Policy_Numbers_DHP__c, id from Milestone1_Project__c where ID = : imp.id];
        
        impNew.Policy_Numbers_DHP__c = 'policy123;policy124;';
        
        update impNew;

    }
}