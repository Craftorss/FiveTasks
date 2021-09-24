public class AccountTriggerHandler {
    @future(callout = true)
    public static void setCoordinates(Set<Id> AccountIds){
        List<Account> accs = [SELECT BillingStreet, BillingCity, BillingState, BillingPostalCode, 
                            BillingCountry, Billing_Location__Latitude__s, Billing_Location__Longitude__s 
                            FROM Account 
                            WHERE Id IN :AccountIds
                            ];
        for(Account acc : accs){
            String addr = '';
            if(acc.BillingStreet != null)  
                addr += acc.BillingStreet + ',';
            if(acc.BillingCity != null)
                addr += acc.BillingCity + ',';
            if(acc.BillingState != null)
                addr += acc.BillingState + ',';
            if(acc.BillingPostalcode != null)
                addr += acc.BillingPostalcode + ',';
            if(acc.BillingCountry != null)
                addr +=acc.BillingCountry;

            addr = EncodingUtil.urlEncode(addr, 'UTF-8');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+ addr +
                                '&key=AIzaSyBNeL5MdzZIzgqTo8DtWXvkIlzHJE-XIXs');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                System.debug('Stepped: '+ response.getStatus());
                JSONParser parser = JSON.createParser(response.getBody());
                Double lat, lng;
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')){
                        parser.nextToken();
                        while (parser.nextToken() != JSONToken.END_OBJECT){
                            String s = parser.getText();
                            parser.nextToken();
                            if (s == 'lat')
                                lat = parser.getDoubleValue();
                            else 
                                if (s == 'lng')
                                    lng = parser.getDoubleValue();    
                        }
                    } 
                }
                if(lat != null && lng != null){
                    acc.Billing_Location__Latitude__s = lat;
                    acc.Billing_Location__Longitude__s = lng;                   
                }
                else{
                    acc.Billing_Location__Latitude__s = null;
                    acc.Billing_Location__Longitude__s = null;
                    System.debug(response.getBody());
                }
            }
            else {
                acc.Billing_Location__Latitude__s = null;
                acc.Billing_Location__Longitude__s = null;
                System.debug(response.getStatus());
            }
        }
        List<Database.SaveResult> saveRes = Database.update(accs, false);
        for(Database.SaveResult sr : saveRes){
            if(sr.success){
                System.debug('Succesfully changed lat/long');
            }
            else 
                System.debug('Changing lat/long failed: ' + sr.errors[0]);
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> db4beea7d2b5e56fcc2d2aa02394e144b696d5cd
