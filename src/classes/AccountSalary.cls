public class AccountSalary{
     public static Double getExchangeRate (String currency1) {
        List<Currency__mdt> key = [SELECT apiKey__c FROM Currency__mdt];
        ExchangeCurrencyWSDL.XigniteGlobalCurrenciesSoap exchangeRate = new ExchangeCurrencyWSDL.XigniteGlobalCurrenciesSoap();
        ExchangeCurrencyWSDL.Header header = new ExchangeCurrencyWSDL.Header();
        header.Username = key[0].apiKey__c;
        exchangeRate.Header = header;
        ExchangeCurrencyWSDL.Rate exchange = exchangeRate.GetRealTimeRate(currency1);
        return exchange.Mid;
    }
     public void updateAccountSalary(List<Account> accountIdList){
        
       List<Account> accountWithContact = [SELECT salary__c, currency__c, 
                                           (SELECT id, Name,  salary__c, currency__c 
                                            FROM Contacts) From Account WHERE id in :accountIdList]; 
          Double sum = 0;
        for(Account a :accountWithContact){
           
            for(Contact c: a.Contacts){
                if(a.currency__c != c.currency__c){
                    String currency1 = c.Currency__c + a.Currency__c;
                    sum += (c.Salary__c * getExchangeRate(currency1)); 
                }
                sum += c.salary__c;
            }
            a.Salary__c = sum;  
        }
       
        update accountWithContact;
    }
    
  
    
            

}