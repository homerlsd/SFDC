trigger SubActivityIDTrigger on Sub_Activity_ID__c (after insert, after update, after delete) {
	if(trigger.isAfter && trigger.isInsert){
		SubActivityIDHandler.afterInsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isUpdate){
		SubActivityIDHandler.afterInsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isDelete){
		SubActivityIDHandler.afterDelete(trigger.old);
	}
}