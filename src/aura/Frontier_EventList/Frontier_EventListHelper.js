({
    getsEventObjectRecords : function(component,event,helper,page,isPageChange,isInitialize,createdByUsers) {
        console.log('YYYYYYYY'+createdByUsers);
        var isExport = component.get("v.isExport");
        //var sortByType = component.find("sortByType").get("v.value");
        var sortByMonth= component.find("MonthSort").get("v.value");
       var sortByRADLList = component.find("sortByRADLList").get("v.value");
        //console.log(sortByType + sortByType);
        console.log(sortByRADLList + sortByRADLList);
        var triggeredField = null;
        if(!isInitialize){
            if(event.target && event.target.id != null){
                triggeredField = component.get("v.SortByField."+event.target.id);
                component.set("v.triggeredField",triggeredField);
                console.log('Triggered Field'+triggeredField);
            }
            else if(isPageChange && component.get("v.triggeredField") != ""){
                triggeredField = component.get("v.triggeredField");
            }
        }
        /*if(!isInitialize && createdByUsers == ''){
        createdByUsers = (component.get("v.createdByUserIds") != null ? component.get("v.createdByUserIds") : '');
        }*/
        //var eventList = component.find("eventList").get("v.value");
        var action = component.get("c.findActivities");
        console.log('*****************'+page);
        console.log('triggeredField'+triggeredField);
        var page = page || 1;
        var pageSize=component.get("v.pageSize");
        //console.log(eventList + 'eventList');
        action.setParams({
            pageNumber : page,
            pageSize : component.get("v.pageSize"),
            triggeredField : triggeredField,
            isInitialize : isInitialize,
            isPageChange : isPageChange,
            isExport : isExport,
            sortByMonth : String(sortByMonth),
            sortByRADL :sortByRADLList,
            filterByCreatedUser : createdByUsers,
            filterByTeam : component.find('TeamSort').get("v.value")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var visitlist = [];
                var message = "E-Mail has been sent";
                var retResponse = response.getReturnValue();
                var users =[];
                var territory =[];
                
                if(retResponse.length > 0){
                    component.set("v.page",page);
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    visitlist = JSON.parse(retResponse[1]);
                    component.set("v.VisitDataList", visitlist);
                    console.log("Visit List"+ visitlist);
                    component.set("v.SortByField", JSON.parse(retResponse[2]));
                    console.log('Sort Order'+retResponse[2]);
                    console.log('retResponse[0].userIdAndUserNameMap=>'+retResponse[3]);
                    var userIdAndUserNameMap = JSON.parse(retResponse[3]);
                    var territoryMap = JSON.parse(retResponse[4]);
                    if(component.get("v.usersInitialLoad")){
                        for (var userId in userIdAndUserNameMap){
                            var optionValue={};
                            optionValue.class="optionClass";
                            optionValue.value = userId;
                            optionValue.label= userIdAndUserNameMap[userId];
                            users.push(optionValue);
                        }
                        component.find("createdUser").set("v.options",users);
                        for (var territoryId in territoryMap){
                            var territoryValues = {};
                            territoryValues.class="optionClass";
                            territoryValues.value = territoryId;
                            territoryValues.label= territoryMap[territoryId];
                            territory.push(territoryValues);
                        }
                        component.find("TeamSort").set("v.options",territory);

                    }
            }
            else if(retResponse.length == 0) {
                component.set("v.VisitDataList", visitlist);
                component.set("v.total",0);
                component.set("v.pages",1);
                component.set("v.page",1);
            }
            if(isExport){
                this.showPopUp(component,event,message); 
                
            }
            component.set("v.isExport",false);
        }else if (state === "ERROR"){
            console.log('Error');
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
} 
})