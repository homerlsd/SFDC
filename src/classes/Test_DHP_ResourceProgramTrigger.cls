@istest
public class Test_DHP_ResourceProgramTrigger {
	
	@istest
	public static void Test_insert() {
		Milestone1_Project__c imp = new Milestone1_Project__c(name='test');
		insert imp;

		List<DHP_Resource_Program__c> dhps = new List<DHP_Resource_Program__c>();

		DHP_Resource_Program__c dhp = new DHP_Resource_Program__c(Identifiers_Requiring_Customization__c = '0001;0002;0003;', Hierarchy_to_Apply_Customization__c = 'Policy Number', Implementation__c = imp.id);
		dhps.add(dhp);

		DHP_Resource_Program__c dhp_PVRC = new DHP_Resource_Program__c(Identifiers_Requiring_Customization__c = '0001p;0002p;0003p;', Hierarchy_to_Apply_Customization__c = 'PVRC', Implementation__c = imp.id);
		dhps.add(dhp_PVRC);

		insert dhps;

		Policy_Number__c[] pns = [select id, (select id, DHP_Resource_Program__c from Policy_Joins__r) from Policy_Number__c where Implementation__c =: imp.id];
		system.assertEquals(3, pns.size());
		system.assertEquals(dhp.id, pns[0].Policy_Joins__r[0].DHP_Resource_Program__c);

		PVRC_Code__c [] pvrc = [select id, (select id, DHP_Resource_Program__c from PVRC_Joins__r) from PVRC_Code__c  where Implementation__c =: imp.id];
		system.assertEquals(3, pvrc.size());
		system.assertEquals(dhp_PVRC.id, pvrc[0].PVRC_Joins__r[0].DHP_Resource_Program__c);

		DHP_Resource_Program__c dhp_2 = new DHP_Resource_Program__c(Identifiers_Requiring_Customization__c = '0001p;0004p;0005p;', Hierarchy_to_Apply_Customization__c = 'PVRC', Implementation__c = imp.id);
		insert dhp_2;

		PVRC_Code__c [] pvrc2 = [select id, name,(select id, DHP_Resource_Program__c from PVRC_Joins__r) from PVRC_Code__c  where Implementation__c =: imp.id];
		for(PVRC_Code__c pvr : pvrc2){
			if(pvr.name == '0004p')
				system.assertEquals(dhp_2.id, pvr.PVRC_Joins__r[0].DHP_Resource_Program__c);
		}

		DHP_Resource_Program__c dhp_3 = new DHP_Resource_Program__c(Identifiers_Requiring_Customization__c = '0001;0004;0005;', Hierarchy_to_Apply_Customization__c = 'Policy Number', Implementation__c = imp.id);
		insert dhp_3;

		Policy_Number__c [] pol2 = [select id, name,(select id, DHP_Resource_Program__c from Policy_Joins__r) from Policy_Number__c  where Implementation__c =: imp.id];
		for(Policy_Number__c pol : pol2){
			if(pol.name == '0004')
				system.assertEquals(dhp_3.id, pol.Policy_Joins__r[0].DHP_Resource_Program__c);
		}

	}
}