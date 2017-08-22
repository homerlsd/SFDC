@istest
public class Test_Utils_Support {
	
	@istest(seealldata=false)
	static void testAll() {
		system.assertEquals('January',Utils_Support.MonthMap().get(1));
		system.assertEquals('December',Utils_Support.MonthMap().get(12));

		userrole uRole  = [ select id,name from userrole where name = 'CSR Associate'];
		profile admin  = [ select id from profile where name = 'System Administrator'];
		
		User u_admin = new User(alias = 'u_admin', email='testtest@test.com',
		            emailencodingkey='UTF-8', lastname='Test_supportutils', languagelocalekey='en_US',
		            localesidkey='en_US', profileid = admin.id, userroleid = urole.id,
		            timezonesidkey='America/Los_Angeles', username='test@Test_supportutils.com', Annual_Cost__c = 100);

	    	 insert u_admin;

	   	Map<Decimal,Integer> mappy = Utils_Support.getCost( new List<String>{string.valueOf(userrole.name)});

	}
}