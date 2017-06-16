({
    loadFormSizeChartData : function(component,fiscalyr,uom) {
        var labels = [];
        var Datas = [];
        var growerAccFarmJson;
       var myBarChart1;
        $A.util.addClass(component.find('tableDiv'),'tableDiv');
        if( $A.get("$Browser.isIPhone")){
            $A.util.removeClass(component.find("tableThTr"),'tableThTrAndroid');
            $A.util.addClass(component.find("tableThTr"),'tableThTrIphone');
        } else if($A.get("$Browser.isAndroid")){
            $A.util.removeClass(component.find("tableThTr"),'tableThTrIphone');
            $A.util.addClass(component.find("tableThTr"),'tableThTrAndroid');
        }
        
        var growerAccId=component.get("v.growerAccId");
        var action = component.get("c.GrowerFarmSizeDetails");
        action.setParams({
            growerAccId :growerAccId,
            fiscalyr : fiscalyr,
            uom: uom
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
             growerAccFarmJson = (JSON.parse(response.getReturnValue()));
               
               //this.getSeasonDetails(component,event,helper);
               component.set("v.growerAccFarm", growerAccFarmJson);
                /*if(growerAccFarmJson.displayMsg == true){
                    var errorMsg = $A.get("$Label.Update_Farming_Area_Alert");
                    console.log("Error msg" , errorMsg);
                    //component.set("v.errorMsg",'**********Please update Total Area for Current FY**********');
                } */
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
            }
                        //console.log('Labels' +JSON.stringify(growerAccFarmJson.Labels));

               //var growerAccFarmResult =component.get("v.growerAccFarm");
                for(var i=0;i<growerAccFarmJson.Labels.length;i++){
                // console.log('Testtttttttt'+growerAccFarmJson[i].Area_Usage_Descr__c);
                    //labels.push('<p style="color:red;">'+growerAccFarmJson.Labels[i]+'</p>') ;
                    labels.push(growerAccFarmJson.Labels[i]) ; 
 
                }
                for(var i=0;i<growerAccFarmJson.growerAccountCroparea.length;i++){
                
                  Datas.push(growerAccFarmJson.growerAccountCroparea[i]) ; 
                }
            //if((JSON.parse(response.getReturnValue()) != )
            var data = {
            labels: labels,
                    
            datasets: [
                {
                    
                    data: Datas,
                    backgroundColor: [
                        "rgba(254, 102, 0, 1)",
                        "rgba(0, 127, 0, 1)",
                        "rgba(127, 127, 127, 1)",
                         "rgba(227,227,228,1)"
                    ],
                     
                    hoverBackgroundColor: [
                        "rgba(254, 102, 0, 1)",
                        "rgba(0, 127, 0, 1)",
                        "rgba(127, 127, 127, 1)",
                        "rgba(227,227,228,1)"
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
                bodyFontSize: 25,
                callbacks : {
                    label : function(tooltipItem, data) {
                        var label =  (data.labels[tooltipItem.index])
                        label = label.substring(label.indexOf("|")+1,label.indexOf(":"));
                        var data = data.datasets[0].data[tooltipItem.index]+'%';
                        return label+': '+data;
                    },
                }
            }
        }
        var el = document.getElementById("myDoughnutChart");
        var ctx = el.getContext("2d");
        console.log(ctx + 'ctx');
        /*new Chart(ctx).Line(data, {
         showScale: false
       });*/
        //var myBarChart1 = new Chart(document.getElementById("myDoughnutChart").getContext("2d"), {
           
                console.log('myBarChart1 if'+myBarChart1);
              myBarChart1 = new Chart(ctx, {
            type: 'doughnut',
            data: data,
            options:options
        });  
            
            
            
            if(growerAccFarmJson.growerTotalArea === null){
                growerAccFarmJson.growerTotalArea = 'N/A';
                
                
            }
            if(growerAccFarmJson.growerTotalArea != 'N/A'){
             document.getElementById('chartLegend').style.display = "block";
              document.getElementById("myDoughnutChart").style.display = "block";
              document.getElementById('message').style.display = "none";

                document.getElementById('chartLegend').innerHTML = myBarChart1.generateLegend() +'<span style="padding-left:30px;">Total :' +growerAccFarmJson.growerTotalArea+'</span>';
        $A.util.addClass(component.find('chartLegend'),'chart-legenddough');
            }
            else{
                document.getElementById('message').style.display = "block";
                document.getElementById('chartLegend').style.display = "none";
                document.getElementById("myDoughnutChart").style.display = "none";

            }
            if(document.getElementById('chartLegend').childNodes[0]){
                var element =document.getElementById('chartLegend').childNodes[0].childNodes;
                var node;
                var styleVar;
                console.log('element'+JSON.stringify(document.getElementById('chartLegend')));
                for(var i=0;i<element.length;i++){
                    node = element[i];
                    styleVar =  JSON.stringify(element[i].childNodes[0].style.backgroundColor);
                    styleVar = styleVar.substring(1, styleVar.length-2);
                    
                    if(styleVar != undefined){
                        node.setAttribute('style','color :'+styleVar);
                    }
                    
                } 
            }
            //element[0].style.color = element[0].childnodes.style.backgroundcolor ;
       
           
        });
        $A.enqueueAction(action);
    },
    updCurrentFYArea : function(component,event,helper) {
        var crop1select= component.find("selectCrop1").get("v.value");
        var crop2select = component.find("selectCrop2").get("v.value");
        var crop3select = component.find("selectCrop3").get("v.value");
        var totalArea = component.find("totalarea").get("v.value");
        var cornArea = (component.find("Crop1").get("v.value") != undefined ? component.find("Crop1").get("v.value") : 0);
        var soyArea = (component.find("Crop2").get("v.value") != undefined ? component.find("Crop2").get("v.value") : 0);
        var cottonArea = (component.find("Crop3").get("v.value") != undefined ? component.find("Crop3").get("v.value") : 0);    
           if((Number(cornArea) + Number(soyArea) + Number(cottonArea)) > Number(totalArea)){
               alert($A.get("$Label.c.GME_CROP_Quantity_Error"));
           }
        else{
            var action = component.get("c.getupdateFYArea");
            var growerAccId=component.get("v.growerAccId");
			var seasonKey = component.get("v.seasonKey"); 
			if(seasonKey == null){
				seasonKey ='';
			}
            action.setParams({
                growerAccId : growerAccId,
				crop1select : crop1select,
				crop2select : crop2select,
				crop3select : crop3select,
				totalArea : totalArea,
				cornArea : cornArea,
				soyArea : soyArea,
				cottonArea : cottonArea,
				seasonKey : ''              
				
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    //alert('Value Updated Successfully');
                    //component.set("v.selectCrop1" ,"");
                    
                   
                    component.find("selectCrop1").set("v.value","");
                    component.find("selectCrop2").set("v.value","");
                    component.find("selectCrop3").set("v.value","");
                    component.find("totalarea").set("v.value","");
                    component.find("Crop1").set("v.value","");
                    component.find("Crop2").set("v.value","");
                    component.find("Crop3").set("v.value","");
                   // if(response.getReturnValue() != ''){
                    alert('Updated Successfully');
                   // }
                   // else{
                       // alert($A.get("$Label.c.GME_CROP_Quantity_Error"));
                   // }
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        }
    }
});