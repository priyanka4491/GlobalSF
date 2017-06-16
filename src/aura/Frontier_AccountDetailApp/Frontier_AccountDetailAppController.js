({
    doInit : function(component, event, helper){
        var myOpts = [];
        myOpts.push({'label':'All','value':'All'});
        myOpts.push({'label':'One','value':'One'});
        myOpts.push({'label':'Two','value':'Two'});
        component.set("v.myOptions",myOpts); 
        
        $A.createComponent(
            "c:MultiSelect",
            {
                "aura:id":"my-multi-select",
                options:component.get("v.myOptions"),
                selectChange:component.getReference("c.handleSelectChangeEvent"),
                selectedItems:""
            },
            function(newCmp){
                var cmp = component.find("mul-select");
                cmp.set("v.body", newCmp);
            }
        );
    },
    
    showSpinner : function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "xc-hidden");
    },
    hideSpinner : function(component, event, helper){
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "xc-hidden");
    },
    handleSelectChangeEvent: function(component, event, helper) {
        var items = component.get("v.items");
        items = event.getParam("values");
        component.set("v.items", items);
    }
})