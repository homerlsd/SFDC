@istest
public class Test_MetaDataTrigger {
	
	@istest(seealldata=false)
	static void Test_MetaDataTrigger() {
		List<Metadata_Property__c> mps = new List<Metadata_Property__c>();

		Metadata_Property__c mp = new Metadata_Property__c(Metadata_Type__c = 'Profile', Metadata_Name__c ='System Administrator');
		mps.add(mp);

		Metadata_Property__c mpr = new Metadata_Property__c(Metadata_Type__c = 'Role', Metadata_Name__c ='System Administrator');
		mps.add(mpr);

		insert mps;

		for(Metadata_Property__c mp1 : [select Metadata_Id__c from Metadata_Property__c where ID = :mp.id]){
			system.assert(mp1.Metadata_ID__c != null);	
		}
	}
}