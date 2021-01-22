public with sharing class CreateChildAccountBatchService {
    public static Set<Id> getParentIds(List<Account> childrenWithMain) {
        Set<Id> result = new Set<Id>();
        for (Account child : childrenWithMain) {
            result.add(child.ParentId);
        }
        return result;
    }
}