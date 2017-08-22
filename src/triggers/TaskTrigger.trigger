trigger TaskTrigger on Task (before insert, before delete) {
	if(Trigger.isInsert && Trigger.isBefore){
        TaskTriggerHandler.isBeforeInsert(Trigger.new);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        TaskTriggerHandler.isBeforeDelete(trigger.old, trigger.oldMap);
    }
}