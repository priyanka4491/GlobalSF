({
    searchKeyChange: function(component, event){
        var myEvent = $A.get("e.c:Frontier_AccountSearchkey");
        myEvent.setParams({"searchKey": event.target.value});
        console.log("ist event value" + event.target.value);
        myEvent.fire();
    },
    onSingleSelectChange:function(component){
        var sortEvent = $A.get("e.c:Frontier_AccountSortBy");
        var selectCmp = component.find("InputSelectSingle").get("v.value");
        console.log("Selected" +selectCmp);
        sortEvent.setParams({"sortbyValue": selectCmp});
        sortEvent.fire();}
});