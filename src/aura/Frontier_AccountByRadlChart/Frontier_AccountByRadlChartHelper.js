({
    loadAccDashData : function(component, event){
        var action = component.get("c.getAccountRadl");
        action.setParams({
            //crop : component.get("v.crop"),
            season : component.get("v.season"),
            accType : component.get("v.accType")
        });
        var developAccCount = [];
        var acqAccCount = [];
        var retainAccCount = [];
        var lightAccCount = [];
        var accCoverageLbl = [];
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var accCoverageRADL = (JSON.parse(response.getReturnValue()));
                accCoverageLbl= accCoverageRADL.accRADLLblSet;
                component.set("v.accCoverageLbl",accCoverageLbl);
                if(!accCoverageRADL.accountRadlperMap.hasOwnProperty('Develop')){
                    
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accountRadlperMap.hasOwnProperty('Acquire')){
                    
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accountRadlperMap.hasOwnProperty('Retain')){
                    
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.accountRadlperMap.hasOwnProperty('Light Touch')){
                  lightAccCount.push(0);
                }
                
                for(var key in accCoverageRADL.accountRadlperMap){
                    
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accountRadlperMap[key]);
                        
                    }
                    if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accountRadlperMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accountRadlperMap[key]);
                        
                    }                 
                    
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accountRadlperMap[key]);
                    }
                }
                if(!accCoverageRADL.accPgmRadlpercMap.hasOwnProperty('Develop')){
                    
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accPgmRadlpercMap.hasOwnProperty('Acquire')){
                    
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accPgmRadlpercMap.hasOwnProperty('Retain')){
                    
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.accPgmRadlpercMap.hasOwnProperty('Light Touch')){
                    
                    lightAccCount.push(0);
                }	
                for(var key in accCoverageRADL.accPgmRadlpercMap){
                    
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accPgmRadlpercMap[key]);
                        
                    }
                    if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accPgmRadlpercMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accPgmRadlpercMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accPgmRadlpercMap[key]);
                    }
                }
                if(!accCoverageRADL.accTouchRadlpercMap.hasOwnProperty('Develop')){
                    
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accTouchRadlpercMap.hasOwnProperty('Acquire')){
                    
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accTouchRadlpercMap.hasOwnProperty('Retain')){
                    
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.accTouchRadlpercMap.hasOwnProperty('Light Touch')){
                    
                    lightAccCount.push(0);
                }
                for(var key in accCoverageRADL.accTouchRadlpercMap){
                    
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accTouchRadlpercMap[key]);
                        
                    }
                    if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accTouchRadlpercMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accTouchRadlpercMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accTouchRadlpercMap[key]);
                    }
                }
                
                if(!accCoverageRADL.TpcountpercRadlMap.hasOwnProperty('Develop')){
                    
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.TpcountpercRadlMap.hasOwnProperty('Acquire')){
                    
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.TpcountpercRadlMap.hasOwnProperty('Retain')){
                    
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.TpcountpercRadlMap.hasOwnProperty('Light Touch')){
                    
                    lightAccCount.push(0);
                }
                for(var key in accCoverageRADL.TpcountpercRadlMap){
                    
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.TpcountpercRadlMap[key]);
                        
                    }
                    if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.TpcountpercRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.TpcountpercRadlMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.TpcountpercRadlMap[key]);
                    }
                }
                
                if(!accCoverageRADL.avgVisitRadlperMap.hasOwnProperty('Develop')){
                    
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.avgVisitRadlperMap.hasOwnProperty('Acquire')){
                    
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.avgVisitRadlperMap.hasOwnProperty('Retain')){
                    
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.avgVisitRadlperMap.hasOwnProperty('Light Touch')){
                    
                    lightAccCount.push(0);
                }
                for(var key in accCoverageRADL.avgVisitRadlperMap){
                    
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.avgVisitRadlperMap[key]);
                        
                    }
                    if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.avgVisitRadlperMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.avgVisitRadlperMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.avgVisitRadlperMap[key]);
                    }
                }
                component.set("v.dtypecount",developAccCount);
                component.set("v.acqtypecount",acqAccCount);
                component.set("v.rtypecount",retainAccCount);
                component.set("v.ltypecount",lightAccCount);
                
                
            } else if (response.getState() === "ERROR") {
                
                console.log('Errors', response.getError());
            }
            var data = {
                //labels: salesDetailJson.Labels,
                //labels:["Total","Visit"],
                labels:component.get("v.accCoverageLbl"),
                datasets: [
                    {
                        label : "Develop",
                        backgroundColor: "rgb(17, 135, 48)",
                        hoverBackgroundColor: "rgba(50,90,100,1)",
                        data:component.get("v.dtypecount")
                        // data: salesDetailJson.orderData
                    },
                    {
                        label : "Acquire",
                        backgroundColor: "rgb(237, 168, 49)",
                        hoverBackgroundColor: "rgba(140,85,100,1)",
                        //data: [acquire]
                        data:component.get("v.acqtypecount")
                        //data: salesDetailJson.orderData
                    },
                    {
                        label : "Retain",
                        backgroundColor: "rgb(252, 208, 171)",
                        hoverBackgroundColor: "rgba(46,185,235,1)",
                        data:component.get("v.rtypecount")
                        //data: salesDetailJson.orderData
                    },
                    {
                        label : "Light Touch",
                        backgroundColor: "rgb(127, 205, 239)",
                        hoverBackgroundColor: "rgba(46,185,235,1)",
                        data:component.get("v.ltypecount")
                    }
                ]};
            
            var options = {
                responsive : true,
                curvature: 0.5,            
                overlayBars: true,          
                bezierCurve : false,
                
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
                hover: {
                    mode: true,
                    animationDuration: 0
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var radlValPer = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%';
                            var RadlLbl = data.datasets[tooltipItem.datasetIndex].label;
                            if(data.labels[tooltipItem.index] == 'Accounts'){
                                var RadlVal =  [accCoverageRADL.accountRadlMap.hasOwnProperty(RadlLbl) ? accCoverageRADL.accountRadlMap[RadlLbl] : 0];
                            }
                            if(data.labels[tooltipItem.index] == 'Accounts with Program'){
                                var RadlVal =  [accCoverageRADL.accPgmRadlMap.hasOwnProperty(RadlLbl) ? accCoverageRADL.accPgmRadlMap[RadlLbl] : 0];
                            }
                            if(data.labels[tooltipItem.index] == 'Accounts Visited'){
                                var RadlVal =  [accCoverageRADL.accTouchRadlMap.hasOwnProperty(RadlLbl) ? accCoverageRADL.accTouchRadlMap[RadlLbl] : 0];
                            }
                            if(data.labels[tooltipItem.index] == 'Total Visits'){
                                var RadlVal =  [accCoverageRADL.TouchpointcountRadlMap.hasOwnProperty(RadlLbl) ? accCoverageRADL.TouchpointcountRadlMap[RadlLbl] : 0];
                            }
                            if(data.labels[tooltipItem.index] == 'Avg Visits'){
                                var RadlVal =  [accCoverageRADL.avgVisitRadlMap.hasOwnProperty(RadlLbl) ? accCoverageRADL.avgVisitRadlMap[RadlLbl] : 0];
                            }
                            var tooltipArray = [];
                            tooltipArray.push(RadlLbl+ ':'+' ' +radlValPer);
                            tooltipArray.push('Count :'+' '+RadlVal);

                            return tooltipArray;
                        }
                    }
                },
                scales: {
                    xAxes: [{
                        gridLines: {
                            display:false
                        },
                        barPercentage : 0.5,
                        categoryPercentage :0.5,
                        
                        stacked : true
                        
                    }],
                    yAxes: [{
                        gridLines: {
                            display:true 
                        },
                        display: true,
                        //barPercentage : 0.5,
                        //categoryPercentage :0.4,
                        
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
                            //var accountchartbyRADL = 'myChartaccountRADL'+component.get("v.season")+component.get("v.crop");
                            
                            var el = document.getElementById("myChartaccountRADL");
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
                            
                            }); 
                            $A.enqueueAction(action);
                            }
                            });