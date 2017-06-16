({
    loadTouchpoint : function(component, event){
     
        console.log('-----Touchpointchart-----' );
        var crop = component.get("v.crop");
        var season = component.get("v.season");
        var action = component.get("c.getTouchpointbyMonth");
        action.setParams({
            crop : crop,
            season : season,
            accType : 'Customer'
        });
        var months = [];
        var develop = [];
        var acquire = [];
        var retain = [];
        var light = [];
        var developcount = [];
        var acquirecount = [];
        var retaincount = [];
        var lightcount = [];
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
				console.log('Success');
                var touchpointByMonth = (JSON.parse(response.getReturnValue()));
                //var tPointbyMonth = JSON.stringify(touchpointByMonth);
                for(var key in touchpointByMonth.touchpermontcount){
                    console.log('key' + key );
                    months.push(key);
                    for(var key1 in touchpointByMonth.touchpermontcount[key]){
                      console.log('key1' + key1); 
                        console.log('touchpointByMonth.touchpermontcount[key]' + touchpointByMonth.touchpermontcount[key]);
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Develop')){
                    		console.log('Inside Develop');
                    		developcount.push(0);
                		}
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Acquire')){
                    		console.log('Inside Acquire');
                    		acquirecount.push(0);
                		}
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Retain')){
                    		console.log('Inside Retain');
                    		retaincount.push(0);
                		}
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Light Touch')){
                    		console.log('Inside Light');
                    		lightcount.push(0);
                		}
                        for(var key2 in touchpointByMonth.touchpermontcount[key][key1]){
                            console.log('key 2' + key2);
                            if(key2 == 'Develop'){
                                console.log('key2' );
                            develop.push(key2);
                            developcount.push(touchpointByMonth.touchpermontcount[key][key1][key2]);
                                console.log('key2' + touchpointByMonth.touchpermontcount[key][key1][key2]);
                            component.set("v.developcount",developcount);
                                console.log('check dev count' + component.get("v.developcount"));
                            }
                           /* if(key2 != 'Develop'){
                            //develop.push(key2);
                            developcount.push(0);
                                console.log('develop'+ developcount);
                            //component.set("v.developcount",developcount);
                                //console.log('check dev count' + component.get("v.developcount"));
                            }*/
                            if(key2 == 'Acquire'){
                            acquire.push(key2);
                            acquirecount.push(touchpointByMonth.touchpermontcount[key][key1][key2]); 
                            }
                           /* if(key2 != 'Acquire'){
                            //acquire.push(key2);
                            acquirecount.push(0); 
                            } */
                            if(key2 == 'Retain'){
                            retain.push(key2);
                            retaincount.push(touchpointByMonth.touchpermontcount[key][key1][key2]); 
                            }
                          /*  if(key2 != 'Retain'){
                            //retain.push(key2);
                            retaincount.push(0); 
                            } */
                            if(key2 == 'Light Touch'){
                            light.push(key2);
                            lightcount.push(touchpointByMonth.touchpermontcount[key][key1][key2]); 
                            } 
                          /*  if(key2 != 'Light Touch'){
                            //light.push(key2);
                            lightcount.push(0); 
                            } */
                        }
                    }
                }
                component.set("v.develop" , develop);
                component.set("v.developcount" , developcount);
                console.log('check dev ' + component.get("v.developcount"));
                component.set("v.acquire" , acquire);
                component.set("v.acquirecount" , acquirecount);
                console.log('check acq ' + component.get("v.acquirecount"));
                component.set("v.retain" , retain);
                component.set("v.retaincount" , retaincount);
                console.log('check retain' + component.get("v.retaincount"));
                component.set("v.light" , light);
                component.set("v.lightcount" , lightcount);
                console.log('check light' + component.get("v.lightcount"));
               
            } else if (response.getState() === "ERROR") {
               
                console.log('Errors', response.getError());
            }
        var data = {
            //labels: salesDetailJson.Labels,
            labels:months,
            //labels:["March","June","July"],
            datasets: [
                {
                    label : "Develop",
                    type : "bar",
                    backgroundColor: "rgb(17, 135, 48)",
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    borderWidth: 1,
                    //data: [develop]
                    data:component.get("v.developcount")
                    // data: salesDetailJson.orderData
                },
                {
                    label : "Acquire",
                    type : "bar",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    borderWidth: 1,
                    //data: [acquire]
                    data:component.get("v.acquirecount")
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Retain",
                    type : "bar",
                    backgroundColor: "rgb(252, 208, 171)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                    //data: [retaincount]
                    data:component.get("v.retaincount")
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Light Touch",
                    type : "bar",
                    backgroundColor: "rgb(127, 205, 239)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                    data:component.get("v.lightcount")
                    //data: [lightcount]
                    //data: salesDetailJson.orderData
                }
            ]};
        
            var options = {
            responsive : true,
            curvature: 0.5,            
            overlayBars: true,          
            bezierCurve : false,
           
                legend:{
                    display:false
                },
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
                tooltips: {
                            enabled:true,
                        },
            scales: {
                xAxes: [{
                    gridLines: {
                        display:false
                    },
                    categoryPercentage :0.2,
                    barPercentage : 2.5,
                    stacked : true
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:true,
                        color: "#ccc",
                        
                    },
                    display: true,
                    categoryPercentage :0.4,
                    barPercentage : 2.5,                   
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
        
        var el = document.getElementById("myChartGrowertouchpoint");
        var ctx = el.getContext("2d");
        ctx.canvas.height=400;
            ctx.canvas.width=1300;
        var myBarChart1 = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: options
        });
        
        /*window.onresize=function() {
            myBarChart1.resize();
        };*/
       });
        $A.enqueueAction(action);
    }
});