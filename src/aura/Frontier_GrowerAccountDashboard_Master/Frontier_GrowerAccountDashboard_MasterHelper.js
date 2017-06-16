({
	getPicklistValues : function(component,event) {
         var action = component.get("c.getMyProgramsChart");
        var programId = null;
        var dealerId = null;
        action.setParams({
        		programId :programId,
                dealerId : dealerId
            });
     var inputsel = component.find("sellingSeasonGrower");
      var cropsel = component.find("cropDetailsGrower");
        var opts=[];
        var crops=[];
        
        action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse = (JSON.parse(response.getReturnValue()));
                    console.log("retResponse"+ JSON.stringify(retResponse));
                    
                    
               for(var i=0;i< retResponse.sellingSeasontypes.length;i++){
                opts.push({"class": "optionClass", label: retResponse.sellingSeasontypes[i], value:retResponse.sellingSeasontypes[i]});
            }
                for(var i=0;i< retResponse.croptypes.length;i++){
                crops.push({"class": "optionClass", label: retResponse.croptypes[i], value:retResponse.croptypes[i]});
            }
             inputsel.set("v.options",opts); 
              cropsel.set("v.options",crops);
                }
        });
        $A.enqueueAction(action);
		
		
	},
    getchartdetails : function(component,event,crop,season){
         $A.createComponent(
            "c:Frontier_GrowerAccountByRadlChart",
            {
                "crop" : crop,
                "season" : season
                
            },
            function(newCmp){
                var cmp = component.find("accountCoverageRADLGrower");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
         $A.createComponent(
            "c:Frontier_GrowerTouchpointsbyMonth_Chart",
            {
                "crop" : crop,
                "season" : season
                
            },
            function(newCmp){
                var cmp = component.find("touchpointByMonthChartGrower");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
         $A.createComponent(
            "c:Frontier_GrowerTouchpointbyTypeChart",
            {
                "crop" : crop,
                "season" : season
                
            },
            function(newCmp){
                var cmp = component.find("touchpointByTypeChartGrower");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
        $A.createComponent(
            "c:Frontier_GrowerAccountDashboard_GrowerList",
            {
                "crop" : crop,
                "season" : season
                
            },
            function(newCmp){
                var cmp = component.find("growerList");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
    }
})