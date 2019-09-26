public with sharing class FinalTaskController   {
    @AuraEnabled
    public static List<Hotel__c> allHotels() {
        List<Hotel__c> allHotels = [SELECT id, Name FROM Hotel__c WHERE isOpen__c = true];
        system.debug(allHotels);
        return allHotels;
    }

    @AuraEnabled
    public static List<Room__c> showRoom(String selectedHotel) {
        system.debug(selectedHotel);
        List<Room__c> roomChoosenHotel = [
                SELECT Name
                FROM Room__c
                WHERE Hotel__r.Name = :selectedHotel
        ];
        system.debug(roomChoosenHotel);
        return roomChoosenHotel ;

    }
    @AuraEnabled
    public static List<Boolean> bookRooms(String dateB, List<Room__c> rooms) {


        List<Boolean> cheakListBook = new List<Boolean>();


        List<String> newListIdRoom = new List<String>();
        List<String> listBookRoom = new List<String>();

        for (Room__c r : rooms) {

            newListIdRoom.add(r.Id);

        }
        system.debug(newListIdRoom);

        Date expirationDate = Date.valueOf(dateB);

        system.debug(dateB);


        List<BookRoom__c> dateBook = [
                SELECT id, Date__c, Rooms__r.Name
                FROM BookRoom__c
                WHERE Date__c = :expirationDate
        ];

        system.debug(dateBook);

        for (BookRoom__c b : dateBook) {

            listBookRoom.add(b.Rooms__c);

        }
        for (String r : newListIdRoom) {
            if (listBookRoom.contains(r)) {
                cheakListBook.add(true);
            } else {
                cheakListBook.add(false);
            }
        }
        system.debug(cheakListBook);
        return cheakListBook;


    }


}