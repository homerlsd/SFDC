trigger PartnerTrigger on Partner__c (before insert,before update) {
	
	Map<string,id> rtMap = new Map<string, id>();

    for(RecordType rts : [SELECT Id, Name, SobjectType FROM RecordType WHERE sObjectType = 'Milestone1_Project__c']){
    	rtMap.put(rts.name, rts.id);
    }

    system.debug('RT NAMES ARE ' + rtMap.keyset());

	for (Partner__c partner : trigger.new) {
        // Blank out the record types currently saved
        partner.Implementation_Record_Type_ID__c = null;

        String nameMatch = 'Engage - ' + partner.name;

        system.debug('NAME IS ' + nameMatch);

        if(rtMap.containsKey(nameMatch)){
        	partner.Implementation_Record_Type_ID__c = rtMap.get(nameMatch);
        }
    }
}