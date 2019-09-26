@IsTest
private class RestServiceForBookingHotelTest {

    @testSetup static void createDate(){

        List<Hotel__c> newListHotel = new List<Hotel__c>();
        List<Room__c> newListRoom = new List<Room__c>();

        Hotel__c testHotel = new Hotel__c (
                Name = 'testHotel',
                IsOpen__c = false

        );
        newListHotel.add(testHotel);

        Room__c  testRoom1 = new Room__c(
                Name = 'testRoom1',
                Hotel__c = testHotel.id
        );
        newListRoom.add(testRoom1);

        Hotel__c testHotel2 = new Hotel__c (
                Name = 'testHotel2',
                IsOpen__c = true

        );
        newListHotel.add(testHotel2);

        Room__c  testRoom2 = new Room__c(
                Name = 'testRoom2',
                Hotel__c = testHotel2.id
        );
        newListRoom.add(testRoom2);


        Hotel__c testHotel3 = new Hotel__c (
                Name = 'testHotel3',
                IsOpen__c = true

        );
        newListHotel.add(testHotel3);


        Room__c  testRoom3 = new Room__c(
                Name = 'testRoom3',
                Hotel__c = testHotel3.id
        );
        newListRoom.add(testRoom3);

        Hotel__c testHotel4 = new Hotel__c (
                Name = 'testHotel4',
                IsOpen__c = true

        );
        newListHotel.add(testHotel4);
        insert  newListHotel;

        Room__c  testRoom4 = new Room__c(
                Name = 'testRoom4',
                Hotel__c = testHotel4.id
        );
        newListRoom.add(testRoom4);

        Room__c  testRoom5 = new Room__c(
                Name = 'testRoom5',
                Hotel__c = testHotel4.id
        );
        newListRoom.add(testRoom5);

        insert newListRoom;

        BookRoom__c testBookRoom = new BookRoom__c(
                Rooms__c = newListRoom[3].id,
                Date__c = Date.valueof('2018-05-05')

        );


        insert testBookRoom;


    }
    @IsTest
    static void testIfHotelAndRoomDontExistMethodPost(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('[{"nameHotel": "TestHotel123", ' +
                '"Rooms": [{"Name" : "TestHotelRoom"}]}]}');
        RestContext.request = request;
        RestServiceForBookingHotel.upsertHotelAndRoom();
        List<Hotel__c> newHotel = [SELECT id FROM Hotel__c WHERE Name = 'TestHotel123'];
        List<Room__c> newRoom = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'TestHotelRoom'];
        system.assertEquals(newHotel[0].id, newRoom[0].Hotel__c);

    }
    @IsTest
    static void testIfHotelAndRoomExistMethodPost(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('[{"nameHotel": "testHotel", ' +
                '"Rooms": [{"Name" : "testRoom1"}]}]}');
        RestContext.request = request;
        RestServiceForBookingHotel.upsertHotelAndRoom();
        List<Hotel__c> newHotel = [SELECT id FROM Hotel__c WHERE Name = 'testHotel'];
        List<Room__c> newRoom = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom1'];

        system.assertEquals(newHotel[0].id, newRoom[0].Hotel__c);

    }
    @IsTest
    static void testIfHotelExistAndRoomDontExistMethodPost(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('[{"nameHotel": "testHotel", ' +
                '"Rooms": [{"Name" : "testRoom5"}]}]}');
        RestContext.request = request;
        RestServiceForBookingHotel.upsertHotelAndRoom();
        List<Hotel__c> newHotel = [SELECT id FROM Hotel__c WHERE Name = 'testHotel'];
        List<Room__c> newRoom = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom5'];

        system.assertEquals(newHotel[0].id, newRoom[0].Hotel__c);

    }
    @IsTest
    static void testIfHotelDontExistAndRoomExistMethodPost(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('[{"nameHotel": "testHotel22", ' +
                '"Rooms": [{"Name" : "testRoom1"}]}]}');
        RestContext.request = request;
        RestServiceForBookingHotel.upsertHotelAndRoom();
        List<Hotel__c> newHotel = [SELECT id FROM Hotel__c WHERE Name = 'testHotel22'];
        List<Room__c> newRoom = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom1'];

        system.assertEquals(newHotel[0].id, newRoom[0].Hotel__c );

    }
    @IsTest
    static void testDiffrentCasesMethodPost(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('[{"nameHotel": "testHotel", ' +
                '"Rooms": [{"Name" : "testRoom3"}, {"Name" : "testRoom6"} ]},{"nameHotel": "testHotel2", ' +
                '"Rooms": [{"Name" : "testRoom2"}]},{"nameHotel": "testHotel5", ' +
                '"Rooms": [{"Name" : "testRoom7"}]},{"nameHotel": "testHotel3", ' +
                '"Rooms": [{"Name" : "testRoom1"}]}]');
        RestContext.request = request;
        RestServiceForBookingHotel.upsertHotelAndRoom();
        Hotel__c testHotel = [SELECT id FROM Hotel__c WHERE Name = 'testHotel'];
        Hotel__c testHotel2 = [SELECT id FROM Hotel__c WHERE Name = 'testHotel2'];
        Hotel__c testHotel5 = [SELECT id FROM Hotel__c WHERE Name = 'testHotel5'];
        Hotel__c testHotel3 = [SELECT id FROM Hotel__c WHERE Name = 'testHotel3'];
        Room__c testRoom3 = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom3'];
        Room__c testRoom6 = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom6'];
        Room__c testRoom2 = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom2'];
        Room__c testRoom7 = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom7'];
        Room__c testRoom1 = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom1'];

        system.assertEquals(testHotel.id, testRoom3.Hotel__c);
        system.assertEquals(testHotel.id, testRoom6.Hotel__c);
        system.assertEquals(testHotel2.id, testRoom2.Hotel__c);
        system.assertEquals(testHotel5.id, testRoom7.Hotel__c);
        system.assertEquals(testHotel3.id, testRoom1.Hotel__c);

    }
    @IsTest
    static void testIfHotelDontExistMethodPut(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"nameHotel" : "HotelMethodPut",' +
                ' "nameRoom" : "testRoom2", "bookDate" : "2019-09-17"  }');
        RestContext.request = request;
        RestServiceForBookingHotel.bookRoom();

        Room__c newRoom = [SELECT id, Hotel__c FROM Room__c WHERE Name = 'testRoom2'];
        List<BookRoom__c> newBook = [Select Date__c, Rooms__c From BookRoom__c WHERE Date__c = 2019-09-17
        And Rooms__c = :newRoom.id];

        system.assertEquals(0, newBook.size());

    }
    @IsTest
    static void testIfHotelExistButIsOpenFalseMethodPut(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"nameHotel" : "testHotel",' +
                ' "nameRoom" : "testRoom2", "bookDate" : "2019-09-16"  }');
        RestContext.request = request;
        RestServiceForBookingHotel.bookRoom();

        RestServiceForBookingHotel.bookRoom();
        String response =  RestServiceForBookingHotel.bookRoom();

        system.assertEquals('Hotel testHotel close', response);

    }
    @IsTest
    static void testRoomAlreadyBookedMethodPut(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"nameHotel" : "testHotel4",' +
                ' "nameRoom" : "testRoom4", "bookDate" : "2018-05-05"  }');
        RestContext.request = request;
        RestServiceForBookingHotel.bookRoom();

        RestServiceForBookingHotel.bookRoom();
        String response =  RestServiceForBookingHotel.bookRoom();

        system.assertEquals('testRoom4 has already booked on 2018-05-05 00:00:00', response);

    }
    @IsTest
    static void testRoomDontExistInHotelMethodPut(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"nameHotel" : "testHotel4",' +
                ' "nameRoom" : "testRoom112", "bookDate" : "2019-09-18"  }');
        RestContext.request = request;
        RestServiceForBookingHotel.bookRoom();

        RestServiceForBookingHotel.bookRoom();
        String response =  RestServiceForBookingHotel.bookRoom();

        system.assertEquals('Room testRoom112 dont exist in testHotel4', response);

    }
    @IsTest
    static void tesBookRoomMethodPut(){

        RestRequest request = new RestRequest();
        request.requestURI = 'https://ap15.salesforce.com/'+
                'services/apexrest/Hotel/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"nameHotel" : "testHotel4",' +
                ' "nameRoom" : "testRoom4", "bookDate" : "2019-07-01"  }');
        RestContext.request = request;
        RestServiceForBookingHotel.bookRoom();
        String response =  RestServiceForBookingHotel.bookRoom(); 

        system.assertEquals('Conglaturation', response);


    }


}