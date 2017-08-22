@isTest
private class Test_ContentDocumentLinkTrigger {
  
  	private static testMethod void testCreate() {

  		account a = new account(name='test acc ContentDocumentLink');
  		insert a;

	    ContentVersion contentVersion_1 = new ContentVersion(
	      	Title = 'Penguins',
	      	PathOnClient = 'Penguins.jpg',
	     	VersionData = Blob.valueOf('Test Content'),
	      	IsMajorVersion = true
	    );
	    
	    insert contentVersion_1;
	    
	    ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=a.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=contentVersion_2.ContentDocumentId;

        insert contentlink;
	    
    	ContentDocumentLink link = [select id, Visibility from contentdocumentlink where id = : contentlink.id];

	    System.assertEquals('AllUsers', link.Visibility);
  	}
}