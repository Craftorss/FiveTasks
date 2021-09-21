public with sharing class AccountEditControllerExtension {
    private final Account acc;
    public AccountEditControllerExtension(ApexPages.StandardController stdController) {
        this.acc = (Account)stdController.getRecord();
    }

}
