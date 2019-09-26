@IsTest
public class RestServiceTest{
 @IsTest	
    static void testGetRecords(){
        Account account = new Account(Name = 'Test');
        upsert account;
        system.debug(account);
        Contact contact = new Contact(LastName = 'Test1');
        upsert contact;
        Date createdRecords = date.today();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
            'services/apexrest/lecture20/' + createdRecords;
        request.httpMethod = 'Get';
        RestContext.request = request;
        RestService.WrapperClass getRecord = RestService.getRecords();
        List<Id> resultAccountsId = getRecord.accountsId;
        List<Id> resultContactsId = getRecord.contactsId;  
        System.assert(getRecord != null);  
        System.assertEquals(account.Id, resultAccountsId[0]);
        System.assertEquals(contact.Id, resultContactsId[0]);
    }
    @IsTest	
    static void testCreateRecords(){
         Account account = new Account(Name = 'Test');
        upsert account;
        system.debug(account);
        Contact contact = new Contact(LastName = 'Test1');
        upsert contact;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
            'services/apexrest/lecture20/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"account":[{"name": "Test"}],"contact": [{"lastname": "Test1"}]}');
        RestContext.request = request;
        RestService.WrapperClass createRecords = RestService.createRecords();
        List<Id> resultAccountsId = createRecords.accountsId;
        List<Id> resultContactsId = createRecords.contactsId;  
        Account a = [SELECT Name FROM Account WHERE id = :resultAccountsId[0]];
        system.debug(a);
        Contact c = [SELECT LastName FROM Contact WHERE id = :resultContactsId[0]];
        system.debug(c);
       System.assertEquals(a.name, 'Test');
       System.assertEquals(c.LastName, 'Test1');
    }

}