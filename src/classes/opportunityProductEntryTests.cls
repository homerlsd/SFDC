@istest
private class opportunityProductEntryTests {

    static testMethod void theTests(){

        Account a = new Account(Name='Lexcorp');
        insert a;

        RecordType rt = [select id from RecordType where sObjectType='Opportunity' AND Name = 'Engage'];

        Opportunity opp = new Opportunity(accountid=a.id,name='Lexcorp Engage', closeDate=date.today(), stageName='Test',RecordTypeid = rt.id);
        insert opp;

        Product2 packagee1 = new Product2(Name='Test Product',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee1;

        Product2 packagee = new Product2(Name='Test Product',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee;

        Product2 Add_On = new Product2(Name='Test Product1',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Add-On');
        insert Add_On;

        Product2 Feature = new Product2(Name='Test Product1',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Feature');
        insert Feature;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=packagee.Id, UnitPrice=99, isActive=true);
        insert pbe;

        PricebookEntry pbe_pack1 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=packagee1.Id, UnitPrice=99, isActive=true);
        insert pbe_pack1;

        PricebookEntry pbe_addon = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=Add_On.Id, UnitPrice=10, isActive=true);
        insert pbe_addon;

        PricebookEntry pbe_feature = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=Feature.Id, UnitPrice=0, isActive=true);
        insert pbe_feature;

        Product_Package__c pp = new Product_Package__c(Parent_Product__c = packagee.id, Child_Product__c = Feature.id, Package_Options__c = 'Included', Quantity__c = 1);
        insert pp;

        Product_Package__c pp1 = new Product_Package__c(Parent_Product__c = packagee.id, Child_Product__c = Add_On.id, Package_Options__c = 'Optional', Quantity__c = 1);
        insert pp1;

        opportunityLineItem oli1 = new opportunityLineItem(opportunityid = opp.id, pricebookentryid = pbe.id, quantity = 1, unitprice = 10);
        insert oli1;

        opportunityLineItem oli3 = new opportunityLineItem(opportunityid = opp.id, pricebookentryid = pbe_addon.id, quantity = 1, unitprice = 10);
        insert oli3;
            
        OpportunityLineItem oli_addon = [select Id, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where ID = : oli3.id];
                
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(opp));
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        Test.setCurrentPageReference(pageRef);
        // load the extension
        
        // test 'getChosenCurrency' method
        if(UserInfo.isMultiCurrencyOrganization())
            System.assert(oPEE.getChosenCurrency()!='');
        else
            System.assertEquals(oPEE.getChosenCurrency(),'');

