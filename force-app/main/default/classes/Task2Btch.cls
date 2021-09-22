public class Task2Btch implements Database.Batchable<SObject>  {
    public Database.QueryLocator Start(Database.BatchableContext context){
        return Database.getQueryLocator(
            'SELECT Id' + 
            'FROM Opportunity'+
            'WHERE Send_Test_Email__c = TRUE'
        );
    }
    public void Execute(Database.BatchableContext context, List<Opportunity> opps){
        
    }
    public void Finish(Database.BatchableContext context){

    }
}