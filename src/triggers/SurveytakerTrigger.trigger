trigger SurveytakerTrigger on SurveyTaker__c(before insert, after insert) {
     
    //Trigger to Report on the last survey taker.
    Trigger_Setting__c trig = Trigger_Setting__c.getInstance('SurveytakerTrigger');

    if(test.isRunningTest() || trig.active__c){
        if(Trigger.isInsert && Trigger.isbefore){
            SurveyTakerTriggerHandler.OnBeforeInsert(Trigger.new);
        }
        /*if(Trigger.isInsert && Trigger.isAfter){
            SurveyTakerTriggerHandler.OnafterInsert(Trigger.new);
        }*/
    }
}