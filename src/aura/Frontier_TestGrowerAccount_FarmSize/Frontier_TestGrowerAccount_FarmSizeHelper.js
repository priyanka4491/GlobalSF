({
    loadFormSizeChartData : function(component,fiscalyr,uom) {
        $A.util.addClass(component.find('tableDiv'),'tableDiv');
        if( $A.get("$Browser.isIPhone")){
            $A.util.removeClass(component.find("tableThTr"),'tableThTrAndroid');
            $A.util.addClass(component.find("tableThTr"),'tableThTrIphone');
        } else if($A.get("$Browser.isAndroid")){
            $A.util.removeClass(component.find("tableThTr"),'tableThTrIphone');
            $A.util.addClass(component.find("tableThTr"),'tableThTrAndroid');
        }
        var errorMsg = $A.get("$Label.Update_Farming_Area_Alert");
        console.log("Error msg" , errorMsg);
                    //component.set("v.errorMsg",'**********Please update Total Area for Current FY**********');
                 
            
            var data = {
            labels: [corn,
                     soya,
                     others
                     ],
            datasets: [
                {
                    
                    data: [50,40,10],
                    backgroundColor: [
                        "rgba(254, 102, 0, 1)",
                        "rgba(0, 127, 0, 1)",
                        "rgba(127, 127, 127, 1)"
                    ],
                    hoverBackgroundColor: [
                        "rgba(254, 102, 0, 1)",
                        "rgba(0, 127, 0, 1)",
                        "rgba(127, 127, 127, 1)"
                    ]
                }]
        };
        var options = {
            segmentShowStroke: false,
            responsive : true,
            animateRotate: true,
            animateScale: false,
            cutoutPercentage: 80,
            legend: {
                display : false
            },
            tooltips: {
                
                callbacks : {
                    label : function(tooltipItem, data) {
                        var label =  (data.labels[tooltipItem.index])
                        label = label.substring(label.indexOf("|")+1,label.indexOf(":"));
                        var data = data.datasets[0].data[tooltipItem.index]+'%';
                        console.log(label.substring(label.indexOf("|")+1,label.indexOf(":")));
                        return label+': '+data;
                    },
                }
            }
        }
        var el = document.getElementById("myDoughnutChart");
        //var el = component.find(bchart);
        var ctx = el.getContext("2d");
        ctx.canvas.width=2;
        ctx.canvas.height=2; 
        var myBarChart1 = new Chart(document.getElementById("myDoughnutChart").getContext("2d"), {
            type: 'doughnut',
            data: data,
            options:options
        });
            document.getElementById('chartLegend').innerHTML = myBarChart1.generateLegend() +'<span style="padding-left:30px">Total :' +1000+'</span>';
        $A.util.addClass(component.find('chartLegend'),'chart-legend');
        
        
    }
})