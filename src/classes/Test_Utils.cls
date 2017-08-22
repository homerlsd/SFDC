@istest
public class Test_Utils {
	
	@istest(seealldata=false)
	static void testError() {
		account a = new account(name='Wayne Enterprises');
		insert a;

		List<Utils.ApexError> aes = new List<Utils.ApexError>();
		Utils.ApexError ae = new Utils.ApexError();
		
		ae.recordID = a.id; 
        ae.pageOrProcess = 'Some page';
        ae.userId = UserInfo.getUserId();  
        ae.errorString = 'TEST ERROR STRING';
        ae.timeStamp = date.today();
        aes.add(ae);

		Utils.addSingleErrorLog(aes);
		
		System_Log__c eCheck = [select id, Object_Type__c from System_Log__c where Record_ID__c = : a.id];
		System.assert(echeck != null);
		system.assertEquals('Account',eCheck.Object_Type__c);
	}
}