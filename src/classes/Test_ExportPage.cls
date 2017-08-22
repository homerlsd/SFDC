@IsTest
public class Test_ExportPage {
    
    @IsTest(seealldata=false)
    public static void testExport() {
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='optum',partner_string__c='testp');
        insert p;

        Sales_Channel__c sc = new Sales_Channel__c(Approved_Record_Type_Name__c = 'Engage Approved', Unapproved_Record_Type_Name__c = 'Engage', Case_Record_Type_Name__c = 'Engage', Name='Engage');
         insert sc;

        Milestone1_Project__c imp=new Milestone1_Project__c(Name='imp test', Account__c=a.Id, Partner__c=p.ID);
        insert imp;

        Challenge_Requirement__c tc = new Challenge_Requirement__c(Implementation__c = imp.id, RecordTypeID=label.ChallengeRequirement_TeamRTID);
        insert tc;

        ExportClass exp = new ExportClass(new ApexPages.StandardController(imp));

        exp.export();
        
    }
}