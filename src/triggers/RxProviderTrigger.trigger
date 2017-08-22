trigger RxProviderTrigger on Rx_Provider__c (after insert) {
	if(trigger.isAfter && trigger.isInsert)
		RxProviderHandler.afterInsert(trigger.new);
}