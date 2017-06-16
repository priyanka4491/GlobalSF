({
	/*doInit : function(component, event, helper) {
     var data = [0,25,50,75,100];
        component.set("v.CropData",data);
        var labels = ['2017','2018','2019','2010'];
        component.set("v.label",labels);
        component.set("v.KPIMeasure","Sales Order By Crop");
    },*/
    loadChart: function(component, event, helper) {
       helper.loadChartData(component, event, helper);
    }
})