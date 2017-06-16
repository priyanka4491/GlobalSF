({
    helperUpdateTouchPoint : function(component) {
        
        var uniqueId=component.get("v.currentDateId");
        var touchPointId = 'null';
        var accId,i,j,k;
        var accountId=component.get("v.growerAcc");
        var selectedProgramIds =component.get("v.growerAcc").split('/')[0];
        var selectedActivitiesIds = component.get("v.growerAcc").split('/')[2];
        var selectedActivitiesIdsArray = [];
        var selectedProgramIdsArray = [];
        var currentDate = new Date();
        console.log('accountId=>'+accountId);
        
        
        if(!component.get("v.isDealerList") && !component.get("v.isFromCalendar") && !component.get("v.isGrowerList")){
            component.set("v.isSchedule",'true');
        }
        if(component.get("v.growerAcc").split('/').length === 6){
            touchPointId = component.get("v.growerAcc").split('/')[3];
            if(component.get("v.growerAcc").split('/')[4] != ''){
                component.find('touchpointDate').set('v.value',component.get("v.growerAcc").split('/')[4]);
            }else {
                //component.find('touchpointDate').set('v.value',currentDate.getFullYear()+'-'+(parseInt(currentDate.getMonth())+parseInt(1))+'-'+currentDate.getDate());
            	component.find('touchpointDate').set('v.value',currentDate.toISOString());
            }
        }else{
                //component.find('touchpointDate').set('v.value',currentDate.getFullYear()+'-'+(parseInt(currentDate.getMonth())+parseInt(1))+'-'+currentDate.getDate());
        		component.find('touchpointDate').set('v.value',currentDate.toISOString());

        }
        console.log('currentDate=>'+currentDate.toISOString());
        if(selectedActivitiesIds.includes(',')){
            for(i=0;i<selectedActivitiesIds.split(',').length;i++){
                selectedActivitiesIdsArray.push(selectedActivitiesIds.split(',')[i]);
            }
        }else {
            selectedActivitiesIdsArray.push(selectedActivitiesIds);
        }
        if(selectedProgramIds.includes(',')){
            for(i=0;i<selectedProgramIds.split(',').length;i++){
                selectedProgramIdsArray.push(selectedActivitiesIds.split(',')[i]);
            }
        }else {
            selectedProgramIdsArray.push(selectedProgramIds);
        }
        if(component.get('v.isFromCalendar') && component.get('v.newUpdateStatus') === 'New'){
            accId = component.get('v.accountsId');
        }else {
            accId=accountId.split('/')[1].split(',')[0];
        }
        component.set("v.accountId",accId);
        
        var recnumber= (uniqueId.split('/')[1]);
        component.set("v.RecordNumber",recnumber);
        var eventId =(uniqueId.split('/')[2]);
        //component.set("v.EventId",eventId);
        //
        debugger;

        var date =  component.get("v.clickdate");
        if(date){
           var presentDate = new Date()
           console.log('presentDate=>'+(presentDate.toISOString()).split('T')[1]);
           var parsedDate = new Date(date+'T'+(presentDate.toISOString()).split('T')[1]);
            
            var touchDate = component.find("touchpointDate");
            console.log('parsedDate.toISOString()=>'+parsedDate.toISOString());
            touchDate.set('v.value',date+'T'+(presentDate.toISOString()).split('T')[1]);   
        }
        
        if(component.get("v.growerAcc").split('/').length === 6){
            if(component.get("v.growerAcc").split('/')[3] != ''){
                touchPointId = component.get("v.growerAcc").split('/')[3];
                
            }
            
            var date1 =uniqueId.split('/')[4];
            if(!date1){
                if(component.get("v.growerAcc").split('/')[4]){
                    date1 = component.get("v.growerAcc").split('/')[4]; 
                }
            }
            console.log('Date1' + date1);
            
            var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
            var days =["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
            var d1=new Date(date1);
            d1.toString('dddd, MMMM ,yyyy'); 
            console.log('D1'+monthNames[d1.getMonth()] + '---'+ days[d1.getDay()]);
            var touchPointDate = days[d1.getDay()] + ', ' + monthNames[d1.getMonth()] + ', ' + d1.getDate() + ', ' + d1.getFullYear();
            
            console.log('touchPointDate' + touchPointDate);
            component.set("v.currentDate",touchPointDate);
        }
        console.log('AccountId' +accId);
        console.log('eventId' +eventId);
        if(touchPointId === ''){
            touchPointId = 'null';
        }
        
        if(accId !== 'null'){
            var action = component.get("c.getNewAndUpdateTouchPointDetails");
            action.setParams({
                seletedProgActivityId : selectedActivitiesIds ,
                accId : accId,
                selectedProgramIds : selectedProgramIds,
                touchPointId : touchPointId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                   
                   
                    var retResponse = JSON.parse(response.getReturnValue());
                    if(selectedActivitiesIds != ''){
                        component.set('v.activityType',retResponse.activityType);
                        var opts = [
                            {label: retResponse.activityType , value: retResponse.activityType}
                        ];
                        component.find('touchPointType').set('v.options',opts);
                    }
                   
                    //alert(retResponse.touchPointStatus);
                    if(retResponse.touchPointStatus === 'Cancelled' || retResponse.touchPointStatus === 'Completed'){
                        component.set("v.isReadOnly","true");
                    }
                    if(retResponse.touchPointStatus != 'null'){
                        component.set("v.touchPointStatus",retResponse.touchPointStatus);
                    }
                    component.set("v.selectedActivitiesFromActivityListArray",selectedActivitiesIdsArray);
                    console.log("Response"+ JSON.stringify(retResponse));
                    component.set("v.touchPointList", retResponse);
                    component.set("v.contactList", retResponse.contactList);
                    component.set("v.programList",retResponse.accountProgramList);
                    component.set("v.programIdActivityMap",retResponse.activityMap);
                    console.log("Response====>"+ retResponse.selectedProgramsList);
                    component.set('v.selectedProgramsList',retResponse.selectedProgramsList);
                    component.set("v.selectedActivitiesList",retResponse.selectedActivityList);
                    component.set("v.programDependentActivities",retResponse.selectedActivityList);
                    component.set("v.nonProgramActivitiesList",retResponse.nonProgramActivitiyList);
                    component.set("v.nonProgramList",retResponse.nonProgramsList);
                    component.set("v.selectedNonProgramList",retResponse.selectedNonProgramList);
                    component.set("v.selectedNonProgramActivitiesList",retResponse.selectedNonProgramActivityList);
                    
                    //alert(JSON.stringify( component.get("v.selectedActivitiesFromActivityListArray")));
                    //alert(JSON.stringify( component.get("v.selectedNonProgramActivitiesList")));
                    //
                    
                    console.log(component.get("v.selectedActivitiesFromActivityListArray"));
                    console.log(JSON.stringify(component.get("v.selectedNonProgramActivitiesList")));
                    console.log('programIdActivityMap=>'+JSON.stringify(component.get("v.programIdActivityMap")));
                    
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    dependentActivities : function(component,event){
        var selectProgramDomId = event.target.id;
        if(selectProgramDomId === 'program_1'){
            //component.set("v.activitiesFlag",true);
        }else{
            //component.set("v.activitiesFlag",false);
        }
        console.log(document.getElementById(event.target.id).value);
        var selectProgram = document.getElementById(event.target.id).value;
        if(component.get("v.programIdActivityMap")[selectProgram] !== 'undefined'){
            component.set("v.programDependentsActivities",component.get("v.programIdActivityMap")[selectProgram]);
        }
        console.log(JSON.stringify(component.get("v.programDependentActivities")));
        if(event.target.id != ''){
            // if(!document.getElementById('programActivity_'+selectProgramDomId.substring(selectProgramDomId.indexOf('_')+1,selectProgramDomId.length).classList.contains('')){
            document.getElementById('programActivites_'+selectProgramDomId.substring(selectProgramDomId.indexOf('_')+1,selectProgramDomId.length)).removeAttribute("disabled");
            //document.getElementById(selectProgramDomId.substring(selectProgramDomId.indexOf('_')+1,selectProgramDomId.length)).setAttribute("size", "3");
            // }
        }
        
    },
    setMultipleAttributeToSelectdynamically : function(component,event){
        console.log(event.target.id);
        if(event.target.id != ''){
            if(!document.getElementById(event.target.id).classList.contains('multiple')){
                document.getElementById(event.target.id).setAttribute("multiple", "true");
                document.getElementById(event.target.id).setAttribute("size", "3");
            }
        }
    },
    
    nonProgramdependentActivate : function(component,event){
        var selectProgramDomId = 'nonprogram_1';
        var i;
        var activityArray=[];
        if(selectProgramDomId === 'nonprogram_1'){
            component.set("v.activitiesFlag",true);
        }else{
            component.set("v.activitiesFlag",false);
        }
        var selectProgram = document.getElementById(selectProgramDomId).value;
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
    
    setProgramAndActivityValues : function(component,event,status){
        this.nonProgramAndProgramSave(component,event);
        var i,j,k,l;
        var programActivityMap = {};
        var programDomIdAndProgramIdMap = {};
        var programDomIdAndProgramNameMap = {};
        var programActivityAfterAddorRemoveMap = {};
        var programActivityLastId = document.getElementsByClassName('programActivityGrid')[document.getElementsByClassName('programActivityGrid').length-1].id;
        var programActivityLastIdIndex = programActivityLastId.substring(programActivityLastId.length-1,programActivityLastId.length);
        var touchPointId='null';
        var selectedProgram ='';
        if(component.get("v.growerAcc").split('/').length === 6){
            touchPointId = component.get("v.growerAcc").split('/')[3];
        }
        for(i=1;i<programActivityLastIdIndex;i++){
            
            //alert(document.getElementById('program_'+i));
            if(document.getElementById('program_'+i)){
                 for(k=0;k<document.getElementById('program_'+i).length;k++){
                 	if(document.getElementById('program_'+i).options[k].selected){
                        selectedProgram = document.getElementById('program_'+i).options[k].value;
                 	}
                 }
                debugger;
                if(selectedProgram !== 'SelectProgram'){
                    console.log('program=>'+document.getElementById('program_'+i).value);
                    
                    var activityArray=[];
                    for (j = 1; j < document.getElementById('programActivites_'+i).length; j++) {
                        if(document.getElementById('programActivites_'+i).options[j].selected !== 'undefined'){
                            if (!document.getElementById('programActivites_'+i).disabled) {
                                //alert('1');
                                console.log(document.getElementById('programActivites_'+i).options[j].value);
                                if(document.getElementById('programActivites_'+i).options[j].value !== 'SelectActivity' &&
                                   (document.getElementById('programActivites_'+i).options[j].selected || document.getElementById('programActivites_'+i).options[j].disabled)) {
                                    //alert('2');
                                    var activityOption = {};
                                    activityOption.id = document.getElementById('programActivites_'+i).options[j].value;
                                    activityOption.value = document.getElementById('programActivites_'+i).options[j].text;
                                    activityArray.push(activityOption);
                                }
                            }
                        }
                    }
                    if (activityArray.length !== 0) {
                        for(k=0;k<document.getElementById('program_'+i).length;k++){
                            if(document.getElementById('program_'+i).options[k].selected){
                                /*for(j=0;j<component.get("v.selectedActivitiesList").length;j++){
                                    var activityOption = {};
                                    //alert(component.get("v.selectedActivitiesList")[j].Id);
                                    activityOption.id = component.get("v.selectedActivitiesList")[j].Id ;
                                    activityOption.value = component.get("v.selectedActivitiesList")[j].Name;
                                    if(!activityArray.includes(activityOption)) {   
                                        activityArray.push(activityOption);
                                    }
                                }*/
                            }
                            programDomIdAndProgramNameMap['program_'+i]=document.getElementById('program_'+i).options[k].text;
                            programDomIdAndProgramIdMap['program_'+i]=document.getElementById('program_'+i).options[k].value;                        }
                    }
                    programActivityMap[document.getElementById('program_'+i).value] = activityArray;
                }
            }
        }
        console.log('programActivityMap=>'+JSON.stringify(programActivityMap));
        console.log('programDomIdAndProgramIdMap=>'+JSON.stringify(programDomIdAndProgramIdMap));
        console.log('programDomIdAndProgramNameMap=>'+JSON.stringify(programDomIdAndProgramNameMap));
        component.set('v.savedProgramDivNameAndProgramIdMap',programDomIdAndProgramIdMap);
        component.set('v.savedProgramDivNameAndProgramNameMap',programDomIdAndProgramNameMap);
        component.set('v.savedProgramActivityMap',programActivityMap)
        console.log('savedProgramActivityMap=>'+JSON.stringify(component.get("v.savedProgramActivityMap")));
        
        console.log('savedProgramActivityMap=>'+JSON.stringify(component.get("v.savedProgramActivityMap")));
        console.log('savedNonProgramActivityMap=>'+JSON.stringify(component.get("v.savedNonProgramActivityMap")));
        console.log('deletedActivityList=>'+JSON.stringify(component.get("v.deletedActivityList"))); 
        console.log('deletedNonProgramList=>'+JSON.stringify(component.get("v.deletedNonProgramList"))); 
        console.log('deletedProgramList=>'+JSON.stringify(component.get("v.deletedProgramList"))); 
        console.log('deletedNonActivityList=>'+JSON.stringify(component.get("v.deletedNonActivityList")));
        var programFlag = false;
        var programActivityflag = true;
        var nonprogramFlag = false;
        var nonprogramActivityflag = true;
        //Hiding all the picklistList Values
        for(var key in component.get("v.savedProgramActivityMap")){
                programFlag = true;
        }
        for(var key in component.get("v.savedProgramActivityMap")){
            if(component.get("v.savedProgramActivityMap")[key].length === 0){
                programActivityflag = false;
            }
        }
        for(var key in component.get("v.savedNonProgramActivityMap")){
                nonprogramFlag = true;
        }
        for(var key in component.get("v.savedNonProgramActivityMap")){
            if(component.get("v.savedNonProgramActivityMap")[key].length === 0){
                nonprogramActivityflag = false;
            }
        }
        //alert(programFlag);
        //alert(programActivityflag);
        if( (programFlag && programActivityflag) || (nonprogramFlag && nonprogramActivityflag) ){
            var action = component.get("c.saveTouchPointDetails");
            action.setParams({
                accId : component.get("v.accountId"),
                deletedProgramIds : JSON.stringify(component.get("v.deletedProgramList")),
                deletedActivityIds : JSON.stringify(component.get("v.deletedActivityList")),
                programIdAndActivityIds : JSON.stringify(component.get("v.savedProgramActivityMap")),
                deletedNonProgramIds : JSON.stringify(component.get("v.deletedNonProgramList")),
                deletedNonActivityIds : JSON.stringify(component.get("v.deletedNonActivityList")),
                savedNonProgramActivityMapIds : JSON.stringify(component.get("v.savedNonProgramActivityMap")),
                touchPointId : touchPointId,
                //touchPointId : 'a0l2C000000GNJkQAO',
                touchPointDates : component.find('touchpointDate').get('v.value'),
                touchPointType : component.find('touchPointType').get('v.value') ,
                status : status
                
            });
            //alert(component.get("v.isDealerList"));
            action.setCallback(this,function(response){
                //alert(response.getState());
                if(response.getState() === 'SUCCESS') {
                    this.redirectiontoList(component,event);
                }
            });
            $A.enqueueAction(action); 
        } else{
            alert('Please Select the Program And Activities before saving Touchpoint');
        }
        
    },
    
    deleteActivity :function(component,event){
        //('test');
        var selectedActivityToDelete = event.target.id;
        var activityIndex = selectedActivityToDelete.substring(selectedActivityToDelete.indexOf('_')+1,selectedActivityToDelete.lastIndexOf('_'));
        var activityId = selectedActivityToDelete.substring(selectedActivityToDelete.lastIndexOf('_')+1,selectedActivityToDelete.length);
        if(document.getElementById('activity_'+activityId).parentNode.childNodes.length === 2){
            document.getElementById('activity_'+activityId).parentNode.childNodes[1].classList.remove('parentPlusSingn');
            document.getElementById('activity_'+activityId).parentNode.childNodes[1].style.margin='11px 0px 0px 0px';
        }
        document.getElementById('activity_'+activityId).remove();
        
        var t,i;
        var activitesAfterDeletion=[];
        var activityOptionObject={};
        
        if(component.get("v.deletedActivityList") == 'null'){
            var deletearray = [];
            deletearray.push(activityId);
            component.set("v.deletedActivityList",deletearray);
        }else{
            var deletedArray = []
            for(i=0;i<component.get("v.deletedActivityList").length;i++){
                deletedArray.push(component.get("v.deletedActivityList")[i]);
            }
            deletedArray.push(activityId);
            component.set("v.deletedActivityList",deletedArray);
        }
       
    },
    deleteNonProgramActivity :function(component,event){
        var selectedActivityToDelete = event.target.id;
        var activityIndex = selectedActivityToDelete.substring(selectedActivityToDelete.indexOf('_')+1,selectedActivityToDelete.lastIndexOf('_'));
        var activityId = selectedActivityToDelete.substring(selectedActivityToDelete.lastIndexOf('_')+1,selectedActivityToDelete.length);
        var t,i;
        var activitesAfterDeletion=[];
        var activityOptionObject={};
        
        if(document.getElementById('nonactivity_'+activityId).parentNode.childNodes.length === 2){
            document.getElementById('nonactivity_'+activityId).parentNode.childNodes[1].classList.remove('parentPlusSingn');
            document.getElementById('nonactivity_'+activityId).parentNode.childNodes[1].style.margin='11px 0px 0px 0px';
        }
        document.getElementById('nonactivity_'+activityId).remove();

        if(component.get("v.deletedNonActivityList") == 'null'){
            var deletearray = [];
            deletearray.push(activityId);
            component.set("v.deletedNonActivityList",deletearray);
        }else{
            var deletedArray = []
            for(i=0;i<component.get("v.deletedNonActivityList").length;i++){
                deletedArray.push(component.get("v.deletedNonActivityList")[i]);
            }
            deletedArray.push(activityId);
            component.set("v.deletedNonActivityList",deletedArray);
        }
    },    
 
    addActivities : function(component,event){
        var i,j,k;
        var targetId = event.target.id;
        var activityIndex = targetId.substring(targetId.indexOf('_')+1,targetId.length);
        var activityArray=[];
        document.getElementById('programActivity'+activityIndex).childNodes[0].classList.remove('slds-hide');
        document.getElementById('program_'+activityIndex).classList='slds-hide';
        document.getElementById('programAndActivities'+activityIndex).childNodes[0].childNodes[1].classList.add('slds-hide');
        document.getElementById('programAndActivities'+activityIndex).childNodes[0].childNodes[0].style.margin="-49px 0px 0px 0px";
        document.getElementById('programActivites_'+activityIndex).innerHTML='';
        var activitySelectOption1 = document.createElement('option');
        activitySelectOption1.value =  'SelectActivity';
        activitySelectOption1.text = 'Select Activity';
        document.getElementById('programActivites_'+activityIndex).add(activitySelectOption1);
        //for(i=0;i<component.get("v.programIdActivityMap")[].length;i++){
        for(k=0;k<document.getElementById('program_'+activityIndex).length;k++){
            if(document.getElementById('program_'+activityIndex).options[k].selected){ 
                //alert(document.getElementById('program_'+activityIndex).options[k].value);
                if(typeof component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value] !== 'undefined'){

                for(i=0;i<component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value].length;i++){
                    //alert(component.get('v.activityType') +',' +component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value][i].Touchpoint_Type__c);
                    if(component.get('v.activityType') === component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value][i].Activity_Type__c){
                        var activitySelectOption = document.createElement('option');
                        activitySelectOption.value = component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value][i].Id;
                        activitySelectOption.text = component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value][i].Name;
                        activitySelectOption.className = "option";
                        for(j=0;j<component.get("v.selectedActivitiesList").length;j++){
                            if(component.get("v.selectedActivitiesList")[j].Id === component.get("v.programIdActivityMap")[document.getElementById('program_'+activityIndex).options[k].value][i].Id){
                                activitySelectOption.selected = "true"
                                //activitySelectOption.disabled = "true"
                            }
                        }
                        //document.getElementById('nonprogramActivites_'+activityIndex).setAttribute("multiple", "true");
                        //document.getElementById('nonprogramActivites_'+activityIndex).setAttribute("size", "3");
                        document.getElementById('programActivites_'+activityIndex).add(activitySelectOption);
                    }
                }
                    
                }else{//if All Activities get scheduled
					document.getElementById('programActivites_'+activityIndex).setAttribute("multiple", "true");
					document.getElementById('programActivites_'+activityIndex).setAttribute("size", "3");
				}
            }
        }
        if(component.get('v.newUpdateStatus') === 'update'){
            for(j=0;j<component.get("v.selectedActivitiesList").length;j++){
                var activitySelectOption = document.createElement('option');
                activitySelectOption.value = component.get("v.selectedActivitiesList")[j].Id;
                activitySelectOption.text = component.get("v.selectedActivitiesList")[j].Name;
                activitySelectOption.className = "option";
                activitySelectOption.selected = "true";
                document.getElementById('programActivites_'+activityIndex).add(activitySelectOption);
                
            }
        }
        for(j=0;j<component.get("v.selectedActivitiesList").length;j++){
            for(k=0;k<component.get("v.deletedActivityList").length;k++){
                if(component.get("v.selectedActivitiesList")[j].Id === component.get("v.deletedActivityList")[k]){
                    var activitySelectOption = document.createElement('option');
                    activitySelectOption.value = component.get("v.selectedActivitiesList")[j].Id;
                    activitySelectOption.text = component.get("v.selectedActivitiesList")[j].Name;
                    activitySelectOption.className = "option";
                    document.getElementById('programActivites_'+activityIndex).add(activitySelectOption);
                    
                }
            }
        }
    },
    
    addNonProgActivities : function(component,event){
        var i,j,k;
        var targetId = event.target.id;
        var activityIndex = targetId.substring(targetId.indexOf('_')+1,targetId.length);
        //alert('targetId=>'+targetId);
        var activityArray=[];
        document.getElementById('nonprogramActivity'+activityIndex).childNodes[0].classList.remove('slds-hide');
        document.getElementById('nonprogram_'+activityIndex).classList='slds-hide';
        document.getElementById('nonprogramAndActivities'+activityIndex).childNodes[0].childNodes[1].classList.add('slds-hide');
        document.getElementById('nonprogramAndActivities'+activityIndex).childNodes[0].childNodes[0].style.margin="-49px 0px 0px 0px";
        document.getElementById('nonprogramActivites_'+activityIndex).innerHTML='';
        var activitySelectOption1 = document.createElement('option');
        activitySelectOption1.value =  'SelectActivity';
        activitySelectOption1.text = 'Select Activity';
        document.getElementById('nonprogramActivites_'+activityIndex).add(activitySelectOption1);
        //for(i=0;i<component.get("v.selectedNonProgramActivitiesList").length;i++){
        for(k=0;k<document.getElementById('nonprogram_'+activityIndex).length;k++){
            if(document.getElementById('nonprogram_'+activityIndex).options[k].selected ){
                
                //alert(component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value]);
                if(typeof component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value] !== 'undefined'){
                    for(i=0;i<component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value].length;i++){

						if(component.get('v.activityType') === component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value][i].Activity_Type__c){
		
							var activitySelectOption = document.createElement('option');
							activitySelectOption.value =  component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value][i].Id;
							activitySelectOption.text = component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value][i].Name;
							activitySelectOption.className = "option";
							for(j=0;j<component.get("v.selectedNonProgramActivitiesList").length;j++){
								if(component.get("v.selectedNonProgramActivitiesList")[j].Id === component.get("v.programIdActivityMap")[document.getElementById('nonprogram_'+activityIndex).options[k].value][i].Id){
									activitySelectOption.selected = "true"
									//activitySelectOption.disabled = "true"
								}
							}
							activityArray.push(activitySelectOption);
							document.getElementById('nonprogramActivites_'+activityIndex).setAttribute("multiple", "true");
							document.getElementById('nonprogramActivites_'+activityIndex).setAttribute("size", "3");
							//if(!activityArray.includes(activitySelectOption)){
								document.getElementById('nonprogramActivites_'+activityIndex).add(activitySelectOption);
							//}
					   }
					}
				}else{//if All Activities get scheduled
					document.getElementById('nonprogramActivites_'+activityIndex).setAttribute("multiple", "true");
					document.getElementById('nonprogramActivites_'+activityIndex).setAttribute("size", "3");
				}
            }
        }
        
        if(component.get('v.newUpdateStatus') !== 'New'){
            for(j=0;j<component.get("v.selectedNonProgramActivitiesList").length;j++){
                var activitySelectOption = document.createElement('option');
                activitySelectOption.value = component.get("v.selectedNonProgramActivitiesList")[j].Id;
                activitySelectOption.text = component.get("v.selectedNonProgramActivitiesList")[j].Name;
                activitySelectOption.className = "option";
                activitySelectOption.selected = "true";
                document.getElementById('nonprogramActivites_'+activityIndex).add(activitySelectOption);
                
            }
        }
        
        for(j=0;j<component.get("v.selectedNonProgramActivitiesList").length;j++){
            for(k=0;k<component.get("v.deletedNonActivityList").length;k++){
                if(component.get("v.selectedNonProgramActivitiesList")[j].Id === component.get("v.deletedNonActivityList")[k]){
                    var activitySelectOption = document.createElement('option');
                    activitySelectOption.value = component.get("v.selectedNonProgramActivitiesList")[j].Id;
                    activitySelectOption.text = component.get("v.selectedNonProgramActivitiesList")[j].Name;
                    activitySelectOption.className = "option";
                    document.getElementById('nonprogramActivites_'+activityIndex).add(activitySelectOption);
                    
                }
            }
        }
     
    },
    
    minusNonPrograms : function(component,event){
        var i,j,k;
        var targetId = event.target.id;
        var programIndex = targetId.substring(targetId.indexOf('_')+1,targetId.lastIndexOf('_'));
        var programId = targetId.substring(targetId.lastIndexOf('_')+1,targetId.length);
        //alert(programId+','+programIndex);
        document.getElementById('nonprogramActivity'+programIndex).remove();
        if(component.get("v.deletedNonProgramList") == 'null'){
            var deletearray = [];
            deletearray.push(programId);
            component.set("v.deletedNonProgramList",deletearray);
        }else{
            var deletedArray = []
            for(i=0;i<component.get("v.deletedNonProgramList").length;i++){
                //alert(component.get("v.deletedProgramList")[i]);
                deletedArray.push(component.get("v.deletedNonProgramList")[i]);
            }
            deletedArray.push(programId);
            component.set("v.deletedNonProgramList",deletedArray);
        }
        console.log('component.get("v.deletedNonProgramList")=>'+JSON.stringify(component.get("v.deletedNonProgramList")));
    },
    minusProgram : function(component,event){
        var i,j,k;
        var targetId = event.target.id;
        var programIndex = targetId.substring(targetId.indexOf('_')+1,targetId.lastIndexOf('_'));
        var programId = targetId.substring(targetId.lastIndexOf('_')+1,targetId.length);
        //alert(programId+','+programIndex);
        document.getElementById('programActivity'+programIndex).remove();
        if(component.get("v.deletedProgramList") == 'null'){
            var deletearray = [];
            deletearray.push(programId);
            component.set("v.deletedProgramList",deletearray);
        }else{
            var deletedArray = []
            for(i=0;i<component.get("v.deletedProgramList").length;i++){
                //alert(component.get("v.deletedProgramList")[i]);
                deletedArray.push(component.get("v.deletedProgramList")[i]);
            }
            deletedArray.push(programId);
            component.set("v.deletedProgramList",deletedArray);
        }
        console.log('component.get("v.deletedProgramList")=>'+JSON.stringify(component.get("v.deletedProgramList")));
    },
    
    nonProgramAndProgramSave : function(component,event){
        var activityGrid = 'nonprogramActivityGrid';
        var programSelectOption = 'nonprogram_';
        var programActivitySelectOption ='nonprogramActivites_';
        var programAndActivitiesReadablediv ='nonprogramAndActivities';
        var programActivityParentDiv = 'nonprogramActivity';
        var programActivityRemove = 'nonprogramRemove_';
        var activityReadableDiv = 'nonactivity_';
        var activityNonReadableAdd = 'nonactivityAdd_';
        var activityDiv = 'nonprogramActivitySelectGrid';
        
        var i,j,k,l;
        var programActivityMap = {};
        var programDomIdAndProgramIdMap = {};
        var programDomIdAndProgramNameMap = {};
        var programActivityAfterAddorRemoveMap = {};
        var selectedProgram='';
        //alert(document.getElementsByClassName('nonprogramActivityGrid').length);
        var programActivityLastId = document.getElementsByClassName(activityGrid)[document.getElementsByClassName(activityGrid).length-1].id;
        var programActivityLastIdIndex = programActivityLastId.substring(programActivityLastId.length-1,programActivityLastId.length);
        for(i=1;i<programActivityLastIdIndex;i++){
            //
            //alert(document.getElementById(programSelectOption+i));
            if(document.getElementById(programSelectOption+i)){
                for(k=0;k<document.getElementById(programSelectOption+i).length;k++){
                 	if(document.getElementById(programSelectOption+i).options[k].selected){
                        selectedProgram = document.getElementById(programSelectOption+i).options[k].value;
                 	}
                 }
                if(selectedProgram !== 'Select Program' && selectedProgram !== 'SelectProgram'){
                    console.log('program=>'+document.getElementById(programSelectOption+i).value);
                    
                    var activityArray=[];
                    for (j = 1; j < document.getElementById(programActivitySelectOption+i).length; j++) {
                        if(document.getElementById(programActivitySelectOption+i).options[j].selected !== 'undefined'){
                            if (!document.getElementById(programActivitySelectOption+i).disabled) {
                                //alert('1');
                                console.log(document.getElementById(programActivitySelectOption+i).options[j].value);
                                if(document.getElementById(programActivitySelectOption+i).options[j].value !== 'SelectActivity' &&
                                   (document.getElementById(programActivitySelectOption+i).options[j].selected || document.getElementById(programActivitySelectOption+i).options[j].disabled)) {
                                    //alert('2');
                                    var activityOption = {};
                                    activityOption.id = document.getElementById(programActivitySelectOption+i).options[j].value;
                                    activityOption.value = document.getElementById(programActivitySelectOption+i).options[j].text;
                                    activityArray.push(activityOption);
                                }
                            }
                        }
                    }
                    if (activityArray.length !== 0) {
                        for(k=0;k<document.getElementById(programSelectOption+i).length;k++){
                            if(document.getElementById(programSelectOption+i).options[k].selected){
                                /*for(j=0;j<component.get("v.selectedNonProgramActivitiesList").length;j++){
                                    var activityOption = {};
                                    //alert(component.get("v.selectedNonProgramActivitiesList")[j].Id);
                                    activityOption.id = component.get("v.selectedNonProgramActivitiesList")[j].Id ;
                                    activityOption.value = component.get("v.selectedNonProgramActivitiesList")[j].Name;
                                    if(!activityArray.includes(activityOption)) {   
                                        activityArray.push(activityOption);
                                    }
                                }*/
                                programDomIdAndProgramNameMap[programSelectOption+i]=document.getElementById(programSelectOption+i).options[k].text;
                                programDomIdAndProgramIdMap[programSelectOption+i]=document.getElementById(programSelectOption+i).options[k].value;                        }
                        }
                        programActivityMap[document.getElementById(programSelectOption+i).value] = activityArray;
                    }
                }
            }
        }
        console.log('programActivityMap=>'+JSON.stringify(programActivityMap));
        console.log('programDomIdAndProgramIdMap=>'+JSON.stringify(programDomIdAndProgramIdMap));
        console.log('programDomIdAndProgramNameMap=>'+JSON.stringify(programDomIdAndProgramNameMap));
        component.set("v.savedNonProgramDivNameAndNonProgramIdMap",programDomIdAndProgramIdMap);
        component.set('v.savedNonProgramDivNameAndNonProgramNameMap',programDomIdAndProgramNameMap);
        component.set('v.savedNonProgramActivityMap',programActivityMap)
        console.log('savedNonProgramActivityMap=>'+JSON.stringify(component.get("v.savedNonProgramActivityMap")));
        
    },
    closeModel : function(component){
        $A.util.removeClass(component.find('showCancelOrCompleteTouchpointPopUp'), 'slds-fade-in-open');
        $A.util.addClass(component.find('showCancelOrCompleteTouchpointPopUp'), 'slds-fade-in-close');
        $A.util.removeClass(component.find('cancelORCompleteTouchpointBackGround'), 'slds-backdrop--open');
        $A.util.addClass(component.find('cancelORCompleteTouchpointBackGround'), 'slds-backdrop--close');
    },
    showModel : function(component,event,status){
        var cancelTouchpoint = 'By cancelling the touchpoint, all related activities will be cancelled and cannot be rescheduled \n \n Are you sure you want to cancel the touchpoint?'
        var completeTouchpoint = 'By completing the touchpoint, all related activities will be completed and will be read only \n \n Are you sure you want to complete the touchpoint?'
        if(status === 'Cancelled'){
            component.set('v.popUpHeader','Cancel Touchpoint');
            component.set('v.popUpContent',cancelTouchpoint);
        }else if(status === 'Completed'){
			component.set('v.popUpHeader','Complete Touchpoint');
            component.set('v.popUpContent',completeTouchpoint);            
        }
        $A.util.removeClass(component.find('showCancelOrCompleteTouchpointPopUp'), 'slds-fade-in-close');
        $A.util.addClass(component.find('showCancelOrCompleteTouchpointPopUp'), 'slds-fade-in-open');
        $A.util.removeClass(component.find('cancelORCompleteTouchpointBackGround'), 'slds-backdrop--close');
        $A.util.addClass(component.find('cancelORCompleteTouchpointBackGround'), 'slds-backdrop--open');
    },
    
   redirectiontoList : function(component,event){
       if(!component.get("v.isGrowerList") && !component.get("v.isDealerList") && !component.get("v.isFromCalendar") && !component.get("v.isdealersGrower") && !component.get("v.isGrowerDealer") && !component.get("v.isTouchpoint")){
           if(component.get("v.growerAcc").split('/').length === 3){
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
           }
       }
       if(component.get("v.isGrowerList")){
           /*var growersEvent = component.getEvent("redirectToGrowers");
                        growersEvent.setParams({
                            "accountId" : '',
                        });
                        growersEvent.fire();*/
                        $A.createComponent("c:Frontier_Grower_AccountList",
                                           {
                                               accountId: ''
                                           },
                                           function(GrowerList){
                                               console.log('GrowerList');
                                               var comp = component.find("dynamicBinding");
                                               comp.set("v.body",GrowerList);
                                           }
                                          );
                        
                    }
       if(component.get("v.isDealerList")){
           /*var dealersEvent = component.getEvent("redirectToDelaerList");
                        dealersEvent.setParams({
                            "accountId" : '',
                        });
                        dealersEvent.fire();*/
                        $A.createComponent("c:Frontier_AccountList",
                                           {
                                               accountId: ''
                                           },
                                           function(dealersList){
                                               console.log('dealersList');
                                               var comp = component.find("dynamicBinding");
                                               comp.set("v.body",dealersList);
                                           }
                                          );
                        
                    }
       if(component.get("v.isFromCalendar")){
           var urlEvent = $A.get("e.force:navigateToURL");
           urlEvent.setParams({
               "url": "/one/one.app#/n/Sales_Rep_Touchpoint_Calendar"
           });
           urlEvent.fire();  
       }
       if(component.get("v.isdealersGrower")){
           $A.createComponent("c:Frontier_GrowerAccountList",
                              {
                                  accountId: component.get('v.dealerId')
                              },
                              function(GrowerList){
                                  console.log('dealersGrower');
                                  var comp = component.find("dynamicBinding");
                                  comp.set("v.body",GrowerList);
                              }
                             );
       }
       if(component.get("v.isGrowerDealer")){
           $A.createComponent("c:Frontier_GrowersDealerList",
                              {
                                  accountId: component.get('v.dealerId')
                              },
                              function(GrowerList){
                                  console.log('GrowerDealer');
                                  var comp = component.find("dynamicBinding");
                                  comp.set("v.body",GrowerList);
                              }
                             );
       }
       if(component.get("v.isTouchpoint")){
           $A.createComponent("c:Frontier_GrowAcc_Touchpoints",
                              {
                                  growerAcc: component.get('v.growerAcc').split('/')[1]
                              },
                              function(TouchpointList){
                                  console.log('TouchpointList');
                                  var comp = component.find("dynamicBinding");
                                  comp.set("v.body",TouchpointList);
                              }
                             );
       }
   }
})