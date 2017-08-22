@isTest
private class Test_UploadLogoController {
	
	@isTest static void test_upload() {
		Milestone1_Project__c imp=new Milestone1_Project__c();
        imp.name = 'test';
        insert imp;

        Attachment att = new Attachment();
   	 	att.Body=Blob.valueOf('abc');
        att.Name='TestAttachment1';
        att.parentID = imp.id;
        insert att;

        imp.Client_Logo_ID__c = att.id;
        update imp;

        PageReference ref = new PageReference('/apex/UploadClientLogo?id=' + imp.id);
        Test.setCurrentPage(ref);
        
        UploadLogoController cont=new UploadLogoController();
        
        cont.attch.Body = Blob.valueof('abc');
        cont.attch.Name = 'Attach. Name';
        cont.upload();
        cont.Cancel();
	}
	
}