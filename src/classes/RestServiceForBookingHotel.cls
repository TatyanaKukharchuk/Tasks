@RestResource(urlMapping = '/Hotel/*')

global with sharing class RestServiceForBookingHotel {

    @HttpPost
    global static String upsertHotelAndRoom(){
        RestRequest req = RestContext.request;
        List<WrapperClassForFinalTaskPost> listHotelAndRoom = (List<WrapperClassForFinalTaskPost>)System.JSON.deserialize(req.requestbody.tostring(), List<WrapperClassForFinalTaskPost>.class);


        List<String> nameOfHotels = new List<String>();
        Map<String, Hotel__c> mapHotel = new Map<String, Hotel__c>();
        Map<String, Room__c> mapRoom = new Map<String, Room__c>();
        Map<String, List<String>> hotelRooms = new Map<String, List<String>>();
        List<String> nameFromListHotel = new List<String>();
        List<Hotel__c> newHotels =  new List<Hotel__c>();
        Hotel__c checkHotel;
        Room__c checkRoom;
        List<Room__c> roomsForUpdate = new List<Room__c>();
        List<String> nameOfRooms = new List<String>();
        List<String> roomsNamesForHotel = new List<String>();


        for(WrapperClassForFinalTaskPost wc :listHotelAndRoom){
            roomsNamesForHotel = new List<String>();

            nameOfHotels.add(wc.nameHotel);

            for(Room__c wcR : wc.rooms){
                nameOfRooms.add(wcR.Name);
                roomsNamesForHotel.add(wcR.Name);
            }

            hotelRooms.put(wc.nameHotel, roomsNamesForHotel);


        }

        List<Hotel__c> listHotel = [SELECT id, Name FROM Hotel__c WHERE Name IN :nameOfHotels];

        for(Hotel__c name :listHotel){

          nameFromListHotel.add(name.Name);

        }

        for(String nameHotel :nameOfHotels){

            if(!nameFromListHotel.contains(nameHotel)){

                Hotel__c newHotel = new Hotel__c(Name = nameHotel);
                newHotels.add(newHotel);

            }
        }

        if(!newHotels.isEmpty()){

            insert newHotels;
        }

        for(Hotel__c h :listHotel){

            mapHotel.put(h.Name, h);
        }


        List<Room__c> listRoom = [SELECT id, Name, Hotel__c FROM Room__c WHERE Name IN :nameOfRooms];

        for(Room__c r :listRoom){
            mapRoom.put(r.Name, r);
        }

        for(String hotel :nameOfHotels){
            if (mapHotel.containsKey(hotel)) {
                checkHotel = mapHotel.get(hotel);
                for (String room : hotelRooms.get(hotel)) {

                    if(mapRoom.containsKey(room)){

                        checkRoom = mapRoom.get(room);
                        checkRoom.Hotel__c = checkHotel.id;
                        roomsForUpdate.add(checkRoom);

                    }
                    else{
                        Room__c newRooms = new Room__c(Name = room, Hotel__c = checkHotel.id);
                        roomsForUpdate.add(newRooms);
                    }

                }

            }

            else{

                for (String room : hotelRooms.get(hotel)) {
                    if (mapRoom.containsKey(room)) {
                        checkRoom = mapRoom.get(room);
                            for (Hotel__c h : newHotels) {

                                if(hotel == h.Name) {

                                    checkRoom.Hotel__c = h.id;
                                    roomsForUpdate.add(checkRoom);
                                }

                            }

                    }
                    else {

                        for (Hotel__c h : newHotels) {
                            if(hotel == h.Name){
                            Room__c newRooms = new Room__c(Name = room, Hotel__c = h.id);
                            roomsForUpdate.add(newRooms);

                            }

                        }


                    }
                }

            }

        }

        if(!roomsForUpdate.isEmpty()){

            upsert roomsForUpdate;

        }

        return 'Success';
    }

    @HttpPut
    global static String bookRoom (){

        RestRequest req = RestContext.request;
        WrapperClassForFinalTaskPut nameHotelNameRoomAndBookDate = (WrapperClassForFinalTaskPut)System.JSON.deserialize(req.requestbody.tostring(), WrapperClassForFinalTaskPut.class);
        List<Hotel__c> hotel = new List <Hotel__c>();
        String resualt;
        List<Room__c> room = new List<Room__c>();
        List<BookRoom__c> bookRoom = new List<BookRoom__c>();
        String nameOfHotel = nameHotelNameRoomAndBookDate.nameHotel;
        String nameofRoom = nameHotelNameRoomAndBookDate.nameRoom;
        Date  dateOfBook = nameHotelNameRoomAndBookDate.bookDate;
        hotel = [SELECT Name, IsOpen__c FROM Hotel__c WHERE Name =:nameOfHotel];
        if(!hotel.isEmpty()){
            if(hotel[0].isOpen__c == True) {

                room = [SELECT Name, Hotel__c FROM Room__c WHERE Name = :nameofRoom];

                if ((!room.isEmpty()) && (hotel[0].id == room[0].Hotel__c)) {

                    bookRoom = [SELECT Date__c, Rooms__r.Name FROM BookRoom__c WHERE ((Date__c = :dateOfBook) AND (Rooms__r.Name = :nameofRoom))];


                    if (bookRoom.isEmpty()) {

                        BookRoom__c newBook = new BookRoom__c(Date__c = dateOfBook, Rooms__c = room[0].id);
                        insert newBook;

                        resualt = 'Conglaturation';


                    } else {


                        resualt = nameofRoom + ' has already booked on ' + dateOfBook;
                       
                    }

                } else {

                    resualt = 'Room ' + nameofRoom + ' dont exist in ' + nameOfHotel;
                }
            }
            else{

                resualt = 'Hotel ' + nameOfHotel + ' close';
            }

        }
        else{
            resualt = 'Hotel ' + nameOfHotel + ' dont exist';
        }

        return resualt;




    }

}