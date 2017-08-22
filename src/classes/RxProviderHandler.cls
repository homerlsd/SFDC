public class RxProviderHandler {
	
	public static void afterInsert(Rx_Provider__c[] rxs) {
		Map<String,String> valueMap = new Map<String,String>();
		Map<String,String> joinMap = new Map<String,String>();
		Map<String,String> objectMap = new Map<String,String>();
		Map<String,String> parentObjectMap = new Map<String,String>();
		List<String> objIDs	= new List<String>();

		for(Rx_Provider__c rx : rxs){

			system.debug('TYPE OF RECORDS ' + rx.Hierarchy_Formula__c);
			system.debug('LIST OF RECORDS ' + rx.Identifiers_Requiring_Rx_Customization__c);

			if(rx.Identifiers_Requiring_Rx_Customization__c != null && rx.Hierarchy_Formula__c != 'N/A'){
				valueMap.put(rx.id, rx.Identifiers_Requiring_Rx_Customization__c);
				joinMap.put(rx.id, rx.Implementation__c);
				objIDs.add(rx.id);
				objectMap.put(rx.id, rx.Hierarchy_Formula__c);
				parentObjectMap.put(rx.id, 'Rx_Provider__c');
			}
		}

		if(!valueMap.isEmpty())
			Utils_Implementation.createNewRecords(valueMap, joinMap, objIDs, objectMap, parentObjectMap);
	}
}