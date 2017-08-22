@istest(seealldata=false)
public class Test_ManageAffiliations {
	//CREATE PAGE TESTS
	/*@isTest(SeeAllData=false) static void testCreateBCBS_noAffil() {	
		Account a = new Account(name='test');
		insert a;

		Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, partner__c=Label.ManageAffiliations_BCBSPartnerID);
        insert imp;
		
		PageReference pageRef = page.ManageAffiliations;
        pageRef.getParameters().put('id', imp.id);
        Test.setCurrentPage(pageRef);

        ManageAffiationController cont = new ManageAffiationController();
        
        System.assert(cont.affiliationNames != null);
        System.assertEquals(true,cont.showSegmentPanel);
        
        cont.addAffiliationRow();
        cont.removeAffiliation();
        cont.addAffiliationRow();

        cont.affiliationWrapperList[0].affil.name = 'something';
        cont.affiliationWrapperList[1].affil.name = 'something1';

        pageRef.getParameters().put('g','0');
        cont.addSegmentIDRow();

		cont.affiliationWrapperList[0].segmentList[0].segPrefix = '213213';
		cont.affiliationWrapperList[0].segmentList[0].segID.name = 'sadsf';

        cont.affiliationWrapperList[0].segmentList[1].segPrefix = '213213123123';
		cont.affiliationWrapperList[0].segmentList[1].segID.name = 'sadsf21123';

		cont.affiliationWrapperList[1].segmentList[0].segPrefix = '2132131231232';
		cont.affiliationWrapperList[1].segmentList[0].segID.name = 'sadsf21123weew';

		cont.saveAffils();

	}

	@isTest(SeeAllData=false) static void testCreatewithAffil() {	
		Account a = new Account(name='test');
		insert a;

		Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
		insert p;

		Affiliation__c aa = new Affiliation__c(name='affil1',Partner__c=p.id);
		insert aa;

		Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;
		
		PageReference pageRef = page.ManageAffiliations;
        pageRef.getParameters().put('id', imp.id);
        Test.setCurrentPage(pageRef);

        ManageAffiationController cont = new ManageAffiationController();
        
        System.assert(cont.affiliationNames != null);
        System.assertEquals(false,cont.showSegmentPanel);
        
        cont.affiliationWrapperList[0].affil.name = 'affil1';
		cont.affiliationWrapperList[0].segmentList[0].segPrefix = '213213';
		cont.affiliationWrapperList[0].segmentList[0].segID.name = '1-10';

		cont.saveAffils();

	}*/
}