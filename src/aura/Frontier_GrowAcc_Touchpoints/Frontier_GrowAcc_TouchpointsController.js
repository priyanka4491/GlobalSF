({
	doInit : function(component, event, helper) {
        var isInitialize = true;
        var page = component.get("v.page") || 1;
        var index =null;
        var accComId = component.get("v.growerAcc").split(',')[2] ? component.get("v.growerAcc").split(',')[2] :'';
        component.set("v.accComId",accComId);
        helper.createAccountDetailsComp(component, event);
        helper.getProgramActivityTouchpoints(component,event,page,isInitialize,index);	
	},
    handleClick : function(component, event, helper){
        var isInitialize = false;
    var page = component.get("v.page") || 1; 
     var index;
        var prevfiscalId = component.get("v.prevfiscalID");
         var prevId = component.get("v.prevID");
        console.log('event.target.id' + event.target.id);
        console.log('prevfiscalId' + prevfiscalId);
        console.log('prevId' + prevId);
        if(event.currentTarget != undefined){
         index = event.currentTarget.id;
           
        }
        console.log('index' +index);
        
        
        if(prevfiscalId == '' && event.currentTarget.id == 'Previous'){
            $A.util.toggleClass(document.getElementById('Upcoming'), 'btncolorchange');
            $A.util.toggleClass(document.getElementById('Previous'), 'btncolorchange');            

        }
        if(prevfiscalId == '' && event.currentTarget.id == 'Cancelled'){
            $A.util.toggleClass(document.getElementById('Upcoming'), 'btncolorchange');
            $A.util.toggleClass(document.getElementById('Cancelled'), 'btncolorchange');

        }
        if(prevfiscalId != '' && prevfiscalId != event.currentTarget.id && (event.target.id == 'Cancelled' || event.target.id == 'Previous' || event.target.id == 'Upcoming')){
            if(prevfiscalId == 'Cancelled'){
            $A.util.toggleClass(document.getElementById('Cancelled'), 'btncolorchange');
            }
            else if(prevfiscalId == 'Previous'){
            $A.util.toggleClass(document.getElementById('Previous'), 'btncolorchange');
            }
            else{
            $A.util.toggleClass(document.getElementById('Upcoming'), 'btncolorchange');
             }
            $A.util.toggleClass(document.getElementById(index), 'btncolorchange');
        } 
        if(event.currentTarget.id === 'Previous' || event.currentTarget.id === 'Upcoming' || event.currentTarget.id === 'Cancelled'){
            component.set("v.prevfiscalID",event.target.id);
        }

        
        
        
    helper.getProgramActivityTouchpoints(component,event,page,isInitialize,index);
    },
    pageChange: function(component,event,helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'TouchPoints'){
        var isInitialize = false;
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getProgramActivityTouchpoints(component,event,page,isInitialize,'');
        }
    },
    navigateToTouchpointList : function(cmp,event,helper){
        var idParameters = event.getParam("touchPointRedirect");
        var touchPointStatus = event.getParam("touchPointStatus");
        var readOnly = true;
        if(touchPointStatus === 'Scheduled'){
            readOnly = false;
        }
        //alert(document.getElementById('Upcoming').classList.contains('btncolorchange'));
        //alert(document.getElementById('Previous').classList.contains('btncolorchange'));
        //if(document.getElementsByClassName)
         $A.createComponent(
            "c:Frontier_GrowerAccount_UpdateTouchPoint",
            {
                //currentDateId: currentDateId,
                //accountId:accId,
                newUpdateStatus:'update',
                //programId:programId,
                growerAcc : idParameters,
                isReadOnly : readOnly,
                isTouchpoint : true
            },
            function(newCmp){
                var comp = cmp.find("viewTouchpoint");
                comp.set("v.body", []);
                comp.set("v.body", newCmp);
            }
        );
    }
});