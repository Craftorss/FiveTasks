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
    public static List<Contact> getContacts(String accountId){
        if(String.isBlank(accountId))
            return null;
        List<Contact> contacts =    [SELECT FirstName, LastName, Phone, Email 
                                    FROM Contact
                                    WHERE AccountId = :accountId
                                    ];
        return contacts;
    }

    @AuraEnabled
    public static void saveAccountAndContacts(string accountJson, string contactsJson){
        System.debug(accountJson);
        System.debug(contactsJson);

        Account acc = JSON.deserialize(accountJSON, Account);

        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
