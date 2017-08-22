trigger CaseTrigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    Trigger_Setting__c trig = Trigger_Setting__c.getInstance('CaseTrigger');

    if(test.isRunningTest() || trig.active__c){
        /* Before Insert */
        if(Trigger.isInsert && Trigger.isBefore){
            casetriggerhandler.OnBeforeInsert(Trigger.new);
        }
        else if(Trigger.isUpdate && Trigger.isBefore){
            casetriggerhandler.OnBeforeUpdate(Trigger.new, trigger.oldMap);
        }
       else if(Trigger.isInsert && Trigger.isAfter){
            casetriggerhandler.OnAfterInsert(Trigger.new);
        }
        else if(Trigger.isUpdate && Trigger.isAfter){
            casetriggerhandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        /*else if(Trigger.isDelete && Trigger.isBefore){
            casetriggerhandler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
        }
        else if(Trigger.isDelete && Trigger.isAfter){
            casetriggerhandler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        }
        else if(Trigger.isUnDelete){
            casetriggerhandler.OnUndelete(Trigger.new);
        }*/
    }

}