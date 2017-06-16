/* ************************************************************************************************************
 * Category				: 	Apex Class
 * Name					:	Frontier_GetAccountDetails_CMP360
 * Description			:	This class is sending response to a class "Frontier_WebserviceCalls", updating 
 *							the RADL data in the Account Business Role.
 * Author				: 	Cognizant Technology Solutions
 * Last Modified Date	:	8/27/2016 3:01 AM
 * ************************************************************************************************************/

Global class Frontier_WebserviceCalls {
    // This method uses to get the Account related data from the Company360 application.
	@AuraEnabled
    public static String getAccountDatas()        
    {
     	String responseResult = Frontier_GetAccountDetails_CMP360.getGrowerAccs();
        System.debug('Frontier Account Details Response Here'+responseResult);
        return responseResult;	
    }
    
    // This method uses to get the farming datas related to Account from the Customer360 application.
    @AuraEnabled
    public static String getAccountFarmingDatas()
    {
     	String responseResult = Frontier_GetAccountFarmingDatas_CUS360.getGrowerAccFarmingDatas();
        System.debug('Frontier Account Farming Datas Response'+responseResult);
        return responseResult;
    }
}