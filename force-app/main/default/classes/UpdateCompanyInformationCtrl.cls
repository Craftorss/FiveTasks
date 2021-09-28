public with sharing class UpdateCompanyInformationCtrl {
    @AuraEnabled
    public static Account getAccount(String accountId){
        System.debug('Entered getAccount with id = ' + accountId);
        Account account =   [SELECT Name, BillingStreet, BillingPostalCode, BillingState, 
                                    BillingCountry 
                            FROM Account 
                            WHERE Id = :accountId 
                            LIMIT 1
                            ];
        System.debug('got here' + account);
        return account;
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
