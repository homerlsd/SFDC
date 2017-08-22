@isTest
private class CC_SupportHomeControllerTest {
	
    User testCommunityUser;
	PageReference pageRef;
	CC_SupportHomeController cont; 
	
	private void setUp(){
		pageRef = Page.CC_SupportHome;
        Test.setCurrentPage(pageRef);
        
	}
	
	@isTest(SeeAllData=true) static void test_Basic() {
		CC_SupportHomeControllerTest tes = new  CC_SupportHomeControllerTest  ();
	    tes.setUp();
		//tes.testCommunityUser = 
		//CC_TestUtil.createUsers(1, CC_Constants.CUSTOMER_COMMUNITY_PROFILE_NAME)[0];
    	//System.runAs(tes.testCommunityUser){
    	    // Knowledge articles are required to run this test
    	    // Data Categories are required to conifigure in the org
    	    tes.cont = new  CC_SupportHomeController();
    	    System.assert(tes.cont.BrowseByTopics.size()>0);
    	    System.assert(tes.cont.CommonQuestions!=null);
    	    
    	    // test navigates
    	    
    	    tes.cont.TargetKnowledgeId='12345';
    	    tes.cont.TargetDataCategoryName = 'General';
    	    tes.cont.TargetDataCategoryLabel='General';
    	    
    	    PageReference p = tes.cont.NavigatesToDetail();
            System.assertEquals('/CC_KnowledgeDetail?DataCategoryGroupName='+EncodingUtil.urlEncode(Label.CC_Default_Group_Name,'UTF-8')+'&KnowledgeId='+'12345',p.getURL());
            
            p=tes.cont.NavigatesToKnowlegeByDataCat();
            System.assertEquals('/CC_KnowledgeByDataCategory?DataCategoryGroupName='+EncodingUtil.urlEncode(Label.CC_Default_Group_Name,'UTF-8')+'&DataCategoryName='+ tes.cont.TargetDataCategoryName ,p.getURL());

        //}
	}
}