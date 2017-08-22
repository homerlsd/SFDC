@isTest
// Unit Tests for CC_SupportCaseController
// @author 7s
// @version Nov 21 2014 
private class CC_ClientCaseControllerTest {
  User testCommunityUser;
  PageReference pageRef;
  CC_ClientCaseController cont; 
  
  private void setUp(){
        Sales_Channel__c ch = CC_TestUtil.createSC();
        ch.Name='Choice';
        update ch;
        
        Knowledge_Group__c kg = new Knowledge_Group__c(Group_Name__c = 'testTestTest', Channel__c = ch.id, Default_Group_For_Channel__c = true, Active__c = true, Apply_Defaults__c = true);
        insert kg;

    pageRef = Page.CC_SupportCase;
        pageRef.getParameters().put('DataCategoryGroupName','testTestTest');
        Test.setCurrentPage(pageRef);
        cont = new  CC_ClientCaseController();
  }
  // test creating case
  @isTest static void test_create_case() {
      CC_ClientCaseControllerTest tes = new CC_clientCaseControllerTest  ();
      tes.setUp();
    
            tes.cont.NewCase.First_name__c= 'tesF';
            tes.cont.NewCase.Last_name__c= 'tesF';
            tes.cont.NewCase.Email__c= 'tes@tes.com';
            //tes.cont.DateOfBirthString= '11/20/1985';
            tes.cont.NewCase.Company__c = 'test';
          tes.cont.NewCase.subject = 'for unittest';
          tes.cont.NewCase.description = 'description';
          tes.cont.NewCase.type = 'Problem';
          //tes.cont.DateExperiencedString = '11/20/2014';
          tes.cont.NewCase.Issue_Bug__c = 'Rewards';
          //tes.cont.att.Name = 'attachment';
            //tes.cont.att.description = 'desc';
            //tes.cont.att.Body = Blob.valueOf('test body');
            
            PageReference p = tes.cont.CreateCase();

            //System.assertEquals('/CC_SupportCase?DataCategoryGroupName=testTestTest&thankyou=true',p.getURL());
            

            // check case is created with all fields value correctly
            List<Case> cList = [select subject,description, Date_Experienced__c, type, Issue_Bug__c from Case where subject = 'for unittest'];
            
            //System.assertEquals('description',cList[0].description);
            //System.assertEquals('Problem',cList[0].type); 
            //System.assertEquals(11,cList[0].Date_Experienced__c.month());
            //System.assertEquals(20,cList[0].Date_Experienced__c.day()); 
            //System.assertEquals(2014,cList[0].Date_Experienced__c.year()); 
            // check attachment is created    
           /* List<Attachment> lisAtt = [select id from Attachment where parentId = :cList[0].Id];
          System.assert(lisAtt.size()>0);

            System.assert( CC_reCAPTCHAUtil.publicKey != null);
             System.assert( CC_reCAPTCHAUtil.verified );*/

      
    
  }
  
  @isTest static void test_validate() {
        CC_ClientCaseControllerTest tes = new CC_ClientCaseControllerTest  ();
      tes.setUp();
    
            
            PageReference p = tes.cont.CreateCase();
            tes.cont.clear();
            
            System.assertEquals(null,tes.cont.SubjectRequired);
            System.assertEquals(null,tes.cont.MessageRequired);
            System.assertEquals(null,tes.cont.TopicRequired);
                        
            p=tes.cont.CreateCase();
                        
      
      
  }
  
  @isTest static void test_navigateToHome() {
          CC_ClientCaseControllerTest tes = new CC_clientCaseControllerTest  ();
          tes.setUp();
        
          
               PageReference p = tes.cont.NavigatesToHome();

                //System.assertEquals('/?DataCategoryGroupName=testTestTest',p.getURL());
          
    }
    
    @isTest static void test_picklistValues() {
        CC_clientCaseControllerTest tes = new CC_clientCaseControllerTest  ();
          tes.setUp();
        
               List<SelectOption> topicValues = tes.cont.getTopicValues();
                 // check actual values
                 System.assertEquals('', topicValues[0].getValue());
                 System.assertEquals('Problem', topicValues[1].getValue());
                 System.assertEquals('Question', topicValues[2].getValue());
                 
                 Schema.DescribeFieldResult fieldResult = Case.Issue_Bug__c.getDescribe();
                 List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                 
                 List<SelectOption> issueBugValues = tes.cont.getIssueBugValues();
                 // calling describe just check size. since having "--Select One--" + 1
                 System.assertEquals(ple.size()+1,issueBugValues.size());
          
    
    }
  
}