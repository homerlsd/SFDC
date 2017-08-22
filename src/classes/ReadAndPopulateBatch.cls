global with sharing class ReadAndPopulateBatch implements Database.batchable<String>, Database.Stateful
{
    public String m_csvFile {get;set;}
    public String m_csvName {get;set;}
    private boolean firstbatch;
    global String CR = '\r';    
    global String errorLineIds {get;set;}    

    private static final Integer SCOPE_SIZE = 200;
   
    public ReadAndPopulateBatch(String csvFile){
      //m_csvName = csvName;
        m_csvFile = csvFile;
        errorLineIds = '';
        firstbatch = true;
    }

    global Iterable<String> start(Database.batchableContext batchableContext)
    { 
        return new CSVIterator(m_csvFile, CR);
    }
    global void execute(Database.BatchableContext batchableContext, List<String> scope)  
    { 
        //TODO: Create a map with the column name and the position.
        String csvFile = '';
        system.debug('Scope Size IS ' + scope.size());
        
        List<Account> newAccs = new List<Account>();
        List<Opportunity> newOpps = new List<Opportunity>();
        List<OpportunityLineItem> upsertOlis = new List<OpportunityLineItem>();
        List<OpportunityLineItem> newLines = new List<OpportunityLineItem>();
        
        Set<Id> newAcctIds =  new Set<Id>();
        Set<Id> newOppIds =  new Set<Id>();
        Set<Id> existingOppIds =  new Set<Id>();
        Map<String,Account> acctMap = new Map<string,Account>();
        Map<String,Opportunity> oppMap = new Map<string,Opportunity>();
        Map<String,PricebookEntry> priceMap = new Map<string,PricebookEntry>();

        for(String row : scope)
        {
            csvFile += row + CR;
        }
       
        Blob bCSV = blob.valueOf(csvFile);

        List<List<String>> csvLines = CSVFileUtil.parseCSV(bCSV,firstbatch);
        firstbatch=false;
        system.debug('CSV LINES ARE ' + csvLines);
        system.debug('CSV LINES SIZE IS  ' + csvLines.size());

        for(PricebookEntry pb2 : [select id,isactive,product2id,unitprice,Pricebook2Id,product2.optum_product_id__c,product2.description,product2.sales_notes__c,product2.Product_Type__c,product2.Product_Sub_Type__c from PricebookEntry WHERE product2.optum_product_id__c != null AND isActive = true]){
            priceMap.put(pb2.Product2.optum_product_id__c, pb2);
        }

        Account[] accts = [select id, name, External_Partner_ID__c from Account where External_Partner_ID__c != null];
        
        for(account a: accts){
            acctMap.put(a.External_Partner_ID__c, a);
        }
        
        system.debug('Account Map is ' + acctMap);
        system.debug('Account Map SIZE IS ' + acctMap.size());

        Opportunity[] opps = [select id,
                                   name,
                                   stagename,
                                   Probability,
                                   CloseDate,
                                   Go_Live__c,
                                   Close_Reason__c,
                                   Closed_Other_Reason__c,
                                   External_Consultant_Name__c,
                                   External_Partner_ID__c,
                                   External_Sales_Category__c,
                                   External_Sales_Channel__c,
                                   Fee_Type__c,
                                   Purchase_type__c,
                                   Market_Segment__c,
                                   Owner_L1_Name__c,
                                   Owner_L2_Name__c,
                                   Owner_L3_Name__c,
                                   (select id, External_Product_ID__c,Priceline_Component_Name__c, Quantity_Description__c, Rate_Period__c, Rate_Type__c, Pricing_Status__c, External_Product_Name__c, name, quantity, unitprice, product2id, pricebookentryId, OpportunityID from opportunitylineitems)
                                   from Opportunity
                                   WHERE Include_in_Partner_Revenue_Query__c = true];

        for(Opportunity opp : opps){
            oppMap.put(opp.External_Partner_ID__c, opp);
        }
        
        system.debug('OPP Map is ' + oppMap);
        system.debug('OPP Map SIZE IS ' + oppMap.size());

        system.debug('PARSE FIELDS ARE '+ csvLines);
        system.debug('&&&&& size is '+ csvLines.size());
        Map<Integer,String> prodLineIDMap = new Map<Integer,String>();
        
        Integer k = -1;

        for(List<String> prodline: csvLines){
            k=k+1;
            prodLineIDMap.put(k,prodline[0]);
            system.debug('Prod Line is '+prodline);
            system.debug('Account ID is '+prodline[0]);

            boolean emptyAcctLists = acctMap.isEmpty() && newAcctIds.isEmpty();
            
            system.debug('DO WE HAVE EMPTY LISTS ' + emptyAcctLists);

            if(emptyAcctLists || (!acctMap.isEmpty() && !acctMap.containsKey(prodline[0]) && (newAcctIds.isEmpty() || !newAcctIds.contains(prodline[0])))){
                system.debug('DO WE GET HERE - NEW ACCOUNT NAME' + prodline[1].replace('"',''));
                string ownerID = prodLine[12].contains('Booked') ? Label.ReadAndPopulateBatch_ClosedOwner : Label.ReadAndPopulateBatch_OpenOwner;
                newAccs.add(new account(name=prodline[1].replace('"',''),External_Partner_ID__c=prodline[0], Area_of_Interest__c=prodline[2], ownerID = ownerid));
                newAcctIds.add(prodline[0]);
                system.debug('NEW ACCOUNT IDS ARE ' + newAcctIds);
            }
        }

        //Initiate an error line to send in an email in case this batch fails
        Integer tempSize = prodLineIDMap.size()-1;
        errorLineIds = 'BATCH FAILED - Initial Failed ID: ' + prodLineIDMap.get(0) + ' -  Final Failed ID: ' + prodLineIDMap.get(tempSize) + '\n';

        if(!newAccs.isEmpty()){
            system.debug('NEW ACCOUNTS SIZE ' + newAccs.size());
            try{
                insert newAccs;
            }
            catch(exception ex){
                errorLineIds += 'DML ERROR IS: ' + ex.getmessage();
                return;
            }
        }

        for(account a : [select id, name, External_Partner_ID__c from account where ID IN: newAccs]){
            acctMap.put(a.External_Partner_ID__c, a);
        }
        
        system.debug('Account Map is ' + acctMap);
        
        for(List<String> prodline: csvLines){

            system.debug('Opp ID is '+prodline[3]);

            //boolean emptyOppLists = oppMap.isEmpty() && newOppIds.isEmpty();
            
            //system.debug('DO WE HAVE EMPTY LISTS ' + emptyOppLists);
            
            Opportunity oppt = new Opportunity();    

            oppt.accountID=acctMap.get(prodline[0]).id;
            oppt.name=prodline[4];
            oppt.External_Partner_ID__c=prodline[3];
            oppt.RecordTypeID=Label.Rally_Engage_Connect_Record_Type_ID;
            oppt.Market_Segment__c=prodline[5];
            oppt.Owner_L1_Name__c=prodline[6];
            oppt.Owner_L2_Name__c=prodline[7];
            oppt.Owner_L3_Name__c=prodline[8];
            oppt.External_Consultant_Name__c=prodline[9];
            oppt.External_Sales_Channel__c=prodline[10];
            oppt.Probability=decimal.valueOf(prodline[11].remove('%'));
            oppt.Stagename=prodline[12];
            oppt.CloseDate=date.parse(prodline[13]);
            oppt.Go_Live__c=date.parse(prodline[14]);
            oppt.Close_Reason__c=prodline[17];
            oppt.Closed_Other_Reason__c=prodline[18];
            oppt.External_Sales_Category__c=prodline[19];
            oppt.Purchase_type__c='PMPM';

            string ownerID = prodLine[12].contains('Booked') ? Label.ReadAndPopulateBatch_ClosedOwner : Label.ReadAndPopulateBatch_OpenOwner;
            
            oppt.ownerid = ownerid;

            if(!oppMap.isEmpty() && oppMap.containsKey(prodline[3])){
                oppt.id = oppMap.get(prodline[3]).id;
                if(existingOppIds.isEmpty() || !existingOppIds.contains(prodline[3])){
                    existingOppIds.add(prodline[3]);    
                    newOpps.add(oppt);
                }
            }
            else if(newOppIds.isEmpty() || !newOppIds.contains(prodline[3])){
                system.debug('NEW OPPORTUNITY FOR ' + prodline[3]);
                newOppIds.add(prodline[3]);
                newOpps.add(oppt);
            }
        }

        if(!newOpps.isEmpty()){
            system.debug('ALL OPPORTUNITIES BEFORE UPSERT ' + newOpps);
            try{
                upsert newOpps;
            }
            catch(exception ex){
                errorLineIds += 'DML ERROR IS: ' + ex.getmessage();
                return;
            }
        }

        for(Opportunity o : [select id,
                                   name,
                                   stagename,
                                   Probability,
                                   CloseDate,
                                   Go_Live__c,
                                   Close_Reason__c,
                                   Closed_Other_Reason__c,
                                   External_Consultant_Name__c,
                                   External_Partner_ID__c,
                                   External_Sales_Category__c,
                                   External_Sales_Channel__c,
                                   Fee_Type__c,
                                   Purchase_type__c,
                                   Market_Segment__c,
                                   Owner_L1_Name__c,
                                   Owner_L2_Name__c,
                                   Owner_L3_Name__c,
                                   (select id, External_Product_ID__c, Priceline_Component_Name__c,Quantity_Description__c, Rate_Period__c, Rate_Type__c, Pricing_Status__c, External_Product_Name__c, name, quantity, unitprice, product2id, pricebookentryId, OpportunityID from opportunitylineitems)
                                   from Opportunity where ID IN: newOpps]){
                                        oppMap.put(o.External_Partner_ID__c, o);
        }

        system.debug('OPPMAP SIZE AFTER INSERT ' + oppMap.size());

        for(List<String> prodline: csvLines){

            system.debug('Prod Line ID is '+prodline[30]);

            if(!newOpps.isEmpty() && newOppIds.contains(prodline[3])){
                if(prodline[29] == Label.ReadAndPopulateBatch_ApprovedLineItemString){
                    OpportunityLineItem oli2 = new OpportunityLineItem();
                    if(decimal.valueOf(prodline[24]) == 0){
                        oli2.quantity = 1;
                        oli2.Zero_Quantity_Line__c = true;
                    }
                    else{
                        oli2.quantity = decimal.valueOf(prodline[24]);
                    }
                    oli2.unitprice = decimal.valueOf(prodline[26]);
                    oli2.pricebookentryID = (priceMap.containsKey(prodline[22]) ? priceMap.get(prodline[22]).id : Label.ReadAndPopulateBatch_DefaultPBID);
                    oli2.Quantity_Description__c = prodline[25];
                    if(prodLine[25] != null && prodline[25] != '' && prodLine[25].contains('Units')){
                        oli2.One_Time_Purchase__c = true;
                        oli2.Effective_Date__c = date.parse(prodline[14]);
                    }
                    oli2.Rate_Type__c = prodline[27];
                    oli2.Rate_Period__c = prodline[28];
                    oli2.Pricing_Status__c = prodline[29];
                    oli2.External_Product_ID__c = prodline[30];
                    oli2.External_Product_Name__c = prodline[23];
                    oli2.Priceline_Component_Name__c = prodline[33];
                    oli2.OpportunityID = oppMap.get(prodline[3]).id;
                    upsertOlis.add(oli2);    
                }
            }
            else if(oppMap.containsKey(prodline[3])){
                Map<id,id> oliIDs = new Map<id,id>();

                for(OpportunityLineItem oli : oppMap.get(prodline[3]).opportunitylineitems){
                    oliIDs.put(oli.External_Product_ID__c, oli.id);
                }

                OpportunityLineItem oli2 = new OpportunityLineItem();
                
                if(!oliIDs.isEmpty() && oliIDs.containsKey(prodline[30])){
                    oli2.id = oliIDs.get(prodline[30]);
                }
                else{
                    oli2.External_Product_ID__c = prodline[30];
                    oli2.OpportunityID = oppMap.get(prodline[3]).id;
                }
                
                if(decimal.valueOf(prodline[24]) == 0){
                    oli2.quantity = 1;
                    oli2.Zero_Quantity_Line__c = true;
                }
                else{
                    oli2.quantity = decimal.valueOf(prodline[24]);
                }
                oli2.unitprice = decimal.valueOf(prodline[26]);
                if(oli2.id == null)
                    oli2.pricebookentryID = (priceMap.containsKey(prodline[22]) ? priceMap.get(prodline[22]).id : Label.ReadAndPopulateBatch_DefaultPBID);
                oli2.Quantity_Description__c = prodline[25];
                oli2.Rate_Type__c = prodline[27];
                oli2.Rate_Period__c = prodline[28];
                oli2.Pricing_Status__c = prodline[29];
                oli2.External_Product_Name__c = prodline[23];
                
                upsertOlis.add(oli2);    
            }
        }

        if(!upsertOlis.isEmpty()){
            try{
                upsert upsertOlis;
            }
            catch(exception ex){
                errorLineIds += 'DML ERROR IS: ' + ex.getmessage();
                return;
            }
        }
    }
    global void finish(Database.BatchableContext batchableContext){
        if(errorLineIds.contains('DML ERROR')){
            
            system.debug('DO WE HAVE AN ERROR IN THE BATCH? ' + errorLineIds);

            Messaging.SingleEmailMessage SuccessMail = new Messaging.SingleEmailMessage();
            List <Messaging.SingleEmailMessage> Mails = new List <Messaging.SingleEmailMessage>();

            List <String> sendTo1 = new List <String>();
            sendTo1.add('alex.roth@rallyhealth.com');
            SuccessMail.setToAddresses(sendTo1);

            SuccessMail.setReplyTo('alex.roth@rallyhealth.com');
            SuccessMail.setSenderDisplayName('Batch Revenue Uploader');
      
            SuccessMail.setSubject('Batch Revenue Uploade Failure');

            String body1 = '<html><body>Dear Admin,' + '<br>' + '<br>' + errorLineIds;
            /*result.message = ('The following number of records '+ updatetsks.size() + ' got created successfuly by the Email Service and ' + '<br>' + a1 + ' number of records got failed by the Email Service.');*/

            SuccessMail.setHtmlBody(body1);

            Mails.add(SuccessMail);
            Messaging.sendEmail(Mails);
        }
        else{
            system.debug('Inserted records ' + batchableContext); 
        }
    }
}