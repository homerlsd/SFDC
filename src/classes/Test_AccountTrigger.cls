@istest
public class Test_AccountTrigger {
	
	@istest(seealldata=false)
	public static void Test_insert() {
		Account a = new Account(name = 'test', Direct_Link__c = 'http://werally.com/partner/optum/queen_consolidated/register');
		insert a;

		Account a2 = [select id, External_Client_String__c from Account where ID = :a.id];

		system.assertEquals('queen_consolidated', a2.External_Client_String__c);
	}

	@istest(seealldata=false)
	public static void Test_badinsert() {
		Account a = new Account(name = 'test', Direct_Link__c = 'http://werally.com/partner/optum/queen_consolidated/register/etc');
		insert a;

		Account a2 = [select id, External_Client_String__c from Account where ID = :a.id];

		system.assertEquals('Bad Direct Registration URL', a2.External_Client_String__c);
	}
	
	@istest(seealldata=false)
	public static void Test_Update() {
		Account a = new Account(name = 'test', Direct_Link__c = 'http://werally.com/partner/optum/wayne_enterprises/register');
		insert a;

		Account a2 = [select id, External_Client_String__c, Direct_Link__c from Account where ID = :a.id];

		a2.Direct_Link__c = 'http://werally.com/partner/optum/stark_enterprises/register';
		update a2;

		Account a3 = [select id, External_Client_String__c, Direct_Link__c from Account where ID = :a.id];

		system.assertEquals('stark_enterprises', a3.External_Client_String__c);
	}
}