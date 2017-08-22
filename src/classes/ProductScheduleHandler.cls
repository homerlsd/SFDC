public class ProductScheduleHandler {
  public static void isBeforeInsert(Product_Schedule__c[] ps) {

    Map<id, List<Product_Schedule__c>> oppMap = new Map<id, List<Product_Schedule__c>>();
    Map<id, id> contMap = new Map<id, id>();
    List<Opportunity_Schedule__c> newSchedles = new List<Opportunity_Schedule__c>();

    Map<integer,integer> calMap = Utils.getCalendarMap();
    
    for(Product_Schedule__c p : ps){
      
      if(p.Opportunity_Schedule__c != null)
        continue;

      if(oppMap.isEmpty() || !oppMap.containsKey(p.opportunity__c))
        oppMap.put(p.opportunity__c, new List<Product_Schedule__c>{p});
      else if (oppMap.containsKey(p.opportunity__c))
        oppMap.get(p.opportunity__c).add(p);
    }

    system.debug('OPP WITH SCHEDULE IS ' + oppMap);

    for(opportunity o : [select id,
                  Sales_Channel__c,
                  Go_Live__c,
                  AccountId,
                  Membership_Term__c,
                  (select id from Opportunity_Schedule__r)
                  from opportunity where ID IN : oppMap.keySet()]){
      
      if(!o.Opportunity_Schedule__r.isEmpty()){
        system.debug('WE HAVE CURRENT CONTRACT ID ON THIS OPPTY ' + o.Opportunity_Schedule__r[0].id);

        contMap.put(o.id, o.Opportunity_Schedule__r[0].id);
      }
      else{
        system.debug('WE DO NOT HAVE CURRENT CONTRACT ID ON THIS OPPTY ');
        
        Opportunity_Schedule__c c = new Opportunity_Schedule__c();
        c.Account__c = o.AccountId;
        c.opportunity__c = o.id;
        c.start_date__c = o.Go_Live__c;
        c.channel__c = o.Sales_Channel__c;

        newSchedles.add(c);
      }
    }

    if(!newSchedles.isEmpty()){
      insert newSchedles;

      for(Opportunity_Schedule__c c : [select opportunity__c, id from Opportunity_Schedule__c where ID IN : newSchedles]){
        system.debug('DO WE GET HERE - NEW CONTRACT INSERTED ' + c);
        contMap.put(c.Opportunity__c, c.id);
      }
    }

    if(!contMap.isEmpty()){
      for(Product_Schedule__c p : ps){
        if(contMap.containsKey(p.Opportunity__c)){
          p.Opportunity_Schedule__c = contMap.get(p.Opportunity__c);
        }
      }
    }
  }

  public static void isAfterInsert(Product_Schedule__c[] ps, Map<id, Product_Schedule__c> oldmap) {
    
    List<Opportunity_Schedule__c> upCons = new List<Opportunity_Schedule__c>();
    List<opportunity> oppys = new List<opportunity>();
    Set<id> setCheck = new Set<id>();
    Set<id> oppScheduleIDs = new Set<id>();
    Set<id> opptyIds = new Set<id>();
    Map<string, AggregateResult> valueMap = new Map<string, AggregateResult>();
    Map<string, AggregateResult> datesMap = new Map<string, AggregateResult>();
    Map<string, AggregateResult> fyMap = new Map<string, AggregateResult>();
    Map<string, AggregateResult> rrMap = new Map<string, AggregateResult>();

    for(Product_Schedule__c pp : ps){
      oppScheduleIDs.add(pp.Opportunity_Schedule__c);
      opptyIds.add(pp.Opportunity__c);
    }

    for (AggregateResult a :  [select Sum(Amount__c) amt,
                      Opportunity__c
                      from Product_Schedule__c
                      where Opportunity__c IN: opptyIds
                      AND Counts_Towards_FYR__c = true
                      GROUP BY Opportunity__c]) {
            fyMap.put(String.ValueOf(a.get('Opportunity__c')), a);
        }

        for (AggregateResult a :  [select Sum(Amount__c) amt,
                      Opportunity__c
                      from Product_Schedule__c
                      where Opportunity__c IN: opptyIds
                      AND Counts_Towards_RR__c = true
                      GROUP BY Opportunity__c]) {
            rrMap.put(String.ValueOf(a.get('Opportunity__c')), a);
        }

    for (AggregateResult a :  [select Sum(Amount__c) amt,
                      Opportunity_Schedule__c
                      from Product_Schedule__c
                      where Opportunity_Schedule__c IN: oppScheduleIDs GROUP BY Opportunity_Schedule__c]) {
            valueMap.put(String.ValueOf(a.get('Opportunity_Schedule__c')), a);
        }

        for (AggregateResult a :  [select Max(End_Date__c) endD,
                      Min(Start_Date__c) srtD,
                      Opportunity_Schedule__c
                      from Product_Schedule__c
                      where Opportunity_Schedule__c IN: oppScheduleIDs 
                      AND Product__r.Revenue_Recognition__c != 'Date Of'
                      GROUP BY Opportunity_Schedule__c]) {
            datesMap.put(String.ValueOf(a.get('Opportunity_Schedule__c')), a);
        }

        system.debug('valueMap is ' + valueMap);

    for(Opportunity_Schedule__c c : [select id, Start_Date__c, End_Date__c, Total_Price__c from Opportunity_Schedule__c where ID IN : valueMap.keySet()]){
      
      if(!datesMap.isEmpty() && datesMap.containsKey(c.id)){
        c.Start_Date__c = date.valueOf(datesMap.get(c.id).get('srtD'));
        c.End_Date__c = date.valueOf(datesMap.get(c.id).get('endD'));
      }
      
      c.Total_Price__c = decimal.valueOf(valueMap.get(c.id).get('amt') + '');
      upCons.add(c);
    }

    system.debug('FIRST YEAR MAP IS ' + fyMap);
    system.debug('SECOND YEAR MAP IS ' + rrMap);

    for(Opportunity op : [select id, first_year_revenue__c, second_year_run_rate__c from Opportunity where ID IN : opptyIds]){

      boolean putInList = false;

      if(!fyMap.isEmpty() && fyMap.containsKey(op.id)){
        
        system.debug('DO WE GET HERE  - FIRST YEAR REVENUE' + decimal.valueOf(fyMap.get(op.id).get('amt') + ''));

        op.first_year_revenue__c = decimal.valueOf(fyMap.get(op.id).get('amt') + '');
        putInList = true;
      }
      if(!rrMap.isEmpty() && rrMap.containsKey(op.id)){
        system.debug('DO WE GET HERE  - 2ND YEAR REVENUE' + decimal.valueOf(rrMap.get(op.id).get('amt') + ''));
        
        op.second_year_run_rate__c = decimal.valueOf(rrMap.get(op.id).get('amt') + '');
        putInList = true;
      }

      system.debug('PUT IN LIST IS ' + putInList);

      if(putInList==true)
        oppys.add(op);
    }

    if(!upCons.isEmpty())
      update upCons;

    if(!oppys.isEmpty())
      update oppys;
  }

  public static void isAfterDelete(Product_Schedule__c[] ps, Map<id, Product_Schedule__c> oldmap) {
    
    Set<id> oppScheduleIDs = new Set<id>();
    Set<string> delCons = new Set<string>();

    //NOTE: This is always going to be 1 contract ID, so the below code is not bulkified as it is not needed
    for(Product_Schedule__c p : ps){
      oppScheduleIDs.add(p.Opportunity_Schedule__c);
    }

    system.debug('DO WE HAVE CONTRACT IDS FOR DELETED SCHEDULE ' + oppScheduleIDs); 

    List<Product_Schedule__c> pss = [select id from Product_Schedule__c where Opportunity_Schedule__c IN : oppScheduleIDs];

    if(pss.isEmpty()){
          Opportunity_Schedule__c[] cons = [select id from Opportunity_Schedule__c where ID IN : oppScheduleIDs];
          
          List<Opportunity_Schedule__c> consup=new List<Opportunity_Schedule__c>();
          
          
          
          if(!cons.isEmpty())
          {
          for(Opportunity_Schedule__c op:cons){
            op.OwnerId=Label.Sales_Queue;
            consup.add(op);
          }
          update cons;
          delete cons;
        }
    }
  }
}