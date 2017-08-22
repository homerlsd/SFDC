public without sharing class CC_SupportFooterController {

	private String ParamClient;
    private String ParamPartner;
    private String ParamAffiliation;
    Public String DataCategoryGroupName{get;set;}
    Public String channel {get;set;}
	public CC_SupportFooterController(){
		    paramClient = ApexPages.CurrentPage().getparameters().get('Client');
            paramPartner = ApexPages.CurrentPage().getparameters().get('Partner');
            paramAffiliation = ApexPages.CurrentPage().getparameters().get('Affiliation');
            channel = ApexPages.CurrentPage().getparameters().get('channel');

            DataCategoryGroupName = ApexPages.CurrentPage().getparameters().get('DataCategoryGroupName');

            if(String.isEmpty(DataCategoryGroupName)){
        			DataCategoryGroupName= CC_Util.getGroupName(paramClient,paramPartner,paramAffiliation,channel);
            }
	}
	
}