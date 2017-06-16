({
	loadSalesdashboard : function(component,event){
        var radlCoverage = component.get("v.radlCoverage");
        var chartIdentfier = component.get("v.chartIdentifier");
        //debugger
		var data = {            
                        labels:['# Accounts','Programs Planned','AVG Programs'],

            datasets: [
                {
                    label : "Develop",                    
                    backgroundColor: "rgb(17, 135, 48)",
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    
                    data:[ String((radlCoverage[chartIdentfier].totalCoverageMap['Develop']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].totalCoverageMap['Develop']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].totalCoverageMap['Develop'].split(':')[1]),
                         
                    	  String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Develop']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Develop']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Develop'].split(':')[1]),
                         
                         String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Develop']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Develop']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Develop'].split(':')[1])
                    ] 
                  
                },
                {
                    label : "Acquire",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    data:[String((radlCoverage[chartIdentfier].totalCoverageMap['Acquire']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].totalCoverageMap['Acquire']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].totalCoverageMap['Acquire'].split(':')[1]),
                          
                     String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Acquire']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Acquire']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Acquire'].split(':')[1]),
                    
                     String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Acquire']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Acquire']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Acquire'].split(':')[1])]
                        
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Retain",
                    backgroundColor: "rgb(252, 208, 171)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data:[
                       
                        String((radlCoverage[chartIdentfier].totalCoverageMap['Retain']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].totalCoverageMap['Retain']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].totalCoverageMap['Retain'].split(':')[1]),
                         
                        String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Retain']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Retain']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Retain'].split(':')[1]),
                       
                    
                    String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Retain']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Retain']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Retain'].split(':')[1])]
                    
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Light Touch",
                    backgroundColor: "rgb(127, 205, 239)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data:[String((radlCoverage[chartIdentfier].totalCoverageMap['Light Touch']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].totalCoverageMap['Light Touch']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].totalCoverageMap['Light Touch'].split(':')[1]),
                         
                         String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Light Touch']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Light Touch']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAccountMap['Light Touch'].split(':')[1]),
                        
                         String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Light Touch']).indexOf(':')) == -1?
                          0 : isNaN(String((radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Light Touch']).indexOf(':')))? 
                          0 : parseFloat(radlCoverage[chartIdentfier].plannedProgramAllocatedAvgMap['Light Touch'].split(':')[1])                        
                        ]
                },
                {
                    label : "No Program",                    
                    backgroundColor: "white",
                    borderColor: 'black',
                    borderWidth: 1,
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    data:[radlCoverage[chartIdentfier].totalCoverageMap.hasOwnProperty('No Program') && String((radlCoverage[chartIdentfier].totalCoverageMap['No Program']).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].totalCoverageMap['No Program'].split(':')[1]) : 0,0,0]
                }
            ]};
        
            var options = {
            responsive : true,
            curvature: 0.5,            
            overlayBars: true,          
            bezierCurve : false,
     /*  animation: {
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
                        ctx.fillStyle = 'black';
                        var y_pos = model.y + 20;
                        
                        if ((scale_max - model.y) / scale_max >= 0.93)
                            y_pos = model.y + 20; 
                        var dataVar;
                        var unit;
                       if(model.label == 'Current Sales'){
                           unit =  [String((radlCoverage[chartIdentfier].currentSalesMap[dataset.label]).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].currentSalesMap[dataset.label].split(':')[0]) : 0];
                        
                            var combineText = unit == '0' ? '300 $' : unit + '$';
                           dataVar = dataset.data[i] +'%';
                            if(dataset.data[i] > 0){
                        ctx.fillText(combineText, model.x, y_pos+15);
                                ctx.fillText(dataVar, model.x, y_pos);
                        }
                        }
                        if(model.label == '# Accounts'){
                            unit = String((radlCoverage[chartIdentfier].totalCoverageMap[dataset.label]).indexOf(':') != -1 ) ? 
            			  parseInt(radlCoverage[chartIdentfier].totalCoverageMap[dataset.label].split(':')[0]) : 0;
                           dataVar = dataset.data[i] +'%';
                            if(dataset.data[i] > 0.0){
                        ctx.fillText(unit, model.x, y_pos+15);
                                ctx.fillText(dataVar, model.x, y_pos);
                        }
                        }
                        else{                       
                        
                        dataVar = dataset.data[i] +'%';
                            if(dataset.data[i] > 0.0){
                        ctx.fillText(dataVar, model.x, y_pos);
                            }
                        }
                    }
                });               
            }
        },
               
            */
  
                
                
      
          legend: {
                display:true,
                position:'bottom',
                labels: {
                    fontColor: 'black'
                }
            },
                showTooltips: false,
            scaleLabel:{
                display:false
            }, 
                hover: {
    mode: false,
    animationDuration: 0
  },
              tooltips: {
                 
         callbacks: {
    label: function(tooltipItem, data) {
      var dataset = data.datasets[tooltipItem.datasetIndex];
      var currentValue = dataset.data[tooltipItem.index];    

        var unit,dataVar;
        var dataVar = [];
        if(data.labels[tooltipItem.index] == '# Accounts'){
                          unit = String((radlCoverage[chartIdentfier].totalCoverageMap[dataset.label]).indexOf(':') != -1 ) ? 
            			  parseFloat(radlCoverage[chartIdentfier].totalCoverageMap[dataset.label].split(':')[0]) : 0;
                        
            currentValue = dataset.label +':' + currentValue +'%';
                            if(dataset.data[tooltipItem.index] > 0){
                                dataVar.push(currentValue);
                                dataVar.push('Count :'+unit);
                                return dataVar;
                          }
                        }                       
                        else{
                        currentValue = dataset.label +':' + currentValue +'%';                        
                        if(dataset.data[tooltipItem.index] > 0){
                        return currentValue;
                        }
                        }
 
    }
  }          
              
              
              
              },
               scaleLineColor: 'rgba(0,0,0,0)',
               
            scales: {
                xAxes: [{
                    gridLines: {
                        display:false,
                        drawBorder: false
                    },
                    categoryPercentage :0.4,
                    barPercentage : 1.0,                    
                    stacked : true,
                    
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
                        stacked : true
                        },
                       ]        
            }
        };
        
        var el = document.getElementById(component.get("v.chartIdentifier"));
        var ctx = el.getContext("2d");
            ctx.canvas.height=400;
            ctx.canvas.width=1300;
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