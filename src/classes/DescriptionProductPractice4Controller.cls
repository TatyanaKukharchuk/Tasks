public class DescriptionProductPractice4Controller {
    public List<Product_Table__c> productTable { get; set; }
    public DescriptionProductPractice4Controller() {
    }

    public List<Product_Table__c> getValueProductTable(){
        productTable = [SELECT id, Image_Url__c, Product_Description__c, Name, Units_Available__c, Unit_Price__c
        FROM Product_Table__c Limit 100];
        
        system.debug('-----------------------------' + productTable);
        return productTable;
    }

    public PageReference goToDetailPage(){
        ID id = System.currentPageReference().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/DescriptionDetail?id='+id);
        return pageRef;
    }
    public PageReference goToBuyPage(){
        ID id = System.currentPageReference().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/BuyProductPage?id='+id);
        return pageRef;
    }
}