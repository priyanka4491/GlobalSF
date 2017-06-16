({
    loadprogramplanningChartData1 : function(component,event,helper) {
        
        console.log('Inside chart');
        var dchart = 'myChar'+component.get("v.programId");
        console.log(dchart + 'dchart');
        var el = document.getElementById(dchart);
                    console.log(el + 'el');
                    var context = el.getContext('2d');
        console.log('Programs'+component.get("v.program1"));
        var dataSet = [component.get("v.program1"),component.get("v.program2"),component.get("v.program3")];
	
	
	var data = {
		//labels: ['Product 1<br /><span style="Padding-left:24%;">Programs:'+component.get("v.program1")+'</span>','Product 2 <br /><span style="Padding-left:24%"> Programs:'+component.get("v.program2")+'</span>','Product 3 <br /> <span style="Padding-left:24%"> Programs:'+component.get("v.program3")+'</span>'],
		labels: ['Product-1 \n\n Programs:'+component.get("v.program1"),'Product-2 \n\n Programs:'+component.get("v.program2"),'Product-3 \n\n Programs:'+component.get("v.program3")],
		//labels: ['Product 1','Product 2','Product 3'],
		datasets: [
			{
				data: dataSet,
				backgroundColor: [
					"#f5f5f5",
					"#999999",
					"#d9d9d9"
				]
			}]
	};
	
	var options = {
		showAllTooltips: false,
		segmentShowStroke: false,
		responsive : true,
		animateRotate: true,
		animateScale: false,
		//cutoutPercentage: 80,
		legend: {
			display : false,
			position:'right'
		},
		hover: {
			onHover: null,
			mode: 'single',
			animationDuration:0
		},
		animation: {
			duration: 0,
			onComplete: function () {
				var self = this,
					chartInstance = this.chart,
					ctx = chartInstance.ctx;
				
				ctx.font = '10px Arial';
				ctx.textAlign = "center";
				ctx.fillStyle = "black";
				
				Chart.helpers.each(self.data.datasets.forEach((dataset, datasetIndex) => {
					var meta = self.getDatasetMeta(datasetIndex),
					total = 0, //total values to compute fraction
					labelxy = [],
					offset = Math.PI / 2, //start sector from top
					radius,
					centerx,
					centery, 
					lastend = 0; //prev arc's end line: starting with 0
					
					for (var val of dataset.data) { total += val; } 
															  
															  Chart.helpers.each(meta.data.forEach((element, index) => {
					radius = element._model.outerRadius;
					centerx = element._model.x;
					centery = element._model.y;
					var thispart = dataset.data[index],
					arcsector = Math.PI * (2 * thispart / total);
					if (element.hasValue() && dataset.data[index] > 0) {
					labelxy.push(lastend + arcsector / 2 + Math.PI + offset);
				}
					else {
					labelxy.push(-1);
				}
					lastend += arcsector;
				}), self)
					
					var lradius = radius * 3 / 4;
					for (var idx in labelxy) {
					if (labelxy[idx] === -1) continue;
					var langle = labelxy[idx],
					dx = centerx + lradius * Math.cos(langle),
					dy = centery + lradius * Math.sin(langle),
					val = Math.round(dataset.data[idx] / total * 100);
					
					//ctx.fillText(self.data.labels[idx],dx, dy);
					wrapText(ctx,self.data.labels[idx],dx,dy,8,3);
					console.log('dx=>'+dx);
					console.log('dy=>'+dy);
					//ctx.fillText(dataset.data[idx], dx, dy);
				}
					
				}), self);
					
					function wrapText(context, text, x, y, maxWidth, lineHeight) {
					var cars = text.split("\n");
					
					for (var ii = 0; ii < cars.length; ii++) {
					
					var line = "";
					var words = cars[ii].split(" ");
					
					for (var n = 0; n < words.length; n++) {
					var testLine = line + words[n] + " ";
					var metrics = context.measureText(testLine);
					var testWidth = metrics.width;
					
					if (testWidth > maxWidth) {
					context.fillText(line, x, y);
					line = words[n] + " ";
					y += lineHeight;
				}
					else {
					line = testLine;
				}
				}
					
					context.fillText(line, x, y);
					y += lineHeight;
				}
				}
				}
				},
					
					tooltips: {
						enabled:false,
					}
				}
                    var canvas = document.getElementById(dchart);
                    console.log(canvas + 'el');
                    var ctx = canvas.getContext('2d');
        console.log(ctx + 'ctx');
                    ctx.canvas.width=150;
                    ctx.canvas.height=50;
                   /* var pgmid = component.get("v.programId");
        			//var dynamicId = 'myDoughnutChart1-'+pgmid;
        			//console.log('Dynamic ' + dynamicId);
                    var canvasel = component.find(pgmid);
        console.log('canvas' + canvasel);
        			var canvas = canvasel.getElement();
        			
                    var ctx = canvas.getContext('2d');*/
                    //document.getElementById("myDoughnutChart").getContext("2d")
                    var myBarChart1 = new Chart(ctx, {
                        type: 'doughnut',
                        data: data,
                        options:options
                    });
                    //document.getElementById('chartLegend').innerHTML = myBarChart1.generateLegend();
                    //$A.util.addClass(component.find('chartLegend'),'chart-legend');
                }
            })