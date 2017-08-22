global class OpportunitySchedulerCron implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunityScheduler b = new OpportunityScheduler();
        database.executebatch(b,200);
    }
}