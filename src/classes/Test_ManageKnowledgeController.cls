@isTest
private class Test_ManageKnowledgeController {
	
	@isTest(SeeAllData=true) static void test_view() {
		Knowledge_Group__c kg = [select id, name, group_name__c from Knowledge_Group__c where ID =: CC_Constants.DEFAULT_GROUP_ID];
		PageReference pageRef = Page.ManageKnowledge;
	    pageRef.getParameters().put('id',kg.id);
		Test.setCurrentPage(pageRef);
		
		ManageKnowledgeController tes = new  ManageKnowledgeController ();
	    
		System.assertEquals(1,tes.newGroupArticles.size());
		
		tes.newGroupArticles[0].selectedArticleLine = 'someIDFORFAKE';

		tes.saveNewStuff();

		tes.newGroupArticles.clear();

		tes.saveNewStuff();
	}

	@isTest(SeeAllData=true) static void test_add1() {
		Knowledge_Group__c kg = [select id, name, group_name__c from Knowledge_Group__c where ID =: CC_Constants.DEFAULT_GROUP_ID];
		PageReference pageRef = Page.ManageKnowledge;
	    pageRef.getParameters().put('id',kg.id);
		Test.setCurrentPage(pageRef);
		
		ManageKnowledgeController tes = new  ManageKnowledgeController ();
	    
		System.assertEquals(1,tes.newGroupArticles.size());

		tes.addNewGA();
		tes.removeLastGA();

		tes.Beginning();
		tes.Next();
		tes.Previous();
		tes.End();
		tes.getDisableNext();
		tes.getDisablePrevious();
		tes.getTotal_size();
		tes.getPageNumber();
		tes.getTotalPages();
		
		tes.saveNewStuff();

		tes.newGroupArticles.clear();

		tes.saveNewStuff();
	}

	@isTest(SeeAllData=false)static void testCCConstants(){
		ID testId = CC_Constants.CUSTOMER_COMMUNITY_PROFILE_Id;
		system.assert(testid != null);
	}
}