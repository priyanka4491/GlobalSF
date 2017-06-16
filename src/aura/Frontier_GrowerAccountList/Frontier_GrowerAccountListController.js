({
    doInit : function(component, event, helper) {
        var searchKey = '';
        var page = component.get("v.page") || 1;
        helper.searchEmployee(component,page,searchKey);
    },
    searchKeyChange: function(component, event,helper){
        var searchKey;
        var page = 1;
        searchKey = event.getParam("searchKey");
        component.set("v.searchString",searchKey);
        component.set("v.sortpage", false);
        if(event.getParam("searchKey") != null){
            searchKey = event.getParam("searchKey");
            helper.searchEmployee(component,page,searchKey);
        }
        else{
            searchKey = '';
            helper.searchEmployee(component,page,searchKey);
        }
    },
    sortbyChange: function(component, event,helper){
        if(event.getParam("sortbyValue") != null){
            var page = 1;
            var sortbyValue = event.getParam("sortbyValue");
            component.set("v.sortString",sortbyValue);
            component.set("v.sortpage", true);
            if(sortbyValue === "None"){
                sortbyValue='';
            }
            helper.sortbyRadl(component,page,sortbyValue);
        }
    },
    accountNavigation: function(component,event,helper){
        var uniqueId = event.target.id;
        console.log('Account List===========>'+uniqueId);
        //component.set("v.accId",uniqueId.split(',')[0]);
        component.set("v.accId",uniqueId);
        helper.navigateToAccountDetail(component, event);
    },
    pageChange: function(component, event, helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'DealerGrowerList'){
            var page;
            
            var direction;
            var sortenable = component.get("v.sortpage");
            console.log(sortenable + 'sortenable');
            if( sortenable === false ){
                var searchKey = component.get("v.searchString");
                if(searchKey === undefined )
                {
                    searchKey='';
                    console.log(searchKey +'searchKey');
                }
                page = component.get("v.page") || 1;
                direction = event.getParam("direction");
                page = direction === "previous" ? (page - 1) : (page + 1);
                helper.searchEmployee(component,page,searchKey);
            }
            else{
                var sortbyValue = component.get("v.sortString");
                if(typeof sortbyValue === undefined || sortbyValue === "None"){
                    sortbyValue='';
                }
                page = component.get("v.page") || 1;
                direction = event.getParam("direction");
                console.log(direction + "Direction");
                page = direction === "previous" ? (page - 1) : (page + 1);
                helper.sortbyRadl(component,page,sortbyValue);
            }
        }
    },
    // Render the touch point creation form
    recordtouchpoint:function(component,event){
        /*try{
            $A.createComponent(
                "c:Frontier_TouchPointRecord",
                {"accId" : event.target.id },
                function(newCmp){
                    newCmp.set("v.accId", event.target.id);
                    var cmp = component.find("AccountDetail");
                    cmp.set("v.body", newCmp);
                });
        }
        catch(e){
            console.log('Exception Occured'+e);
        }*/
        
        component.set("v.growerAcc",event.target.id);
        try{
            $A.createComponent(
                "c:Frontier_GrowerAccount_UpdateTouchPoint",
                {
                    "growerAcc" : ''+'/'+component.get("v.growerAcc")+'/'+'',
                    "dealerId" : component.get("v.accountId"),
                    "isdealersGrower" : true
                },
                function(newCmp){
                    //newCmp.set("v.accId", event.target.id);
                    var cmp = component.find("DealerList");
                    cmp.set("v.body", newCmp);
                });
        }
        catch(e){
            console.log('Exception Occured'+e);
        }
    },
    groweraccNavigation : function(component,event,helper){
        helper.toGrowerCount(component,event);
    },
    navigateToGrowerList : function(component,event){
        var accountId = event.getParam("accountId");
        $A.createComponent("c:Frontier_GrowerAccountList",
                           {
                               accountId: accountId
                           },
                           function(GrowerList){
                               console.log('GrowerList');
                               var comp = component.find("DealerList");
                               comp.set("v.body",GrowerList);
                           }
                          );
    },
    navigateToDelaerList :function(component,event,helper){
        var accountId = event.getParam("accountId");
        console.log('GrowerAccountList=>'+accountId);
        $A.createComponent("c:Frontier_GrowersDealerList",
                           {
                               accountId : accountId
                           },
                           function(acctList){
                               console.log('DealerList');
                               var comp = component.find("DealerList");
                               comp.set("v.body",acctList);
                           }
                          );
    }
});