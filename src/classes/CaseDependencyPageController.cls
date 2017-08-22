public with sharing class CaseDependencyPageController {

	public Case c {get;set;}

    //public string tempid {get;set;}

    public id getTempID(){
    	string tempID1 = ApexPages.currentPage().getParameters().get('id');

        system.debug('CASE ID IS ' + tempid1);
        return tempID1;
    }
	
	public CaseDependencyPageController(ApexPages.StandardController controller) {

        //Set<string> perms = Utils.findUserPermissions(userID);       
    }
}