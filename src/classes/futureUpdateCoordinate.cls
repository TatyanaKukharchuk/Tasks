public class futureUpdateCoordinate  
{ 
    @future(callout=true)
    static public void newContact(set<id> l){
    List<Contact> contacts = [SELECT id, MailingCity,MailingCountry,MailingPostalCode,
                              MailingState,MailingStreet FROM Contact WHERE id =: l];
    List<Contact> newListContact = new List<Contact>();
        for(Contact c : contacts){
        String address = '';
        if (c.MailingStreet != null)
        address += c.MailingStreet +',';
        if (c.MailingCity != null)
        address += c.MailingCity +',';
        if (c.MailingState != null)
        address += c.MailingState +'';
        if (c.MailingPostalCode != null)
        address += c.MailingPostalCode +',';
        if (c.MailingCountry != null)
        address += c.MailingCountry;
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        List<Location__mdt> LocationApiList = [Select apiKey__c, url__c From Location__mdt LIMIT 1];
        String apiKey = LocationApiList[0].apiKey__c;
        String url = LocationApiList[0].url__c;
        String requestEndpoint = url + address + apiKey;
        req.setMethod('GET');
        req.setTimeout(5000);
            try{
            HttpResponse res = h.send(req);
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
        while (parser.nextToken() != null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'location')){
        parser.nextToken(); // object start
            while (parser.nextToken() != JSONToken.END_OBJECT){
                String txt = parser.getText();
                parser.nextToken();
                if (txt == 'lat'){
                lat = parser.getDoubleValue();
                }else if (txt == 'lng'){
                lon = parser.getDoubleValue();
                }     
            }
    }
       
}
        if (lat != null){
        system.debug(lat+' '+lon);
        c.GeoLacation__Latitude__s = lat;
        system.debug(c.GeoLacation__Latitude__s+'c.GeoLacation__Latitude__s');
        c.GeoLacation__Longitude__s = lon;
        system.debug(c.GeoLacation__Longitude__s +'c.GeoLacation__Longitude__s');
        newListContact.add(c);
      }
}
          catch (Exception e) {
            system.debug(e);
      }
  }
        update newListContact;
 }
    
}