@IsTest
private with sharing class AccountBuilderTest {
    private static final String TEST_NAME = 'Test';
    private static final String MAIN_RECORD_TYPE_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Main'].Id;

    @TestSetup
    static void setupTestData(){
        new AccountBuilder()
                .withName(TEST_NAME)
                .buildAndSave();
    }

    @IsTest
    static void shouldBuildAccount(){
        Account parentAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Account result = new AccountBuilder()
                .withName(TEST_NAME+TEST_NAME)
                .withParent(parentAccount)
                .withRecordTypeId(MAIN_RECORD_TYPE_ID)
                .build();
        Test.stopTest();

        System.assertEquals(TEST_NAME+TEST_NAME,result.Name);
        System.assertEquals(parentAccount.Id,result.ParentId);
        System.assertEquals(MAIN_RECORD_TYPE_ID,result.RecordTypeId);
        System.assertEquals(null, result.Id);
    }

    @IsTest
    static void shouldBuildAndSaveAccount(){
        Account parentAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Account result = new AccountBuilder()
                .withName(TEST_NAME+TEST_NAME)
                .withParent(parentAccount)
                .withRecordTypeId(MAIN_RECORD_TYPE_ID)
                .buildAndSave();
        Test.stopTest();

        System.assertEquals(TEST_NAME+TEST_NAME,result.Name);
        System.assertEquals(parentAccount.Id,result.ParentId);
        System.assertEquals(MAIN_RECORD_TYPE_ID,result.RecordTypeId);
        System.assertNotEquals(null, result.Id);
    }

    @IsTest
    static void shouldUpdateAccount(){
        Account parentAccount = [SELECT Id, Name FROM Account LIMIT 1];

        Test.startTest();
        Account result = new AccountBuilder(parentAccount)
                .withName(TEST_NAME+TEST_NAME)
                .withRecordTypeId(MAIN_RECORD_TYPE_ID)
                .buildAndSave();
        Test.stopTest();

        System.assertNotEquals(null, result.Id);
        System.assertNotEquals(TEST_NAME,result.Name);
        System.assertEquals(TEST_NAME+TEST_NAME,result.Name);
        System.assertEquals(parentAccount.Id,result.Id);
        System.assertEquals(MAIN_RECORD_TYPE_ID,result.RecordTypeId);
    }
}