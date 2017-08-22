public class CalculateBusinessHoursAgesTest {
    public static testMethod void testBusinessHoursBucketer() {
        Stop_Status__c[] sss = new List<Stop_Status__c>();
        Stop_Status__c ss = new Stop_Status__c(Name = 'Waiting on Tier 2', Owner_Bucket__c = 'Tier 2');
        Stop_Status__c ss1 = new Stop_Status__c(Name = 'New_test', Owner_Bucket__c = 'Tier 1');
        sss.add(ss);
        sss.add(ss1);
        insert sss;

        Case c = new Case();
        c.Status = 'New_test';
        c.Last_Status_Change__c = System.Now();
        c.Origin = 'Phone';
        c.recordtypeid = label.CC_Default_CASE_RECORDTYPE_ID;
        insert c;

        c.Status = 'Waiting on Tier 2';
        update c;

        c.Status = 'New';
        update c;

        Case updatedCase = [select Time_With_Tier_1__c,Time_With_Tier_2__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];

        system.debug('UPDATED CASE TIME IS ' + updatedCase.Time_With_Tier_1__c);
        system.debug('UPDATED CASE TIME IS ' + updatedCase.Time_With_Tier_2__c);

        System.assert(updatedCase.Time_With_Tier_1__c!=0);
        System.assert(updatedCase.Time_With_Tier_2__c!=0);
        System.assert(updatedCase.Case_Age_In_Business_Hours__c==Null);

        c.Status = 'Closed - Resolved';
        update c;

        updatedCase = [select Time_With_Tier_1__c,Time_With_Tier_2__c,Case_Age_In_Business_Hours__c from Case where Id=:c.Id];

        system.debug('UPDATED CASE TIME IS 2 ' + updatedCase.Time_With_Tier_1__c);
        system.debug('UPDATED CASE TIME IS 2' + updatedCase.Time_With_Tier_2__c);

        System.assert(updatedCase.Time_With_Tier_1__c!=0);
        System.assert(updatedCase.Time_With_Tier_2__c!=0);
        System.assert(updatedCase.Case_Age_In_Business_Hours__c!=0);
    }
}