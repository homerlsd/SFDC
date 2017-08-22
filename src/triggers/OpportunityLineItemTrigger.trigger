trigger OpportunityLineItemTrigger on OpportunityLineItem (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    /* Before Insert */   
    if(Trigger.isInsert && Trigger.isAfter){
        //OpportunityLineItemHandler.updateOLITotal(trigger.new, trigger.newMap);
        OpportunityLineItemHandler.isAfterInsert(trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isBefore){
        OpportunityLineItemHandler.beforeInsert(trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        OpportunityLineItemHandler.isAfterUpdate(trigger.new);
        //OpportunityLineItemHandler.updateOLITotal(trigger.new, trigger.oldMap);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        //OpportunityLineItemHandler.beforeUpdate(trigger.new, trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        OpportunityLineItemHandler.beforeDelete(trigger.old);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        OpportunityLineItemHandler.AfterDelete(Trigger.old);
    }
    /*else if(Trigger.isUnDelete){
        handler.OnUndelete(Trigger.new);
    }*/

}