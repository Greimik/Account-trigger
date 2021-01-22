public with sharing class CreateChildAccountBatch implements Database.Batchable<SObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext context) {
        Set<Id> childrenWithMainIds = CreateChildAccountBatchService.getParentIds([
                SELECT ParentId
                FROM Account
                WHERE RecordType.DeveloperName = 'Child' AND ParentId != NULL
        ]);
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE RecordType.DeveloperName = \'Main\' AND Id NOT IN :childrenWithMainIds');
    }

    public void execute(Database.BatchableContext context, List<Object> scope) {
        List<Account> children = new List<Account>();
        for (Account main : (List<Account>) scope){
            children.add(
                    new AccountBuilder()
                            .withRecordTypeId(AccountService.CHILD_ACCOUNT_RECORD_TYPE)
                            .withName(main.Name)
                            .withParent(main)
                            .build()
            );
        }
        Database.insert(children);
    }

    public void finish(Database.BatchableContext context) {
    }

    public void execute(SchedulableContext context) {
        Database.executeBatch(new CreateChildAccountBatch());
    }
}