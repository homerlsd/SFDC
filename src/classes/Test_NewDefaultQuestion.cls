@istest
public class Test_NewDefaultQuestion {
	
	@istest(seealldata=true)
	static void Test_NewDefaultQuestion() {
		string defaultID = CC_Constants.DEFAULT_UNPUBLISHED_QUESTION;
		List<Question__kav> qs = database.query(CC_Constants.BASE_QUERY_UNPUBLISHED + ' AND knowledgearticleid = : defaultID');
		List<string> qavIDs = new List<string>();
		qavids.add(qs[0].id);
		Knowledge_Utils.newDefaultQuestion(qavIDs);
		
		List<Group_article__c> gaCheck = [select id,Is_default_question__c, Knowledge_Article_ID__c from Group_article__c where Knowledge_Article_ID__c = : qs[0].knowledgearticleid];
		System.assert(gacheck != null);
		system.assertEquals(true,gaCheck[0].Is_default_question__c);
	}
}