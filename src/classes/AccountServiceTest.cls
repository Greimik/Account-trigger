@IsTest
private with sharing class AccountServiceTest {
    private static final String TEST_NAME = 'Test';
    private static final String MAIN_RECORD_TYPE_NAME = 'Main';

    @IsTest
    static void shouldCreateChildAccount() {
        Test.startTest();
        Account mainAccount = new AccountBuilder()
                .withName(TEST_NAME)
                .withRecordTypeId(AccountService.MAIN_ACCOUNT_RECORD_TYPE)
                .buildAndSave();
        Test.stopTest();

        List<Account> childAccounts = [SELECT Id, ParentId, RecordTypeId FROM Account WHERE ParentId = :mainAccount.Id];
        System.assertEquals(1,childAccounts.size());
        System.assertEquals(mainAccount.Id, childAccounts.get(0).ParentId);
        System.assertEquals(AccountService.CHILD_ACCOUNT_RECORD_TYPE, childAccounts.get(0).RecordTypeId);
    }

    @IsTest
    static void shouldNotCreateChildAccount() {
        Test.startTest();
        Account mainAccount = new AccountBuilder()
                .withName(TEST_NAME)
                .withRecordTypeId(AccountService.CHILD_ACCOUNT_RECORD_TYPE)
                .buildAndSave();
        Test.stopTest();

        List<Account> childAccounts = [SELECT Id FROM Account WHERE ParentId = :mainAccount.Id];
        System.assertEquals(0,childAccounts.size());
        System.assertNotEquals(1,childAccounts.size());
        try{
            childAccounts.get(0);
        }catch(ListException listException){
            System.assertEquals('List index out of bounds: 0', listException.getMessage());
        }
    }

    @IsTest
    static void shouldReturnMainAccounts() {
        Account mainAccount = new AccountBuilder()
                .withName(TEST_NAME)
                .withRecordTypeId(AccountService.MAIN_ACCOUNT_RECORD_TYPE)
                .build();
        Account childAccount = new AccountBuilder()
                .withName(TEST_NAME)
                .withRecordTypeId(AccountService.CHILD_ACCOUNT_RECORD_TYPE)
                .build();

        Test.startTest();
        List<Account> results = AccountService.getMainAccounts(new List<Account>{childAccount,mainAccount});
        Test.stopTest();

        System.assert(!results.isEmpty());
        System.assertEquals(1,results.size());
        System.assertEquals(AccountService.MAIN_ACCOUNT_RECORD_TYPE,results.get(0).RecordTypeId);
    }

    @IsTest
    static void shouldReturnEmptyListWhenSearchingMainAccounts() {
        Account mainAccount = new AccountBuilder()
                .withName(TEST_NAME)
                .withRecordTypeId(AccountService.CHILD_ACCOUNT_RECORD_TYPE)
                .build();
        Account childAccount = new AccountBuilder()
                .withName(TEST_NAME)
                .withRecordTypeId(AccountService.CHILD_ACCOUNT_RECORD_TYPE)
                .build();

        Test.startTest();
        List<Account> results = AccountService.getMainAccounts(new List<Account>{childAccount,mainAccount});
        Test.stopTest();

        System.assert(results.isEmpty());
        try{
            results.get(0);
        }catch(ListException listException){
            System.assertEquals('List index out of bounds: 0', listException.getMessage());
        }
    }

    @IsTest
    static void shouldReturnMainRecordTypeId() {
        Id mainRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = :MAIN_RECORD_TYPE_NAME].Id;

        Test.startTest();
        Id result = AccountService.getRecordTypeId(MAIN_RECORD_TYPE_NAME);
        Test.stopTest();

        System.assertEquals(mainRecordTypeId,result);
    }
}
