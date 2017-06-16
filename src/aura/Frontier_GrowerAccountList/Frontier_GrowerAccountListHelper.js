({
    searchEmployee : function(component,page1,searchKey) {
        var page = page1 || 1;
        var acId = component.get("v.accountId");
        var action = component.get("c.getAccounts");
        console.log("================= Inside searchEmployee" + searchKey);
        console.log("================= Inside page" + page);
        action.setParams({
            "searchKey": searchKey,
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            accId : acId
        });
        action.setCallback(this, function(response) {
            var accounts = [];
            component.set("v.page",page);
            var accountList = response.getReturnValue();
            component.set("v.pages",Math.ceil((JSON.parse(accountList[0]))/component.get("v.pageSize")));
            component.set("v.total",JSON.parse(accountList[0]));
            accounts = JSON.parse(accountList[1]);
            console.log("Account search employee" + accounts);
            component.set("v.accounts", accounts);
        });
        $A.enqueueAction(action);
    },
    navigateToAccountDetail : function(component,event) {
        var uniqueId = event.target.id;
        console.log('accountId,Sap Id,Accmu'+uniqueId);
        var accountId = uniqueId.split(',')[0];
        var sapId= uniqueId.split(',')[1];
        var accCommunicationId = uniqueId.split(',')[2];
        $A.createComponent(
            "c:Frontier_GrowerAccount_Overview",
            {
                growerAcc: uniqueId
            },
            function(newCmp){
                var cmp = component.find("DealerList");
                cmp.set("v.body", newCmp);
            }
        );
    },
    sortbyRadl: function(component,page1,sortbyValue) {
        var page = page1 || 1;
        console.log("Inside sort helper");
        console.log("Inside sort page" + page);
        var acId = component.get("v.accountId");
        var action = component.get("c.sortBy");
        console.log('&&&&&&&&&'+acId);
        action.setParams({
             
            "sortbyValue": sortbyValue,
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            acId :acId
        });
        action.setCallback(this, function(response) {
            var accounts = [];
            component.set("v.page",page);
            var accountList = response.getReturnValue();
            component.set("v.pages",Math.ceil((JSON.parse(accountList[0]))/component.get("v.pageSize")));
            component.set("v.total",JSON.parse(accountList[0]));
            accounts = JSON.parse(accountList[1]);
            console.log("Account search employee" + accounts);
            component.set("v.accounts", accounts);
        });
        $A.enqueueAction(action);
    },
    showPopUp: function(component,event,message){
        console.log("Inside showPop");
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message},
                           function(newComp){
                               console.log('pop');
                               var comp = component.find("followpopup");
                               comp.set("v.body",newComp);
                           });
    },
    toGrowerCount : function(component,event){
        var uniqueId = event.target.id;        
        console.log('accountId,Sap Id,Accmu'+uniqueId);
        var accountId = uniqueId.split(',')[0];
        $A.createComponent("c:Frontier_GrowersDealerList",
                           {
                               accountId: accountId
                           },
                           function(DealerList){
                               console.log('DealerList');
                               var comp = component.find("DealerList");
                               comp.set("v.body",DealerList);
                           }
    	);
    },
});