public class AccountDashboardChartController {
    //Get all RADL picklist value
    public static Schema.DescribeFieldResult fieldResult = Account_Business_Role__c.Service_Level_Class_Descr__c.getDescribe();
    public static List<Schema.PicklistEntry> radlClass = fieldResult.getPicklistValues();
    public static Set<String> radlClassSet = new Set<String>();  
    static{ 
        if(!radlClass.isEmpty()){
            for(integer i=0;i<radlClass.Size();i++){
                radlClassSet.add(radlClass[i].getvalue());    
                System.debug('radlClassSet'+radlClassSet);
            }
        }
    }
    //Get Touchpoint Types to display in Account Dashboard - Touchpointpicklist 
    @AuraEnabled
    public static List<String> getTouchpointTypeValues(){
        system.debug('Inside touchpointtype');
        Schema.DescribeFieldResult fieldTypeResult = TouchPoint__c.TouchPointTypes__c.getDescribe();
        List<Schema.PicklistEntry> typeList = fieldTypeResult.getPicklistValues();
        List<String> touchpointtypeList = new List<String>();
        touchpointtypeList.add('All Touchpoints');
        for (Schema.PicklistEntry reasonLabel: typeList) {
            touchpointtypeList.add(reasonLabel.getLabel());
        }
        system.debug('touchpointtypeList'+touchpointtypeList);
        return touchpointtypeList;
    }
    //Get all Touchpoints of Status completed by Month against Radl
    @AuraEnabled
    public static String getTouchpointbyMonth(String touchpointType,String season, String accType){
        //accType = accIdentifier;
        System.debug('touchpointType' + touchpointType+'season' + season);
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        Map<String,Set<Id>> accIdTerritoryMap = new Map<String ,Set<Id>>();
        Set<Id> accCropSeasonId = new Set<Id>();
        List<TouchPoint__c> touchpointList= new List<TouchPoint__c>();
        List<Account_Business_Role__c> accbusinessList = new List<Account_Business_Role__c>();
        Map<Id,String> touchmonthMap = new Map<Id,String>();
        Map<Id,List<Id>> touchAccMap = new Map<Id,List<Id>>();
        Set<String> touchpointSet = new Set<String>();
        List<String> touchpointTypeList = new List<String>();
        RADLtouchWrapper radltouchwrapper; 
        RADLWrapper radlwrapper;
        //Call Util method to get the account having the crop, season and account type
        accIdTerritoryMap = Util.getAccountSalesAccId(season, accType);
        if(!accIdTerritoryMap.isEmpty()){
            if(accType != 'All Accounts'){
                System.debug('accType' + accType);
                accCropSeasonId = accIdTerritoryMap.get(accType);
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
            else{
                accCropSeasonId.addAll(accIdTerritoryMap.get('Partner'));
                accCropSeasonId.addAll(accIdTerritoryMap.get('Customer'));
                System.debug('accCropSeasonId' + accCropSeasonId);
            } 
        }
        touchpointTypeList = getTouchpointTypeValues();
        if(touchpointType == 'All Touchpoints' || touchpointType == 'null' || touchpointType == null){
            for(String touchpoint : touchpointTypeList){
                touchpointSet.add(touchpoint);
            }
        }
        else{
            touchpointSet.add(touchpointType); 
        }
        System.debug('touchpointSet'  + touchpointSet);
        if(accCropSeasonId!= null){  
            try{
                System.debug('Inside touchpoint list');
                for(TouchPoint__c tPoint :  [SELECT Id, Account_SFID__c, Account_SFID__r.Id, Completion_Date__c FROM TouchPoint__c WHERE TouchPoint_Status__c = 'Completed' AND Account_SFID__r.Id IN :accCropSeasonId AND TouchPointTypes__c IN:touchpointSet]){
                    //touchmonthAccMap.put(tPoint.Account__r.Id,((tPoint.Completion_Date__c).format('MMMMM'))); 
                    if(tPoint.Completion_Date__c != null){
                        touchmonthMap.put(tPoint.Id,((tPoint.Completion_Date__c).format('MMMMM')));
                        if(!touchAccMap.isEmpty() && (touchAccMap.containsKey(tPoint.Account_SFID__c))){
                            List<Id> touchId = touchAccMap.get(tPoint.Account_SFID__c);
                            touchId.add(tPoint.Id);  
                            touchAccMap.put(tPoint.Account_SFID__c, touchId);  
                        }
                        else{
                            touchAccMap.put(tPoint.Account_SFID__c, new List<Id> {tPoint.Id});
                        }
                    }
                } 
            }
            catch(Exception e){
                System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
            }
            System.debug('touchmonthAccMap' + touchAccMap +' ' + touchmonthMap);
            System.debug('touchmonthMap'+ touchmonthMap);
            
            radltouchwrapper = new RadlTouchWrapper();
            // radlwrapper = new  RadlTouchcountWrapper();
            //accbusinessList = 
            try{
                accType = (accType == 'All Accounts' ? '%%' : accType);
                System.debug('accType'  + accType);
                for(Account_Business_Role__c accbusiness : [SELECT Id, Account_SFID__c, Service_Level_Class_Descr__c,Role_Descr__c FROM Account_Business_Role__c WHERE Account_SFID__c = :touchAccMap.keySet() AND Role_Descr__c LIKE:accType]){
                    if(radlClassSet.contains(accbusiness.Service_Level_Class_Descr__c)){
                        if(!touchAccMap.isEmpty() && touchAccMap.containskey(accbusiness.Account_SFID__c)){
                            List<Id> touchIdList = touchAccMap.get(accbusiness.Account_SFID__c);
                            String accRole = (accType == '%%' ? accbusiness.Role_Descr__c : accType);
                            if(accbusiness.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                System.debug('accTypeId'+accTypeId);
                                
                                if(!accTypeId.isEmpty() && accTypeId.contains(accbusiness.Account_SFID__c)){
                                    for(Id tpId : touchIdList){
                                        if( !touchmonthMap.isEmpty() && touchmonthMap.containskey(tpId) && !radltouchwrapper.touchpermontcount.isEmpty() && radltouchwrapper.touchpermontcount.containskey(touchmonthMap.get(tpId))){
                                            radlwrapper = radltouchwrapper.touchpermontcount.get(touchmonthMap.get(tpId));
                                        }
                                        else{
                                            radlwrapper = new  RADLWrapper();
                                        }
                                        if(!touchmonthMap.isEmpty() && touchmonthMap.containsKey(tpId)){
                                            if(!radltouchwrapper.touchpermontcount.isEmpty() && radltouchwrapper.touchpermontcount.containsKey((touchmonthMap.get(tpId)))){
                                                System.debug('Inside contains month');
                                                if((radltouchwrapper.touchpermontcount.get((touchmonthMap.get(tpId)))).radltouchcount.containsKey(accbusiness.Service_Level_Class_Descr__c)){
                                                    System.debug('Inside contains radl in the month map');
                                                    System.debug('radlwrapper.radltouchcount' + radlwrapper.radltouchcount);
                                                    radlwrapper.radltouchcount.put(accbusiness.Service_Level_Class_Descr__c,(((radltouchwrapper.touchpermontcount.get((touchmonthMap.get(tpId)))).radltouchcount.get(accbusiness.Service_Level_Class_Descr__c))+1));
                                                    
                                                    radltouchwrapper.touchpermontcount.put((touchmonthMap.get(tpId)),radlwrapper);
                                                    System.debug('Inside contains radl in the month map' + radltouchwrapper.touchpermontcount);
                                                } 
                                                else{
                                                    System.debug('Inside not contains radl in the month map');
                                                    //radlwrapper = new  RadlTouchcountWrapper();
                                                    System.debug('radlwrapper' + radlwrapper.radltouchcount);
                                                    Integer touchcount =1;
                                                    radlwrapper.radltouchcount.put(accbusiness.Service_Level_Class_Descr__c,touchcount);
                                                    radltouchwrapper.touchpermontcount.put((touchmonthMap.get(tpId)),radlwrapper);
                                                    System.debug('Inside not contains radl in the month map' + radltouchwrapper.touchpermontcount);
                                                }
                                            } 
                                            else{
                                                System.debug('Inside not contains month');
                                                Integer touchcount = 1;
                                                System.debug('Inside not contains month init' + radltouchwrapper.touchpermontcount);
                                                radlwrapper.radltouchcount.put(accbusiness.Service_Level_Class_Descr__c,touchcount);
                                                radltouchwrapper.touchpermontcount.put((touchmonthMap.get(tpId)),radlwrapper);
                                                System.debug('Inside not contains month' + radltouchwrapper.touchpermontcount);
                                            }
                                        }
                                    }
                                }
                            }
                        }   
                    } 
                }
            }
            catch(Exception e){
                System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
            }
            System.debug('radltouchwrapper.touchpermontcount' + radltouchwrapper.touchpermontcount);
            // System.debug('radltouchwrp.radltouchcount' + radltouchwrp.radltouchcount);
        }
        if(radltouchwrapper!=null){
            return JSON.serialize(radltouchwrapper);  
        }
        else{
            return null; 
        }
    }
    //Get all Touchpoints by type against Radl
    @AuraEnabled
    public static String getTouchpointTypebyRADL(String season, String accType){       
        System.debug('accIdentifier' + accType);
        //System.debug('crop' + crop);
        System.debug('season' + season);
        Integer totalcount=0;
        Map<String,Set<Id>> accIdTerritoryMap = new Map<String,Set<Id>>();
        Map<Id,Integer> acctouchCountMap = new Map<Id,Integer>();
        Map<Id,Integer> visitCountMap = new Map<Id,Integer>();
        Map<Id,Integer> webCountMap = new Map<Id,Integer>();
        Map<Id,Integer> emailCountMap = new Map<Id,Integer>();
        Map<String,Integer> totalTouchMap = new Map<String,Integer>();
        Map<String,Integer> visitTouchMap = new Map<String,Integer>();
        Map<String,Integer> webTouchMap = new Map<String,Integer>();
        Map<String,Integer> emailTouchMap = new Map<String,Integer>();
        Map<String,Integer> chatTouchMap = new Map<String,Integer>();
        Map<String,Integer> chatCountMap = new Map<String,Integer>();
        Map<String,Integer> callCountMap = new Map<String,Integer>();
        Map<String,Integer> callTouchMap = new Map<String,Integer>();
        List<Account_Farming_Area__c> accFarmingList= new List<Account_Farming_Area__c>();
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        Set<Id> accCropSeasonId = new Set<Id>();
        List<AggregateResult> groupedResults =  new List<AggregateResult>();
        RADLtouchWrapper radltouchtypeWrp = new RADLtouchWrapper();
        //Get all Touchpoint Types picklist value
        Schema.DescribeFieldResult fieldTypeResult = TouchPoint__c.TouchPointTypes__c.getDescribe();
        List<Schema.PicklistEntry> typeList = fieldTypeResult.getPicklistValues();
        Set<String> touchTypeSet = new Set<String>();
        
        String Status ='Completed';
        String Type1 = '1:1 Visit';
        String Type2 = 'Web';
        String Type3 = 'Email';
        String Type4 = 'Call';
        String Type5 = 'Event';
        //Get all Touchpoint types
        if(!typeList.isEmpty()){
            radltouchtypeWrp.typeSet.add('Total');
            for(Integer i=0;i<typeList.Size();i++){
                // touchTypeSet.add(typeList[i].getValue());
                radltouchtypeWrp.typeSet.add(typeList[i].getValue());
            } 
        }
        //Get accounts having selected season and crop
        accIdTerritoryMap = Util.getAccountSalesAccId(season, accType);
        if(!accIdTerritoryMap.isEmpty()){
            if(accType != 'All Accounts'){
                accCropSeasonId = accIdTerritoryMap.get(accType);
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
            else{
                accCropSeasonId.addAll(accIdTerritoryMap.get('Partner'));
                accCropSeasonId.addAll(accIdTerritoryMap.get('Customer'));
                System.debug('accCropSeasonId' + accCropSeasonId);
            }  
        }
        //Get count of Touchpoints completed for Dealer Account
        String queryString = 'SELECT Account_SFID__c accId, Count(Id) counttouch FROM TouchPoint__c WHERE TouchPoint_Status__c = \''+Status+'\' AND Account_SFID__c IN :accCropSeasonId';
        
        String queryTotalTouch= queryString + ' GROUP BY Account_SFID__c';
        
        groupedResults = Database.query(queryTotalTouch);
        System.debug('groupedResults' + groupedResults);
        for(AggregateResult ar : groupedResults){
            //Id acc = (Id)(ar.get('accId'));
            acctouchCountMap.put( (Id)(ar.get('accId')), Integer.valueOf(ar.get('counttouch')));
            // totalcount += Integer.valueOf(ar.get('counttouch'));
        } 
        system.debug('totalcount for %' + totalcount);
        String queryVisitTotal = queryString + ' AND TouchPointTypes__c = \''+Type1+'\' GROUP BY Account_SFID__c';
        groupedResults = Database.query(queryVisitTotal);
        for(AggregateResult ar : groupedResults){
            visitCountMap.put((Id)(ar.get('accId')),Integer.valueof(ar.get('counttouch')));
            System.debug('visitCountMap' + visitCountMap);
            
        }
        String queryEmailTotal = queryString + ' AND TouchPointTypes__c = \''+Type3+'\' GROUP BY Account_SFID__c';
        groupedResults = Database.query(queryEmailTotal);
        for(AggregateResult ar : groupedResults){
            emailCountMap.put((Id)(ar.get('accId')),Integer.valueof(ar.get('counttouch')));
            System.debug('emailCountMap' + emailCountMap);
        }
        String queryChatTotal = queryString + ' AND TouchPointTypes__c = \''+Type4+'\' GROUP BY Account_SFID__c';
        groupedResults = Database.query(queryChatTotal);
        for(AggregateResult ar : groupedResults){
            chatCountMap.put((Id)(ar.get('accId')),Integer.valueof(ar.get('counttouch')));
            System.debug('callCountMap' + chatCountMap);
        }
        String queryCallTotal = queryString + ' AND TouchPointTypes__c = \''+Type5+'\' GROUP BY Account_SFID__c';
        groupedResults = Database.query(queryCallTotal);
        for(AggregateResult ar : groupedResults){
            callCountMap.put((Id)(ar.get('accId')),Integer.valueof(ar.get('counttouch')));
            System.debug('eventCountMap' + callCountMap);
            
        }
        try{
            accType = (accType == 'All Accounts' ? '%%' : accType);
            System.debug('accType'  + accType);
            if(!acctouchCountMap.isEmpty() || !visitCountMap.isEmpty() || !emailCountMap.isEmpty() || !chatCountMap.isEmpty() || !callCountMap.isEmpty()){
                for(Account_Business_Role__c accBusiness : [SELECT Id, Service_Level_Class_Descr__c,Account_SFID__c,Role_Descr__c FROM Account_Business_Role__c WHERE Service_Level_Class_Descr__c !=null AND Service_Level_Class_Descr__c != 'Unknown' AND Service_Level_Class_Descr__c != 'Other'  AND Account_SFID__c IN :accCropSeasonId AND Role_Descr__c LIKE:accType]){
                    if(radlClassSet.contains(accBusiness.Service_Level_Class_Descr__c)){
                        String accRole = (accType == '%%' ? accBusiness.Role_Descr__c : accType);
                        if(accBusiness.Role_Descr__c == accRole){                                           
                            Set<Id> accTypeId = new Set<Id>();
                            accTypeId = accIdTerritoryMap.get(accRole);
                            System.debug('accTypeId'+accTypeId);
                            if(!accTypeId.isEmpty() && accTypeId.contains(accBusiness.Account_SFID__c)){
                                if(!acctouchCountMap.isEmpty() && acctouchCountMap.containskey(accBusiness.Account_SFID__c)){
                                    if(!radltouchtypeWrp.totalTouchMap.isEmpty() && radltouchtypeWrp.totalTouchMap.containsKey(accBusiness.Service_Level_Class_Descr__c)){
                                        totalcount += (acctouchCountMap.get(accBusiness.Account_SFID__c));
                                        Integer touchcount = (radltouchtypeWrp.totalTouchMap.get(accBusiness.Service_Level_Class_Descr__c))+(acctouchCountMap.get(accBusiness.Account_SFID__c));
                                        radltouchtypeWrp.totalTouchMap.put(accBusiness.Service_Level_Class_Descr__c,touchcount);
                                        
                                    }
                                    else{
                                        radltouchtypeWrp.totalTouchMap.put(accBusiness.Service_Level_Class_Descr__c,acctouchCountMap.get(accBusiness.Account_SFID__c));
                                        totalcount += (acctouchCountMap.get(accBusiness.Account_SFID__c)) ;
                                    }  
                                }
                                
                                if(!visitCountMap.isEmpty() && visitCountMap.containskey(accBusiness.Account_SFID__c)){
                                    if(!radltouchtypeWrp.visitTouchMap.isEmpty() && radltouchtypeWrp.visitTouchMap.containsKey(accBusiness.Service_Level_Class_Descr__c)){
                                        Integer touchcount = (radltouchtypeWrp.visitTouchMap.get(accBusiness.Service_Level_Class_Descr__c))+(visitCountMap.get(accBusiness.Account_SFID__c));
                                        radltouchtypeWrp.visitTouchMap.put(accBusiness.Service_Level_Class_Descr__c,touchcount);
                                    }
                                    else{
                                        radltouchtypeWrp.visitTouchMap.put(accBusiness.Service_Level_Class_Descr__c,visitCountMap.get(accBusiness.Account_SFID__c));
                                    } 
                                    System.debug('radltouchtypeWrp.visitTouchMap'+ radltouchtypeWrp.visitTouchMap);
                                }
                                if(!emailCountMap.isEmpty() && emailCountMap.containskey(accBusiness.Account_SFID__c)){
                                    if(!radltouchtypeWrp.emailTouchMap.isEmpty() && radltouchtypeWrp.emailTouchMap.containsKey(accBusiness.Service_Level_Class_Descr__c)){
                                        Integer touchcount = (radltouchtypeWrp.emailTouchMap.get(accBusiness.Service_Level_Class_Descr__c))+(emailCountMap.get(accBusiness.Account_SFID__c));
                                        radltouchtypeWrp.emailTouchMap.put(accBusiness.Service_Level_Class_Descr__c,touchcount);
                                    }
                                    else{
                                        radltouchtypeWrp.emailTouchMap.put(accBusiness.Service_Level_Class_Descr__c,emailCountMap.get(accBusiness.Account_SFID__c));
                                    }
                                    System.debug('radltouchtypeWrp.visitTouchMap'+ radltouchtypeWrp.visitTouchMap); 
                                } 
                                if(!chatCountMap.isEmpty() && chatCountMap.containskey(accBusiness.Account_SFID__c)){
                                    if(!radltouchtypeWrp.chatTouchMap.isEmpty() && radltouchtypeWrp.chatTouchMap.containsKey(accBusiness.Service_Level_Class_Descr__c)){
                                        Integer touchcount = (radltouchtypeWrp.chatTouchMap.get(accBusiness.Service_Level_Class_Descr__c))+(chatCountMap.get(accBusiness.Account_SFID__c));
                                        radltouchtypeWrp.chatTouchMap.put(accBusiness.Service_Level_Class_Descr__c,touchcount);
                                    }
                                    else{
                                        radltouchtypeWrp.chatTouchMap.put(accBusiness.Service_Level_Class_Descr__c,chatCountMap.get(accBusiness.Account_SFID__c));
                                    }
                                    System.debug('radltouchtypeWrp.visitTouchMap'+ radltouchtypeWrp.visitTouchMap); 
                                }
                                if(!callCountMap.isEmpty() && callCountMap.containskey(accBusiness.Account_SFID__c)){
                                    if(!radltouchtypeWrp.callTouchMap.isEmpty() && radltouchtypeWrp.callTouchMap.containsKey(accBusiness.Service_Level_Class_Descr__c)){
                                        Integer touchcount = (radltouchtypeWrp.callTouchMap.get(accBusiness.Service_Level_Class_Descr__c))+(callCountMap.get(accBusiness.Account_SFID__c));
                                        radltouchtypeWrp.callTouchMap.put(accBusiness.Service_Level_Class_Descr__c,touchcount);
                                    }
                                    else{
                                        radltouchtypeWrp.callTouchMap.put(accBusiness.Service_Level_Class_Descr__c,callCountMap.get(accBusiness.Account_SFID__c));
                                    }
                                    System.debug('radltouchtypeWrp.visitTouchMap'+ radltouchtypeWrp.visitTouchMap); 
                                }
                            }
                        }
                    }
                    
                } 
                
            }
            if(!radlClass.isEmpty()){
                for(Schema.PicklistEntry radl : radlClass){
                    if((!radltouchtypeWrp.totalTouchMap.isEmpty() && radltouchtypeWrp.totalTouchMap.containsKey(radl.getValue()))){ 
                        if(totalcount != null && totalcount > 0){
                            radltouchtypeWrp.TotaltouchPerRadlMap.put(radl.getValue(),(((Decimal)(radltouchtypeWrp.totalTouchMap.get(radl.getValue()))/totalcount)*100).setScale(0));
                            System.debug('Inside totoal touch Percentage' + radltouchtypeWrp.TotaltouchPerRadlMap);    
                        }
                        
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        System.debug('radltouchtypeWrp Radl Type' + radltouchtypeWrp);
        if(radltouchtypeWrp != null){
            return JSON.serialize(radltouchtypeWrp);
        }
        else{
            return null;
        } 
    }
    
    @AuraEnabled
    public static String getAccountRadl(String season, String accType){
        System.debug('getAccountRadl');
        System.debug('Inside account radl' + season + 'season' + 'accIdentifier' + accType);
        //System.debug('crop' + crop);
        System.debug('season' + season);
        Integer accountcount;
        Integer touchpointcount;
        Integer totalaccPgmcount = 0;
        Integer totalaccTouchcount = 0;
        Integer totalacc = 0;
        Integer totalTpcount;
        Set<Id> accTouchId = new Set<Id>();
        Set<Id> accCropSeasonId = new Set<Id>();
        List<Account> accRadlList = new List<Account>();
        Map<String,Integer> accRadlMap = new Map<String,Integer>();
        //Map<String,Integer> accPgmRadlMap = new Map<String,Integer>();
        List<Account_Program__c> accPgmList = new List<Account_Program__c>();
        List<Account_Business_Role__c> accpgmRadl =  new List<Account_Business_Role__c>();
        List<Account_Business_Role__c> accTouchRadlList =  new List<Account_Business_Role__c>();
        List<TouchPoint__c> accTouchList = new List<TouchPoint__c>();
        List<Account_Business_Role__c> accList = new List<Account_Business_Role__c>();
        Map<Id,List<Touchpoint__c>> accountTouchpointMap = new Map<Id,List<Touchpoint__c>>();
        Map<String,Set<Id>> accIdTerritoryMap = new Map<String,Set<Id>>();
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        RADLtouchWrapper radltouchtypeWrp = new RADLtouchWrapper();
        //List<Account> accPgmList = new List<Account>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> accVisistedId = new Set<Id>(); 
        String radl1 = 'Develop';
        String radl2 = 'Acquire';
        String radl3 = 'Retain';
        String radl4 = 'Light Touch';
        
        //Get accounts having selected season and crop
        accIdTerritoryMap = Util.getAccountSalesAccId(season, accType);
        if(!accIdTerritoryMap.isEmpty()){
            if(accType != 'All Accounts'){
                accCropSeasonId = accIdTerritoryMap.get(accType);
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
            else{
                
                accCropSeasonId.addAll(accIdTerritoryMap.get('Partner'));
                accCropSeasonId.addAll(accIdTerritoryMap.get('Customer'));
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
        }
        accType = (accType == 'All Accounts' ? '%%' : accType);
        System.debug('accType'  + accType);
        //Construct query to count dealer account as per Service Level Class Descr
        try{
            accList  = [SELECT Id, Service_Level_Class_Descr__c, Account_SFID__c,Role_Descr__c FROM Account_Business_Role__c WHERE Account_SFID__c = :accCropSeasonId AND Service_Level_Class_Descr__c !=null AND Service_Level_Class_Descr__c != 'Unknown' AND Service_Level_Class_Descr__c != 'Other' AND Role_Descr__c LIKE:accType];
            if(!accList.isEmpty()){
                for(Account_Business_Role__c accradl : accList){
                    if(radlClassSet.contains(accradl.Service_Level_Class_Descr__c)){
                        System.debug('Inside business');
                        //Get count of Dealer Account as per Radl
                        String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                        if(accradl.Role_Descr__c == accRole){                                           
                            Set<Id> accTypeId = new Set<Id>();
                            accTypeId = accIdTerritoryMap.get(accRole);
                            System.debug('accTypeId'+accTypeId);
                            if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                if(!radltouchtypeWrp.accountRadlMap.isEmpty() && radltouchtypeWrp.accountRadlMap.containsKey(accradl.Service_Level_Class_Descr__c)){
                                    totalacc += 1;
                                    accountcount = (radltouchtypeWrp.accountRadlMap.get(accradl.Service_Level_Class_Descr__c)) + 1;
                                    radltouchtypeWrp.accountRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                                    System.debug('Inside if' + radltouchtypeWrp.accountRadlMap);
                                }
                                else{
                                    accountcount = 1;
                                    radltouchtypeWrp.accountRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                                    System.debug('Inside else' + radltouchtypeWrp.accountRadlMap);
                                    totalacc += 1;
                                }
                            }
                        }
                    }
                    //Integer totalacccount = radltouchtypeWrp.get()
                }
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        //Calculate percentage of dealer account against each radl
        if(!radlClass.isEmpty() && !radltouchtypeWrp.accountRadlMap.isEmpty()){
            for(Schema.PicklistEntry radl : radlClass){
                if((radltouchtypeWrp.accountRadlMap.containsKey(radl.getValue()))){ 
                    system.debug('Inside percentage++++'+ radltouchtypeWrp.accountRadlMap.get(radl.getValue())+'----'+totalacc);
                    radltouchtypeWrp.accountRadlperMap.put(radl.getValue(),((((Decimal)(radltouchtypeWrp.accountRadlMap.get(radl.getValue()))/totalacc)*100).setScale(0)));
                    System.debug('Inside percentage accpgm' + radltouchtypeWrp.accountRadlperMap);
                }
            }    
        } 
        //Get dealer accounts having "Selected Season and Crop" and Program  
        try{
            accPgmList = [SELECT Account_SFID__c FROM Account_Program__c WHERE Account_SFID__c IN : accCropSeasonId AND  Program_SFID__c != null];
            for(Account_Program__c accPgm : accPgmList){
                accIdSet.add(accPgm.Account_SFID__c);
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        System.debug('accPgm - accIdSet' + accIdSet);
        //Get Dealer Accounts and its Radl data having Program 
        try{
            accpgmRadl  = [SELECT Id, Service_Level_Class_Descr__c, Account_SFID__c,Role_Descr__c FROM Account_Business_Role__c WHERE Account_SFID__c = :accIdSet AND Service_Level_Class_Descr__c !=null AND Service_Level_Class_Descr__c != 'Unknown' AND Service_Level_Class_Descr__c != 'Other' AND Role_Descr__c LIKE:accType];
            if(!accpgmRadl.isEmpty()){
                for(Account_Business_Role__c accradl : accpgmRadl){
                    if(radlClassSet.contains(accradl.Service_Level_Class_Descr__c)){
                        //Get count of Dealer Account as per Radl
                        if(!radltouchtypeWrp.accPgmRadlMap.isEmpty() && radltouchtypeWrp.accPgmRadlMap.containsKey(accradl.Service_Level_Class_Descr__c)){
                            String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                            if(accradl.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                    totalaccPgmcount += 1;
                                    accountcount = (radltouchtypeWrp.accPgmRadlMap.get(accradl.Service_Level_Class_Descr__c)) + 1;
                                    radltouchtypeWrp.accPgmRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                                    System.debug('Inside if' + radltouchtypeWrp.accPgmRadlMap);
                                }
                            } 
                        }
                        else{
                            String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                            if(accradl.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                    accountcount = 1;
                                    radltouchtypeWrp.accPgmRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                                    System.debug('Inside else' + radltouchtypeWrp.accPgmRadlMap);
                                    totalaccPgmcount += 1;
                                }
                            }
                        }
                    }
                }
                //Calculate percentage of dealer account against each radl
                if(!radlClass.isEmpty() && !radltouchtypeWrp.accPgmRadlMap.isEmpty()){
                    for(Schema.PicklistEntry radl : radlClass){
                        if((radltouchtypeWrp.accPgmRadlMap.containsKey(radl.getValue()))){       
                            radltouchtypeWrp.accPgmRadlpercMap.put(radl.getValue(),((((Decimal)(radltouchtypeWrp.accPgmRadlMap.get(radl.getValue()))/totalaccPgmcount)*100).setScale(0)));
                        }
                    }
                    System.debug('Inside percentage accpgm' + radltouchtypeWrp.accPgmRadlpercMap);
                }   
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        //Get all Dealer Account having Touchpoint type as "Visits" and status as "Completed"
        try{
            accTouchList = [SELECT Id, Account_SFID__c FROM TouchPoint__c WHERE TouchPointTypes__c ='1:1 Visit' AND TouchPoint_Status__c ='Completed' AND Account_SFID__c IN :accCropSeasonId];
            System.debug('Inside Account touch' + accTouchList);
            if(!accTouchList.isEmpty()){
                for(TouchPoint__c accTouch : accTouchList){
                    accTouchId.add(accTouch.Account_SFID__c);
                    if(!accountTouchpointMap.isEmpty() && accountTouchpointMap.containsKey(accTouch.Account_SFID__c)) {
                        accountTouchpointMap.get(accTouch.Account_SFID__c).add(accTouch);
                    }
                    else{
                        accountTouchpointMap.put(accTouch.Account_SFID__c,new List<Touchpoint__c>{accTouch});
                    } 
                }
                System.debug('accountTouchpointMap' + accountTouchpointMap);  
            } 
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        //Get all Dealer Account and it's Service Level Class Descr having touchpoint type as "visits" and status as "Completed"
        try{
            accTouchRadlList  = [SELECT Id, Service_Level_Class_Descr__c,Account_SFID__c,Role_Descr__c FROM Account_Business_Role__c WHERE Account_SFID__C = :accTouchId AND Service_Level_Class_Descr__c !=null AND Service_Level_Class_Descr__c != 'Unknown' AND Service_Level_Class_Descr__c != 'Other' AND Role_Descr__c LIKE :accType];
            System.debug('accTouchRadlList' + accTouchRadlList);
            if(!accTouchRadlList.isEmpty()){
                for(Account_Business_Role__c accradl : accTouchRadlList){
                    if(radlClassSet.contains(accradl.Service_Level_Class_Descr__c)){
                        //Get Dealer Account count against each Radl
                        if(!radltouchtypeWrp.accTouchRadlMap.isEmpty() && radltouchtypeWrp.accTouchRadlMap.containsKey(accradl.Service_Level_Class_Descr__c)){
                            String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                            if(accradl.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                    totalaccTouchcount += 1;
                                    accountcount = (radltouchtypeWrp.accTouchRadlMap.get(accradl.Service_Level_Class_Descr__c)) + 1;
                                    radltouchtypeWrp.accTouchRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                                    System.debug('Inside if accTouchRadlMap' + radltouchtypeWrp.accTouchRadlMap);
                                }
                            } 
                        }
                        else{
                            System.debug('accType'+accType);
                            String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                            if(accradl.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                    accountcount = 1;
                                    radltouchtypeWrp.accTouchRadlMap.put(accradl.Service_Level_Class_Descr__c,accountcount);
                                    totalaccTouchcount += 1;
                                }
                            }
                            System.debug('Inside else accTouchRadlMap' + radltouchtypeWrp.accTouchRadlMap);
                        }
                        //Get Dealer Account's Touchpoint count against each Radl
                        if(!radltouchtypeWrp.TouchpointcountRadlMap.isEmpty() && radltouchtypeWrp.TouchpointcountRadlMap.containsKey(accradl.Service_Level_Class_Descr__c)){
                            String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                            if(accradl.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                    touchpointcount = (radltouchtypeWrp.TouchpointcountRadlMap.get(accradl.Service_Level_Class_Descr__c)) + (accountTouchpointMap.get(accradl.Account_SFID__c).size());
                                    radltouchtypeWrp.TouchpointcountRadlMap.put(accradl.Service_Level_Class_Descr__c,touchpointcount);
                                    System.debug('Inside if TouchpointcountRadlMap' + radltouchtypeWrp.TouchpointcountRadlMap);
                                }
                            }   
                        }
                        else{
                            String accRole = (accType == '%%' ? accradl.Role_Descr__c : accType);
                            if(accradl.Role_Descr__c == accRole){                                           
                                Set<Id> accTypeId = new Set<Id>();
                                accTypeId = accIdTerritoryMap.get(accRole);
                                if(!accTypeId.isEmpty() && accTypeId.contains(accradl.Account_SFID__c)){
                                    touchpointcount = accountTouchpointMap.get(accradl.Account_SFID__c).size();
                                    radltouchtypeWrp.TouchpointcountRadlMap.put(accradl.Service_Level_Class_Descr__c,touchpointcount);
                                    System.debug('Inside else TouchpointcountRadlMap' + radltouchtypeWrp.TouchpointcountRadlMap);
                                }
                            }
                        }
                    }
                }
                //Calculate percentage of Dealer account having touchpoints against each Radl
                if(!radlClass.isEmpty() && !radltouchtypeWrp.accTouchRadlMap.isEmpty()){
                    for(Schema.PicklistEntry radl : radlClass){
                        if((!radltouchtypeWrp.accTouchRadlMap.isEmpty() && radltouchtypeWrp.accTouchRadlMap.containsKey(radl.getValue()))){       
                            radltouchtypeWrp.accTouchRadlpercMap.put(radl.getValue(),(((Decimal)(radltouchtypeWrp.accTouchRadlMap.get(radl.getValue()))/totalaccTouchcount)*100).setScale(0));
                            // radltouchtypeWrp.accTouchRadlpercMap.put(radl.getValue(),Integer.valueOf(((radltouchtypeWrp.accTouchRadlMap.get(radl.getValue()))/(accTouchRadlList.size())) * 100));
                        }
                    }    
                    System.debug('account visits perc===' +radltouchtypeWrp.accTouchRadlpercMap);
                }
                //Calculate total touchpoint having Radl
                if(!radlClass.isEmpty() && !radltouchtypeWrp.TouchpointcountRadlMap.isEmpty()){
                    totalTpcount =0;
                    System.debug('Inside touch count');
                    if(radltouchtypeWrp.TouchpointcountRadlMap.containsKey('Develop')){
                        totalTpcount =   radltouchtypeWrp.TouchpointcountRadlMap.get('Develop');
                    }
                    if(radltouchtypeWrp.TouchpointcountRadlMap.containsKey('Acquire')){
                        totalTpcount = totalTpcount +  radltouchtypeWrp.TouchpointcountRadlMap.get('Acquire');
                    }
                    if(radltouchtypeWrp.TouchpointcountRadlMap.containsKey('Light Touch')){
                        totalTpcount =  totalTpcount + radltouchtypeWrp.TouchpointcountRadlMap.get('Light Touch');
                    }
                    if(radltouchtypeWrp.TouchpointcountRadlMap.containsKey('Retain')){
                        totalTpcount =  totalTpcount + radltouchtypeWrp.TouchpointcountRadlMap.get('Retain');
                    }
                    System.debug('Inside touchpointcountper' + totalTpcount);
                    //Calculate percentage of Dealer account's touchpoints against Radl
                    Decimal totalavgVisit = 0.00;
                    for(Schema.PicklistEntry radl : radlClass){
                        System.debug('Inside  touch radlset');
                        if((!radltouchtypeWrp.TouchpointcountRadlMap.isEmpty() && radltouchtypeWrp.TouchpointcountRadlMap.containsKey(radl.getValue()))){       
                            Decimal divDevelop = (((Decimal)(radltouchtypeWrp.TouchpointcountRadlMap.get(radl.getValue()))/totalTpcount)*100).setScale(0);
                            System.debug('divDevelop' + divDevelop);
                            radltouchtypeWrp.TpcountpercRadlMap.put(radl.getValue(),(((Decimal)(radltouchtypeWrp.TouchpointcountRadlMap.get(radl.getValue()))/totalTpcount)*100).setScale(0));
                            System.debug('touch visit percentage==='+radltouchtypeWrp.TpcountpercRadlMap + ' ' + (radltouchtypeWrp.TouchpointcountRadlMap.get(radl.getValue())));	
                            radltouchtypeWrp.avgVisitRadlMap.put(radl.getValue(),((Decimal)(radltouchtypeWrp.TouchpointcountRadlMap.get(radl.getValue()))/4).setScale(2));
                            totalavgVisit += (radltouchtypeWrp.avgVisitRadlMap.get(radl.getValue()));
                            System.debug('totalavgVisit' + totalavgVisit);
                        }
                    }
                    System.debug('totalavgVisit' + totalavgVisit + ' '+radltouchtypeWrp.avgVisitRadlMap);
                    //Calculate avg percentage against Radl
                    for(Schema.PicklistEntry radl : radlClass){
                        if((!radltouchtypeWrp.avgVisitRadlMap.isEmpty() && radltouchtypeWrp.avgVisitRadlMap.containsKey(radl.getValue()))){       
                            if(((radltouchtypeWrp.avgVisitRadlMap.get(radl.getValue())) > 0) && (totalavgVisit > 0)){
                                radltouchtypeWrp.avgVisitRadlperMap.put(radl.getValue(),(((Decimal)(radltouchtypeWrp.avgVisitRadlMap.get(radl.getValue()))/totalavgVisit)*100).setScale(0));
                                System.debug('avg visit percentage==='+radltouchtypeWrp.avgVisitRadlperMap);
                            } 
                        }     
                    } 
                }
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        
        if(radltouchtypeWrp!=null){
            System.debug('Inside return' + radltouchtypeWrp);
            return JSON.serialize(radltouchtypeWrp);  
        }
        else{
            return null; 
        }
    }
    
    @AuraEnabled
    public static String getRadlCoverage(String season, String accType){
        System.debug('Inside Radl Coverage');
        Set<Id> accVisistedId = new Set<Id>();
        Set<Id> accCropSeasonId = new Set<Id>();
        List<Account_Business_Role__c> accradlCoverageList =  new List<Account_Business_Role__c>();
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        RADLtouchWrapper radltouchtypeWrp = new RADLtouchWrapper();
        List<Account_Farming_Area__c> accFarmingList= new List<Account_Farming_Area__c>();
        Map<Id,Decimal> dealerNetMap = new Map<Id,Decimal>();
        Map<Id,Decimal> dealerOppMap = new Map<Id,Decimal>();
        Map<Id,Decimal> growerOppMap = new Map<Id,Decimal>();
        Map<Id,Decimal> growerNetMap = new Map<Id,Decimal>();
        Decimal totaldealerNetSales = 0;
        Decimal totaldealerOpp = 0;
        Decimal totalgrowerNetSales = 0;
        Decimal totalgrowerOpp = 0;
        //Get all account based on the user territory  
        Set<Id> territoryAccId = new Set<Id>();
        territoryAccId = Util.getTerritoryAccountIds();
        System.debug('territoryAccId'+territoryAccId);
        //Get Accounts having touchpoint of type visists
        try{
            for(TouchPoint__c accVisited : [SELECT Id, Account_SFID__c FROM TouchPoint__c WHERE TouchPointTypes__c ='1:1 Visit' AND Account_SFID__c = :territoryAccId]){
                accVisistedId.add(accVisited.Account_SFID__c); 
            }
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        System.debug('accVisistedId'+accVisistedId);
        //Get Dealer Accounts having selected Season and Crop
        if(accType == 'Partner' || accType == 'All Accounts'){
            try{
                accSalesList = [SELECT Account_SFID__c,Account_Business_Role_SFID__c,Net_Sales_Qty__c,Opportunity__c FROM Account_Sales__c WHERE Selling_Season_Descr__c = :season AND Account_Business_Role_SFID__r.Role_Descr__c='Partner' AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c !=null AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != 'Unknown' AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != 'Other' AND Account_SFID__c = :accVisistedId AND Year__c='2016']; 
                if(!accSalesList.isEmpty()){
                    for(Account_Sales__c accSales : accSalesList){
                        accCropSeasonId.add(accSales.Account_SFID__c);
                        System.debug('accCropSeasonId partner' + accCropSeasonId);
                        if(accSales.Account_Business_Role_SFID__c != null){
                            System.debug('totaldealerOpp' + totaldealerOpp);
                            totaldealerNetSales += (accSales.Net_Sales_Qty__c == Null ? 0 : accSales.Net_Sales_Qty__c);
                            totaldealerOpp += (accSales.Opportunity__c == Null ? 0 : accSales.Opportunity__c);
                            System.debug('totaldealerNetSales' + totaldealerOpp);
                            if(!dealerNetMap.containsKey(accSales.Account_SFID__c)){
                                dealerNetMap.put(accSales.Account_SFID__c,(accSales.Net_Sales_Qty__c == Null ? 0 :accSales.Net_Sales_Qty__c));
                            }
                            else
                            {
                                dealerNetMap.put(accSales.Account_SFID__c,((dealerNetMap.get(accSales.Account_SFID__c))+(accSales.Net_Sales_Qty__c == Null ? 0 :accSales.Net_Sales_Qty__c)));
                            }
                            if(!dealerOppMap.containsKey(accSales.Account_SFID__c)){
                                dealerOppMap.put(accSales.Account_SFID__c,(accSales.Opportunity__c == Null ? 0 :accSales.Opportunity__c));
                                System.debug('dealerOppMap' + dealerOppMap );
                            }
                            else 
                            {
                                dealerOppMap.put(accSales.Account_SFID__c,((dealerOppMap.get(accSales.Account_SFID__c))+(accSales.Opportunity__c == Null ? 0 :accSales.Opportunity__c)));
                                System.debug('dealerOppMap' + dealerOppMap );
                            }
                        }
                    }
                }
            }
            catch(Exception e){
                System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
            }
        }
        if(accType == 'Customer' || accType == 'All Accounts' ){
            try{
                accFarmingList = [SELECT Account_SFID__c,Account_Business_Role_SFID__c,Area_Opportunity__c FROM Account_Farming_Area__c WHERE Selling_Season_Descr__c = :season AND Account_Business_Role_SFID__r.Role_Descr__c = 'Customer' AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c !=null AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != 'Unknown' AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != 'Other' AND Year__c=2016 AND Account_SFID__c = :accVisistedId];
                accSalesList = [SELECT Account_SFID__c,Account_Business_Role_SFID__c,Net_Sales_Qty__c FROM Account_Sales__c WHERE Selling_Season_Descr__c = :season AND Account_Business_Role_SFID__r.Role_Descr__c = 'Customer' AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c !=null AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != 'Unknown' AND Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != 'Other' AND Year__c='2016' AND Account_SFID__c = :accVisistedId ];  
                if(!accFarmingList.isEmpty()){
                    for(Account_Farming_Area__c accFarming : accFarmingList){
                        accCropSeasonId.add(accFarming.Account_SFID__c);
                        System.debug('accCropSeasonId customer' + accCropSeasonId);
                        if(accFarming.Account_Business_Role_SFID__c != null){
                            totalgrowerOpp += (accFarming.Area_Opportunity__c == Null ? 0 :accFarming.Area_Opportunity__c);
                            System.debug('totalgrowerOpp' + totalgrowerOpp);
                            if(!growerOppMap.containsKey(accFarming.Account_SFID__c)){
                                growerOppMap.put(accFarming.Account_SFID__c,(accFarming.Area_Opportunity__c == Null ? 0 :accFarming.Area_Opportunity__c));
                                System.debug('growerOppMap if' + growerOppMap);
                            }
                            else {
                                growerOppMap.put(accFarming.Account_SFID__c,((growerOppMap.get(accFarming.Account_SFID__c))+(accFarming.Area_Opportunity__c == Null ? 0 :accFarming.Area_Opportunity__c)));
                                System.debug('growerOppMap else' + growerOppMap);
                            }
                        }
                    }
                }
                if(!accSalesList.isEmpty()){
                    for(Account_Sales__c accSales : accSalesList){
                        if(accSales.Account_Business_Role_SFID__c != null){
                            System.debug('totalgrowerNetSales' + totalgrowerNetSales);
                            totalgrowerNetSales += (accSales.Net_Sales_Qty__c == Null ? 0 :accSales.Net_Sales_Qty__c);
                        }
                        if(!growerNetMap.containsKey(accSales.Account_SFID__c)){
                            growerNetMap.put(accSales.Account_SFID__c,(accSales.Net_Sales_Qty__c == Null ? 0 :accSales.Net_Sales_Qty__c));
                        }
                        else if(!growerNetMap.isEmpty()){
                            growerNetMap.put(accSales.Account_SFID__c,((growerNetMap.get(accSales.Account_SFID__c))+(accSales.Net_Sales_Qty__c == Null ? 0 :accSales.Net_Sales_Qty__c)));
                        }
                    }
                }
            }
            catch(Exception e){
                System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
            }
        }
        //Construct query to get all accounts from business role having account sales or account farming
        try{
            accType = (accType == 'All Accounts' ? '%%' : accType);
            System.debug('accType'  + accType);
            accradlCoverageList = [SELECT Id, Role_Descr__c, Service_Level_Class_Descr__c, Account_SFID__c FROM Account_Business_Role__c WHERE Account_SFID__c = :accCropSeasonId AND Service_Level_Class_Descr__c!=null AND Service_Level_Class_Descr__c != 'Unknown' AND Service_Level_Class_Descr__c != 'Other' AND Role_Descr__c LIKE:accType];
            if(!accradlCoverageList.isEmpty()){
                System.debug('Inside Account Net' + accradlCoverageList);
                for(Account_Business_Role__c accradlnet : accradlCoverageList){
                    if(radlClassSet.contains(accradlnet.Service_Level_Class_Descr__c)){
                        System.debug('Inside business');
                        //Get count of Dealer Account as per Radl
                        if(!radltouchtypeWrp.accRadldealerOppMap1.isEmpty() && radltouchtypeWrp.accRadldealerOppMap1.containsKey(accradlnet.Service_Level_Class_Descr__c) && accradlnet.Role_Descr__c == 'Partner'){
                            if(!dealerOppMap.isEmpty() && dealerOppMap.containsKey(accradlnet.Account_SFID__c)){
                                radltouchtypeWrp.accRadldealerOppMap1.put(accradlnet.Service_Level_Class_Descr__c,((radltouchtypeWrp.accRadldealerOppMap1.get(accradlnet.Service_Level_Class_Descr__c))+(dealerOppMap.get(accradlnet.Account_SFID__c))));  
                                System.debug('Inside accRadldealerOppMap1' + radltouchtypeWrp.accRadldealerOppMap1);	
                                //Calculation for All Account Radl Coverage 
                            }
                        }
                        else{
                            if(accradlnet.Role_Descr__c == 'Partner' && dealerOppMap.containsKey(accradlnet.Account_SFID__c)){
                                radltouchtypeWrp.accRadldealerOppMap1.put(accradlnet.Service_Level_Class_Descr__c,(dealerOppMap.get(accradlnet.Account_SFID__c))); 
                                System.debug('Inside accRadldealerOppMap1' + radltouchtypeWrp.accRadldealerOppMap1);
                            }
                        }
                        if(!radltouchtypeWrp.accRadlgrowOppMap1.isEmpty() && radltouchtypeWrp.accRadlgrowOppMap1.containsKey(accradlnet.Service_Level_Class_Descr__c) && accradlnet.Role_Descr__c == 'Customer'){
                            if(!growerOppMap.isEmpty() && growerOppMap.containsKey(accradlnet.Account_SFID__c)){
                                radltouchtypeWrp.accRadlgrowOppMap1.put(accradlnet.Service_Level_Class_Descr__c,((radltouchtypeWrp.accRadlgrowOppMap1.get(accradlnet.Service_Level_Class_Descr__c))+(growerOppMap.get(accradlnet.Account_SFID__c))));  
                                System.debug('Inside accRadlgrowOppMap1' + radltouchtypeWrp.accRadlgrowOppMap1);	
                                //Calculation for All Account Radl Coverage
                            }
                        }
                        else{
                            if(accradlnet.Role_Descr__c == 'Customer' && growerOppMap.containsKey(accradlnet.Account_SFID__c)){
                                radltouchtypeWrp.accRadlgrowOppMap1.put(accradlnet.Service_Level_Class_Descr__c,(growerOppMap.get(accradlnet.Account_SFID__c)));
                                System.debug('Inside accRadlgrowOppMap1' + radltouchtypeWrp.accRadlgrowOppMap1);	
                            }
                        }  
                    }
                }
            }
            if(!radlClass.isEmpty()){
                
                Decimal allacctotalOpp = totaldealerOpp + totalgrowerOpp;
                Decimal dealerOppValue =0.0;
                Decimal GrowerOppValue=0.0;
                for(Schema.PicklistEntry radl : radlClass){
                    System.debug('radl.getValue()' + radl.getValue() );
                    system.debug('accType inside for' +accType + 'radltouchtypeWrp.accRadldealerOppMap.get(radl.getValue())'+radltouchtypeWrp.accRadldealerOppMap1.get(radl.getValue())+radltouchtypeWrp.accRadlgrowOppMap1.get(radl.getValue()));
                    if(accType == 'All Accounts' || accType == '%%'){
                        if(!radltouchtypeWrp.accRadldealerOppMap1.isEmpty()){
                            dealerOppValue = (radltouchtypeWrp.accRadldealerOppMap1.get(radl.getValue()) != null ? radltouchtypeWrp.accRadldealerOppMap1.get(radl.getValue()):0.0);
                        }
                        if(!radltouchtypeWrp.accRadlgrowOppMap1.isEmpty()){
                            GrowerOppValue = (radltouchtypeWrp.accRadlgrowOppMap1.get(radl.getValue()) != null?radltouchtypeWrp.accRadlgrowOppMap1.get(radl.getValue()) :0.0); 
                        }
                        System.debug('radl all count'+ dealerOppValue +' '+GrowerOppValue);
                        if((dealerOppValue > 0.0 || GrowerOppValue >0.0) && allacctotalOpp >0.0){
                            System.debug('Inside all account');
                            radltouchtypeWrp.allaccRadlOppMap.put(radl.getValue(),(((Decimal)(dealerOppValue+GrowerOppValue)/allacctotalOpp)*100).setScale(0));
                        system.debug('allacctotalOpp'+allacctotalOpp +'dealerOppValue'+dealerOppValue+'GrowerOppValue'+GrowerOppValue+' radltouchtypeWrp.allaccRadlOppMap'+ radltouchtypeWrp.allaccRadlOppMap);
                        }  
                    }
                    
                    if((!radltouchtypeWrp.accRadldealerOppMap1.isEmpty() && radltouchtypeWrp.accRadldealerOppMap1.containsKey(radl.getValue()))){ 
                        if(totaldealerOpp != null && totaldealerOpp > 0){
                            radltouchtypeWrp.accRadldealerOppMap.put(radl.getValue(),(((Decimal)(radltouchtypeWrp.accRadldealerOppMap1.get(radl.getValue()))/totaldealerOpp)*100).setScale(0));
                            System.debug('Inside net sale' + radltouchtypeWrp.accRadldealerOppMap);    
                        }
                        
                    }
                    if((!radltouchtypeWrp.accRadlgrowOppMap1.isEmpty() && radltouchtypeWrp.accRadlgrowOppMap1.containsKey(radl.getValue()))){   
                        if(totalgrowerOpp != null && totalgrowerOpp > 0){
                            radltouchtypeWrp.accRadlgrowOppMap.put(radl.getValue(),(((Decimal)(radltouchtypeWrp.accRadlgrowOppMap1.get(radl.getValue()))/totalgrowerOpp)*100).setScale(0));
                            System.debug('Inside net sale' + radltouchtypeWrp.accRadlgrowOppMap);
                        } 
                    }
                }    
            } 
        }
        catch(Exception e){
            System.debug('The following error has been occured:  1.Exception type caught:' + e.getTypeName() + '2.Message:' + e.getMessage() + '3.Cause: ' + e.getCause() + '4.Line number: ' + e.getLineNumber() + '5.Stack trace: ' + e.getStackTraceString()); 
        }
        if(radltouchtypeWrp!=null){
            System.debug('Inside return' + radltouchtypeWrp);
            return JSON.serialize(radltouchtypeWrp);  
        }
        else{
            return null; 
        }
    }
    
    public class RADLtouchWrapper{
        Map<String,RADLWrapper> touchpermontcount {get;set;}
        Map<String,Integer>  totalTouchMap {get;set;}
        Map<String,Integer>  visitTouchMap {get;set;}
        Map<String,Integer>  webTouchMap {get;set;}
        Map<String,Integer>  emailTouchMap {get;set;}
        Map<String,Integer> chatTouchMap {get;set;}
        Map<String,Integer> callTouchMap {get;set;}   
        Map<String,Integer> accountRadlMap {get;set;}
        Map<String,Decimal> accountRadlperMap {get;set;}
        Map<String,Integer> accPgmRadlMap {get;set;}
        Map<String,Decimal> accPgmRadlpercMap {get;set;}
        Map<String,Decimal> accTouchRadlpercMap {get;set;}
        Map<String,Integer> accTouchRadlMap {get;set;}
        Map<String,Integer> TouchpointcountRadlMap {get;set;}
        Map<String,Decimal> TpcountpercRadlMap {get;set;}
        Map<String,Decimal> TotaltouchPerRadlMap {get;set;}
        Map<String,Decimal> accRadlCoverMap1 {get;set;}
        Map<String,Decimal> accRadldealerOppMap1 {get;set;}
        Map<String,Decimal> accRadlgrowOppMap1 {get;set;}
        Map<String,Decimal> accRadlgrowNetMap1 {get;set;}
        Map<String,Decimal> accRadlCoverMap {get;set;}
        Map<String,Decimal> accRadldealerOppMap {get;set;}
        Map<String,Decimal> accRadlgrowOppMap {get;set;}
        Map<String,Decimal> accRadlgrowNetMap {get;set;}
        Map<String,Decimal> avgVisitRadlMap {get;set;}
        Map<String,Decimal> avgVisitRadlperMap {get;set;}
        Map<String,Decimal> allaccRadlOppMap {get;set;}
        Set<String> typeSet {get;set;}
        Set<String> accRADLLblSet {get;set;}
        
        public RADLtouchWrapper(){
            touchpermontcount = new Map<String,RADLWrapper>(); 
            totalTouchMap = new Map<String,Integer>();
            visitTouchMap = new Map<String,Integer>();
            webTouchMap = new Map<String,Integer>();
            emailTouchMap = new Map<String,Integer>();
            chatTouchMap = new Map<String,Integer>();
            callTouchMap = new Map<String,Integer>();
            accountRadlMap = new Map<String,Integer>();
            accountRadlperMap = new Map<String,Decimal>();
            accPgmRadlMap = new Map<String,Integer>();
            accPgmRadlpercMap = new Map<String,Decimal>();
            accTouchRadlpercMap = new Map<String,Decimal>();
            accTouchRadlMap = new Map<String,Integer>();
            TouchpointcountRadlMap = new Map<String,Integer>();
            TpcountpercRadlMap = new Map<String,Decimal>();
            accRadlCoverMap1 = new Map<String,Decimal> ();
            accRadldealerOppMap1 = new Map<String,Decimal> ();
            allaccRadlOppMap = new Map<String,Decimal> ();
            accRadlgrowOppMap1 = new Map<String,Decimal> ();
            accRadlgrowNetMap1 = new Map<String,Decimal> ();
            accRadlCoverMap = new Map<String,Decimal> ();
            accRadldealerOppMap = new Map<String,Decimal> ();
            accRadlgrowOppMap = new Map<String,Decimal> ();
            accRadlgrowNetMap = new Map<String,Decimal> ();
            avgVisitRadlMap = new Map<String,Decimal>();
            avgVisitRadlperMap = new Map<String,Decimal>();
            TotaltouchPerRadlMap = new Map<String,Decimal>();
            typeSet = new Set<String>();
            accRADLLblSet = new Set<String>{'Accounts','Accounts with Program','Accounts Visited','Total Visits','Avg Visits'};
                }
        
    }
    public class RADLWrapper{ 
        public Map<String,Integer> radltouchcount{get;set;}
        
        public RADLWrapper(){
            radltouchcount = new Map<String,Integer>();
        }
    } 
}