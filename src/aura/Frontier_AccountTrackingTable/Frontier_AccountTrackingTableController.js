({
    doInit : function(component, event, helper){
        helper.createTrackingTable(component);
    },
    jsLoaded : function(component, event, helper){
        helper.drawChart(component);
    }
});