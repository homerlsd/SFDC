public class TaskTriggerHandler {
	
	public static void isBeforeInsert(Task[] tsks) {
		List<task> nextloop = new List<task>();
		Set<string> callids = new Set<string>();
		Map<string,Task> dnis = new Map<string,Task>();
		Map<string, case> caseMap = new Map<string,case>();
		Map<string, case> dnisMap = new Map<string,case>();
		Map<string, case> caseIDmap = new Map<string,case>();

		for(task t : tsks){
			if(t.Five9__Five9SessionId__c != null && t.Five9__Five9SessionId__c != '' && t.Processed__c == false){
				//if(t.WhatId == null){
					callids.add(t.Five9__Five9SessionId__c);
					dnis.put(t.Five9__Five9DNIS__c, t);
					nextloop.add(t);
				//}
			}
		}


		if(!nextloop.isEmpty()){
			system.debug('WHAT IS THE SESSION ID LIST ' + callids);
		
			if(!dnis.isEmpty())
				system.debug('WHAT IS THE ANI LIST ' + dnis.keyset());

			for(case c : [select id,Call_ID__c,contactID,Partner_Lookup__c,Phone__c,CreatedByID,CreatedDate,Call_Type__c from Case where ((Call_ID__c != null AND Call_ID__c IN : callids) OR (CreatedDate >= :Datetime.now().addMinutes(-60) AND Phone__c != NULL AND Call_Type__c = 'Outbound' AND Phone__c IN : dnis.keyset())) ORDER BY CreatedDate DESC]){
				
				system.debug('CREATED DATE OF CASE ' + c.createdDate);
				system.debug('ID OF CASE ' + c.id);

				if(callids.contains(c.call_id__c)){
					caseMap.put(c.call_id__c, c);
				}
				else if(c.call_type__c == 'Outbound' && dnis.containsKey(c.phone__c) && dnis.get(c.phone__c).ownerID == c.CreatedByID){
					if(dnisMap.isEmpty() || !dnisMap.containsKey(c.phone__c))
						dnisMap.put(c.phone__c, c);
				}

			}

			system.debug('caseMap is ' + caseMap);
			system.debug('dnisMap is ' + dnisMap);

			for(task t : nextloop){
				if(caseMap.containsKey(t.Five9__Five9SessionId__c)){
					t.WhatId = caseMap.get(t.Five9__Five9SessionId__c).id;
					
					if(caseMap.get(t.Five9__Five9SessionId__c).contactID != null)
						t.WhoId = caseMap.get(t.Five9__Five9SessionId__c).contactID;

					if(caseMap.get(t.Five9__Five9SessionId__c).Partner_Lookup__c != null)
						t.Partner__c = caseMap.get(t.Five9__Five9SessionId__c).Partner_Lookup__c;
				}
				else if(dnisMap.containsKey(t.Five9__Five9DNIS__c)){
					t.WhatId = dnisMap.get(t.Five9__Five9DNIS__c).id;
					
					if(dnisMap.get(t.Five9__Five9DNIS__c).contactID != null)
						t.WhoId = dnisMap.get(t.Five9__Five9DNIS__c).contactID;

					if(dnisMap.get(t.Five9__Five9DNIS__c).Partner_Lookup__c != null)
						t.Partner__c = dnisMap.get(t.Five9__Five9DNIS__c).Partner_Lookup__c;
				}
			}
		}
	}

	public static void isBeforeDelete(Task[] tsks, Map<id, Task> oldMap) {
		Set<string> permissions = utils.findUserPermissions(UserInfo.getUserId());

		if(permissions.isEmpty() || (!permissions.isEmpty() && !permissions.contains(Label.TaskTriggerHandler_DeleteTasksPermission))){
			tsks[0].addError(Label.TaskTriggerHandler_DeleteTasksError);
		}

	}
}