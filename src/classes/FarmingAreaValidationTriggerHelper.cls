/**********************************************************
 * Name: FarmingAreavalidationTriggerHelper
 * Description: This helper class is for
 *              FarmingAreavalidationTriggerHandler.
 * 
 * 
 * 
 **********************************************************/
public class FarmingAreaValidationTriggerHelper {
    public static void validateCROPFarmAreaVSTotalFarmArea(List<Account_Farming_Area__c> listchildCropFarmingRecords, Map<Id, Account_Farming_Area__c> mapParentFarmingAreaRecords,Map<String,String> parentFarmRecordMap,String triggerContext)
    {
        AggregateResult[] areaQuantityResults;
        if(triggerContext == 'isInsert'){            
            areaQuantityResults = [SELECT Parent_SFID__c,Sum(Inbound_Area_Qty__c), Sum(Area_Qty__c) areaQty FROM Account_Farming_Area__c
                                   WHERE Parent_SFID__c IN : mapParentFarmingAreaRecords.keySet() GROUP BY Parent_SFID__c];
        }
        else if(triggerContext == 'isUpdate'){            
            areaQuantityResults = [SELECT Parent_SFID__c, Sum(Inbound_Area_Qty__c),Sum(Area_Qty__c) areaQty FROM Account_Farming_Area__c
                                WHERE Parent_SFID__c IN : mapParentFarmingAreaRecords.keySet() AND Id NOT IN:listchildCropFarmingRecords GROUP BY Parent_SFID__c];
        }
        
        for(AggregateResult ar : areaQuantityResults){
            if(!parentFarmRecordMap.containskey(String.valueOf(ar.get('Parent_SFID__c')))){                
                    parentFarmRecordMap.put(String.valueOf(ar.get('Parent_SFID__c')),Double.valueOf(ar.get('expr0')) + ':' + (Double.valueOf(ar.get('areaQty')) != null ? Double.valueOf(ar.get('areaQty')) : 0.0));
                
            }
            else{
               String inputVal = parentFarmRecordMap.get(String.valueOf(ar.get('Parent_SFID__c')));
                 Double area_Qty = (inputVal.split(':')[1] != 'null'? Double.valueof(inputVal.split(':')[1]) : 0.0);

                inputVal = Double.valueof(inputVal.split(':')[0]) + Double.valueOf(ar.get('expr0')) + ':' + (area_Qty + (Double.valueOf(ar.get('areaQty')) != null ? Double.valueOf(ar.get('areaQty')) : 0.0));
               parentFarmRecordMap.put(String.valueOf(ar.get('Parent_SFID__c')),inputVal);
            }
        }
          String error = '';
        for(Account_Farming_Area__c childCROPFarm : listchildCropFarmingRecords){ 
            if(parentFarmRecordMap.isEmpty() || (!parentFarmRecordMap.isEmpty() && !parentFarmRecordMap.containskey(String.valueOf(childCROPFarm.Parent_SFID__c)))){               
                 parentFarmRecordMap.put(String.valueOf(childCROPFarm.Parent_SFID__c),'0:0');
            }
            If(parentFarmRecordMap.ContainsKey(childCROPFarm.Parent_SFID__c)){
                Double total_InboundQty = Double.valueof(parentFarmRecordMap.get(childCROPFarm.Parent_SFID__c).split(':')[0]);
                Double area_Qty = (parentFarmRecordMap.get(childCROPFarm.Parent_SFID__c).split(':')[1] == 'null' ? null : Double.valueof(parentFarmRecordMap.get(childCROPFarm.Parent_SFID__c).split(':')[1]));

                if(mapParentFarmingAreaRecords.get(childCROPFarm.Parent_SFID__c).Inbound_Total_Farm_Area_Qty__c < total_InboundQty) {
                     error = Label.External_Data_CROP_Quantity_Error;
                }
                else if(area_Qty != Null && mapParentFarmingAreaRecords.get(childCROPFarm.Parent_SFID__c).Total_Farming_Area_Qty__c < area_Qty){
                     error = Label.External_Data_CROP_Quantity_Error;
                }
                else if(mapParentFarmingAreaRecords.get(childCROPFarm.Parent_SFID__c).Total_Farming_Area_Qty__c == Null && (childCROPFarm.Area_Qty__c != null)){
                    error = Label.External_Data_CROP_Quantity_Error;
                }
            } 
            if(error != ''){
                childCROPFarm.addError(error);
            }
        }
    }
}