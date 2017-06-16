public class Frontier_GrowerFarmSizeController {
    @AuraEnabled    
    public static String GrowerFarmSizeDetails(Id growerAccId,String fiscalyr,String uom){
        GrowerAccountDataWrapper accountData = new GrowerAccountDataWrapper();
        List<Integer> areaShareList = new  List<Integer>();
        Integer areaMonShareTotal=0;
        Integer areaMonTotal=0;
        Decimal cropAreaQty;
        Decimal TotalReaQty;
        String Unit;
        //Id recordTypeId =[select id from Recordtype where Developername='Account_Farming_Area_Total_Farming_Area' LIMIT 1].id;
        //system.debug('recordTypeId' +recordTypeId);
        String season;
        season = 'SUMMER';
        System.debug('fiscalyr' + fiscalyr + 'season' + season);
        List<Account_Farming_Area__c> accFarmingArea;
        String queryString= 'SELECT Id, Name,Account_SFID__c, Account_Business_Role_SFID__c, Parent_SFID__c,Area_Usage_Descr__c,Inbound_Area_Qty__c,Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c,Parent_SFID__r.Selling_Season_Descr__c,Inbound_Area_Use_UOM_Descr__c,Year__c, Year_Type__c From Account_Farming_Area__c Where Parent_SFID__c!=null AND Parent_SFID__r.Account_SFID__c = :growerAccId';  
        if(fiscalyr ==null ||fiscalyr=='FY17' ){
            
            queryString += ' AND Parent_SFID__r.Year__c=2017 AND Selling_Season_Descr__c=\''+season+'\'';
        }
        if(fiscalyr=='FY16' ){
            
            queryString += ' AND Parent_SFID__r.Year__c=2016 AND Selling_Season_Descr__c=\''+season+'\''; 
        }
        if(fiscalyr=='FY15' ){
            
            queryString += ' AND Parent_SFID__r.Year__c=2015 AND Selling_Season_Descr__c=\''+season+'\''; 
        }
        accFarmingArea =Database.query(queryString);
        System.debug('accFarmingArea' + accFarmingArea);
        if(accFarmingArea.isEmpty()){
            accFarmingArea = new List<Account_Farming_Area__c>();
        }
        
        for(Integer i=0;i<accFarmingArea.size();i++){          
            if(uom==null || uom=='Acres'){
                cropAreaQty= (Integer.valueof(Math.roundToLong(accFarmingArea[i].Inbound_Area_Qty__c)));
                TotalReaQty =(Integer.valueof(Math.roundToLong(accFarmingArea[i].Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c)));
            }
            else if(uom=='hectares'){
                cropAreaQty= (Integer.valueof(0.404*(Math.roundToLong(accFarmingArea[i].Inbound_Area_Qty__c))));
                TotalReaQty =(Integer.valueof(0.404*(Math.roundToLong(accFarmingArea[i].Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c))));
            }
            Integer areaMonsatoShare = cropAreaQty != null && TotalReaQty != null ? Integer.valueOf((cropAreaQty/TotalReaQty)*100) : 0;            
            areaMonShareTotal = areaMonShareTotal +areaMonsatoShare; 
            areaMonTotal =  areaMonTotal != null && cropAreaQty != null ?areaMonTotal + (Integer.valueOf(cropAreaQty)) : 0;
            areaShareList.add(areaMonsatoShare);
            System.debug('areaShareList' + areaShareList);
        }
        
        for(Integer i=0;i<areaShareList.size() && i<accFarmingArea.size();i++){
            if(uom==null || uom=='acres'){
                cropAreaQty= (Integer.valueof(Math.roundToLong(accFarmingArea[i].Inbound_Area_Qty__c)));
                Unit = accFarmingArea[i].Inbound_Area_Use_UOM_Descr__c != Null ? accFarmingArea[i].Inbound_Area_Use_UOM_Descr__c : ' Acres';
            }
            else if(uom=='hectares'){
                cropAreaQty= (Integer.valueof(0.404*(Math.roundToLong(accFarmingArea[i].Inbound_Area_Qty__c))));
                Unit =' Hectares';
            }
            accountData.Labels.add(areaShareList[i] + '% |' +accFarmingArea[i].Area_Usage_Descr__c+ ': ' + (Integer.valueOf(cropAreaQty)) +'' +Unit ) ; 
            accountData.growerAccountCroparea.add(areaShareList[i]);
        }
        if((uom==null || uom=='Acres') && !accFarmingArea.isEmpty() ){
            TotalReaQty =(accFarmingArea[0].Parent_SFID__r != Null ? (Integer.valueOf(Math.roundToLong(accFarmingArea[0].Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c))) :0 );
            Unit = (accFarmingArea[0].Inbound_Area_Use_UOM_Descr__c != Null)? accFarmingArea[0].Inbound_Area_Use_UOM_Descr__c : 'Acres';
            accountData.growerTotalArea=Integer.valueOf(TotalReaQty);
            System.debug('Acre' + accountData.growerTotalArea);
            
        }
        else if(uom=='hectares' && !accFarmingArea.isEmpty()){
            TotalReaQty =(accFarmingArea[0].Parent_SFID__r != NULL ? (Integer.valueOf(0.404*(Math.roundToLong(accFarmingArea[0].Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c)))) : 0);
            Unit =' Hectares';
            accountData.growerTotalArea=Integer.valueOf(TotalReaQty);
            System.debug('hectares' + accountData.growerTotalArea);
        }
        if(TotalReaQty != NUll){
         accountData.othersShare=100 - areaMonShareTotal;

            accountData.othersArea=(Integer.ValueOf(TotalReaQty))- areaMonTotal;
        }
        if(accountData.othersShare != 0){
            accountData.Labels.add(accountData.othersShare + '% |' +'Others'+ ': ' +( accountData.othersArea != Null ?  accountData.othersArea : 0 )+' ' +( Unit != Null ? Unit : 'N/A')) ; 
            accountData.growerAccountCroparea.add(accountData.othersShare);
        }
        for(Account_Farming_Area__c accfarming :accFarmingArea){
            accountData.growerAccountTotalArea=(accfarming.Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c != NULL?(Integer.valueOf(Math.roundToLong(accfarming.Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c))):0);
        }
        System.debug('accountData' + accountData);
        return JSON.serialize(accountData);
    }
    
    @AuraEnabled    
    public static String getupdateFYArea(Id growerAccId,String crop1select,String crop2select, String crop3select,Integer totalArea, Integer  cornArea,Integer soyArea, Integer cottonArea, String seasonKey){
        System.debug('Inside update' + growerAccId + ' '+ crop1select);
        List<Account_Farming_Area__c> accFarmingArea = new List<Account_Farming_Area__c>();
        List<Account_Farming_Area__c> accFarmupd = new List<Account_Farming_Area__c>();
        List<Account_Farming_Area__c> accparentFarmingArea = new List<Account_Farming_Area__c>();
        String Error = '';
        
        accFarmingArea = [SELECT Id, Name,Account_SFID__c, Account_Business_Role_SFID__c, Parent_SFID__c,Area_Usage_Descr__c,Inbound_Area_Qty__c,Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c,Parent_SFID__r.Selling_Season_Descr__c,Inbound_Area_Use_UOM_Descr__c,
                          RFM_Score__c, Selling_Season_Descr__c, Year__c, Year_Type__c, NPS__c From Account_Farming_Area__c Where RecordType.DeveloperName='Account_Farming_Area_Crop_Farming_Area' AND Parent_SFID__r.Account_SFID__c =: growerAccId AND Selling_Season_Descr__c='SUMMER' AND Parent_SFID__r.Year__c = 2017];
        System.debug('accFarmingArea' + accFarmingArea);
        for(Account_Farming_Area__c accountFarmingArea : accFarmingArea){
            if(crop1select == accountFarmingArea.Area_Usage_Descr__c){
                System.debug('crop1select' + crop1select);
                accountFarmingArea.Area_Qty__c = cornArea;
                accFarmupd.add(accountFarmingArea);
            }
            if(crop2select == accountFarmingArea.Area_Usage_Descr__c){
                System.debug('crop2select' + crop2select);

                accountFarmingArea.Area_Qty__c = soyArea;
                accFarmupd.add(accountFarmingArea);
            }
            if(crop3select == accountFarmingArea.Area_Usage_Descr__c){
                System.debug('crop3select' + crop3select);

                accountFarmingArea.Area_Qty__c = cottonArea;
                accFarmupd.add(accountFarmingArea);
            }
        }
        
        //accparentFarmingArea.add(new Account_Farming_Area__c(Id = accFarmingArea[0].Parent_SFID__c,Total_Farming_Area_Qty__c = totalArea));
        try{
            accFarmupd.add(new Account_Farming_Area__c(Id = accFarmingArea[0].Parent_SFID__c,Total_Farming_Area_Qty__c = totalArea));
            System.debug('accFarmupd' + accFarmupd);
            update accFarmupd; 
            
           
        }
        catch(Exception e){
            Error = Label.External_Data_CROP_Quantity_Error;
        }
        
        return Error;
    }
    
    @AuraEnabled
    public static String dealerSalesDetails(Id dealerAccId,String crop){
        GrowerAccountDataWrapper accountData = new GrowerAccountDataWrapper();
         List<Territory2> territoryList = new List<Territory2>();
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
          userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                                UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
            territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
                             Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }
        system.debug('territoryList'+territoryList);
        Map<String,List<Decimal>> salesMap = new Map<String,List<Decimal>>();
        Map<String,List<Decimal>> orderMap = new Map<String,List<Decimal>>();
        set<String> season =new set<String>{'2017 Safra','2016 Safra','2015 Safra'};
            List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        //accSalesList = [SELECT Id, Name,Account_SFID__c, Account_Business_Role_SFID__c,Net_Sales_Qty__c, Parent_SFID__c,Area_Usage_Descr__c,Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c,Parent_SFID__r.Selling_Season_Descr__c,Inbound_Area_Use_UOM_Descr__c,
        //RFM_Score__c, Selling_Season_Descr__c,Orders__c, Year__c, Year_Type__c, NPS__c From Account_Farming_Area__c Where RecordType.DeveloperName='Account_Farming_Area_Crop_Farming_Area' AND Parent_SFID__r.Account_SFID__c =: dealerAccId AND Selling_Season_Descr__c IN: season AND Area_Usage_Descr__c=:crop];
        accSalesList=[Select Id,Name,Account_SFID__c,Net_Sales_Qty__c,Year__c,Order_Qty__c From Account_Sales__c where Account_SFID__c=:dealerAccId AND Crop__c=:crop AND Account_Business_Role_SFID__r.Role_Descr__c='Partner'];
        if(!accSalesList.isEmpty()){
            for(Account_Sales__c accSales :accSalesList){
                if(!salesMap.containsKey(accSales.Year__c)){
                    salesMap.put(accSales.Year__c,new List<Decimal>{accSales.Net_Sales_Qty__c == null ? 0 : accSales.Net_Sales_Qty__c});
                }
                else{
                    salesMap.get(accSales.Year__c).add(accSales.Net_Sales_Qty__c);
                }
                if(!orderMap.containsKey(accSales.Year__c)){
                    orderMap.put(accSales.Year__c,new List<Decimal>{accSales.Order_Qty__c == null ? 0 : accSales.Order_Qty__c});
                }
                else{
                    orderMap.get(accSales.Year__c).add(accSales.Order_Qty__c == null ? 0 : accSales.Order_Qty__c);
                }
                
            }
        }
        System.debug('salesMap'+salesMap);
        System.debug('orderMap'+orderMap);
        
        
        for(String salesYear : salesMap.keySet()){
            Decimal Salesdata = 0.0;
            for(Decimal sales : salesMap.get(salesYear)){
              Salesdata += sales; 
            }
          accountData.SalesYearMap.put(salesYear,Salesdata) ;
          //Salesdata = 0.0;

        }
        for(String orderYear : orderMap.keySet()){
            Decimal Orderdata = 0.0;
            for(Decimal order : orderMap.get(orderYear)){
              Orderdata += order; 
                
            }
         accountData.OrderYearMap.put(orderYear,Orderdata) ;
            //Orderdata = 0.0;
        }
        system.debug('accountData.SalesYearMap'+accountData.SalesYearMap);
        system.debug('accountData.OrderYearMap'+accountData.OrderYearMap	);

        return JSON.serialize(accountData);       
    }
    @AuraEnabled
    public static List<String> getCropList(){
        System.debug('Inside crop');
        List<String> cropValue = new List<String>();
        Schema.DescribeFieldResult cropResult = Account_Sales__c.crop__c.getDescribe();
        List<Schema.PicklistEntry> croppicvalues = cropResult.getPicklistValues();
       
        for (Schema.PicklistEntry reasonLabel: croppicvalues) {
            cropValue.add(reasonLabel.getLabel());
        }
        System.debug('cropValue' + cropValue);
        return cropValue;
    }
    @AuraEnabled    
    public static String getdealerSalesDetails(String dealerAccId,String UOM){
        System.debug('dealerAccId' + dealerAccId+UOM);
        Integer TotalNetSales = 0;
        List<Territory2> territoryList = new List<Territory2>();
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>(); 
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        Map<String,Integer> cropSalesMap = new Map<String,Integer>();
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                             UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
            territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
                             Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }
        system.debug('territoryList'+territoryList);
        
        accSalesList=[Select Id,Name,Account_SFID__c,Brand_Name__c,Crop__c,Net_Sales_Qty__c,Opportunity__c,Year__c,Business_Unit_Descr__c,Account_Business_Role_SFID__r.Role_Descr__c From Account_Sales__c where Account_SFID__c=:dealerAccId AND Unit_Of_Measure__c=:UOM AND Account_Business_Role_SFID__r.Role_Descr__c='Partner'] ;
        system.debug('accSalesList'+accSalesList);
        List<AccountSalesWrapper> accSalesWrapList = new List<AccountSalesWrapper>();
        AccountSalesWrapper accSalesWrap = new AccountSalesWrapper();
        if(!territoryList.isEmpty()){
            accSalesWrap.salesRepBrand = territoryList[0].Division__c;
        }
        
        for(Account_Sales__c accSales : accSalesList){
            salesYearWrapper salesYear = new salesYearWrapper();
            salesWrapper salesrecord = new salesWrapper();  
            
            if(accSales.Crop__c != null){
                if(accSalesWrap.cropMap.containskey(accSales.Crop__c)){
                    salesYear =  accSalesWrap.cropMap.get(accSales.Crop__c);
                    
                }
                if(accSales.Business_Unit_Descr__c != null){
                if(accSales.Year__c == '2017'){
                    if(salesYear.CY.containsKey(accSales.Business_Unit_Descr__c)){
                        salesrecord = salesYear.CY.get(accSales.Business_Unit_Descr__c);
                        salesrecord.netSalesCY = (Integer.valueOf((salesrecord.netSalesCY)) + (Integer.valueOf(accSales.Net_Sales_Qty__c)));
                        salesrecord.OpportunityCY = (Integer.valueOf((salesrecord.OpportunityCY)) + (Integer.valueOf(accSales.Opportunity__c)));
                    }
                    else{
                        salesrecord.netSalesCY=(accSales.Net_Sales_Qty__c != null ? (Integer.valueOf(accSales.Net_Sales_Qty__c)):0);
                        salesrecord.OpportunityCY = (accSales.Opportunity__c != null ? (Integer.valueOf(accSales.Opportunity__c)):0);  
                    }       
                    salesYear.CY.put(accSales.Business_Unit_Descr__c,salesrecord);
                    System.debug('salesYear' +salesYear.CY);
                    //Calculate total net sales per crop
                    if(accSales.Business_Unit_Descr__c == accSalesWrap.salesRepBrand){
                        if(cropSalesMap.containsKey(accSales.Crop__c)){
                            TotalNetSales +=  (cropSalesMap.get(accSales.Crop__c));
                            cropSalesMap.put(accSales.Crop__c,TotalNetSales); 
                        }
                        else{
                            cropSalesMap.put(accSales.Crop__c,Integer.valueOf(accSales.Net_Sales_Qty__c)); 
                        }
                        
                    }
                    
                }
                if(accSales.Year__c == '2016'){
                    if(salesYear.PY.containsKey(accSales.Business_Unit_Descr__c)){
                        salesrecord = salesYear.PY.get(accSales.Business_Unit_Descr__c);
                        salesrecord.netSalesPY = (Integer.valueOf((salesrecord.netSalesPY)) + (Integer.valueOf(accSales.Net_Sales_Qty__c)));
                        salesrecord.OpportunityPY = (Integer.valueOf((salesrecord.OpportunityPY)) + (Integer.valueOf(accSales.Opportunity__c)));
                    }
                    else{
                        salesrecord.netSalesPY=(accSales.Net_Sales_Qty__c != null ? (Integer.valueOf(accSales.Net_Sales_Qty__c)):0);
                        salesrecord.OpportunityPY = (accSales.Opportunity__c != null ? (Integer.valueOf(accSales.Opportunity__c)):0);
                    }
                    salesYear.PY.put(accSales.Business_Unit_Descr__c,salesrecord);  
                }
                if(accSales.Year__c == '2015'){
                    if(salesYear.twoPY.containsKey(accSales.Business_Unit_Descr__c)){
                        salesrecord = salesYear.twoPY.get(accSales.Business_Unit_Descr__c);
                        salesrecord.netSalestwoPY = (Integer.valueOf((salesrecord.netSalestwoPY)) + (Integer.valueOf(accSales.Net_Sales_Qty__c)));
                        salesrecord.OpportunitytwoPY = (Integer.valueOf((salesrecord.OpportunitytwoPY)) + (Integer.valueOf(accSales.Opportunity__c)));
                    }
                    else{
                        salesrecord.netSalestwoPY=(accSales.Net_Sales_Qty__c != null ? (Integer.valueOf(accSales.Net_Sales_Qty__c)):0);
                        salesrecord.OpportunitytwoPY = (accSales.Opportunity__c != null ? (Integer.valueOf(accSales.Opportunity__c)):0);
                    }
                    salesYear.twoPY.put(accSales.Business_Unit_Descr__c,salesrecord); 
                    
                }
                }
                accSalesWrap.cropMap.put(accSales.Crop__c,salesYear);
                //accSalesWrapList.add(accSalesWrap) ; 
            }
        }
        Integer TotalSales = 0;
        Integer cropSales;
        for(Integer netSales : cropSalesMap.values()){
            TotalSales+= netSales;
        }
        system.debug('cropSalesMap'+cropSalesMap);
        system.debug('TotalSales'+TotalSales);
        for(String cropMap :cropSalesMap.keySet()){
            system.debug('cropSalesMap'+cropSalesMap.get(cropMap));
            
            cropSales = Integer.valueOf(((cropSalesMap.get(cropMap))*100 / TotalSales));
            system.debug('cropSales'+cropSales);
            accSalesWrap.cropPercentage.put(cropMap,cropSales);
        }
        system.debug('accSalesWrap.cropPercentage'+accSalesWrap.cropPercentage);
        system.debug('accSalesWrap' +accSalesWrap);
        return JSON.serialize(accSalesWrap);
    }
 
    @AuraEnabled    
    public static String GrowerSalesDetails(String growerAccId,String UOM){
        List<Territory2> territoryList = new List<Territory2>();
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>();
        List<Account_Farming_Area__c> accFarmingList = new List<Account_Farming_Area__c>();
        Map<String,Integer> cropSalesMap = new Map<String,Integer>();
        
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                             UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
            territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
                             Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }
        system.debug('territoryList'+territoryList);
        
        accSalesList=[Select Id,Name,Account_SFID__c,Brand_Name__c,Crop__c,Net_Sales_Qty__c,Opportunity__c,Year__c,Business_Unit_Descr__c,Account_Business_Role_SFID__r.Role_Descr__c From Account_Sales__c where Account_SFID__c=:growerAccId AND Unit_Of_Measure__c=:UOM AND Account_Business_Role_SFID__r.Role_Descr__c='Customer'] ;
        accFarmingList = [Select Id,Name,Account_SFID__c,Area_Opportunity__c,Parent_SFID__c,Year__c,Area_Usage_Descr__c FROM Account_Farming_Area__c WHERE Account_SFID__c=:growerAccId AND Parent_SFID__c != null];  
        List<AccountSalesWrapper> accSalesWrapList = new List<AccountSalesWrapper>();
        AccountSalesWrapper accSalesWrap = new AccountSalesWrapper();
        system.debug('accSalesList++++++' +accSalesList);
        if(!territoryList.isEmpty()){
            accSalesWrap.salesRepBrand = territoryList[0].Division__c;
        }
        Integer TotalNetSales = 0;
        if(!accFarmingList.isEmpty()){
            //Get Opportunity from Account Farming, put 'Year +Crop' and Opportunity to Map 
            for(Account_Farming_Area__c accFarming : accFarmingList){
                 accSalesWrap.CropValues.add(accFarming.Area_Usage_Descr__c);
                accSalesWrap.accFarmingMap.put((accFarming.Year__c +'-'+accFarming.Area_Usage_Descr__c),Integer.valueOf(accFarming.Area_Opportunity__c));
           
            }              
        }
        system.debug('Account Farming' + accSalesWrap.accFarmingMap);
        for(Account_Sales__c accSales : accSalesList){
            salesYearWrapper salesYear = new salesYearWrapper();
            salesWrapper salesrecord = new salesWrapper();  
            
            if(accSales.Crop__c != null){
            accSalesWrap.CropValues.add(accSales.Crop__c);

                if(accSalesWrap.cropMap.containskey(accSales.Crop__c)){
                    salesYear =  accSalesWrap.cropMap.get(accSales.Crop__c);
                    
                }
                
               if(accSales.Business_Unit_Descr__c != null){ 
                if(accSales.Year__c == '2017'){
                    if(salesYear.CY.containsKey(accSales.Business_Unit_Descr__c)){
                        salesrecord = salesYear.CY.get(accSales.Business_Unit_Descr__c);
                        salesrecord.netSalesCY = (Integer.valueOf((salesrecord.netSalesCY)) + (Integer.valueOf(accSales.Net_Sales_Qty__c)));
                    }
                    else{
                        salesrecord.netSalesCY=(accSales.Net_Sales_Qty__c != null ? (Integer.valueOf(accSales.Net_Sales_Qty__c)):0);
                        
                    }
                    
                    salesYear.CY.put(accSales.Business_Unit_Descr__c,salesrecord);
                    system.debug('salesYear' +salesYear.CY);
                    if(accSales.Business_Unit_Descr__c == accSalesWrap.salesRepBrand){
                        if(cropSalesMap.containsKey(accSales.Crop__c)){
                            TotalNetSales +=  (cropSalesMap.get(accSales.Crop__c));
                            cropSalesMap.put(accSales.Crop__c,TotalNetSales); 
                        }
                        else{
                            cropSalesMap.put(accSales.Crop__c,Integer.valueOf(accSales.Net_Sales_Qty__c)); 
                        }
                        
                    }
                    
                }
                  
                if(accSales.Year__c == '2016'){
                    if(salesYear.PY.containsKey(accSales.Business_Unit_Descr__c)){
                        salesrecord = salesYear.PY.get(accSales.Business_Unit_Descr__c);
                        salesrecord.netSalesPY = (Integer.valueOf((salesrecord.netSalesPY)) + (Integer.valueOf(accSales.Net_Sales_Qty__c)));
                    }
                    else{
                        salesrecord.netSalesPY=(accSales.Net_Sales_Qty__c != null ? (Integer.valueOf(accSales.Net_Sales_Qty__c)):0);
                       
                        
                    }
                    salesYear.PY.put(accSales.Business_Unit_Descr__c,salesrecord);  
                    
                    
                }
                   
                if(accSales.Year__c == '2015'){
                    if(salesYear.twoPY.containsKey(accSales.Business_Unit_Descr__c)){
                        salesrecord = salesYear.twoPY.get(accSales.Business_Unit_Descr__c);
                        salesrecord.netSalestwoPY = (Integer.valueOf((salesrecord.netSalestwoPY)) + (Integer.valueOf(accSales.Net_Sales_Qty__c)));
                    }
                    else{
                        salesrecord.netSalestwoPY=(accSales.Net_Sales_Qty__c != null ? (Integer.valueOf(accSales.Net_Sales_Qty__c)):0);
                       
                        
                    }
                    salesYear.twoPY.put(accSales.Business_Unit_Descr__c,salesrecord);                    
                }
                   
               }
                accSalesWrap.cropMap.put(accSales.Crop__c,salesYear);
                
      
                //accSalesWrapList.add(accSalesWrap) ; 
            }
        }
        system.debug('Crop Values' +accSalesWrap.CropValues);
        Integer TotalSales = 0;
        Integer cropSales;
        for(Integer netSales : cropSalesMap.values()){
            TotalSales+= netSales;
        }
        system.debug('cropSalesMap'+cropSalesMap);
        system.debug('TotalSales'+TotalSales);
        for(String cropMap :cropSalesMap.keySet()){
            system.debug('cropSalesMap'+cropSalesMap.get(cropMap));
            
            cropSales = Integer.valueOf(((cropSalesMap.get(cropMap))*100 / TotalSales));
            system.debug('cropSales'+cropSales);
            accSalesWrap.cropPercentage.put(cropMap,cropSales);
        }
        system.debug('accSalesWrap.cropPercentage'+accSalesWrap.cropPercentage);
        system.debug('accSalesWrap' +accSalesWrap);
        return JSON.serialize(accSalesWrap);
    }
    
    public class GrowerAccountDataWrapper{
        public List<String> Labels {get;set;}
        
        public List<String> growerSeason{get;set;}
        
        public Integer growerAccountTotalArea{get;set;}
        public List<Integer> growerAccountCroparea{get;set;}
        public Integer growerTotalArea{get;set;}
        public List<String> growerbrand {get;set;}
        public List<String> growerFamily {get;set;}
        public List<String> areaMonShare {get;set;}
        public Integer othersShare {get;set;}
        public Integer othersArea {get;set;}   
        public List<Integer> chartdata {get;set;}
        
        public List<String> buttonValue {get;set;}
        public  Map<String,Decimal> SalesYearMap{get;set;}
        public  Map<String,Decimal> OrderYearMap{get;set;}
        public GrowerAccountDataWrapper(){
            
            Labels = new List<String>();
            growerSeason=new List<String>();
            growerbrand = new List<String>();
            growerFamily = new List<String>();
            chartdata = new List<Integer>();
            areaMonShare = new List<String>();
            buttonValue =new List<String>();
            growerAccountCroparea=new List<Integer>();
            SalesYearMap=new Map<String,Decimal>();
            OrderYearMap=new Map<String,Decimal>();
        }
    }
    public class AccountSalesWrapper{
        public Map<String,salesYearWrapper> cropMap{get;set;}
        public Map<String,Integer> accFarmingMap{get;set;} 
        public Set<String> CropValues{get;set;}
        public String salesRepBrand{get;set;}
        public Map<String,Integer> cropPercentage{get;set;}
        public AccountSalesWrapper(){
            cropMap= new Map<String,salesYearWrapper>();
            accFarmingMap = new Map<String,Integer>();
            cropPercentage = new Map<String,Integer>();
            CropValues = new Set<String>();
        }
    }
    public class salesYearWrapper{
        public Map<String,salesWrapper> twoPY{get;set;}
        public Map<String,salesWrapper> PY{get;set;}
        public Map<String,salesWrapper> CY{get;set;}
        public salesYearWrapper(){
            twoPY = new Map<String,salesWrapper>();
            PY = new Map<String,salesWrapper>();
            CY = new Map<String,salesWrapper>();            
        }
    }
    public class salesWrapper{
        public Integer netSalesPY{get;set;}
        public Integer OpportunityPY{get;set;}
        public Integer netSalestwoPY{get;set;}
        public Integer OpportunitytwoPY{get;set;}
        public Integer netSalesCY{get;set;}
        public Integer OpportunityCY{get;set;}
    }
    
}