@istest
public class Test_PartnerTrigger {
	
	@istest(seealldata=false)
	static void  Test_PartnerUpsert() {
		Partner__c opt = new Partner__c(name = 'BCBS South Carolina', partner_string__c = 'BCBSSC');
		insert opt;

		Partner__c p = [select id, Implementation_Record_Type_ID__c from Partner__c where ID = : opt.id];
		system.assert(p.Implementation_Record_Type_ID__c.contains(Label.ROF_BCBSRTYPEID));
	}
}