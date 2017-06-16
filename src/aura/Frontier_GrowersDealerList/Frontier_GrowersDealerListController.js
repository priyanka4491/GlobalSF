({
    doInit : function(component, event, helper) {
        var searchKey = '';
        var page = component.get("v.page") || 1;
        helper.getDealerAccount(component,event,page,searchKey);
    },
    searchKeyChange: function(component, event,helper){
        var searchKey;
        var page = 1;
        searchKey = event.getParam("searchKey");
        component.set("v.searchString",searchKey);
        component.set("v.sortpage", false);
        if(event.getParam("searchKey") != null){
            searchKey = event.getParam("searchKey");
            helper.getDealerAccount(component, event, page,searchKey);
        }
        else{
            searchKey = '';
            helper.getDealerAccount(component, event, page,searchKey);
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
        component.set("v.accId",uniqueId.split(',')[0]);
        helper.navigateToAccountDetail(component, event);
    },
    groweraccNavigation : function(component,event,helper){
        helper.toGrowerCount(component,event);
    },
    pageChange: function(component, event, helper) {
        var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'GrowerDealerList'){
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
            helper.getDealerAccount(component,page,searchKey);
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
    recordtouchpoint : function(component, event, helper) {
        //component.set("v.growerAcc",event.target.id);
        try{
            $A.createComponent(
                "c:Frontier_GrowerAccount_UpdateTouchPoint",
                {
                    "growerAcc" : ''+'/'+event.target.id+'/'+'',
                    "isGrowerDealer" : true,
                    "dealerId" : component.get("v.accountId"),

                },
                function(newCmp){
                    //newCmp.set("v.accId", event.target.id);
                    var cmp = component.find("GrowerAccount");
                    cmp.set("v.body", newCmp);
                });
        }
        catch(e){
            console.log('Exception Occured'+e);
        }
    }
})