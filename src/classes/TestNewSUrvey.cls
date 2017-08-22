@IsTest(seeAllData=true)
public class TestNewSUrvey {

	private static TestMethod void testConstructor(){
	    SurveyTestingUtil tu = new SurveyTestingUtil();
	    System.assert(tu.surveyId != null);
	}

	private static Testmethod void testNewSurvey() {

		contact c = new contact(lastname='wayne',email='bruce@wayne.com');
		insert c;

        case ca = new case(subject='wayne');
        insert ca;

        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.currentPage().getParameters().put('cid',c.id);  
        Apexpages.currentPage().getParameters().put('caId',ca.id);  
        Apexpages.Standardcontroller stc;   
        NewSurvey vsc = new NewSurvey(stc);
        vsc.init();
        System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
        
        vsc.submitResults();

        //CANT LOOP THROUGH THIS CLASS OBJECT FOR SOME REASON, THIS SHOULD BE OK SINCE IT IS NOT A LOT OF WORK
        vsc.allQuestions[0].selectedOption = String.valueof(2);
        vsc.allQuestions[0].choices = String.valueof(2);
        vsc.allQuestions[0].selectedOptions = new List<String>();
        vsc.allQuestions[0].selectedOptions.add(String.valueof(2));
        vsc.submitResults();        
        System.assertEquals(true, vsc.showRequiredError);
        vsc.allQuestions[1].selectedOption = String.valueof(2);
        vsc.allQuestions[1].choices = String.valueof(2);
        vsc.allQuestions[1].selectedOptions = new List<String>();
        vsc.allQuestions[1].selectedOptions.add(String.valueof(2));
        vsc.submitResults();   
        System.assertEquals(true, vsc.showRequiredError);
        vsc.allQuestions[2].selectedOption = String.valueof(2);
        vsc.allQuestions[2].choices = String.valueof(2);
        vsc.allQuestions[2].selectedOptions = new List<String>();
        vsc.allQuestions[2].selectedOptions.add(String.valueof(2));
        vsc.submitResults();  
        System.assertEquals(true, vsc.showRequiredError);
        vsc.allQuestions[3].selectedOption = String.valueof(2);
        vsc.allQuestions[3].choices = String.valueof(2);
        vsc.allQuestions[3].selectedOptions = new List<String>();
        vsc.allQuestions[3].selectedOptions.add(String.valueof(2));
        vsc.submitResults();     
        /*for (vscuallQuestions[0].estion q : vsc.allQuestions)
        {
            q.selectedOption = String.valueof(2);
            q.choices = String.valueof(2);
            q.selectedOptions = new List<String>();
            q.selectedOptions.add(String.valueof(2));
            vsc.submitResults();            
        }*/
        //vsc.AddSurveyTaker();

        System.assertEquals(true, vsc.thankYouRendered);

    }

    /*private static Testmethod void testUpdateSurveyName() {
      SurveyTestingUtil tu = new SurveyTestingUtil();
      Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
      Apexpages.Standardcontroller stc; 
      NewSurvey vsc = new NewSurvey(stc);
      vsc.surveyName = 'new name';
      system.assert(vsc.updateSurveyName() == null);
      
  }

  private static Testmethod void testupdateSurveyThankYouAndLink() {
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
    Apexpages.Standardcontroller stc; 
    NewSurvey vsc = new NewSurvey(stc);
    vsc.surveyThankYouText = 'new stuff';
    vsc.surveyThankYouURL = 'more new stff';
    system.assert(vsc.updateSurveyThankYouAndLink()==null);
  }*/

}