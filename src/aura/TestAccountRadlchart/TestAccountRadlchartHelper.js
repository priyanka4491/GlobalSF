({
    loadAccDashData : function(component, event){
var dev = [59, 80, 81, 56, 55, 0, 65];
        var acq =[80, 81, 56, 55, 40, 0, 60];
      
        component.set("v.dtypecount",dev);
        component.set("v.acqtypecount",acq);  
        
      var data = {
  labels: ["January", "February", "March", "April", "May", "June", "July"],
  datasets: [
    {
      label: "My First dataset",
      backgroundColor: "rgba(99,255,132,0.2)",
      data: dev,
       yAxisID: "y-axis-1",
      stack: 2
    },
    {
      label: "My Second dataset",
      backgroundColor: "rgba(99,132,255,0.2)",
      data: acq,
       yAxisID: "y-axis-1",
      stack: 2
    },
    {
      label: "My Third dataset",
      backgroundColor: "red",
      data: [0, 0, 0, 0, 0, 40, 0],
      yAxisID: "y-axis-0",
      stack: 1
    },
    {
      label: "My Third dataset",
      backgroundColor: "rgba(220,20,60.0.2)",
      data: [0, 0, 0, 0, 0, 30, 0],
      yAxisID: "y-axis-0",
      stack: 2
    }
    
  ]
};
        
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
      yAxes: [
      {
        ticks: {
          max: 160,
        }
          
        },
         {
      "id": "y-axis-0",
      stacked: false
      },
      {
      "id": "y-axis-1",
      stacked: true
      } 
        ]
    }
  
        };
        
        var el = document.getElementById("myChartaccountRADL");
        var ctx = el.getContext("2d");
            ctx.canvas.height=400;
            ctx.canvas.width=1300;
        var myBarChart1 = new Chart(ctx, {
            type: 'groupableBar',
            data: data,
            options: options
        });        
        window.onresize=function() {
            myBarChart1.resize();
        };
    }
});