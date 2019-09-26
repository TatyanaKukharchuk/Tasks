({
    myAction : function(component, event, helper) {
        var allContactRecords = component.get("v.contacts");
       	var pageSize = component.set("v.pageSize", 5);
        helper.displayContact(component, allContactRecords);
        var fieldSetContact = component.get("v.fieldSet");
        helper.displayFieldSet(component, fieldSetContact);
    },


	searchByContact : function(component, event, helper) {
            var searchSegment = component.get("v.nameForSearch");
            if (!searchSegment) {
                searchSegment = '';
            }
            helper.searchContactByField(component, searchSegment);
     },
     clickShowMore: function(component, event, helper){
          var numberRecords = component.get("v.pageSize");
                 var contacts = component.get("v.contacts");
                 var numberContacts = contacts.length;
                 if(numberRecords  <= numberContacts){
                     numberRecords += 5;
                 } else {
                      numberRecords = numberContacts;
                 }
                 component.set("v.pageSize", numberRecords);

             }
})