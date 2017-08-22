global class CaseScheduler implements Database.Batchable<SObject> {

    global String caseQuery;
    global List<Case> caseRecords;
    
    global CaseScheduler() {
        if(test.isRunningTest()){
            caseQuery = 'select id, Status, Process_to_fire__c,Last_Time_Based_Email_Sent_Date__c,lastmodifieddate, Last_Status_Change__c from Case where isClosed = false LIMIT 50';
        }
        else{
            caseQuery = 'select id, Status, Process_to_fire__c,Last_Time_Based_Email_Sent_Date__c,lastmodifieddate, Last_Status_Change__c from Case where isClosed = false';
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bContext) {
        return Database.getQueryLocator(caseQuery);
    }
    
    global void execute(Database.BatchableContext bContext, List<Case> caseList) {
        caseRecords = caseList;
        List<Case> caseListUpdate = new List<Case>();
        
        for(Case c : caseRecords){
            
            if(c.Status == Label.CaseScheduler_Tier2AssignedStatus
                && ((c.Last_Status_Change__c < (date.today()-integer.valueOf(label.CaseScheduler_DaysBetweenSends)) && c.Last_Time_Based_Email_Sent_Date__c == null)
                    || (c.Last_Time_Based_Email_Sent_Date__c != null && (c.Last_Time_Based_Email_Sent_Date__c < (date.today()-integer.valueOf(label.CaseScheduler_DaysBetweenSends)))))){
                        c.Process_to_fire__c = label.CaseScheduler_Tier2AssignedProcess;
                        caseListUpdate.add(c);
            } 
            if(c.Status == Label.CaseScheduler_PendingUserStatus
                && c.Last_Status_Change__c < (date.today()-integer.valueOf(label.CaseScheduler_DaysBeforeClose))){
                        c.Process_to_fire__c = label.CaseScheduler_PendingUserProcess;
                        caseListUpdate.add(c);
            } 
        }   

        if(caseListUpdate.size() > 0) { database.update(caseListUpdate,false); }
    }

    global void finish(Database.BatchableContext bContext) {
        AsyncApexJob aaJob = [SELECT NumberOfErrors, JobItemsProcessed, JobType, MethodName, CompletedDate, Status, ExtendedStatus, TotalJobItems FROM AsyncApexJob WHERE Id = :bContext.getJobId()];
        Organization org = [SELECT o.Id, o.Name FROM Organization o];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'alex.roth@rallyhealth.com'});
        mail.setSubject('Case Scheduler - ' + aaJob.CompletedDate);
        mail.setPlainTextBody('Org ID: ' + org.Id + ' - Processed ' + aaJob.TotalJobItems + ' batch(es) with ' + aaJob.NumberOfErrors + ' errors.');
        mail.setSenderDisplayName('Rally-Production');
        mail.setReplyTo('noreply@rallyhealth.com');
        Messaging.sendEmail(new Messaging.Email[] { mail });
    }
}