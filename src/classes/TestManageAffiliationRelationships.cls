@istest(seealldata=false)
public class TestManageAffiliationRelationships {
	//CREATE PAGE TESTS
	@isTest(SeeAllData=false) static void testCreateBCBS_noAffil() {	
		Account a = new Account(name='test');
		insert a;

		Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, partner__c=Label.ManageAffiliations_BCBSPartnerID);
        insert imp;
		
		PageReference pageRef = page.ManageAffiliationRelationships;
        pageRef.getParameters().put('impID', imp.id);
        pageRef.getParameters().put('recID', '001');
        Test.setCurrentPage(pageRef);

        ManageAffiliationRelationshipsController cont = new ManageAffiliationRelationshipsController();
        
        System.assertEquals(cont.message,Label.ManageAffiliationRelationship_Message);

	}

	@isTest(SeeAllData=false) static void testCreatewithAffil() {	
		Account a = new Account(name='test');
		insert a;

		Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
		insert p;

		Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;
		
		Client_Affiliation__c ca = new Client_Affiliation__c(account__c=a.id,Implementation__c=imp.id,name='TestAff1');
		insert ca;

		Digital_Campaign_Requirement__c dg = new Digital_Campaign_Requirement__c(Implementation__c=imp.id);
		insert dg;
		
		PageReference pageRef = page.ManageAffiliationRelationships;
        pageRef.getParameters().put('impID', imp.id);
        pageRef.getParameters().put('recID', dg.id);
        Test.setCurrentPage(pageRef);

        ManageAffiliationRelationshipsController cont = new ManageAffiliationRelationshipsController();
        
        System.assertNotEquals(cont.message,Label.ManageAffiliationRelationship_Message);

        system.assert(cont.allAffiliation != null);

        cont.selectedAffiliation.addAll(cont.allAffiliation);
        cont.allAffiliation.clear();

        cont.save();

	}
}