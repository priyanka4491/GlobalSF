({
    loadChart: function(component, event, helper) {        
        var data = {
            labels: ["2PY", "PY", "CY"],
            datasets: [
                       {
                           label : "Sales",
                           type : "bar",
                           fillColor: "rgba(220,220,220,0.5)",           
                           //backgroundColor: 'rgba(0, 157, 217, 1)',
                            backgroundColor: "#5ba361",
                           borderColor: '#71B37C',
                           //hoverBackgroundColor: 'rgba(0, 157, 217, 1)',
                           hoverBackgroundColor: "#5ba361",
                           hoverBorderColor: '#71B37C',       
                           data: [200, 170, 180]
                       }
                      ]};        
      var options = {responsive : true,
                       barValueSpacing: 1,
                       overlayBars: true,
                       bezierCurve : false,  
				legend: {
                   display: true,
                   position : 'right',
                   labels: {
                       fontColor: 'black'
                   }
               },                     
                       scales: {
                           xAxes: [{
                               gridLines: {
                                   display:false
                               }
                           }],
                           yAxes: [{
                               gridLines: {
                                   display:false
                               }   
                           }]                           
                       }
          };
        var el = component.find("chart").getElement();
        var ctx = el.getContext("2d");
        var myBarChart = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: options
        });
        window.onresize=function()
        {
            myBarChart.resize();
            
        }
    }
})