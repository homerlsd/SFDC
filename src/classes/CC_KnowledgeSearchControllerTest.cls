@isTest

// @author 7s
// @version Nov 24
// NOTE:
// there are no ways to publish articles and assign Data Categories 
// using SeeAllData = true
// Required to load Knowledge in org to run this test

private class CC_KnowledgeSearchControllerTest {
	
	User testCommunityUser;
	PageReference pageRef;
	CC_KnowledgeSearchController cont; 
	
	private void setUp(){
		pageRef = Page.CC_KnowledgeSearch;
        Test.setCurrentPage(pageRef);
        cont = new  CC_KnowledgeSearchController();
	}
	
	@isTest(SeeAllData=true) static void test_Basic() {
		CC_KnowledgeSearchControllerTest tes = new  CC_KnowledgeSearchControllerTest  ();
	    tes.setUp();
		//tes.testCommunityUser = 
		//CC_TestUtil.createUsers(1, CC_Constants.CUSTOMER_COMMUNITY_PROFILE_NAME)[0];
    	//System.runAs(tes.testCommunityUser){
    	    // Knowledge articles are required in the org
    	    List<CC_KnowledgeSearchController.KnowledgeWrapper> ListOfKnowledge = tes.cont.ListOfKnowledge;
    	    // Since unable to statge test data we don't know how many results are in the org, just call pagenagtion methods
    	    if(tes.cont.TotalPages>1){
    	        System.assert(tes.cont.hasNextSet);
    	        tes.cont.NextSet();
    	        System.assertEquals(tes.cont.SpecifiedPageNumber,2);
    	        System.assertEquals(tes.cont.PageNumber,2);
    	        tes.cont.PrevSet();
    	        System.assertEquals(tes.cont.SpecifiedPageNumber,1);
    	    }else{
    	        Boolean nextSet = tes.cont.hasNextSet;
    	        tes.cont.NextSet();
    	        tes.cont.PrevSet();
    	        Integer pn =tes.cont.PageNumber;
    	    }    	    
    	    System.assert(!tes.cont.hasPrevSet);
    	    Integer rs = tes.cont.ResultsSize;
    	    tes.cont.GoToPage();
    	    
    	    // Test Param
    	    ApexPages.currentPage().getParameters().put('SearchString','Rally');
      	    tes.cont = new CC_KnowledgeSearchController();
            tes.cont.EscapedSearchString = 'Rally';
            tes.cont.findSearchLogID();
            tes.cont.NavigatesToDetail();
            tes.cont.NavigatesToHome();
    	    System.assertEquals('Rally',tes.cont.SearchString);
            // you cannot really test without staging proper test data.
    	    ListOfKnowledge = tes.cont.ListOfKnowledge;
    	    
    	//}
	}
	

	
}