trigger ClientAffiliationTrigger on Client_Affiliation__c (after insert, before insert, after update, before update) {
	if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
		ClientAffiliationTriggerHandler.BeforeUpsert(trigger.new);
	}
	else if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
		ClientAffiliationTriggerHandler.AfterUpsert(trigger.new);
	}
	else if(trigger.isAfter && trigger.isDelete){
		ClientAffiliationTriggerHandler.AfterUpsert(trigger.old);
	}
}