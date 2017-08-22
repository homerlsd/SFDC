trigger ProductScheduleTrigger on Product_Schedule__c (before insert, after insert, after delete) {

    /* Before Insert */   
    if(Trigger.isInsert && Trigger.isBefore){
        ProductScheduleHandler.isBeforeInsert(trigger.new);
    }
    if(Trigger.isInsert && Trigger.isAfter){
        ProductScheduleHandler.isAfterInsert(trigger.new, trigger.oldMap);
    }
    if(Trigger.isDelete && Trigger.isAfter){
        ProductScheduleHandler.isAfterDelete(trigger.old, trigger.oldMap);
    }
}