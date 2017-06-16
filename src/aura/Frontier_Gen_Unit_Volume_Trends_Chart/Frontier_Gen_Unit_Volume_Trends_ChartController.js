({
    onChartLoad :function(component){
        var data = {
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            datasets: [
                {
                    fillColor: "rgba(111,187,205,1)",
                    strokeColor: "rgba(111,187,205,0.2)",
                    data: [100, 200, 300, 50, 500, 600, 100, 300, 1000, 200, 100, 300]
                }
            ]
        }
        var options = { responsive: true };
        
        //get the canvas element defined in the component
        var element = component.find("chart").getElement();
        
        //Get the context of the canvas element we want to select
        var ctx = element.getContext("2d");
        
        var myLineChart = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: options
        });        
        //r myLineChart  = new Chart(ctx).Line(data, options);
    }    
})