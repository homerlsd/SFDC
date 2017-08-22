public class SurveyQuestionResponse {

    //SAMPLE JSON STRING THAT THIS CLASS IS EXPECTING:
    //Fake Data: { "rallyID" : "someID", "sessionID" : "someSessID", "surveyDate" : "2017-03-30T18:55:49.662Z", "clientID" : "someCID", "payerID" : "somepID", "surveyID" : "a064C000000bvPy", "appID" : "Mobile", "platformID" : "iOS", "appVersion" : "v1.2.3", "transactionID" : "someID1234", "Questions" : [{"question_type" : "NPS", "response" : "10"}, { "question_type" : "text", "response" : "Some comment"}]}

    public class Questions {
        public String question_type;
        public String response;
    }

    public String rallyID;
    public String sessionID;
    public String surveyDate;
    public String clientID;
    public String payerID;
    public String surveyID;
    public String appID;
    public String platformID;
    public String appVersion;
    public String transactionID;
    
    public List<Questions> Questions;

    public static SurveyQuestionResponse parse(String json) {
        return (SurveyQuestionResponse) System.JSON.deserialize(json, SurveyQuestionResponse.class);
    }
}