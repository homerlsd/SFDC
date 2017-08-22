public class InternalKnowledgeHandler {
    
    @InvocableMethod
    public static void newInternalQuestion(List<Id> qavIDs)
    {
        List<Group_Article__c> newGas = new List<Group_Article__c>();
        Map<String, Knowledge_Group__c> kbMap  = new Map<String, Knowledge_Group__c>();

        for(Knowledge_Group__c kb : [select id, Partner_lookup__r.name, Partner_lookup__c from Knowledge_Group__c where Active__c = true AND Partner_Lookup__c != null AND Default_Group_for_Partner__c = true]){
            kbMap.put(kb.Partner_lookup__r.name, kb);
        }

        String query = CC_Constants.BASE_QUERY_INTERNAL_UNPUBLISHED + ' AND ID IN : qavIDS';
        //String query = CC_Constants.BASE_QUERY + ' AND ID IN : qavIDS';
        List<Internal__kav> iks = database.query(query);

        system.debug('QUESTION IS ' + iks);
        system.debug('MAP IS ' + kbMap);
        
        if(!iks.isEmpty()){ 
            for(Internal__kav q : iks){
                
                system.debug('PARTNER IS ' + q.Partner__c);

                if(q.Partner__c != null){
                    List<string> partners = q.Partner__c.split(';');
                    
                    system.debug('Partner strings are ' + partners);

                    for (string s: partners) {
                        Group_Article__c newGa = new Group_Article__c();
                        newGa.Knowledge_Group__c = kbMap.get(s).id;
                        newGa.Knowledge_Article_ID__c = q.KnowledgeArticleID;
                        newGa.Active__c = true;
                        newGa.Knowledge_Summary__c = q.summary;
                        newGa.Knowledge_Title__c = q.title;
                        newGa.knowledge_description__c = q.Troubleshooting_steps__c;
                        newGa.Knowledge_LastPublishedDate__c = date.valueOf(q.LastPublishedDate);
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