public class BillingAddressHelper {
    public static Boolean isEmpty(System.Address addr){
        if(addr == null)
            return true;
        if(String.isBlank(addr.street) && String.isBlank(addr.city) && 
            String.isBlank(addr.state) && String.isBlank(addr.postalCode) && 
            String.isBlank(addr.country)
        )
            return true;
        else 
            return false;
    }
}
