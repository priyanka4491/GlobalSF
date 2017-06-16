({
    loadChart : function(component,event){
        console.log('Inside chart');
        var bchart = 'myChart'+component.get("v.accId");
        //var bchart = 'myChart'+'0012C000002MJjfQAG';
        //console.log("Inside chart load" + bchart);
        var data = {
            labels:[""],
            datasets: [
                {
                    label : "CY",
                    type : "horizontalBar",
                    backgroundColor: "#646666",    
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    data: [100]
                },
                {
                    label : "PY",
                    type : "horizontalBar",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    data:  [300]
                },
                {
                    label : "Opp acre",
                    type : "horizontalBar",
                    backgroundColor: "rgb(201, 197, 191)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data: [500]
                }
            ]};
        
            var options = {
            responsive : false,
            maintainAspectRatio: true,
            curvature: 0.5,            
            overlayBars: true,          
            bezierCurve : false,
            animation:false,
            tooltip:false,
            scaleLabel:{
                display:false
            },
            legend:{
                display: false
                },    
            scales: {
                xAxes: [{
                    display:false,
                    stacked: true,
                    gridLines: {
                        display:false
                    },
                    barPercentage : 0.2
                    
                }],
                yAxes: [{
                    stacked: true,
                    display:false,
                    gridLines: {
                        display:false,
                        color: "#fff"    
                    },
                    display: true,
                    barPercentage : 0.5,                   
                    ticks: {
                    // minimum will be 0, unless there is a lower value.
                    suggestedMin: 0,
                    // minimum value will be 0.
                    beginAtZero: true
                }
                      
                        }]
            }
        };
        
        var el = document.getElementById(bchart);
        //var el = component.find(bchart);
        var ctx = el.getContext("2d");
        ctx.canvas.width=200;
        ctx.canvas.height=30; 
        console.log(ctx.canvas.width + "Width");
        //var lineBar = document.getElementById("line-bar").getContext("2d");
        var myBarChart1 = new Chart(ctx, {
            type: 'horizontalBar',
            data: data,
            options: options
        });
        //var myLineBarChart = new Chart(lineBar).LineBar(data);

    }
});