@istest
private class Test_KnowledgeUtils {
	
	@istest(seealldata=true)
	static void Test_KnowledgeArticleExternal(){		
		Question__kav q = [select id from Question__kav WHERE (PublishStatus = 'draft' and Language = 'en_US') AND KnowledgeArticleID = : CC_Constants.DEFAULT_UNPUBLISHED_QUESTION];

		Knowledge_Utils.newDefaultQuestion(new List<id>{q.id});

		Group_Article__c[] ga = [select id from Group_Article__c WHERE Knowledge_Article_ID__c = : CC_Constants.DEFAULT_UNPUBLISHED_QUESTION];

		system.assert(ga != null);

	}

	@istest(seealldata=true)
	static void Test_KnowledgeArticleInternal(){		
		Internal__kav q = [select id, KnowledgeArticleID from Internal__kav WHERE (PublishStatus = 'draft' and Language = 'en_US') AND Partner__c != null LIMIT 1];

		InternalKnowledgeHandler.newInternalQuestion(new List<id>{q.id});

		Group_Article__c[] ga = [select id from Group_Article__c WHERE Knowledge_Article_ID__c = : q.KnowledgeArticleID];

		system.assert(ga != null);

	}
}