({
    chartLoad : function(component,event,crop)  {
        var labels = [];
        var Datas = [];
        var Orders = [];
        var dealerAccSalesJson;
        var uniqueId =component.get("v.dealerAccId");
        var dealerAccountId =uniqueId.split(',')[0];
        var action = component.get("c.dealerSalesDetails");
        var currentYear = parseInt(new Date().getFullYear());
        //alert(currentYear-1);
        action.setParams({
            dealerAccId :dealerAccountId,
            crop : crop
            
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             dealerAccSalesJson = (JSON.parse(response.getReturnValue()));;
                //for(var key in  dealerAccSalesJson.SalesYearMap){
                    if((dealerAccSalesJson.SalesYearMap).hasOwnProperty((currentYear-2).toString())){
                        Datas.push(dealerAccSalesJson.SalesYearMap[(currentYear-2).toString()]);
                    }else{
                        Datas.push('');
                    }
                    if((dealerAccSalesJson.SalesYearMap).hasOwnProperty((currentYear-1).toString())){
                        Datas.push(dealerAccSalesJson.SalesYearMap[(currentYear-1).toString()]);
                    }else{
                        Datas.push('');
                    }
                    if((dealerAccSalesJson.SalesYearMap).hasOwnProperty((currentYear).toString())){
                        Datas.push(dealerAccSalesJson.SalesYearMap[(currentYear).toString()]);
                    }else{
                        Datas.push('');
                    }
                        
                //}
                //for(var key in  dealerAccSalesJson.OrderYearMap){
                    if((dealerAccSalesJson.OrderYearMap).hasOwnProperty((currentYear-2).toString())){
                        Orders.push(dealerAccSalesJson.OrderYearMap[(currentYear-2).toString()]);
                    }else{
                        Orders.push('');
                    }
                    if((dealerAccSalesJson.OrderYearMap).hasOwnProperty((currentYear-1).toString())){
                        Orders.push(dealerAccSalesJson.OrderYearMap[(currentYear-1).toString()]);
                    }else{
                        Orders.push('');
                    }
                    if((dealerAccSalesJson.OrderYearMap).hasOwnProperty((currentYear).toString())){
                        Orders.push(dealerAccSalesJson.OrderYearMap[(currentYear).toString()]);
                    }else{
                        Orders.push('');
                    }
                        
                //}
               //this.getSeasonDetails(component,event,helper);
               //component.set("v.dealerAccSales", dealerAccSalesJson);
                /*if(growerAccFarmJson.displayMsg == true){
                    var errorMsg = $A.get("$Label.Update_Farming_Area_Alert");
                    console.log("Error msg" , errorMsg);
                    //component.set("v.errorMsg",'**********Please update Total Area for Current FY**********');
                } */
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
            }
             /*for(var i=0;i<dealerAccSalesJson.length;i++){
                // console.log('Testtttttttt'+growerAccFarmJson[i].Area_Usage_Descr__c);
                  Datas.push(dealerAccSalesJson.value[i]) ; 
                }*/
        var data = {
            labels: ["2PY Sales","PY Sales","CY Sales"],
            datasets: [
                {
                    label: "Sales",
                    backgroundColor: [
                        'rgba(0, 102, 0, 1)',
                        'rgba(0, 102, 0, 1)',
                        'rgba(0, 102, 0, 1)'
                    ],
                    borderColor: [
                        'rgba(0, 102, 0, 1)',
                        'rgba(0, 102, 0, 1)',
                        'rgba(0, 102, 0, 1)'
                    ],
                    borderWidth: 1,
                    data: Datas,
                },
                
                {
                    label: "Orders",
                    //new option, type will default to bar as that what is used to create the scale
                    type: "line",
                    fill: false,
                    lineTension: 0,
                    borderColor: "rgba(0, 102, 0, 1)",
                    pointRadius: 5,
                    pointBorderColor: "#ab2c00",
            		pointBackgroundColor: "#fff",
                    data: Orders
                }
            ]};
        var options = 
            {
                responsive : true,
                barValueSpacing: 2,
                overlayBars: true,
                bezierCurve : false,
                animation:false,
                legend: {
                    display:true,
                    position:'right',
                    labels: {
                        fontColor: 'black'
                    }
                },
                scales: {
                    xAxes: [{
                        gridLines: {
                            display:false
                        },
                        barThickness:50
                    }],
                    yAxes: [{
                        gridLines: {
                            display:false
                        },
                        display: true,
                        ticks: {
                            // minimum will be 0, unless there is a lower value.
                            suggestedMin: 0,
                            // minimum value will be 0.
                            //beginAtZero: true
                        }
                    }]
                }
            };
        
        var chrt = document.getElementById("salesTrendChart").getContext("2d");
        var salesTrendCharts = new Chart(chrt, {
            type: 'bar',
            data: data,
            options: options
        });
        window.onresize=function() {
            salesTrendCharts.resize();
        };
            });
        $A.enqueueAction(action);
    },
    
    toggleButton: function(component,event,crop1,crop2){
        $A.util.addClass(component.find(crop1+'Clicked'), 'slds-button--brand');
        $A.util.removeClass(component.find(crop1+'Clicked'), 'slds-button--neutral');
        $A.util.addClass(component.find(crop2+'Clicked'), 'slds-button--neutral');
        $A.util.removeClass(component.find(crop2+'Clicked'), 'slds-button--brand');
	},
    getPicklistValues : function(component,event,helper) {
         var action = component.get("c.getCropList");
        var programId = null;
        var dealerId = null;
        action.setParams({
        		programId :programId,
                dealerId : dealerId
            });
     var cropsel = component.find("crop");
     var crops=[];
        
        action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var cropList = response.getReturnValue();
                    //console.log("retResponse"+ JSON.stringify(retResponse));
                for(var i=0;i< cropList.length;i++){
                crops.push({"class": "optionClass", label: cropList[i], value:cropList[i]});
            } 
              cropsel.set("v.options",crops);
                }
        });
        $A.enqueueAction(action);
		
		
	},
})