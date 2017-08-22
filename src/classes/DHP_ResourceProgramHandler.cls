public class DHP_ResourceProgramHandler {

	public static void afterInsert(DHP_Resource_Program__c[] dhps) {
		Map<String,String> valueMap = new Map<String,String>();
		Map<String,String> joinMap = new Map<String,String>();
		Map<String,String> objectMap = new Map<String,String>();
		Map<String,String> parentObjectMap = new Map<String,String>();
		List<String> objIDs	= new List<String>();

		for(DHP_Resource_Program__c dhp : dhps){

			system.debug('TYPE OF RECORDS ' + dhp.Hierarchy_Formula__c);
			system.debug('LIST OF RECORDS ' + dhp.Identifiers_Requiring_Customization__c);

			if(dhp.Identifiers_Requiring_Customization__c != null && dhp.Hierarchy_Formula__c != 'N/A'){
				valueMap.put(dhp.id, dhp.Identifiers_Requiring_Customization__c);
				joinMap.put(dhp.id, dhp.Implementation__c);
				objIDs.add(dhp.id);
				objectMap.put(dhp.id, dhp.Hierarchy_Formula__c);
				parentObjectMap.put(dhp.id, 'DHP_Resource_Program__c');
			}
		}

		if(!valueMap.isEmpty()){
			system.debug('OBJECT MAP IS ' + objectMap);
			Utils_Implementation.createNewRecords(valueMap, joinMap, objIDs, objectMap, parentObjectMap);
		}
	}
}