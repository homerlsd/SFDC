trigger MetadataPropertyTrigger on Metadata_Property__c (before insert, before update) {
	
	Map<string, id> profMap = new Map<String, ID>();
	Map<string, id> roleMap = new Map<String, ID>();

	for(Profile profs : [SELECT Id, Name FROM Profile]){
		profMap.put(profs.name, profs.id);
	}
	for(userrole roles : [SELECT Id, Name FROM userrole]){
		roleMap.put(roles.name, roles.id);
	}

	for (Metadata_Property__c mp : trigger.new) {
        // Blank out the record types currently saved
        mp.Metadata_Id__c = null;

       	if(mp.Metadata_Type__c == 'Profile'){
	        // For each record type returned
	        if (profMap.containsKey(mp.Metadata_Name__c))
	        	mp.Metadata_Id__c = profMap.get(mp.Metadata_Name__c);	        
	        // If no record types found at all... there is an issue
	        else
	            mp.addError('Your metadata name as entered can not return an ID - please try again.');
        }

        else if(mp.Metadata_Type__c == 'Role'){
            // Set the ID fields to that of the recordtypes
            if (roleMap.containsKey(mp.Metadata_Name__c))
	        	mp.Metadata_Id__c = roleMap.get(mp.Metadata_Name__c);	        
	        // If no record types found at all... there is an issue
	        else
	            mp.addError('Your metadata name as entered can not return an ID - please try again.');
	    }
	}
}