//reworked Task 2
global class ProcessOpportunitySchd implements Schedulable {
    global void execute(SchedulableContext context){
        ProcessOpportunityBatch task = new ProcessOpportunityBatch();
        Database.executeBatch(task, 2);
    }
}
