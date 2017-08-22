trigger ResourcePageCategoryTrigger on Resource_Page_Category__c (after insert, before insert, after update, before update) {
  
  if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
    ResourcePageCategoryTriggerHandler.AfterUpsert(trigger.new);
  }
}