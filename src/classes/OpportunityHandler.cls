public with sharing class OpportunityHandler {
    
    public static void onAfterInsert(Opportunity[] opps) {
        Map<id, AccountContactRole> acctMap = new Map<ID, AccountContactRole>();
        List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
        List<Opportunity_Next_Step__c> newNs = new List<Opportunity_Next_Step__c>();
        List<id> accts = new List<id>();

        for(Opportunity op : opps){
            accts.add(op.accountid);

            if(op.Next_Steps__c != null && op.Next_Steps__c != ''){
                Opportunity_Next_Step__c ns = new Opportunity_Next_Step__c(Opportunity__c = op.id, Next_Steps__c = op.Next_Steps__c);
                newNs.add(ns);
            }
        }

        for(account a : [select id, (select id,contactid,role from AccountContactRoles WHERE isprimary = true LIMIT 1) from Account where ID IN : accts]){
            if(!a.AccountContactRoles.isEmpty()){
                for(AccountContactRole acr : a.AccountContactRoles){
                    acctMap.put(a.id, acr);
                }
            }
        }

        if(!acctMap.isEmpty()){
            for(Opportunity op : opps){
                if(acctMap.containsKey(op.accountid)){
                    OpportunityContactRole ocr = new OpportunityContactRole();
                    ocr.contactid = acctMap.get(op.accountid).contactid;
                    ocr.opportunityid = op.id;
                    ocr.isprimary = true;
                    ocr.role = acctMap.get(op.accountid).role;
                    ocrs.add(ocr);
                }
            }
        }

        if(!ocrs.isEmpty())
            insert ocrs;

        if(!newNs.isEmpty())
            insert newNs;
    }

    public static void onAfterUpdate(Opportunity[] opps, Map<Id,Opportunity> oldOppMap){
        List<opportunitylineitem> olis = new List<opportunitylineitem>();
        List<Opportunity_Next_Step__c> newNs = new List<Opportunity_Next_Step__c>();

        for(Opportunity o : [select id, Go_Live__c,Next_Steps__c, Membership_Term__c, (select id from opportunitylineitems) From Opportunity WHERE ID IN : opps]){
            if(((o.go_live__c != oldOppMap.get(o.id).go_live__c) || (o.Membership_Term__c != oldOppMap.get(o.id).Membership_Term__c)) && !o.opportunitylineitems.isEmpty()){
                olis.addAll(o.opportunitylineitems);
            }

            if(o.Next_Steps__c != null && o.Next_Steps__c != '' && o.Next_Steps__c != oldOppMap.get(o.id).Next_Steps__c){
                Opportunity_Next_Step__c ns = new Opportunity_Next_Step__c(Opportunity__c = o.id, Next_Steps__c = o.Next_Steps__c);
                newNs.add(ns);
            }
        }

        if(!olis.isEmpty())
            update olis;

        if(!newNs.isEmpty())
            insert newNs;
    }


    public static void onBeforeInsert(Opportunity[] opps) {
        Map<id, id> unaprovedids = new Map<ID, id>();
        Map<id, id> approvedids = new Map<ID, id>();
        List<id> rtypes = new List<id>();

        for(Opportunity op : opps){
            rtypes.add(op.recordtypeID);
            Date dateTemp;
            
            if(op.Go_Live__c != null)
                dateTemp = Date.newInstance(op.Go_Live__c.year(),op.Go_Live__c.month(),op.Go_Live__c.day());
            else
                dateTemp = Date.newInstance(op.CloseDate.year(),op.CloseDate.month(),op.CloseDate.day());
            
            string dateString = dateTemp.format();
            op.name = op.account_name__c + ' - ' + dateString + ' - ' + op.record_type_name__c;
        }

        for(Sales_Channel__c sc : [select id, Unapproved_Record_Type_ID__c, Approved_Record_Type_ID__c from Sales_Channel__c where (Unapproved_Record_Type_ID__c IN : rtypes OR Approved_Record_Type_ID__c IN : rtypes)]){
            unaprovedids.put(sc.Unapproved_Record_Type_ID__c, sc.id);
            approvedids.put(sc.Approved_Record_Type_ID__c, sc.id);
        }

        for(Opportunity op : opps){
            if(unaprovedids != null && unaprovedids.containsKey(op.recordtypeID))
                op.Sales_Channel__c = unaprovedids.get(op.recordtypeID);
            else if(approvedids != null && approvedids.containsKey(op.recordtypeID))
                op.Sales_Channel__c = approvedids.get(op.recordtypeID);
        }
    }

    public static void onBeforeUpdate(Opportunity[] opps, Map<Id,Opportunity> oldOppMap){
        system.debug('DO WE GET HERE BEFORE UPDATE ' + opps);
        
        for(Opportunity op : opps){
            Date dateTemp;
            
            if(op.Go_Live__c != null)
                dateTemp = Date.newInstance(op.Go_Live__c.year(),op.Go_Live__c.month(),op.Go_Live__c.day());
            else
                dateTemp = Date.newInstance(op.CloseDate.year(),op.CloseDate.month(),op.CloseDate.day());
            
            string dateString = dateTemp.format();
            op.name = op.account_name__c + ' - ' + dateString + ' - ' + op.record_type_name__c;
        }   
    }

    public static void onBeforeDelete(Opportunity[] opps) {
        
        set<String> permissionname =Utils.findUserPermissions(userinfo.getUserId());
        if(opps.size()>1 && !permissionname.contains('Delete Opportunities') && (userinfo.getprofileId()!= Label.System_Admin_Profile_ID))
        {
            opps[1].addError(Label.Opportunit_DelError);
        }

    }
}