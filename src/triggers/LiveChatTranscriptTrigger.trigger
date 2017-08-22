trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert, before update) {
    if(Trigger.isInsert && Trigger.isBefore){
        LiveChatTranscriptTriggerHandler.onBeforeUpsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        LiveChatTranscriptTriggerHandler.onBeforeUpsert(Trigger.new);
    }
}