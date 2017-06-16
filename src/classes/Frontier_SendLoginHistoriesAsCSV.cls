global class Frontier_SendLoginHistoriesAsCSV implements Database.Batchable<sobject>,Database.Stateful {
    global String generatedCSVFile;        
    global String fileRow = '';
    global String csvHeader = 'User Name,Title, State,Parent Territory,LoginTime,LoginMonth,LoginType,Status,Browser,Platform,LoginURL,CountryISO\n';
    global String plainTextBody = '';
    global String csvName;
    global String subject;
    global String query;
    global Set<Id> userIdSet = new Set<Id>();
    global String sortingFields = '';
    global Map<Id, Territory2> territoryMap = new Map<Id, Territory2>();
    global List<String> toAddress;
    global Map<Id,User> usermap = new Map<Id,User>();
    
    global Frontier_SendLoginHistoriesAsCSV(String query,Set<Id> userIds,String sortingFields,Map<Id,Territory2> territoryMap,Map<Id,User> usermap){ 
        this.userIdSet.addAll(userIds);
        this.userMap.putAll(userMap);
        this.territoryMap.putAll(territoryMap);
        system.debug('territoryMap=>'+territoryMap);
        sortingFields = (sortingFields != Null ? sortingFields : '');        
        this.query = query;
        generatedCSVFile = '';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator(query);     
    }    
    global void execute(Database.BatchableContext BC,List<LoginHistory> loginList){ 
        String loginWrapList = '';
        loginWrapList = (Frontier_UserLoginReportController.loginRecordMapping(loginList,userMap,territoryMap,true) != Null ?Frontier_UserLoginReportController.loginRecordMapping(loginList,userMap,territoryMap,true):'');
        List<Frontier_UserLoginReportController.historyWrapper> loginHistoryWrapper = (List<Frontier_UserLoginReportController.historyWrapper>)System.JSON.deserialize(loginWrapList, List<Frontier_UserLoginReportController.historyWrapper>.class);
        if(!loginHistoryWrapper.isEmpty()){
            for(Frontier_UserLoginReportController.historyWrapper loginHistoryWrap  : loginHistoryWrapper){
                fileRow = '';
                fileRow = fileRow + ','+loginHistoryWrap.UserName+','+loginHistoryWrap.UserTitle+','+loginHistoryWrap.State+ ','+loginHistoryWrap.ParentTerritory+ ','+loginHistoryWrap.LoginTime;
                fileRow = fileRow + ','+loginHistoryWrap.Month+ ','+loginHistoryWrap.LoginType+ ','+loginHistoryWrap.Status+ ','+loginHistoryWrap.Browser;
                fileRow = fileRow + ','+loginHistoryWrap.Platform+ ','+loginHistoryWrap.LoginUrl+ ','+loginHistoryWrap.CountryIso;            
                fileRow = fileRow.replaceFirst(',','');
                generatedCSVFile = generatedCSVFile + fileRow + '\n';
            }
        }
        else{
            System.debug('generatedCSVFile============================>'+generatedCSVFile);
        }
    }  
    
    global void finish(Database.BatchableContext BC){ 
        AsyncApexJob asyncJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email, ExtendedStatus FROM AsyncApexJob WHERE Id =:bc.getJobId()];  
        if(asyncJob.Status == 'Completed'){
            generatedCSVFile = csvHeader + generatedCSVFile; 
            plainTextBody += 'Hi '+Userinfo.getName()+',\n\n';
            plainTextBody += 'Please find attachment for requested User Login Report . \n\n\n';
            plainTextBody += 'Thanks , \n';
            plainTextBody += 'Global Sales Portal , \n';
            csvName = 'User Login History.csv';
            subject = 'User Login History';
            toAddress = new List<String>{UserInfo.getUserEmail()};
                
                Util.sendEmail(csvName,subject,toAddress,plainTextBody,generatedCSVFile);
        }
    }
}