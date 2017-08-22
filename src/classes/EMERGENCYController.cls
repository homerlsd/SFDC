public class EMERGENCYController {

	public SSU__c SiteUtility {get;set;}
	public string downmessage {get;set;}
	public string upmessage {get;set;}
	public string errorMessage {get;set;}

	public EMERGENCYController() {
		Set<string> tempSet = UTILS.findUserPermissions(UserInfo.getUserId());

		if(tempSet.contains('Emergency Page')){
   			SiteUtility = SSU__c.getInstance('Rally Support');
   			downmessage = 'IF THE SITE IS DOWN HIT THIS BUTTON TO TAKE DOWN THE FAQ!';
   			upmessage = 'IF THE SITE IS BACK UP HIT THIS BUTTON TO RESTORE THE FAQ!';
   		}
   		else{
   			errorMessage = 'You do not have the permissions to access this page.';
   		}
	}

	public void siteDown(){
		SiteUtility.Active__c = false;
		update SiteUtility;
	}

	public void siteUp(){
		SiteUtility.Active__c = true;
		update SiteUtility;
	}
}