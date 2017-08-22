trigger DHP_ResourceProgramTrigger on DHP_Resource_Program__c (after insert) {
	if(trigger.isAfter && trigger.isInsert){
		DHP_ResourceProgramHandler.afterInsert(trigger.new);
	}
}