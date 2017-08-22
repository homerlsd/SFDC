public class Knowledge_Utils {
	
	@InvocableMethod
    public static void newDefaultQuestion(List<Id> qavIDs)
    {
    	List<Group_Article__c> newGas = new List<Group_Article__c>();
    	Map<id, List<Knowledge_Group__c>> kbMap	 = new Map<id, List<Knowledge_Group__c>>();

		for(Knowledge_Group__c kb : [select id, channel__c from Knowledge_Group__c where Active__c = true AND Channel__c != null]){
			if(!kbMap.containsKey(kb.Channel__c))
				kbMap.put(kb.Channel__c, new List<Knowledge_Group__c>{kb});
			else
				kbMap.get(kb.Channel__c).add(kb);
		}

 		String query = CC_Constants.BASE_QUERY_UNPUBLISHED + ' AND ID IN : qavIDS';
    	//String query = CC_Constants.BASE_QUERY + ' AND ID IN : qavIDS';
    	List<Question__Kav> qs = database.query(query);

    	system.debug('QUESTION IS ' + qs);
    	system.debug('MAP IS ' + kbMap);
    	
    	if(!qs.isEmpty()){ 
        	for(Question__Kav q : qs){
        		
        		system.debug('QUESTION CHANNEL IN LOOP IS ' + q.Channel__c);

        		if(q.Channel__c != null && kbMap.containsKey(q.Channel__c)){
					for (Knowledge_Group__c kb: kbMap.get(q.Channel__c)) {
			    		Group_Article__c newGa = new Group_Article__c();
			    		newGa.Knowledge_Group__c = kb.id;
			    		newGa.Knowledge_Article_ID__c = q.KnowledgeArticleID;
			    		newGa.Active__c = true;
			    		newGa.Knowledge_Summary__c = q.summary;
			    		newGa.Knowledge_Title__c = q.title;
			    		newGa.knowledge_description__c = q.RichTextSummary__c;
			    		newGa.Is_Default_Question__c = true;
			    		newGa.Is_Common_Question__c = q.Is_Common_Question__c;
			    		newGa.Knowledge_LastPublishedDate__c = date.valueOf(q.LastPublishedDate);
			    		newGa.Channel__c = q.Channel__c;
			    		newGas.add(newGa);
			    	}
			    }
        	}
 		}
 
 		system.debug('NEWGAS IS ' + newGas);

 		if(!newGas.isEmpty())
 			insert newGas;
    }
}