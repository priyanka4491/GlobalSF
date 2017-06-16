public class TestDashboardbyMonth {
    
    @AuraEnabled
    public static void getbyMonth(){
        String crop = 'Corn';
        String season = '2016 Safra';
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        Schema.DescribeFieldResult fieldResult;
        List<Schema.PicklistEntry> radlClass;   
        fieldResult = Account_Business_Role__c.Service_Level_Class_Descr__c.getDescribe();
        radlClass = fieldResult.getPicklistValues();
        Set<String> radlClassSet = new Set<String>();
        Set<Id> accCropSeasonId = new Set<Id>();
        List<TouchPoint__c> touchpointList= new List<TouchPoint__c>();
        List<Account_Business_Role__c> accbusinessList = new List<Account_Business_Role__c>();
        Map<Id,String> touchmonthMap = new Map<Id,String>();
        Map<Id,List<Id>> touchAccMap = new Map<Id,List<Id>>();
        RadlTouchWrapper radltouchwrapper; 
        RadlTouchcountWrapper radlwrapper;
        RadlTouchcountWrapper checkwrapper;
        
        if(!radlClass.isEmpty()){
            for(integer i=0;i<radlClass.Size();i++){
                radlClassSet.add(radlClass[i].getvalue());                        
            }
        }
        
        accSalesList = [SELECT Account_SFID__c,Net_Sales_Qty__c,Opportunity__c FROM Account_Sales__c WHERE Selling_Season_Descr__c = :season AND Crop__c = :crop AND Account_Business_Role_SFID__r.Role_Descr__c='Partner'];
        if(!accSalesList.isEmpty()){
            for(Account_Sales__c accSales : accSalesList){
                accCropSeasonId.add(accSales.Account_SFID__c);
                System.debug('accCropSeasonId' + accCropSeasonId);
            }
            
            touchpointList = [SELECT Id, Account_SFID__c, Account_SFID__r.Id, Check__c FROM TouchPoint__c WHERE TouchPoint_Status__c = 'Completed' AND Account_SFID__r.Id IN :accCropSeasonId];
            //touchpointList = Database.query(query);
            system.debug('touchpointList' +touchpointList.size() + ' '+touchpointList);
            if(!touchpointList.isEmpty()){
                System.debug('Inside touchpoint list');
                for(TouchPoint__c tPoint : touchpointList){
                    //touchmonthAccMap.put(tPoint.Account__r.Id,((tPoint.Completion_Date__c).format('MMMMM'))); 
                    if(tPoint.Check__c != null){
                        touchmonthMap.put(tPoint.Id,((tPoint.Check__c).format('MMMMM')));
                        if(touchAccMap.containsKey(tPoint.Account_SFID__c)){
                            List<Id> touchId = touchAccMap.get(tPoint.Account_SFID__c);
                            touchId.add(tPoint.Id);  
                            touchAccMap.put(tPoint.Account_SFID__c, touchId);  
                        }
                        else{
                            touchAccMap.put(tPoint.Account_SFID__c, new List<Id> {tPoint.Id});
                        }
                    }
                } 
                System.debug('touchmonthAccMap' + touchAccMap +' ' + touchmonthMap);
                System.debug('touchmonthMap'+ touchmonthMap);
            } 
            radltouchwrapper = new RadlTouchWrapper();
           // radlwrapper = new  RadlTouchcountWrapper();
            accbusinessList = [SELECT Id, Account_SFID__c, Service_Level_Class_Descr__c FROM Account_Business_Role__c WHERE Account_SFID__c = :touchAccMap.keySet() AND Role_Descr__c='Partner'];
            
            for(Account_Business_Role__c accbusiness : accbusinessList){
                //radltouchwrp = new  RADLtouchWrapper();
                    
                //checkwrapper = new  RadlTouchcountWrapper();
                if(radlClassSet.contains(accbusiness.Service_Level_Class_Descr__c)){
                    System.debug('accbusiness.Account_SFID__c' + accbusiness.Account_SFID__c);
                    if(!touchAccMap.isEmpty() && touchAccMap.containskey(accbusiness.Account_SFID__c)){
                        System.debug('Not empty');
                        List<Id> touchIdList = touchAccMap.get(accbusiness.Account_SFID__c);
                        for(Id tpId : touchIdList){
                            System.debug('Inside Touchpoint List' + tpId);
                            if(touchmonthMap.containskey(tpId) && radltouchwrapper.touchpermontcount.containskey(touchmonthMap.get(tpId))){
                               radlwrapper = radltouchwrapper.touchpermontcount.get(touchmonthMap.get(tpId));
                            }
                           else{
                              radlwrapper = new  RadlTouchcountWrapper();
                           }
                            
                          
                            if(touchmonthMap.containsKey(tpId)){
                                if(radltouchwrapper.touchpermontcount.containsKey((touchmonthMap.get(tpId)))){
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
                        //radlwrp.radlcount.put(accbusiness.Service_Level_Class_Descr__c ,accountMap.get(accbusiness.Account_SFID__c));
                        //System.debug('radlwrp.radlcount' + radlwrp.radlcount);
                        //radltouchwrp.radltouchcount.put(touchmonthAccMap.get(accbusiness.Account_SFID__c),radlwrp);
                        //System.debug('radltouchwrp.radltouchcount' + radltouchwrp.radltouchcount);
                    }
                }   
            } 
            
            System.debug('radltouchwrapper.touchpermontcount' + radltouchwrapper.touchpermontcount);
           // System.debug('radltouchwrp.radltouchcount' + radltouchwrp.radltouchcount);
        }
    }
    public class RadlTouchWrapper{ 
        public Map<String,RadlTouchcountWrapper> touchpermontcount {get;set;}
        
        public RadlTouchWrapper(){
            touchpermontcount = new Map<String,RadlTouchcountWrapper>();
        }
    }
    
    public class RadlTouchcountWrapper{ 
        public Map<String,Integer> radltouchcount {get;set;}
        
        public RadlTouchcountWrapper(){
            radltouchcount = new Map<String,Integer>();
        }
    }
    
    
}