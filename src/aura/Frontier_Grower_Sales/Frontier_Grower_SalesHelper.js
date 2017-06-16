({
    loadChartData : function(component){
        
        var data = {
            //labels: salesDetailJson.Labels,
            labels:["Corn", "Soy", "Cotton"],
            datasets: [
                {
                    label : "PY Sales",
                    type : "horizontalBar",
                    backgroundColor: "rgb(17, 135, 48)",
                    
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    data: (component.get("v.CropData") == 'General' || component.get("v.CropData") == 'Corn'?[30000, 40000, 10000]:[40000, 30000, 20000])
                    // data: salesDetailJson.orderData
                },
                {
                    label : "Other Monsanto Brand/License sales",
                    type : "horizontalBar",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    data: (component.get("v.CropData") == 'General' || component.get("v.CropData") == 'Corn'? [40000,10000,20000]:[30000,20000,10000]),
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Opportunity",
                    type : "horizontalBar",
                    backgroundColor: "rgb(201, 197, 191)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data: (component.get("v.CropData") == 'General' || component.get("v.CropData") == 'Corn'?[1000,20000,1000]:[2000,10000,2000])
                    //data: salesDetailJson.orderData
                }
            ]};
        
            var options = {
            responsive : true,
            curvature: 0.5,            
            overlayBars: true,          
            bezierCurve : false,
            animation:false,
            legend: {
                display:true,
                position:'bottom',
                labels: {
                    fontColor: 'black'
                }
            },
            scaleLabel:{
                display:false
            },           
            scales: {
                xAxes: [{
                    gridLines: {
                        display:false
                    },
                    barPercentage : 25,
                    stacked : true
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:false,
                        color: "#fff",
                        
                    },
                    display: true,
                    barPercentage : 25,                    
                    //barThickness : 20,
                    ticks: {
                    // minimum will be 0, unless there is a lower value.
                    suggestedMin: 0,
                    // minimum value will be 0.
                    beginAtZero: true
                },
                        stacked : true
                        }]
            }
        };
        
        var el = document.getElementById("myChart");
        var ctx = el.getContext("2d");
        var myBarChart1 = new Chart(ctx, {
            type: 'horizontalBar',
            data: data,
            options: options
        });
        window.onresize=function() {
            myBarChart1.resize();
        };
        
    }

});