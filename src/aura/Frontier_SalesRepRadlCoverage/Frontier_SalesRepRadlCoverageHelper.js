({
	loadSalesdashboard : function(component,event){
        var radlCoverage = component.get("v.radlCoverage");
        var chartIdentfier = component.get("v.chartIdentifier");
       
        //debugger
		var data = {            
            labels:['RADL coverage'],
            datasets: [
                {
                    label : "Develop",                    
                    backgroundColor: "rgb(17, 135, 48)",
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    
                    data:[String((radlCoverage[chartIdentfier].radlCoverageSalesMap['Develop']).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].radlCoverageSalesMap['Develop'].split(':')[1]) : 0] 
                   
                    // data: salesDetailJson.orderData
                },
                {
                    label : "Acquire",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    //data: [acquire]
                    data:[String((radlCoverage[chartIdentfier].radlCoverageSalesMap['Acquire']).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].radlCoverageSalesMap['Acquire'].split(':')[1]) : 0] 
                    
                    //data: salesDetailJson.orderData
                },
                {
                   label : "Retain",
                    backgroundColor: "rgb(252, 208, 171)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data:[String((radlCoverage[chartIdentfier].radlCoverageSalesMap['Retain']).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].radlCoverageSalesMap['Retain'].split(':')[1]) : 0]
                    
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Light Touch",
                    backgroundColor: "rgb(127, 205, 239)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data:[String((radlCoverage[chartIdentfier].radlCoverageSalesMap['Light Touch']).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].radlCoverageSalesMap['Light Touch'].split(':')[1]) : 0]
                }
            ]};
        
            var options = {
            responsive : true,
            curvature: 0.5,            
            overlayBars: true,          
            bezierCurve : false,
       animation: {
            duration: 0,
            easing: "easeOutBack",
            onComplete: function () {
                var ctx = this.chart.ctx;
                ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontFamily, 'normal', Chart.defaults.global.defaultFontFamily);
                ctx.textAlign = 'center';
                ctx.textBaseline = 'bottom';

                this.data.datasets.forEach(function (dataset) {
                    for (var i = 0; i < dataset.data.length; i++) {
                        var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model,
                            scale_max = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._yScale.maxHeight;
                        ctx.fillStyle = '#ffffff';
                        var y_pos = model.y + 20;
                        // Make sure data value does not get overflown and hidden
                        // when the bar's value is too close to max value of scale
                        // Note: The y value is reverse, it counts from top down
                        if ((scale_max - model.y) / scale_max >= 0.93)
                            y_pos = model.y + 20; 
                        var dataVar = dataset.data[i] +'%'
                        ctx.fillText(dataVar, model.x, y_pos);
                    }
                });               
            }
        },
               
            
               
      
          legend: {
                display:false,
                position:'bottom',
                labels: {
                    fontColor: 'black'
                }
            },
            scaleLabel:{
                display:false
            }, 
              hover: {
    mode: false,
    animationDuration: 0
  },
              tooltips: {
                  enabled:false},
            scales: {
                xAxes: [{
                    gridLines: {
                        display:false,
                        drawBorder: false
                    },
                    barPercentage : 0.7,
                    categoryPercentage :0.5,                   
                    stacked : false
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:true 
                    },
                    display: false,
                    categoryPercentage :0.4,
                    //barPercentage : 1.0,                   
                    //barThickness : 20,
                    ticks: {
                  	suggestedMin: 0,
                    // minimum value will be 0.
                    beginAtZero: true
                  
              },
                        stacked : false
                        }
                        
                       ] 
                        
                        
                       
                        
                        
                        
            }
        };
        
        var el = document.getElementById('RadlCoverage');
        var ctx = el.getContext("2d");
             ctx.canvas.height=55;
            ctx.canvas.width=100;           
           //ctx.canvas.height=400;
           // ctx.canvas.width=1300;
        var myBarChart1 = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: options
        });        
        window.onresize=function() {
            myBarChart1.resize();
        };
            
}
        
    
	
})