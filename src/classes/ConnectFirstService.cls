global class ConnectFirstService {
    
    webService static boolean UpdateCase(string uii, integer timeOfCall) {
        Case c = [select id, agent_duration__c from case where Connect_First_Id__c = : uii];
        if(c != null){
	        c.agent_duration__c = timeOfCall;
	       	update c;
	       	return true;
	    }
	    else
       		return false;
    }
}