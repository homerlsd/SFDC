public without sharing class WhiteLabelHeaderController {

	private String ParamClient;
    private String ParamPartner;
    private String ParamAffiliation;
    Public String DataCategoryGroupName{get;set;}
    Public String channel {get;set;}

	public WhiteLabelHeaderController(){
		    paramClient = ApexPages.CurrentPage().getparameters().get('Client');
            paramPartner = ApexPages.CurrentPage().getparameters().get('Partner');
            paramAffiliation = ApexPages.CurrentPage().getparameters().get('Affiliation');
            channel = ApexPages.CurrentPage().getparameters().get('channel');
	}
	
}