({
    loadAccDashData : function(component, event){
        var action = component.get("c.getRadlCoverage");
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
                //accCoverageLbl= accCoverageRADL.accRADLLblSet;
                //component.set("v.accCoverageLbl",accCoverageLbl);
               
                if(component.get("v.accType") == 'Partner'){
                    if(!accCoverageRADL.accRadldealerOppMap.hasOwnProperty('Develop')){
                       developAccCount.push(0);
                    }
                    if(!accCoverageRADL.accRadldealerOppMap.hasOwnProperty('Acquire')){
                       acqAccCount.push(0);
                    }
                    if(!accCoverageRADL.accRadldealerOppMap.hasOwnProperty('Retain')){
                        retainAccCount.push(0);
                    }
                    if(!accCoverageRADL.accRadldealerOppMap.hasOwnProperty('Light Touch')){
                        lightAccCount.push(0);
                    }
                    for(var key in accCoverageRADL.accRadldealerOppMap){
                        if(key == 'Develop'){
                            developAccCount.push(accCoverageRADL.accRadldealerOppMap[key]);
                        }
                        if(key == 'Acquire'){
                            acqAccCount.push(accCoverageRADL.accRadldealerOppMap[key]);
                        }
                        if(key == 'Retain'){
                            retainAccCount.push(accCoverageRADL.accRadldealerOppMap[key]);
                        }
                        if(key == 'Light Touch'){
                            lightAccCount.push(accCoverageRADL.accRadldealerOppMap[key]);
                        }
                    }
                    
                }                
                else if(component.get("v.accType") == 'Customer'){
                    if(!accCoverageRADL.accRadlgrowOppMap.hasOwnProperty('Develop')){
                       developAccCount.push(0);
                    }
                    if(!accCoverageRADL.accRadlgrowOppMap.hasOwnProperty('Acquire')){
                       acqAccCount.push(0);
                    }
                    if(!accCoverageRADL.accRadlgrowOppMap.hasOwnProperty('Retain')){
                        retainAccCount.push(0);
                    }
                    if(!accCoverageRADL.accRadlgrowOppMap.hasOwnProperty('Light Touch')){
                       lightAccCount.push(0);
                    }
                    for(var key in accCoverageRADL.accRadlgrowOppMap){
                        if(key == 'Develop'){
                            developAccCount.push(accCoverageRADL.accRadlgrowOppMap[key]);
                         }
                        if(key == 'Acquire'){
                            acqAccCount.push(accCoverageRADL.accRadlgrowOppMap[key]);
                        }
                        if(key == 'Retain'){
                            retainAccCount.push(accCoverageRADL.accRadlgrowOppMap[key]);
                        }
                        if(key == 'Light Touch'){
                            lightAccCount.push(accCoverageRADL.accRadlgrowOppMap[key]);
                        }
                    }
                } 
                else if(component.get("v.accType") == 'All Accounts'){
                    if(!accCoverageRADL.allaccRadlOppMap.hasOwnProperty('Develop')){
                        developAccCount.push(0);
                    }
                    if(!accCoverageRADL.allaccRadlOppMap.hasOwnProperty('Acquire')){
                        acqAccCount.push(0);
                    }
                    if(!accCoverageRADL.allaccRadlOppMap.hasOwnProperty('Retain')){
                        retainAccCount.push(0);
                    }
                    if(!accCoverageRADL.allaccRadlOppMap.hasOwnProperty('Light Touch')){
                        lightAccCount.push(0);
                    }
                    for(var key in accCoverageRADL.allaccRadlOppMap){
                        if(key == 'Develop'){
                            developAccCount.push(accCoverageRADL.allaccRadlOppMap[key]);
                        }
                        if(key == 'Acquire'){
                            acqAccCount.push(accCoverageRADL.allaccRadlOppMap[key]);
                        }
                        if(key == 'Retain'){
                            retainAccCount.push(accCoverageRADL.allaccRadlOppMap[key]);
                        }
                        if(key == 'Light Touch'){
                            lightAccCount.push(accCoverageRADL.allaccRadlOppMap[key]);
                        }
                    }
                }
            } 
            else if (response.getState() === "ERROR") {
                
                console.log('Errors', response.getError());
            }
            var data = {
                //labels: salesDetailJson.Labels,
                //labels:["Total","Visit"],
                labels:["RADL Coverage"],
                datasets: [
                    {
                        label : "Develop",
                        backgroundColor: "rgb(17, 135, 48)",
                        hoverBackgroundColor: "rgba(50,90,100,1)",
                        data:developAccCount
                        // data: salesDetailJson.orderData
                    },
                    {
                        label : "Acquire",
                        backgroundColor: "rgb(237, 168, 49)",
                        hoverBackgroundColor: "rgba(140,85,100,1)",
                        //data: [acquire]
                        data:acqAccCount
                        //data: salesDetailJson.orderData
                    },
                    {
                        label : "Retain",
                        backgroundColor: "rgb(252, 208, 171)",
                        hoverBackgroundColor: "rgba(46,185,235,1)",
                        data:retainAccCount
                        //data: salesDetailJson.orderData
                    },
                    {
                        label : "Light Touch",
                        backgroundColor: "rgb(127, 205, 239)",
                        hoverBackgroundColor: "rgba(46,185,235,1)",
                        data:lightAccCount
                    }
                ]};
            
            var options = {
                responsive : true,
                curvature: 0.5,            
                overlayBars: true,          
                bezierCurve : false,
                
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
                    mode: true,
                    animationDuration: 0
                },
                tooltips: {
            		callbacks: {
                		label: function(tooltipItem, data) {
                    		var datasetLabel = data.datasets[tooltipItem.datasetIndex].data;
                            return data.datasets[tooltipItem.datasetIndex].label +':'+ ' '+datasetLabel + '% ';
                		}
            		}
        		},
                scales: {
                    xAxes: [{
                        gridLines: {
                            display:false
                        },
                        barPercentage : 0.7,
                        categoryPercentage :0.5,
                        
                        stacked : false
                        
                    }],
                    yAxes: [{
                        gridLines: {
                            display:true 
                        },
                        display: true,
                        scaleShowLabels: false,	
                        //barPercentage : 0.5,
                        //categoryPercentage :0.4,
                        
                        //barThickness : 20,
                        ticks: {
                            suggestedMin: 0,
                            fontColor: "#ffffff",
                            // minimum value will be 0.
                            beginAtZero: true,
                            steps: 10,
                            stepValue: 10,
                            max: 100
                            
                        },
                        stacked : false
                    },
                           ]
                            }
                            };
                            //var accountchartbyRADL = 'myChartaccountRADL'+component.get("v.season")+component.get("v.crop");
                            
                            var el = document.getElementById("myChartRADLaccount");
                            var ctx = el.getContext("2d");
                            ctx.canvas.height=63;
                            ctx.canvas.width=100;
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