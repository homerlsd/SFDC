@istest(seealldata=false)
public class Test_ResourcePageRequirement {
  //CREATE PAGE TESTS
  @isTest(SeeAllData=false) static void testresourcepage() {  
    Account a = new Account(name='test');
    insert a;

    Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, partner__c=Label.ManageAffiliations_BCBSPartnerID);
    insert imp;  
        
    Client_Affiliation__c ca=new Client_Affiliation__c(Name = 'Clientafftest', Implementation__c = imp.Id, Account__c = a.Id);
    insert ca;
     
    PageReference pageRef = page.ResourcePageEntry;
    pageRef.getParameters().put('impID', imp.id);
    Test.setCurrentPage(pageRef);

    ResourcePageEntryController  rcontr = new  ResourcePageEntryController();
    rcontr.currentpromos[0].pagePromo.Current_Promo_Headline__c='test headline';
    rcontr.currentpromos[0].pagePromo.Promotion_End_DateString__c='1/2/2017';
    MultiselectController c = new MultiselectController();
    c.leftOptions = new List<SelectOption>();
    c.rightOptions = rcontr.allAffiliations;

    rcontr.Currentpromos[0].selectedAffils=c.rightOptions;
    rcontr.featuredpromos[0].pagePromo.Featured_Promo_Headline__c='featured test headline';
    rcontr.featuredpromos[0].pagePromo.Promotion_End_DateString__c='2/2/2017';
    rcontr.featuredpromos[0].selectedAffils=c.rightOptions;
                 
    System.assert(rcontr.allAffiliations  != null);
    rcontr.addFeaturedPromo();
    System.assert(rcontr.categories  != null);
    system.debug('rcontr.resource' +rcontr.resource);    
    rcontr.submitResults();
  }
}