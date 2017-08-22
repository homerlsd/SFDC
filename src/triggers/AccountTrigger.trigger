trigger AccountTrigger on Account (before insert, before update) {
	if(trigger.isBefore){
		AccountTriggerHandler.beforeUpsert(trigger.new, (trigger.isInsert == true ? trigger.newMap : trigger.oldMap));
	}
}