public class LiveChatTranscriptTriggerHandler {
	
	public static void onBeforeUpsert(LiveChatTranscript[] transcripts) {
        Map<string, string> mappy = new Map<string,string>();
        Map<id,case> cMap = new Map<id,case>();
        Set<id> caseIDs = new Set<ID>();

        for(LiveChatTranscript lc : transcripts){
        	if(lc.CaseID != null && trigger.isInsert){
        		caseIDs.add(lc.CaseID);
        	}
        }

        for(Case c : [select id,
        					 Chat_Key__c,
        					 Thread_ID__c,
        					 Email_Formula__c,
        					 Live_Agent_Transcript_Send_Email__c,
        					 Send_Live_Agent_Transcript__c
        					 from case where
        					 ID IN : caseIDs]){

        	cMap.put(c.id, c);
        }

        for(Regex__mdt reg : [select label, Replacement_String__c from Regex__mdt]){
        	mappy.put(reg.label, reg.Replacement_String__c);
        }

		//example for social security number with dash:
        //Label = '([0-9]{3}-[0-9]{2}-[0-9]{4})';
		//Replacement String = xxx-xx-xxxx;
		for(string s : mappy.keySet()){
			Pattern globalPattern = Pattern.compile(s);
			for(LiveChatTranscript lct : transcripts){

				if(cMap.containsKey(lct.CaseID)
					&& cMap.get(lct.CaseID).Send_Live_Agent_Transcript__c == true
						&& lct.Send_Transcript_Email__c == false){
							lct.Send_Transcript_Email__c = true;
         				    lct.Thread_ID__c = cMap.get(lct.caseID).Thread_ID__c;
		            		lct.Transcript_Send_Address__c = ((cMap.get(lct.caseID).Live_Agent_Transcript_Send_Email__c == null || cMap.get(lct.caseID).Live_Agent_Transcript_Send_Email__c == '') ? cMap.get(lct.caseID).Email_Formula__c : cMap.get(lct.caseID).Live_Agent_Transcript_Send_Email__c);
				}

	        	if(lct.body != null && lct.body != ''){        		
	            	Matcher regexMatcher = globalPattern.matcher(lct.body);

	            	if(regexMatcher.find()) {
					   lct.body = lct.body.replaceAll(s, mappy.get(s));
					}
	        	}
	        }
		}
    }
}