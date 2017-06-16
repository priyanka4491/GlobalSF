({
    loadStaticResources : function(component, event, helper){
        console.log("Script Loaded");
    },
    doInit : function(component, event, helper) {
        helper.helperUpdateTouchPoint(component, event);
        //alert(component.get('v.accountId'));
    },    
    setMultipleAttributeToSelectdyanamically : function(component,event,helper){
        if(!(event.target.id).includes('activityOption') && !(event.target.id).includes('nonactivityOption') && event.target.id != ''){
            if(!document.getElementById(event.target.id).classList.contains('multiple')){
                helper.nonProgramdependentActivate(component, event);
                document.getElementById(event.target.id).setAttribute("multiple", "true");
                document.getElementById(event.target.id).setAttribute("size", "3");
            }
        }
    },
    
    dependentActivate : function(component,event,helper){
        var selectProgramDomId = event.target.id;
        var i;
        var activityArray=[];
        if(selectProgramDomId === 'program_1'){
            component.set("v.activitiesFlag",true);
        }else{
            component.set("v.activitiesFlag",false);
        }
        var selectProgram = document.getElementById(event.target.id).value;
        if(selectProgram !== 'SelectProgram'){
            if(component.get("v.programIdActivityMap")[selectProgram] !== 'undefined'){
                if(component.get("v.activityType") != '' && component.get("v.activityType") != 'null'){
                    for(i=0;i<(component.get("v.programIdActivityMap")[selectProgram]).length;i++){
                        if(component.get("v.programIdActivityMap")[selectProgram][i].Activity_Type__c === component.get("v.activityType")){
                            activityArray.push(component.get("v.programIdActivityMap")[selectProgram][i])
                        }
                    }
                    component.set("v.programDependentActivities",activityArray);
                    
                }else {
                    component.set("v.programDependentActivities",component.get("v.programIdActivityMap")[selectProgram]);
                }
            }
            if(event.target.id != ''){
                document.getElementById('programActivites_'+selectProgramDomId.substring(selectProgramDomId.indexOf('_')+1,selectProgramDomId.length)).removeAttribute("disabled");
            }
        }
    },
    
    nonProgramdependentActivate : function(component,event,helper){
        var selectProgramDomId = event.target.id;
        var i;
        var activityArray=[];
        if(selectProgramDomId === 'nonprogram_1'){
            component.set("v.activitiesFlag",true);
        }else{
            component.set("v.activitiesFlag",false);
        }
        var selectProgram = document.getElementById(event.target.id).value;
        if(selectProgram !== 'SelectProgram'){
            if(component.get("v.programIdActivityMap")[selectProgram] !== 'undefined'){
                if(component.get("v.activityType") != '' && component.get("v.activityType") != 'null'){
                    for(i=0;i<(component.get("v.programIdActivityMap")[selectProgram]).length;i++){
                        if(component.get("v.programIdActivityMap")[selectProgram][i].Activity_Type__c === component.get("v.activityType")){
                            activityArray.push(component.get("v.programIdActivityMap")[selectProgram][i])
                        }
                    }
                    component.set("v.nonProgramDependentActivities",activityArray);
                    
                }else {
                    component.set("v.nonProgramDependentActivities",component.get("v.programIdActivityMap")[selectProgram]);
                }
            }
            if(event.target.id != ''){
                document.getElementById('nonprogramActivites_'+selectProgramDomId.substring(selectProgramDomId.indexOf('_')+1,selectProgramDomId.length)).removeAttribute("disabled");
            }
        }
    },
    
    addProgramActivities : function(component,event,helper){
        var programDependentsActivities = 'programDependentsActivities';
        var programActivityLastId = document.getElementsByClassName('programActivityGrid')[document.getElementsByClassName('programActivityGrid').length-1].id;
        var totalprogramActivityGrid = parseInt(programActivityLastId.substring(programActivityLastId.length-1,programActivityLastId.length));
        //var totalprogramActivityGrid = (document.getElementsByClassName('programActivityGrid')).length;
        var existingProgramIdsArray = [];
        var refNode = document.getElementsByClassName('programActivityGrid')[document.getElementsByClassName('programActivityGrid').length-1];
        //var refNode = document.getElementsByClassName('programActivityGrid')[0
        //var refProgramActivitesTextNode = document.getElementsByClassName("programActivitySelectGrid")[document.getElementsByClassName('programActivityGrid').length-1];
        var refProgramActivitesTextNode = document.getElementById('programActivity'+totalprogramActivityGrid)
        var attr ='programActivity'+(totalprogramActivityGrid+1);
        var textAttr = 'programAndActivities'+(totalprogramActivityGrid);
        var i,j;
        var options='';
        var programNotSelected = false;
        
        //Checking whether Program selected for before activity
        //alert(document.getElementById('program_'+(totalprogramActivityGrid-1)));
        if(document.getElementById('program_'+(totalprogramActivityGrid-1))){
            for(i=0;i<document.getElementById('program_'+(totalprogramActivityGrid-1)).options.length;i++){
                if(document.getElementById('program_'+(totalprogramActivityGrid-1)).options[i].selected &&
                   document.getElementById('program_'+(totalprogramActivityGrid-1)).options[i].value === 'SelectProgram'){
                    
                    programNotSelected = true;
                }
                
            }
        }
        if(programNotSelected){
            alert('Please Select a Program before adding a new Program Activities')
        }else{
            //Eliminating already selected Programs in select option for new program activity
            
            for(j=1;j<totalprogramActivityGrid;j++){
                if(document.getElementById('program_'+j)){
                    for(i=0;i<document.getElementById('program_'+j).options.length;i++){
                        if(document.getElementById('program_'+j).options[i].value !== 'SelectProgram'){
                            if(document.getElementById('program_'+j).options[i].selected && !existingProgramIdsArray.includes(document.getElementById('program_'+j).options[i].value)){
                                existingProgramIdsArray.push(document.getElementById('program_'+j).options[i].value);
                            }
                        }
                    }
                }
            }
            
            var activitySelect = document.createElement('select');
            var activitySelectOption = document.createElement('option');
            var programActivity = document.createElement('div');
            programActivity.setAttribute("class","slds-grid programActivitySelectGrid");
            var ProgramDiv = document.createElement('div');
            ProgramDiv.setAttribute("class","slds-p-horizontal--small slds-size--6-of-12  slds-small-size--6-of-12 slds-medium-size--6-of-12 slds-large-size--6-of-12");
            programActivity.appendChild(ProgramDiv); 
            var ProgramDivPar = document.createElement('p');
            ProgramDivPar.setAttribute("class","vAlign");
            ProgramDiv.appendChild(ProgramDivPar);
            var programSelect = document.createElement('select');
            programSelect.setAttribute("id","program_"+totalprogramActivityGrid);
            // programSelect.setAttribute("onchange","dependentActivate");
            
            programSelect.onchange = function(events) { 
                console.log(events.target.id);
                var currentSelectedProgramId = events.target.id
                
                helper.dependentActivities(component,events);
                //clearing the Current Select Option Before loading dependent activity option
                document.getElementById('programActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).innerHTML = '';
                
                // enabling the picklist
                document.getElementById('programActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).removeAttribute("disabled");
                
                //Adding Program Dependent Activities
                var activitySelectedsOption = document.createElement('option');
                activitySelectedsOption.value =  'SelectActivity';
                activitySelectedsOption.text = 'Select Activity';
                //programSelect.add(programSelectOption);
                document.getElementById('programActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).add(activitySelectedsOption);
                //alert(component.get("v.programDependentsActivities"));
                if(typeof component.get("v."+programDependentsActivities) !== 'undefined'){
                    for(i=0;i<component.get("v."+programDependentsActivities).length;i++){
                        if(component.get("v.activityType") === component.get("v."+programDependentsActivities)[i].Activity_Type__c ){
                            var activitySelectedOption = document.createElement('option');
                            activitySelectedOption.value =  component.get('v.programDependentsActivities')[i].Id;
                            activitySelectedOption.text = component.get('v.programDependentsActivities')[i].Name;
                            activitySelectedOption.className = 'option';
                            //programSelect.add(programSelectOption);
                            document.getElementById('programActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).add(activitySelectedOption);
                        }
                    }
                }
            }
            var programSelectOption = document.createElement('option');
            programSelectOption.value =  'SelectProgram';
            programSelectOption.text = 'Select Program';
            //programSelectOption.selected = 'true';
            programSelect.add(programSelectOption);
            
            //Adding Program Picklist values
            for(i=0;i<component.get('v.programList').length;i++){
                var programSelectOption = document.createElement('option');
                programSelectOption.value =  component.get('v.programList')[i].Program_SFID__c;
                programSelectOption.text = component.get('v.programList')[i].Program_SFID__r.Name;
                
                if(existingProgramIdsArray.includes(component.get('v.programList')[i].Program_SFID__c)){
                    programSelectOption.disabled = true;
                }
                
                for(j=0;j<component.get('v.deletedProgramList').length;j++){
                    if(component.get('v.deletedProgramList')[j] === component.get('v.programList')[i].Program_SFID__c){
                        programSelectOption.disabled = false;
                    }
                }
                
                
                //programSelectOption.disabled = existingProgramIdsArray.includes(component.get('v.programList')[i].Program_SFID__c) ? True : False ;
                programSelect.add(programSelectOption);
            }
            ProgramDivPar.appendChild(programSelect);
            
            var ActivityDiv = document.createElement('div');
            ActivityDiv.setAttribute("class","slds-p-horizontal--small slds-size--6-of-12  slds-small-size--6-of-12 slds-medium-size--6-of-12 slds-large-size--6-of-12");
            programActivity.appendChild(ActivityDiv); 
            var ActivityDivPar = document.createElement('p');
            ActivityDivPar.setAttribute("class","vAlign");
            ActivityDiv.appendChild(ActivityDivPar);
            
            activitySelect.setAttribute("id","programActivites_"+totalprogramActivityGrid);
            // programSelect.setAttribute("onchange","dependentActivate");
            
            activitySelect.onclick = function(eventss) {
                console.log('event');
                helper.setMultipleAttributeToSelectdynamically(component,eventss);
                
            }
            activitySelectOption.value =  'SelectActivity';
            activitySelectOption.text = 'Select Activity';
            activitySelect.add(activitySelectOption);
            activitySelect.setAttribute("disabled","true");
            ActivityDivPar.appendChild(activitySelect);
            //refNode.parentNode.insertBefore(programActivity,refNode.nextSibling);
            //document.getElementById('programAndActivities'+totalprogramActivityGrid).innerHTML = '';
            document.getElementById('programActivity'+totalprogramActivityGrid).appendChild(programActivity)
            var el = document.createElement("div")
            el.setAttribute("id",attr);
            el.setAttribute("class","programActivityGrid");
            refNode.parentNode.insertBefore(el,refNode.nextSibling);
            var e2 = document.createElement("div")
            e2.setAttribute("id",textAttr);
            refProgramActivitesTextNode.appendChild(e2);
        }
        
    },
    
    addNonProgramActivities : function(component,event,helper){
        var programDependentsActivities = 'programDependentsActivities';
        var programActivityLastId = document.getElementsByClassName('nonprogramActivityGrid')[document.getElementsByClassName('nonprogramActivityGrid').length-1].id;
        var totalprogramActivityGrid = parseInt(programActivityLastId.substring(programActivityLastId.length-1,programActivityLastId.length));
        //var totalprogramActivityGrid = (document.getElementsByClassName('nonprogramActivityGrid')).length;
        var existingProgramIdsArray = [];
        var refNode = document.getElementsByClassName('nonprogramActivityGrid')[document.getElementsByClassName('nonprogramActivityGrid').length-1];
        //var refNode = document.getElementsByClassName('nonprogramActivityGrid')[0
        //var refProgramActivitesTextNode = document.getElementsByClassName("programActivitySelectGrid")[document.getElementsByClassName('nonprogramActivityGrid').length-1];
        var refProgramActivitesTextNode = document.getElementById('nonprogramActivity'+totalprogramActivityGrid)
        var attr ='nonprogramActivity'+(totalprogramActivityGrid+1);
        var textAttr = 'nonprogramAndActivities'+(totalprogramActivityGrid);
        var i,j;
        var options='';
        var programNotSelected = false;
        
        //Checking whether Program selected for before activity
        if(document.getElementById('nonprogram_'+(totalprogramActivityGrid-1))){
            for(i=0;i<document.getElementById('nonprogram_'+(totalprogramActivityGrid-1)).options.length;i++){
                if(document.getElementById('nonprogram_'+(totalprogramActivityGrid-1)).options[i].selected &&
                   document.getElementById('nonprogram_'+(totalprogramActivityGrid-1)).options[i].value === 'SelectProgram'){
                    programNotSelected = true;
                }
            }
        }
        
        if(programNotSelected){
            alert('Please Select a Non-Program before adding a new Non-Program Activities')
        }else{
            
            //Eliminating already selected Programs in select option for new program activity
            for(j=1;j<totalprogramActivityGrid;j++){
                if(document.getElementById('nonprogram_'+j)){
                    for(i=0;i<document.getElementById('nonprogram_'+j).options.length;i++){
                        if(document.getElementById('nonprogram_'+j).options[i].value !== 'SelectProgram'){
                            if(document.getElementById('nonprogram_'+j).options[i].selected && !existingProgramIdsArray.includes(document.getElementById('nonprogram_'+j).options[i].value)){
                                existingProgramIdsArray.push(document.getElementById('nonprogram_'+j).options[i].value);
                            }
                        }
                    }
                }
            }
            
            var activitySelect = document.createElement('select');
            var activitySelectOption = document.createElement('option');
            var programActivity = document.createElement('div');
            programActivity.setAttribute("class","slds-grid nonprogramActivitySelectGrid");
            var ProgramDiv = document.createElement('div');
            ProgramDiv.setAttribute("class","slds-p-horizontal--small slds-size--6-of-12  slds-small-size--6-of-12 slds-medium-size--6-of-12 slds-large-size--6-of-12");
            programActivity.appendChild(ProgramDiv); 
            var ProgramDivPar = document.createElement('p');
            ProgramDivPar.setAttribute("class","vAlign");
            ProgramDiv.appendChild(ProgramDivPar);
            var programSelect = document.createElement('select');
            programSelect.setAttribute("id","nonprogram_"+totalprogramActivityGrid);
            // programSelect.setAttribute("onchange","dependentActivate");
            
            programSelect.onchange = function(events) { 
                console.log(events.target.id);
                var currentSelectedProgramId = events.target.id
                
                helper.dependentActivities(component,events);
                //clearing the Current Select Option Before loading dependent activity option
                document.getElementById('nonprogramActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).innerHTML = '';
                
                // enabling the picklist
                document.getElementById('nonprogramActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).removeAttribute("disabled");
                
                //Adding Program Dependent Activities
                var activitySelectedsOption = document.createElement('option');
                activitySelectedsOption.value =  'SelectActivity';
                activitySelectedsOption.text = 'Select Activity';
                //programSelect.add(programSelectOption);
                document.getElementById('nonprogramActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).add(activitySelectedsOption);
                //alert(component.get("v.programDependentsActivities"));
                if(typeof component.get("v."+programDependentsActivities) !== 'undefined'){
                    for(i=0;i<component.get("v."+programDependentsActivities).length;i++){
                        var activitySelectedOption = document.createElement('option');
                        activitySelectedOption.value =  component.get('v.programDependentsActivities')[i].Id;
                        activitySelectedOption.text = component.get('v.programDependentsActivities')[i].Name;
                        activitySelectedOption.className = 'option';
                        //programSelect.add(programSelectOption);
                        document.getElementById('nonprogramActivites_'+currentSelectedProgramId.substring(currentSelectedProgramId.indexOf('_')+1,currentSelectedProgramId.length)).add(activitySelectedOption);
                    }
                }
            }
            var programSelectOption = document.createElement('option');
            programSelectOption.value =  'SelectProgram';
            programSelectOption.text = 'Select Program';
            programSelectOption.selected = 'true';
            programSelect.add(programSelectOption);
            
            //Adding Non-Program Picklist values
            for(i=0;i<component.get('v.nonProgramList').length;i++){
                var programSelectOption = document.createElement('option');
                programSelectOption.value =  component.get('v.nonProgramList')[i].Id;
                programSelectOption.text = component.get('v.nonProgramList')[i].Name;
                if(existingProgramIdsArray.includes(component.get('v.nonProgramList')[i].Id)){
                    programSelectOption.disabled = true;
                }
                
                for(j=0;j<component.get('v.deletedNonProgramList').length;j++){
                    if(component.get('v.deletedNonProgramList')[j] === component.get('v.nonProgramList')[i].Id){
                        programSelectOption.disabled = false;
                    }
                }
                //programSelectOption.disabled = existingProgramIdsArray.includes(component.get('v.programList')[i].Program_SFID__c) ? True : False ;
                programSelect.add(programSelectOption);
            }
            ProgramDivPar.appendChild(programSelect);
            
            var ActivityDiv = document.createElement('div');
            ActivityDiv.setAttribute("class","slds-p-horizontal--small slds-size--6-of-12  slds-small-size--6-of-12 slds-medium-size--6-of-12 slds-large-size--6-of-12");
            programActivity.appendChild(ActivityDiv); 
            var ActivityDivPar = document.createElement('p');
            ActivityDivPar.setAttribute("class","vAlign");
            ActivityDiv.appendChild(ActivityDivPar);
            
            activitySelect.setAttribute("id","nonprogramActivites_"+totalprogramActivityGrid);
            // programSelect.setAttribute("onchange","dependentActivate");
            
            activitySelect.onclick = function(eventss) {
                console.log('event');
                helper.setMultipleAttributeToSelectdynamically(component,eventss);
                
            }
            activitySelectOption.value =  'SelectActivity';
            activitySelectOption.text = 'Select Activity';
            activitySelect.add(activitySelectOption);
            activitySelect.setAttribute("disabled","true");
            ActivityDivPar.appendChild(activitySelect);
            //refNode.parentNode.insertBefore(programActivity,refNode.nextSibling);
            //document.getElementById('nonprogramAndActivities1'+totalprogramActivityGrid).innerHTML = '';
            document.getElementById('nonprogramActivity'+totalprogramActivityGrid).appendChild(programActivity)
            var el = document.createElement("div")
            el.setAttribute("id",attr);
            el.setAttribute("class","nonprogramActivityGrid");
            refNode.parentNode.insertBefore(el,refNode.nextSibling);
            var e2 = document.createElement("div")
            e2.setAttribute("id",textAttr);
            refProgramActivitesTextNode.appendChild(e2);
        }
        
    },
    
    toGrowerList : function(component,event){
        if(event.target.id){
            var cmpEvent = component.getEvent("redirectToGrowerList");
            cmpEvent.setParams({
                "accountId" : event.target.id,
            });
            cmpEvent.fire();
        }
        else{
            var growersEvent = component.getEvent("redirectToGrowers");
            growersEvent.setParams({
                "accountId" : event.target.id,
            });
            growersEvent.fire();
        }
    },
    
    toDealerList : function(component,event){
        var dealersEvent = component.getEvent("redirectToDelaerList");
        dealersEvent.setParams({
            "accountId" : event.target.id,
        });
        dealersEvent.fire();
    },
    
    loadCalendar : function(component,event){
        /*var calEvent = $A.get("e.c:Frontier_Touchpoint_Planning_Calendar_Event");
        calEvent.setParams({
            "handlerName" :'calendar'
        });
        calEvent.fire();*/
        
        localStorage.setItem("justOnce", "false");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/one/one.app#/n/Sales_Rep_Touchpoint_Calendar"
        });
        urlEvent.fire();        
    },
    
    saveTouchPoint : function(component,event,helper){
        helper.setProgramAndActivityValues(component,event,'Not Scheduled');
    },
    scheduleTouchPoint : function(component,event,helper){
        
        helper.setProgramAndActivityValues(component,event,'Scheduled');
    },
    cancelTouchpoint : function(component,event,helper){
        //helper.setProgramAndActivityValues(component,event,'Cancelled');
        helper.showModel(component,event,'Cancelled');
    },
    
    completeTouchpoint : function(component,event,helper){
        //helper.setProgramAndActivityValues(component,event,'Completed');
        helper.showModel(component,event,'Completed');

    },
    cancelORCompleteTouchpoint : function(component,event,helper){
        console.log(component.get("v.popUpHeader").split(' ')[0]);
        if(component.get("v.popUpHeader").split(' ')[0] === 'Cancel'){
            helper.setProgramAndActivityValues(component,event,'Cancelled');
        }else if(component.get("v.popUpHeader").split(' ')[0] === 'Complete'){
        	helper.setProgramAndActivityValues(component,event,'Completed');
        }
        helper.closeModel(component);
    },
    closePopUp : function(component,event,helper){
        //console.log(component.get("v.popUpHeader").split(' ')[0]);
        //helper.setProgramAndActivityValues(component,event,)
        helper.closeModel(component);
    },
    selecActivityDelete : function(component,event,helper){
        helper.deleteActivity(component,event);
    },
    selectNonActivityDelete : function(component,event,helper){
        helper.deleteNonProgramActivity(component,event);
    },
    editProgramActivity :function(component,event,helper){
        helper.addActivities(component,event);
    },
    editNonProgramActivity :function(component,event,helper){
        helper.addNonProgActivities(component,event);
    },
    deleteProgram : function(component,event,helper){
        helper.minusProgram(component,event);
    },
    deleteNonProgram : function(component,event,helper){
        helper.minusNonPrograms(component,event);
    },
    deleteNonProgramActivity : function(component,event,helper){
        var targetId = event.target.id;
        document.getElementById('nonActivity'+targetId).remove()
    },
    addNonProgramActivity : function(component,event,helper){
        document.getElementById('nonProgramActivityDiv').classList = 'slds-hide';
        document.getElementById('nonProgramActivitySelect').classList.remove('slds-hide');
        
    },
    cancel : function(component,event,helper){
        
        /*if(component.get("v.growerAcc").split('/').length === 3){
            //touchPointId = component.get("v.growerAcc").split('/')[3];
            var cmpEvent = component.getEvent("redirectToDealerDetail");
            console.log('growId=>'+component.get("v.growerAcc").split('/')[1]);
            cmpEvent.setParams({
                "accIdSapIdAccCommId" : component.get("v.growerAcc").split('/')[1],
                "tabScopeNo" : '3',
                "componentName":"c:Frontier_GrowerAccount_ActivitiesList"
            });
            cmpEvent.fire();
        }else if(component.get("v.growerAcc").split('/').length === 6){
            var cmpEvent = component.getEvent("redirectToDealerDetail");
            console.log('growId=>'+component.get("v.growerAcc").split('/')[1]);
            cmpEvent.setParams({
                "accIdSapIdAccCommId" : component.get("v.growerAcc").split('/')[1]+','+component.get("v.growerAcc").split('/')[0],
                "tabScopeNo" : '3',
                //"componentName":component.get("v.growerAcc").split('/')[5],
                "componentName" : 'c:Frontier_GrowerAccount_Program'
            });
            cmpEvent.fire();
        }else if(component.get("v.growerAcc").split('/').length === 6){
            var cmpEvent = component.getEvent("redirectToDealerDetail");
            console.log('growId=>'+component.get("v.growerAcc").split('/')[1]);
            cmpEvent.setParams({
                "accIdSapIdAccCommId" : component.get("v.growerAcc").split('/')[1]+','+component.get("v.growerAcc").split('/')[0],
                "tabScopeNo" : '3',
                //"componentName":component.get("v.growerAcc").split('/')[5],
                "componentName" : 'c:Frontier_GrowerAccount_Program'
            });
            cmpEvent.fire();
        }*/
        helper.redirectiontoList(component,event);
    },
    selectActivitiesByType : function(component,event,helper){
        
        var selectedActivityId = document.getElementById(event.target.id).value;
        var selectedActivityIndex = (document.getElementById(event.target.id).parentNode.id).substring((document.getElementById(event.target.id).parentNode.id).indexOf('_')+1,(document.getElementById(event.target.id).parentNode.id).length);
        var selectedProgramId ='';
        var i;
        var activityType='';
        
        //Getting Program Id to retrive the related activites from Activity Map
        for(i=0;i<document.getElementById('program_'+selectedActivityIndex).length;i++){
            if(document.getElementById('program_'+selectedActivityIndex).options[i].selected){
                selectedProgramId = document.getElementById('program_'+selectedActivityIndex).options[i].value;
            }
        }
        
        //Getting selected visit Type
        for(i=0;i<component.get("v.programIdActivityMap")[selectedProgramId].length;i++){
            if(component.get("v.programIdActivityMap")[selectedProgramId][i].Id === selectedActivityId){
                activityType = component.get("v.programIdActivityMap")[selectedProgramId][i].Activity_Type__c;
            }
        }
        
        //Adding related Touchpoint Type options to Program related Activities
        document.getElementById('programActivites_'+selectedActivityIndex).innerHTML ='';
        var activitySelectOption = document.createElement('option');
        activitySelectOption.value = 'SelectActivity';
        activitySelectOption.text = 'Select Activity';
        document.getElementById('programActivites_'+selectedActivityIndex).add(activitySelectOption);
        
        for(i=0;i<component.get("v.programIdActivityMap")[selectedProgramId].length;i++){
            if(component.get("v.programIdActivityMap")[selectedProgramId][i].Activity_Type__c === activityType){
                var activitySelectOption = document.createElement('option');
                activitySelectOption.value = component.get("v.programIdActivityMap")[selectedProgramId][i].Id;
                activitySelectOption.text = component.get("v.programIdActivityMap")[selectedProgramId][i].Name;
                activitySelectOption.className = "option";
                if(component.get("v.programIdActivityMap")[selectedProgramId][i].Id === selectedActivityId){
                    activitySelectOption.selected = "true";
                }
                
                document.getElementById('programActivites_'+selectedActivityIndex).add(activitySelectOption);
            }
        }
        component.set('v.activityType',activityType);
        //Setting touchpoint Type picklist  value
        var opts = [
            {label:activityType , value: activityType}
        ];
        component.find('touchPointType').set('v.options',opts);
    },
    selectNonActivitiesByType : function(component,event,helper){
        
        var selectedActivityId = document.getElementById(event.target.id).value;
        var selectedActivityIndex = (document.getElementById(event.target.id).parentNode.id).substring((document.getElementById(event.target.id).parentNode.id).indexOf('_')+1,(document.getElementById(event.target.id).parentNode.id).length);
        var selectedProgramId ='';
        var i;
        var activityType='';
        
        //Getting Program Id to retrive the related activites from Activity Map
        for(i=0;i<document.getElementById('nonprogram_'+selectedActivityIndex).length;i++){
            if(document.getElementById('nonprogram_'+selectedActivityIndex).options[i].selected){
                selectedProgramId = document.getElementById('nonprogram_'+selectedActivityIndex).options[i].value;
            }
        }
        
        //Getting selected visit Type
        for(i=0;i<component.get("v.programIdActivityMap")[selectedProgramId].length;i++){
            if(component.get("v.programIdActivityMap")[selectedProgramId][i].Id === selectedActivityId){
                activityType = component.get("v.programIdActivityMap")[selectedProgramId][i].Activity_Type__c;
            }
        }
        
        //Adding related Touchpoint Type options to Program related Activities
        document.getElementById('nonprogramActivites_'+selectedActivityIndex).innerHTML ='';
        var activitySelectOption = document.createElement('option');
        activitySelectOption.value = 'SelectActivity';
        activitySelectOption.text = 'Select Activity';
        document.getElementById('nonprogramActivites_'+selectedActivityIndex).add(activitySelectOption);
        
        for(i=0;i<component.get("v.programIdActivityMap")[selectedProgramId].length;i++){
            if(component.get("v.programIdActivityMap")[selectedProgramId][i].Activity_Type__c === activityType){
                var activitySelectOption = document.createElement('option');
                activitySelectOption.value = component.get("v.programIdActivityMap")[selectedProgramId][i].Id;
                activitySelectOption.text = component.get("v.programIdActivityMap")[selectedProgramId][i].Name;
                activitySelectOption.className = "option";
                if(component.get("v.programIdActivityMap")[selectedProgramId][i].Id === selectedActivityId){
                    activitySelectOption.selected = "true";
                }
                
                document.getElementById('nonprogramActivites_'+selectedActivityIndex).add(activitySelectOption);
            }
        }
        component.set('v.activityType',activityType);
        //Setting touchpoint Type picklist  value
        var opts = [
            {label:activityType , value: activityType}
        ];
        component.find('touchPointType').set('v.options',opts);
    }
    
})