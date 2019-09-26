trigger Practice3 on Product_Table__c (before insert) {

    TriggerHandler handle = new TriggerHandler();
    if(trigger.isInsert)
    {
        handle.assignProductTableToWarehouse(Trigger.new);
    }


}