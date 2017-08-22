trigger PolicyNumberTrigger on Policy_Number__c (after insert) {
	if(trigger.isAfter && trigger.isInsert){
		PolicyNumberHandler.afterUpsert(trigger.new,trigger.newMap);
	}
}