({
    displayHotel : function(component, allOpenHotelsParam)  {

                     var action = component.get("c.allHotels");
                            action.setCallback(this, function(result){
                                var hotels = result.getReturnValue();
                                component.set("v.hotels", hotels);
                                    $A.getCallback( function(response) {
                                          var state = response.getState();
                                             if(state === "SUCCESS"){
                                       component.find("chooseHotel").set("v.value", hotels[1].id);
                                       } else if (state === "ERROR") {
                                          var errors = response.getError();
                                         console.error(errors);
                                       }
                                    });
                            });
                            $A.enqueueAction(action);
                        },

    displayRoomByHotel : function(component, selectedHotelParam) {

                      var action = component.get("c.showRoom");
                            action.setParams({ selectedHotel : selectedHotelParam});
                                 action.setCallback(this, function(result){
                                      var state = result.getState();
                                       if(state === "SUCCESS"){
                                   var room = result.getReturnValue();
                                   component.set("v.rooms", room);
                                    } else if (state === "ERROR") {
                                        var errors = response.getError();
                                       console.error(errors);
                                     }
                                     });
                               $A.enqueueAction(action);
                                  },
    checkBookRoom : function(component, dateParam, roomsParam) {

                      var action = component.get("c.bookRooms");
                            action.setParams({"dateB" : dateParam, "rooms" :  roomsParam });
                                 action.setCallback(this, function(result){
                                      var state = result.getState();
                                       if(state === "SUCCESS"){
                                   var bookRoom = result.getReturnValue();
                                    component.set("v.book", bookRoom);
                                  var transformedData = [];
                                    for(var i=0; i< roomsParam.length; i=i+1){
                                    transformedData.push({
                                       roomsParam : roomsParam[i],
                                       bookRoom: bookRoom[i]
                                    });
                                 }
                                  component.set('v.transformData', transformedData);
                                   } else if (state === "ERROR") {
                                       var errors = response.getError();
                                       console.error(errors);
                                   }
                                    });
                               $A.enqueueAction(action);
                                  }


})