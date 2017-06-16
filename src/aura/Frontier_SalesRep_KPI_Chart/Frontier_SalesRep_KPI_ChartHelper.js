({
    loadChartData : function(component, event, helper){
        var lchart = 'myChart'+component.get("v.identifier");
        var data = {
            labels:[2014,2015,2016,2017],
            datasets: [
                {
                    backgroundColor: '#7CFC00',
                    borderColor :"rgb(192,192,192)",
                    fill : false,
                    pointStyle : 'circle',
                    pointRadius : [4,4,4,4],
                     pointBorderColor: "rgb(192,192,192)",
            pointBackgroundColor: "#fff",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(75,192,192,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 2,
            
            pointHitRadius: 10,
                    lineTension: 0,
                    data:[20,25,120,200],
                    spanGaps :true
                }
            ]};
        
            var options =  {
                responsive: true,
                legend: {
                display : false
            },
                scales: {
            xAxes: [{
                display: false
            }]
        }
        };
                           
        var el = document.getElementById(lchart);
        var ctx = el.getContext("2d");
        ctx.canvas.width=90;
        ctx.canvas.height=30;
        var myBarChart1 = new Chart(ctx, {
            type: 'line',
            data: data,
            options: options
        });
            window.onresize=function() {
                myChart.resize();
            };
        
    }
});