@istest(seealldata=false)
public class Test_ParentCaseSearch {
    //CREATE Tier 2
    @isTest(SeeAllData=false) static void testCreateT2() {   

    	case c = new case(subject='test',status='New Test');
    	insert c;

        PageReference pageRef = page.ParentCaseSeach;
        pageRef.getParameters().put('ID', c.id);
        Test.setCurrentPage(pageRef);

        ParentCaseActionController cont = new ParentCaseActionController();
        cont.getRtypes();
        cont.selectedRtype = LABEL.Test_ParentCaseSearch_Tier2ID;
        cont.showNewCase();
        cont.theCase.subject = 'test';
        cont.save();

        Case c2 = [select id, parent.recordtype.name from case where id =: c.id];
        system.assertEquals('Tier 2', c2.parent.recordtype.name);

    }
    //showErrors
    @isTest(SeeAllData=false) static void testCreateNothing() {   

    	case c = new case(subject='test',status='New Test');
    	insert c;

        PageReference pageRef = page.ParentCaseSeach;
        pageRef.getParameters().put('ID', 'someID');
        Test.setCurrentPage(pageRef);

        ParentCaseActionController cont = new ParentCaseActionController();

    }
    //CREATE CS
    @isTest(SeeAllData=false) static void testCreateCS() {   

    	case c = new case(subject='test',status='New Test');
    	insert c;

        PageReference pageRef = page.ParentCaseSeach;
        pageRef.getParameters().put('ID', c.id);
        Test.setCurrentPage(pageRef);

        ParentCaseActionController cont = new ParentCaseActionController();
        cont.getRtypes();
        cont.selectedRtype = LABEL.Test_ParentCaseSearch_ClientSupportID;
        cont.showNewCase();
        cont.theCase.subject = 'test';
        cont.save();

        Case c2 = [select id, parent.recordtype.name from case where id =: c.id];
        system.assertEquals('Client Support', c2.parent.recordtype.name);

    }
    //LINK Case
    @isTest(SeeAllData=false) static void testLink() {   

    	case c = new case(subject='test',status='New Test');
    	insert c;

    	case c1 = new case(subject='test',status='New Test',RecordTypeID=LABEL.Test_ParentCaseSearch_ClientSupportID);
    	insert c1;

        PageReference pageRef = page.ParentCaseSeach;
        pageRef.getParameters().put('ID', c.id);
        Test.setCurrentPage(pageRef);

        ParentCaseActionController cont = new ParentCaseActionController();
        cont.getRtypes();
        cont.getClientCases();
        cont.getParentCases();
        cont.selectedParent = c1.id;
        cont.showDetails();
        cont.linkParentCase();
        cont.cancel();

        Case c2 = [select id, parentid from case where id =: c.id];
        system.assertEquals(c1.id, c2.parentid);

    }
}