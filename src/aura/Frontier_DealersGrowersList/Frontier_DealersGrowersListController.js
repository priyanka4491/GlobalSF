({
	doInit : function(component, event, helper) {
        var searchKey = '';
        var page = component.get("v.page") || 1;
		helper.findGrowerAccounts(component, page, searchKey, event, helper, true);		
	},
    toggle : function(component, event, helper) {
    var toggleGrowerAccounts = component.find("GrowerAccounts");
    var accordionChange = component.find("accordionSection");
    $A.util.toggleClass(toggleGrowerAccounts, "toggle");    
    $A.util.toggleClass(accordionChange, 'slds-is-close');
    $A.util.toggleClass(accordionChange, 'slds-is-open');
  },
    handleSelectChangeEvent: function(component, event, helper) {
        console.log("==== I am here event propogation");
        var items = event.getParam("values");
        var selectedItem='';
        console.log("console output" +items);
        for(var i in items){
            selectedItem = selectedItem +items[i] ;
        }
        //component.set("v.selectedItem",selectedItem);
        if(event.getParam("selectedId")){
             var slectedElem = document.getElementById(event.getParam("selectedId")+"itemsSelected");
            	slectedElem.innerHTML = selectedItem;
        }
        
       
    }
})