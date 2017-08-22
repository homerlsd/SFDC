@istest(seealldata=True)
public class Testfivenineemailhandler{
static testMethod void myTestMethod(){

   // Create a new email, envelope object and Attachment
   
   test.starttest();

   Messaging.InboundEmail email = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
   Messaging.InboundEmail.TextAttachment inAtt = new Messaging.InboundEmail.TextAttachment();

   email.subject = 'test';
   env.fromAddress = 'user@acme.com'; 

   // set the body of the attachment
   Document lstDoc = [select id,name,Body from Document where name = 'Test Data for fivenineemail services'];
   
   inAtt.Body = lstDoc.Body.toString();
   inAtt.fileName = 'my attachment name';
   inAtt.mimeTypeSubType = 'text/csv';

   email.TextAttachments = new Messaging.inboundEmail.TextAttachment[] {inAtt };
   
   contact con = new contact(lastname='wayne');
   insert con;
 
   task t = new task(Five9__Five9SessionId__c='1BA8C40E02B72491A9E069B994F8A2D8E',activitydate=date.today(),status='Completed',priority='Normal', Processed__c = false);
   insert t;
  
    Case c = new case(subject='batman',Call_Id__c='BA8C40E02B72491A9E069B994F8A2D8Etest2',contactid=con.id, Origin='Phone');
   insert c;
   
   // call the class and test it with the data in the testMethod
   fiveNineEmailHandler emailServiceObj = new fiveNineEmailHandler();
   emailServiceObj.handleInboundEmail(email, env );
   
   test.stoptest();                     

  }
  
  static testMethod void myTestMethodnegativeTest(){

   // Create a new email, envelope object and Attachment
   
   test.starttest();
   
   Messaging.InboundEmail email = new Messaging.InboundEmail();
   Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
   Messaging.InboundEmail.TextAttachment inAtt = new Messaging.InboundEmail.TextAttachment();
   
   email.subject = 'test';
   env.fromAddress = 'user@acme.com';
   
   // set the body of the attachment
   Document lstDoc = [select id,name,Body from Document where name = 'Bad Test Data'];
   
   contact con = new contact(lastname='wayne');
    insert con;
   
   task t = new task(Five9__Five9SessionId__c='1BA8C40E02B72491A9E069B994F8A2D8E',activitydate=date.today(),status='Completed',priority='Normal', Processed__c = false);
    insert t;
    
   Case c = new case(subject='batman',Call_Id__c='BA8C40E02B72491A9E069B994F8A2D8Etest1',contactid=con.id, Origin='Phone');
    insert c;
   
   inAtt.Body = lstDoc.Body.toString();
   inAtt.fileName = 'my attachment name';
   inAtt.mimeTypeSubType = 'text/csv';

   email.TextAttachments = new Messaging.inboundEmail.TextAttachment[] {inAtt };
   
   // call the class and test it with the data in the testMethod
   fiveNineEmailHandler emailServiceObj = new fiveNineEmailHandler();
   emailServiceObj.handleInboundEmail(email, env );
   
   test.stoptest();                     

  }  
}