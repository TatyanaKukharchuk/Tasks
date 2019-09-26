@RestResource(urlMapping= '/lecture20/*' )
global with sharing class RestService {
    global class WrapperClass {
     public List<Id> accountsId{get;set;}
     public List<Id> contactsId{get;set;}

}
    @HttpPost
    global static WrapperClass createRecords(){
        List<Id> accountId = new List<Id>();
        List<Id> contactId = new List<Id>();
        List<Account> accountWithName = new List<Account>();
        List<Contact> contactWithName = new List<Contact>();
        RestRequest req = RestContext.request;   
        Map<String, Object> parametrs = (Map<String, Object>)JSON.deserializeUntyped(req.requestbody.tostring());
        List<Object> accountWithParam =(List<Object>)parametrs.get('account');
        List<Object> contactWithParam =(List<Object>)parametrs.get('contact');
        for(Object a :accountWithParam){
            Map<String, Object> newAccountMap = (Map<String, Object>)a;
            Account accounts = new Account();
            for(String acc :newAccountMap.keySet())
            {
                accounts.put(acc, newAccountMap.get(acc));
            }
            accountWithName.add(accounts);
        }
        insert accountWithName;
        for(Object c : contactWithParam){
            Map<String, Object> newContactMap = (Map<String, Object>)c;
            Contact contacts = new Contact();
            for(String con :newContactMap.keySet())
            {
                contacts.put(con, newContactMap.get(con));
            }
            contactWithName.add(contacts);
        }
        insert contactWithName;
         for(Account a :accountWithName){
            accountId.add(a.id);
        }
        for(Contact c :contactWithName){
            contactId.add(c.id);
        }
        WrapperClass wc = new WrapperClass();
        wc.accountsId = accountId;
        wc.contactsId = contactId;
        return wc;
    }
       @HttpGet
    global static WrapperClass getRecords(){
        List<Id> accountId = new List<Id>();
        List<Id> contactId = new List<Id>();
        RestRequest req = RestContext.request;
        Date createdDate = Date.valueOf(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        system.debug('createdDate----------->' + createdDate);
        List<Account> accounts = [SELECT id FROM Account WHERE DAY_ONLY(CreatedDate) = :createdDate];
        List<Contact> contacts = [SELECT id FROM Contact WHERE DAY_ONLY(CreatedDate) = :createdDate];
        system.debug('account----------->' + accounts);
        system.debug('contact----------->' + contacts);
        for(Account a :accounts){
            accountId.add(a.id);
        }
        for(Contact c :contacts){
            contactId.add(c.id);
        }
        WrapperClass wc = new WrapperClass();
        wc.accountsId = accountId;
        wc.contactsId = contactId;
        return wc;
	} 

}