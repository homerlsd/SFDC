public with sharing class opportunityProductEntryExtension {

    public Opportunity oppy {get;set;}
    public String searchString {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public opportunityLineItem[] currentpackage {get;set;}
    public opportunityLineItem[] currentAddons {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public priceBookEntry[] packages {get;set;}
    public priceBookEntry[] addOns {get;set;}
    public Pricebook2 theBook {get;set;}   

    public viewPack[] viewPacks {get;set;}
    public string[] upsells {get;set;}
    public feature[] features {get;set;}
    public Boolean showViewPack {get;set;}
    public Boolean displayPopup {get;set;}
    public Map<Id, List<viewPack>> ppMap {get;set;}
    
    public String purchaseType {get; set;}
    public String initialPurchaseType {get; set;}
    public String errorMessage {get; set;}
    public String acctType {get; set;}
    public Boolean showError {get; set;}
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public String toView {get; set;}
    public Decimal Total {get;set;}
    public Decimal TotalBaseQuantity {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean hasPackage {get;set;}
    public string packId {get;set;}
    public Boolean multipleCurrencies {get; set;}
    public string selectedTab {get;set;}
    
    public Set<id> featureids {get;set;}

    private Boolean forcePricebookSelection = false;
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};


    public opportunityProductEntryExtension(ApexPages.StandardController controller) {
        currentAddons = new List<opportunityLineItem>();
        currentpackage = new List<opportunityLineItem>();
        upsells = new List<string>();
        features = new List<feature>();
        viewPacks = new List<viewPack>();
        featureids = new set<id>();

        ppMap = new Map<ID, List<viewPack>>();
        hasPackage = false;
        showError = false;
        showViewPack = false;
        displayPopup = false;
        selectedTab = 'name2';

        purchaseType = '';
        initialpurchaseType = '';
        
        errorMessage = '';
        packid = '';

        // Need to know if org has multiple currencies enabled
        multipleCurrencies = UserInfo.isMultiCurrencyOrganization();

        // Get information about the Opportunity being worked on
        if(multipleCurrencies)
            oppy = database.query('select Id,account.type,sales_channel__r.name,Go_live__c,Record_Type_Name__c,membership_term__c,purchase_type__c,account.recordtype.name,Pricebook2Id, PriceBook2.Name, Total_Covered_Members__c, Total_Covered_Employees__c, Fee_Type__c, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        else
            oppy = [select Id,account.type,Go_live__c,Record_Type_Name__c,sales_channel__r.name,membership_term__c,purchase_type__c,account.recordtype.name,Pricebook2Id, PriceBook2.Name, Total_Covered_Members__c, Total_Covered_Employees__c, Fee_Type__c from Opportunity where Id = :controller.getRecord().Id limit 1];
        
        if(oppy.Purchase_Type__c != null){
            initialpurchaseType = oppy.Purchase_Type__c;
            purchaseType = oppy.Purchase_Type__c;
        }

        //checkout the member/employee pricing and do work to get base package quantity for new package creation
        if(oppy.Fee_Type__c == 'PMPM' && oppy.Total_Covered_Members__c != null){
            TotalBaseQuantity = oppy.Total_Covered_Members__c;
        }
        else if(oppy.Fee_Type__c == 'PEPM' && oppy.Total_Covered_Employees__c != null){
            TotalBaseQuantity = oppy.Total_Covered_Employees__c;
        }
        else
            TotalBaseQuantity = 1;

        if(oppy.account.type != null)
            acctType = oppy.account.type;
        else
            acctType = oppy.account.recordtype.name;

        // Check if Opp has a pricebook associated yet
        if(oppy.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = oppy.Pricebook2;
        }
        
        if(!forcePricebookSelection)
            updateAvailableList();
    }
    
    // this is the 'action' method on the page
    public PageReference priceBookCheck(){
    
        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
        
            //if there is only one active pricebook we go with it and save the opp
            if(oppy.pricebook2Id != theBook.Id){
                try{
                    oppy.Pricebook2Id = theBook.Id;
                    update(oppy);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }
       
    public String getChosenCurrency(){
    
        if(multipleCurrencies)
            return (String)oppy.get('CurrencyIsoCode');
        else
            return '';
    }

    public void updateAvailableList() {
        if(!featureids.isEmpty())
            featureids.clear();
        if(!features.isEmpty())
            features.clear();
        if(!currentpackage.isEmpty())
            currentpackage.clear();
        if(!currentAddons.isEmpty())
            currentAddons.clear();
        
        packid = '';
        hasPackage = false;
        
         // If products were previously selected need to put them in the "selected products" section to start with
        shoppingCart = [select Id,
                               Quantity,
                               TotalPrice,
                               UnitPrice,
                               Description,
                               PriceBookEntryId,
                               Opportunity_Product_Type__c,
                               Tailored_Options__c,
                               Implementation_Fee__c,
                               Effective_Date__c,
                               Product_Type_Formula__c,
                               Reward_Options__c,
                               Opportunity_Product_Sub_Type__c,
                               PriceBookEntry.Name,
                               PriceBookEntry.IsActive,
                               PriceBookEntry.Product2Id,
                               PriceBookEntry.Product2.Name,
                               PriceBookEntry.Product2.description,
                               PriceBookEntry.Product2.Product_Type__c,
                               PriceBookEntry.Product2.Product_Sub_Type__c, 
                               PriceBookEntry.Product2.Product_Family__c,
                               PriceBookEntry.Product2.Sales_Notes__c,
                               PriceBookEntry.PriceBook2Id,
                               OpportunityId,
                               Parent_Package_Item__c,
                               Opportunity.Purchase_Type__c
                               from opportunityLineItem
                               where OpportunityId=:oppy.Id
                               ORDER BY Opportunity_Product_Order__c ASC, Effective_Date__c ASC, TotalPrice DESC];

        integer packageCount = 0;

        for(opportunityLineItem oli1 : shoppingCart){
            system.debug('CURRENT OLI PRODUCT TYPE IS ' + oli1.PriceBookEntry.Product2.Product_Type__c);
            if(oli1.PriceBookEntry.Product2.Product_Type__c == 'Package'|| oli1.PriceBookEntry.Product2.Product_Type__c == 'Add-On'){
                
                if(oli1.PriceBookEntry.Product2.Product_Type__c == 'Package'){
                    packageCount++;
                    if(purchaseType != 'Licensing Fee' && initialpurchaseType != 'Licensing Fee')
                        TotalBaseQuantity = oli1.quantity;
                    else
                        TotalBaseQuantity = 1;
                    hasPackage = true;
                    selectedTab = 'name1';
                    if(oli1.Parent_Package_Item__c)
                        packId = oli1.id;
                    currentPackage.add(oli1);
                }
                if(oli1.PriceBookEntry.Product2.Product_Type__c == 'Add-On')
                    currentAddons.add(oli1);
               
                
            }
            else if(oli1.PriceBookEntry.Product2.Product_Type__c == 'Feature'){
                if(oli1.PriceBookEntry.Product2.Product_Sub_Type__c != 'Upsell Feature'){
                    system.debug('DO WE HAVE ANY CURRENT FEATURES ' + oli1.id);
                    Features.add( new feature(oli1.PriceBookEntry.Product2.Name, oli1.PriceBookEntry.Product2.Product_Type__c,true,oli1.id, oli1.PriceBookEntry.Product2.description,oli1.PriceBookEntry.Product2.id));
                    featureids.add(oli1.PriceBookEntry.Product2.id);
                }
                else{
                    currentAddons.add(oli1);
                }
            }
        }

        /*if(packageCount > 1 && initialpurchaseType == ''){
            initialpurchaseType = 'Licensing Fee';
            purchaseType = 'Licensing Fee';
        }
        else if(shoppingCart != null && !shoppingCart.isEmpty() && initialpurchaseType == ''){
            initialpurchaseType = 'PMPM';
            purchaseType = 'PMPM';
        }*/

        system.debug('DO WE HAVE A PURCHASE TYPE ' + initialpurchaseType);
        system.debug('DO WE HAVE A PACKAGE LINE ' + currentpackage);
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive,Product2.Product_Sub_Type__c, Product2.Name,Product2.Sales_Notes__c, Product2.Family,Product2.Product_Family__c,Product2.Product_Type__c,Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where';
        
        if(oppy.Record_Type_Name__c != 'Consultation'){
            String val= '%' + String.escapeSingleQuotes(oppy.sales_channel__r.name.trim()) + '%';
            qString += ' Product2.Family_Formula__c LIKE \'' + val + '\' AND Product2.External_Only_Product__c = false AND IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        }
        else
            qString += ' IsActive=true and Product2.External_Only_Product__c = false AND Pricebook2Id = \'' + theBook.Id + '\'';
        
        if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + oppy.get('currencyIsoCode') + '\'';
        
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
        }
        
        Set<Id> selectedEntries = new Set<Id>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }
        
        qString+= ' order by Product2.Name';
        qString+= ' limit 101';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        // We only display up to 100 results... if there are more than we let the user know (see vf page)
        if(AvailableProducts.size()==101){
            AvailableProducts.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
            segmentOpptyProducts();
        }
    }

    public void segmentOpptyProducts(){
        packages = new list<priceBookEntry>();
        addOns = new list<priceBookEntry>();
        Map<ID, Product_Package__c> currentPPs = new Map<ID, Product_Package__c>();

        //First we gots to see if we actually have access to the upsell products based on what is in the cart
        //if nothing is in the cart then we don't care about this step

        string pQuery = 'select id,(select id,Quantity__c,Parent_Product__c,Child_Product__c,Child_Product__r.Product_Type__c,Child_Product__r.Name,Child_Product__r.description,';
        pQuery += 'Package_Options__c,Applicable_Account_Types__c, Child_Product__r.Product_Sub_Type__c from Product_Packages__r) from Product2 where'; 
        if(oppy.Record_Type_Name__c != 'Consultation'){
            String val= '%' + String.escapeSingleQuotes(oppy.sales_channel__r.name.trim()) + '%';
            pQuery += ' Family_Formula__c LIKE \'' + val + '\' AND Product_Type__c = \'Package\' AND isActive = true';
        }
        else
            pQuery += ' Product_Type__c = \'Package\' AND isActive = true';

        system.debug('pQuery is ' + pQuery);

        List<Product2> currentPacks = database.query(pQuery);

        for(Product2 currentPack : currentPacks){
            system.debug('DO WE GET INSIDE THE PACKAGE PRODUCT LOOP ' + currentpack);
            if(!currentpack.Product_Packages__r.isEmpty()){
                for(Product_Package__c pp : currentpack.Product_Packages__r){
                    if(pp.Package_Options__c != 'Not Available'){
                        if(hasPackage && currentpackage[0].PriceBookEntry.Product2Id == currentpack.id){
                            currentPPs.put(pp.Child_Product__c, pp);
                            if(!featureids.contains(pp.Child_Product__c) && pp.Child_Product__r.Product_Type__c == 'Feature' && pp.Child_Product__r.Product_Sub_Type__c == 'Standard Feature'){
                                Features.add( new feature(pp.Child_Product__r.Name, pp.Child_Product__r.Product_Type__c,false,'','',pp.Child_Product__r.id));
                            }
                        }

                        if(pp.Child_Product__r.Product_Type__c == 'Feature' && pp.Child_Product__r.Product_Sub_Type__c == 'Standard Feature'){
                            if(ppMap.isEmpty() || (!ppMap.isEmpty() && !ppMap.containsKey(pp.Parent_Product__c))){
                                ppMap.put(pp.Parent_Product__c, new List<viewPack>{new viewPack(pp.Child_Product__r.name, pp.Child_Product__r.Product_Type__c, pp.Child_Product__r.description)});
                            }
                            else
                                ppMap.get(pp.Parent_Product__c).add(new viewPack(pp.Child_Product__r.name, pp.Child_Product__r.Product_Type__c, pp.Child_Product__r.description));
                        }
                    }
                }
            }

            if(!ppMap.containsKey(currentPack.id)){
                system.debug('DO WE GET HERE FOR 01tL0000004dRLUIA2 ' + currentpack.id);
                ppmap.put(currentpack.id, new List<viewPack>{new viewPack('No Package Items Included', 'No Package Items Included', 'No Package Items Included')});
            }
        }

        system.debug('CURRENT PPS ARE ' + currentPPs);
        system.debug('CURRENT MAP IS ' + ppmap);

        // This function runs to separate out the products into separate lists
        for(PricebookEntry prod : AvailableProducts){
            if(prod.Product2.Product_Type__c == 'Package')
                packages.add(prod);
            else if(prod.Product2.Product_Type__c == 'Add-On' || prod.Product2.Product_Sub_Type__c == 'Upsell Feature'){
                
                system.debug('PRODUCT ID IS ' + prod.Product2id);

                if(currentPPs.isEmpty() || 
                    (!currentPPs.isEmpty() && currentPPs.containsKey(prod.Product2id) && 
                        (currentPPs.get(prod.Product2id).Applicable_Account_Types__c == null
                            || currentPPs.get(prod.Product2id).Applicable_Account_Types__c == '' 
                                || (currentPPs.get(prod.Product2id).Applicable_Account_Types__c != null
                                    && currentPPs.get(prod.Product2id).Applicable_Account_Types__c != ''
                                        && currentPPs.get(prod.Product2id).Applicable_Account_Types__c.contains(acctType)))))
                    addOns.add(prod);
            }
        }
        system.debug('PACKS ARE ' + packages);
        system.debug('ADD ONS ARE ' + addOns);
    }
    
    public void addPackToShoppingCart(){
    
        // This function runs when a user hits "select" button next to a product
        if(hasPackage == true){
            opportunityLineItem[] delOlis = [select id from opportunityLineItem where Parent_Opportunity_Product_ID__c = : currentpackage[0].id];
            delete delOlis;
            delete currentpackage;
        }
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                opportunityLineItem oli = new opportunityLineItem(OpportunityId=oppy.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, quantity = TotalBaseQuantity, Opportunity_Product_Type__c='Package', Parent_Package_Item__c = true);
                insert oli;
                break;
            }
        }
        
        displayPopup = true;
        updateAvailableList();  
    }

    public void addToShoppingCart(){
    
        // This function runs when a user hits "select" button next to a product
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                string typ = d.product2.Product_Type__c;
                string subtyp = d.product2.Product_Sub_Type__c;

                List<Product_Package__c> ppqs = [select id,
                                                        Optional_Pricing__c,
                                                        Optional_Price__c,
                                                        Parent_Product__c,
                                                        Child_Product__c
                                                        from Product_Package__c
                                                        where Optional_Pricing__c != null AND Optional_Pricing__c != ''
                                                        AND Optional_Price__c != null
                                                        AND (Parent_Product__c = : currentpackage[0].priceBookEntry.Product2Id AND Child_Product__c = : d.product2ID)];

                system.debug('Optional Pricing Products are ' + ppqs);

                opportunityLineItem oli = new opportunityLineItem(OpportunityId=oppy.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, quantity = 1, Parent_Opportunity_Product_ID__c = currentpackage[0].id, Opportunity_Product_Type__c = typ, Opportunity_Product_Sub_Type__c = subtyp);

                if(!ppqs.isEmpty()){
                    if(ppqs[0].Optional_Pricing__c != null && ppqs[0].Optional_Pricing__c != 'N/A'){
                        oli.UnitPrice = 0;
                        if(ppqs[0].Optional_Pricing__c == 'Flat')
                            oli.totalprice = ppqs[0].Optional_Price__c;
                        else if(ppqs[0].Optional_Pricing__c == 'PMPM' && oppy.Total_Covered_Members__c != null)
                            oli.totalprice = ppqs[0].Optional_Price__c * oppy.Total_Covered_Members__c;
                        else if(ppqs[0].Optional_Pricing__c == 'PEPM' && oppy.Total_Covered_Employees__c != null)
                            oli.totalprice =  ppqs[0].Optional_Price__c * oppy.Total_Covered_Employees__c;
                    }
                }
                
                insert oli;
                break;
            }
        }
        
        updateAvailableList();  
    }

    public void removeFromShoppingCart(){
    
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
    
        for(opportunityLineItem d : shoppingCart){

            if((String)d.PriceBookEntryId==toUnselect){
            
                if(d.PriceBookEntry.Product2.Product_Type__c == 'Package'){
                    errorMessage = 'Please select another Package from the list below to remove this Package from the Opportunity.';
                    showError = true;
                    break;
                }
                else if(d.Id!=null){
                    forDeletion.add(d);
                    delete forDeletion;
                    break;
                }  
            }
        }
        
        updateAvailableList();
    }
    
    public PageReference onSave(){
        List<opportunityLineItem> upsertOlis = new List<opportunityLineItem>();
        List<opportunityLineItem> deleteOlis = new List<opportunityLineItem>();
        List<id> delOliIds = new List<id>();
        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
        try{
            if(shoppingCart.size()>0){

                if((oppy.Purchase_Type__c == null || oppy.purchase_type__c == '') || purchaseType != oppy.Purchase_Type__c ){
                    oppy.purchase_type__c = purchaseType;
                    update oppy;
                }

                for(opportunityLineItem oliz: shoppingCart){
                    if(oliz.pricebookentry.product2.Product_Type__c == 'Package'){
                        if(TotalBaseQuantity != null && TotalBaseQuantity > 0){
                            if(purchaseType != 'Licensing Fee')
                                oliz.quantity = TotalBaseQuantity;
                            else
                                oliz.quantity = 1;
                            upsertOlis.add(oliz);
                        }
                        else{
                            errorMessage = 'The quantity for the Package can not be null or zero.  Please check the quantity and try again to save.';
                            showError = true;
                            return null;
                        }
                    }
                    if(oliz.pricebookentry.product2.Product_Type__c == 'Add-On')
                        upsertOlis.add(oliz);
                }

                for(feature fe : features){
                    if(fe.selected && !fe.origSelected){
                        opportunityLineItem newOli = new opportunityLineItem();
                        newOli.PriceBookEntryId = findPBEID(fe.prodID);
                        newOli.Parent_Opportunity_Product_ID__c = packId;
                        newOli.OpportunityId = oppy.id;
                        newOli.quantity = 1;
                        newOli.UnitPrice = 0;
                        upsertOlis.add(newOli);
                    }
                    else if(!fe.selected && fe.origSelected){
                        delOliIds.add(fe.oliID);
                    }
                }

                if(!delOliIds.isEmpty())
                    deleteOlis.addAll([select id from opportunityLineItem where ID IN : delOliIds]);

                if(!deleteOlis.isEmpty())
                    delete deleteOlis;

                if(!upsertOlis.isEmpty())
                    upsert upsertOlis;
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }  
           
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
 
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference changePricebook(){
    
        // returns a PageReference to the standard Pricebook selection screen
        // retURL parameter to send user sent back after they choose
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',oppy.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + oppy.Id);
        
        return ref;
    }

    public void clearError(){
        errorMessage = '';
        showError = false;
    }

    public void showPopup(){
        displayPopup = true;
    }

    public void closePopup(){
        displayPopup = false;
        system.debug('DISPLAY POP UP IS ' + displayPopup);
    }

    public id findPBEID(string prod2id){
        system.debug('FEATURE PRODUCT ID IS ' + prod2id);
        id tempid = [select id from pricebookentry where product2ID = : Prod2id AND pricebook2Id = : theBook.id].id;
        return tempid;
    }

    public class viewPack{
        public string type          {get; set;}
        public String name          {get; set;}
        public String descrip          {get; set;}

        public viewPack(string paramName, string paramType,string paramDesc){
            this.type = paramType;
            this.name = paramName;
            this.descrip = paramDesc;
        } 
    }

    public List<selectOption> getPurchaseOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Please Select...', 'Please Select...'));
        options.add(new SelectOption('Licensing Fee', 'Licensing Fee'));
        options.add(new SelectOption('PMPM', 'PMPM'));
        return options;
    }

    public void setupPurchaseOptions(){
        system.debug('PURCHASE TYPE IS ' + purchaseType);
        system.debug('INITIAL PURCHASE TYPE IS ' + initialpurchaseType);
        if(purchaseType == 'Licensing Fee' && (initialpurchaseType == '' || initialpurchaseType == 'PMPM')){
            List<opportunityLineItem> newOlis = new List<opportunityLineItem>();

            integer loops = integer.valueOf(oppy.membership_term__c) - 1;
            integer counter = 0;
            for(Integer i=1; i <= loops; i++){
                counter++;
                opportunityLineItem oli = currentpackage[0].clone(false);
                system.debug('OLI IS ' + oli);
                oli.totalprice = null;  
                oli.Parent_Package_Item__c = false;
                if(currentpackage[0].Effective_Date__c != null)
                    oli.Effective_Date__c = currentpackage[0].Effective_Date__c.AddYears(counter);
                oli.Parent_Opportunity_Product_ID__c = currentpackage[0].id;    
                newOlis.add(oli);
            }
            if(!newOlis.isEmpty())
                insert newOlis;
            
            initialpurchaseType = 'Licensing Fee';
            oppy.Purchase_Type__c = initialpurchaseType;
            update oppy;
            updateAvailableList();
            //TotalBaseQuantity = 1;
        }
        else if(purchaseType == 'PMPM' && initialpurchaseType == 'Licensing Fee'){
              
            system.debug('DO WE HAVE THE RIGHT CURRENT PACKAGE ID - 00k29000003Vp6SAAS ' + packId);

            List<opportunityLineItem> delOliPacks = [select id
                                                            from opportunityLineItem
                                                            where Parent_Opportunity_Product_ID__c = : packId
                                                            AND Opportunity_Product_Type__c = 'Package'];
                                                    
            if(!delOliPacks.isEmpty()){
                delete delOliPacks;
                initialpurchaseType = 'PMPM';
                oppy.Purchase_Type__c = initialPurchaseType;
                update oppy;
                updateAvailableList();
            }
        }
    }

    public List<selectOption> getActivityOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = opportunityLineItem.Reward_Options__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('Please Select...', 'Please Select...'));
        for( Schema.PicklistEntry f : ple)
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;
    }

    public class feature{
        public string type                  {get; set;}
        public String name                  {get; set;}
        public Boolean selected             {get; set;}
        public Boolean origSelected         {get; set;}
        public string oliID                 {get; set;}
        public string prodID                {get; set;}
        public String descrip          {get; set;}

        public feature(string paramName, string paramType,Boolean paramSelected, string paramOliID, string paramDesc, string paramProd){
            this.type = paramType;
            this.name = paramName;
            this.selected = paramSelected;
            this.origSelected = paramSelected;
            this.descrip = paramDesc;
            this.prodID = paramProd;
            if(paramOliID != '')
                this.oliID = paramOliID;
        } 
    }
}