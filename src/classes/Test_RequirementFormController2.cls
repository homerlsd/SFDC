@istest
public class Test_RequirementFormController2 {

    @isTest(SeeAllData=true) static void testCreate() {    
        Account a = new Account(name='test');
        insert a;
        
        RecordType rt = [select id from RecordType where name = 'Engage - Optum' AND sObjectType = 'Milestone1_Project__c'];

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, RecordTypeID=rt.id);
        insert imp;

        PageReference pageRef = page.RequirementForm;
        pageRef.getParameters().put('impID', imp.id);
        pageRef.getParameters().put('formID', 'dhp_rx');
        Test.setCurrentPage(pageRef);

        RequirementFormController2 cont = new RequirementFormController2();
        cont.addRecord();
        cont.removeRecord();
        cont.submitResults();
        cont.goToLink();
        //System.assert(cont.objName == 'challenge_requirement__c');
        //System.assert(cont.fieldsetName.contains('TeamChallenge'));

        //cont.newObject.put('Challenge_Start_DateString__c','02/07/1984');

        //cont.submitResults();

    }
}