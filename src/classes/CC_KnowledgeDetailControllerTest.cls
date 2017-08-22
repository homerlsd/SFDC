@isTest
// @author 7s
// @version Nov 24
// NOTE:
// there are no ways to publish articles and assign Data Categories 
// using SeeAllData = true
// Required to load Knowledge in org to run this test
private class CC_KnowledgeDetailControllerTest {
	
User testCommunityUser;
	PageReference pageRef;
	CC_KnowledgeDetailController cont; 
	
	private void setUp(){
		pageRef = Page.CC_KnowledgeDetail;
        Test.setCurrentPage(pageRef);
	}
	
	@isTest(SeeAllData=true) static void test_Basic() {
	    
	   CC_KnowledgeDetailControllerTest tes = new  CC_KnowledgeDetailControllerTest  ();
	   tes.setUp();
       // assumption this must return records
       List<Question__kav> kv= [SELECT Id,category__c,title,summary, UrlName, LastPublishedDate,LastModifiedById FROM Question__KAV WHERE (PublishStatus = 'online' and Language = 'en_US')];
	   System.assert(kv.size()>0);
	   if(kv.size()>0){
	        ApexPages.currentPage().getParameters().put('KnowledgeId',kv[0].Id);
	        tes.cont = new  CC_KnowledgeDetailController();
	    	System.assert(!String.isEmpty(tes.cont.DataCategoryName));
	        System.assert(!String.isEmpty(tes.cont.LastPublishedDate));
	        System.assert(tes.cont.Article!=null);
	        
	        PageReference p = tes.cont.NavigatesToHome();

	        String testLabel = CC_Constants.DEFAULT_GROUP_NAME.replace(' ','+');
            System.assertEquals('/?DataCategoryGroupName='+testLabel,p.getURL());
            
            p = tes.cont.NavigatesToKnowlegeByDataCat();
            System.assertEquals('/CC_KnowledgeByDataCategory?DataCategoryGroupName=' + testLabel + '&DataCategoryName='+ EncodingUtil.urlEncode(tes.cont.DataCategoryName, 'UTF-8'),p.getURL());

	   }	    
	}
}