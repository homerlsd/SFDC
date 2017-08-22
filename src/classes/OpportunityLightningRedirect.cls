public with sharing class OpportunityLightningRedirect {

	private ApexPages.StandardController controller;

	public String oppID {get; set;}
	public String retURL {get; set;}

	public opportunity o {get;set;}


	public OpportunityLightningRedirect(ApexPages.StandardController controller) {
		oppID = '';
		this.controller = controller;

		this.o = (opportunity)controller.getRecord();

		if(o.id != null)
			oppID = o.id;

		retURL = ApexPages.currentPage().getParameters().get('retURL');

	}

	public PageReference redirect() {

		Set<string> permissions = utils.findUserPermissions(UserInfo.getUserId());

		PageReference returnURL;

		system.debug('OPP ID IS ' + oppID);
		system.debug('PERMS ARE ' + oppID);

		// Redirect if permission corresponds to custom VisualForce page
		if(oppID != ''){
			if(!permissions.isEmpty() && permissions.contains(label.USER_PROPERTY_LightningRedirect)) 
				returnURL = new PageReference('/'+oppid);
			else 
				returnURL = new PageReference('/apex/opportunitypagelayout?id='+oppID);
		}
		else{
			return null;
		}

		if (retURL != null)
			returnURL.getParameters().put('retURL', retURL);

		returnURL.getParameters().put('nooverride', '1');
		returnURL.setRedirect(true);
		return returnURL;

	}
		
}