@IsTest
public class Test_SalesChannelTriggerHandler {
    
    @IsTest(seealldata=false)
    public static void testChanUpsert() {

 		Sales_Channel__c sc = new Sales_Channel__c(Approved_Record_Type_Name__c = 'Engage Approved', Unapproved_Record_Type_Name__c = 'Engage', Case_Record_Type_Name__c = 'Engage');
 		insert sc;

 		Sales_Channel__c scQuery = [select Approved_Record_Type_ID__c from Sales_Channel__c where ID = : sc.id];
 		system.assert(scQuery.Approved_Record_Type_ID__c != null && scQuery.Approved_Record_Type_ID__c != '');      
    }
}