global class CaseSchedulerCron implements Schedulable {
    global void execute(SchedulableContext sc) {
        CaseScheduler b = new CaseScheduler();
        database.executebatch(b,200);
    }
}