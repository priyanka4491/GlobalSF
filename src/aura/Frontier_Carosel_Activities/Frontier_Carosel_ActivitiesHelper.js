({
    getProgramEventListHelper : function(component, event, helper) {       
       		var acctDetails = component.get("v.growerAcc"),
            acctId = acctDetails.split(',')[0],
            acctProgramId  = acctDetails.split(',')[3],
            acctProgramActivityId = acctDetails.split(',')[4];
        
        component.set("v.selectedProgramId",acctProgramId);       
        var action = component.get("c.getProgramsTasksByTask");
        action.setParams({
            acctId : acctId,  
            programId : acctProgramId,
            taskId : acctProgramActivityId    
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var programEventlist = [];
                var retResponse = response.getReturnValue();
                programEventlist = JSON.parse(retResponse);
                console.log("json stringfiy:::" + JSON.stringify(retResponse));
                //component.set("v.programEventList", programEventlist);
                component.set("v.programList",programEventlist.accountProgramList);
                component.set("v.ativityMap",programEventlist.activityMap);
                //component.set("v.selectedActivity",programEventlist.selectedName);
                console.log("v.programEventList from PA" + programEventlist);
                var PgmListId = component.get("v.PgmListId");
                var selectedTask  = component.get("v.selectedActivity");
                var aMap = component.get("v.ativityMap");
                var selaMap =[];
                for(var key in aMap){
                    if(PgmListId && key){
                        if(key === PgmListId){
                            selaMap = aMap[PgmListId];                    
                        }
                    }
                }
                component.set("v.selectedAtivityMap",selaMap);
                var selectedMap = component.get("v.selectedAtivityMap");
                helper.createHTMLForCarosel(component, event, selectedMap, acctProgramActivityId);             
                if(component.get("v.programList").length === component.get("v.programCount")+1){
                    window.setTimeout(
                        $A.getCallback(function() {
                            if (component.isValid()) {
                                $('.carosel').slick({
                                    dots:true,
                                    infinite:false
                                })  
                            }
                        })
                    );
                }
            }
            else if(state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);		
    },
    createHTMLForCarosel : function(component, event, selectedMap, acctProgramActivityId){
        var selectedHtml;
        var   parsedHTML;
        var _bindHtml;
        var topSectionMarkup,tableHead,tableRows,tableBottom ='';
        var buttonDetails =[];
        
        if(selectedMap && selectedMap.length >0){
            
                for(var i in selectedMap){
                    if(acctProgramActivityId === selectedMap[i].Id && selectedMap[i].Program_SFID__r.Name !== 'Non-Program'){
                        topSectionMarkup = '<div>'+
                            '<div class="slds-grid slds-wrap caroselGrid">'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" id='+'parentbackLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentbackLink','backlink','<Back to Activities','c.backToTouchpoint','backlinkClass')+''+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" style="padding-right:5%">'+
                            '<center>'+
                            '<span class="headSection">Activitiy&nbsp#&nbsp'+component.get("v.activityCount")+'</span>'+
                            '<span class="headSection">TouchPoint&nbsp#&nbsp 1</span>';
                        	if(selectedMap[i].TouchPoint_SFID__c){
                            topSectionMarkup= topSectionMarkup+'<span class="headSection-noraml">'+replaceEmptyString(convertCustomDate(selectedMap[i].TouchPoint_SFID__r.Date__c))+'</span>';
                        	}
                            topSectionMarkup = topSectionMarkup +'</center>'+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3">'+
                            '<p data-aura-rendered-by="17:830;a"><b data-aura-rendered-by="18:830;a">Time :&nbsp;<select class="form-control inputstyle select uiInput uiInputSelect uiInput--default uiInput--select" size="1" aria-describedby="" id="20:830;a" data-aura-rendered-by="31:830;a" data-aura-class="uiInput uiInputSelect uiInput--default uiInput--select" data-interactive-lib-uid="9" style="width:50%">&nbsp;'+                    
                            '<option value="" selected="selected" data-aura-rendered-by="24:830;a" class="uiInputSelectOption" data-aura-class="uiInputSelectOption">01:00PM Central US</option></select><!--render facet: 35:830;a--></b></p>'+
                            '</div>'+
                            '</div>'+
                            '<div class="innercaroselGrid">'+
                            '<div class="slds-grid slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large">'+
                            '<strong>Activity</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Subject?selectedMap[i].Subject:selectedMap[i].Name) +''+
                            '</div>';
                            if(selectedMap[i].TouchPoint_SFID__c && selectedMap[i].Status === 'Scheduled'){
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcancelactivityLink','cancelactivitylink','Cancel Activity','c.cancelActivity','cancelactivitylinkClass')+''+
                                    '</div>';  
                            }else{
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    '</div>';     
                            }
                            topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-2 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-p-large slds-custom-m-large">'+
                            '<div class="slds-grid">'+
                            '<div class="slds-size--1-of-2">'+
                            '<strong>Comments</strong>'+
                            '</div>'+
                            '<div class="slds-size--1-of-2 cus-textarea-save-link" id='+'parentcommentSavelinkLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentcommentSavelinkLink','commentSavelink','Save','c.saveComments','commentSavelinkClass')+''+
                            '</div>'+
                            '</div>'+
                            '<textarea style="width:96%;" class="textarea" rows="5" id='+'textArea'+component.get("v.PgmListId")+'>'+ replaceEmptyString(selectedMap[i].Description) +'</textarea>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '<div class="vertical-line" style="height:260px;"></div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-4">'+
                            '<strong>Program</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Program_SFID__r.Name) +''+
                            '</div>'+
                                '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 custom-comp-cancel">';
                            if(component.get("v.prgmStatus") !== 'Completed' && component.get("v.prgmStatus") !== 'Cancelled'){
                                topSectionMarkup = topSectionMarkup +'<span style = "position:relative;right:2%;" id='+'parentcompleteProgramlink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcompleteProgramlink','completeProgramlink','Complete Program','c.completeProgram','completeProgramlinkClass')+''+
                                    '</span>'+
                                	'<span class="slashClass">/</span>' +
                                    '<span style = "position:relative;right:8%;" id='+'parentcancelProgramlink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcancelProgramlink','cancelProgramlink','Cancel Program','c.completeProgram','cancelProgramlinkClass')+''+
                                    '</span>';
                            }
                            topSectionMarkup = topSectionMarkup +'</div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-m-large">'+
                            '<strong>Program Status</strong><br></br>'+
                            '<span id='+'pgmStatus'+component.get("v.PgmListId")+'>'+ replaceEmptyString(component.get("v.prgmStatus")) +'</span>'+
                            '</div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-m-large">'+
                            '<strong>Program Budget</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Program_SFID__r.Budget__C) +''+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>';
                        
                        //set activity Id
                        component.set("v.generatedActivityId",selectedMap[i].Id);
                        //increment count
                        component.set("v.activityCount",component.get("v.activityCount") +1);
                        var cmpEvent = component.getEvent("loadCarosel");
                        cmpEvent.setParams({
                            "activityCount":component.get("v.activityCount"),
                            "isPopup" :false,
                            "modalParameters":''
                        });
                        cmpEvent.fire();
                        break;
                    }
                    if(acctProgramActivityId === selectedMap[i].Id && selectedMap[i].Program_SFID__r.Name === 'Non-Program'){
                        topSectionMarkup = '<div>'+
                            '<div class="slds-grid slds-wrap caroselGrid">'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" id='+'parentbackLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentbackLink','backlink','<Back to Activities','c.backToTouchpoint','backlinkClass')+''+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" style="padding-right:5%">'+
                            '<center>'+
                            '<span class="headSection">Activitiy&nbsp#&nbsp'+component.get("v.activityCount")+'</span>'+
                            '<span class="headSection">TouchPoint&nbsp#&nbsp 1</span>';
                        	if(selectedMap[i].TouchPoint_SFID__c){
                            topSectionMarkup= topSectionMarkup+'<span class="headSection-noraml">'+replaceEmptyString(convertCustomDate(selectedMap[i].TouchPoint_SFID__r.Date__c))+'</span>';
                        	}
                            topSectionMarkup = topSectionMarkup +'</center>'+
                            '</center>'+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3">'+
                            '<p data-aura-rendered-by="17:830;a"><b data-aura-rendered-by="18:830;a">Time :&nbsp;<select class="form-control inputstyle select uiInput uiInputSelect uiInput--default uiInput--select" size="1" aria-describedby="" id="20:830;a" data-aura-rendered-by="31:830;a" data-aura-class="uiInput uiInputSelect uiInput--default uiInput--select" data-interactive-lib-uid="9" style="width:50%">&nbsp;'+                    
                            '<option value="" selected="selected" data-aura-rendered-by="24:830;a" class="uiInputSelectOption" data-aura-class="uiInputSelectOption">01:00PM Central US</option></select><!--render facet: 35:830;a--></b></p>'+
                            '</div>'+
                            '</div>'+
                            '<div class="innercaroselGrid">'+
                            '<div class="slds-grid slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large">'+
                            '<strong>Activity</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Subject?selectedMap[i].Subject:selectedMap[i].Name) +''+
                            '</div>';
                            if(selectedMap[i].TouchPoint_SFID__c && selectedMap[i].Status === 'Scheduled'){
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcancelactivityLink','cancelactivitylink','Cancel Activity','c.cancelActivity','cancelactivitylinkClass')+''+
                                    '</div>';  
                            }else{
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    '</div>';     
                            }
                            topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-2 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-p-large slds-custom-m-large">'+                        
                            '<div class="slds-grid">'+
                            '<div class="slds-size--1-of-2">'+
                            '<strong>Comments</strong>'+
                            '</div>'+
                            '<div class="slds-size--1-of-2 cus-textarea-save-link" id='+'parentcommentSavelinkLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentcommentSavelinkLink','commentSavelink','Save','c.saveComments','commentSavelinkClass')+''+
                            '</div>'+
                            '</div>'+
                            '<textarea style="width:96%;" class="textarea" rows="5" id='+'textArea'+component.get("v.PgmListId")+'>'+ replaceEmptyString(selectedMap[i].Description) +'</textarea>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3">'+
                            '<strong>Program</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Program_SFID__r.Name) +''+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>';
                        
                        //set activity Id
                        component.set("v.generatedActivityId",selectedMap[i].Id);
                        //increment count
                        component.set("v.activityCount",component.get("v.activityCount") +1);
                        var cmpEvent = component.getEvent("loadCarosel");
                        cmpEvent.setParams({
                            "activityCount":component.get("v.activityCount"),
                            "isPopup" :false,
                            "modalParameters":''
                        });
                        cmpEvent.fire();
                        break;
                    }
                }
            if(!component.get("v.generatedActivityId")){
                for(var i in selectedMap){
                    if(acctProgramActivityId !== selectedMap[i].Id && selectedMap[i].Program_SFID__r.Name !== 'Non-Program'){
                        topSectionMarkup = '<div>'+
                            '<div class="slds-grid slds-wrap caroselGrid">'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" id='+'parentbackLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentbackLink','backlink','<Back to Activities','c.backToTouchpoint','backlinkClass')+''+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" style="padding-right:5%">'+
                            '<center>'+
                            '<span class="headSection">Activitiy&nbsp#&nbsp'+component.get("v.activityCount")+'</span>'+
                            '<span class="headSection">TouchPoint&nbsp#&nbsp 1</span>';
                        	if(selectedMap[i].TouchPoint_SFID__c){
                            topSectionMarkup= topSectionMarkup+'<span class="headSection-noraml">'+replaceEmptyString(convertCustomDate(selectedMap[i].TouchPoint_SFID__r.Date__c))+'</span>';
                        	}
                            topSectionMarkup = topSectionMarkup +'</center>'+
                            '</center>'+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3">'+
                            '<p data-aura-rendered-by="17:830;a"><b data-aura-rendered-by="18:830;a">Time :&nbsp;<select class="form-control inputstyle select uiInput uiInputSelect uiInput--default uiInput--select" size="1" aria-describedby="" id="20:830;a" data-aura-rendered-by="31:830;a" data-aura-class="uiInput uiInputSelect uiInput--default uiInput--select" data-interactive-lib-uid="9" style="width:50%">&nbsp;'+                    
                            '<option value="" selected="selected" data-aura-rendered-by="24:830;a" class="uiInputSelectOption" data-aura-class="uiInputSelectOption">01:00PM Central US</option></select><!--render facet: 35:830;a--></b></p>'+
                            '</div>'+
                            '</div>'+
                            '<div class="innercaroselGrid">'+
                            '<div class="slds-grid slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large">'+
                            '<strong>Activity</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Subject?selectedMap[i].Subject:selectedMap[i].Name) +''+
                            '</div>';
                            if(selectedMap[i].TouchPoint__c && selectedMap[i].Status === 'Scheduled'){
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcancelactivityLink','cancelactivitylink','Cancel Activity','c.cancelActivity','cancelactivitylinkClass')+''+
                                    '</div>';  
                            }else{
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    '</div>';     
                            }
                            topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-2 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-p-large slds-custom-m-large">'+                        
                            '<div class="slds-grid">'+
                            '<div class="slds-size--1-of-2 cus-textarea-save-link">'+
                            '<strong>Comments</strong>'+
                            '</div>'+
                            '<div class="slds-size--1-of-2 cus-textarea-save-link" id='+'parentcommentSavelinkLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentcommentSavelinkLink','commentSavelink','Save','c.saveComments','commentSavelinkClass')+''+
                            '</div>'+
                            '</div>'+
                            '<textarea style="width:96%;" class="textarea" rows="5" id='+'textArea'+component.get("v.PgmListId")+'>'+ replaceEmptyString(selectedMap[i].Description) +'</textarea>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '<div class="vertical-line" style="height:260px;"></div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-4">'+
                            '<strong>Program</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Program_SFID__r.Name) +''+
                            '</div>'+
                                '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3 custom-comp-cancel">';
                            if(component.get("v.prgmStatus") !== 'Completed' && component.get("v.prgmStatus") !== 'Cancelled'){
                                topSectionMarkup = topSectionMarkup +'<span style = "position:relative;right:2%;" id='+'parentcompleteProgramlink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcompleteProgramlink','completeProgramlink','Complete Program','c.completeProgram','completeProgramlinkClass')+''+
                                    '</span>'+
                                	'<span class="slashClass">/</span>' +
                                    '<span style = "position:relative;right:8%;" id='+'parentcancelProgramlink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcancelProgramlink','cancelProgramlink','Cancel Program','c.completeProgram','cancelProgramlinkClass')+''+
                                    '</span>';
                            }
                            topSectionMarkup = topSectionMarkup +'</div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-m-large">'+
                            '<strong>Program Status</strong><br></br>'+
                            '<span id='+'pgmStatus'+component.get("v.PgmListId")+'>'+ replaceEmptyString(component.get("v.prgmStatus")) +'</span>'+
                            '</div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-m-large">'+
                            '<strong>Program Budget</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Program_SFID__r.Budget__C) +''+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>';
                        
                        //set activity Id
                        component.set("v.generatedActivityId",selectedMap[i].Id);
                        //increment count
                        component.set("v.activityCount",component.get("v.activityCount") +1);
                        var cmpEvent = component.getEvent("loadCarosel");
                        cmpEvent.setParams({
                            "activityCount":component.get("v.activityCount"),
                            "isPopup" :false,
                            "modalParameters":''
                        });
                        cmpEvent.fire();
                        break;
                    }
                    if(acctProgramActivityId !== selectedMap[i].Id && selectedMap[i].Program_SFID__r.Name === 'Non-Program'){
                        topSectionMarkup = '<div>'+
                            '<div class="slds-grid slds-wrap caroselGrid">'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" id='+'parentbackLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentbackLink','backlink','<Back to Activities','c.backToTouchpoint','backlinkClass')+''+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3" style="padding-right:5%">'+
                            '<center>'+
                            '<span class="headSection">Activitiy&nbsp#&nbsp'+component.get("v.activityCount")+'</span>'+
                            '<span class="headSection">TouchPoint&nbsp#&nbsp 1</span>';
                        	if(selectedMap[i].TouchPoint_SFID__c){
                            topSectionMarkup= topSectionMarkup+'<span class="headSection-noraml">'+replaceEmptyString(convertCustomDate(selectedMap[i].TouchPoint_SFID__r.Date__c))+'</span>';
                        	}
                            topSectionMarkup = topSectionMarkup +'</center>'+
                            '</center>'+
                            '</div>'+
                            '<div class="slds-size--1-of-3 slds-medium-size--1-of-3">'+
                            '<p data-aura-rendered-by="17:830;a"><b data-aura-rendered-by="18:830;a">Time :&nbsp;<select class="form-control inputstyle select uiInput uiInputSelect uiInput--default uiInput--select" size="1" aria-describedby="" id="20:830;a" data-aura-rendered-by="31:830;a" data-aura-class="uiInput uiInputSelect uiInput--default uiInput--select" data-interactive-lib-uid="9" style="width:50%">&nbsp;'+                    
                            '<option value="" selected="selected" data-aura-rendered-by="24:830;a" class="uiInputSelectOption" data-aura-class="uiInputSelectOption">01:00PM Central US</option></select><!--render facet: 35:830;a--></b></p>'+
                            '</div>'+
                            '</div>'+
                            '<div class="innercaroselGrid">'+
                            '<div class="slds-grid slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large">'+
                            '<strong>Activity</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Subject?selectedMap[i].Subject:selectedMap[i].Name) +''+
                            '</div>';
                            if(selectedMap[i].TouchPoint_SFID__c && selectedMap[i].Status === 'Scheduled'){
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    ''+generateDynamicButton('parentcancelactivityLink','cancelactivitylink','Cancel Activity','c.cancelActivity','cancelactivitylinkClass')+''+
                                    '</div>';  
                            }else{
                                topSectionMarkup = topSectionMarkup +'<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2 slds-custom-p-large" id='+'parentcancelactivityLink'+component.get("v.PgmListId")+'>'+
                                    '</div>';     
                            }
                            topSectionMarkup = topSectionMarkup + '<div class="slds-p-horizontal--small slds-size--1-of-2 slds-medium-size--1-of-1 slds-large-size--1-of-1 slds-custom-p-large slds-custom-m-large">'+                        
                            '<div class="slds-grid">'+
                            '<div class="slds-size--1-of-2">'+
                            '<strong>Comments</strong>'+
                            '</div>'+
                            '<div class="slds-size--1-of-2 cus-textarea-save-link" id='+'parentcommentSavelinkLink'+component.get("v.PgmListId")+'>'+
                            ''+generateDynamicButton('parentcommentSavelinkLink','commentSavelink','Save','c.saveComments','commentSavelinkClass')+''+
                            '</div>'+
                            '</div>'+
                            '<textarea style="width:96%;" class="textarea" rows="5" id='+'textArea'+component.get("v.PgmListId")+'>'+ replaceEmptyString(selectedMap[i].Description) +'</textarea>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-2">'+
                            '<div class="slds-grid slds-wrap slds-grid--pull-padded">'+
                            '<div class="slds-p-horizontal--small slds-size--1-of-1 slds-medium-size--1-of-2 slds-large-size--1-of-3">'+
                            '<strong>Program</strong><br></br>'+
                            ''+ replaceEmptyString(selectedMap[i].Program_SFID__r.Name) +''+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>';
                        
                        //set activity Id
                        component.set("v.generatedActivityId",selectedMap[i].Id);
                        //increment count
                        component.set("v.activityCount",component.get("v.activityCount") +1);
                        var cmpEvent = component.getEvent("loadCarosel");
                        cmpEvent.setParams({
                            "activityCount":component.get("v.activityCount"),
                            "isPopup" :false,
                            "modalParameters":''
                        });
                        cmpEvent.fire();
                        break;
                    }
                }
                
            }
            
            tableRows="";
            for(var j in selectedMap){
                if(component.get("v.generatedActivityId") !== selectedMap[j].Id){
                    tableRows = tableRows +
                        '<tr class="tablerow">'+
                        '<td>'+
                        ''+ replaceEmptyString(selectedMap[j].Subject?selectedMap[j].Subject:selectedMap[j].Name) +''+
                        '</td><td>'+
                        ''+ replaceEmptyString(selectedMap[j].Status?selectedMap[j].Status:selectedMap[j].Status__c) +''+
                        '</td><td>'+
                        ''+ replaceEmptyString(selectedMap[j].Phase__c) +''+
                        '</td>'+
                        '</tr>';
                }
            }

            if(tableRows !== ""){
                tableHead = '<div class="slds-grid slds-wrap slds-grid--pull-padded paTable">'+
                    '<p><strong>Related Program Activities</strong></p><br></br>'+
                    '<table id="tableRPA'+component.get("v.PgmListId")+'" class="slds-table  slds-no-row-hover slds-table--product VisitTable">'+
                    '<thead>'+
                    '<tr class="slds-text-custom--label">'+
                    '<th>'+
                    '<span><strong>Activity Name</strong></span>'+
                    '</th>'+                    
                    '<th>'+
                    '<span><strong>Status</strong></span>'+
                    '</th>'+
                    '<th>'+
                    '<div style="text-align:center;">'+
                    '<span style="float:left;">'+
                    '<strong>Phase</strong>'+
                    '</span>'+
                    '<span><svg class="icon  icon--plus" viewBox="0 0 5 5" xmlns="http://www.w3.org/2000/svg"><path d="M2 1 h1 v1 h1 v1 h-1 v1 h-1 v-1 h-1 v-1 h1 z" /></svg></span>'+
                    '<span id='+'parentaddactivityLink'+component.get("v.PgmListId")+'>'+
                    ''+generateDynamicButton('parentaddactivityLink','addactivitylink','Add New Activity','c.showAddNewActivity','addactivitylinkClass')+''+
                    '</span>'+
                    '</div>'+
                    '</th>'+
                    '</tr>'+
                    '</thead><tbody>';
                
                tableBottom ='</tbody></table></div>';
            }
            
            if(tableHead && tableRows && tableBottom){
             _bindHtml = topSectionMarkup + tableHead + tableRows + tableBottom;
            }
            else{
             _bindHtml = topSectionMarkup; 
            }
            
            if(topSectionMarkup){
                if(component.get("v.selectedProgramId") === component.get("v.PgmListId")){
                    var _bindParent = $("#innerCarosel" +component.get("v.programCount")).append(_bindHtml);
                    $(".carosel").prepend(_bindParent);
                }else{
                    $("#innerCarosel" +component.get("v.programCount")).append(_bindHtml);
                }
            }else{
                $("#innerCarosel" +component.get("v.programCount")).remove();
            }
            
        }else{
            $("#innerCarosel" +component.get("v.programCount")).remove();
        }
        
        function replaceEmptyString(value){
            if(!value && value === undefined && value !== 0){
                return ''; 
            }
            else{
                return value;
            }
        }
        function convertCustomDate(date){
            var tchDate;
            if(date){
                var days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
                var months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
                tchDate = new Date(date);
                return days[tchDate.getDay()]+','+months[tchDate.getMonth()]+','+tchDate.getDate()+','+tchDate.getFullYear();
            }
            return tchDate
        }
        //Dynamically create ui:button and the append into carosel markup
        function generateDynamicButton(parentId,butttonId,label,action,markupclass){
            buttonDetails.push({pId:parentId,bId:butttonId,label:label,action:action,mclass:markupclass});
            return '';
        }
        
        for(var k in buttonDetails){
            
            var parentElem = document.getElementById(buttonDetails[k].pId+component.get("v.PgmListId"));
            if(parentElem){
                var accountDetails = component.get("v.growerAcc");
                $A.createComponent(
                    "ui:button",
                    {
                        "aura:id": accountDetails.split(',')[0]+','+accountDetails.split(',')[1]+','+accountDetails.split(',')[2]+','+component.get("v.PgmListId")+','+buttonDetails[k].bId+','+component.get("v.prgmStatus")+','+component.get("v.generatedActivityId"),
                        "label": buttonDetails[k].label,
                        "press": component.getReference(buttonDetails[k].action)
                    },
                    function(newButton, status, errorMessage){
                        if (status === "SUCCESS") {
                            var cmp = component.find(buttonDetails[k].bId)
                            cmp.set("v.body", newButton);
                        }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                        }
                    }
                );
                
                var backlinkelem = $('.'+buttonDetails[k].mclass + component.get("v.programCount"));
                $('.'+buttonDetails[k].mclass + component.get("v.programCount")).remove();
                $('#'+buttonDetails[k].pId +component.get("v.PgmListId")).append(backlinkelem);
            }
            
        }
        
    },
    cancelSelectedActivity : function(component, event, helper, acctId, acctProgramId, acctProgramActivityId){
        
        var action = component.get("c.getCancelActy");
        action.setParams({
            accountId : acctId,
            programId : acctProgramId,
            taskId : acctProgramActivityId    
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                helper.redirectToselectedActivity(component, event, helper);
                console.log('Success');
            }
            else if (state === "ERROR"){
                console.log('Error');
            }
        });
        $A.enqueueAction(action);		
    },
    
    redirectToselectedActivity : function(component, event, helper){
        var cmpEvent = component.getEvent("redirectToDealerDetail");
        cmpEvent.setParams({
            "accIdSapIdAccCommId" : event.getSource().getLocalId(),
            "tabScopeNo" : '2',
            "componentName":"c:Frontier_GrowerAccount_Program",
        });
        cmpEvent.fire();
    },
    saveActivityComments : function (component, event, helper, actAccId, activityId, textAreaValue)
    {
    		var action = component.get("c.saveActivityComments");
        	action.setParams({
            accountId : actAccId,
            activityId : activityId,
            activityComments : textAreaValue
            });
        	action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                this.showPopUp(component,event,'Your Comments Successfully Updated !!');
                console.log('Saved in the backend.  Response success.');
            }
            else if (state === "ERROR"){
                console.log('Unable to save.  Error reported.');
            }
        });
        $A.enqueueAction(action);	
    },
    showPopUp: function(component,event,message){
        $A.createComponent("c:Frontier_PopUp",
                           {Message : message,
                            ComponentName : 'Frontier_Carosel_Activities',
                            customCss : "commentPopup"
                           },
                           function(newComp){
                               var comp = component.find("userpopup");
                               if(comp != undefined){
                                   comp.set("v.body",newComp);
                               }
                           });
        $(".cFrontier_PopUp").css("right:50%");
	}
})