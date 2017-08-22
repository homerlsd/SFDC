@IsTest
public class Test_AccountHeader {
    
    @IsTest(seealldata=false)
    public static void testheader() {
        Account a = new Account(name='test');
        insert a;

        Contact c = new Contact(lastname='test',email='test2123@sdf.com');
        insert c;

        Sales_Channel__c ch = new Sales_Channel__c(name='Choice',Approved_Record_Type_Name__c = 'Choice Approved', Unapproved_Record_Type_Name__c = 'Choice', Case_Record_Type_Name__c = 'Choice');
        insert ch;
        
        AccountContactRole ac = new AccountContactRole(Contactid = c.id,isPrimary=true,accountid = a.id, role='test');
        insert ac;

        Opportunity op = new Opportunity(stagename='test',recordtypeid=Label.Rally_Choice_Record_Type_ID,accountid=a.id,name='test',closedate=date.today());
        insert op;

        OpportunityContactRole oc = [select id from OpportunityContactRole where Contactid = :c.id];
        system.assert(oc != null);

        AccountHeader ach = new AccountHeader(new ApexPages.StandardController(a));
        
    }
}