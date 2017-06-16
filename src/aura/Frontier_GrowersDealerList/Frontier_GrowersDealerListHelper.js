({
    getDealerAccount : function(component,event,page1,searchKey) {
        var page = page1 || 1;
        var acId = component.get("v.accountId");
        var action = component.get("c.getDealerAccounts");
        console.log("================= Inside getDealerAccount" + searchKey);
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
    toGrowerCount : function(component,event){
        var uniqueId = event.target.id;        
        console.log('accountId,Sap Id,Accmu'+uniqueId);
        var accountId = uniqueId.split(',')[0];
        $A.createComponent("c:Frontier_GrowerAccountList",
                           {
                               accountId: accountId
                           },
                           function(GrowerList){
                               console.log('AccountList');
                               var comp = component.find("GrowerAccount");
                               comp.set("v.body",GrowerList);
                           }
    );
    },
	 navigateToAccountDetail : function(component,event) {
        console.log("c:Frontier_GrowerAccount_Overview");
        var uniqueId = event.target.id;
        console.log('accountId,Sap Id,Accmu'+uniqueId);
        var accountId = uniqueId.split(',')[0];
        var sapId= uniqueId.split(',')[1];
        var accCommunicationId = uniqueId.split(',')[2];
        /*$A.createComponent(
            "c:Frontier_AccountDetailViewComponent",
            {
                accId: accountId,
                sapId: sapId,
                accCommunicationId: accCommunicationId
            },
            function(newCmp){
                var cmp = component.find("AccountDetail");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );*/
        $A.createComponent(
            "c:Frontier_GrowerAccount_Overview",
            {
                "growerAcc" : uniqueId,
                "role" : component.get("v.accounts")[0].roleDesc,
                "heading" :'dealer'
            },
            function(newCmp){
                var cmp = component.find("GrowerAccount");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
    },
    sortbyRadl: function(component,page1,sortbyValue) {
        var page = page1 || 1;
        console.log("Inside sort helper");
        console.log("Inside sort page" + page);
        var action = component.get("c.sortBy");
        action.setParams({
            "sortbyValue": sortbyValue,
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            accId : component.get("v.accountId")
        });
        action.setCallback(this, function(response) {
            var accounts = [];
            component.set("v.page",page);
            var accountList = response.getReturnValue();
            component.set("v.pages",Math.ceil((JSON.parse(accountList[0]))/component.get("v.pageSize")));
            component.set("v.total",JSON.parse(accountList[0]));
            accounts = JSON.parse(accountList[1]);
            console.log("Dealer Account=>" + accounts);
            component.set("v.accounts", accounts);
        });
        $A.enqueueAction(action);
    },
    
	
})