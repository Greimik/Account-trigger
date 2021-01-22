public with sharing class AccountBuilder {
    Account record;

    public AccountBuilder() {
        this.record = new Account();
    }

    public AccountBuilder(Account record) {
        this.record = record;
    }

    public AccountBuilder withName(String name) {
        this.record.Name = name;
        return this;
    }

    public AccountBuilder withRecordTypeId(String recordTypeId) {
        this.record.RecordTypeId = recordTypeId;
        return this;
    }

    public AccountBuilder withParent(Account parent) {
        this.record.ParentId = parent.Id;
        return this;
    }

    public Account build() {
        return this.record;
    }

    public Account buildAndSave() {
        upsert this.record;
        return this.record;
    }
}