@istest(seealldata=false)
public class Test_CreateCasev2 {
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

        PageReference pageRef = page.CreateCasev2;
        pageRef.getParameters().put('ANI', '9148333629');
        pageRef.getParameters().put('Call_ID', 'someID');
        Test.setCurrentPage(pageRef);

        CreateCasev2Controller cont = new CreateCasev2Controller();
        cont.onLoad();
        System.assertEquals(true, cont.needcon);
        cont.clearError();
        cont.clearInfo();
        cont.con.lastname = 'test';
        cont.closeCase();
        cont.c.subject = 'test';
        cont.con.accountid = acc.id;
        cont.saveAnd();

    }

    @isTest(SeeAllData=false) static void testCreatewNumber() {     
        Sales_Channel__c sc = CC_TestUtil.createSC();
        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.accountid = acc.id;
        insert c;

        PageReference pageRef = page.CreateCasev2;
        pageRef.getParameters().put('ANI', '9148333669');
        pageRef.getParameters().put('Call_ID', 'someID');
        pageRef.getParameters().put('DNIS', '9148333224');
        Test.setCurrentPage(pageRef);

        CreateCasev2Controller cont = new CreateCasev2Controller();
        cont.onLoad();
        System.assertEquals(false, cont.needcon);
        cont.toSelect = c.id;
        cont.selectCon();
        cont.c.subject = 'test';
        cont.needinfo();
        cont.con.accountid = acc.id;
        cont.saveAnd();

        Case cs = [select id from case where contactid = :c.id];
        system.assert(cs != null);

    }

    @isTest(SeeAllData=false) static void testCreatewNumberDOB() {      
        Sales_Channel__c sc = CC_TestUtil.createSC();
        
        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.accountid = acc.id;
        c.Date_of_Birth__c = date.today();
        insert c;
        
        PageReference pageRef = page.CreateCasev2;
        pageRef.getParameters().put('ANI', '9148333669');
        pageRef.getParameters().put('Call_ID', 'someID');
        pageRef.getParameters().put('DNIS', '9148333224');
        Test.setCurrentPage(pageRef);

        CreateCasev2Controller cont = new CreateCasev2Controller();
        cont.onLoad();
        System.assertEquals(false, cont.needcon);

        cont.toSelect = c.id;
        cont.selectCon();
        cont.c.subject = 'test';
        cont.needinfo();
        cont.con.accountid = acc.id;
        cont.saveAnd();

        Case cs = [select id from case where contactid = :c.id];
        system.assert(cs != null);

    }

    @isTest(SeeAllData=false) static void testSelectFoundCon() {      
        Sales_Channel__c sc = CC_TestUtil.createSC();
        
        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.accountid = acc.id;
        c.Date_of_Birth__c = date.today();
        insert c;
        
        PageReference pageRef = page.CreateCasev2;
        pageRef.getParameters().put('ANI', '9148333669');
        pageRef.getParameters().put('Call_ID', 'someID');
        pageRef.getParameters().put('DNIS', '9148333224');
        Test.setCurrentPage(pageRef);

        CreateCasev2Controller cont = new CreateCasev2Controller();
        cont.onLoad();
        System.assertEquals(false, cont.needcon);

        cont.toSelect = c.id;
        cont.selectFound();
        cont.noContact();

    }


    @isTest(SeeAllData=false) static void testCreateTransfer() {        
        Sales_Channel__c sc = CC_TestUtil.createSC();
        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333665';
        c.accountid = acc.id;
        insert c;

        PageReference pageRef = page.CreateCasev2;
        pageRef.getParameters().put('ANI', '9148333669');
        pageRef.getParameters().put('Call_ID', 'someID');
        Test.setCurrentPage(pageRef);

        CreateCasev2Controller cont = new CreateCasev2Controller();
        cont.onLoad();
        System.assertEquals(true, cont.needcon);
        
        cont.searchString = '9148333665';
        cont.findsoslResults();

        cont.c.comments__c = 'test';

        cont.c.subject = 'test';
        cont.con.lastname = 'test';
        cont.con.Date_of_Birth__c = date.today();
        cont.c.step_1__c = 'test';
        cont.c.step_2__c = 'test';
        cont.c.step_3__c = 'test';
        cont.c.step_4__c = 'test';
        cont.c.step_5__c = 'test';
        cont.c.step_6__c = 'test';
        cont.transferToOptum();
        cont.con.accountid = acc.id;
        cont.saveAnd();
        


        Case cs = [select id,status,contactid from case LIMIT 1];
        system.assert(cs.status == Label.csr_create_case_transferredtooptum);
        system.assert(cs.contactid != null);

    }

    @isTest(SeeAllData=false) static void testCreateClosed() {        
        Sales_Channel__c sc = CC_TestUtil.createSC();


        Account acc = new Account(name='someAccountfake1');
        insert acc;

        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333665';
        c.accountid = acc.id;
        insert c;

        PageReference pageRef = page.CreateCasev2;
        pageRef.getParameters().put('ANI', '9148333669');
        pageRef.getParameters().put('Call_ID', 'someID');
        Test.setCurrentPage(pageRef);

        CreateCasev2Controller cont = new CreateCasev2Controller();
        cont.onLoad();
        System.assertEquals(true, cont.needcon);
        
        cont.searchString = '9148333665';
        cont.findsoslResults();

        cont.c.comments__c = 'test';

        cont.c.subject = 'test';
        cont.con.lastname = 'test';
        cont.con.Date_of_Birth__c = date.today();
        cont.c.step_1__c = 'test';
        cont.c.step_2__c = 'test';
        cont.c.step_3__c = 'test';
        cont.c.step_4__c = 'test';
        cont.c.step_5__c = 'test';
        cont.c.step_6__c = 'test';
        cont.closeCase();
        cont.con.accountid = acc.id;
        cont.saveAnd();
        


        Case cs = [select id,status,contactid from case LIMIT 1];
        system.assert(cs.status == Label.csr_createcase_closed);
        system.assert(cs.contactid != null);

    }
}