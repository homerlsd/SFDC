@istest(seealldata=false)
private class Test_EmailMessageTrigger {
	static testMethod void Test_EmailMessageTrigger() {
    	
        Account a = new Account(Name='Alex Test Account');
        insert a;

        Case c = new Case(AccountId = a.id,origin='Email');
        insert c; 
        
        EmailMessage e = new EmailMessage(ParentId = c.id, incoming = true, toaddress='someAddress@test.com', htmlBody=Label.EmailMessageTrigger_CorporateEmailString);
        insert e;
        
        Case myCase = [SELECT to_address__c, sub_origin__c FROM Case WHERE id = :c.Id];
        System.assertEquals(myCase.to_address__c,'someAddress@test.com');
        System.assertEquals(myCase.sub_origin__c,'Corporate Site');

    }

    static testMethod void Test_EmailMessageTrigger_filter() {
        
        Account a = new Account(Name='Alex Test Account');
        insert a;

        Case c = new Case(AccountId = a.id,origin='Email');
        insert c; 
        
        List<Inbound_Email_Address_Filter__mdt> testEmail = [select id, email_address__c from Inbound_Email_Address_Filter__mdt LIMIT 1];

        List<Inbound_Email_Term_Route__mdt> matchings = [select matching_term__c, routing_ID__c from Inbound_Email_Term_Route__mdt LIMIT 1];

        EmailMessage e = new EmailMessage(ParentId = c.id, incoming = true, toaddress=testEmail[0].email_address__c, textbody=matchings[0].matching_term__c);
        insert e;
        
        Case myCase = [SELECT ownerid FROM Case WHERE id = :c.Id];
        
        system.debug('CASE OWNER ID ' + myCase.OwnerId);
        system.debug('ROUTING ID ' + matchings[0].routing_ID__c);

        System.assertEquals(myCase.OwnerId,matchings[0].routing_ID__c);

    }
}