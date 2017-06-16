({
    drawChart : function(component){
        var data;
        var options;
        var el;
        var ctx;
        var gradient;
        var myBarChart;
        data ={
            labels:["CORN","SOYBEANS","CANOLA","ALFALFA","RYE"],
            datasets:[
                {
                    label: "Orders",
                    fillColor: gradient,
                    backgroundColor: '#0000A0',
                    borderColor: '#71B37C',
                    data: [10000,20000,60000,70000,40000]
                },
                {
                    label: "CY Sales",
                    fillColor: gradient,
                    backgroundColor: '#1589FF',
                    borderColor: '#71B37C',
                    data: [50000,30000,10000,40000,80000]
                },
                {
                    label: "Budget",
                    fillColor: gradient,
                    backgroundColor: "rgb(201, 197, 191)",
                    borderColor: '#71B37C',
                    data: [80000,40000,80000,90000,100000]
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
    }
});