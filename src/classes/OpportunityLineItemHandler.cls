public class OpportunityLineItemHandler {

    public static void isAfterInsert(OpportunityLineItem[] olis) {
        Map<id, List<Product_Package__c>> prodMap = new Map<id, List<Product_Package__c>>();
        Map<id, Map<id,PricebookEntry>> priceMap = new Map<id, Map<id,PricebookEntry>>();
        Map<id,id> pbeToPriceBookMap = new Map<id,id>();
        List<id> productIds = new List<id>();
        List<id> pbeIds = new List<id>();
        List<OpportunityLineItem> newOlis = new List<OpportunityLineItem>();
        List<Product_Schedule__c> newPS1 = new List<Product_Schedule__c>();

        //get Pricebookentry id because we need to get PriceBook info
        for(OpportunityLineItem oli : [select One_Time_Purchase__c,Effective_Date__c,product2id,opportunityid,quantity,unitprice,pricebookentryid,opportunity.Purchase_Type__c,id,totalprice,opportunity.membership_term__c,opportunity.go_live__c,product_sub_type_formula__c,product_type_formula__c from OpportunityLineItem where ID IN : olis]){
            productIds.add(oli.product2id);
            pbeIds.add(oli.pricebookentryid);

            decimal totalprice = oli.TotalPrice;
            
            if(oli.opportunity.go_live__c != null && totalprice != null && totalprice != 0){     
                
                //Remaining months = how many months we have yet to assign to a record
                integer remainingMonths = ((integer.valueOf(oli.opportunity.membership_term__c)*12)-1);
                //numberical representation of start month of deal (Oct == 10)
                integer startMonth = oli.opportunity.go_live__c.month();                
                //months applied to the initial schedule
                integer initMonths = 12 - startMonth;  
                //remove these initial months 
                remainingMonths = remainingMonths - initMonths; 

                system.debug('INITIAL MONTHS IN FIRST YEAR ' + initMonths);
                system.debug('INITIAL REMAINDER BEFORE FIRST YEAR ' + remainingMonths);

                
                decimal initAmount = (initMonths+1)*totalprice;

                date currentEndDate;

                integer year = 1;

                if(oli.opportunity.Purchase_Type__c == 'PMPM' && oli.Product_Type_Formula__c != 'Implementation Fee' && oli.product_sub_type_formula__c != 'One Time Fee' && !oli.One_Time_Purchase__c){    

                    Product_Schedule__c ps = new Product_Schedule__c();
                    ps.Start_Date__c = oli.opportunity.go_live__c;
                    ps.End_Date__c = oli.opportunity.go_live__c.addMonths(initMonths);  
                    Integer numberOfDays = Date.daysInMonth(ps.End_Date__c.year(), ps.End_Date__c.month());
                    ps.End_Date__c = Date.newInstance(ps.End_Date__c.year(), ps.End_Date__c.month(), numberOfDays);
                    ps.Amount__c = initAmount;
                    ps.Opportunity_Product_ID__c = oli.id;
                    ps.Opportunity__c = oli.OpportunityId;
                    ps.Quantity__c = oli.Quantity;
                    ps.Unit_Price__c = oli.UnitPrice;
                    ps.Product__c = oli.product2ID;
                    ps.Contract_Year__c = year;
                    currentEndDate = ps.End_Date__c;
                    newPS1.add(ps);

                    integer remainder = math.mod(remainingMonths,12);

                    remainingMonths = remainingMonths - remainder;

                    integer loops = remainingMonths/12;

                    system.debug('REMAINING MONTHS AFTER FIRST YEAR ' + remainingMonths);
                    system.debug('Remainder ' + remainder);
                    system.debug('LOOPS ' + loops);


                    for(Integer i=1; i <= loops; i++){
                        year++;
                        Product_Schedule__c ps1 = new Product_Schedule__c();
                        ps1.Start_Date__c = Date.newInstance(currentEndDate.year()+1, 1, 1);
                        ps1.End_Date__c = currentEndDate.addMonths(12);
                        ps1.Amount__c = totalprice*12;
                        ps1.Opportunity_Product_ID__c = oli.id;
                        ps1.Opportunity__c = oli.OpportunityId;
                        ps1.Quantity__c = oli.Quantity;
                        ps1.Unit_Price__c = oli.UnitPrice;
                        ps1.Product__c = oli.product2ID;
                        ps1.Contract_Year__c = year;
                        currentEndDate = ps1.End_Date__c;
                        newPS1.add(ps1);
                    }
                                    
                    if(remainder > 0){
                        system.debug('Remainder IS ' + remainder);
                        year++;
                        Product_Schedule__c ps2 = new Product_Schedule__c();
                        ps2.Start_Date__c = Date.newInstance(currentEndDate.year()+1, 1, 1);
                        ps2.End_Date__c = currentEndDate.addMonths(remainder);
                        Integer numberOfDays1 = Date.daysInMonth(ps2.End_Date__c.year(), ps2.End_Date__c.month());
                        ps2.End_Date__c = Date.newInstance(ps2.End_Date__c.year(), ps2.End_Date__c.month(), numberOfDays1);
                        ps2.Amount__c = totalprice*(remainder);
                        ps2.Opportunity_Product_ID__c = oli.id;
                        ps2.Opportunity__c = oli.OpportunityId;
                        ps2.Quantity__c = oli.Quantity;
                        ps2.Unit_Price__c = oli.UnitPrice;
                        ps2.Product__c = oli.product2ID;
                        ps2.Contract_Year__c = year;
                        newPS1.add(ps2);
                    }
                }
                else{
                    system.debug('DO WE GET IN THE IMPLEMENTATION/ONE TIME FEE/LICENSING FEE BLOCK - ' + oli.effective_date__c);

                    Product_Schedule__c ps3 = new Product_Schedule__c();
                    ps3.Start_Date__c = oli.Effective_Date__c;
                    ps3.End_Date__c = oli.Effective_Date__c;  
                    ps3.Amount__c = totalprice;
                    ps3.Opportunity_Product_ID__c = oli.id;
                    ps3.Opportunity__c = oli.OpportunityId;
                    ps3.Quantity__c = oli.Quantity;
                    ps3.Unit_Price__c = oli.UnitPrice;
                    ps3.Product__c = oli.product2ID;
                    //ps3.Contract_Year__c = year;
                    newPS1.add(ps3);
                }
            }
        }

        if(!newPS1.isEmpty())
            insert newPS1;
        
        system.debug('PS IS ' + newPS1);


        //loop through product packages and see if we have any work to do, if not we just womp out of this thing
        /*for(Product_Package__c pp : [select id, Parent_Product__c, Child_Product__c, quantity__c, Applicable_Account_Types__c,Optional_Pricing__c, Optional_Price__c from Product_Package__c
                                    WHERE Parent_Product__c IN : productIds AND Package_Options__c = 'Included']){
                if(prodMap.isEmpty())
                    prodMap.put(pp.Parent_Product__c, new List<Product_Package__c>{pp});
                else
                    prodMap.get(pp.Parent_Product__c).add(pp);
        }
        
        if(prodmap != null && !prodMap.isEmpty()){

            //get price book id which is not available through a formula field for some reason
            for(PricebookEntry pbe : [select id,isactive,Pricebook2Id,unitprice from PricebookEntry where ID IN : pbeIds]){
                pbeToPriceBookMap.put(pbe.id, pbe.Pricebook2Id);
            }
            
            //find the rest of the pricebook entries in the parent item's pricebook and bind them to the pricebook id in that fun map below
            for(PricebookEntry pb2 : [select id,isactive,product2id,unitprice,Pricebook2Id,product2.description,product2.sales_notes__c,product2.Product_Type__c,product2.Product_Sub_Type__c from PricebookEntry where Pricebook2Id IN : pbeToPriceBookMap.values() AND isActive = true]){
                if(priceMap.isEmpty() || !priceMap.containsKey(pb2.Pricebook2Id))
                    priceMap.put(pb2.Pricebook2Id, new Map<id, Pricebookentry>{pb2.Product2id => pb2});
                else
                    priceMap.get(pb2.Pricebook2Id).put(pb2.Product2id, pb2);
            }

            for(OpportunityLineItem oli : [select id,
                                                  Product2id,
                                                  Opportunity_Account_Type__c,
                                                  opportunityid,
                                                  pricebookentryid,
                                                  opportunity.Total_Covered_Members__c,
                                                  opportunity.Total_Covered_Employees__c
                                                  from OpportunityLineItem WHERE ID IN : olis]){
                if(prodMap.containsKey(oli.Product2id)){
                    for(Product_Package__c pp2 : prodMap.get(oli.Product2id)){
                        if(pp2.Applicable_Account_Types__c == null || pp2.Applicable_Account_Types__c == '' || (pp2.Applicable_Account_Types__c != null && pp2.Applicable_Account_Types__c != '' && pp2.Applicable_Account_Types__c.contains(oli.Opportunity_Account_Type__c))){
                            OpportunityLineItem oliNew = new OpportunityLineItem();
                            oliNew.opportunityid = oli.opportunityid;
                            oliNew.quantity = pp2.quantity__c;
                            if(!pbeToPriceBookMap.isEmpty() && 
                                !priceMap.isEmpty() &&
                                    priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).containsKey(pp2.Child_Product__c)
                                        && priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).get(pp2.Child_Product__c).product2.Product_Type__c == 'Feature'){
                                oliNew.pricebookentryid = priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).get(pp2.Child_Product__c).id;
                                system.debug('DO WE GET THE PRICE INFO ' + priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).get(pp2.Child_Product__c).unitprice);
                                system.debug('DO WE GET THE PRICE INFO ' + pp2.quantity__c);
                                
                                oliNew.totalprice = priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).get(pp2.Child_Product__c).unitprice * pp2.quantity__c;
                                
                                /*if(pp2.Optional_Pricing__c != 'N/A'){
                                    if(pp2.Optional_Pricing__c == 'Flat')
                                        oliNew.totalprice = pp2.Optional_Price__c;
                                    else if(pp2.Optional_Pricing__c == 'PMPM' && oli.opportunity.Total_Covered_Members__c != null)
                                        oliNew.totalprice = pp2.Optional_Price__c * oli.opportunity.Total_Covered_Members__c;
                                    else if(pp2.Optional_Pricing__c == 'PEPM' && oli.opportunity.Total_Covered_Employees__c != null)
                                        oliNew.totalprice =  pp2.Optional_Price__c * oli.opportunity.Total_Covered_Employees__c;
                                }

                                system.debug('DO WE GET THE TOTAL PRICE ' + oliNew.totalprice);
                                oliNew.Parent_Opportunity_Product_ID__c = oli.id;
                                oliNew.Opportunity_Product_Type__c = priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).get(pp2.Child_Product__c).product2.Product_Type__c;
                                oliNew.Opportunity_Product_Sub_Type__c = priceMap.get(pbeToPriceBookMap.get(oli.pricebookentryid)).get(pp2.Child_Product__c).product2.Product_Sub_Type__c;
                                newOlis.add(olinew);
                            }
                            else{
                                //oli.addError('Missing Pricing Info - Contact System Administration');
                            }
                        }
                    }
                }
            }

            if(!newOlis.isEmpty())
                insert newOlis;
        }*/
    }

    public static void isAfterUpdate(OpportunityLineItem[] olis) {
        List<Product_Schedule__c> newPS = new List<Product_Schedule__c>();
        List<id> delids = new List<id>();

        //get Pricebookentry id because we need to get PriceBook info
        for(OpportunityLineItem oli : [select product2id,
                                              pricebookentryid,
                                              opportunityid,
                                              quantity,
                                              unitprice,
                                              id,
                                              totalprice,
                                              effective_Date__c,
                                              One_Time_Purchase__c,
                                              opportunity.Purchase_Type__c,
                                              opportunity.membership_term__c,
                                              opportunity.go_live__c,
                                              product_sub_type_formula__c,
                                              product_type_formula__c
                                              from OpportunityLineItem
                                              where ID IN : olis]){

            system.debug('OLI TOTAL IS ' + oli.TotalPrice);
            system.debug('OLI TYPE IS ' + oli.product_type_formula__c);

            delIds.add(oli.id);

            decimal totalprice = oli.TotalPrice;
            
            if(oli.opportunity.go_live__c != null && totalprice != null && totalprice != 0){     

                //Remaining months = how many months we have yet to assign to a record
                integer remainingMonths = (integer.valueOf(oli.opportunity.membership_term__c)*12) - 1;
                //numberical representation of start month of deal (Oct == 10)
                integer startMonth = oli.opportunity.go_live__c.month();                
                //months applied to the initial schedule
                integer initMonths = 12 - startMonth;  
                //remove these initial months 
                remainingMonths = remainingMonths - initMonths;             
                
                decimal initAmount = (initMonths+1)*totalprice;

                date currentEndDate;

                integer year = 1;

                system.debug('INITIAL AMOUNT IS ' + initAmount);

                if(oli.opportunity.Purchase_Type__c == 'PMPM' && oli.Product_Type_Formula__c != 'Implementation Fee' && oli.product_sub_type_formula__c != 'One Time Fee' && !oli.One_Time_Purchase__c){    

                    Product_Schedule__c ps = new Product_Schedule__c();
                    ps.Start_Date__c = oli.opportunity.go_live__c;
                    ps.End_Date__c = oli.opportunity.go_live__c.addMonths(initMonths);  
                    Integer numberOfDays = Date.daysInMonth(ps.End_Date__c.year(), ps.End_Date__c.month());
                    ps.End_Date__c = Date.newInstance(ps.End_Date__c.year(), ps.End_Date__c.month(), numberOfDays);
                    ps.Amount__c = initAmount;
                    ps.Opportunity_Product_ID__c = oli.id;
                    ps.Opportunity__c = oli.OpportunityId;
                    ps.Quantity__c = oli.Quantity;
                    ps.Unit_Price__c = oli.UnitPrice;
                    ps.Product__c = oli.product2ID;
                    ps.Contract_Year__c = year;
                    currentEndDate = ps.End_Date__c;
                    newPS.add(ps);

                    integer remainder = math.mod(remainingMonths,12);

                    remainingMonths = remainingMonths - remainder;
                    integer loops = remainingMonths/12;

                    for(Integer i=1; i <= loops; i++){
                        year++;
                        Product_Schedule__c ps1 = new Product_Schedule__c();
                        ps1.Start_Date__c = Date.newInstance(currentEndDate.year()+1, 1, 1);
                        ps1.End_Date__c = currentEndDate.addMonths(12);
                        ps1.Amount__c = totalprice*12;
                        ps1.Opportunity_Product_ID__c = oli.id;
                        ps1.Opportunity__c = oli.OpportunityId;
                        ps1.Quantity__c = oli.Quantity;
                        ps1.Unit_Price__c = oli.UnitPrice;
                        ps1.Product__c = oli.product2ID;
                        ps1.Contract_Year__c = year;
                        currentEndDate = ps1.End_Date__c;
                        newPS.add(ps1);
                    }
                                    
                    system.debug('REMAINDER IS ' + remainder);


                    if(remainder > 0){
                        year++;
                        Product_Schedule__c ps2 = new Product_Schedule__c();
                        ps2.Start_Date__c = Date.newInstance(currentEndDate.year()+1, 1, 1);
                        ps2.End_Date__c = currentEndDate.addMonths(remainder);
                        Integer numberOfDays1 = Date.daysInMonth(ps2.End_Date__c.year(), ps2.End_Date__c.month());
                        ps2.End_Date__c = Date.newInstance(ps2.End_Date__c.year(), ps2.End_Date__c.month(), numberOfDays1);
                        ps2.Amount__c = totalprice*(remainder);
                        ps2.Opportunity_Product_ID__c = oli.id;
                        ps2.Opportunity__c = oli.OpportunityId;
                        ps2.Quantity__c = oli.Quantity;
                        ps2.Unit_Price__c = oli.UnitPrice;
                        ps2.Product__c = oli.product2ID;
                        ps2.Contract_Year__c = year;
                        newPS.add(ps2);
                    }
                }
                else{
                    
                    system.debug('DO WE GET IN THE IMPLEMENTATION/ONE TIME FEE BLOCK - ' + oli.effective_date__c);

                    Product_Schedule__c ps = new Product_Schedule__c();
                    ps.Start_Date__c = oli.Effective_Date__c;
                    ps.End_Date__c = oli.Effective_Date__c;  
                    ps.Amount__c = totalprice;
                    ps.Opportunity_Product_ID__c = oli.id;
                    ps.Opportunity__c = oli.OpportunityId;
                    ps.Quantity__c = oli.Quantity;
                    ps.Unit_Price__c = oli.UnitPrice;
                    ps.Product__c = oli.product2ID;
                    //ps.Contract_Year__c = year;
                    newPS.add(ps);
                }
            }
        }

        Product_Schedule__c[] psDel = [select id from Product_Schedule__c where Opportunity_Product_ID__c IN : delIds];

        if(!psDel.isEmpty())
            delete psDel;

        if(!newPS.isEmpty())
            insert newPS;
    }

    public static void beforeInsert(OpportunityLineItem[] oldOlis){
            
        system.debug('DO WE GET Before Insert ' + oldOlis);

        Set<id> oppyIds = new Set<id>();

        for(OpportunityLineItem oli : oldOlis){
            if(oli.Parent_Package_Item__c)
                oppyIds.add(oli.opportunityid);
        }

        Map<ID,Date> oppMap = new Map<ID,Date>();

        for(opportunity opp : [select id, Go_Live__c from Opportunity WHERE id IN : oppyIds]){
            oppMap.put(opp.id, opp.Go_Live__c);
        }

        for(OpportunityLineItem oli : oldOlis){
            if(oppMap.containsKey(oli.opportunityid) && oppMap.get(oli.opportunityid) != null)
               oli.Effective_Date__c = oppmap.get(oli.opportunityid);
        }
    }

    public static void beforeDelete(OpportunityLineItem[] olis){
            
        system.debug('DO WE GET BEFORE DELETE ' + olis);

        List<string> packs = new List<string>();
        List<string> oliIds = new List<string>();

        id uID = userInfo.getUserID();
        
        Set<String> perms = utils.findUserPermissions(uID);


        for(OpportunityLineItem oli : olis){
            if(oli.CreatedByID != uID && oli.Opportunity_Owner_ID__c != uID && (perms.isEmpty() || !perms.contains('Delete Opportunity Line Items'))){
                oli.addError(Label.OpportunityLineItemHandler_DelError);
            }
            else{
                if(oli.Product_Type_Formula__c == 'Package'){
                    packs.add(oli.id);
                }   
                oliIds.add(oli.id);
            }
        }

        if(!oliIds.isEmpty()){
            system.debug('DO WE HAVE PACKAGES FOR DELELTE ' + packs);

            List<Product_Schedule__c> psd = [select id from Product_Schedule__c where Opportunity_Product_ID__c IN : oliIds];

            if(!psd.isEmpty())
                delete psd;

            if(!packs.isEmpty()){
                List<OpportunityLineItem> delOlis = [select id from OpportunityLineItem where Parent_Opportunity_Product_ID__c IN : packs AND ID NOT IN : olis];

                system.debug('DO WE HAVE DELETE SUB OLIS ' + delOlis);

                if(!delOlis.isEmpty())
                    delete delOlis;
            }
        }
    }

    public static void afterDelete(OpportunityLineItem[] oldOlis){
            
        system.debug('DO WE GET AFTER DELELTE ' + oldOlis);

        Set<id> oppyIds = new Set<id>();

        for(OpportunityLineItem oli : oldOlis){
            oppyIds.add(oli.opportunityid);
        }

        List<Opportunity> updateOpps = new List<opportunity>();

        for(opportunity opp : [select id, Purchase_Type__c,First_Year_Revenue__c, Second_Year_Run_Rate__c, (select id from OpportunityLineItems) from Opportunity where id IN : oppyIds]){
            if(opp.OpportunityLineItems.isEmpty()){
                system.debug('DO WE RESET OPPTY INFO? ' + opp);
                opp.Purchase_Type__c = null;
                opp.First_Year_Revenue__c = null;
                opp.Second_Year_Run_Rate__c = null;
                updateOpps.add(opp);
            }
        }
        
        if(!updateOpps.isEmpty())
            update updateOpps;
    }

    /*system.debug('DO WE GET BEFORE INSERT ' + olis);

    Map<id, Product_Package__c> ppMap = new Map<id,Product_Package__c>();
    Map<OpportunityLineItem, id> upsellParent = new Map<OpportunityLineItem,id>();
    map<id, OpportunityLineItem> upsells = new map<id, OpportunityLineItem>();
    set<id> oppyIDs = new set<id>();
    String defaultVals = '';

    for(OpportunityLineItem oli : olis){
        if(oli.Product_Type_Formula__c == 'Feature' && oli.product_sub_type_formula__c == 'Upsell Feature'){
            upsells.put(oli.id, oli);
            upsellParent.put(oli, oli.Parent_Opportunity_Product_ID__c);
            oppyIDs.add(oli.OpportunityId);
        }   
    }

    if(!upsells.isEmpty()){

        Map<id,Opportunity> oppyMap = new Map<id,opportunity>([select id, Total_Covered_Members__c,Total_Covered_Employees__c from Opportunity where ID IN : oppyIDs]);

        system.debug('DO WE HAVE UPSELL PRICING - ' + oppyMap);

        for(Product_Package__c pp1 : [select id,
                                             Child_Product__c,
                                             Parent_Product__c,
                                             Optional_Pricing__c,
                                             Optional_Price__c
                                             from Product_Package__c WHERE
                                             (Parent_Product__c IN : upsellParent.values() AND Child_Product__c IN : upsells.keyset())]){
            if(pp1.Optional_Pricing__c != null && (pp1.Optional_Pricing__c != '' && pp1.Optional_Pricing__c != 'N/A'))
                ppMap.put(pp1.child_product__c, pp1);
        }
        
        system.debug('DO WE HAVE PACKAGE PRODS ' + ppMap);
    
        for(OpportunityLineItem oli: upsells.values()){
            if(ppMap != null && ppMap.containsKey(oli.id) && oli.Parent_Opportunity_Product_ID__c == ppMap.get(oli.id).Parent_Product__c){
                if(ppMap.get(oli.id).Optional_Pricing__c != null && ppMap.get(oli.id).Optional_Pricing__c != 'N/A'){
                    if(ppMap.get(oli.id).Optional_Pricing__c == 'Flat')
                        oli.totalprice = ppMap.get(oli.id).Optional_Price__c;
                    else if(ppMap.get(oli.id).Optional_Pricing__c == 'PMPM' && oppyMap.get(oli.OpportunityId).Total_Covered_Employees__c != null)
                        oli.totalprice = ppMap.get(oli.id).Optional_Price__c * oppyMap.get(oli.OpportunityId).Total_Covered_Employees__c;
                    else if(ppMap.get(oli.id).Optional_Pricing__c == 'PEPM' && oppyMap.get(oli.OpportunityId).Total_Covered_Employees__c != null)
                        oli.totalprice =  ppMap.get(oli.id).Optional_Price__c * oppyMap.get(oli.OpportunityId).Total_Covered_Employees__c;
                }
            }
        }
    }*/

    /*public static void updateOLITotal(OpportunityLineItem[] olis, Map<id, OpportunityLineItem> oliMap) {
        Map<id,decimal> updateIds = new Map<Id, Decimal>();
        Map<id,id> pbeMap = new Map<Id, id>();
        List<OpportunityLineItem> upsertOlis = new List<OpportunityLineItem>();
        set<id> upsertOliIds = new set<id>();

        //Change to logic to look to Pricebook2 to find the appropriate PBE ID
        for(Pricebookentry pbe : [select id, Pricebook2Id from Pricebookentry where Product2.Product_Type__c = 'Implementation Fee']){
            pbeMap.put(pbe.Pricebook2Id ,pbe.id);
        }

        system.debug('pbeMap IS ' + pbeMap);
        if(!pbeMap.isEmpty() || test.isRunningTest()){
            for(OpportunityLineItem oli : [select id,Price_Book_ID__c, Implementation_Fee__c,Effective_Date__c, name, opportunityid from OpportunityLineItem where ID IN :olis]){
                if((trigger.isInsert && oli.Implementation_Fee__c != null && oli.Implementation_Fee__c > 0) || (trigger.isUpdate && oli.Implementation_Fee__c != null && oli.Implementation_Fee__c > 0 && (oliMap.get(oli.id).Implementation_Fee__c == null || oliMap.get(oli.id).Implementation_Fee__c == 0))){
                    OpportunityLineItem oli1 = new OpportunityLineItem();
                    oli1.opportunityid = oli.opportunityid;
                    
                    //implement logic from Map here to find the correct implementation fee for this Pricebook, otherwise use backup
                    if(pbeMap.containsKey(oli.Price_Book_ID__c))
                        oli1.pricebookentryid = pbeMap.get(oli.Price_Book_ID__c);
                    else
                        oli1.pricebookentryid = label.DEFAULT_IMPLEMENTATION_FEE_PRODUCT_ID;
                    
                    oli1.quantity = 1;
                    oli1.unitprice = oli.Implementation_Fee__c;
                    oli1.Effective_Date__c = oli.Effective_Date__c;
                    oli1.description = 'Implementation Fee related to Opportunity Product ' + oli.name;
                    oli1.Parent_Opportunity_Product_ID__c = oli.id;
                    oli1.Opportunity_Product_Type__c = 'Implementation Fee';
                    upsertOlis.add(oli1);
                }
                else if(trigger.isUpdate && oli.Implementation_Fee__c != oliMap.get(oli.id).Implementation_Fee__c && oliMap.get(oli.id).Implementation_Fee__c != null && oliMap.get(oli.id).Implementation_Fee__c > 0){
                    updateIds.put(oli.id, oli.Implementation_Fee__c);
                    system.debug('WHAT IS THE NEW Implementation_Fee__c' + updateIds);
                }
            }

            if(!updateIds.isEmpty()){
                OpportunityLineItem[] olix = [select id, unitprice, Parent_Opportunity_Product_ID__c from OpportunityLineItem where Parent_Opportunity_Product_ID__c IN : updateIds.keyset() AND pricebookentry.product2.Product_Type__c = 'Implementation Fee'];
                
                system.debug('WHAT IS THE CHILD LINE' + olix);

                for(OpportunityLineItem ol : olix){
                    ol.unitprice = updateIds.get(ol.Parent_Opportunity_Product_ID__c);
                    upsertOlis.add(ol);
                    upsertOliIds.add(ol.id);
                }
            }

            if(!upsertOlis.isEmpty())   
                upsert upsertOlis;

            system.debug('UPSERTED FEES ARE ' + upsertOlis);
        }
    }*/
}