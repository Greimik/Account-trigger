@IsTest
private with sharing class CreateChildAccountBatchTest {
    public static final String MAIN_ACCOUNT_RECORD_TYPE = AccountService.getRecordTypeId('Main');
    public static final String CHILD_ACCOUNT_RECORD_TYPE = AccountService.getRecordTypeId('Child');
    public static final String TEST_NAME = 'Test';

    @TestSetup
    static void setupTestData() {
        new AccountBuilder()
                .withRecordTypeId(MAIN_ACCOUNT_RECORD_TYPE)
                .withName(TEST_NAME)
                .buildAndSave();
        Account childAccount = new AccountBuilder()
                .withRecordTypeId(CHILD_ACCOUNT_RECORD_TYPE)
                .withName(TEST_NAME + TEST_NAME)
                .buildAndSave();
        new AccountBuilder(childAccount)
                .withRecordTypeId(MAIN_ACCOUNT_RECORD_TYPE)
                .buildAndSave();
    }
    @IsTest
    static void shouldCreateChildAccount() {
        Test.startTest();
        Database.executeBatch(new CreateChildAccountBatch());
        Test.stopTest();

        List<Account> mainAccounts = [SELECT Id, RecordTypeId, Name, (SELECT Id, RecordTypeId FROM ChildAccounts) FROM Account WHERE RecordTypeId = :MAIN_ACCOUNT_RECORD_TYPE];
        for (Account mainAccount : mainAccounts) {
            System.assertEquals(MAIN_ACCOUNT_RECORD_TYPE, mainAccount.RecordTypeId);
            System.assert(!mainAccount.ChildAccounts.isEmpty());
            System.assertEquals(1,mainAccount.ChildAccounts.size());
            for (Account child : mainAccount.ChildAccounts){
                System.assertEquals(CHILD_ACCOUNT_RECORD_TYPE, child.RecordTypeId);
            }
        }

    }
}