/*
* Tests with mock, without mock request denied
and link to billing... vot tak
*/
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
            if(acc.BillingPostalCode != null)
                addr += acc.BillingPostalCode + ',';
            if(acc.BillingCountry != null)
                addr +=acc.BillingCountry;
            //if(addr == ',,,,')
                //continue;
            addr = EncodingUtil.urlEncode(addr, 'UTF-8');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+ addr +
                                '&key=AIzaSyBNeL5MdzZIzgqTo8DtWXvkIlzHJE-XIXs');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if(response.getStatus() == 'OK'){
                try {
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
                    acc.Billing_Location__Latitude__s = lat;
                    acc.Billing_Location__Longitude__s = lng;                       
                } catch (JSONException ex) {
                    acc.Billing_Location__Latitude__s = null;
                    acc.Billing_Location__Longitude__s = null;
                    System.debug(ex);
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
}
