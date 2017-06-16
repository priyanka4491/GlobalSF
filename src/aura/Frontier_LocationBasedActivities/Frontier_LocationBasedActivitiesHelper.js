({
    getTasks : function(component) {
         /*if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(function(position){     
                console.log(position.coords.longitude);
                component.set("v.comLat",position.coords.latitude);
                component.set("v.comLong",position.coords.longitude);
            });	
        }*/
        var action = component.get("c.getMyLocationRecords");
        action.setParams({
            lati : component.get("v.comLat"),
            longi: component.get("v.comLong")
        });      
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                $A.createComponent("c:Frontier_GoogleMapComponent",
                                   { "aura:id" : "test",
                                    "Tasks" : response.getReturnValue(),
                                    "currentLongitude": component.get("v.comLong"),
                                    "currentLatitude": component.get("v.comLat")
                                   },
                                   function(task){
                                       var comp = component.find("map");
                                       comp.set("v.body",task);
                                       console.log('Frontier_GoogleMapComponent');                                       
                                   }
                                  );
                component.set("v.TaskRecords",response.getReturnValue());
                //component.set("v.TaskRecords",component.get("v.responseRecord"));
            }
            
        });
        $A.enqueueAction(action);        
    }
})