@istest(seealldata=false)
public class Test_CSRCasePages {
	//CREATE PAGE TESTS
	@isTest(SeeAllData=false) static void testCreate() {		
		Sales_Channel__c sc = CC_TestUtil.createSC();
        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        insert c;
		PageReference pageRef = page.csr_CreateCase;
        pageRef.getParameters().put('str', '8333629');
    	pageRef.getParameters().put('cfID', 'someID');
        Test.setCurrentPage(pageRef);

        CSR_CreateCaseController cont = new CSR_CreateCaseController();
        cont.onLoad();
        System.assertEquals(true, cont.needcon);
        cont.clearError();
        cont.clearInfo();
        cont.con.lastname = 'test';
        cont.closeCase();
        cont.c.subject = 'test';
        cont.saveAnd();

	}

	@isTest(SeeAllData=false) static void testCreatewNumber() {		
		Sales_Channel__c sc = CC_TestUtil.createSC();
        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        insert c;

		PageReference pageRef = page.csr_CreateCase;
        pageRef.getParameters().put('str', '9148333669');
        pageRef.getParameters().put('cfID', 'someID');
        Test.setCurrentPage(pageRef);

        CSR_CreateCaseController cont = new CSR_CreateCaseController();
        cont.onLoad();
        System.assertEquals(false, cont.needcon);
        cont.toSelect = c.id;
        cont.selectCon();
        cont.c.subject = 'test';
        cont.needinfo();
        cont.saveAnd();

        Case cs = [select id from case where contactid = :c.id];
        system.assert(cs != null);

	}

	@isTest(SeeAllData=false) static void testCreatewNumberDOB() {		
		Sales_Channel__c sc = CC_TestUtil.createSC();
        
        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.Date_of_Birth__c = date.today();
        insert c;
        
        PageReference pageRef = page.csr_CreateCase;
        pageRef.getParameters().put('str', '9148333669');
        pageRef.getParameters().put('cfID', 'someID');
        Test.setCurrentPage(pageRef);

        CSR_CreateCaseController cont = new CSR_CreateCaseController();
        cont.onLoad();
        System.assertEquals(false, cont.needcon);

        cont.toSelect = c.id;
        cont.selectCon();
        cont.c.subject = 'test';
        cont.needinfo();
        cont.saveAnd();

        Case cs = [select id from case where contactid = :c.id];
        system.assert(cs != null);

	}

	@isTest(SeeAllData=false) static void testCreateTransfer() {		
		Sales_Channel__c sc = CC_TestUtil.createSC();
        contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333665';
        insert c;

		PageReference pageRef = page.csr_CreateCase;
        pageRef.getParameters().put('str', '8333669');
        pageRef.getParameters().put('cfID', 'someID');
        Test.setCurrentPage(pageRef);

        CSR_CreateCaseController cont = new CSR_CreateCaseController();
        cont.onLoad();
        System.assertEquals(true, cont.needcon);
        
        cont.searchString = '9148333665';
        cont.findsoslResults();

        cont.c.comments__c = 'test';

        cont.c.subject = 'test';
        cont.con.lastname = 'test';
        cont.con.Date_of_Birth__c = date.today();
        cont.transferToOptum();
        cont.saveAnd();
        


        Case cs = [select id,status,contactid from case LIMIT 1];
        system.assert(cs.status == Label.csr_create_case_transferredtooptum);
        system.assert(cs.contactid != null);

	}
	
	///EDIT PAGE TESTS
	@isTest(SeeAllData=false) static void testEdit() {		
		contact C = new contact();
        c.lastname = 'tadgd';
        c.phone = '9148333669';
        c.Date_of_Birth__c = date.today();
        insert c;

        case ca = new case(subject='test',contactid=c.id);
        insert ca;

		PageReference pageRef = new PageReference('/apex/csr_editcase?id='+ca.id);
    	Test.setCurrentPage(pageRef);
        CSR_EditCaseController cont = new CSR_EditCaseController();
        System.assertEquals(false, cont.needcon);
        cont.clearError();
        cont.clearInfo();
        cont.con.lastname = 'test';
        cont.closeCase();
        cont.c.subject = 'test';
        cont.needInfo();

	}

	@isTest(SeeAllData=false) static void testEditNoContact() {		
        case ca = new case(subject='test');
        insert ca;

		PageReference pageRef = new PageReference('/apex/csr_editcase?id='+ca.id);
    	Test.setCurrentPage(pageRef);
        CSR_EditCaseController cont = new CSR_EditCaseController();
        System.assertEquals(true, cont.needcon);
        cont.clearError();
        cont.clearInfo();
        cont.con.lastname = 'test';
        cont.closeCase();
        cont.c.subject = 'test';
        cont.transferToOptum();

	}

	@isTest(SeeAllData=false) static void testEditNoContactCatch() {		
        case ca = new case(subject='test');
        insert ca;

		PageReference pageRef = new PageReference('/apex/csr_editcase?id='+ca.id);
    	Test.setCurrentPage(pageRef);
        CSR_EditCaseController cont = new CSR_EditCaseController();
        System.assertEquals(true, cont.needcon);
        cont.saveAnd();

	}

}