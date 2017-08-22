public with sharing class CC_TestUtil {
	
/**

date        11/20/2014
description
create list of test users

*/

	public static List<User> createUsers(Integer howMany,String profileName){
			 
			 //Added by Alex Roth 06/11/15 to get through some test errors, will refactor eventually
			 userrole uRole  = [ select id from userrole where name = 'System Administrator'];
			 profile admin  = [ select id from profile where name = 'System Administrator'];
			 Id profileId;
			 // to make user unique
			 String type; 

			 if(profileName == CC_Constants.CUSTOMER_COMMUNITY_PROFILE_NAME){
			    profileId = CC_Constants.CUSTOMER_COMMUNITY_PROFILE_Id;
			 	type = 'com';
			 } 
	         
	         User u_admin = new User(alias = 'u_admin', email='testtest@test.com',
		            emailencodingkey='UTF-8', lastname='Test_admin' + type, languagelocalekey='en_US',
		            localesidkey='en_US', profileid = admin.id, userroleid = urole.id,
		            timezonesidkey='America/Los_Angeles', username='test@testtest_admin.com.' + type);

	    	 insert u_admin;

	    	 //system.runAs(u_admin){

				 List<User> listOfUsers = new List<User>();
		         for (Integer i = 0; i < howMany; i++){
		             
			         User u = new User(alias = 'u' + type +i , email='testtest@test.com',
			            emailencodingkey='UTF-8', lastname='Test' + type +i, languagelocalekey='en_US',
			            localesidkey='en_US', profileid = profileId,
			            timezonesidkey='America/Los_Angeles', username='test@testtest.com.' + type + i,ContactId=createContact(u_admin.id).Id);

			         listOfUsers.add(u);
			     }
			     insert listOfUsers;
			 return listOfUsers;
			//}
	}
	static Account createAccount(id adminID){
	    Account a = new Account(Name='testAcct', ownerid = adminID);
	    insert a;
	    return a;
	}
	static Contact createContact(id adminID){
	    Contact c = new Contact(LastName='test',AccountId = createAccount(adminID).id );
	    insert c;
	    return c;
	        
	}
	public static Sales_Channel__c createSC(){
		Sales_Channel__c sc = new Sales_Channel__c(Approved_Record_Type_Name__c = 'Engage Approved', Unapproved_Record_Type_Name__c = 'Engage', Case_Record_Type_Name__c = 'Engage');
 		insert sc;
 		return sc;
	}
	public static Case createCase(){
	    case c = new case(Subject='test',recordtypeID=CC_Constants.DEFAULT_CASE_RECORDTYPE_ID);
	    insert c;
	    return c;   
	}
}