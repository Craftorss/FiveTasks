public with sharing class UpdateCompanyInformationCtrl {
    @AuraEnabled
    public static Account getOppAccount(String oppId){
        Opportunity opp =    [SELECT Account.Name, Account.BillingStreet, Account.BillingPostalCode, Account.BillingState, 
                                    Account.BillingCountry 
                            FROM Opportunity 
                            WHERE Id = :oppId 
                            LIMIT 1
                            ];
        System.debug('got here' + opp);
        return opp.Account;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String oppId){
        Opportunity opp =   [SELECT AccountId 
                            FROM Opportunity 
                            WHERE Id = :oppId 
                            LIMIT 1
                            ];
        if(opp == null)
            return null;
        if(opp.AccountId == null)
            return null;
        List<Contact> contacts =    [SELECT FirstName, LastName, Phone, Email 
                                    FROM Contact
                                    WHERE AccountId = :opp.AccountId
                                    ];
        return contacts;
    }
}
