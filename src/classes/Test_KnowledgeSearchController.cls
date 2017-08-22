@istest
private class Test_KnowledgeSearchController {

	@isTest(SeeAllData=true) static void test_basicSearch() {

		case test_c = new case();
		test_c.subject='test';
		test_c.recordtypeid = CC_Constants.DEFAULT_CASE_RECORDTYPE_ID;
		insert test_c;

		Knowledge_Group__c kg = [select id, name, group_name__c from Knowledge_Group__c where ID =: CC_Constants.DEFAULT_GROUP_ID];
		PageReference pageRef = Page.KnowledgeSearch;
		pageRef.getParameters().put('letter', 'A');
		pageRef.getParameters().put('caseID', test_c.id);
		Test.setCurrentPage(pageRef);
		
		KnowledgeSearchController tes = new  KnowledgeSearchController();
		tes.getQtypes();
		tes.getPartners();
		tes.getChannels();

	    system.assertEquals(test_c.id,tes.caseID);

	    tes.selectedPartner = 'Search All';
	    tes.selectedChannel = 'Search All';
	    tes.selectedType = 'Search All';

	    tes.ChooseFirstLetter();

		tes.SearchKB();

		tes.querystring = 'Rally';

		tes.SearchKB();

		pageRef.getParameters().put('qID', tes.questions[0].knowledgearticleid);
		tes.linkArticle();

		tes.next();
		tes.previous();
		tes.LastPage();
		tes.FirstPage();
		tes.getBools();

		tes.querystring = '';
		tes.querystring_client = 'Rally	Basic Support';

		tes.SearchKB();

		tes.querystring_client = '';
		tes.querystring_affiliation = 'rally_base';

		tes.SearchKB();

		tes.querystring_affiliation = 'rally_base';
		tes.selectedPartner = CC_Constants.DEFAULT_PARTNER_ID;

		tes.SearchKB();

		tes.selectedPartner = 'Search All';
		tes.selectedChannel = CC_Constants.DEFAULT_CHANNEL_ID;

		tes.SearchKB();

		system.assertEquals(Label.KnowledgeSearch_LinkArticleSuccess, tes.custerror);

	}

}