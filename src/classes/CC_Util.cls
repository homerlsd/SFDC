public class CC_Util {

	public static String getGroupName(String paramClient, String paramPartner, String paramAffiliation, String channel){
		
		system.debug('DO WE GET IN GROUP NAME ' + paramClient + ' - ' + paramPartner + ' - ' + paramAffiliation + ' - ' + channel);
		string groupName = '';

		if(channel == null || channel == '')
			channel = CC_Constants.DEFAULT_CHANNEL_NAME;


		if(parampartner == null || parampartner == '' || paramClient == null || paramClient == '' || paramAffiliation == null || paramAffiliation == ''){
			List<Knowledge_Group__c> kg = [select id, Group_Name__c from Knowledge_Group__c where Channel__r.name = : channel AND Default_Group_for_Channel__c = true AND Active__c = true ORDER BY CreatedDate DESC LIMIT 1];
					if(!kg.isEmpty())
						groupName = kg[0].Group_Name__c;
		}
		else{
			
			system.debug('FINDING DEFAULT GROUP FOR AFFILIATION ' + paramAffiliation);

			List<Knowledge_Group__c> kbs = [select id, Group_Name__c from Knowledge_Group__c
											where Client__c = :paramClient 
	                    						AND Partner__c = :paramPartner
	                    							AND Affiliation__c =:paramAffiliation
	                    								AND Channel__r.Name =:channel
	                    									AND Active__c = true];
			if(!kbs.isEmpty()){
				groupName = kbs[0].Group_Name__c;
			}
			else{					
				system.debug('FINDING DEFAULT GROUP FOR CLIENT ' + paramClient);

				List<Knowledge_Group__c> kbsc = [select id,
													   Group_Name__c
													   from Knowledge_Group__c
													   WHERE Client__c = :paramClient
													   AND Default_Group_for_Client__c = true
													   AND Active__c = true
													   ORDER BY CreatedDate DESC
													   LIMIT 1];
				if(!kbsc.isEmpty()){
					groupName = kbsc[0].Group_Name__c;
				}	
				else{
					system.debug('FINDING DEFAULT GROUP FOR PARTNER ' + parampartner);
					
					List<Knowledge_Group__c> kbs1 = [select id,
														   Group_Name__c
														   from Knowledge_Group__c
														   WHERE Partner__c = :paramPartner
														   AND Default_Group_for_Partner__c = true
														   AND Active__c = true
														   ORDER BY CreatedDate DESC
														   LIMIT 1];
					if(!kbs1.isEmpty()){
						groupName = kbs1[0].Group_Name__c;
					}	
					else{
						system.debug('FINDING DEFAULT GROUP FOR CHANNEL ' + channel);

						List<Knowledge_Group__c> kg = [select id, Group_Name__c from Knowledge_Group__c where Channel__r.name = : channel AND Default_Group_for_Channel__c = true AND Active__c = true ORDER BY CreatedDate DESC LIMIT 1];
						if(!kg.isEmpty())
							groupName = kg[0].Group_Name__c;
					}	
				}						   
			}
		}

	    return groupName;
	}

	public static List<String> getGroupIDs(String groupName){
		List<String> groupIds = new List<String>();

	    List<Group_Article__c> groupArticles;
	    
	    if(!String.isEmpty(groupName)){
	        string paramName = String.escapeSingleQuotes(groupName);
	       
	        groupArticles = [Select Knowledge_Article_ID__c from Group_Article__c WHERE Active__c = true
	                    		AND Knowledge_Group__r.Group_Name__c = : paramName AND Active__c = true];
			
			system.debug('Group Articles Are ' + groupArticles);
	    }else {
	        groupArticles = [select Knowledge_Article_ID__c from Group_Article__c where Active__c = true
	        					AND Knowledge_Group__c = : CC_Constants.DEFAULT_GROUP_ID];
	    }
	    if(groupArticles.size()>0){
	    	for(Group_Article__c ga : groupArticles){
	    		groupIds.add(ga.Knowledge_Article_ID__c);
	    	}
	    }
	    return groupIds;
	}

	public static Knowledge_Group__c GetGroupInfo(String groupName){
		List<Knowledge_Group__c> chanG = [select id, Affiliation__c,Client__c,Partner_Lookup__c,Partner_Lookup__r.name, Show_Live_Agent__c,Channel__r.Case_Record_Type_ID__c, Support_Number__c,Partner_lookup__r.Support_Number__c,Channel__r.name, Channel__r.id, Channel__r.DNIS_Formula__c, Channel__r.DNIS_Support_Number__c FROM Knowledge_Group__c where Group_Name__c =: groupName];

		if(!chang.isEmpty()){
			system.debug('WE FIND A CHANNEL - FOOTER ' + chang);
			return chanG[0];
		}
		else{
			List<Knowledge_Group__c> kbDefault = [select id, Affiliation__c,Client__c,Partner_Lookup__c,Partner_Lookup__r.name, Show_Live_Agent__c,Channel__r.Case_Record_Type_ID__c, Support_Number__c,Partner_lookup__r.Support_Number__c,Channel__r.name, Channel__r.id,Channel__r.DNIS_Formula__c, Channel__r.DNIS_Support_Number__c FROM Knowledge_Group__c where ID = : CC_Constants.DEFAULT_GROUP_ID];
			system.debug('WE FIND NO CHANNEL - FOOTER - DEFAULT ' + kbDefault);
			return kbDefault[0];
		}
	}
}