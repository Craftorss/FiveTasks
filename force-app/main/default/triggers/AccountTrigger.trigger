trigger AccountTrigger on Account (after insert, after update) {
    Set<Id> accsToHandler = new Set<Id>();
    if(Trigger.isUpdate){
        for(Account newAc : Trigger.new){
            Account beforeAc = Trigger.oldMap.get(newAc.Id);
            if(newAc.BillingState != beforeAc.BillingState || 
            newAc.BillingStreet != beforeAc.BillingStreet ||
            newAc.BillingCountry != beforeAc.BillingCountry ||
            newAc.BillingPostalCode != beforeAc.BillingPostalCode ||
            newAc.BillingCity != beforeAc.BillingCity
            ){
                accsToHandler.add(newAc.Id);
            }
        }
    }
    else {
        for (Account acc : [SELECT BillingAddress FROM Account WHERE Id IN :Trigger.new]) {
            if(!(BillingAddressHelper.isEmpty(acc.BillingAddress))){
                accsToHandler.add(acc.Id);
            }
        }
    }
        
    if (accsToHandler.size() > 0)
        AccountTriggerHandler.setCoordinates(accsToHandler);
}