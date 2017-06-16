({
    init: function() {},
    update: function(component) {
        var tabClass = component.get("v.tabClass") || null;
        if (tabClass) {
            component.set("v.gen_class", tabClass);
        } else {
            var active = component.get("v.active") || false;
            var clas = component.get("v.class") || null;
            var gen_class = "slds-tabs__content";
            gen_class += active ? " slds-show" : " slds-hide";
            gen_class += clas ? " " + clas : "";
            component.set("v.gen_class", gen_class);
        }
    }
});