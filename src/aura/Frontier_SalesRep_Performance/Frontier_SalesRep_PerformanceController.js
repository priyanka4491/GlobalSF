({
    loadChart : function(component,event){
        console.log('Inside chart');
        var bchart = "myChart";
        //var bchart = 'myChart'+'0012C000002MJjfQAG';
        console.log("Inside chart load" + bchart);
        var data = {
            labels: ['778,923 YTD Volume'],

            datasets: [
                {
                    
                    type : "horizontalBar",
                    backgroundColor: "#32CD32",
                    data: [100]
                },
                {
                    
                    type : "horizontalBar",
                    backgroundColor: "rgb(237, 168, 49)",
                    data:  [100]
                }
               
            ]};
        
            var options = {
            responsive : true,
            maintainAspectRatio: false,
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
            },
             animation: {
                duration: 0,
                onComplete: function () {
                    var self = this,
                        chartInstance = this.chart,
                        ctx = chartInstance.ctx;
                    
                    ctx.font = '10px Arial';
                    ctx.textAlign = "center";
                    ctx.fillStyle = "White";
                    
                    Chart.helpers.each(self.data.datasets.forEach((dataset, datasetIndex) => {
                        var meta = self.getDatasetMeta(datasetIndex),
                        total = 0, //total values to compute fraction
                        labelxy = [],
                        offset = Math.PI / 2, //start sector from top
                        radius,
                        centerx,
                        centery, 
                        lastend = 0; //prev arc's end line: starting with 0
                        
                        for (var val of dataset.data) { total += val; } 
                                                                  
                        Chart.helpers.each(meta.data.forEach((element, index) => {
                        radius = element._model.outerRadius;
                        centerx = element._model.x;
                        centery = element._model.y;
                        var thispart = dataset.data[index],
                        arcsector = Math.PI * (2 * thispart / total);
                        if (element.hasValue() && dataset.data[index] > 0) {
                        labelxy.push(lastend + arcsector / 2 + Math.PI + offset);
                    }
                        else {
                        labelxy.push(-1);
                    }
                        lastend += arcsector;
                    }), self)
                        
                        var lradius = radius * 3 / 4;
                        for (var idx in labelxy) {
                        if (labelxy[idx] === -1) continue;
                        var langle = labelxy[idx],
                        dx = centerx + lradius * Math.cos(langle),
                        dy = centery + lradius * Math.sin(langle),
                        val = Math.round(dataset.data[idx] / total * 100);
                        
                        //ctx.fillText(self.data.labels[idx],dx, dy);
                        wrapText(ctx,self.data.labels[idx],dx,dy,8,3);
                        console.log('dx=>'+dx);
                        console.log('dy=>'+dy);
                        //ctx.fillText(dataset.data[idx], dx, dy);
                    }
                        
                    }), self);
                        
                        function wrapText(context, text, x, y, maxWidth, lineHeight) {
                        	var cars = text.split("\n");
                            
                            for (var ii = 0; ii < cars.length; ii++) {
                            
                            var line = "";
                            var words = cars[ii].split(" ");
                            
                            for (var n = 0; n < words.length; n++) {
                            var testLine = line + words[n] + " ";
                            var metrics = context.measureText(testLine);
                            var testWidth = metrics.width;
                            
                                if (testWidth > maxWidth) {
                                    context.fillText(line, x, y);
                                    line = words[n] + " ";
                                    y += lineHeight;
                                }
                                    else {
                                    line = testLine;
                                }
                            }
                            
                            context.fillText(line, x, y);
                            y += lineHeight;
                        }
                    }
            	}
           	}
                        
        };
        
        var el = document.getElementById(bchart);
        //var el = component.find(bchart);
        var ctx = el.getContext("2d");
        //ctx.canvas.width=600;
        ctx.canvas.height=60; 
        //console.log(ctx.canvas.width + "Width");
        //var lineBar = document.getElementById("line-bar").getContext("2d");
        var myBarChart1 = new Chart(ctx, {
            type: 'horizontalBar',
            data: data,
            options: options
        });
        //var myLineBarChart = new Chart(lineBar).LineBar(data);

    }
});