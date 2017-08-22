public class ClientLinkController {

	public Map<string,Account> clientMap 													{get;set;}
	public Set<string> clientNames 															{get;set;}
	public String selectedClient 															{get;set;}
	public boolean showError		 														{get;set;}
	public String errorMessage		 														{get;set;}
	public Account selectedClientID 														{get;set;}

	public ClientLinkController() {
		showError = false;
		selectedClient = '';
		errorMessage = '';
		selectedClientID = new Account();
		clientMap = new Map<String,Account>();
		clientNames = new Set<String>();

		string partnerid = Apexpages.currentPage().getParameters().get('id');

	    List<Account> Clients = [select id, name, (select id, name from Rally_Implementations__r) from Account where Partner__c = :partnerid];
	    for(Account cl : Clients){
	    	string stemp = String.escapeSingleQuotes(cl.name);
	    	clientMap.put(stemp,cl);
	    }

	    clientNames.addAll(clientMap.keyset());

	    system.debug('Clients ARE ' + clientMap);
	}

	public void getLinkStuff(){
        system.debug('SELECTED CLIENT IS ' + selectedClient);

        if(clientMap.containsKey(String.escapeSingleQuotes(selectedClient))){
            selectedClientID = clientMap.get(String.escapeSingleQuotes(selectedClient));
            system.debug('DO WE FIND A CLIENT?' + selectedClientID);
	    	
	    	if(selectedClientID.Rally_Implementations__r.isEmpty()){
	    		showError = true;
	    		errorMessage = Label.ClientLinkController_NoImplementationsError;
	    	}

        }
    }
		
}