public class RewardPlanDesignHandler {
	
	public static void afterInsert(Reward_Plan_Design__c[] rpds) {

		//TEST INPUTS:
		//OBJNAME: Reward_Plan_Design__c
		//WHERE CLAUSE: Reward_Plan_Designex__c

		string objName = CloneCtrl.returnAPIObjectName(rpds[0].id);

        string whereClause = objName.replace('__c','ex__c');

		Map<String,String> filterLookups = Utils.getFilteredLookupMap('Reward_Plan_Activity__c');
		Set<string> objIdSet = new Set<string>();
		Set<string> foundfilters = new Set<string>();
		Map<String,String> mappy = new Map<String,String>();
		Map<String,String> rpaMap = new Map<String,String>();
		Map<String,List<String>> objIDMap = new Map<String,List<String>>();
		Map<String,List<String>> exIDMap = new Map<String,List<String>>();
		
		for(Reward_Plan_Design__c rpd : rpds){
			if(rpd.get(whereClause) != null)
				mappy.put(string.valueOf(rpd.get(whereClause)), rpd.id);
		}	

		//DYNAMIC task QUERY WORK
        List<string> rpaStandardFields = new List<string>{'id'};
        string queryString_rpa = '';
        
        for(Schema.FieldSetMember fsm: SObjectType.Reward_Plan_Activity__c.FieldSets.RewardPlanDesignHandler.getFields()){
            rpaStandardFields.add(fsm.getfieldPath());
        }

        // Add to set to de-dup field listing
        Set<string> fieldSet_rpa = new Set<string>();
        for(string s: rpaStandardFields){
            fieldSet_rpa.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList_rpa = new List<string>(fieldSet_rpa);
        for (Integer i=0; i<fieldList_rpa.size(); i++) {
            if(i == 0) {
                    queryString_rpa = 'select ' + fieldList_rpa[i];
            } else {
                    queryString_rpa += ', ' + fieldList_rpa[i];
            }
        }

        Set<string> mapSet = mappy.keySet();

        queryString_rpa += ' from Reward_Plan_Activity__c where ' + whereClause + ' IN : mapSet';

        system.debug('QUERY RPA FIELDS ARE ' + queryString_rpa);

        List<Reward_Plan_Activity__c> rpas = Database.query(queryString_rpa);

		for(Reward_Plan_Activity__c rpa : rpas){
			//system.debug('REWARD PLAN DESIGN IS ' + mappy.get(string.valueOf(rpa.get(whereClause))));

			rpa.Reward_Plan_Design__c = mappy.get(string.valueOf(rpa.get(whereClause)));

			for(String s : filterLookups.keySet()){
				if(filterLookups.get(s) != null){
					string exID = s.replace('__c', 'ex__c');
					if(rpa.get(exID) != null){
						
						system.debug('LOOKUP FIELD BEING FOUND ' + s);
						system.debug('OBJECT BEING FOUND ' + filterLookups.get(s));
						system.debug('LOOKUP VALUE FOUND ' + rpa.get(exID));

						foundfilters.add(s);

						if(objIDMap.isEmpty() || !objIDMap.containsKey(filterLookups.get(s))){
							/*string tempQuery = 'select id from ' + filterLookups.get(s) + ' where ' + exID + ' =\'' + string.valueOf(rpa.get(exID)) + '\'';
							system.debug('THE QUERY IS ' + tempQuery);
							sObject tempObj = Database.query(tempQuery);
							rpa.put(s,string.valueOf(tempObj.get('id')));	
							system.debug('THE NEW LOOKUP IS  ' + rpa.get(s));*/
							objIDMap.put(filterLookups.get(s), new List<String>{string.valueOf(rpa.get(exID))});
							objIdSet.add(string.valueOf(rpa.get(exID)));
						}
						else if(objIDMap.containsKey(filterLookups.get(s)) && !objIdSet.contains(string.valueOf(rpa.get(exID)))){
							objIDMap.get(filterLookups.get(s)).add(string.valueOf(rpa.get(exID)));
							objIdSet.add(string.valueOf(rpa.get(exID)));
						}
					}
				}
			}
		}

		for(String s : foundfilters){
			string exID = s.replace('__c', 'ex__c');
			for(string queryS : objIDMap.keySet()){
				List<String> objIds = objIDMap.get(queryS);
				string tempQuery = 'select id, ' + exID + ' from ' + queryS + ' where ' + exID + ' IN : objIds';
				system.debug('THE QUERY IS ' + tempQuery);
				for(sObject tempObj : Database.query(tempQuery)){
					rpaMap.put(string.ValueOf(tempObj.get(exID)),string.valueOf(tempObj.get('id')));	
				}
			}
		}
		
		system.debug('THE NEW LOOKUP MAP IS  ' + rpaMap);

		if(!rpaMap.isEmpty()){
			for(Reward_Plan_Activity__c rpa : rpas){
				for(String s : filterLookups.keySet()){
					if(filterLookups.get(s) != null){
						string exID = s.replace('__c', 'ex__c');
						system.debug('RPA ID IS ' + rpa.id);
						system.debug('RPA FIELD IS ' + exID);
						system.debug('RPA FIELD VALUE IS ' + rpa.get(exID));

						if(rpa.get(exID) != null && rpaMap.get(string.valueOf(rpa.get(exID))) != null){
							system.debug('DO WE SET A NEW LOOKUP ID ON RPA ' + rpaMap.get(string.valueOf(rpa.get(exID))));
							rpa.put(s,rpaMap.get(string.valueOf(rpa.get(exID))));
						}
					}
				}
			}
		}

		update rpas;
	}
}