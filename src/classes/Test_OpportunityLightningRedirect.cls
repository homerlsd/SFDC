@istest(seealldata=false)
public class Test_OpportunityLightningRedirect {
    //CREATE PAGE TESTS
    @isTest(SeeAllData=false) static void testView() {        
        //Set up test data
		Account act = new Account(name='The Daily Planet');
		insert act;

		contact con = new contact(lastname='Kent', email='Clark@dp.com');
		insert con;

		AccountContactRole acr = new AccountContactRole(contactid = con.id, accountid = act.id, role='Test', isprimary=true);
		insert acr;

		Opportunity oppty = new Opportunity(StageName='Test',accountid = act.id, CloseDate=date.today(), name='testoppty');
		insert oppty;

        ApexPages.StandardController sc = new ApexPages.StandardController(oppty);
        OpportunityLightningRedirect tes = new  OpportunityLightningRedirect (sc);
        PageReference pageRef = Page.CaseOverride;
        Test.setCurrentPage(pageRef);
        tes.redirect();

    }
}