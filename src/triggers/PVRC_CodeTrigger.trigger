trigger PVRC_CodeTrigger on PVRC_Code__c (after insert) {
	if(trigger.isAfter && trigger.isInsert){
		PVRC_CodeHandler.afterUpsert(trigger.new,trigger.newMap);
	}
}