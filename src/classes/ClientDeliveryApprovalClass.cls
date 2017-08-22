Global class ClientDeliveryApprovalClass implements Messaging.InboundEmailHandler{	

	public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
	    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

	    String body = email.plainTextBody == null? (email.htmlBody == null? '': email.htmlBody.stripHtmlTags()): email.plainTextBody;
	    
	    system.debug('BODY IS ' + body);

	    boolean approved = false;

	    Pattern p = Pattern.compile('(\\p{Alnum}{15}\\p{Alnum}{3}?)');
	    Matcher m = p.matcher(body);

	    Pattern p1 = Pattern.compile('(approved|Approved)(?=(?:[^"]*"[^"]*")*[^"]*$)');
	    Matcher m1 = p1.matcher(body);

	    while(m.find()) {
	        try {
	            id recordID = (id)m.group(0);
	            system.debug('RECORD ID IS ' + recordID);

	            Set<id> objIDs = new Set<ID>{recordID};

	            string objName = Utils_Implementation.findObjectNameFromRecordIdPrefix(recordID);

	            string query = 'select id, Approval_Status__c from ' + objName + ' where ID IN : objIDs';
	           
	           	sObject[] apps = Database.query(query);
	            
	            system.debug('object is ' + apps);

	            if(!apps.isEmpty()){

	            	while(m1.find()){
	            		system.debug('WE FIND AN APPROVAL');
	            		approved = true;
	            		apps[0].put('Approval_Status__c', 'Approved');
	            	}

		            if(!approved){
		            	apps[0].put('Approval_Status__c', 'Rejected');
		            }

		            system.debug('approved is ' + approved);
		            
		            update apps;
	            }
	            else{
	        		result.success = false;
	            	return result;
	            }
	        } 
	        catch(Exception e) {
	        	result.success = false;
	            return result;
	        }
	    }
	    result.success = true;
	    return result;
	}
}