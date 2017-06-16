({
    loadTouchType : function(component, event){
       var action = component.get("c.getTouchpointTypebyRADL");
        action.setParams({
           // crop : component.get("v.crop"),
            season : component.get("v.season"),
            accType : component.get("v.accType")
        });
        var developtypecount = [];
        var acqtypecount = [];
        var retaintypecount = [];
        var lighttypecount = [];
        var touchType = ['Total','E-mail','Visit','Call','Event'];
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
				var touchpointByVisit = (JSON.parse(response.getReturnValue()));
                //touchType= touchpointByVisit.typeSet;
                component.set("v.touchtype",touchType);
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Develop')){
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Acquire')){
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Retain')){
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.totalTouchMap.hasOwnProperty('Light Touch')){
                    lighttypecount.push(0);
                }
                
                for(var key in touchpointByVisit.totalTouchMap){
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
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Acquire')){                    
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Retain')){
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.emailTouchMap.hasOwnProperty('Light Touch')){
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.emailTouchMap){
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
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Acquire')){
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Retain')){
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.visitTouchMap.hasOwnProperty('Light Touch')){
                    lighttypecount.push(0);
                }
                 for(var key in touchpointByVisit.visitTouchMap){
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
               
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Develop')){
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Acquire')){
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Retain')){
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.chatTouchMap.hasOwnProperty('Light Touch')){
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.chatTouchMap){
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
                    developtypecount.push(0);
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Acquire')){
                    acqtypecount.push(0);
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Retain')){
                    retaintypecount.push(0);
                }
                if(!touchpointByVisit.callTouchMap.hasOwnProperty('Light Touch')){
                    lighttypecount.push(0);
                }
                for(var key in touchpointByVisit.callTouchMap){
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
                    data:component.get("v.dtypecount")
                },
                {
                    label : "Acquire",
                    type : "bar",
                    backgroundColor: "rgb(237, 168, 49)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    borderWidth: 1,
                    data:component.get("v.acqtypecount")
                },
                {
                    label : "Retain",
                    type : "bar",
                    backgroundColor: "rgb(252, 208, 171)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
                    data:component.get("v.rtypecount")
                },
                {
                    label : "Light Touch",
                    type : "bar",
                    backgroundColor: "rgb(127, 205, 239)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    borderWidth: 1,
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
        
        var el = document.getElementById("myChart");
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