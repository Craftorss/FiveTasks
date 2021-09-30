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
    
        Account account = (Account)JSON.deserialize(accountJSON, Account.class);
        List<Contact> contacts = (List<Contact>) JSON.deserialize(contactsJson, List<Contact>.class);
        System.debug(account);
        System.debug(contacts);
        if(account == null)
            throw new AuraHandledException('No Account Associated with this Opportunity');
        
        Savepoint savePoint = Database.setSavepoint();
        try {
            update account;
            List<Contact> toDeleteContacts = new List<Contact>();
            List<Contact> toUpsertContacts = new List<Contact>();
            Map<Id, Contact> contactsWereMap = new Map<Id, Contact>([SELECT FirstName, LastName, Phone, Email 
                                                                    FROM Contact
                                                                    WHERE AccountId = :account.Id
                                                                    ]);
            if (contacts.isEmpty()) {
                if(!contactsWereMap.isEmpty())
                    toDeleteContacts.addAll(contactsWereMap.values());
            } else {
                for (Contact contact : contacts){
                    contact.AccountId = account.Id;
                    toUpsertContacts.add(contact);
                }
                for (Contact contactOld : contactsWereMap.values()) {
                    Boolean containOld = false;
                    for (Contact contactNew: contacts){
                        if( contactOld.Id == contactNew.Id){
                            containOld = true;
                            break;
                        }
                    }
                    if(!containOld)
                        toDeleteContacts.add(contactOld);
                }
            }
            if(!toDeleteContacts.isEmpty()){ 
                delete toDeleteContacts;
            }
            if(!toUpsertContacts.isEmpty())
                upsert toUpsertContacts;        
        } catch (DmlException ex) {
            Database.rollback(savePoint);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
