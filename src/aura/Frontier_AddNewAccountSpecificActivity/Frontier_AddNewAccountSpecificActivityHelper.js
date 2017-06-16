({    
    createRecord : function(component) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Task"
        });
        createRecordEvent.fire();
    }
})