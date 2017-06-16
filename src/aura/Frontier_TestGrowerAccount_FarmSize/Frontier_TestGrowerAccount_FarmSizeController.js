({
    loadFormSizeChart : function(component, event, helper) {
        var fiscalyr = null;
        var uom = null;
        helper.loadFormSizeChartData(component,fiscalyr,uom);
    },
    update : function(component, event, helper){
        if(component.isValid()){
            component.destroy();
        }
    },
    changeChart : function(component, event, helper){
        var fiscalyr;
        var uom;
        var prevId = component.get("v.prevID");
        var prevfiscalId = component.get("v.prevfiscalID");
        console.log('event.target.id' + event.target.id);
        console.log('prevfiscalId' + prevfiscalId);
        console.log('prevId' + prevId);
        if(prevId === '' && event.target.id == 'hectares'){
            $A.util.toggleClass(document.getElementById('acres'), 'buttonColor');
            $A.util.toggleClass(document.getElementById('hectares'), 'buttonColor');
        }
        if(prevId != '' && prevId != event.target.id && (event.target.id === 'acres' || event.target.id === 'hectares')){
            $A.util.toggleClass(document.getElementById('acres'), 'buttonColor');
            $A.util.toggleClass(document.getElementById('hectares'), 'buttonColor');
        }
        if(prevfiscalId == '' && event.target.id == 'FY15'){
            $A.util.toggleClass(document.getElementById('FY16'), 'buttonColor');
            $A.util.toggleClass(document.getElementById('FY15'), 'buttonColor');
        }
        if(prevfiscalId != '' && prevfiscalId != event.target.id && (event.target.id == 'FY16' || event.target.id == 'FY15')){
            $A.util.toggleClass(document.getElementById('FY16'), 'buttonColor');
            $A.util.toggleClass(document.getElementById('FY15'), 'buttonColor');
        } 
        var itemNode = document.getElementById('myDoughnutChart');
        itemNode.parentNode.removeChild(itemNode);
        document.getElementById('chartDivDoughnut').innerHTML = '<canvas id="myDoughnutChart" class="myChartLarge canvasPosition"></canvas>'; 
        if(prevId === '' && (event.target.id === 'acres' || event.target.id === 'hectares')){
            uom = event.target.id;
            console.log('Inside uom' + uom);
        } 
        else if(prevId != '' && (event.target.id === 'acres' || event.target.id === 'hectares')){
            uom = event.target.id;
            console.log('Inside uom 1' + uom);
        }
            else if(prevId != '' && (event.target.id === 'FY15' || event.target.id ==='FY16')){
                uom = prevId;
            }
        
        if(prevfiscalId === '' && (event.target.id === 'FY15' || event.target.id ==='FY16')){
            fiscalyr = event.target.id; 
        }
        else if(prevfiscalId != '' && (prevfiscalId != event.target.id) && (event.target.id === 'FY15' || event.target.id ==='FY16')){
            fiscalyr = event.target.id; 
        }
            else if(prevfiscalId != '' && (event.target.id === 'acres' || event.target.id === 'hectares')){
                fiscalyr = prevfiscalId;   
            }
                else if(prevfiscalId === '' && (event.target.id === 'acres' || event.target.id === 'hectares')){
                    fiscalyr = null; 
                }
        if(event.target.id === 'FY15' || event.target.id === 'FY16'){
            component.set("v.prevfiscalID",event.target.id);
        }
        else if(prevfiscalId === '' && (event.target.id === 'acres' || event.target.id === 'hectares')){
            component.set("v.prevfiscalID",'FY16');
        }   
        
        if(event.target.id === 'acres' || event.target.id === 'hectares'){
            component.set("v.prevID",event.target.id);     
        }
        console.log('fiscalyr' + fiscalyr + ' '+ 'uom' + uom);
        helper.loadFormSizeChartData(component,fiscalyr,uom);   
        
    },   
})