public class Task2 {
    public static final String jobName = 'Test Scheduled Job';
    private static final String cronExpr = '0 0/30 0 ? * * *';
    public static void main(){
        Task2Schd task = new Task2Schd();
        System.schedule(jobName, cronExpr, task);
    }
}
