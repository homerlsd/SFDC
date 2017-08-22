public class ContinueCaseController {
	
	public boolean isChat 													{get;set;}
	public boolean showError 												{get;set;}

	public ContinueCaseController(ApexPages.StandardController controller) {
		isChat = false;
		showError = false;

		string caseID = ApexPages.currentPage().getHeaders().get('id');

		Case[] cs = [select id, Origin from Case where ID =: caseID];

		if(!cs.isEmpty()){

			if(cs[0].Origin == 'Chat'){
				isChat = true;
				system.debug('CHAT IS ' + isChat);
			}
			string instance = 'https://' + ApexPages.currentPage().getHeaders().get('Host');
			instance += '/ui/support/servicedesk/ServiceDeskPage#/csr_createcase?cfid=1234545678';
			system.debug('INSTANCE IS ' + instance);
		}
		else{
			showError = true;
		}
	}
		
}