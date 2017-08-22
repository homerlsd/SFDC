@istest
public class Test_EmergencyController{
	
	@istest(seealldata=true)
	static void Test_EmergencyController() {

		EMERGENCYController tes = new  EMERGENCYController();
        PageReference pageRef = Page.EMERGENCY;
        Test.setCurrentPage(pageRef);
        tes.siteDown();
        tes.siteup();

	}
}