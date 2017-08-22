public with sharing class PolicyNumberHandler {
	
	public static void afterUpsert(Policy_Number__c[] pns, Map<id,Policy_Number__c> oldPNMap) {

		List<sObject> newPjs = new List<sObject>();
		Set<id> impIds = new Set<id>();
		List<Id> delPLs = new List<Id>();
		Map<String, Policy_Number__c> policyMap = new Map<String, Policy_Number__c>();

		for(Policy_Number__c pl : pns){
			impIds.add(pl.implementation__c);
		}

		for(Policy_Number__c pnum : [select id, name from Policy_Number__c where implementation__c IN : impIds AND ID NOT IN : pns]){
			policyMap.put(pnum.name, pnum);
		}
        
        for(Policy_Number__c pl : pns){
        	if(trigger.isInsert && pl.Referring_Object_ID__c != null && pl.Referring_Object_ID__c != ''){
	        	string objectName = Utils_Implementation.findObjectNameFromRecordIdPrefix(pl.Referring_Object_ID__c);
	        	
	        	system.debug('Object Name ' + objectName);

	        	sObject pj = Schema.getGlobalDescribe().get('policy_join__c').newSObject();
	        	pj.put('Policy_Number__c', pl.id);
	        	pj.put(objectName,pl.Referring_Object_ID__c);

	        	if(policyMap.isEmpty() || !policyMap.containsKey(pl.name)){
	        		policyMap.put(pl.name, pl);
	        	}
	        	else if(policyMap.containsKey(pl.name)){
	        		delPLs.add(pl.id);
	        		pj.put('Policy_Number__c', policyMap.get(pl.name).id);
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