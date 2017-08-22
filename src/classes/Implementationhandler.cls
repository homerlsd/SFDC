public class Implementationhandler 
{   
    
    public static void onBeforeupsert(Milestone1_Project__c[] imps) {
        Set<Id> rtypes = new Set<Id>();
        Map<Id, string> maprecpartners = new Map<Id, string>();
        Map<string, Sales_channel__c> channelMap = new Map<string, Sales_channel__c>();
        Map<string, partner__c> partnerMap = new Map<string, partner__c>();

        for(Sales_Channel__c chan:Utils.Channels){
           if(!channelMap.containsKey(chan.Name)){
                channelMap.put(chan.Name, chan);
           }
        }

        for(Partner__c partner:Utils.Partners){
            if(!partnerMap.containsKey(partner.Name)){
                partnerMap.put(partner.Name, partner);
            }
        }
        
        for(Milestone1_Project__c imp :imps){
            string chanString = imp.Record_Type_Name__c.split('-')[0].trim();
            string partString = imp.Record_Type_Name__c.split('-')[1].trim();
            
            if(channelMap.containsKey(chanString))
                imp.Channel__c = channelMap.get(chanString).id;
            if(partnerMap.containsKey(partString))
                imp.Partner__c = partnerMap.get(partString).id;
        }
    } 

     public static void onAfterUpsert(Milestone1_Project__c[] imps) {

        //Policy Number/PVRC Vars
        Set<ID> impIds = new Set<ID>();
        List<Policy_Number__c> newPols = new List<Policy_Number__c>();
        Map<ID, Set<String>> policyMap = new Map<ID, Set<String>>();

        for(Milestone1_Project__c imp :imps){
            impIds.add(imp.id);
        }

        for(Policy_Number__c pnum : [select id, name, implementation__c from Policy_Number__c where implementation__c IN : impIds]){
            if(policyMap.isEmpty() || !policyMap.containsKey(pnum.Implementation__c))
                policyMap.put(pnum.Implementation__c, new Set<String>{pnum.name});
            else if(policyMap.containsKey(pnum.Implementation__c))
                policyMap.get(pnum.Implementation__c).add(pnum.name);
        }

        for(Milestone1_Project__c imp :imps){
            //Policy Number/PVRC work - calls utils class to do the inserts with dynamic apex
            if(imp.Policy_Numbers_DHP__c != null){
                string[] keyss = imp.Policy_Numbers_DHP__c.split(';');
                Set<String> checkSet = new Set<String>();
                
                if(policyMap.containsKey(imp.id))
                    checkSet.addAll(policyMap.get(imp.id));

                system.debug('EXISTING POLICY IDS FOR THIS IMPLEMENTATION ' + checkSet);

                for(string s2 : keyss){         
                    if(checkSet.isEmpty() || !checkSet.contains(s2)){
                        Policy_Number__c pl = new Policy_Number__c(implementation__c = imp.id, name = s2);
                        checkSet.add(s2);
                        newPols.add(pl);
                    }

                    system.debug('New Policy IDS are ' + newPols);

                }
            }
        }

        if(!newPols.isEmpty())
            insert newPols;
     }
}