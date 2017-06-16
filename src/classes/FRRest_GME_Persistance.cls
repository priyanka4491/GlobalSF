/* ************************************************************************************************************
 * Category             :   Apex Class
 * Name                 :   FRRest_GME_Persistance
 * Description          :   This class is receiving response form a call out class "FRRestAccDetail", updating 
 *                          the RADL data in the Account Business Role.
 * Author               :   Cognizant Technology Solutions
 * Last Modified Date   :    8/27/2016 3:01 AM
 * ************************************************************************************************************/
public class FRRest_GME_Persistance {
    
   @future(callout=true)
    public static void updateAccountInfo(String responseResults)
    {
        List<FRRestAccDetail.Responsewrapper> result = new  List<FRRestAccDetail.Responsewrapper>();
        if(responseResults != null){
        result.add((FRRestAccDetail.Responsewrapper)JSON.deserialize(responseResults,FRRestAccDetail.Responsewrapper.Class));
        }
        Map<String,String> SAPIds = new Map<String,String>();
        List<Account_Business_Role__c> businessRoles = new List<Account_Business_Role__c>();        
        for(FRRestAccDetail.ResponseData ref: result[0].results[0].data){ 
            SAPIds.put(ref.DLR_SAP_ID,ref.DLR_RADL_CD);
        }
        if(!SAPIds.isEmpty()){
            //for(Account_Business_Role__c businessRole : [SELECT Id,SAP_ID__c,Service_Level_Class_Descr__c FROM Account_Business_Role__c]){
             for(Account_Business_Role__c businessRole : [SELECT Id,(SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),Service_Level_Class_Descr__c FROM Account_Business_Role__c]){
                // If GME Account exist in External System and RADL has value then updates RADL, else updating the value as unknown.
                String identifierapnd = businessRole.Account_Identifiers__r[0].Source_System_ID__c;
                 If(SAPIds.containsKey(identifierapnd)){
                    businessRole.Service_Level_Class_Descr__c = SAPIds.get(identifierapnd) != null ? SAPIds.get(identifierapnd) : 'Unknown';    
                }else{
                    // If GME Account does not exist in External System, updating GME Account RADL as Unknown
                    businessRole.Service_Level_Class_Descr__c = 'Unknown';
                }
                businessRoles.add(businessRole);
            }
        }
        if(!businessRoles.isEmpty()){
            update businessRoles;
        }
        
    }
}