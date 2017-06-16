({
    loadPgmChart : function(component,event,helper) {        
        console.log('Inside chartHelp');
        var allocated =component.get("v.allocated");
        var available =component.get("v.available");
        var consumed = component.get("v.consumed");
        console.log(allocated + ' ' + available+''+consumed);
        var dataSet=[];
        var labels=[];
        var progChart;
        if((component.get("v.identifier"))==5){
          progChart = 'myChart'+component.get("v.identifier")+component.get("v.programId");  
        }
        else{
        progChart = 'myChart'+component.get("v.identifier");
        }
        console.log(progChart + 'progChart');
        var el = document.getElementById(progChart);
        console.log(el + 'el');
        var context = el.getContext('2d');
        if((component.get("v.identifier")) == 1){
            console.log('identifier 1');
            dataSet = [component.get("v.allocated"),((component.get("v.available")) == 'NA'? 0 :  parseInt(component.get("v.available"))),component.get("v.consumed")];
            //labels = [component.get("v.allocated"),component.get("v.available")];
            labels =['Allocated','Available', 'Consumed'];
            var centext = "Budget";
            console.log(dataSet + 'dataset1');
            console.log(labels + 'labels1');
        }
        else if((component.get("v.identifier")) == 2){
            console.log('identifier 2');
            dataSet = [component.get("v.cancelled"),component.get("v.completed"),component.get("v.notStarted"),component.get("v.inExecution")];
            //labels = [component.get("v.cancelled"),component.get("v.completed"),component.get("v.notStarted"),component.get("v.inExecution")];
            labels =['Cancelled','Completed','Not Started','In Execution'];
            var centext = "Execution";
            console.log(dataSet + 'dataset2');
            console.log(labels + 'labels2');
        }
            else if((component.get("v.identifier") == 3)){
                console.log('identifier 3');
                dataSet = [component.get("v.planned"),component.get("v.postPlanned")];
                //labels = [component.get("v.planned"),component.get("v.postPlanned")];
                labels =['Planned','Post Planned'];
                var centext = "Planning";
                console.log(dataSet + 'dataset');                
            }
                else if((component.get("v.identifier") == 4)){
                    console.log('identifier 4');
                    dataSet = [component.get("v.product1"),component.get("v.product2"),component.get("v.product3")];
                    //labels = [component.get("v.product1"),component.get("v.product2"),component.get("v.product3")];
                    labels =['Product1','Product2','Product3'];
                    var centext = "Accts.using Prod.";
                    console.log(dataSet + 'dataset');                
                }
                   else if((component.get("v.identifier") == 5)){
                    console.log('identifier 5');
                    dataSet = [component.get("v.product1"),component.get("v.product2"),component.get("v.product3")];
                    //labels = [component.get("v.product1"),component.get("v.product2"),component.get("v.product3")];
                    labels =['Product1','Product2','Product3'];
                    var centext = "Accts.using Prod.";
                    console.log(dataSet + 'dataset');                
                }
                    
        
        
        var data = {
            //labels: ['Product 1<br /><span style="Padding-left:24%;">Programs:'+component.get("v.program1")+'</span>','Product 2 <br /><span style="Padding-left:24%"> Programs:'+component.get("v.program2")+'</span>','Product 3 <br /> <span style="Padding-left:24%"> Programs:'+component.get("v.program3")+'</span>'],
            
            labels: labels,
            
            
            
            //labels: ['Product 1','Product 2','Product 3'],
            datasets: [
                {
                    data: dataSet,
                    backgroundColor: [
                        "#f5f5f5",
                        "#A0A0A0",
                        "#3299CC",
                        "#FFCC00"
                    ]
                }]
        };
        
        var options = {
            showAllTooltips: false,
            segmentShowStroke: false,
            responsive : true,
            animateRotate: true,
            animateScale: false,
            //cutoutPercentage: 80,
            legend: {
                display : false,
                position:'right'
            },
            
            
            hover: {
                onHover: null,
                mode: 'single',
                animationDuration:0
            },
            animation: {
                duration: 0,
                onComplete: function () {
                    var self = this,
                        chartInstance = this.chart,
                        ctx = chartInstance.ctx;
                    
                    ctx.font = '10px Arial';
                    ctx.textAlign = "center";
                    var width = this.chart.width;
                    var height = this.chart.height;
                    
                    
                    var x = this.chart.canvas.clientWidth / 2;
                    var y = this.chart.canvas.clientHeight / 2;
                    
                    //fill center chart color
                    
                    ctx.beginPath();
                    this.chart.ctx.arc(x,y,40,0,2*Math.PI);
                    ctx.fillStyle = '#ffffff';
                    ctx.fill();
                    
                    //render text in the middle of the chart
                    var textX = width / 2,   
                        textY = height / 2;
                    console.log('text' + textX + ' ' + textY);
                    ctx.fillStyle ='black';
                    ctx.textBaseline = "middle"; 
                    ctx.fillText(centext, textX, textY);
                    
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
                        
                        wrapText(ctx,dataset.data[idx],dx,dy,8,3);
                    }
                        
                        // centrText(ctx,textcentr,textX,textY);
                    }), self);
                        
                        function wrapText(context, text, x, y, maxWidth, lineHeight) {
                        var line=" ";
                        line = text;
                        context.fillStyle='black';
                        context.fillText(line, x, y+3);   
                    }
                        
                    }
                    },
                        
                        tooltips: {
                            enabled:false,
                        }
                    }
                    var canvas = document.getElementById(progChart);
                    console.log(canvas + 'el');
                    var ctx = canvas.getContext('2d');
                    console.log(ctx + 'ctx');
                    ctx.canvas.width=300;
                    ctx.canvas.height=100;
                    var pgmDChart = new Chart(ctx, {
                        type: 'doughnut',
                        data: data,
                        options:options
                        
                    });
                    var pgmlegendId;
                    if((component.get("v.identifier"))==5){
                        pgmlegendId= 'chartLegend1'+component.get("v.identifier")+component.get("v.programId");
                    }
                    else{
                     pgmlegendId = 'chartLegend1'+ component.get("v.identifier");
                    }
                    console.log('legend' + component.get("v.comp"));
                    document.getElementById(pgmlegendId).innerHTML = pgmDChart.generateLegend();
                    $A.util.addClass(component.find(pgmlegendId),'chart-lgnd1');
                }
            })