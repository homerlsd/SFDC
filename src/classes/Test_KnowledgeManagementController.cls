@isTest
private class Test_KnowledgeManagementController {
	
	@isTest(SeeAllData=true) static void test_view() {
		KnowledgeManagementController tes = new  KnowledgeManagementController ();
	    PageReference pageRef = Page.KnowledgeManagementHome;
		Test.setCurrentPage(pageRef);

	    System.assertEquals('A%',tes.selectedLetter);
	    System.assertEquals('New Article',tes.title);
	    tes.FirstPage();
	    tes.next();
	    tes.previous();
	    tes.LastPage();
	    tes.getnxt();
	    tes.getprev();
	}

	@isTest(SeeAllData=true) static void test_new() {
		KnowledgeManagementController tes = new  KnowledgeManagementController ();
	    PageReference pageRef = Page.NewKnowledgeArticle;
		Test.setCurrentPage(pageRef);

	    System.assertEquals('A%',tes.selectedLetter);
	    System.assertEquals('New Article',tes.title);

	    tes.refreshQuery();
	    tes.createNewArticle();
	    tes.publishDate = '07/15/2029';
	    tes.art.is_default_question__c = true;
	    tes.recordID = '';
	    tes.save();
	    tes.insertDefaults();
	}

	@isTest(SeeAllData=true) static void test_edit_pub() {
		string quer = CC_Constants.BASE_QUERY + ' LIMIT 1';
		
		List<Question__Kav> qss = database.query(quer);

		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', qss[0].id);
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();
		system.debug(tes.title);

		system.assert(tes.title.contains('Online'));
		tes.editPublished();
		tes.unPublish();

	}

	@isTest(SeeAllData=true) static void test_edit_pub_default() {
		string quer = CC_Constants.BASE_QUERY + ' AND is_default_question__c = true LIMIT 1';
		
		List<Question__Kav> qss = database.query(quer);

		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', qss[0].id);
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();
		system.debug(tes.title);

		system.assert(tes.title.contains('Online'));
		tes.editPublished();
		tes.updateDefaults();
		tes.unPublish();

	}

	@isTest(SeeAllData=true) static void test_edit_pub_default1() {
		string quer = CC_Constants.BASE_QUERY + ' AND is_default_question__c = true LIMIT 1';
		
		List<Question__Kav> qss = database.query(quer);

		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', qss[0].id);
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();
		system.debug(tes.title);

		system.assert(tes.title.contains('Online'));
		tes.editPublished();
		tes.updateDefaults();
		tes.saveandPub();
		tes.save();

	}

	@isTest(SeeAllData=true) static void test_edit_draft() {
		string quer = CC_Constants.BASE_QUERY_UNPUBLISHED + ' LIMIT 1';
		
		List<Question__Kav> qss = database.query(quer);

		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', qss[0].id);
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();
		system.debug(tes.title);

		system.assert(tes.title.contains('Draft'));
		tes.saveandPub();

	}

	@isTest(SeeAllData=true) static void test_edit_draftDefault() {
		string quer = CC_Constants.BASE_QUERY_UNPUBLISHED + ' LIMIT 1';
		
		List<Question__Kav> qss = database.query(quer);

		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', qss[0].id);
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();
		system.debug(tes.title);

		system.assert(tes.title.contains('Draft'));
		tes.saveandPub();

	}

	@isTest(SeeAllData=true) static void test_viewArchived() {
		List<Id> idss = new List<ID>();
		idss.add(CC_Constants.DEFAULT_KBARCHIVED_ID);

		string quer = CC_Constants.BASE_QUERY_ARCHIVED + ' AND KnowledgeArticleID IN : idss AND isLatestVersion = false LIMIT 1';
		
		List<Question__Kav> qss = database.query(quer);

		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', qss[0].id);
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();
		system.debug(tes.title);

		system.assert(tes.title.contains('Archived'));

	}


	@isTest(SeeAllData=true) static void test_unfound() {
		PageReference pageRef = Page.NewKnowledgeArticle;
	    pageRef.getParameters().put('id', 'someFakeID');
		Test.setCurrentPage(pageRef);

		KnowledgeManagementController tes = new  KnowledgeManagementController ();

	}
}