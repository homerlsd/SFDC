@isTest
public class implementationviewpagecontrollerTest {

    public static testMethod void testMyController() {
    
    string folderName = label.UploadLogoContoller_Logo_folder;
    Folder f = [select id from folder where Name = :folderName]; 
    
    Document doc=new Document();
    doc.AuthorId = UserInfo.getUserId();
    doc.FolderId = f.id;
    doc.Name='Rally Icon';
    doc.ispublic = true;
    insert doc;
    
    Test.startTest();
        PageReference pageRef = Page.Implementationpage;
       Test.setCurrentPage(pageRef);
       
       Implementationviewpagecontroller svpcntrl=new Implementationviewpagecontroller();
       
    Test.stopTest();   
       
       }
       
       
}