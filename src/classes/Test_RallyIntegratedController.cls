@isTest
public class Test_RallyIntegratedController {
		
		@isTest(SeeAllData=false) 
		static void testCreateChallenge() {    
        
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;

        Product2 prod = new Product2(Name='Test Product',isActive=true, Partner__c=p.id);
        insert prod;

        Product2 prod2 = new Product2(Name='Optum Biometric',isActive=true, Partner__c=p.id);
        insert prod2;

        Partner_Integrated_Product__c intProd = new Partner_Integrated_Product__c(Implementation__c = imp.id, Product__c = prod.id, Product_Name__c = prod.name);
        insert intProd;
        
        PageReference pageRef = page.RallyIntegratedPage;
        pageRef.getParameters().put('id', imp.id);
        Test.setCurrentPage(pageRef);

        RallyIntegratedcontroller cont = new RallyIntegratedcontroller();

        cont.getThirdpartyoptions();
        cont.save();
        cont.cancel();
    }
}