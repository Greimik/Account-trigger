public with sharing class AccountService {
    public static final String MAIN_ACCOUNT_RECORD_TYPE = getRecordTypeId('Main');
    public static final String CHILD_ACCOUNT_RECORD_TYPE = getRecordTypeId('Child');

    public static void createChildAccount(List<Account> mainAccounts) {
        List<Account> childAccounts = new List<Account>();
        for (Account mainAccount : mainAccounts) {
            childAccounts.add(
                    new AccountBuilder()
                            .withRecordTypeId(CHILD_ACCOUNT_RECORD_TYPE)
                            .withName(mainAccount.Name)
                            .withParent(mainAccount)
                            .build()
            );
        }

        Database.insert(childAccounts, false);

    }

    public static List<Account> getMainAccounts(List<Account> newAccounts) {
        List<Account> mainAccount = new List<Account>();
        for (Account account : newAccounts) {
            if (account.RecordTypeId == MAIN_ACCOUNT_RECORD_TYPE) {
                mainAccount.add(account);
            }
        }
        return mainAccount;
    }

    public static Id getRecordTypeId(String developerName) {
        return Account.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get(developerName).recordTypeId;
    }
}