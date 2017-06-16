({
    getsEventRecords : function(component, event,page, helper,isInitialize) {
        var isExport = component.get("v.isExport");
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        console.log(pageSize + 'pageSize');
        console.log(page + 'page');
        var sortByType = component.find("sortByType").get("v.value");
        var sortByRADL = component.find("sortByRADL").get("v.value");
        var sortByMonth= component.find("MonthSort").get("v.value");
        //var sortByCountry = component.find("CountrySort").get("v.value");
       
        console.log('sortByRADL' + sortByRADL);
        console.log('sortByMonth' + sortByMonth);
        //console.log('sortByCountry' + sortByCountry);
        //var eventList = component.find("eventList").get("v.value");
        var action = component.get("c.getVisitDetails");
        action.setParams({
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            sortByType : sortByType,
            sortByRADL : sortByRADL,
            sortByMonth : String(sortByMonth),
            //sortByCountry : String(sortByCountry),
            isExport : isExport
        });        
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                
                var message = "E-Mail has been sent";
                console.log('Response=>'+response.getReturnValue().length);
                var resp = response.getReturnValue();
                var visitDetailJson =JSON.parse(response.getReturnValue());
                console.log('parsed json'+visitDetailJson.length)
                if(visitDetailJson.length > 0){
                console.log(visitDetailJson[0].Count + 'Total');
                
                component.set("v.total",visitDetailJson[0].Count);
                component.set("v.pages",Math.ceil((visitDetailJson[0].Count)/component.get("v.pageSize")));
                component.set("v.page",page);
                }
                else if(visitDetailJson.length == 0){
                    component.set("v.total",0);
                    component.set("v.pages",1);
                    component.set("v.page",1);
                }
                                
                if(isExport){                    
                   this.showPopUp(component,event,message); 
                }
                component.set("v.isExport",false);
                component.set("v.visits", visitDetailJson);                
            }
            else if (state === "ERROR"){
                var errors = response.getError();
                if (errors){
                    if (errors[0] && errors[0].message){
                        console.log("Error message: "+errors[0].message);
                    }
                } else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
     showPopUp: function(component,event,message){
        console.log("Inside showPop" + message);
        
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message
                           },
                           function(newComp){
                               console.log('pop');
                               var comp = component.find("visitreportpopup");
                               comp.set("v.body",newComp);
                           });
    }
})