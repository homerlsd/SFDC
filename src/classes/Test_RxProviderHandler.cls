@istest
public class Test_RxProviderHandler {
	
	@istest
	public static void Test_insert() {
		Milestone1_Project__c imp = new Milestone1_Project__c(name='test');
		insert imp;

		List<Rx_Provider__c> rxs = new List<Rx_Provider__c>();

		Rx_Provider__c rx = new Rx_Provider__c(Identifiers_Requiring_Rx_Customization__c = '0001;0002;0003;', Hierarchy_to_Apply_RX_Customization__c = 'Policy Number', Implementation__c = imp.id);
		rxs.add(rx);

		Rx_Provider__c rx_PVRC = new Rx_Provider__c(Identifiers_Requiring_Rx_Customization__c = '0001p;0002p;0003p;', Hierarchy_to_Apply_RX_Customization__c = 'PVRC', Implementation__c = imp.id);
		rxs.add(rx_PVRC);

		insert rxs;

		Policy_Number__c[] pns = [select id, (select id, Rx_Provider__c from Policy_Joins__r) from Policy_Number__c where Implementation__c =: imp.id];
		system.assertEquals(3, pns.size());
		system.assertEquals(rx.id, pns[0].Policy_Joins__r[0].Rx_Provider__c);

		PVRC_Code__c [] pvrc = [select id, (select id, Rx_Provider__c from PVRC_Joins__r) from PVRC_Code__c  where Implementation__c =: imp.id];
		system.assertEquals(3, pvrc.size());
		system.assertEquals(rx_PVRC.id, pvrc[0].PVRC_Joins__r[0].Rx_Provider__c);

		Rx_Provider__c rx_2 = new Rx_Provider__c(Identifiers_Requiring_Rx_Customization__c = '0001p;0004p;0005p;', Hierarchy_to_Apply_RX_Customization__c = 'PVRC', Implementation__c = imp.id);
		insert rx_2;

		PVRC_Code__c [] pvrc2 = [select id, name,(select id, Rx_Provider__c from PVRC_Joins__r) from PVRC_Code__c  where Implementation__c =: imp.id];
		for(PVRC_Code__c pvr : pvrc2){
			if(pvr.name == '0004p')
				system.assertEquals(rx_2.id, pvr.PVRC_Joins__r[0].Rx_Provider__c);
		}

		Rx_Provider__c rx_3 = new Rx_Provider__c(Identifiers_Requiring_Rx_Customization__c = '0001;0004;0005;', Hierarchy_to_Apply_RX_Customization__c = 'Policy Number', Implementation__c = imp.id);
		insert rx_3;

		Policy_Number__c [] pol2 = [select id, name,(select id, Rx_Provider__c from Policy_Joins__r) from Policy_Number__c  where Implementation__c =: imp.id];
		for(Policy_Number__c pol : pol2){
			if(pol.name == '0004')
				system.assertEquals(rx_3.id, pol.Policy_Joins__r[0].Rx_Provider__c);
		}

	}
}