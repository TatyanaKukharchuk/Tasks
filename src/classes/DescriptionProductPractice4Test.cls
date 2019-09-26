@IsTest
private class DescriptionProductPractice4Test {
    @testSetup static void createDate(){

        Product_Table__c productTable1 = new Product_Table__c (
                Name = 'productTableTest1',
                Product_Description__c = 'forTest1',
                Units_Available__c = 10,
                Unit_Price__c = 100,
                Image_Url__c  = 'https://my-domaintk1-dev-ed--c.visualforce.com/resource/1567421978000/ProductTableIphone?'

        );
        insert productTable1;
        Product_Table__c productTable2 = new Product_Table__c (
                Name = 'productTableTest2',
                Product_Description__c = 'forTest1',
                Units_Available__c = 12,
                Unit_Price__c = 100,
                Image_Url__c  = 'https://my-domaintk1-dev-ed--c.visualforce.com/resource/1567421978000/ProductTableIphone?'
        );
        insert productTable2;
    }
     @ISTest static void rightSelect() {

        List<Product_Table__c> products = [SELECT id FROM Product_Table__c];
        Integer size = products.size();
        Test.startTest();
        DescriptionProductPractice4Controller testDescriptionProduct = new DescriptionProductPractice4Controller();
        testDescriptionProduct.getValueProductTable();
        Integer sizeProduct = testDescriptionProduct.productTable.size();

        Test.stopTest();
         system.assertEquals(size, sizeProduct);
    }
}