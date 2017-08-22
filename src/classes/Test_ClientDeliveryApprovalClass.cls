@istest
public class Test_ClientDeliveryApprovalClass {
	//Test Method for main class
   	@istest(seealldata=false)
    static void TestinBoundEmail(){

    	Milestone1_Project__c imp = new Milestone1_Project__c(name='test');
    	insert imp;

    	Approver__c app = new Approver__c(Implementation__c = imp.id);
    	insert app;

       	// create a new email and envelope object
       	Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       	Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
       	// setup the data for the email
      	email.subject = 'ApprTest';
      	email.fromAddress = 'someaddress@email.com';
      	email.plainTextBody = ' approved \n' + app.id +'\n';
      
      	// call the email service class and test it with the data in the testMethod
      	ClientDeliveryApprovalClass  testInbound= new ClientDeliveryApprovalClass();
      	testInbound.handleInboundEmail(email, env);

      	Approver__c app2 = [select id, Approval_Status__c from Approver__c where ID =: app.id];
      	system.assertEquals('Approved', app2.Approval_Status__c);
   
   }

	 @istest(seealldata=false)
    static void TestinBoundEmail_reject(){

    	Milestone1_Project__c imp = new Milestone1_Project__c(name='test');
    	insert imp;

    	Approver__c app = new Approver__c(Implementation__c = imp.id);
    	insert app;

     	// create a new email and envelope object
     	Messaging.InboundEmail email = new Messaging.InboundEmail() ;
     	Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
     
     	// setup the data for the email
    	email.subject = 'ApprTest';
    	email.fromAddress = 'someaddress@email.com';
    	email.plainTextBody = 'rejected \n' + app.id +'\n';
    
    	// call the email service class and test it with the data in the testMethod
    	ClientDeliveryApprovalClass  testInbound= new ClientDeliveryApprovalClass();
    	testInbound.handleInboundEmail(email, env);

    	Approver__c app2 = [select id, Approval_Status__c from Approver__c where ID =: app.id];
    	system.assertEquals('Rejected', app2.Approval_Status__c);
   
   }

   @istest(seealldata=false)
    static void TestinBoundEmail_dontfind(){

       	// create a new email and envelope object
       	Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       	Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
       	// setup the data for the email
      	email.subject = 'ApprTest';
      	email.fromAddress = 'someaddress@email.com';
      	email.plainTextBody = 'email body\n2225256325\nTitle';
      
      	// call the email service class and test it with the data in the testMethod
      	ClientDeliveryApprovalClass  testInbound= new ClientDeliveryApprovalClass();
      	testInbound.handleInboundEmail(email, env);
   
   }
}