/*
* Tests with mock, without mock request denied
and link to billing... vot tak
*/
//reworked Task 3 

public class AccountTriggerHandler {
    public static void handleAfterUpdate(List<Account> newRecords, Map<Id, Account> oldRecordsMap){
        Set<Id> accountsToProcess = new Set<Id>();
        for (Account newAccount : newRecords){
            Account beforeAccount = oldRecordsMap.get(newAccount.Id);
            if(newAccount.BillingState != beforeAccount.BillingState || 
            newAccount.BillingStreet != beforeAccount.BillingStreet ||
            newAccount.BillingCountry != beforeAccount.BillingCountry ||
            newAccount.BillingPostalCode != beforeAccount.BillingPostalCode ||
            newAccount.BillingCity != beforeAccount.BillingCity
            ){
                accountsToProcess.add(newAccount.Id);
            }
        }
        if (accountsToProcess.size() > 0)
            AccountTriggerHandler.setCoordinates(accountsToProcess);
    }
    public static void handleAfterInsert(List<Account> newRecords){
        Set<Id> accountsToProcess = new Set<Id>();
        for (Account account : [SELECT BillingAddress FROM Account WHERE Id IN :newRecords]) {
            if(!(BillingAddressHelper.isEmpty(account.BillingAddress))){
                accountsToProcess.add(account.Id);
            }
        }
        if (accountsToProcess.size() > 0)
        AccountTriggerHandler.setCoordinates(accountsToProcess);
    }

    @future(callout = true)
    public static void setCoordinates(Set<Id> AccountIds){
        List<Account> accounts = [SELECT BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                            BillingCountry, Billing_Location__Latitude__s, Billing_Location__Longitude__s 
                            FROM Account 
                            WHERE Id IN :AccountIds
                            ];
        for(Account account : accounts){
            String address = '';
            if(account.BillingStreet != null)  
                address += account.BillingStreet + ',';
            if(account.BillingCity != null)
                address += account.BillingCity + ',';
            if(account.BillingState != null)
                address += account.BillingState + ',';
            if(account.BillingPostalCode != null)
                address += account.BillingPostalCode + ',';
            if(account.BillingCountry != null)
                address +=account.BillingCountry;
            //if(address == ',,,,')
                //continue;
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+ address +
                                '&key=AIzaSyBNeL5MdzZIzgqTo8DtWXvkIlzHJE-XIXs');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                try {
                    JSONParser parser = JSON.createParser(response.getBody());
                    Double latitude, longtitude;
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')){
                            parser.nextToken();
                            while (parser.nextToken() != JSONToken.END_OBJECT){
                                String s = parser.getText();
                                parser.nextToken();
                                if (s == 'lat')
                                    latitude = parser.getDoubleValue();
                                else 
                                    if (s == 'lng')
                                        longtitude = parser.getDoubleValue();    
                            }
                        } 
                    }
                    account.Billing_Location__Latitude__s = latitude;
                    account.Billing_Location__Longitude__s = longtitude;                       
                } catch (JSONException ex) {
                    account.Billing_Location__Latitude__s = null;
                    account.Billing_Location__Longitude__s = null;
                    System.debug(ex);
                }

            }
            else {
                account.Billing_Location__Latitude__s = null;
                account.Billing_Location__Longitude__s = null;
                System.debug(response.getStatus());
            }
        }
        List<Database.SaveResult> saveResults = Database.update(accounts, false);
        for(Database.SaveResult saveResult : saveResults){
            if(saveResult.success){
                System.debug('Succesfully changed lat/long');
            }
            else 
                System.debug('Changing lat/long failed: ' + saveResult.errors[0]);
        }
    }
}
