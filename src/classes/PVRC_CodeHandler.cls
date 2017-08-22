public with sharing class PVRC_CodeHandler {
	
	public static void afterUpsert(PVRC_Code__c[] pns, Map<id,PVRC_Code__c> oldPNMap) {
	List<sObject> newPjs = new List<sObject>();
		Set<id> impIds = new Set<id>();
		List<Id> delPLs = new List<Id>();
		Map<String, PVRC_Code__c> policyMap = new Map<String, PVRC_Code__c>();

		for(PVRC_Code__c pl : pns){
			impIds.add(pl.implementation__c);
		}

		for(PVRC_Code__c pnum : [select id, name from PVRC_Code__c where implementation__c IN : impIds AND ID NOT IN : pns]){
			policyMap.put(pnum.name, pnum);
		}
        
        system.debug('EXISTING PVRCS ARE ' + policyMap);
        
        for(PVRC_Code__c pl : pns){
        	if(trigger.isInsert && pl.Referring_Object_ID__c != null && pl.Referring_Object_ID__c != ''){
	        	string objectName = Utils_Implementation.findObjectNameFromRecordIdPrefix(pl.Referring_Object_ID__c);
	        	
	        	system.debug('Object Name ' + objectName);

	        	sObject pj = Schema.getGlobalDescribe().get('pvrc_join__c').newSObject();
	        	pj.put('PVRC_Code__c', pl.id);
	        	pj.put(objectName,pl.Referring_Object_ID__c);

	        	if(policyMap.isEmpty() || !policyMap.containsKey(pl.name)){
	        		policyMap.put(pl.name, pl);
	        	}
	        	else if(policyMap.containsKey(pl.name)){
	        		delPLs.add(pl.id);
	        		pj.put('PVRC_Code__c', policyMap.get(pl.name).id);
	        	}

	        	newPjs.add(pj);
	        }
        }

        if(!newPjs.isEmpty())
        	insert newPjs;

       	if(!delPLs.isEmpty())
       		Utils_Implementation.deleteObjects(delPLs);
	}
}