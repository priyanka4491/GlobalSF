({
	dealerSalesDetails : function(component,event,helper) {
        //var UOM = component.find("sortByType").get("v.value");
        var growerAccSalesJson;
        console.log('Dealer id' +dealerAccId);
        console.log('UOM'+UOM);
       var UOM = 'Units';
       var dealerAccId=component.get("v.dealerid").split(',')[0];
        console.log('dealerAccId' + dealerAccId);
		var action = component.get("c.getdealerSalesDetails");
        action.setParams({
            dealerAccId :dealerAccId,
            UOM:UOM
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('Success');
             growerAccSalesJson = (JSON.parse(response.getReturnValue()));
              console.log('growerAccSalesJson' + JSON.stringify(growerAccSalesJson));
               component.set("v.growerSalesFarm",growerAccSalesJson); 
              var growerSalesFarmCrop = [];  
              for(var key in  growerAccSalesJson.cropMap){
                    console.log('Inside Map');
                   growerSalesFarmCrop.push(key); 
                }
               console.log('growerSalesFarmCrop' +growerSalesFarmCrop.sort());
                
               component.set("v.growerSalesFarmCrop", growerSalesFarmCrop.sort());
               if(growerSalesFarmCrop != null && growerSalesFarmCrop.length > 0){
                    component.set("v.latestCrop",growerSalesFarmCrop[growerSalesFarmCrop.length -1]);
                } 
                
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