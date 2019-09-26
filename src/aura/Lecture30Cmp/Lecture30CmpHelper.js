({
	 searchContactByField : function(component, searchSegmentParam) {
            var action = component.get('c.searchContactByBack');

            action.setParams({ searchSegment : searchSegmentParam});

            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.contacts', response.getReturnValue());
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors) ;
                }
            }));
            $A.enqueueAction(action);
},
    displayContact : function(component, allContactRecordsParam) {
           var action = component.get('c.allContacts');
           action.setParams({ allContactRecords : allContactRecordsParam});
           action.setCallback(this, $A.getCallback(function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
           component.set('v.contacts', response.getReturnValue());
           } else if (state === "ERROR") {
           var errors = response.getError();
           console.error(errors) ;
           }
           }));
           $A.enqueueAction(action);
},
   displayFieldSet : function(component, fieldSetContactParam) {
           var action = component.get('c.getFieldSets');
           action.setParams({ fieldSetContact : fieldSetContactParam});
           action.setCallback(this, $A.getCallback(function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
           component.set('v.fieldSet', response.getReturnValue());
           } else if (state === "ERROR") {
           var errors = response.getError();
           console.error(errors) ;
           }
           }));
           $A.enqueueAction(action);
},

})