@istest
private class Test_OpptyProductRelatedListController {
    //OpptyRelatedList
    static testmethod void testController(){        
        account C = new account();
        c.name = 'test';
        insert c;

        Opportunity o = new Opportunity(name='test',accountid = c.id, stagename='test',closeDate = date.today());
        insert o;

        Product2 packagee = new Product2(Name='Test Product',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee;

        Id pricebookId = Test.getStandardPricebookId();

        system.debug('ID IS ' + pricebookId);

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=packagee.Id, UnitPrice=99, isActive=true);
        insert pbe;

        opportunityLineItem oli1 = new opportunityLineItem(opportunityid = o.id, Implementation_Fee__c = 7, pricebookentryid = pbe.id, quantity = 1, unitprice = 10);
        insert oli1;
        
        RelatedListController tes = new  RelatedListController();
        tes.oppyid = o.id;

        tes.getOppy();

        System.assertEquals(true, tes.isDirector);
        System.assertEquals(false, tes.noProds);

        tes.deleteRecordId = oli1.id;
        tes.deleteRecord();
      
    }

    static testmethod void testNoDirector(){    

        User u_admin = new User(alias = 'u_admin1', email='testtest_opprelated@test.com',
                emailencodingkey='UTF-8', lastname='Test_admin', languagelocalekey='en_US',
                localesidkey='en_US', profileid = UserInfo.getProfileId(), userroleid = UserInfo.getUserRoleId(),
                timezonesidkey='America/Los_Angeles', username='testtest_opprelated@rally.com');

        insert u_admin; 
        
        system.runAs(u_admin){

        account C = new account();
        c.name = 'test';
        insert c;

        Opportunity o = new Opportunity(name='test',accountid = c.id, stagename='test',closeDate = date.today());
        insert o;

        
        

            RelatedListController tes = new  RelatedListController();
            PageReference pageRef = Page.OppProductsRelatedList;
            Test.setCurrentPage(pageRef);

            tes.oppyid = o.id;
            tes.getOppy();

            System.assertEquals(false, tes.isDirector);
            System.assertEquals(true, tes.noProds);
            
            tes.editOpptyProds();
            tes.pricebook();
        }
      
    }


    
}