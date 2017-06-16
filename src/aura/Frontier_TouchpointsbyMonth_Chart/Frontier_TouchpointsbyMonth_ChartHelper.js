({  
    
    getpicklistvalues:function(component, event){
    var action = component.get("c.getTouchpointTypeValues");
    var inputsel = component.find("touchpointbytype");
     var opts=[];
     var results = [];
      action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var retResponse = response.getReturnValue();
                  //results.push(retResponse);     
               for(var i=0;i< retResponse.length;i++){
                opts.push({"class": "optionClass", label: retResponse[i], value:retResponse[i]});
            }
            
             inputsel.set("v.options",opts); 
             //cropsel.set("v.options",crops);
             
                }
        });
        $A.enqueueAction(action);
		
   },
    loadTouchpoint : function(component, event,touchpointType){
        var season = component.get("v.season");
        var action = component.get("c.getTouchpointbyMonth");
        action.setParams({
            touchpointType : touchpointType,
            season : component.get("v.season"),
            accType : component.get("v.accType")
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
        var checkNull = false;
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var touchpointByMonth = (JSON.parse(response.getReturnValue()));
                for(var key in touchpointByMonth.touchpermontcount){
                    months.push(key);
                    for(var key1 in touchpointByMonth.touchpermontcount[key]){
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Develop')){
                    		developcount.push(0);
                            checkNull = true;
                		}
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Acquire')){
                            acquirecount.push(0);
                            checkNull = true;
                		}
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Retain')){
                            retaincount.push(0);
                            checkNull = true;
                		}
                        if(!touchpointByMonth.touchpermontcount[key][key1].hasOwnProperty('Light Touch')){
                            lightcount.push(0);
                            checkNull = true;
                		}
                        for(var key2 in touchpointByMonth.touchpermontcount[key][key1]){
                            if(key2 == 'Develop'){
                                develop.push(key2);
                            developcount.push(touchpointByMonth.touchpermontcount[key][key1][key2]);
                                component.set("v.developcount",developcount);
                                checkNull = false;
                            }
                            if(key2 == 'Acquire'){
                            acquire.push(key2);
                            acquirecount.push(touchpointByMonth.touchpermontcount[key][key1][key2]);
                            checkNull = false;    
                            }
                            if(key2 == 'Retain'){
                            retain.push(key2);
                            retaincount.push(touchpointByMonth.touchpermontcount[key][key1][key2]); 
                                checkNull = false;
                            }
                            if(key2 == 'Light Touch'){
                            light.push(key2);
                            lightcount.push(touchpointByMonth.touchpermontcount[key][key1][key2]); 
                                checkNull = false;
                            }
                        }
                    }
                }
                component.set("v.develop" , develop);
                component.set("v.developcount" , developcount);
                component.set("v.acquire" , acquire);
                component.set("v.acquirecount" , acquirecount);
                component.set("v.retain" , retain);
                component.set("v.retaincount" , retaincount);
                component.set("v.light" , light);
                component.set("v.lightcount" , lightcount);
            } else if (response.getState() === "ERROR") {
               
                console.log('Errors', response.getError());
            }
        var data = {
            labels:months,
            datasets: [
                {
                    label : "Develop",
                    type : "bar",
                    backgroundColor: "rgb(17, 135, 48)",
                    
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    borderWidth: 1,
                    data:component.get("v.developcount")
                },
                {
                    label : "Acquire",
                    type : "bar",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    borderWidth: 1,
                    data:component.get("v.acquirecount")
                },
                {
                    label : "Retain",
                    type : "bar",
                    backgroundColor: "rgb(252, 208, 171)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                    data:component.get("v.retaincount")
                },
                {
                    label : "Light Touch",
                    type : "bar",
                   backgroundColor: "rgb(127, 205, 239)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                    data:component.get("v.lightcount")
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
                    categoryPercentage :0.1,
                    barPercentage : 0.5,
                    stacked : true
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:true,
                        color: "#ccc",
                        
                    },
                    display: true,
                    //categoryPercentage :0.4,
                    //barPercentage : 0.5,                   
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
        
        var el = document.getElementById("myCharttouchpoint");
        var ctx = el.getContext("2d");
        ctx.canvas.height=400;
            ctx.canvas.width=1300;
        var myBarChart1 = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: options
        });
             //= touchpointByMonth.touchpermontcount.length;
            var touchpointMapLength=Object.keys(touchpointByMonth.touchpermontcount).length;
           
            if(touchpointMapLength > 0){
                document.getElementById("myCharttouchpoint").style.display = "block";
        }
            else{
                document.getElementById("myCharttouchpoint").style.display = "none"; 
            }
       
       });
        $A.enqueueAction(action);
    }
});