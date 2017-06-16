({
    loadChartData : function(component){
        if(component.isValid()){
            Console.log(JSON.stringify(component.get("v.SalesDetailResponse")));
            var action = component.get("c.AccountDetails");
            action.setParams({
            CropType : component.get("v.CropData"),
            result : component.get("v.SalesDetailResponse"),
            accId : component.get("v.accId")    
            });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var salesDetailJson = JSON.parse(response.getReturnValue());
                component.set("v.SalesOrder",salesDetailJson);
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
            }
            var data = {
            labels: salesDetailJson.Labels,
            datasets: [
                {
                label : "Sales",
                type : "bar",
                fillColor: "rgba(220,220,220,0.5)",
                backgroundColor: 'rgba(38, 95, 43, 1)',
                borderColor: '#71B37C',
                hoverBackgroundColor: 'rgba(38, 95, 43, 1)',
                hoverBorderColor: '#71B37C',
                data: salesDetailJson.orderData
            }
     ]};
     var options = {
                    responsive : true,
                    barValueSpacing: 1,
                    overlayBars: true,
                    bezierCurve : false,
                    animation:false,
         legend: {
             display:true,
             position:'right',
             labels: {
                 fontColor: 'black'
             }
         },
         scales: {
             xAxes: [{
                 gridLines: {
                     display:false
                 }
             }],
             yAxes: [{
                 gridLines: {
                     display:false
                 },
                 display: true,
                 ticks: {
                     // minimum will be 0, unless there is a lower value.
                     suggestedMin: 0,
                     // minimum value will be 0.
                     beginAtZero: true
                 }
             }]
         }
     };
     var el = document.getElementById("myChart");
     var ctx = el.getContext("2d");
     var myBarChart1 = new Chart(ctx, {
         type: 'bar',
         data: data,
         options: options
     });
     window.onresize=function() {
         myBarChart1.resize();
     };
     });
     $A.enqueueAction(action);
     }
    }
});