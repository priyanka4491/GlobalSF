({
	selectAccount : function(component,event,helper,isChecked,accId) {
		var myEvent = $A.get("e.c:Frontier_ProgramPlanning_Event");        
        myEvent.setParams({"isCheck": isChecked,"accountId":accId});
        myEvent.fire();
	},
    enableAccount : function(component,accountToSelect,field,oldvalue,newvalue,isEnable) {
        var account = component.get("v.account"); 
    var accountToSelect = JSON.stringify(account);
    var originalString = '"isSelected":false';
    var replaceString = '"isSelected":true';
        if(isEnable){
        accountToSelect = accountToSelect.replace(originalString,replaceString);
        }
        else{
            accountToSelect = accountToSelect.replace(replaceString,originalString);
        }
     console.log(accountToSelect);
        component.set("v.account",JSON.parse(accountToSelect));
}
})