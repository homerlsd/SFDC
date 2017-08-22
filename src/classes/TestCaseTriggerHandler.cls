@IsTest
public class TestCaseTriggerHandler {

    @IsTest(seealldata=true)
    public static void testAfterUpsert() {
        Case c = new Case(hashtag__c = 'MagnetoWasRight', Comments__c = 'MagnetoWasRight',Subject='MagnetoWasRight');
        insert c;

        CaseComment cc = [select id, commentbody from CaseComment where parentid = :c.id];

        system.assert(cc.commentBody == 'MagnetoWasRight');

        FeedItem fi = [select id, body from FeedItem where parentid = :c.id];

        system.assert(fi.body.contains('MagnetoWasRight'));

    }
    
    @IsTest(seealldata=false)
    public static void testBulkContactsGetCreated() {
        List<Case> newCases = new List<Case>();
        for (Integer i = 0; i<10; i++) {
            Case c = new Case(Email__c='jdoe_test_test@doe.com' + i,
                                First_Name__c='John' + i,
                                Last_Name__c = 'Doe' + i,
                                Origin = 'Email',
                                Subject='Feedback - Something' + i,
                                suppliedemail = 'Testing' + i + '@testing.net');
            newCases.add(c);
        }
        insert newCases;
        
        List<Id> newCaseIds = new List<Id>();
        for (Case caseObj:newCases) {
            newCaseIds.add(caseObj.Id);    
        }
        
        List<Case> updatedCases = [Select ContactId From Case Where Id in :newCaseIds];
        
        for (Case caseObj:updatedCases) {
            System.debug(caseObj.Id + ' ' + caseObj.ContactId);
            System.assert(caseObj.ContactId!=null,'There should be no null contacts');
        }
    }
    
    @IsTest(seealldata=false)
    public static void testContactGetsCreated() {
        Case c = new Case(Email__c='jdoe_test_test1@doe.com',
                                First_Name__c='John',
                                Last_Name__c = 'Doe1',
                                Origin = 'Email',
                                Subject='Feedback - Something',
                                suppliedemail = 'jdoe_test_test1@doe.com');
        insert c;

        List<Contact> johnDoes = [select Id from Contact where Email='jdoe_test_test1@doe.com'];

        //there should be only 1 -- the trigger should not have created another
        System.assert(johnDoes.size()==1, 'There should be one John Doe!');
        
        Case caseObj = [select ContactId from Case where Id=:c.Id];
        System.assert(caseObj.ContactId!=null,'There should be no null contact on the case');
    }

    @IsTest(seealldata=false)
    public static void testNoDupesAreCreated() {
        Contact cnt1 = new Contact(FirstName = 'John',
                                LastName = 'Doe',
                                Email='Testing_ind2@test.net');

        insert cnt1;

        Case case1 = new Case(Email__c='jdoe_test_test2@doe.com',
                                First_Name__c='John',
                                Last_Name__c = 'Doe1',
                                Subject='Feedback - Something',
                                suppliedemail = 'Testing_ind2@test.net');

        insert case1;

        List<Contact> johnDoes = [select Id from Contact where Email='Testing_ind2@test.net'];

        //there should be only 1 -- the trigger should not have created another
        System.assert(johnDoes.size()==1, 'There should be only one John Doe!');
    }

    @IsTest(seealldata=false)
    public static void testEmailNameDoesntGetCreated() {
        Case c = new Case(First_Name__c='testEmailNameDoesntGetCreated@doe.com',
                            Last_Name__c='testEmailNameDoesntGetCreated@doe.com',
                            Subject='Feedback - Something');
        insert c;

        List<Contact> johnDoes = [select Id from Contact where email='Testing_ind3@testing.net'];

        System.assert(johnDoes.size()==0, 'There should be no John Does!');
    }

    @IsTest(seealldata=false)
    public static void testChannelUpdate() {

        Sales_Channel__c sc = CC_TestUtil.createSC();

        Sales_Channel__c sc1 = [select Case_Record_Type_ID__c from Sales_Channel__c where ID = :sc.id];

        system.debug('WHAT IS THE RTYPE ID ' + sc1.Case_Record_Type_ID__c);

        Case c = new Case(First_Name__c='testEmailNameDoesntGetCreated@doe.com',
                            Last_Name__c='testEmailNameDoesntGetCreated@doe.com',
                            Subject='Feedback - Something',
                            Origin='Email',
                            RecordTypeId=sc1.Case_Record_Type_ID__c);
        insert c;

        List<Contact> johnDoes = [select Id from Contact where email='Testing_ind3@testing.net'];

        System.assert(johnDoes.size()==0, 'There should be no John Does!');
    }
}