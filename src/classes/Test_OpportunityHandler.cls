@istest
public class Test_OpportunityHandler {
	
	@istest(seealldata=false)
	static void Test_OpportunityHandler() {
		//Set up test data
		Account act = new Account(name='The Daily Planet');
		insert act;

		contact con = new contact(lastname='Kent', email='Clark@dp.com');
		insert con;

		AccountContactRole acr = new AccountContactRole(contactid = con.id, accountid = act.id, role='Test', isprimary=true);
		insert acr;

		Opportunity oppty = new Opportunity(StageName='Test',accountid = act.id, CloseDate=date.today(), name='testoppty');
		insert oppty;

		OpportunityContactRole ocr = [select id, role from OpportunityContactRole where OpportunityID = : oppty.id];
		system.assert(ocr != null);
		system.assert(ocr.role == acr.role);
	}
}