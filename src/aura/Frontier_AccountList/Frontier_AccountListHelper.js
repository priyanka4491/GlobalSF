({
    searchEmployee : function(component,event, helper, page1,searchKey) {
        var acId = component.find("v.accountId");
        var page = page1 || 1;
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
            if(response.getState() === "SUCCESS"){
                var accounts = [];
                component.set("v.page",page);
                var accountList = response.getReturnValue();
                component.set("v.pages",Math.ceil((JSON.parse(accountList[0]))/component.get("v.pageSize")));
                component.set("v.total",JSON.parse(accountList[0]));
                accounts = JSON.parse(accountList[1]);
                console.log("Account search employee" + accounts);
                component.set("v.accounts", accounts);
               	helper.gotoComponent(component, event, helper);
                
            }
        });
        $A.enqueueAction(action);
    },
    navigateToAccountDetail : function(component,event) {
        console.log("c:Frontier_AccountDetailViewComponent");
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
                "growerAcc" : accountId+','+sapId+','+accCommunicationId,
                "role" : component.get("v.accounts")[0].roleDesc,
                "heading" :'dealer',
                "accountAddressInfo":uniqueId.split(',')[3]+','+uniqueId.split(',')[4]
            },
            function(newCmp){
                var cmp = component.find("AccountDetail");
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
            pageSize : component.get("v.pageSize")
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
        $A.createComponent("c:Frontier_GrowerAccountList",
                           {
                               accountId: accountId
                           },
                           function(GrowerList){
                               console.log('AccountList');
                               var comp = component.find("AccountDetail");
                               comp.set("v.body",GrowerList);
                           }
    );
    },
    toGrowerList : function(component,event){
        var accountId = event.getParam("accountId");
        $A.createComponent("c:Frontier_GrowerAccountList",
                           {
                               accountId: accountId
                           },
                           function(GrowerList){
                               console.log('AccountList');
                               var comp = component.find("AccountDetail");
                               comp.set("v.body",GrowerList);
                           }
                          );
    },
    gotoComponent : function(component,event,helper){
        var sPageURL,myprogramDetails,accountId,programId,accomId,roleDesc;
        if(window.location.hash.split('=')){
            sPageURL = window.location.hash.split('=');
            if(sPageURL[1]){
            myprogramDetails = sPageURL[1].split('-');
            roleDesc =  myprogramDetails[1];
            accountId = myprogramDetails[2];
            programId = myprogramDetails[3];
            accomId = myprogramDetails[4];
            if(accountId){
                $A.createComponent(
                    "c:Frontier_GrowerAccount_Overview",
                    {
                        "growerAcc" : accountId+','+''+','+accomId+','+programId,
                        "role" : myprogramDetails[1],
                        "heading" :'dealer',
                        "handlerName": myprogramDetails[0]
                    },
                    function(newCmp){
                        var cmp = component.find("AccountDetail");
                        cmp.set("v.body", []);
                        cmp.set("v.body", newCmp);
                    }
                );
            }
            }

        }
    }
});