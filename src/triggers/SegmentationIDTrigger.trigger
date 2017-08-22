trigger SegmentationIDTrigger on Segmentation_ID__c (after insert, after update) {
	if(trigger.isAfter && trigger.isInsert){
		SegmentationIDTriggerHandler.afterInsert(trigger.new);
	}
	if(trigger.isAfter && trigger.isUpdate){
		SegmentationIDTriggerHandler.afterInsert(trigger.new);
	}
}