global class OpportunityScheduler implements Database.Batchable<SObject> {

    global String opportunityQuery;
    global List<opportunity> opportunityRecords;
    
    global OpportunityScheduler() {
		opportunityQuery = 'select id, ownerID from opportunity where Hot_Prospect__c = true AND isclosed = false';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bContext) {
        return Database.getQueryLocator(opportunityQuery);
    }
    
    global void execute(Database.BatchableContext bContext, List<opportunity> opportunityList) {
        opportunityRecords = opportunityList;
        
        List<ID> users = new List<Id>();
        Set<ID> user_check = new Set<Id>();

        for(opportunity c : opportunityRecords){
        	if(user_check.isEmpty() || !user_check.contains(c.ownerID)){
        		users.add(c.ownerID);
        		user_check.add(c.ownerID);
        	}
        }   

    	Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
     	mail.setTargetObjectIds(users);
     	mail.setTemplateId('00X29000000M7nj');

     	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }

    global void finish(Database.BatchableContext bContext) {
        AsyncApexJob aaJob = [SELECT NumberOfErrors, JobItemsProcessed, JobType, MethodName, CompletedDate, Status, ExtendedStatus, TotalJobItems FROM AsyncApexJob WHERE Id = :bContext.getJobId()];
        Organization org = [SELECT o.Id, o.Name FROM Organization o];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'alex.roth@rallyhealth.com'});
        mail.setSubject('Opportunity Scheduler - ' + aaJob.CompletedDate);
        mail.setPlainTextBody('Org ID: ' + org.Id + ' - Processed ' + aaJob.TotalJobItems + ' batch(es) with ' + aaJob.NumberOfErrors + ' errors.');
        mail.setSenderDisplayName('Rally-Production');
        mail.setReplyTo('noreply@rallyhealth.com');
        Messaging.sendEmail(new Messaging.Email[] { mail });
    }
}