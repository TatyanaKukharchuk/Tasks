public with sharing class WeatherController{
    public String city {get; set;}
    public List<JSON2Apex.List_Z> listOfData{get; set;}
    public List<WrapperWeather> wrapperWeather{get; set;}
    public WeatherController(){
    }
	public String selectedCity{get; set;}
	public List<Selectoption> getSelectedFieldCity(){
        List<Selectoption> citySelList = new List<Selectoption>();
        citySelList.add(new selectOption('Choose city', 'Choose city'));
        citySelList.add(new selectOption('Minsk', 'Minsk'));
        citySelList.add(new selectOption('Kiev', 'Kiev')); 
        citySelList.add(new selectOption('Warsaw', 'Warsaw'));
        citySelList.add(new selectOption('Moscow', 'Moscow'));
        citySelList.add(new selectOption('Vilnius', 'Vilnius'));
        return citySelList;
    }
    public void saveResponce(){
        List<Weather__mdt> weatherApiList = [Select apiKey__c, url__c From Weather__mdt LIMIT 1];
        if(!weatherApiList.isEmpty()){
        String apiKey = weatherApiList[0].apiKey__c;
        String url = weatherApiList[0].url__c;
        String city = selectedCity;
        String requestEndpoint = url +city + apiKey;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        HttpResponse res = http.send(request);
        if(res.getStatusCode() == 200){
         JSON2Apex json2ApexWeather = JSON2Apex.parse(res.getBody());
            city = json2ApexWeather.city.name;
            listOfData = json2ApexWeather.list_Z;
            wrapperWeather = new List<WrapperWeather>();
            System.debug(listOfData);
            for(Integer i = 0; i < listOfData.size(); i = i + 8)
            {
                Json2Apex.List_Z data1 = listOfData.get(i);
                Datetime tmpDate = Date.valueOf(data1.dt_txt);
                String dateT = tmpDate.format('dd.MM.YYYY');
                Double temp = (Integer)(data1.main.temp -273.15);
                Double pressure = data1.main.pressure;
                wrapperWeather.add(new WrapperWeather(dateT, temp, pressure));
            }
              System.debug( wrapperWeather); 

        }
            if (res.getStatusCode() == 400) {
                ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'400 Bad Request'));
            }
            
    }
 }      
}