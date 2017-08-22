public class SalesChannelTriggerHandler {
	
	public static void ChannelUpsert(Sales_Channel__c[] newChannels) {
		for (Sales_Channel__c chan : newChannels) {
	        // Blank out the record types currently saved
	        chan.Approved_Record_Type_ID__c = null;
	        chan.Unapproved_Record_Type_ID__c = null;
	        chan.Case_Record_Type_ID__c = null;
	        
	        // Get the record types that match the names on the channel object
	        List<RecordType> rts = [SELECT Id, Name, SobjectType FROM RecordType WHERE (Name = :chan.Approved_Record_Type_Name__c OR Name = :chan.Unapproved_Record_Type_Name__c OR Name = :chan.Case_Record_Type_Name__c) AND (sObjectType = 'Opportunity' OR sObjectType = 'Case')];
	        
	        // For each record type returned
	        for (RecordType rt : rts) {
	            // Set the ID fields to that of the recordtypes
	            if(rt.sObjectType == 'Opportunity'){
		            if (rt.Name == chan.Approved_Record_Type_Name__c)
		                chan.Approved_Record_Type_ID__c = rt.Id;
		            if (rt.Name == chan.Unapproved_Record_Type_Name__c)
		                chan.Unapproved_Record_Type_ID__c = rt.Id;
		        }
		        else if(rt.sObjectType == 'Case'){
		        	system.debug('CASE RTYPE IS ' + rt);
		            if (rt.Name == chan.Case_Record_Type_Name__c)
		                chan.Case_Record_Type_ID__c = rt.Id;
		        }
	        }
	        
	        // If no record types found at all... there is an issue
	        if (chan.Approved_Record_Type_ID__c == null || chan.Unapproved_Record_Type_ID__c == null || chan.Case_Record_Type_ID__c == null) {
	            chan.addError('One or more Record Type names does not return a Record Type ID - please try again.');
	        }
	    }
	}
}