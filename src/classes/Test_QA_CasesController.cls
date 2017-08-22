@istest(seealldata=true)
public class Test_QA_CasesController {
    //CREATE PAGE TESTS
    @isTest(SeeAllData=false) static void testCreate() {        
        Sales_Channel__c sc = CC_TestUtil.createSC();
        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.accountid = acc.id;
        insert c;

        Case ca = new Case(contactid=c.id,Origin='Phone',
                            Subject='Feedback - Something'); 
        insert ca;

        PageReference pageRef = page.QACasesPage;
        pageRef.getParameters().put('ID', ca.id);
        Test.setCurrentPage(pageRef);

        QACasesController cont = new QACasesController();
        cont.getQATypes();

        cont.qaNew.Agent__c = UserInfo.getUserId();
        cont.qaNew.QA_Type__c = 'Phone';

        cont.selectedType = 'Phone';

        cont.setSelectedType();
      
        pageRef.getParameters().put('subCat', Label.Test_QA_CasesController_AuthenticationSubCat);
      
      	cont.updateScore();

        cont.saveQA();

    }

    @isTest(SeeAllData=false) static void testCreate_category() {        
        Sales_Channel__c sc = CC_TestUtil.createSC();
        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.accountid = acc.id;
        insert c;

        Case ca = new Case(contactid=c.id,Origin='Phone',
                            Subject='Feedback - Something'); 
        insert ca;

        PageReference pageRef = page.QACasesPage;
        pageRef.getParameters().put('ID', ca.id);
        Test.setCurrentPage(pageRef);

        QACasesController cont = new QACasesController();
        cont.getQATypes();

        cont.qaNew.Agent__c = UserInfo.getUserId();
        cont.qaNew.QA_Type__c = 'Phone';

        cont.selectedType = 'Phone';

        cont.setSelectedType();
      
        pageRef.getParameters().put('subCat', Label.Test_QA_CasesController_AccurateSubCat);
      
      	cont.updateScore();

        cont.saveQA();

    }
}