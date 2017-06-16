({
    loadChartData : function(component){
        var show = (component.get("v.latestCrop") == component.get("v.identifier") ?  true : false);
        var salesChartGrower = 'myChart'+component.get("v.identifier");
        console.log(salesChartGrower + 'salesChart');
        var el = document.getElementById(salesChartGrower);
        console.log(el + 'el');
         var context = el.getContext('2d');
        var growerSales = component.get("v.growerSalesFarm");
        var salesRepBrand = growerSales.salesRepBrand;
        var OtherBrandTotaltwoPY = 0;
        var OtherBrandTotalCY = 0;
        var OtherBrandTotalPY = 0;

        console.log('salesRepBrand'+salesRepBrand);
        console.log('Inside grower chart' + JSON.stringify(growerSales));
        for(var key in growerSales.accFarmingMap){
            console.log('Inside accFarmingMap Loop');
            var year = key.split('-')[0];
            var crop = key.split('-')[1];
            if(crop == (component.get("v.identifier"))){
                if(year == '2017'){
                  console.log('2017 data' + growerSales.accFarmingMap[key]);
                component.set("v.cropCYOpportunity",growerSales.accFarmingMap[key]);
  
                }
                if(year == '2016'){
                console.log('2016 data' + growerSales.accFarmingMap[key]);
   
               component.set("v.cropPYOpportunity",growerSales.accFarmingMap[key]);    
  
                }
                if(year == '2015'){
                   console.log('2015 data' + growerSales.accFarmingMap[key]);

                   component.set("v.crop2PYOpportunity",growerSales.accFarmingMap[key]);
  
                }
            }
        }
        for(var key in  growerSales.cropMap){
            console.log('Inside Loop');
            if(key == (component.get("v.identifier"))){
                console.log('Inside if' + key + component.get("v.identifier") );
                for(var key1 in growerSales.cropMap[key]){
                    console.log('inside Year key' + key1);
                    if(key1 == 'twoPY'){
                        var year = growerSales.cropMap[key][key1];
                        console.log('twoPY' + year);
                        for(var key2 in year){
                            
                         if(key2 == salesRepBrand){
                        console.log('Inside salesRepBrand if' + key2);
                        component.set("v.crop2PYBrandSales",year[key2].netSalestwoPY);
                        //component.set("v.crop2PYOpportunity",year[key2].OpportunitytwoPY);
                        console.log('Brand Sales 2PY' + (component.get("v.crop2PYBrandSales")));
                        //console.log('Brand Opportunity 2PY' + (component.get("v.crop2PYOpportunity")));

                    }
                    else{
                        console.log('Inside Channel if' + key2);
                        OtherBrandTotaltwoPY += (year[key2].netSalestwoPY);
                        console.log('Other Brand Sales 2PY' + OtherBrandTotaltwoPY);
                    }
                   


                        }
                    
                    }
                    component.set("v.crop2PYNetSales",OtherBrandTotaltwoPY);
                    if(key1 == 'PY'){
                        var year = growerSales.cropMap[key][key1];
                        console.log('PY' + year);
                        for(var key2 in year){
                            
                         if(key2 == salesRepBrand){
                        console.log('Inside Channel if' + key2);
                        component.set("v.cropPYBrandSales",year[key2].netSalesPY);
                        //component.set("v.cropPYOpportunity",year[key2].OpportunityPY);
                        console.log('Brand Sales PY' + (component.get("v.cropPYBrandSales")));
                        //console.log('Brand Opportunity PY' + (component.get("v.cropPYOpportunity")));
                         
                    }
                    else{
                        console.log('Inside Channel if' + key2);
                        OtherBrandTotalPY += (year[key2].netSalesPY);
                        
                          console.log('Other Brand Sales PY' + OtherBrandTotalPY);

                    }

                        }
                    
                    }
                    component.set("v.cropPYNetSales",OtherBrandTotalPY);
                    
                    if(key1 == 'CY'){
                        var year = growerSales.cropMap[key][key1];
                        console.log('CY' + year);
                        for(var key2 in year){
                            
                         if(key2 == salesRepBrand){
                        console.log('Inside Channel if' + key2);
                        component.set("v.cropCYBrandSales",year[key2].netSalesCY);
                        //component.set("v.cropCYOpportunity",year[key2].OpportunityCY);
                        console.log('Brand Sales CY' + (component.get("v.cropCYBrandSales")));
                        //console.log('Brand Opportunity CY' + (component.get("v.cropCYOpportunity")));
                    }
                    else{
                        console.log('Inside Channel if' + key2);
                         OtherBrandTotalCY += (year[key2].netSalesCY);
                       console.log('Other Brand Sales CY' + OtherBrandTotalCY);

                    }
                      

                        }
                    
                    }
                     component.set("v.cropCYNetSales",OtherBrandTotalCY);
                      
                  
                }
            }
        }
        var crop = component.get("v.identifier");
        var data = {
            //labels: salesDetailJson.Labels,
            labels:["2PY", "PY", "CY"],
            datasets: [
                {
                    label : "Sales My Brand",
                    type : "horizontalBar",
                    backgroundColor: "rgb(237, 168, 49)",
                    
                    hoverBackgroundColor: "rgba(50,90,100,1)",
                    data: [(component.get("v.crop2PYBrandSales")),(component.get("v.cropPYBrandSales")),(component.get("v.cropCYBrandSales"))]
                    //data: [1000,1000,10000]
                },
                {
                    label : "Other MON sales",
                    type : "horizontalBar",
                    backgroundColor: "rgb(201, 197, 191)",
                    hoverBackgroundColor: "rgba(140,85,100,1)",
                    data: [(component.get("v.crop2PYNetSales")),(component.get("v.cropPYNetSales")),(component.get("v.cropCYNetSales"))]
                    //data: [1000,1000,10000]
                },
                {
                    label : "Opportunity",
                    type : "horizontalBar",
                    backgroundColor: "rgb(51, 153, 255)",
                    hoverBackgroundColor: "rgba(46,185,235,1)",
                    data:[(component.get("v.crop2PYOpportunity")),(component.get("v.cropPYOpportunity")),(component.get("v.cropCYOpportunity"))]
                    //data: [1000,1000,10000]
                }
            ]};
        
            var options = {
            responsive : true,
            curvature: 0.5,            
            overlayBars: true,
            scaleShowLabels : false,
            barValueSpacing : 1,
            bezierCurve : false,
            animation:false,
                legend:{
                    display:false
                },
            legend: {
                
                display:show,
           
                position:'bottom',
                labels: {
                    fontColor: 'black'
                }
            
            
},
            scaleLabel:{
                display:false
            },           
            scales: {
                xAxes: [{
                    gridLines: {
                        display:false,
                        color: "#fff"
                    },
                    ticks: {
                    display: false
                },
                    categoryPercentage :0.1,
                    showScale : false,
                    barPercentage : 0.2,
                    stacked : true
                    
                }],
                yAxes: [{
                    gridLines: {
                        display:false,
                        color: "#fff",
                        
                    },
                    display: true,
                    categoryPercentage :0.4,
                    barPercentage : 0.5,                   
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
        
        var el = document.getElementById(salesChartGrower);
        var ctx = el.getContext("2d");
        console.log(ctx + 'ctx');
        /*new Chart(ctx).Line(data, {
         showScale: false
       });*/
        ctx.canvas.width=300;
        ctx.canvas.height=120;
        var myBarChart1 = new Chart(ctx, {
            type: 'horizontalBar',
            data: data,
            options: options,
            draw: function(){
        this.options.barValueSpacing = this.chart.width / 5;
        Chart.types.Bar.prototype.draw.apply(this, arguments);
    }
        });
        if((component.get("v.identifier")) == 'Sorghum'){
        var saleslegendId = 'chartLegend1'+component.get("v.identifier");
        /*document.getElementById(saleslegendId).innerHTML = myBarChart1.generateLegend();
        $A.util.addClass(component.find(saleslegendId),'chart-legend1');*/
    }
        window.onresize=function() {
            myBarChart1.resize();
        };
       
     // });
       // $A.enqueueAction(action);  
        
    },
    
    getMonsantoShare : function(component){
        //Display Monsanto share data in % from Customer 360
      /*  var action = component.get("c.GrowerDetails");
        action.setParams({
            result : component.get("v.GrowerDetailResponse")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             var growerMonsantoshare = JSON.parse(response.getReturnValue());
              console.log('growerMonsantoshare' + growerMonsantoshare);
              component.set("v.GrowerMonsantoShare",growerMonsantoshare);
              
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
                console.log("Errors", response.getError());
            }
        });                        
       $A.enqueueAction(action);*/
    }
});