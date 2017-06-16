({
   /* afterRender: function(component, helper) {
        console.log('rerender');
        var itemNode = document.getElementById('myDoughnutChart');
        itemNode.parentNode.removeChild(itemNode);
        document.getElementById('chartDivDoughnut').innerHTML = '<canvas id="myDoughnutChart" class="myChartLarge canvasPosition"></canvas>'; 
        return this.superAfterRender();
    },
    
   rerender : function(cmp, helper){
       var itemNode = document.getElementById('myDoughnutChart');
       itemNode.parentNode.removeChild(itemNode);
       document.getElementById('chartDivDoughnut').innerHTML = '<canvas id="myDoughnutChart" class="myChartLarge canvasPosition"></canvas>';   
       return this.superRerender();    
}*/
unrender: function () {
    	var itemNode = document.getElementById('myDoughnutChart');
        itemNode.parentNode.removeChild(itemNode);
    	return this.superUnrender();
}
})