({
	getAllPrograms : function(component,event,helper) {
        
		 var action = component.get("c.getMyPrograms");
         
        var acctDetails = component.get("v.growerAcc");
        console.log('acctDetails' +acctDetails);
         
        var isMyProgram = 'false';
        var dealerId = null;
        var isAllDealer ='true';
        var ProgramId = null;
        
      action.setParams({
          ProgramId :ProgramId,
          dealerId : dealerId,
          isAllDealer:isAllDealer,
          isMyProgram :isMyProgram
               
                
            });
     //var inputsel = component.find("sellingSeason");
        var opts=[];
     action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse = (JSON.parse(response.getReturnValue()));
                    console.log("retResponse"+ JSON.stringify(retResponse));
                    
                    component.set("v.programList", retResponse);
                    component.set("v.loadchart1" , true);
                    component.set("v.loadchart2" , true);
                    component.set("v.loadchart3" , true);
              /* for(var i=0;i< retResponse.sellingSeasontypes.length;i++){
                opts.push({"class": "optionClass", label: retResponse.sellingSeasontypes[i], value:retResponse.sellingSeasontypes[i]});
            }
             inputsel.set("v.options",opts);*/
                var Acquire = retResponse.acquireCount;
                var Develop = retResponse.developCount;
                var LightTouch = retResponse.lightTouchCount;
                var Retain = retResponse.retainCount;
               console.log('Acquire' + Acquire + 'Develop' + Develop + 'LightTouch' +LightTouch +'Retain'+Retain);
                   $A.createComponent(
            "c:Frontier_ProgramPlanning_Radl",
            {
                acqcount:Acquire,
                dcount :Develop,
                lcount :LightTouch,
                rcount :Retain
                
            },
            function(newCmp){
                var cmp = component.find("radlDiv");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);	
            }
        );   
               /*    $A.createComponent(
            "c:Frontier_Pgm_Planning_BudgetChart",
            {
              "available" : '5',
                "allocated" : '7',
                "consumed" :'8' ,
                "identifier" : '1'
            },
            function(newCmp){
                var cmp = component.find("loadchart1");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);	
            }
        );*/   
            /*        $A.createComponent(
            "c:Frontier_ProgramPlanning_Radl",
            {
               
            },
            function(newCmp){
                var cmp = component.find("radlDiv");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);	
            }
        );   
                    $A.createComponent(
            "c:Frontier_ProgramPlanning_Radl",
            {
               
            },
            function(newCmp){
                var cmp = component.find("radlDiv");
                //cmp.set("v.body", []);
                cmp.set("v.body", newCmp);	
            }
        );  */ 
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        },
    navigateToProgramDetails:function(component,event,helper){
        var programId = event.getParam("programId");
        
        console.log('My Programs' + programId);
        $A.createComponent("c:Frontier_AllDealers_SalesRep_ProgramDetail_Master",
                           {
                               programId: programId
                               
                           },
                           function(program){
                               console.log('Program Details');
                               var comp = component.find("programDetail");
                               comp.set("v.body",program);
                           }
    );
    }
	
	
})