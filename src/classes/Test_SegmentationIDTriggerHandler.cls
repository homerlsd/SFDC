@isTest
private class Test_SegmentationIDTriggerHandler {
	
	@isTest static void test_afterInsert() {
		Partner__c p = new Partner__c(name = 'test',Partner_String__c = 'test', Affiliation_Naming_Convention__c = Label.SegmentationIDHandler_AdvancedNamingConvention);
		insert p;

		Account a = new Account(name = 'test', Partner__c = p.id);
		insert a;
		
		Milestone1_Project__c imp = new Milestone1_Project__c(name='test', partner__c = p.id, Account__c = a.id);
		insert imp;

		Client_Affiliation__c ca = new Client_Affiliation__c(Name='Testaff2',Account__c = a.id, Implementation__c  = imp.id);
		insert ca;

		Segmentation_ID__c seg = new Segmentation_ID__c(Client_Affiliation__c = ca.id, name = '2784', Segmentation_Suffix__c = 'MED', Segmentation_Prefix__c = 'somePref');
		insert seg;

		Client_Affiliation__c ca2 = [select name,segmentation_ids__c from Client_Affiliation__c where ID = : ca.id];
		System.assertEquals('Segmentation ID #1: somePref2784MED', ca2.segmentation_ids__c);

	}

	@isTest static void test_afterInsert_optum() {
		Partner__c p = new Partner__c(name = 'Optum',Partner_String__c = 'test', Affiliation_Naming_Convention__c = Label.SegmentationIDHandler_AdvancedNamingConvention);
		insert p;

		Account a = new Account(name = 'Optum', Partner__c = p.id);
		insert a;
		
		Milestone1_Project__c imp = new Milestone1_Project__c(name='test', partner__c = p.id, Account__c = a.id);
		insert imp;

		Client_Affiliation__c ca = new Client_Affiliation__c(Name='Testaff2',Account__c = a.id, Implementation__c  = imp.id);
		insert ca;

		Segmentation_ID__c seg = new Segmentation_ID__c(Client_Affiliation__c = ca.id, name = '2784', Segmentation_Suffix__c = 'MED', Segmentation_Prefix__c = 'somePref');
		insert seg;

		Client_Affiliation__c ca2 = [select name, segmentation_ids__c from Client_Affiliation__c where ID = : ca.id];
		System.assertEquals('somePref2784MED', ca2.segmentation_ids__c);

	}
	
}