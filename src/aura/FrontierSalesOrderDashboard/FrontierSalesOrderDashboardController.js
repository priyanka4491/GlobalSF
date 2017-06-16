({
    // Draw the chart on the canvas based on the respective account
    loadChart: function(component, event, helper) {
       helper.loadChartData(component);
    },
    // Draw the chart with respect to the crop upon clicking it
    getCropDetails : function(component, event, helper) {
        if(!$A.util.isEmpty(event.target.id)){
            component.set("v.CropData",event.target.id);
            var itemNode = document.getElementById('myChart');
            itemNode.parentNode.removeChild(itemNode);
            document.getElementById('chartDiv').innerHTML = '<canvas id="myChart"></canvas>';
            helper.loadChartData(component);
        }
     }
});