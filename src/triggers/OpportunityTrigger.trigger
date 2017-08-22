trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    /* Before Insert */
    if(Trigger.isInsert && Trigger.isAfter){
        Opportunityhandler.OnAfterInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isBefore){
        Opportunityhandler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        Opportunityhandler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        Opportunityhandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        Opportunityhandler.OnBeforeDelete(Trigger.old);
    }
    /*else if(Trigger.isDelete && Trigger.isAfter){
        Opportunityhandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isUnDelete){
        Opportunityhandler.OnUndelete(Trigger.new);
    }*/

}