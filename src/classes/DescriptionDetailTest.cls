@IsTest
private class DescriptionDetailTest {
    @testSetup static void createDate(){
        Product_Table__c productTable1 = new Product_Table__c (
                Name = 'productTableTest1',
                Product_Description__c = 'forTest1',
                Units_Available__c = 10,
                Unit_Price__c = 100,
                Image_Url__c  = 'https://my-domaintk1-dev-ed--c.visualforce.com/resource/1567421978000/ProductTableIphone?'

        );
        insert productTable1;

        Contact newContact = new Contact(
                LastName = 'TestForOrder',
                FirstName = 'TestForOrder1',
                Email = 'tanya@test.ru'

        );
        insert newContact;

        Contact newContact2 = new Contact(
                LastName = 'TestForOrder2',
                FirstName = 'TestForOrder2',
                Email = 'fsfh@fw.ru'

        );
        insert newContact2;
    }
    @ISTest static  void rightTotalAmount() {

        Product_Table__c productT = [SELECT Name, Product_Description__c, Units_Available__c, Unit_Price__c, Image_Url__c
        FROM Product_Table__c];

        DescriptionDetailController testDescriptionDetail = new DescriptionDetailController();
        testDescriptionDetail.detailProductTable = productT;
        testDescriptionDetail.unitCount = 5;

        Test.startTest();
        testDescriptionDetail.changeTotalAmount();

        Double totalAmount = testDescriptionDetail.totalAmount;

        Test.stopTest();
        system.assertEquals(500, totalAmount);
    }
    @ISTest static  void createOrderWithContactEmail() {

        List<Contact> newContacts = [SELECT id, firstName, LastName, Email From Contact];
        Product_Table__c productT = [SELECT Name, Product_Description__c, Units_Available__c, Unit_Price__c, Image_Url__c
        FROM Product_Table__c];



        DescriptionDetailController testDescriptionDetail = new DescriptionDetailController();
        testDescriptionDetail.contacts = newContacts;
        testDescriptionDetail.detailProductTable = productT;
        testDescriptionDetail.unitCount = 5;

        Test.startTest();
        testDescriptionDetail.searchContact();
        testDescriptionDetail.registrationOrder(testDescriptionDetail.contacts);


        Test.stopTest();
        system.assert( testDescriptionDetail.newOrder != null);
    }
    @ISTest static  void createOrderWithoutContactEmail() {

        List<Contact> newContacts = [SELECT id FROM Contact WHERE Email = 'adad@ada.ru'];
        Product_Table__c productT = [SELECT Name, Product_Description__c, Units_Available__c, Unit_Price__c, Image_Url__c
        FROM Product_Table__c];


        DescriptionDetailController testDescriptionDetail = new DescriptionDetailController();
        testDescriptionDetail.contacts = newContacts;
        testDescriptionDetail.detailProductTable = productT;
        testDescriptionDetail.unitCount = 5;
        testDescriptionDetail.firstName = 'testForTest';
        testDescriptionDetail.lastName = 'LastNameForTest';
        testDescriptionDetail.firstName = 'FirstNameForTest';
        testDescriptionDetail.email = 'test@test.test';

        Test.startTest();
        testDescriptionDetail.searchContact();
        testDescriptionDetail.registrationOrder( testDescriptionDetail.contacts);



        Test.stopTest();
        system.assert( testDescriptionDetail.newOrder != null);
    }

}