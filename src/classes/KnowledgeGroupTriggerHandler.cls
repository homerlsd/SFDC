public class KnowledgeGroupTriggerHandler {

    private boolean m_isExecuting = false;
    
    public static void OnAfterInsert(Knowledge_Group__c[] newKBG){
        List<Group_Article__c> newGAs = new List<Group_Article__c>();
        List<Knowledge_Group__c> updateKbs = new List<Knowledge_Group__c>();
        Map<id, id> chanMap = new Map<id, id>();
        Map<id, id> partnerMap = new Map<id, id>();
        Set<id> channels = new Set<id>();
        Map<id, List<Question__kav>> questMap = new Map<id, List<Question__kav>>();

        for(Knowledge_Group__c kb : newKBG){
            if(kb.Default_Group_For_Channel__c == true){
                chanMap.put(kb.channel__c, kb.id);
            }
            if(kb.Default_Group_for_Partner__c == true){
                partnerMap.put(kb.Partner_lookup__c, kb.id);
            }

            if(kb.Apply_Defaults__c){
                channels.add(kb.channel__c);
            }
        }
        system.debug('CHAN MAP IS ABOVE ' + chanMap);
        
        if(trigger.isInsert){

            List<Question__kav> qs = database.query(CC_Constants.BASE_QUERY + ' AND Channel__c IN : channels AND Is_Default_Question__c = true order by Category__c');

            if(!qs.isEmpty()){
                for(Question__kav q : qs){
                    if(!questMap.containsKey(q.channel__c))
                        questMap.put(q.channel__c, new List<Question__kav>{q});
                    else 
                        questMap.get(q.channel__c).add(q);
                }
            }


            for(Knowledge_Group__c kb : newKBG){
                if(kb.Apply_Defaults__c && !questMap.isEmpty() && questMap.containsKey(kb.Channel__c)){
                    for(Question__kav qav : questMap.get(kb.channel__c)){
                        Group_Article__c ga = new Group_Article__c();
                        ga.Knowledge_Group__c = kb.id;
                        ga.Knowledge_Article_ID__c = qav.knowledgearticleid;
                        ga.Knowledge_Summary__c = qav.summary;
                        ga.Knowledge_Title__c = qav.title;
                        ga.Knowledge_LastPublishedDate__c = Date.valueOf(qav.LastPublishedDate);
                        ga.Knowledge_Description__c = qav.RichTextSummary__c;
                        ga.Is_Common_Question__c = qav.Is_Common_Question__c;
                        ga.Is_Default_Question__c = true;
                        ga.Channel__c = kb.channel__c;
                        ga.active__c = true;
                        newGAs.add(ga);
                    }
                }
            }
        }
        
        Set<id> updateSet = new Set<id>();

        if(!chanMap.isEmpty()){

            system.debug('CHAN MAP IS ' + chanMap);

            for(Sales_Channel__c chan : [select id,
                                                (select id,
                                                Default_Group_For_Channel__c
                                                from Knowledge_Groups__r
                                                WHERE Default_Group_For_Channel__c = true
                                                AND ID NOT IN : chanMap.values())
                                                FROM Sales_Channel__c 
                                                WHERE ID IN : chanMap.keySet()]){

                system.debug('CHANNEL GROUPS ARE ' + chan.Knowledge_Groups__r);
                
                if(!chan.Knowledge_Groups__r.isEmpty()){
                    for(Knowledge_Group__c kb1 : chan.Knowledge_Groups__r){
                        kb1.Default_Group_For_Channel__c = false;
                        updateKbs.add(kb1);
                        updateSet.add(kb1.id);
                    }
                }
            }
        }

        if(!partnerMap.isEmpty()){
            system.debug('Partner MAP IS ' + partnerMap);

            for(Partner__c partner : [select id,
                                            (select id,
                                            Default_Group_For_partner__c
                                            from Knowledge_Groups__r
                                            WHERE Default_Group_For_partner__c = true
                                            AND ID NOT IN : partnerMap.values())
                                            FROM Partner__c 
                                            WHERE ID IN : partnerMap.keySet()]){

                system.debug('partner GROUPS ARE ' + partner.Knowledge_Groups__r);
                
                if(!partner.Knowledge_Groups__r.isEmpty()){
                    for(Knowledge_Group__c kb1 : partner.Knowledge_Groups__r){
                        kb1.Default_Group_For_Partner__c = false;
                        if(updateSet.isEmpty() || (!updateSet.isEmpty() && !updateSet.contains(kb1.id))){
                            updateKbs.add(kb1); 
                            updateSet.add(kb1.id);
                        }
                    }
                }
            }
        }

        if(!updateKbs.isEmpty())
            update updateKbs;

        if(!newGAs.isEmpty())
            insert newGAs;
    }   


    /*public void OnAfterUpdate(Knowledge_Group__c[] oldKnowledge_Group__cs, Knowledge_Group__c[] updatedKnowledge_Group__cs, MapKnowledge_Group__cMap){
        // AFTER UPDATE LOGIC
    }

    public void OnBeforeDelete(Knowledge_Group__c[] Knowledge_Group__csToDelete, MapKnowledge_Group__cMap){
        // BEFORE DELETE LOGIC
    }

    public void OnAfterDelete(Knowledge_Group__c[] deletedKnowledge_Group__cs, MapKnowledge_Group__cMap){
        // AFTER DELETE LOGIC
    }

    public void OnUndelete(Knowledge_Group__c[] restoredKnowledge_Group__cs){
        // AFTER UNDELETE LOGIC
    }*/

}