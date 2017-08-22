public class DHP_PromotionHandler {
	
	public static void afterInsert(DHP_Promotion__c[] dhps) {
		Map<String,String> valueMap = new Map<String,String>();
		Map<String,String> joinMap = new Map<String,String>();
		Map<String,String> objectMap = new Map<String,String>();
		Map<String,String> parentObjectMap = new Map<String,String>();
		List<String> objIDs	= new List<String>();

		for(DHP_Promotion__c dhp : dhps){

			system.debug('TYPE OF RECORDS ' + dhp.Hierarchy_Formula__c);
			system.debug('LIST OF RECORDS ' + dhp.Identifiers_Requiring_the_Campaign__c);

			if(dhp.Identifiers_Requiring_the_Campaign__c != null && dhp.Hierarchy_Formula__c != 'N/A'){
				valueMap.put(dhp.id, dhp.Identifiers_Requiring_the_Campaign__c);
				joinMap.put(dhp.id, dhp.Implementation__c);
				objIDs.add(dhp.id);
				objectMap.put(dhp.id, dhp.Hierarchy_Formula__c);
				parentObjectMap.put(dhp.id, 'dhp_promotion__c');
			}
		}

		if(!valueMap.isEmpty())
			Utils_Implementation.createNewRecords(valueMap, joinMap, objIDs, objectMap, parentObjectMap);
	}
}