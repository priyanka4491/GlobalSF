({
	getPicklistValues : function(component,event,helper) {
        var action = component.get("c.getMyProgramsChart");
        var programId = null;
        var dealerId = null;
        action.setParams({
        		programId :programId,
                dealerId : dealerId,
            	isDashboard : 'True'	
            });
     var inputsel = component.find("sellingSeason");
      //var cropsel = component.find("cropDetails");
        var accSelect = component.find("accType"); 
        var opts=[];
        //var crops=[];
        var accType=[];
        
        action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse = (JSON.parse(response.getReturnValue()));
                  for(var i=0;i< retResponse.sellingSeasontypes.length;i++){
                opts.push({"class": "optionClass", label: retResponse.sellingSeasontypes[i], value:retResponse.sellingSeasontypes[i]});
            }
             /*   for(var i=0;i< retResponse.croptypes.length;i++){
                crops.push({"class": "optionClass", label: retResponse.croptypes[i], value:retResponse.croptypes[i]});
            }*/
                for(var i=0;i< retResponse.accTypes.length;i++){
                     accType.push({"class": "optionClass", label: retResponse.accTypes[i], value:(retResponse.accTypes[i] == 'Dealer'?'Partner': (retResponse.accTypes[i] == 'Grower'?'Customer':'All Accounts'))});
            }
             inputsel.set("v.options",opts); 
             //cropsel.set("v.options",crops);
             accSelect.set("v.options",accType);
                }
        });
        $A.enqueueAction(action);
		
		
	},
    getchartdetails : function(component,event,helper,season,accType){
         $A.createComponent(
            "c:Frontier_AccountByRadlChart",
            {
                //"crop" : crop,
                "season" : season,
                "accType" : accType
                
            },
            function(newCmp){
                var cmp = component.find("accountRADL");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
        $A.createComponent(
            "c:Frontier_RadlCoveragechart",
            {
                //"crop" : crop,
                "season" : season,
                "accType" : accType
                
            },
            function(newCmp){
                var cmp = component.find("accountRADLCoverage");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
         $A.createComponent(
            "c:Frontier_TouchpointsbyMonth_Chart",
            {
                //"crop" : crop,
                "season" : season,
                "accType" : accType
                
            },
            function(newCmp){
                var cmp = component.find("touchpointByMonthChart");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
         $A.createComponent(
            "c:Frontier_TouchpointbyTypeChart",
            {
                //"crop" : crop,
                "season" : season,
                "accType" : accType
                
            },
            function(newCmp){
                var cmp = component.find("touchpointByTypeChart");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
      /*  $A.createComponent(
            "c:Frontier_AccountDashborad_DealerList",
            {
                "crop" : crop,
                "season" : season,
                "accType" : accType
                
            },
            function(newCmp){
                var cmp = component.find("dealerList");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );*/
    }
})