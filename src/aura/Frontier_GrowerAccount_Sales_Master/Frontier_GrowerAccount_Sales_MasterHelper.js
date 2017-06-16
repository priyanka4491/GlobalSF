({
	growerSalesDetails : function(component,event,helper) {
        //var UOM = component.find("sortByType").get("v.value");
        //console.log('UOM'+UOM);
       var UOM = 'Units';
        var growerAccId=component.get("v.growerAccId");
		var action = component.get("c.GrowerSalesDetails");
        var growerAccSalesJson;
        action.setParams({
            growerAccId :growerAccId,
            UOM:UOM
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             growerAccSalesJson = (JSON.parse(response.getReturnValue()));
              console.log('growerAccSalesJson' + JSON.stringify(growerAccSalesJson));
               
               //this.getSeasonDetails(component,event,helper);
               component.set("v.growerSalesFarm", growerAccSalesJson);
                var growerSalesFarmCrop = [];
               
                   growerSalesFarmCrop = (growerAccSalesJson.CropValues); 
                     console.log('growerSalesFarmCrop' +growerSalesFarmCrop.sort());
               component.set("v.growerSalesFarmCrop", growerSalesFarmCrop.sort());
                if(growerSalesFarmCrop != null && growerSalesFarmCrop.length > 0){
                    component.set("v.latestCrop",growerSalesFarmCrop[growerSalesFarmCrop.length -1]);
                }
                /*if(growerAccFarmJson.displayMsg == true){
                    var errorMsg = $A.get("$Label.Update_Farming_Area_Alert");
                    console.log("Error msg" , errorMsg);
                    //component.set("v.errorMsg",'**********Please update Total Area for Current FY**********');
                } */
                   component.set("v.loadchart1" , true);
                    component.set("v.loadchart2" , true);
                    component.set("v.loadchart3" , true);
                
                var crops = [];
                var conts = growerAccSalesJson.cropPercentage;
                for ( key in conts ) {
                    crops.push({value:conts[key], key:key});
                }
                component.set("v.crops", crops);
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
                console.log("Errors", response.getError());
            }
	});
         $A.enqueueAction(action);
    }
});