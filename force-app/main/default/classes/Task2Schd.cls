global class Task2Schd implements Schedulable{
    global void Execute(SchedulableContext context){
        Task2Btch task = new Task2Btch();
        Database.executeBatch(task, 2);
    }
}
