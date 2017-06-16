({
    doInit : function(component, event, helper){
        helper.navigateToAccountDashboard(component, event);
        //helper.getInprogressTask(component, event);
    },
    onScroll :function(component, event, helper){
    },
    ToggleTabs : function(component, event, helper) {
        var targetObjId=event.target.id;
        if(targetObjId === ''){
            targetObjId = event.target.parentElement.id;
            if(targetObjId === '' || (targetObjId.length === 0)){
                targetObjId = event.target.parentElement.parentElement.id;
                if(targetObjId === '' || (targetObjId.length === 0)){
                    targetObjId = event.target.parentElement.parentElement.parentElement.id;
                    if(targetObjId === '' || (targetObjId.length === 0)){
                        targetObjId = event.target.parentElement.parentElement.parentElement.parentElement.id;
                        if(targetObjId === '' || (targetObjId.length === 0)){
                            targetObjId = event.target.parentElement.parentElement.parentElement.parentElement.parentElement.id;
                    }
                }
            }
        }
    }
        if (typeof targetObjId !== "undefined") {
            var tab1 = component.find('tab-scoped-1__item_medium');
            var tab2 = component.find('tab-scoped-2__item_medium');
            var tab3 = component.find('tab-scoped-3__item_medium');
            var tab4 = component.find('tab-scoped-4__item_medium');
            var item1 = component.find('custom-tab-scoped-1');
            var item2 = component.find('custom-tab-scoped-2');
            var item3 = component.find('custom-tab-scoped-3');
            var item4 = component.find('custom-tab-scoped-3');
            if(targetObjId === 'tab-scoped-2__item_medium'){
                $A.util.addClass(tab2, "slds-active");
                $A.util.removeClass(tab1, "slds-active");
                $A.util.removeClass(tab3, "slds-active");
                $A.util.removeClass(tab4, "slds-active");
                $A.util.removeClass(item1, "slds-show");
                $A.util.addClass(item1, "slds-hide");
                $A.util.removeClass(item2, "slds-hide");
                $A.util.addClass(item2, "slds-show");
                $A.util.removeClass(item3, "slds-show");
                $A.util.addClass(item3, "slds-hide");
                $A.util.removeClass(item4, "slds-show");
                $A.util.addClass(item4, "slds-hide");
            }
            if(targetObjId === 'tab-scoped-1__item_medium'){
                $A.util.addClass(tab1, "slds-active");
                $A.util.removeClass(tab2, "slds-active");
                $A.util.removeClass(tab3, "slds-active");
                $A.util.removeClass(tab4, "slds-active");
                $A.util.removeClass(item2, "slds-show");
                $A.util.addClass(item2, "slds-hide");
                $A.util.removeClass(item3, "slds-show");
                $A.util.addClass(item3, "slds-hide");
                $A.util.removeClass(item4, "slds-show");
                $A.util.addClass(item4, "slds-hide");
                $A.util.removeClass(item1, "slds-hide");
                $A.util.addClass(item1, "slds-show");
            }
            if(targetObjId === 'tab-scoped-3__item_medium'){
                $A.util.addClass(tab3, "slds-active");
                $A.util.removeClass(tab1, "slds-active");
                $A.util.removeClass(tab2, "slds-active");
                $A.util.removeClass(tab4, "slds-active");
                $A.util.removeClass(item2, "slds-show");
                $A.util.addClass(item2, "slds-hide");
                $A.util.removeClass(item1, "slds-show");
                $A.util.addClass(item1, "slds-hide");
                $A.util.removeClass(item4, "slds-show");
                $A.util.addClass(item4, "slds-hide");
                $A.util.removeClass(item3, "slds-hide");
                $A.util.addClass(item3, "slds-show");
            }
            if(targetObjId === 'tab-scoped-4__item_medium'){
                $A.util.addClass(tab4, "slds-active");
                $A.util.removeClass(tab1, "slds-active");
                $A.util.removeClass(tab2, "slds-active");
                $A.util.removeClass(tab3, "slds-active");
                $A.util.removeClass(item2, "slds-show");
                $A.util.addClass(item2, "slds-hide");
                $A.util.removeClass(item1, "slds-show");
                $A.util.addClass(item1, "slds-hide");
                $A.util.removeClass(item3, "slds-show");
                $A.util.addClass(item3, "slds-hide");
                $A.util.removeClass(item4, "slds-hide");
                $A.util.addClass(item4, "slds-show");
            }
            if(targetObjId.split("_")[0] === "tab-scoped-2") {
                helper.navigateToAccountList(component, event);
            }
            if(targetObjId.split("_")[0] === "tab-scoped-1") {
                helper.navigateToAccountDashboard(component, event);
                helper.getInprogressTask(component, event);
            }
            if(targetObjId.split("_")[0] === "tab-scoped-3") {
                helper.navigateToVisitListReport(component, event);
            }
            if(targetObjId.split("_")[0] === "tab-scoped-4") {
                helper.navigateToFollowUpList(component, '');
            }
        }
    },
    gettingTheComponentGlobalId:function(component, event) {
        component.set("v.globalId",event.getParams("componentGlobalId"));
    },
    showSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "xc-hidden");
    },
    hideSpinner : function (component) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "xc-hidden");
    },
    checkAll : function(component){
        var i;
        for(i=0;i<component.get("v.totaltask");i++) {
            if(document.getElementById('headercheckbox').checked){
                document.getElementById('tasks_'+i).checked = true;
            }else if(!document.getElementById('headercheckbox').checked){
                document.getElementById('tasks_'+i).checked = false;
            }
        }
    },
    dismissTask : function(component,event,helper) {
        var i;
        var taskId='';
        var taskIdsArray= [];
        for(i=0;i<component.get("v.totaltask");i++) {
            if(document.getElementById('tasks_'+i).checked){
                taskIdsArray.push(document.getElementById('tasks_'+i).value);
            }
        }
        taskId += taskIdsArray;
        if(taskIdsArray.length > 0) {
            $A.util.removeClass(component.find('notification'), 'slds-show');
            $A.util.addClass(component.find('notification'), 'slds-hide');
            helper.endTask(component,event,taskId);
            helper.closeModel(component,event);
            component.set("v.showReminderPopUpFlag","false");
        } else {
            $A.util.removeClass(component.find('notification'), 'slds-hide');
            $A.util.addClass(component.find('notification'), 'slds-show');
        }
    },
    closeModel : function(component,event,helper){
        helper.closeModel(component,event);
        component.set("v.showReminderPopUpFlag","false");
    },
    closeNotification : function(component) {
         $A.util.removeClass(component.find('notification'), 'slds-show');
         $A.util.addClass(component.find('notification'), 'slds-hide');
    },
    handleTouchmove : function(component, event, helper){
        var startY = event.target.offsetTop;
        console.log("offsetTop::" +startY);
        var el = document.getElementById('sideMenu');
        if(el){
            el.style.position = 'absolute';
            el.style.top = startY +'px';
        }
    },
   ToggleChevron: function(component,event,helper){
        var targetId = event.currentTarget.id;
        if(targetId != '' && targetId != 'undefined'){
            if(targetId === 'chevronright'){
                $A.util.removeClass(document.getElementById('chevronright'), 'slds-show');
                $A.util.addClass(document.getElementById('chevronright'), 'slds-hide');
                $A.util.removeClass(document.getElementById('chevronleft'), 'slds-hide');
                $A.util.addClass(document.getElementById('chevronleft'), 'slds-show');
                $A.util.removeClass(component.find('sideMenu'), 'slds-hide');
                $A.util.addClass(component.find('sideMenu'), 'slds-show');
            }
            else if(targetId === 'chevronleft'){
                $A.util.removeClass(document.getElementById('chevronright'), 'slds-hide');
                $A.util.addClass(document.getElementById('chevronright'), 'slds-show');
                $A.util.removeClass(document.getElementById('chevronleft'), 'slds-show');
                $A.util.addClass(document.getElementById('chevronleft'), 'slds-hide');
                $A.util.removeClass(component.find('sideMenu'), 'slds-show');
                $A.util.addClass(component.find('sideMenu'), 'slds-hide');
            }
        }
        console.log("Event Object::" +event);
    },
    navigateFollowUplistFromRemainderPopUp : function(cmp,event,helper) {
        helper.navigateToFollowUpList(cmp,event.target.id);
    }
});