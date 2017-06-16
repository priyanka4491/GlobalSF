({
    drawChart : function(component){
        var data;
        var options;
        var el;
        var ctx;
        var gradient;
        var myBarChart;
        data ={
            labels:["CORN","SOYBEAN","CANOLA","ALFALFA","RYE"],
            datasets:[
                {
                    label: "Orders",
                    fillColor: gradient,
                    backgroundColor: '#5ba361',
                    borderColor: '#71B37C',
                    data: [0,0,0,0,0]
                },
                {
                    label: "CY Sales",
                    fillColor: gradient,
                    backgroundColor: '#9dbb67',
                    borderColor: '#71B37C',
                    data: [0,0,0,0,0]
                }
            ]
        };
        options ={
            responsive:true,
            showTooltips: true,
            barValueSpacing:2,
            labels:{
                fontColor: 'black'
            },
            title:{
                display:false,
                text:''
            },
            legend:{
                display: true,
                labels:{
                    fontColor: 'black'
                }
            },
            scales:{
                xAxes:[{
                    display:false,
                    gridLines:{
                        display:false
                    }
                }],
                yAxes:[{
                    ticks:{
                        max: 100000,
                        min: 0,
                        stepSize: 100000
                    },
                    gridLines:{
                        display:false
                    }
                }]
            }
        };
        el = component.find("chart").getElement();
        ctx = el.getContext("2d");
        gradient= ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0,'rgba(151,187,205,0.7)');
        gradient.addColorStop(1,'rgba(151,187,205,0)');
        myBarChart = new Chart(ctx,{
            type: 'bar',
            data: data,
            options:options
        });
        window.onresize=function(){
            myBarChart.resize();
        };
    },
    createTrackingTable : function(component){
        var action = component.get("c.getAccsDetails");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && !(response.getReturnValue() === 'CalloutError')){
                console.log(response.getReturnValue());
                console.log("Sucess tracking");
                $A.createComponent(
                    "c:Frontier_AccountTracking_Table",
                    {
                        "Trackingtabledetails": response.getReturnValue()
                    },
                    function(newCmp){
                        var cmp = component.find("AccountTrackingTablecorn");
                        cmp.set("v.body", []);
                        cmp.set("v.body", newCmp);
                    }
                );
            }
            else if(response.getReturnValue() === 'CalloutError'){
                console.log('CalloutError');
            }
                else{
                    console.log('Call Back Error');
                }
        });
        $A.enqueueAction(action);
    }
    });