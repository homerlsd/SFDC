trigger ImplementationTrigger on Milestone1_Project__c (before insert, before update, after insert) {
   	if(Trigger.isBefore && (Trigger.isInsert  || trigger.isUpdate)){
        Implementationhandler.OnBeforeUpsert(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        Implementationhandler.OnAfterUpsert(Trigger.new);
    }
}