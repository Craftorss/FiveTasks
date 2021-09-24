public class BillingAddressHelper {
    public static String toString(System.Address addr){
        String addrStr = '';
        if(addr.street != null)  
            addrStr += addr.street + ',';
        if(addr.city != null)
            addrStr += addr.city + ',';
        if(addr.state != null)
            addrStr += addr.state + ',';
        if(addr.postalCode != null)
            addrStr += addr.postalCode + ',';
        if(addr.country != null)
            addrStr += addr.Country + ',';
        return addrStr;
    }
    public static Boolean isEmpty(System.Address addr){
        if(addr == null)
            return false;
        if(String.isBlank(addr.street) && String.isBlank(addr.city) && 
            String.isBlank(addr.state) && String.isBlank(addr.postalCode) && 
            String.isBlank(addr.country)
        )
            return true;
        else 
            return false;
    }
}
