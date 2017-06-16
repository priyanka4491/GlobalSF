({
    doInit:function(component,event,helper){
        var accountList = component.get("v.accountList");
        var account = component.get("v.account"); 
        console.log('account'+account);
         console.log('accountList'+accountList);

        var radlKey = (component.get("v.radlKey") == undefined ? 'None': component.get("v.radlKey")) ;
        var searchKey = (component.get("v.searchKey") == undefined || component.get("v.searchKey") == null ? '' : component.get("v.searchKey"));
        if(accountList != null && accountList.length > 0){
            for(var i = 0;i<accountList.length;i++){
                if(account != undefined && account.Id == accountList[i].Id 
                   && ((radlKey != undefined && (radlKey != 'None' || radlKey != null) && radlKey == account.serviceLevelDesc)?true:((radlKey == undefined || radlKey == 'None' || radlKey == null) && searchKey != '' ? true :(searchKey == '' && radlKey == 'None'?true:false)))
                  ){
               /* if(account != undefined && account.Id == accountList[i].Id){
                    var isSelectAccount = false;
                    var accName = String(account.Name).toLowerCase();
                    var searchText = searchKey.toLowerCase();
                    if((radlKey != undefined && (radlKey != 'None' || radlKey != null) && radlKey == account.serviceLevelDesc)
                      && searchKey != '' && searchText == accName){
                        isSelectAccount = true;
                    }
                    else if((radlKey == 'None' || radlKey == null) && (searchKey != '' && searchText == accName)){
                        console.log('Matched');
                        isSelectAccount = true;
                    }
                        else if((searchKey == '') && (radlKey != undefined && (radlKey != 'None' || radlKey != null) && radlKey == account.serviceLevelDesc)){
                             isSelectAccount = true;
                        }
                            else if(searchKey == '' && (radlKey == 'None' || radlKey == null || radlKey == undefined)){
                                isSelectAccount = true;
                            }
                    if(isSelectAccount){
                        component.set("v.account",accountList[i]);
                        break;
                    }
                }*/
                   
                    component.set("v.account",accountList[i]);
                        break;
                    
                }
            }
        }
        
    },
    
	onCheck : function(component, event, helper) {
        var account = component.get("v.account");
        helper.selectAccount(component, event, helper,account.isSelected,account.accId);
    },
    selectAllAccounts : function(component, event, helper) {
        console.log('Select All');
        var filteredAccountList = event.getParam("filteredAccountList");
        var account = component.get("v.account");   
        var accountToSelect = {};
        accountToSelect = JSON.stringify(account);
        console.log('**********accountToSelect'+accountToSelect);
        var isAllSelected = event.getParam("isAllSelected");
        console.log('**********isAllSelected'+isAllSelected+'filteredAccountList'+JSON.stringify(filteredAccountList));
        if(isAllSelected && filteredAccountList.length > 0){
            for(var i = 0; i < filteredAccountList.length; i++){
                console.log('**********filteredAccountList[i].Id == account.Id'+filteredAccountList[i].Id == account.Id);

                if(!account.isSelected && filteredAccountList[i].Id == account.Id){
                   helper.enableAccount(component,accountToSelect,'isSelected',false,true,true);
                    helper.selectAccount(component, event, helper,true,account.accId);
                    break;
                }
            }
        }
        else if(!isAllSelected && filteredAccountList.length > 0){
            for(var i = 0; i < filteredAccountList.length; i++){
                if(account.isSelected && filteredAccountList[i].Id == account.Id){
                  helper.enableAccount(component,accountToSelect,'isSelected',false,true,false);
                    helper.selectAccount(component, event, helper,false,account.accId);
                    break;
                }
            }
        }
    }
	
})