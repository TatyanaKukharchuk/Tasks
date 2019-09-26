public with sharing class DescriptionDetailController {
    public Product_Table__c detailProductTable { get; set; }
    public String email {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public List<Contact> contacts {get;set;}
    public List<Contact> contactForUpsert {get;set;}
    public Integer unitCount{get;set;}
    public Double totalAmount{get;set;}
    public String strId{get;set;}
    public Order_Table__c newOrder{get;set;}

    public DescriptionDetailController() {
       strId = ApexPages.currentPage().getParameters().get('id');
        if(strId != NULL){
            detailProductTable = [SELECT id, Image_Url__c, Product_Description__c, Name, Units_Available__c, Unit_Price__c
            FROM Product_Table__c WHERE id =:strId];
        }

    }

    public PageReference goToBuyPage(){
        ID id = System.currentPageReference().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/BuyProductPage?id='+id);
        return pageRef;
    }

    public PageReference goToShoppingPage(){
        PageReference pageRef = new PageReference('/apex/DescriptionProductPractice4');
        return pageRef;
    }

    public void changeTotalAmount(){
        totalAmount = unitCount * detailProductTable.Unit_Price__c;

    }

    public void searchContact(){
        Savepoint savepointContact;
//        List<Contact> contactForUpdate = new List<Contact>();
        contactForUpsert = new List<Contact>();
        List<Contact> contacts = [SELECT id, LastName, FirstName, Email FROM Contact WHERE Email =:email];

        if(!contacts.isEmpty()){

            contacts[0].FirstName = firstName;
            contacts[0].LastName = lastName;
            contactForUpsert.add(contacts[0]);
            system.debug(contactForUpsert);
        }

        else{

            Contact newContact = new Contact(FirstName = firstName, LastName = lastName, Email = email);
            contactForUpsert.add(newContact);
        }

        savepointContact = Database.setSavepoint();
        if(!contactForUpsert.isEmpty()){

            try {
                upsert contactForUpsert;
                contacts.add(contactForUpsert[0]);
            }catch (Exception d){
                new Apexpages.Message(Apexpages.Severity.ERROR, 'Check data');
            }

        }

        registrationOrder(contacts, savepointContact);

    }

    public void registrationOrder(List<Contact> contacts, Savepoint savepointContact){

            try {
                newOrder = new Order_Table__c(Product__c = detailProductTable.id, Units__c = unitCount,
                        Order_Amount__c = totalAmount, Contact__c = contacts[0].id);
            }catch (Exception de){
                new Apexpages.Message(Apexpages.Severity.ERROR, 'Check data');
            }

        detailProductTable.Units_Available__c = detailProductTable.Units_Available__c - unitCount;

        if(detailProductTable.Units_Available__c > 0) {
            try {
                insert newOrder;
                update detailProductTable;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Order Created'));

            }
            catch (Exception de) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Try again'));

            }
        }
        else{
            Database.rollback(savepointContact);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry! This product is ' +
                    'not available '));
        }

    }

}