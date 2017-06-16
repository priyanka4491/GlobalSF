({
	 doinit : function(component, event, helper) {
         //setInterval(function(){
             if(component.get("v.comLat") === 'empty'){
                 if(navigator.geolocation){
                     console.log(component.get("v.comLat"));
                     navigator.geolocation.getCurrentPosition(function(position){ 
                         console.log(position.coords.latitude);
                         console.log(position.coords.longitude);
                         component.set("v.comLat",position.coords.latitude);
                         component.set("v.comLong",position.coords.longitude);
                     });	
                 }
             }
         //},3000);
    },
    handleValueChange : function(component, event, helper) {
	    helper.getAccounts(component);
    },
})