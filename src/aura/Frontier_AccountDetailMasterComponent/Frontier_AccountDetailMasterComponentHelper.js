({
    navigateToAccountList : function(component){
        console.log('Inside Frontier_AccountList');
        $A.createComponent("c:Frontier_AccountList",
                           {label : ""},
                           function(Accounts){
                               console.log('AccountList==>'+Accounts);
                               var comp = component.find("tab-scoped-2");
                               comp.set("v.body",Accounts);
                           }
                          );
        console.log('Done Frontier_AccountList');
        //c:Frontier_AccountList
    },
    navigateToAccountDashboard:function(component){
        console.log('Inside Frontier_AccountDashboard');
        $A.createComponent("c:Frontier_AccountDashboard",
                           { "aura:id" : "test",
                            "label" : "testing"
                           },
                           function(AccountDashboard){
                               console.log('Frontier_AccountDashboard');
                               var comp = component.find("tab-scoped-1");
                               comp.set("v.body",AccountDashboard);
                           }
                          );
        console.log('Done Frontier_AccountDashboard');
    },
    navigateToVisitListReport:function(component){
        $A.createComponent("c:Frontier_EventList",
                           {label :""},
                           function(visitListReport){
                               var comp = component.find("tab-scoped-3");
                               comp.set("v.body",visitListReport);
                           });
    },
    navigateToFollowUpList:function(component,taskId){
        if(taskId === '') {
            $A.createComponent("c:Frontier_FollowUpReport",
                               {label :""},
                               function(followUpListReport){
                                   var comp = component.find("tab-scoped-3");
                                   comp.set("v.body",followUpListReport);
                               });
        }else {
            console.log('taskId=>'+taskId);
            this.closeModel(component,event);
            $A.util.addClass(component.find('tab-scoped-4__item_medium'), "slds-active");
            $A.util.removeClass(component.find('tab-scoped-1__item_medium'), "slds-active");
            $A.util.removeClass(component.find('tab-scoped-2__item_medium'), "slds-active");
            $A.util.removeClass(component.find('tab-scoped-3__item_medium'), "slds-active");
            $A.util.removeClass(component.find('custom-tab-scoped-2'), "slds-show");
            $A.util.addClass(component.find('custom-tab-scoped-2'), "slds-hide");
            $A.util.removeClass(component.find('custom-tab-scoped-1'), "slds-show");
            $A.util.addClass(component.find('custom-tab-scoped-1'), "slds-hide");
            $A.util.removeClass(component.find('custom-tab-scoped-3'), "slds-show");
            $A.util.addClass(component.find('custom-tab-scoped-3'), "slds-hide");
            $A.util.removeClass(component.find('custom-tab-scoped-3'), "slds-hide");
            $A.util.addClass(component.find('custom-tab-scoped-3'), "slds-show");
            $A.createComponent("c:Frontier_FollowUpReport",
                               {taskId : taskId},
                               function(followUpListReport){
                                   var comp = component.find("tab-scoped-3");
                                   comp.set("v.body",followUpListReport);
                               });
        }
    },
    getInprogressTask : function(component,event){
        var action = component.get("c.getallTask");
        action.setCallback(this,function(response){
            var task;
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('Return Value' + response.getReturnValue());
                task = JSON.parse(response.getReturnValue());
                if(task[0].taskTotalRecords > 0 && component.get("v.showReminderPopUpFlag") === true){
                    component.set("v.totaltask",task[0].taskTotalRecords);
                    component.set("v.task", task[0].taskLists);
                    this.showModel(component,event);
                } else {
                    this.closeModel(component,event);
                }
                console.log('task Lenght'+task[0].taskTotalRecords);
                console.log('Success Task');
                console.log('component.get("v.showReminderPopUpFlag")=>'+component.get("v.showReminderPopUpFlag"));
            }else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
    },
    endTask : function(cmp,events,taskId) {
        var action = cmp.get('c.dismissTasks');
        action.setParams({
            taskIds: taskId
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS"){
                console.log('response=>'+response);
            }
        });
        $A.enqueueAction(action);
    },
    closeModel : function(component){
        $A.util.removeClass(component.find('showActivities'), 'slds-fade-in-open');
        $A.util.addClass(component.find('showActivities'), 'slds-fade-in-close');
        $A.util.removeClass(component.find('showActivitiesBackGround'), 'slds-backdrop--open');
        $A.util.addClass(component.find('showActivitiesBackGround'), 'slds-backdrop--close');
    },
    showModel : function(component){
        $A.util.removeClass(component.find('showActivities'), 'slds-fade-in-close');
        $A.util.addClass(component.find('showActivities'), 'slds-fade-in-open');
        $A.util.removeClass(component.find('showActivitiesBackGround'), 'slds-backdrop--close');
        $A.util.addClass(component.find('showActivitiesBackGround'), 'slds-backdrop--open');
    }
});