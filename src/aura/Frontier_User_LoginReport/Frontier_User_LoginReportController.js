({
    doInit : function(component, event, helper) {
        var pageChange = false;
        var page = component.get("v.page") || 1;
        component.set("v.monthOrCountrySort",false);
        component.set("v.selectedMonthOrCountry",'');
        helper.getsLogRecords(component,event,page,helper,pageChange);        
    },
    pageChange: function(component,event,helper) {
        var pageChange = true;
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        console.log("Page direction" + page);
        helper.getsLogRecords(component,event,page,helper,pageChange);
    },
    VisitsList:function(component,event,helper){
        var page = 1;
        var pageChange = false;
        component.set("v.monthOrCountrySort",false);
        component.set("v.selectedMonthOrCountry",'');
        helper.getsLogRecords(component,event,page,helper,pageChange);
    },
     exportData:function(component,event,helper){
        component.set("v.isExport",true);
        var page = 1;
         if(!component.get("v.monthOrCountrySort")){
        helper.getsLogRecords(component, event,page);
         }
         else{
             helper.monthORCountrySort(component, event,page);
         }
    },
    SortByMonth:function(cmp,event,helper){
        var page =1;
        cmp.set("v.monthOrCountrySort",true);
        cmp.set("v.selectedMonthOrCountry",cmp.find("MonthSort").get("v.value")+'/'+cmp.find("CountrySort").get("v.value"));
        cmp.set("v.selectedMonthOrCountryField","CALENDAR_MONTH(LoginTime)=/CountryIso=");
        helper.monthORCountrySort(cmp,event,page);
    },
    SortByCountry:function(cmp,event,helper){
        var page =1;
        cmp.set("v.monthOrCountrySort",true);
        cmp.set("v.selectedMonthOrCountry",cmp.find("MonthSort").get("v.value")+'/'+cmp.find("CountrySort").get("v.value"));
        cmp.set("v.selectedMonthOrCountryField","CALENDAR_MONTH(LoginTime)=/CountryIso=");
        helper.monthORCountrySort(cmp,event,page);
    }
})