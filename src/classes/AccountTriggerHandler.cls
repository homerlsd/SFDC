public class AccountTriggerHandler {
	
	public static void beforeUpsert(Account[] accs, Map<Id, Account> oldAccmap) {
		for(account a : accs){

			if(a.Direct_Link__c != null &&
				(trigger.isInsert || (trigger.isUpdate && a.Direct_Link__c != oldAccmap.get(a.id).Direct_Link__c))){
				
				String[] sss = a.Direct_Link__c.split('/');
				
				integer siz = sss.size()-1;

				string ss = sss[siz];
				
				if(ss == 'register'){
					integer i = siz-1;
					a.External_Client_String__c = sss[i];
				}
				else{
					a.External_Client_String__c = 'Bad Direct Registration URL';
				}
			}
		}
	}
}