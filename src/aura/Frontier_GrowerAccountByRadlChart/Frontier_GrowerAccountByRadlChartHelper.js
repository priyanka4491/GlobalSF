({
    loadAccDashData : function(component, event){
     
        console.log('-----Acccount coverage chart-----' );
        var action = component.get("c.getAccountRadl");
        action.setParams({
            crop : component.get("v.crop"),
            season : component.get("v.season"),
            accType : 'Customer'
        });
      var developAccCount = [];
        var acqAccCount = [];
        var retainAccCount = [];
        var lightAccCount = [];
        var accCoverageLbl = [];
        
         action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
				console.log('Success');
            var accCoverageRADL = (JSON.parse(response.getReturnValue()));
                accCoverageLbl= accCoverageRADL.accRADLLblSet;
                component.set("v.accCoverageLbl",accCoverageLbl);
                console.log('type' + component.get("v.accCoverageLbl"));
                //console.log('check value' + accCoverageRADL.accountRadlMap.hasOwnProperty('Retain'));
                if(!accCoverageRADL.accountRadlMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accountRadlMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accountRadlMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retainAccCount.push(0);
                    console.log('Inside retain 0' + retainAccCount);
                }
                if(!accCoverageRADL.accountRadlMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lightAccCount.push(0);
                }
                
                for(var key in accCoverageRADL.accountRadlMap){
                    console.log('key' + key );
                    
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accountRadlMap[key]);
                        console.log('Develop1'+ developAccCount);
                    }
                     if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accountRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accountRadlMap[key]);
                        console.log('Inside retain' + retainAccCount);
                    }                 
                    
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accountRadlMap[key]);
                    }
                }
                if(!accCoverageRADL.accPgmRadlMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accPgmRadlMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accPgmRadlMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.accPgmRadlMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lightAccCount.push(0);
                }	
                for(var key in accCoverageRADL.accPgmRadlMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accPgmRadlMap[key]);
                        console.log('Develop2'+ developAccCount);
                    }
                     if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accPgmRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accPgmRadlMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accPgmRadlMap[key]);
                    }
                }
                if(!accCoverageRADL.accTouchRadlMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accTouchRadlMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accTouchRadlMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.accTouchRadlMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lightAccCount.push(0);
                }
                 for(var key in accCoverageRADL.accTouchRadlMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accTouchRadlMap[key]);
                        console.log('Develop3'+ developAccCount);
                    }
                     if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accTouchRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accTouchRadlMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accTouchRadlMap[key]);
                    }
                }
                if(!accCoverageRADL.accRadlCoverMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.accRadlCoverMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.accRadlCoverMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.accRadlCoverMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lightAccCount.push(0);
                } 
                
                 for(var key in accCoverageRADL.accRadlCoverMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.accRadlCoverMap[key]);
                        console.log('Develop3'+ developAccCount);
                    }
                     if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.accRadlCoverMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.accRadlCoverMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.accRadlCoverMap[key]);
                    }
                }
                if(!accCoverageRADL.TouchpointcountRadlMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.TouchpointcountRadlMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.TouchpointcountRadlMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.TouchpointcountRadlMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lightAccCount.push(0);
                }
                for(var key in accCoverageRADL.TouchpointcountRadlMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.TouchpointcountRadlMap[key]);
                        console.log('Develop4'+ developAccCount);
                    }
                     if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.TouchpointcountRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.TouchpointcountRadlMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.TouchpointcountRadlMap[key]);
                    }
                }
                
                if(!accCoverageRADL.avgVisitRadlMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developAccCount.push(0);
                }
                if(!accCoverageRADL.avgVisitRadlMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqAccCount.push(0);
                }
                if(!accCoverageRADL.avgVisitRadlMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retainAccCount.push(0);
                }
                if(!accCoverageRADL.avgVisitRadlMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lightAccCount.push(0);
                }
                for(var key in accCoverageRADL.avgVisitRadlMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developAccCount.push(accCoverageRADL.avgVisitRadlMap[key]);
                        console.log('Develop6'+ developAccCount);
                    }
                     if(key == 'Acquire'){
                        acqAccCount.push(accCoverageRADL.avgVisitRadlMap[key]);
                    }
                    if(key == 'Retain'){
                        retainAccCount.push(accCoverageRADL.avgVisitRadlMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lightAccCount.push(accCoverageRADL.avgVisitRadlMap[key]);
                    }
                }
                component.set("v.dtypecount",developAccCount);
                component.set("v.acqtypecount",acqAccCount);
                component.set("v.rtypecount",retainAccCount);
                component.set("v.ltypecount",lightAccCount);
             /*   console.log('Dev' + component.get("v.dtypecount"));
                console.log('Acq' + component.get("v.acqtypecount"));
                console.log('Ret' + component.get("v.rtypecount"));
                console.log('Light' + component.get("v.ltypecount"));*/
               
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
                tooltips: {
                            enabled:true,
                        },
            scales: {
                xAxes: [{
                    gridLines: {
                        display:false
                    },
                    barPercentage : 1.5,
                    categoryPercentage :0.5,                   
                    stacked : true
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:true 
                    },
                    display: true,
                    //categoryPercentage :0.4,
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
        
        var el = document.getElementById("myChartGroweraccountRADL");
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