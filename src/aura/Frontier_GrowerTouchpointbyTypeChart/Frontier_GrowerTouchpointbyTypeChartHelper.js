({
    loadTouchType : function(component, event){
     
console.log('-----Touchpointchart-----' );
        var action = component.get("c.getTouchpointTypebyRADL");
        action.setParams({
            crop : component.get("v.crop"),
            season : component.get("v.season"),
            accType : 'Customer'
        });
        var developtypecount = [];
        var acqtypecount = [];
        var retaintypecount = [];
        var lighttypecount = [];
        var touchType = [];
        
action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
				console.log('Success');
                var touchpointByVisit = (JSON.parse(response.getReturnValue()));
                touchType= touchpointByVisit.typeSet;
                component.set("v.touchtype",touchType);
                console.log('type' + component.get("v.touchtype"));
                console.log('check value' + touchpointByVisit.totalTouchMap.hasOwnProperty('Retain'));
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lighttypecount.push(0);
                }
                
                for(var key in touchpointByVisit.totalTouchMap){
                    console.log('key' + key );
                    
                    if(key == 'Develop'){
                        developtypecount.push(touchpointByVisit.totalTouchMap[key]);
                    }
                     if(key == 'Acquire'){
                        acqtypecount.push(touchpointByVisit.totalTouchMap[key]);
                    }
                    if(key == 'Retain'){
                        retaintypecount.push(touchpointByVisit.totalTouchMap[key]);
                    }                 
                    
                    if(key == 'Light Touch'){
                        lighttypecount.push(touchpointByVisit.totalTouchMap[key]);
                    }
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.emailTouchMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developtypecount.push(touchpointByVisit.emailTouchMap[key]);
                    }
                     if(key == 'Acquire'){
                        acqtypecount.push(touchpointByVisit.emailTouchMap[key]);
                    }
                    if(key == 'Retain'){
                        retaintypecount.push(touchpointByVisit.emailTouchMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lighttypecount.push(touchpointByVisit.emailTouchMap[key]);
                    }
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lighttypecount.push(0);
                }
                 for(var key in touchpointByVisit.visitTouchMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developtypecount.push(touchpointByVisit.visitTouchMap[key]);
                    }
                     if(key == 'Acquire'){
                        acqtypecount.push(touchpointByVisit.visitTouchMap[key]);
                    }
                    if(key == 'Retain'){
                        retaintypecount.push(touchpointByVisit.visitTouchMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lighttypecount.push(touchpointByVisit.visitTouchMap[key]);
                    }
                }
                if(!touchpointByVisit.webTouchMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.webTouchMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.webTouchMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.webTouchMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.webTouchMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developtypecount.push(touchpointByVisit.webTouchMap[key]);
                    }
                     if(key == 'Acquire'){
                        acqtypecount.push(touchpointByVisit.webTouchMap[key]);
                    }
                    if(key == 'Retain'){
                        retaintypecount.push(touchpointByVisit.webTouchMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lighttypecount.push(touchpointByVisit.webTouchMap[key]);
                    }
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.chatTouchMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developtypecount.push(touchpointByVisit.chatTouchMap[key]);
                    }
                     if(key == 'Acquire'){
                        acqtypecount.push(touchpointByVisit.chatTouchMap[key]);
                    }
                    if(key == 'Retain'){
                        retaintypecount.push(touchpointByVisit.chatTouchMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lighttypecount.push(touchpointByVisit.chatTouchMap[key]);
                    }
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Develop')){
                    console.log('Inside Develop');
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Acquire')){
                    console.log('Inside Retain');
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Retain')){
                    console.log('Inside Retain');
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Light Touch')){
                    console.log('Inside Retain');
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.callTouchMap){
                    console.log('key' + key );
                    if(key == 'Develop'){
                        developtypecount.push(touchpointByVisit.callTouchMap[key]);
                    }
                     if(key == 'Acquire'){
                        acqtypecount.push(touchpointByVisit.callTouchMap[key]);
                    }
                    if(key == 'Retain'){
                        retaintypecount.push(touchpointByVisit.callTouchMap[key]);
                    }
                    if(key == 'Light Touch'){
                        lighttypecount.push(touchpointByVisit.callTouchMap[key]);
                    }
                }
                component.set("v.dtypecount",developtypecount);
                component.set("v.acqtypecount",acqtypecount);
                component.set("v.rtypecount",retaintypecount);
                component.set("v.ltypecount",lighttypecount);
                console.log('D' + component.get("v.dtypecount"));
                console.log('A' + component.get("v.acqtypecount"));
                console.log('R' + component.get("v.rtypecount"));
                console.log('L' + component.get("v.ltypecount"));
               
            } else if (response.getState() === "ERROR") {
               
                console.log('Errors', response.getError());
            }
       var data = {
            //labels: salesDetailJson.Labels,
            //labels:["Total","Visit"],
            labels:component.get("v.touchtype"),
            datasets: [
                {
                    label : "Develop",
                    type : "bar",
                    backgroundColor: "rgb(17, 135, 48)",
                    
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    borderWidth: 1,
                    //data: [develop]
                    data:component.get("v.dtypecount")
                    // data: salesDetailJson.orderData
                },
                {
                    label : "Acquire",
                    type : "bar",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    borderWidth: 1,
                    //data: [acquire]
                    data:component.get("v.acqtypecount")
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Retain",
                    type : "bar",
                    backgroundColor: "rgb(252, 208, 171)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                   // data: [0,0,0,0,0]
                    //data:component.get("v.ltypecount")
                    data:component.get("v.rtypecount")
                    //data: salesDetailJson.orderData
                },
                {
                    label : "Light Touch",
                    type : "bar",
                    backgroundColor: "rgb(127, 205, 239)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                    data:component.get("v.ltypecount")
                    //data: [lightcount]
                    //data: salesDetailJson.orderData
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
                    categoryPercentage :0.5,
                    barPercentage : 1.5, 
                    
                    stacked : true
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:true,
                        color: "#ccc",
                        
                    },
                    display: true,
                    //categoryPercentage :0.4,
                    //barPercentage : 0.7,                   
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
        
        var el = document.getElementById("myChartGrower");
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