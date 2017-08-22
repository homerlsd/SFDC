@istest
public class Test_SubIDHandler {
	
	@istest(seealldata=false)
    static void TestClientAffil_after() {
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='Optum',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;
        
        Reward_Plan_Activity__c rpa = new Reward_Plan_Activity__c(name='testy');
        insert rpa;

        Activity_Id__c idone = new Activity_Id__c(name='someid123', Partner__c = p.id);
        insert idone;

        Sub_Activity_Id__c sub = new Sub_Activity_Id__c(Activity_Id__c = idone.id, Reward_Plan_Activity__c = rpa.id);
        insert sub;

        Reward_Plan_Activity__c rpa2 = [select id, Sub_Activity_Info__c from Reward_Plan_Activity__c where id = : rpa.id];
        system.assert(rpa2.Sub_Activity_Info__c != null);

        Milestone1_Project__c imp2 = [select id, Post_Approval_Change_Control__c, Initial_Approval_Date__c from Milestone1_Project__c where ID = :imp.id];
        imp2.Initial_Approval_Date__c = date.today();
        imp2.Post_Approval_Change_Control__c = 'test';
        update imp2;
        
    }

    @istest(seealldata=false)
    static void TestClientAffil_afterDel() {
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='Optum',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;
        
        Reward_Plan_Activity__c rpa = new Reward_Plan_Activity__c(name='testy');
        insert rpa;

        Activity_Id__c idone = new Activity_Id__c(name='someid123', Partner__c = p.id);
        insert idone;

        Sub_Activity_Id__c sub = new Sub_Activity_Id__c(Activity_Id__c = idone.id, Reward_Plan_Activity__c = rpa.id);
        insert sub;

        Reward_Plan_Activity__c rpa2 = [select id, Sub_Activity_Info__c from Reward_Plan_Activity__c where id = : rpa.id];
        system.assert(rpa2.Sub_Activity_Info__c != null);

        delete sub;

        Reward_Plan_Activity__c rpa3 = [select id, Sub_Activity_Info__c from Reward_Plan_Activity__c where id = : rpa.id];
        system.assert(rpa3.Sub_Activity_Info__c == null);

        
    }
}