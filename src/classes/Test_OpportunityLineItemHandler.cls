@istest
public class Test_OpportunityLineItemHandler {
	
	@istest(seealldata=false)
	static void Test_OpportunityLineItemHandler() {
		//Set up test data
		Account a = new Account(Name='Lexcorp');
        insert a;

        RecordType rt = [select id from RecordType where sObjectType='Opportunity' AND Name = 'Engage'];

        Opportunity opp = new Opportunity(accountid=a.id,name='Lexcorp Engage', closeDate=date.today(), stageName='Test');
        insert opp;

        Product2 packagee = new Product2(Name='Test Product',isActive=true, Product_Type__c ='Package', Product_Sub_Type__c = 'Base');
        insert packagee;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=packagee.Id, UnitPrice=99, isActive=true);
        insert pbe;

        opportunityLineItem oli1 = new opportunityLineItem(opportunityid = opp.id, Implementation_Fee__c = 7, pricebookentryid = pbe.id, quantity = 1, unitprice = 10);
        insert oli1;

        //testing opportunitylineitemhandler before/after insert
        opportunityLineItem[] query1 = [select id, Non_Tailored_Options__c, Implementation_Fee__c from opportunityLineItem where opportunityid = : opp.id];
        system.assertEquals(1, query1.size());

        for(opportunityLineItem oli : query1){
        	if(oli.id == oli1.id)
        		oli.Implementation_Fee__c = 5;
        }

        update query1;

        //testing opportunitylineitemhandler after update
        opportunityLineItem[] query2 = [select id, totalprice from opportunityLineItem where Parent_Opportunity_Product_ID__c = : oli1.id];

        delete oli1;

        //testing opportunitylineitemhandler before delete
        opportunityLineItem[] query3 = [select id from opportunityLineItem where opportunityid = : opp.id];
        system.assert(query3.isEmpty());
	}
}