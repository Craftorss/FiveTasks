global class Task2Schd implements Schedulable{   
    global void execute(SchedulableContext context){
        Task2Btch task = new Task2Btch();
        Database.executeBatch(task, 2);
        //System.abortJob(context.getTriggerId());
        //start();
    }

    //public static void start(){
        //String jobName = 'Test Scheduled Job';
        //String cronExpr = '0 ' + System.now().addMinutes(30).minute() + ' * * * ?';
        //Task2Schd task = new Task2Schd();
        //System.schedule(jobName, cronExpr, task);
    //}
}