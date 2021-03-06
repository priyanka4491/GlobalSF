({
    loadChart : function(component, event){
        var crop   = component.find("crop").get("v.value");
        var season = component.find("season").get("v.value");
        component.set("v.Crop",crop == undefined ? 'All Crops' :crop);
        var programType = component.find("programPlanned").get("v.value");
        var action = component.get("c.RadlBasedCoverageManipulation");
        action.setParams({ 
            selectedOrAllSalesRep : typeof component.find("salesrep").get("v.value")=== 'undefined' ? 'All' : component.find("salesrep").get("v.value"),
            crop : crop,
            season : season,
            programType : programType
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log('Success');
                var crops = [];
                var seasons = [];
                var salesReps = [];
                var programs = [];
                var radlCoverage = response.getReturnValue();
                component.set("v.radlCoverage",JSON.parse(radlCoverage[2]));
                var season = JSON.parse(radlCoverage[0]);
                var crop = JSON.parse(radlCoverage[1]);
                var salesrep = JSON.parse(radlCoverage[3]);
                if(component.get("v.isInitialize") == false){
                    component.set("v.isInitialize",true);
                    programs.push({"class": "optionClass", label: 'Planned Program Coverage', value:'Planned Program Coverage'});
                    programs.push({"class": "optionClass", label: 'Actual Program Coverage', value:'Actual Program Coverage'});
					component.find("programPlanned").set("v.options",programs);
                    
                    if(radlCoverage != null &&  radlCoverage.length > 0){
                        if(radlCoverage[4] === 'true'){ // True if it is Manager
                            var saleRepPickListDiv = component.find('salesRepDiv');
                            $A.util.removeClass(saleRepPickListDiv,'slds-hide');
                            salesReps.push({"class": "optionClass", label: 'All', value:'All'});
                            for(var i=0;i< salesrep.length;i++){
                                salesReps.push({"class": "optionClass", label: salesrep[i].Name, value:salesrep[i].Id});
                            }
                            component.find("salesrep").set("v.options",salesReps);
                        for(var i=0;i< season.length;i++){
                            seasons.push({"class": "optionClass", label: season[i], value:season[i]});
                        }
                        for(var i=0;i< crop.length;i++){
                            crops.push({"class": "optionClass", label: crop[i], value:crop[i]});
                        }
                        component.find("crop").set("v.options",crops); 
                        component.find("season").set("v.options",seasons);
                        component.set("v.loadChart",true);                 
                    }
                }
                
                this.getchartList(component,event); 
            }
            else{
                console.log('Error occured');
            }
            } 
        });
        $A.enqueueAction(action);
    },
    getchartList:function(component,event,helper){
        if(component.get("v.loadChart") == true){
            $A.createComponent(
                "c:Frontier_SalesRepTerritoryBasedRadl",
                {
                    chartIdentifier:"Customer",
                    radlCoverage:component.get("v.radlCoverage")
                },
                function(newCmp){   
                    var cmp = component.find("Customer");
                    if(cmp != undefined){
                        cmp.set("v.body",[]);
                        cmp.set("v.body", newCmp);
                    }                
                });
            
            $A.createComponent(
                "c:Frontier_SalesRepTerritoryBasedRadl",
                {
                    chartIdentifier:"Partner",
                    radlCoverage:component.get("v.radlCoverage")
                },
                function(newCmp){               
                    var comp = component.find("Partner");
                    if(comp != undefined){
                        comp.set("v.body",[]);
                        comp.set("v.body", newCmp);
                    }                
                });
          
            $A.createComponent(
                "c:Frontier_SalesRepProgramAllocation",
                {
                    chartIdentifier:"AllAccountsWithProgram",
                    radlCoverage:component.get("v.radlCoverage")
                },
                function(newCmp){               
                    var cmp = component.find("AllAccountsWithProgram");
                    if(cmp != undefined){
                        cmp.set("v.body", newCmp);
                    }                
                });
            
           
        }     
    }
});