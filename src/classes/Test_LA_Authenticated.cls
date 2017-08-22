@isTest(SeeAllData=false)
public class Test_LA_Authenticated {
	//CREATE PAGE TESTS
    @isTest(SeeAllData=false) static void testSaveAnd() {        
        Case c = new Case();
        c.subject = 'tadgd';
        c.status = 'somestat';
        insert c;

        PageReference pageRef = page.LA_Authenticated;
        pageRef.getParameters().put('ID', c.id);
        Test.setCurrentPage(pageRef);

        LA_Authenticated cont = new LA_Authenticated();
        system.assertEquals(false, cont.showError);
        cont.getAuthValues();
        cont.selectedAuth = '--Select One--';
        cont.saveAnd();

        system.assertEquals(Label.LA_Authenticated_SelectOneError, cont.showAuthError);

        cont.selectedAuth = 'Yes';
        cont.saveAnd();

        Case c2 = [select id, authenticated__c from Case where ID = :c.id];

        system.assertEquals(true,c2.authenticated__c);

    }

    @isTest(SeeAllData=false) static void testSaveAndNo() {        
        Case c = new Case();
        c.subject = 'tadgd';
        c.status = 'somestat';
        insert c;

        PageReference pageRef = page.LA_Authenticated;
        pageRef.getParameters().put('ID', c.id);
        Test.setCurrentPage(pageRef);

        LA_Authenticated cont = new LA_Authenticated();
        system.assertEquals(false, cont.showError);
        cont.getAuthValues();
        cont.selectedAuth = 'No';
        cont.showUnauthFields();
        cont.saveAnd();

        system.assertEquals(Label.LA_Authenticated_UnauthedSaveError, cont.showAuthError);

        cont.cc.commentBody = 'something';
        cont.saveAnd();

        Case c2 = [select id, status,authenticated__c from Case where ID = :c.id];

        system.assertEquals(false,c2.authenticated__c);
        system.assertEquals(Label.LA_Authenticated_ClosedNoResponseStatus,c2.status);

    }
}