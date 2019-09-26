({
    myAction : function(component, event, helper) {
            var allOpenHotels = component.get("v.hotels");
            helper.displayHotel(component, allOpenHotels);
            var today = new Date();
           component.set('v.dateBook', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        },

    displayRoom :  function(component, event, helper) {
            var  selectedHotel = event.getSource().get("v.value");
            helper.displayRoomByHotel(component, selectedHotel );
           },

    dateChange :  function(component, event, helper) {
            var dateB = component.get("v.dateBook");
            var rooms = component.get("v.rooms");
            helper.checkBookRoom(component, dateB, rooms);
           }

})