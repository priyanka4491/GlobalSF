({
    loadFilterValues : function(component, event){
        var crop   = component.find("crop").get("v.value");
        var season = component.find("season").get("v.value");
        console.log('crop--------'+crop+'season============'+season);
             var action = component.get("c.getFilterDetails");
        action.setParams({ 
            crop : crop,
            season : season
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
				console.log('Success');
                var crops = [];
                var seasons = [];
                var radlCoverage = response.getReturnValue();
                component.set("v.radlCoverage",JSON.parse(radlCoverage[2]));
                console.log('JSON.parse---------------'+JSON.stringify(JSON.parse(radlCoverage[2])));
                var season = JSON.parse(radlCoverage[0]);
                var crop = JSON.parse(radlCoverage[1]);
                if(component.get("v.isInitialize") == false){
                    component.set("v.isInitialize",true);
                if(radlCoverage != null &&  radlCoverage.length > 0){
                    
                    for(var i=0;i< season.length;i++){
                		seasons.push({"class": "optionClass", label: season[i], value:season[i]});
                    }
                for(var i=0;i< crop.length;i++){
                	crops.push({"class": "optionClass", label: crop[i], value:crop[i]});
           		}
                 component.find("crop").set("v.options",crops); 
                 component.find("season").set("v.options",seasons);				 
                }
                }
                
              // this.getchartList(component,event); 
            }
            else{
                console.log('Error occured');
            }
            
       });
        $A.enqueueAction(action);
    }
})