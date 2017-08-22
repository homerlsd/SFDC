@istest(seealldata=false)
public class Test_SurveyQuestionResponseService {
	
	@istest(seealldata=false)
	static void testCreate(){

		Survey__c s = new Survey__c();
	    s.Name = 'Testing Survey';
	    s.Submit_Response__c = 'empty'; 
	    insert s;

	    Survey_Question__c q = new Survey_Question__c();
	    q.Name = 'Testing Question';
	    q.Survey__c = s.id;
	    q.Type__c = 'Free Text';
	    q.Choices_New__c = '';
	    q.Question_New__c = 'Text q';
	    q.OrderNumber__c = 0;
	    q.Required__c = true;
	    insert q;

	    Survey_Question__c q1 = new Survey_Question__c();
	    q1.Name = 'Testing Question';
	    q1.Survey__c = s.id;
	    q1.Type__c = 'Single Select--Horizontal';
	    q1.Choices_New__c = 'one\ntwo\nthree\n';
	    q1.NPS__c = true;
	    q1.Question_New__c = 'NPS';
	    q1.OrderNumber__c = 1;
	    q1.Required__c = true;
	    insert q1;
		
		//uid = ApexPages.currentPage().getParameters().get('id');
		RestRequest req = new RestRequest(); 
	    RestResponse res = new RestResponse();

	    // pass the req and resp objects to the method     
	    req.requestURI = Label.Test_SurveyQuestionResponseService_DomainAddy;  
	    req.httpMethod = 'POST';
	    req.requestBody = blob.valueOf('{ "rallyID" : "someID", "sessionID" : "someSessID", "clientID" : "someCID", "payerID" : "somepID", "surveyID" : "'+s.id+'", "sourceID" : "Mobile", "transactionID" : "someID1234", "Questions" : [{"question_type" : "NPS", "response" : "10"}, { "question_type" : "text", "response" : "Some comment"}]}');

	    RestContext.request = req;
	    RestContext.response = res;

	    string resulty = SurveyQuestionResponseService.createQs();

		System.assertEquals('Success',resulty);

		SurveyTaker__c st = [select id, Transaction_ID__c from SurveyTaker__c where Survey__c = :s.id];
		system.assertEquals('someID1234', st.Transaction_ID__c);

		RestRequest req1 = new RestRequest(); 
	    RestResponse res1 = new RestResponse();

	    // pass the req and resp objects to the method     
	    req1.requestURI = Label.Test_SurveyQuestionResponseService_DomainAddy;  
	    req1.httpMethod = 'POST';
	    req1.requestBody = blob.valueOf('{ "rallyID" : "someID", "sessionID" : "someSessID", "clientID" : "someCID", "payerID" : "somepID", "surveyID" : "'+s.id+'", "sourceID" : "Mobile", "transactionID" : "someID1234", "Questions" : [{"question_type" : "NPS", "response" : "9"}, { "question_type" : "text", "response" : "Some comment updated"}]}');

	    RestContext.request = req1;
	    RestContext.response = res1;

		string resulty2 = SurveyQuestionResponseService.createQs();

		System.assertEquals('Success',resulty2);

		SurveyQuestionResponse__c resp = [select id,response__c from SurveyQuestionResponse__c where SurveyTaker__r.Survey__c = :s.id AND Survey_Question__r.NPS__c = true];
		system.assertEquals('9', resp.response__c);
		
	}

	@istest(seealldata=false)
	static void testCreateDate(){

		Survey__c s = new Survey__c();
	    s.Name = 'Testing Survey';
	    s.Submit_Response__c = 'empty'; 
	    insert s;

	    Survey_Question__c q = new Survey_Question__c();
	    q.Name = 'Testing Question';
	    q.Survey__c = s.id;
	    q.Type__c = 'Free Text';
	    q.Choices_New__c = '';
	    q.Question_New__c = 'Text q';
	    q.OrderNumber__c = 0;
	    q.Required__c = true;
	    insert q;

	    Survey_Question__c q1 = new Survey_Question__c();
	    q1.Name = 'Testing Question';
	    q1.Survey__c = s.id;
	    q1.Type__c = 'Single Select--Horizontal';
	    q1.Choices_New__c = 'one\ntwo\nthree\n';
	    q1.NPS__c = true;
	    q1.Question_New__c = 'NPS';
	    q1.OrderNumber__c = 1;
	    q1.Required__c = true;
	    insert q1;
		
		//uid = ApexPages.currentPage().getParameters().get('id');
		RestRequest req = new RestRequest(); 
	    RestResponse res = new RestResponse();

	    // pass the req and resp objects to the method     
	    req.requestURI = Label.Test_SurveyQuestionResponseService_DomainAddy;  
	    req.httpMethod = 'POST';
	    req.requestBody = blob.valueOf('{ "rallyID" : "someID", "sessionID" : "someSessID", "surveyDate" : "2017-03-30T18:55:49.662Z", "clientID" : "someCID", "payerID" : "somepID", "surveyID" : "'+s.id+'", "sourceID" : "Mobile", "transactionID" : "someID1234", "Questions" : [{"question_type" : "NPS", "response" : "10"}, { "question_type" : "text", "response" : "Some comment"}]}');

	    RestContext.request = req;
	    RestContext.response = res;

	    string resulty = SurveyQuestionResponseService.createQs();

		System.assertEquals('Success',resulty);

		SurveyTaker__c st = [select id, Transaction_ID__c, Survey_Date__c from SurveyTaker__c where Survey__c = :s.id];
		system.assertEquals('someID1234', st.Transaction_ID__c);
	}
}