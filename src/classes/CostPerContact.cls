global class CostPerContact Implements Schedulable
    {
        global void execute(SchedulableContext sc)
        {
            createCost();
        }

        public void createCost()
        {

            Internal_Cost__c cost = new Internal_Cost__c();

            Date td = Date.today()-1;
            cost.Month__c = Utils_Support.MonthMap().get(td.month());
            cost.Year__c = string.valueOf(td.year());

            Internal_Cost__c[] checkCost = [select id,
                                                   name,
                                                   Month__c,
                                                   Year__c,
                                                   T1_Cost__c,
                                                   T2_Cost__c,
                                                   Lead_Cost__c,
                                                   Supervisor_Cost__c,
                                                   Total_Interactions__c
                                                   from Internal_Cost__c
                                                   Where Month__c = : cost.Month__c AND Year__c = : Cost.Year__c];
            if(!checkCost.isEmpty())
                cost = checkCost[0].clone(true);

            string withzero = td.month() < 10 ? '0'+String.valueOf(td.month()) : String.valueOf(td.month());

            cost.name = Label.CostPerContact_NameLabel + ' ' + withzero + '/' + cost.Year__c; 

            Map<Decimal, Integer> t1Map = Utils_Support.getCost( new List<String> {Label.CostPerContact_Tier1RoleName});
            Map<Decimal, Integer> t2Map = Utils_Support.getCost( new List<String> {Label.CostPerContact_Tier2RoleName,Label.CostPerContact_ThinkTankRoleName});
            Map<Decimal, Integer> leadMap = Utils_Support.getCost( new List<String> {Label.CostPerContact_LeadRoleName});
            Map<Decimal, Integer> superMap = Utils_Support.getCost( new List<String> {Label.CostPerContact_ManagerRoleName});

            List<Decimal> t1cost = new List<Decimal>();
            t1cost.addAll(t1Map.KeySet());
            List<Decimal> t2cost = new List<Decimal>();
            t2cost.addAll(t2Map.KeySet());
            List<Decimal> LeadCost = new List<Decimal>();
            LeadCost.addAll(leadMap.KeySet());
            List<Decimal> supercost = new List<Decimal>();
            supercost.addAll(superMap.KeySet());

            cost.T1_Cost__c = t1cost[0];
            cost.T1_Count__c = t1Map.Values()[0];
            cost.T2_Cost__c = t2cost[0];
            cost.T2_Count__c = t2Map.Values()[0];
            cost.Lead_Cost__c = LeadCost[0];
            cost.Lead_Count__c = leadMap.Values()[0];
            cost.Supervisor_Cost__c = supercost[0];
            cost.Supervisor_Count__c = superMap.Values()[0];

            integer interactions = 0;

            Set<String> bademails = new Set<String>{'noreply@rallyhealth.com','noreply@werally.com','notifications@werally.com','replies@werally.com'};

            integer tsk = [select Count() from task where createdDate = LAST_MONTH AND Five9__Five9SessionId__c != null];
            integer chats = [select Count() from LiveChatTranscript where createdDate = LAST_MONTH];
            integer emails = [select Count() from EmailMessage where createdDate = LAST_MONTH AND incoming = true AND parentID != NULL AND Parent.OwnerID != : Label.CostPerContact_MarketingBouncesQueueID];
            integer ccomments = [select Count() from CaseComment where createdDate = LAST_MONTH AND ConnectionReceivedId != null];
            
            integer historys = 0;

            for(CaseHistory ch : [select id,NewValue from CaseHistory where createdDate = LAST_MONTH AND Field = 'Status' AND Case.OwnerID != : Label.CostPerContact_MarketingBouncesQueueID]){
                if(ch.NewValue == 'Pending ERT (New)')
                    historys++;
            }

            cost.Total_Interactions__c = tsk+chats+emails+ccomments+historys;

            upsert cost;
        }
    }