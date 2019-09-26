public with sharing class TriggerHandler {

    public void assignProductTableToWarehouse(List<Product_Table__c> newProductTables){

        Date today = system.today();
        List<Warehouse__c> wareHouses = new List<Warehouse__c>();
        List<Warehouse__c> newWareHouses = new List<Warehouse__c>();
        List<Profile> profileId = new List<Profile>();
        List<Org_Configuration__c> chooseSetOwner = new List<Org_Configuration__c>();
        List<id> newListIdForProfileId = new List<Id>();

        profileId = [SELECT id FROM Profile];
        chooseSetOwner = [SELECT SetupOwnerId FROM Org_Configuration__c WHERE SetupOwnerId = :profileId];

         for(Org_Configuration__c c :chooseSetOwner){

            newListIdForProfileId.add(c.SetupOwnerId);
        }

        Org_Configuration__c orgC = Org_Configuration__c.getInstance(newListIdForProfileId[0]);
        Double term = orgC.Period_Term__c;
        Integer termForDate = term.intValue();
        system.debug(termForDate);

        for(Product_Table__c pT :newProductTables){
            if(pt.Added_Date__c == NULL){
                pt.Added_Date__c = today;
            }
        }

        wareHouses = [SELECT id, Period_Start__c, Period_End__c FROM Warehouse__c];
        for(Warehouse__c wH :wareHouses){
            for(Product_Table__c pT :newProductTables){
                if((wh.Period_Start__c <= pT.Added_Date__c) && (wh.Period_End__c >= pT.Added_Date__c)){
                    pT.Warehouse__c = wh.id;
                    break;
                }
                else{
                    Warehouse__c newWareHouse = new Warehouse__c(
                            Name = 'Warehouse' + pT.Added_Date__c +
                                    ' ' + pT.Added_Date__c.addDays(termForDate),
                            Period_Start__c = pT.Added_Date__c,
                            Period_End__c = pT.Added_Date__c.addDays(termForDate));

                    newWareHouses.add(newWareHouse);
                }
            }
        }
        if(!newWareHouses.isEmpty()) {
            insert newWareHouses;

            for (Warehouse__c wH : newWareHouses) {
                for (Product_Table__c pT : newProductTables) {
                    if ((pT.Warehouse__c == NULL) && (pT.Added_Date__c == wH.Period_Start__c) &&
                            (pT.Added_Date__c == wH.Period_End__c.addDays(-termForDate))) {
                        pT.Warehouse__c = wH.id;
                    }
                }

            }
        }



    }





}