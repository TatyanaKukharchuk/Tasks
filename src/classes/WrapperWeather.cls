public class WrapperWeather {
     public String dateT{get; set;}
     public Double temp{get; set;}
     public Double pressure{get; set;}
     public List<WrapperWeather> wrapperWeather{get; set;} 
     public WrapperWeather(String dateT, Double temp,Double pressure)
     {
         this.dateT = dateT;
         this.temp =  temp;
         this.pressure = pressure;
     }

}