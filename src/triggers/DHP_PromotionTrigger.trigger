trigger DHP_PromotionTrigger on DHP_Promotion__c (after insert) {
	if(trigger.isAfter && trigger.isInsert)
		DHP_PromotionHandler.afterInsert(trigger.new);
}