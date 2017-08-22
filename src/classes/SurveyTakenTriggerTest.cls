@isTest
public class SurveyTakenTriggerTest {
    public static testMethod void unittest() {
    
      //creating sample data
      Case c = new Case();
        c.Status = 'New_test';
        c.Last_Status_Change__c = System.Now();
        c.Origin = 'Phone';
        c.recordtypeid = label.CC_Default_CASE_RECORDTYPE_ID;
        insert c;
        
        SurveyTaker__c st=new SurveyTaker__c();
        st.case__c=c.Id;
        insert st;
        
        Test.startTest();
        
        SurveyTaker__c st1=new SurveyTaker__c();
        st1.case__c=c.Id;
        insert st1;
        
        Test.stopTest();
        
        }
}