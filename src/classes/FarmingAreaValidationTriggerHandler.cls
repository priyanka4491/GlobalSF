public class FarmingAreaValidationTriggerHandler {
    public static void onBeforeInsertOrUpdate(List<Account_Farming_Area__c> listFarmingAreaRecords, String triggerContext,Map<Id,Account_Farming_Area__c> OldMap)
    {
        
        // Query CROP Farming Area and Total Farm Area Record Type.
        Id croprecordTypeId;
        set<Id> parentFarmingIdSet = new Set<Id>();
        Recordtypes__c croprecordType = Recordtypes__c.getValues('AccountFarmingAreaCropFarmingArea');
        Recordtypes__c parentFarmrecordType = Recordtypes__c.getValues('AccountFarmingAreaTotalFarmingArea');
        Set<Id> entryParentRecordIds = new Set<Id>();       
        Map<Id,Integer> childRecordMap = new Map<Id,Integer>();
        Map<String,String> parentFarmRecordMap = new Map<String,String>();
        Map<Id,String> parentTotalFarmRecordMap = new Map<Id,String>();
        Set<String> farmingAreaIds = new Set<String>(); 
        List<Account_Farming_Area__c> listParentFarmingAreaRecords = new List<Account_Farming_Area__c>();
        List<Account_Farming_Area__c> listchildCropFarmingRecords = new List<Account_Farming_Area__c>();
        
        Map<Id, Account_Farming_Area__c> mapParentFarmingAreaRecords = new Map<Id, Account_Farming_Area__c>();        
        
        Integer count = 0;
        for(Account_Farming_Area__c farmingRecord : listFarmingAreaRecords){
            if(triggerContext == 'isUpdate' && !OldMap.isEmpty() && farmingRecord.RecordTypeId == parentFarmrecordType.Value__c && OldMap.containsKey(farmingRecord.Id)
               && ((OldMap.get(farmingRecord.Id).Inbound_Total_Farm_Area_Qty__c != farmingRecord.Inbound_Total_Farm_Area_Qty__c) ||
              ((OldMap.get(farmingRecord.Id).Total_Farming_Area_Qty__c == Null && farmingRecord.Total_Farming_Area_Qty__c != Null) 
               || (OldMap.get(farmingRecord.Id).Total_Farming_Area_Qty__c != Null && OldMap.get(farmingRecord.Id).Total_Farming_Area_Qty__c != farmingRecord.Total_Farming_Area_Qty__c)))){
                   parentTotalFarmRecordMap.put(farmingRecord.Id,farmingRecord.Inbound_Total_Farm_Area_Qty__c + ':'+farmingRecord.Total_Farming_Area_Qty__c);
            }
            
            if(farmingRecord.Parent_SFID__c != null && farmingRecord.RecordTypeId == croprecordType.Value__c){
                if(!parentFarmRecordMap.containskey(farmingRecord.Parent_SFID__c)){
                    parentFarmRecordMap.put(farmingRecord.Parent_SFID__c,farmingRecord.Inbound_Area_Qty__c + ':'+farmingRecord.Area_Qty__c);
                }
                else if(parentFarmRecordMap.containskey(farmingRecord.Parent_SFID__c))  {
                    farmingAreaIds.add(farmingRecord.Parent_SFID__c);
                    String inputVal = parentFarmRecordMap.get(farmingRecord.Parent_SFID__c);
                    if(farmingRecord.Inbound_Area_Qty__c != Null){
                        inputVal = Double.valueof(inputVal.split(':')[0]) + farmingRecord.Inbound_Area_Qty__c + ':' + inputVal.split(':')[1];
                    }
                    if(farmingRecord.Area_Qty__c != Null){
                        inputVal =   inputVal.split(':')[0] + ':' + ((inputVal.split(':')[1] != 'null'? Double.valueof(inputVal.split(':')[1]) : 0) + farmingRecord.Area_Qty__c);
                    }
                    parentFarmRecordMap.put(farmingRecord.Parent_SFID__c,inputVal);
                    
                }
                listchildCropFarmingRecords.add(farmingRecord);   
            }
        }
        // Querying all the total farming records
        listParentFarmingAreaRecords = [SELECT Id, RecordTypeId, Account_SFID__c, Account_Business_Role_SFID__c, Area_Usage_Descr__c, Area_Qty__c, Inbound_Area_Qty__c, Archive_Date__c,
                                        Archive_Ind__c, Area_Updated_DateTime__c, Parent_SFID__c,Service_Level_Class_Descr__c, Selling_Season_Descr__c,
                                        Total_Farming_Area_Qty__c, Inbound_Total_Farm_Area_Qty__c, Area_Usage_UOM_Descr__c, Year__c, Year_Type__c,Inbound_Area_Use_UOM_Descr__c
                                        FROM Account_Farming_Area__c WHERE Id IN : parentFarmRecordMap.keySet()];
        for(Account_Farming_Area__c totalFarmRecord : listParentFarmingAreaRecords) {
            if(!parentTotalFarmRecordMap.isEmpty() && parentTotalFarmRecordMap.containsKey(totalFarmRecord.Id)) {
                totalFarmRecord.Inbound_Total_Farm_Area_Qty__c =  (parentTotalFarmRecordMap.get(totalFarmRecord.Id).split(':')[0] != 'null' ? Integer.valueOf(parentTotalFarmRecordMap.get(totalFarmRecord.Id).split(':')[0]):totalFarmRecord.Inbound_Total_Farm_Area_Qty__c);
                totalFarmRecord.Total_Farming_Area_Qty__c =  (parentTotalFarmRecordMap.get(totalFarmRecord.Id).split(':')[1] != 'null' ? Integer.valueOf(parentTotalFarmRecordMap.get(totalFarmRecord.Id).split(':')[1]):totalFarmRecord.Total_Farming_Area_Qty__c);
              }
            
            mapParentFarmingAreaRecords.put(totalFarmRecord.Id, totalFarmRecord);            
        }
        if(!listchildCropFarmingRecords.isEmpty() && mapParentFarmingAreaRecords.size() > 0){
            FarmingAreaValidationTriggerHelper.validateCROPFarmAreaVSTotalFarmArea(listchildCropFarmingRecords, mapParentFarmingAreaRecords,parentFarmRecordMap,triggerContext);       
        }
    }
}