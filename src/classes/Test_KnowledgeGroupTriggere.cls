@istest
public class Test_KnowledgeGroupTriggere{
	
	@istest(seealldata=true)
	static void Test_KnowledgeGroupTriggere1() {

		Sales_Channel__c sc = new Sales_Channel__c(name= 'Engage',Approved_Record_Type_Name__c = 'Engage Approved', Case_Record_Type_Name__c = 'Engage', Unapproved_Record_Type_Name__c = 'Engage');
 		insert sc;

 		Question__kav qs = database.query(CC_Constants.BASE_QUERY + ' AND Is_Default_Question__c = true order by CreatedDate ASC LIMIT 1');

		id testid = KbManagement.PublishingService.editOnlineArticle(qs.knowledgearticleid,false);

		system.debug('DRAFT ID IS ' + testID);

		List<string> testids = new List<string>();
		testids.add(testid);
		    
		Question__kav qs1 = database.query(CC_Constants.BASE_QUERY_UNPUBLISHED + ' AND ID IN : testids');

		qs1.channel__c = sc.id;
		update qs1;

		KbManagement.PublishingService.publishArticle(qs.knowledgearticleid,true);

		Knowledge_Group__c grp = new Knowledge_Group__c(Group_Name__c ='Wayne Enterprises', Client__c = 'testClient', Affiliation__c ='TestAffil', Partner__c = 'testPartner', Channel__c = sc.id);
		insert grp;
		
		Knowledge_Group__c grpCheck = [select id, (select id from Group_Articles__r) from Knowledge_Group__c where ID = : grp.id];

		System.assert(grpCheck.Group_Articles__r != null);
		System.assert(grpCheck.Group_Articles__r.size() > 0);
	}

	@istest(seealldata=false)
	static void Test_KnowledgeGroupTriggere2() {

		Sales_Channel__c sc = new Sales_Channel__c(name= 'Engage',Approved_Record_Type_Name__c = 'Engage Approved', Case_Record_Type_Name__c = 'Engage', Unapproved_Record_Type_Name__c = 'Engage');
 		insert sc;

		Knowledge_Group__c grp = new Knowledge_Group__c(Default_Group_For_Channel__c = true,Group_Name__c ='Wayne Enterprises', Client__c = 'testClient', Affiliation__c ='TestAffil', Partner__c = 'testPartner', Channel__c = sc.id);
		insert grp;

		Knowledge_Group__c grp1 = new Knowledge_Group__c(Default_Group_For_Channel__c = true,Group_Name__c ='Wayne Enterprises 1', Client__c = 'testClient', Affiliation__c ='TestAffil', Partner__c = 'testPartner', Channel__c = sc.id);
		insert grp1;
		
		List<Knowledge_Group__c> kbcheck = [select id from Knowledge_Group__c where Default_Group_For_Channel__c = true AND Channel__c =: sc.id];

		System.assert(kbcheck != null);
		System.assert(kbcheck.size() == 1);
	}
}