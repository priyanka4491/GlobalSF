({
    getsLogRecords : function(component, event,page, helper,pageChange) {
        var isExport = component.get("v.isExport");
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        console.log(pageSize + 'pageSize');
        console.log(page + 'page');
        var logViewList = '';//component.find("LogView").get("v.value");
        var action = component.get("c.getLoggedDetails");
        if(!pageChange){
            var monthOpt = [
                { class: "optionClass", label: "Jan", value: "1"},
                { class: "optionClass", label: "Feb", value: "2"},
                { class: "optionClass", label: "Mar", value: "3"},
                { class: "optionClass", label: "Apr", value: "4"},
                { class: "optionClass", label: "May", value: "5"},
                { class: "optionClass", label: "Jun", value: "6"},
                { class: "optionClass", label: "Jul", value: "7"},
                { class: "optionClass", label: "Aug", value: "8"},
                { class: "optionClass", label: "Sep", value: "9"},
                { class: "optionClass", label: "Oct", value: "10"},
                { class: "optionClass", label: "Nov", value: "11"},
                { class: "optionClass", label: "Dec", value: "12"}
            ];
            component.find("MonthSort").set("v.options",monthOpt);
        }
        action.setParams({
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            logviews : logViewList,
            isExport : isExport,
            MonthOrCountrySort : component.get("v.monthOrCountrySort"),
            selectedMonthOrCountry : component.get("v.selectedMonthOrCountry"),
            selectedMonthOrCountryField : component.get("v.selectedMonthOrCountryField")
        });        
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var message = "E-Mail has been sent";
                console.log('Response=>'+response.getReturnValue());
                var logDetailJson =JSON.parse(response.getReturnValue());
                
                if(logDetailJson.length > 0){
                    var i;
                    console.log(logDetailJson[0].Count + 'Total');
                    var Countryopt=[];
                    if(!pageChange){
                        for (i = 0; i < logDetailJson[0].countrySet.length; i++) {
                            var optionValue={};
                            optionValue.class="optionClass";
                            optionValue.label = logDetailJson[0].countrySet[i];
                            optionValue.value= logDetailJson[0].countrySet[i];
                            Countryopt.push(optionValue);
                        }
                        component.find("CountrySort").set("v.options",Countryopt);
                    }
                    component.set("v.total",logDetailJson[0].Count);
                    component.set("v.pages",Math.ceil((logDetailJson[0].Count)/component.get("v.pageSize")));
                    component.set("v.page",page);
                }
                else if(logDetailJson.length == 0){
                    component.set("v.total",0);
                    component.set("v.pages",1);
                    component.set("v.page",1);
                }
                if(isExport){
                    this.showPopUp(component,event,message);               
                }
                component.set("v.isExport",false);
                component.set("v.logs", logDetailJson);
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
                               var comp = component.find("userpopup");
                               comp.set("v.body",newComp);
                           });
    },
    monthORCountrySort: function(component, event,page) {
        console.log("Month Selected=>"+component.get("v.selectedMonthOrCountry"));
        var isExport = component.get("v.isExport");
        var countrySorting = component.get("v.selectedMonthOrCountry").split('/')
        var action = component.get("c.getSortByMonthORCounty");
        action.setParams({
            MonthORCountry : component.get("v.selectedMonthOrCountry"),
            MonthORCountryField : component.get("v.selectedMonthOrCountryField"),
            isExport : isExport
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var message = "E-Mail has been sent";
                var logDetailJson =JSON.parse(response.getReturnValue());
                console.log('Response Sort=>'+response.getReturnValue());
                if(logDetailJson.length > 0){
                    console.log(logDetailJson[0].Count + 'Total');
                    var Countryopt=[];var i;
                    if(countrySorting.length === 2){
                        for (i = 0; i < logDetailJson[0].countrySet.length; i++) {
                            var optionValue={};
                            optionValue.class="optionClass";
                            optionValue.label = logDetailJson[0].countrySet[i];
                            optionValue.value= logDetailJson[0].countrySet[i];
                            if(countrySorting[1] != ''){
                                if(countrySorting[1].split(';').includes(logDetailJson[0].countrySet[i])){
                                    optionValue.selected= "true"
                                }
                            }
                            Countryopt.push(optionValue);
                        }
                        component.find("CountrySort").set("v.options",Countryopt);
                    }
                    component.set("v.total",logDetailJson[0].Count);
                    component.set("v.pages",Math.ceil((logDetailJson[0].Count)/component.get("v.pageSize")));
                    component.set("v.page",page);
                }
                else if(logDetailJson.length == 0){
                    component.set("v.total",0);
                    component.set("v.pages",1);
                    component.set("v.page",1);
                }
                if(isExport){
                    this.showPopUp(component,event,message);               
                }
                component.set("v.isExport",false);                
                component.set("v.logs", logDetailJson);
            }
        });
        $A.enqueueAction(action);
    }
})