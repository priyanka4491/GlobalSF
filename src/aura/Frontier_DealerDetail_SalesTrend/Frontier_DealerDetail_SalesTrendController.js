({
	loadChart : function(component, event, helper) {
        var crop ='CORN'
       // helper.toggleButton(component,event,'Corn','Soy');
       helper.getPicklistValues(component,event,helper);
		helper.chartLoad(component,event,crop);
	},
    
    switchChart : function(component, event, helper) {
        //var crop = event.currentTarget.Id;
        var crop = component.find("crop").get("v.value");
        if(!$A.util.isEmpty(component.find("crop").get("v.value"))){
            var itemNode = document.getElementById('salesTrendChart');
            itemNode.parentNode.removeChild(itemNode);
            document.getElementById('salesTrendDiv').innerHTML = '<canvas id="salesTrendChart"></canvas>';
            /*if(event.target.id === 'Corn'){
                helper.toggleButton(component,event,'Corn','Soy');
				helper.chartLoad(component,event,component.get('v.Corn'), component.get('v.OrderCorn'),crop);
            }else if(event.target.id === 'Soy'){
			    helper.toggleButton(component,event,'Soy','Corn');
				helper.chartLoad(component,event,component.get('v.Soy'), component.get('v.OrderSoy'),crop);
            }*/
             helper.chartLoad(component,event,crop);
        }
        
    }
})