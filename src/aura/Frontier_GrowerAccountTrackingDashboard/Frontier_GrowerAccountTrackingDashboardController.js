({
    doInit : function(component, event,helper) {
        var nDay = 6;
        $A.util.addClass(component.find('accnt1'), 'bgBlue');
        $A.util.removeClass(component.find('svg1'),'hidedisplay');
        $A.util.addClass(component.find('svg1'),'display');
        $A.util.removeClass(component.find('svg2'),'hidedisplay');
        $A.util.addClass(component.find('svg2'),'display');
        $A.util.removeClass(component.find('svg3'),'hidedisplay');
        $A.util.addClass(component.find('svg3'),'display');
        $A.util.removeClass(component.find('svg4'),'hidedisplay');
        $A.util.addClass(component.find('svg4'),'display');
        component.set("v.buttonshow","true");
        helper.getLastData(component, nDay);
    },
    getLast7Days : function(component,event,helper) {
        var nDay = 6;
        $A.util.addClass(component.find('accnt1'),'bgBlue');
        $A.util.removeClass(component.find('accnt2'),'bgBlue');
        $A.util.removeClass(component.find('svg1'),'hidedisplay');
        $A.util.addClass(component.find('svg1'),'display');
        $A.util.removeClass(component.find('svg2'),'hidedisplay');
        $A.util.addClass(component.find('svg2'),'display');
        $A.util.removeClass(component.find('svg3'),'hidedisplay');
        $A.util.addClass(component.find('svg3'),'display');
        $A.util.removeClass(component.find('svg4'),'hidedisplay');
        $A.util.addClass(component.find('svg4'),'display');
        if(component.get("v.buttonshow")){
            component.set("v.buttonshow","false");
        }
        helper.getLastData(component, nDay);
    },
    getLast30Days : function(component, event, helper) {
        var nDay = 29;
        $A.util.addClass(component.find('accnt2'), 'bgBlue');
        $A.util.removeClass(component.find('accnt1'), 'bgBlue');
        $A.util.removeClass(component.find('svg1'),'hidedisplay');
        $A.util.addClass(component.find('svg1'),'display');
        $A.util.removeClass(component.find('svg2'),'hidedisplay');
        $A.util.addClass(component.find('svg2'),'display');
        $A.util.removeClass(component.find('svg3'),'hidedisplay');
        $A.util.addClass(component.find('svg3'),'display');
        $A.util.removeClass(component.find('svg4'),'hidedisplay');
        $A.util.addClass(component.find('svg4'),'display');
        component.set("v.buttonshow","false");
        helper.getLastData(component, nDay);
    }
});