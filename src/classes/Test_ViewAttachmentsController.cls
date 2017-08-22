@istest(seealldata=false)
public class Test_ViewAttachmentsController {

    @isTest(SeeAllData=false) static void testView() {        
        Account acc = new Account(name='someAccountfake1');
        insert acc;
		
		attachment att = new attachment(body=blob.valueOf('test'),name='test', parentID = acc.id);
		insert att;

        PageReference pageRef = page.ViewAttachments;
        pageRef.getParameters().put('ID', acc.id);
        Test.setCurrentPage(pageRef);

        ViewAttachmentsController cont = new ViewAttachmentsController();

        System.assertEquals(1, cont.Atts.size());

        cont.goHome();
    }

}