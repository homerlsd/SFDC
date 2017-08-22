@istest
public class TestProductScheduleHandler {
	
	@istest(seealldata=false)
	static void TestProductScheduleHandler() {
		//Set up test data
		Account a = new Account(Name='Lexcorp');
        insert a;

        RecordType rt = [select id from RecordType where sObjectType='Opportunity' AND Name = 'Engage'];

        Opportunity opp = new Opportunity(accountid=a.id,name='Lexcorp Engage', closeDate=date.today(), stageName='Test', Go_Live__c = date.today(), Membership_Term__c = 3);
        insert opp;

        Product2 packagee = new Product2(Name='Test Product',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=packagee.Id, UnitPrice=99, isActive=true);
        insert pbe;

        opportunityLineItem oli1 = new opportunityLineItem(opportunityid = opp.id, Implementation_Fee__c = 7, pricebookentryid = pbe.id, quantity = 1, unitprice = 10);
        insert oli1;

        List<Opportunity_Schedule__c> con = [select id, End_Date__c, (select id, End_Date__c from Product_Schedule__r) from Opportunity_Schedule__c WHERE Opportunity__c = : opp.Id];
        
        system.assertEquals(1, con.size());
        system.assert(!con[0].Product_Schedule__r.isEmpty());

        Date endCheck;

        for(Product_Schedule__c ps : con[0].Product_Schedule__r){
        	if(endCheck == null || endCheck < ps.End_Date__c)
        		endCheck = ps.End_Date__c;
        }

        system.assertEquals(endCheck, con[0].End_Date__c);
	}
}