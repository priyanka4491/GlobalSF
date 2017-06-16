({
   
    
 rerender : function(cmp, helper){
        console.log('rerender');
        var element = document.getElementsByClassName('chart-legenddough').childNodes;
        console.log('element'+element);
       return this.superRerender();    
}	
/*unrender: function () {
        console.log('unrender');
        var element = document.getElementsByClassName('chart-legenddough').childNodes;
        console.log('element'+element);
    	var itemNode = document.getElementById('myDoughnutChart');
        itemNode.parentNode.removeChild(itemNode);
    	return this.superUnrender();
}*/
})