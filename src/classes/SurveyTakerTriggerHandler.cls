public class SurveyTakerTriggerHandler {

    public static void onBeforeInsert(Surveytaker__C[] newsts){
        
        List<ID> accts = new List<ID>();
        Map<ID,List<Milestone1_Project__c>> accMap = new Map<ID,List<Milestone1_Project__c>>();

        for(SurveyTaker__c objst:newsts){
            if(objst.Account__c != null){
               accts.add(objst.Account__c);
            }
        }
        
        system.debug('DO WE HAVE ANY ACCOUNTS ' + accts);

        if(!accts.isEmpty()){
            for(Milestone1_Project__c acc : [select id, account__c from Milestone1_Project__c where Account__c IN : accts ORDER BY Rally_Implementation_Start_Date__c DESC]){
                if(accMap.isEmpty() || !accMap.containsKey(acc.account__c))
                    accmap.put(acc.account__c, new list<Milestone1_Project__c>{acc});
                else if(accMap.containsKey(acc.Account__c))
                    accMap.get(acc.Account__c).add(acc);
            }
            
            system.debug('IMP MAP IS ' + accMap);

            if(!accMap.isEmpty()){
                for(Surveytaker__C st : newsts){
                    if(accMap != null && st.account__c != null && accMap.containsKey(st.account__c)){
                        st.Rally_Implementation__c = accMap.get(st.account__c)[0].id;
                    }
                }
            }
        }
    }

    /*public static void OnAfterInsert(Surveytaker__C[] newsts){
    
    set<Id> setcaseid=new set<Id>();
    List<SurveyTaker__c> lstst=new List<SurveyTaker__c>();
    String clientSurveyID = Label.SurveyTriggerHandler_ClientSurveyID;

      for(SurveyTaker__c objst:newsts)
      {
          if(objst.Report__c==True){
            setcaseid.add(objst.Case__c);
            
          }
      }

      for(SurveyTaker__c objs:[select Id, case__c, Report__c from SurveyTaker__c where Case__c IN :setcaseid and ID NOT IN:newsts]){
         objs.Report__c=False;
         lstst.add(objs);
       }
      
      
      if(lstst.size()>0){
         update lstst;
      }
    
    }*/
}