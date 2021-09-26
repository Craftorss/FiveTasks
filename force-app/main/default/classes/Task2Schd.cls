global class Task2Schd implements Schedulable{   
    global void execute(SchedulableContext context){
        Task2Btch task = new Task2Btch();
        Database.executeBatch(task, 2);
        //System.abortJob(context.getTriggerId());
        //start();
    }
    /**
     * '0 30 * * * ?' - 30 минут каждого часа. Либо создавать две scheduled job,
     * либо убивать себя в execute и создавать новую, но тестировать такое,
     * да и в целом... 
     */
    //public static void start(){
        //String jobName = 'Test Scheduled Job';
        //String cronExpr = '0 ' + System.now().addMinutes(30).minute() + ' * * * ?';
        //Task2Schd task = new Task2Schd();
        //System.schedule(jobName, cronExpr, task);
    //}
}