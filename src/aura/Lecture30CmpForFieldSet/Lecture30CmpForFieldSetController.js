({

    doInit : function(component, event, helper){
    		var sobject = component.get('v.objName');
            var fieldName = component.get('v.fieldName');
            var formatText = component.find("fielddata");
            formatText.set("v.value",sobject[fieldName]);
            console.log(sobject[fieldName]);

    	}

})