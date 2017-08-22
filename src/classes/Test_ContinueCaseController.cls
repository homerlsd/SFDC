@istest(SeeAllData=false)
public class Test_ContinueCaseController {
	
	@istest(SeeAllData=false)
	static void validateContinueCase(){
        
        case testcase = new case(subject='Magneto Was Right');
        insert testcase;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testcase);
        ContinueCaseController testController = new ContinueCaseController(sc);
        
        PageReference pageRef = Page.ContinueCase;
        pageRef.getParameters().put('id', String.valueOf(testcase.Id));
        Test.setCurrentPage(pageRef);
        
      }
}