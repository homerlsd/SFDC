@isTest
private class CC_UrlRewriterTest {
	CC_UrlRewriter ur = new CC_UrlRewriter();
	
	@isTest static void test_mapRequestUrl() {
	    CC_UrlRewriterTest tes = new CC_UrlRewriterTest();
	    // test data cat
		PageReference pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.DATACAT_PAGE+'General/General'));
		System.assertEquals( '/CC_KnowledgeByDataCategory?DataCategoryGroupName=General&DataCategoryName=General',pr.getUrl());
        // test detail
        pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.DETAIL_PAGE+'1234/General'));
		System.assertEquals( '/CC_KnowledgeDetail?DataCategoryGroupName=General&KnowledgeId=1234',pr.getUrl());
		 // test search results
        pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.SEARCH_RESULTS_PAGE+'?SearchString=Rally&DataCategoryGroupName=General'));
		System.assertEquals( '/CC_KnowledgeSearch?DataCategoryGroupName=Rally&SearchString=General',pr.getUrl());
		 // test case thankyou 
        pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.CASE_THANKYOU_PAGE+'true/General'));
		System.assertEquals(  '/CC_SupportCase?DataCategoryGroupName=General&thankyou=true',pr.getUrl());
		// test create case 
        pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.CREATE_CASE_PAGE+'General'));
		System.assertEquals( '/CC_SupportCase?DataCategoryGroupName=General',pr.getUrl());
                //test choice home
        pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.CHOICE_HOME_PAGE));
                System.assertEquals( '/CC_SupportHome?channel=choice',pr.getUrl());
		// test home
        pr = tes.ur.mapRequestUrl(new PageReference(CC_UrlRewriter.HOME_PAGE));
		System.assertEquals( '/CC_SupportHome',pr.getUrl());
	}
	
	@isTest static void test_generateUrlFor() {
         CC_UrlRewriterTest tes = new CC_UrlRewriterTest();
         List<PageReference> mySfdcUrl = new  List<PageReference> ();
         mySfdcUrl.add (new PageReference('/CC_KnowledgeByDataCategory?DataCategoryName=General&DataCategoryGroupName=General'));
         mySfdcUrl.add (new PageReference('/CC_KnowledgeDetail?KnowledgeId=1234&DataCategoryGroupName=General'));
         mySfdcUrl.add (new PageReference( '/CC_KnowledgeSearch?SearchString=Rally&DataCategoryGroupName=General'));
         mySfdcUrl.add (new PageReference( '/CC_SupportCase?thankyou=true&DataCategoryGroupName=General')); 
         mySfdcUrl.add (new PageReference('/CC_SupportCase')); 
         
         PageReference[] prs = tes.ur.generateUrlFor(mySfdcUrl);
         // data cat
         System.assertEquals( '/datacat/General/General',prs[0].getUrl());
         // detail
         System.assertEquals( '/detail/id1234/General',prs[1].getUrl());
         //search results
         System.assertEquals( '/results/Rally/General',prs[2].getUrl());
         //case thank you
         System.assertEquals( '/case/thankyou/true/General',prs[3].getUrl());
         //create case 
         System.assertEquals( '/case/',prs[4].getUrl());
         
	}
	
}