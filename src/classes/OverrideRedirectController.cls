public with sharing class OverrideRedirectController {
	
	private ApexPages.StandardController controller;
	public String retURL {get; set;}
	public String saveNewURL {get; set;}
	public String rType {get; set;}
	public String cancelURL {get; set;}
	public String ent {get; set;}
	public String confirmationToken {get; set;}
	public String accountID {get; set;}
	public String contactID {get; set;}
	
	public String caseid {get; set;}

	public case c {get;set;}

	public OverrideRedirectController(ApexPages.StandardController controller) {
		caseid = '';
		this.controller = controller;

		this.c = (case)controller.getRecord();

		if(c.id != null)
			caseid = c.id;

		retURL = ApexPages.currentPage().getParameters().get('retURL');
		rType = ApexPages.currentPage().getParameters().get('RecordType');
		cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
		ent = ApexPages.currentPage().getParameters().get('ent');
		confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
		saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
		accountID = ApexPages.currentPage().getParameters().get('def_account_id');
		contactID = ApexPages.currentPage().getParameters().get('def_contact_id');
	}

	public PageReference redirect() {

		Set<string> permissions = utils.findUserPermissions(UserInfo.getUserId());

		PageReference returnURL;

		// Redirect if permission corresponds to custom VisualForce page
		if(caseid == ''){
			if(!permissions.isEmpty() && permissions.contains(label.USER_PROPERTY_New_Case_Override_CSR_CreateCase)) 
				returnURL = new PageReference('/apex/CSR_CreateCase?str=');
			else if(!permissions.isEmpty() && permissions.contains(label.USER_PROPERTY_New_Case_Override_CreateCasev2)){
				returnURL = new PageReference('/apex/CreateCasev2?str=');
			}
			else 
				returnURL = new PageReference('/500/e');
		}
		/*else{
			if(!permissions.isEmpty() && permissions.contains(label.USER_PROPERTY_Edit_Case_Override_CSR_EditCase)) 
				returnURL = new PageReference('/apex/CSR_EditCase?id='+caseid);
			else if(!permissions.isEmpty() && permissions.contains(label.USER_PROPERTY_New_Case_Override_CreateCasev2)){
				returnURL = new PageReference('/apex/CreateCasev2?str=');
			}
			else 
				returnURL = new PageReference('/'+caseid+'/e');
		}*/


		if (retURL != null)
			returnURL.getParameters().put('retURL', retURL);
		if (rType != null)
			returnURL.getParameters().put('RecordType', rType);
		if (cancelURL != null)
			returnURL.getParameters().put('cancelURL', cancelURL);
		if (ent != null)
			returnURL.getParameters().put('ent', ent);
		if (confirmationToken != null)
			returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
		if (saveNewURL != null)
			returnURL.getParameters().put('save_new_url', saveNewURL);
		if (accountID != null)
			returnURL.getParameters().put('def_account_id', accountID);
		if (contactID != null)
			returnURL.getParameters().put('def_contact_id', contactID);
		
		returnURL.getParameters().put('nooverride', '1');
		returnURL.setRedirect(true);
		return returnURL;

	}
}