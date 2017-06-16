({
	loadRADLgraph : function(component,event) {
		/*console.log('Inside graph' + component.get("v.fromCmp"));
        var programId;
        var developradlCount =[];
        var acqradlCount =[];
        var retainradlCount =[];
        var lightradlCount =[];
        
        if(component.get("v.fromCmp") == 'myPrograms'){
            programId = null;
            console.log('programId' + programId);
        }
        if(component.get("v.programId") != '' || component.get("v.programId") != undefined ){
            programId = component.get("v.programId");
            console.log('programId' + programId);
        }
        var action = component.get("c.getGraphdata");
        action.setParams({
                programId : programId,
                dealerId :  component.get("v.dealerId")
            });
        action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    console.log('Success');
                    var accPgmRADL = (JSON.parse(response.getReturnValue()));
                    for(var key in accPgmRADL.accPgmRadlMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        component.set("v.dcount",accPgmRADL.accPgmRadlMap[key]);
                    }
                     if(key == 'Acquire'){
                        component.set("v.acqcount",accPgmRADL.accPgmRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        component.set("v.rcount",accPgmRADL.accPgmRadlMap[key]);
                    }
                    if(key == 'Light Touch'){
                        component.set("v.lcount",accPgmRADL.accPgmRadlMap[key]);
                    }
                } 
                }
            else{
                console.log('Error');
            }
	});
     $A.enqueueAction(action);  */
    }
})