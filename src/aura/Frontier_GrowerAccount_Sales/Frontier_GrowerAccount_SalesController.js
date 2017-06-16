({
   
    loadChart : function(component, event, helper){
        
        helper.loadChartData(component, event);
    },
    doInit : function(component, event, helper){
       component.set("v.prevID","");  
       helper.getMonsantoShare(component); 
    }, 
    update : function(component, event, helper){
        if(component.isValid()){
           component.destroy();
        }
    },
    getCropDetails : function(component, event, helper) {
        if(event.target.id != null && event.target.id == 'Area'){
            component.set("v.CropData", 'Area');
        }
        if(!$A.util.isEmpty(event.target.id)){ 
            var prevId = component.get("v.prevID"); 
           if(prevId === '' && event.target.id != 'Units'){
               $A.util.toggleClass(document.getElementById('Units'), 'buttonColor');
                $A.util.toggleClass(document.getElementById('Area'), 'buttonColor'); 
            }
              if(prevId != '' && prevId != event.target.id){
                $A.util.toggleClass(document.getElementById('Units'), 'buttonColor');
                $A.util.toggleClass(document.getElementById('Area'), 'buttonColor');
            }
            component.set("v.CropData",event.target.id);
             
            var itemNode = document.getElementById('myChart');
            itemNode.parentNode.removeChild(itemNode);
            document.getElementById('chartDiv').innerHTML = '<canvas id="myChart" class= "canvasPosition"></canvas>';
            helper.loadChartData(component);
            component.set("v.prevID",event.target.id);
        }
    }
})