trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountService.createChildAccount(AccountService.getMainAccounts((List<Account>) Trigger.new));
    }
}