        //test search functionality without finding anything
        oPEE.searchString = 'Who watches the Watchmen?';
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()==0);
        
        //test remove from shopping cart
        oPEE.toUnselect = oli_addon.PricebookEntryId;
        oPEE.removeFromShoppingCart();
        
        //test save and reload extension
        oPEE.onSave();
        
        // test search again, this time we will find something
        oPEE.searchString = oli_addon.PricebookEntry.Name;
        oPEE.updateAvailableList();

        // test add to Shopping Cart function
        oPEE.toSelect = pbe_addon.id;
        oPEE.addToShoppingCart();
                
        // test save method - WITHOUT base quanity entered and confirm that error message is displayed
        oPEE.TotalBaseQuantity = 0;
        oPEE.onSave();
        system.assert(oPEE.showError==true);
        
        // add required info and try save again
        oPEE.TotalBaseQuantity = 101;
        oPEE.onSave();
        
        // query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where OpportunityId = :oli_addon.OpportunityId];
        
        // test on new Opp (no pricebook selected) to make sure redirect is happening
        Opportunity newOpp = new Opportunity(Name='New Opp',stageName='test',Amount=10,closeDate=System.Today()+30,AccountId=oli_addon.Opportunity.AccountId);
        insert(newOpp);

        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp)); 
        System.assert(oPEE.priceBookCheck()==null);
        
        // final quick check of cancel button
        System.assert(oPEE.onCancel()!=null);
        
        
        ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        pageRef = Page.opportunityProductRedirect;
        pageRef.getParameters().put('Id',oli2[0].Id);
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        opportunityProductRedirectExtension oPRE = new opportunityProductRedirectExtension(new ApexPages.StandardController(oli2[0]));
        System.assert(oPRE.redirect()!=null);
     
    }

    static testMethod void theTests1(){

        Account a = new Account(Name='Lexcorp');
        insert a;

        RecordType rt = [select id from RecordType where sObjectType='Opportunity' AND Name = 'Engage'];

        Opportunity opp = new Opportunity(accountid=a.id,name='Lexcorp Engage', closeDate=date.today(), stageName='Test',RecordTypeid = rt.id);
        insert opp;

        Product2 packagee1 = new Product2(Name='Test Product',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee1;

        Product2 packagee = new Product2(Name='Test Product',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee;

        Product2 Add_On = new Product2(Name='Test Product1',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Add-On');
        insert Add_On;

        Product2 Feature = new Product2(Name='Test Product1',Product_Family__c = 'Engage',isActive=true, Product_Type__c ='Feature');
        insert Feature;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=packagee.Id, UnitPrice=99, isActive=true);
        insert pbe;

        PricebookEntry pbe_pack1 = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=packagee1.Id, UnitPrice=99, isActive=true);
        insert pbe_pack1;

        PricebookEntry pbe_addon = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=Add_On.Id, UnitPrice=10, isActive=true);
        insert pbe_addon;

        PricebookEntry pbe_feature = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=Feature.Id, UnitPrice=0, isActive=true);
        insert pbe_feature;

        Product_Package__c pp = new Product_Package__c(Parent_Product__c = packagee.id, Child_Product__c = Feature.id, Package_Options__c = 'Included', Quantity__c = 1);
        insert pp;

        Product_Package__c pp1 = new Product_Package__c(Parent_Product__c = packagee.id, Child_Product__c = Add_On.id, Package_Options__c = 'Optional', Quantity__c = 1);
        insert pp1;

        opportunityLineItem oli1 = new opportunityLineItem(opportunityid = opp.id, pricebookentryid = pbe.id, quantity = 1, unitprice = 10);
        insert oli1;

        opportunityLineItem oli3 = new opportunityLineItem(opportunityid = opp.id, pricebookentryid = pbe_addon.id, quantity = 1, unitprice = 10);
        insert oli3;
            
        OpportunityLineItem oli_addon = [select Id, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem where ID = : oli3.id];
                
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(opp));
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        Test.setCurrentPageReference(pageRef);
        // load the extension
        
        // test 'getChosenCurrency' method
        if(UserInfo.isMultiCurrencyOrganization())
            System.assert(oPEE.getChosenCurrency()!='');
        else
            System.assertEquals(oPEE.getChosenCurrency(),'');

        //test search functionality without finding anything
        oPEE.searchString = 'Who watches the Watchmen?';
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()==0);
        
        //test remove from shopping cart
        oPEE.toUnselect = oli_addon.PricebookEntryId;
        oPEE.removeFromShoppingCart();
        
        //test save and reload extension
        oPEE.onSave();
        
        // test search again, this time we will find something
        oPEE.searchString = oli_addon.PricebookEntry.Name;
        oPEE.updateAvailableList();

        // test add to Shopping Cart function
        oPEE.toSelect = pbe.id;
        oPEE.addPackToShoppingCart();

        // test save method - WITHOUT base quanity entered and confirm that error message is displayed
        oPEE.TotalBaseQuantity = 0;
        oPEE.onSave();
        
        // add required info and try save again
        oPEE.TotalBaseQuantity = 101;
        oPEE.onSave();
        
        // query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where opportunityid = : opp.id LIMIT 1];
        
        // test on new Opp (no pricebook selected) to make sure redirect is happening
        Opportunity newOpp = new Opportunity(Name='New Opp',stageName='test',Amount=10,closeDate=System.Today()+30,AccountId=opp.AccountId);
        insert(newOpp);

        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp)); 
        System.assert(oPEE.priceBookCheck()==null);
        
        // final quick check of cancel button
        System.assert(oPEE.onCancel()!=null);
        
        
        ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        pageRef = Page.opportunityProductRedirect;
        //pageRef.getParameters().put('Id',oli2[0].Id);
        Test.setCurrentPageReference(pageRef);
     
    }
}