({
    redirectTonewTouchpoint : function(component, event, ids, date, actionStatus,isreadOnly){
        var parsedDate;
        if(date){
            parsedDate = date.format();
        }
        /*$A.createComponent("c:Frontier_GrowerAccount_UpdateTouchPoint",
                           {
                               "clickdate":date,
                               "newUpdateStatus":actionStatus,
                               "growerAcc": ids,
                               "isFromCalendar":true,
                               "isReadOnly":isreadOnly
                           },
                           function(touchPoint){
                               var comp = component.find("calenderBody");
                               comp.set("v.body",touchPoint);
                           });*/

        //var comp = component.find("calenderBody");
        //comp.set("v.body",[]);
        //this.removejscssfile(component,event,'Momentjs.js','js');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Frontier_GrowerAccount_UpdateTouchPoint",
            componentAttributes: {
                clickdate:parsedDate,
                newUpdateStatus:actionStatus,
                growerAcc: ids,
                isFromCalendar:true,
                isReadOnly:isreadOnly,
                isLoaded:true
            }
        });
        evt.fire();

        //var compEvent = component.getEvent("masterCalendarEvent");
        //compEvent.fire();
    },
    loadCalendarData : function(component, event, helper){
        var action = component.get("c.getAllTouchPoints");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var touchPointList = JSON.parse(response.getReturnValue()); 
				var eventsources  = helper.convertToCalendarFormat(component, event, helper,touchPointList);
                helper.loadDatatoCalendar(component, event, helper,eventsources);
            } else if (response.getState() === "ERROR") {
                $A.log("Errors", response.getError());
            }
        });
        
        $A.enqueueAction(action);         
    },
    convertToCalendarFormat : function(component,event,helper,touchPointList){
        var eventSources = [];
        var eventsArray;
        console.log('touchPointList=>'+JSON.stringify(touchPointList));
        $.map(touchPointList, function(value, key){
            eventsArray=[];
            var objevent;
            var titleText = '';
            for(var i in value){
                objevent = {"id":'',"title":'',"start":'',"color":'',"textColor":'',"isReadOnly":false};
                objevent.id = value[i].Program_SFID__c+'/'+value[i].WhatId+','+','+'/'+value[i].Program_Activity_SFID__c+'/'+value[i].TouchPoint_SFID__c+'/'+value[i].TouchPoint_SFID__r.Date__c+'/'+'';
                if(value[i].TouchPoint_SFID__r.Name){
                 titleText = '<b>'+value[i].TouchPoint_SFID__r.Name+'</b>';
                }
                for(var j in value){
                    titleText = titleText + '<br>' + (value[j].Subject?value[j].Subject:''); 
                }
                objevent.title = titleText;
                var startDate = value[i].TouchPoint_SFID__r.Date__c;
               	var format = 'YYYY/MM/DD HH:mm:ss ZZ';
               	var zone = $A.get("$Locale.timezone");
    			var parsedDate = moment(startDate, format).tz(zone).format(format);
               	console.log("StartDate!!!" + startDate);
                if(!$A.util.isUndefinedOrNull(parsedDate)){
                    objevent.start = parsedDate;
                }
                 if(value[i].TouchPoint_SFID__r.TouchPoint_Status__c === 'Scheduled'){
                  objevent.color = '#66ccff';          
                 }
                 else if(value[i].TouchPoint_SFID__r.TouchPoint_Status__c === 'Cancelled'){
                  objevent.color = 'rgba(255, 0, 0, 0.498039215686275)'; 
                  objevent.isReadOnly = true;
                 }
                else if (value[i].TouchPoint_SFID__r.TouchPoint_Status__c === 'Completed'){
                  objevent.color = '#00ff00'; 
                  objevent.isReadOnly = true;
                }
                objevent.textColor = '#000000';
                if(objevent.title && objevent.start){
                 eventsArray.push(objevent);
                 break;
                }
            }
            eventSources.push({events:eventsArray});
        });        
        return eventSources;
    },
    loadDatatoCalendar :function(component,event,helper,eventSources){
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title,\n,month,agendaWeek,agendaDay'
            },
            timezone:'UTC',
            editable : true,
            eventStartEditable : true,
            defaultView: 'month',
            eventSources: eventSources,
            dayClick: function(date, allDay, jsEvent, view){
                var ids = ''+'/'+'0012C00000AsKGzQAN'+','+'a0g2C000000UynxQAC'+'/';
                var isPastDated =  $(this).hasClass("fc-other-month fc-past");
                var isFutureDated = $(this).hasClass("fc-other-month fc-future");
                if(!isPastDated && !isFutureDated){
                    helper.redirectTonewTouchpoint(component, event, ids, date,'New',false);   
                    
                }
            },
            eventClick: function(calEvent, jsEvent, view) {
                var spinner = component.find('spinner');
                $A.util.removeClass(spinner, "xc-hidden");
                var actionStatus = 'update';
                if(calEvent.isReadOnly){
                    actionStatus = 'view';
                }
                helper.redirectTonewTouchpoint(component,event,calEvent.id,'',actionStatus,calEvent.isReadOnly);
            },
            eventRender: function(event, element, view) {
                if (view.name === 'month') {
                    element.find('span.fc-title').html(element.find('span.fc-title').text());
                } else if (view.name === 'agendaWeek' || view.name === 'agendaDay') {
                    element.find('div.fc-title').html(element.find('div.fc-title').text());
                }
            }
        });
    },
    removejscssfile :function(component, event, filename, filetype){
        var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none" //determine element type to create nodelist from
        var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none" //determine corresponding attribute to test for
        var allsuspects=document.getElementsByTagName(targetelement)
        for (var i=allsuspects.length; i>=0; i--){ //search backwards within nodelist for matching elements to remove
            if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(filename)!=-1)
                allsuspects[i].parentNode.removeChild(allsuspects[i]) //remove element by calling parentNode.removeChild()
                }
    }
})