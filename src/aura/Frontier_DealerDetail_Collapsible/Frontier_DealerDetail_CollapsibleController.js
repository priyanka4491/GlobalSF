({
	toggle : function(component, event, helper) {
    var toggleGrowerAccounts = component.find("GrowerAccounts");
    var accordionChange = component.find("accordionSection");
    $A.util.toggleClass(toggleGrowerAccounts, "toggle");    
    $A.util.toggleClass(accordionChange, 'slds-is-close');
    $A.util.toggleClass(accordionChange, 'slds-is-open');
    },
    doInit :function(component, event, helper){
        var myOpts = [];
        myOpts.push({'label':'All','value':'All'});
        myOpts.push({'label':'One','value':'One'});
        myOpts.push({'label':'Two','value':'Two'});
        component.set("v.myOptions",myOpts);   
    }
})