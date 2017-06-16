Public class Frontier_ManagerDashboard {
    
    public static Boolean isManager;
    
    public static Map<String,RadlCoverageWrapper> radlCoverageMap;
    public static Map<String,Integer> aggregateCount;
    public static Map<String,Integer> aggregateCurrentSalesMap;
    public static Map<String,Integer> aggregateCurrentSalesRadlMap;
    public static Map<String,Integer> aggregateNetSalesGrowerOpptyMap;
    public static Map<String,Integer> aggregateNetSalesDealerOpptyMap;
    public static Map<String,Integer> accountSalesRadlMap;
    public static Map<String,Integer> accountSalesMap;
    public static Map<String,Integer> dealerOpptyMap;
    public static Map<String,Integer> growerOpptyMap;
    public static Map<Id,Id> plannedProgramMap;
    public static Map<Id,Id> plannedAvgProgramMap;
    public static Set<Id> growerAccountIds;
    public static Set<Id> dealerAccountIds;
    public static Set<Id> territoryAccountIds;
    public static String radlCount;


    public static Set<String> radlSet;
    public static Set<Id> managersSalesRepIdSet; //userId Set
    public static Set<Id> accountIds;
    public static List<String> crops;
    public static List<String> seasons;
    public static List<Territory2> saleRepList;
    
     Static {      
        radlSet = new Set<String>();
        accountIds = new Set<Id>();
        seasons = new List<String>();
        crops = new List<String>();
        saleRepList = new List<Territory2>();
        
        Schema.DescribeFieldResult fieldResult =  Account_Business_Role__c.Service_Level_Class_Descr__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple){
            radlSet.add(f.getValue());
        }
        ple.clear();
        fieldResult =  Account_Sales__c.Selling_Season_Descr__c.getDescribe();
        ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple){
            seasons.add(f.getValue());
        }
        ple.clear();
        fieldResult =  Account_Sales__c.Crop__c.getDescribe();
        ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple){
            crops.add(f.getValue());
        }
       
        /*for(User usr : [SELECT Id,Name FROM User WHERE ManagerId = :UserInfo.getUserId()]){
                saleRepList.add(usr); //Adding All SalesRep User Object to populate salesrep list 
        }*/
        String currenUserName = '%'+UserInfo.getName()+'%';
        List<UserTerritory2Association > userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM UserTerritory2Association WHERE UserId= :UserInfo.getUserId() AND Territory2.Name like :currenUserName  ];
        
        //Getting all child Territory Ids
        if(!userTerritoryList.isEmpty()){
            for(Territory2 territory : [SELECT Id, Name, DeveloperName, Division__c FROM Territory2 WHERE ParentTerritory2Id = :userTerritoryList[0].Territory2Id]){
                saleRepList.add(territory); //Adding All SalesRep User Object to populate salesrep list 
            }
        
        }
    }
    
    @AuraEnabled
    
    public static List<String> getManagerDashboardData(String selectedOrAllSalesRep,String crop,String season) {
    
        managersSalesRepIdSet = new Set<Id>();
        radlCoverageMap = new Map<String,RadlCoverageWrapper>(); 
        Set<Id> allterritoryIdSet = new Set<Id>();

        String currenUserName = '%'+UserInfo.getName()+'%';
        radlCoverageMap.put('Partner',new RadlCoverageWrapper());
        radlCoverageMap.put('Customer',new RadlCoverageWrapper());
        radlCoverageMap.put('AllAccountsWithProgram',new RadlCoverageWrapper());

        
        List<Territory2> territory2CurrentUserManagerRealatedSalesrepTerritoryList ;
        //List<Territory2> territory2CurrentUserManagerTerritoryList = [SELECT Id, Name, DeveloperName, Division__c FROM Territory2 WHERE Name like :currenUserName ];
        List<UserTerritory2Association > userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM UserTerritory2Association WHERE UserId= :UserInfo.getUserId() AND Territory2.Name like :currenUserName  ];
        
        //Getting all child Territory Ids
        if(!userTerritoryList.isEmpty()){
            //if(territory2CurrentUserManagerTerritoryList[0].id == userTerritoryList[0].Territory2Id){ 
                allterritoryIdSet.add(userTerritoryList[0].Territory2Id);
                for(Territory2 territory : [SELECT Id, Name, DeveloperName, Division__c FROM Territory2 WHERE ParentTerritory2Id = :userTerritoryList[0].Territory2Id]){
                    allterritoryIdSet.add(territory.Id);
                } 
            //}
        }
        if(!allterritoryIdSet.isEmpty()){
            isManager = true;
            if(selectedOrAllSalesRep == 'All'){
                for(UserTerritory2Association usr : [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM UserTerritory2Association WHERE Territory2Id IN :allterritoryIdSet]){
                    managersSalesRepIdSet.add(usr.UserId); //Adding All SalesRep User Id 
                }
            
            }else{
                for(UserTerritory2Association usr : [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM UserTerritory2Association WHERE Territory2Id = :selectedOrAllSalesRep ]){
                    managersSalesRepIdSet.add(usr.UserId); //Adding All SalesRep User Id 
                }

                //managersSalesRepIdSet.add(selectedOrAllSalesRep); // Adding Selected Salesrep User Id
            
            }
        }else{
            isManager = false;
            managersSalesRepIdSet.add(UserInfo.getUserId());//Adding Current Login SalesRep Id
        }
        
        system.debug('managersSalesRepIdSet=>'+managersSalesRepIdSet);
        
        accountIds = Util.getTerritoryAccountIdsForMultipleUsers(managersSalesRepIdSet);
        system.debug('accountIds =>'+accountIds );
        accountSalesMap = new Map<String,Integer>();
        accountSalesRadlMap = new Map<String,Integer>();
        dealerOpptyMap = new Map<String,Integer>();
        growerOpptyMap = new Map<String,Integer>();
        territoryAccountIds = new Set<Id>();

        
        System.debug('Sales Rep Territory Accounts'+accountIds.size());
        if(!accountIds.isEmpty()){
            aggregateCount = new Map<String,Integer>();
            aggregateCurrentSalesMap = new Map<String,Integer>();
            aggregateCurrentSalesRadlMap = new Map<String,Integer>();
            aggregateNetSalesGrowerOpptyMap = new Map<String,Integer>();
            aggregateNetSalesDealerOpptyMap = new Map<String,Integer>();
            String cropVar = (crop == 'null' || crop == null ? 'Corn' : crop);
            String seasonVar = (season == 'null' || season == null ? 'SUMMER' : season);
            system.debug(cropVar+seasonVar);
            getAccountSales(cropVar,seasonVar,accountIds);
            getFarmingArea(cropVar,seasonVar,accountIds);
            territoryAccountIds.addAll(accountIds);
            // Find the Radl count for the accounts
            for(Account_Business_Role__c accBusinessRole : [SELECT Account_SFID__c,Service_Level_Class_Descr__c,Role_Descr__c,Business_Unit_Descr__c,
                                                            Account_SFID__r.Account_Global_Party_ID__c FROM  Account_Business_Role__c WHERE 
                                                            Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c ='N' AND 
                                                            Account_SFID__r.Archive_Ind__c = 'N' AND Account_SFID__c IN:accountIds]){
                                                                getRadlCount(accBusinessRole,'TerritoryAccounts'); 
                                                            }
            //Find the average rate for the radl
            RadlBasedPercentageCalculation();
            RadlBasedProgramManipulation(cropVar,seasonVar);
            RadlBasedPlannedProgramManipulation(cropVar,seasonVar); 
            system.debug('AccountIds size-----'+accountIds.size());
        }
    // }  
        List<String> accountSales = new List<String>();
        accountSales.add(JSON.serialize(seasons));
        accountSales.add(JSON.serialize(Crops));
        accountSales.add(JSON.serialize(radlCoverageMap));
        accountSales.add(JSON.serialize(saleRepList));
        accountSales.add(JSON.serialize(isManager));
        return accountSales;

    }
    
       // Radl coverage for Dealers and Growers
   /* @AuraEnabled
    public static List<String> RadlBasedCoverageManipulation(String crop,String season){
        system.debug('Crop--------'+crop+'Season--------'+season);
        
        accountIds = new Set<Id>(); 
        // Get all the accounts that belongs to Sales Rep Territory
        accountIds = Util.getTerritoryAccountIds();  
        accountSalesMap = new Map<String,Integer>();
        dealerOpptyMap = new Map<String,Integer>();
        growerOpptyMap = new Map<String,Integer>();
        
        System.debug('Sales Rep Territory Accounts'+accountIds.size());
        if(!accountIds.isEmpty()){
            aggregateCount = new Map<String,Integer>();
            aggregateCurrentSalesMap = new Map<String,Integer>();
            aggregateNetSalesGrowerOpptyMap = new Map<String,Integer>();
            aggregateNetSalesDealerOpptyMap = new Map<String,Integer>();
            radlCoverageMap = new Map<String,RadlCoverageWrapper>(); 
            String cropVar = (crop == 'null' || crop == null ? 'Corn' : crop);
            String seasonVar = (season == 'null' || season == null ? 'SUMMER' : season);
            system.debug(cropVar+seasonVar);
            getAccountSales(cropVar,seasonVar);
            getFarmingArea(cropVar,seasonVar);
            system.debug('AccountIds size-----'+accountIds.size());
            // Find the Radl count for the accounts
            for(Account_Business_Role__c accBusinessRole : [SELECT Account_SFID__c,Service_Level_Class_Descr__c,Role_Descr__c,Business_Unit_Descr__c,
                                                            Account_SFID__r.Account_Global_Party_ID__c FROM  Account_Business_Role__c WHERE 
                                                            Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c ='N' AND 
                                                            Account_SFID__r.Archive_Ind__c = 'N' AND Account_SFID__c IN:accountIds]){
                                                                getRadlCount(accBusinessRole,'TerritoryAccounts'); 
                                                            }
            //Find the average rate for the radl
            RadlBasedPercentageCalculation();
            RadlBasedProgramManipulation(cropVar,seasonVar);
            RadlBasedPlannedProgramManipulation();
        }
        List<String> accountSales = new List<String>();
        accountSales.add(JSON.serialize(seasons));
        accountSales.add(JSON.serialize(Crops));
        accountSales.add(JSON.serialize(radlCoverageMap));
        return accountSales;
    } */
    
      public static void RadlBasedProgramManipulation(String crop,String season){
        plannedProgramMap = new Map<Id,Id>();
        plannedAvgProgramMap = new Map<Id,Id>();
        clearCollectionData();
        dealerAccountIds.clear();
        growerAccountIds.clear();
        accountIds.clear();
        
        if(!territoryAccountIds.isEmpty()){
            for(Account_Program__c accPgm : [SELECT Id,Planning_Status__c,Account_SFID__c,Program_SFID__c FROM Account_Program__c WHERE Account_SFID__c IN :territoryAccountIds]){
                accountIds.add(accPgm.Account_SFID__c);
                if(accPgm.Planning_Status__c == 'Planned'){
                    plannedProgramMap.put(accPgm.Account_SFID__c,accPgm.Program_SFID__c);
                }
                plannedAvgProgramMap.put(accPgm.Account_SFID__c,accPgm.Program_SFID__c);
            }
        }
        getAccountSales(crop,season,accountIds);
        getFarmingArea(crop,season,accountIds);
        
        if(!dealerAccountIds.isEmpty()){
            accountIds.retainAll(dealerAccountIds);
        }
        if(!growerAccountIds.isEmpty()){
            if(dealerAccountIds.isEmpty())
                accountIds.retainAll(growerAccountIds);
            else 
                accountIds.addAll(growerAccountIds);
        }
        system.debug('accountIds-----------------------------'+accountIds.size());
        if(!accountIds.isEmpty()){
            for(Account_Business_Role__c accBusinessRole : [SELECT Account_SFID__c,Service_Level_Class_Descr__c,Role_Descr__c,Business_Unit_Descr__c,
                                                            Account_SFID__r.Account_Global_Party_ID__c FROM  Account_Business_Role__c WHERE 
                                                            Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c ='N' AND 
                                                            Account_SFID__r.Archive_Ind__c = 'N' AND Account_SFID__c IN:accountIds]){
                                                                getRadlCount(accBusinessRole,'AllAccountsWithProgram'); 
                                                            }
            RadlBasedPercentageCalculation();
        }
    }
    
    public static void RadlBasedPlannedProgramManipulation(String crop,String season){
        clearCollectionData();
        Map<String,Integer> netPlannedPrograms = new Map<String,Integer>();
        Map<String,Integer> netAvgPlannedPrograms = new Map<String,Integer>();
        Set<Id> avgProgramIds = new Set<Id>();
        Set<Id> programIds = new Set<Id>();
        String Type = 'AllAccountsWithProgram';
        System.debug('All Accounts With Program---------------'+accountIds.size());    
        for(Account_Business_Role__c accountBusinessRole : [SELECT Account_SFID__c,Service_Level_Class_Descr__c,Role_Descr__c,Business_Unit_Descr__c,
                                                            Account_SFID__r.Account_Global_Party_ID__c FROM  Account_Business_Role__c WHERE 
                                                            Account_SFID__r.Account_Global_Party_ID__c != null AND Archive_Ind__c ='N' AND 
                                                            Account_SFID__r.Archive_Ind__c = 'N' AND Account_SFID__c IN:accountIds]){  
           if(radlCoverageMap.isEmpty() || (!radlCoverageMap.isEmpty() && !radlCoverageMap.containsKey(Type))){
               radlCoverageMap.put(Type,new RadlCoverageWrapper());
               //System.debug('radlCoverageMap==>'+radlCoverageMap);    
           } 
          System.debug('radlCoverageMap==>'+radlCoverageMap.containskey(Type));    
 
           if(Type == 'AllAccountsWithProgram' && ((!growerAccountIds.isEmpty() && growerAccountIds.contains(accountBusinessRole.Account_SFID__c))
                                                   || (!dealerAccountIds.isEmpty() && dealerAccountIds.contains(accountBusinessRole.Account_SFID__c)))){

           if(!plannedProgramMap.isEmpty() && plannedProgramMap.containsKey(accountBusinessRole.Account_SFID__c)){
              // if(programIds.isEmpty() || !programIds.contains(plannedProgramMap.get(accountBusinessRole.Account_SFID__c))){
                  //  programIds.add(plannedProgramMap.get(accountBusinessRole.Account_SFID__c));
                    radlCount = String.valueOf(Integer.valueof(radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.get(accountBusinessRole.Service_Level_Class_Descr__c)) + 1);
                    //netPlannedPrograms.add(plannedProgramMap.get(accountBusinessRole.Account_SFID__c));
                    netPlannedPrograms.put('PlannedProgram',(netPlannedPrograms.isEmpty() ? 1 : (!netPlannedPrograms.isEmpty() && netPlannedPrograms.containsKey('PlannedProgram') ? netPlannedPrograms.get('PlannedProgram')+1 : 1)));   
                    radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);
               // }
            }
            if(!plannedAvgProgramMap.isEmpty() && plannedAvgProgramMap.containsKey(accountBusinessRole.Account_SFID__c)){
                //if(avgProgramIds.isEmpty() || !avgProgramIds.contains(plannedAvgProgramMap.get(accountBusinessRole.Account_SFID__c))){
                    //avgProgramIds.add(plannedAvgProgramMap.get(accountBusinessRole.Account_SFID__c));
                    radlCount = String.valueOf(Integer.valueof(radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.get(accountBusinessRole.Service_Level_Class_Descr__c)) + 1);
                    //netAvgPlannedPrograms.add(plannedAvgProgramMap.get(accountBusinessRole.Account_SFID__c));
                   // netAvgPlannedPrograms.add(accountBusinessRole.Account_SFID__c);
                     netAvgPlannedPrograms.put('PlannedAvgProgram',(netAvgPlannedPrograms.isEmpty() ? 1 : (!netAvgPlannedPrograms.isEmpty() && netAvgPlannedPrograms.containsKey('PlannedAvgProgram') ? netAvgPlannedPrograms.get('PlannedAvgProgram')+1 : 1)));   

                    radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);
                // }
             }
      } 
     }
      if(radlCoverageMap.containskey(Type) && !radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.isEmpty()){
         for(String radlType :  radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.keyset()){
            if(!radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.get(radlType).contains(':')){
               integer radlCount = Integer.valueOf(radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.get(radlType));
               if(radlCount > 0 && netPlannedPrograms.size() > 0){
                  radlCoverageMap.get(Type).plannedProgramAllocatedAccountMap.put(radlType,String.valueOf(radlCount)+':'+String.valueOf((((radlCount)/Decimal.valueof((netPlannedPrograms.get('PlannedProgram'))))*100).setScale(2))+'%');
               }
            }
            }
        }
  
        if(radlCoverageMap.containskey(Type) && !radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.isEmpty()){
            for(String radlType :  radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.keyset()){
                if(!radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.get(radlType).contains(':')){
                    Integer radlCount = Integer.valueOf(radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.get(radlType));
                    if(radlCount > 0 && netAvgPlannedPrograms.size() > 0){
                        radlCoverageMap.get(Type).plannedProgramAllocatedAvgMap.put(radlType,String.valueOf((((radlCount)/Decimal.valueof((netAvgPlannedPrograms.get('PlannedAvgProgram')))).setScale(2)))+':'+String.valueOf((((radlCount)/Decimal.valueof((netAvgPlannedPrograms.get('PlannedAvgProgram'))))*100).setScale(2))+'%');
                    }
                }
            }
        }
    }
    
    public static void getRadlCount(Account_Business_Role__c accountBusinessRole,String Type){   
        Type = (Type == 'TerritoryAccounts'? accountBusinessRole.Role_Descr__c : Type);
        if(radlCoverageMap.isEmpty() || (!radlCoverageMap.isEmpty() && !radlCoverageMap.containsKey(Type))){
            radlCoverageMap.put(Type,new RadlCoverageWrapper());
        }
         if(Type == 'AllAccountsWithProgram' && !territoryAccountIds.isEmpty() && territoryAccountIds.contains(accountBusinessRole.Account_SFID__c)) {
            System.debug('territoryAccountIdsterritoryAccountIds----------'+accountBusinessRole.Account_SFID__c);
            System.debug('No Programmmmmmmmmmmmmmm Existss');
            radlCoverageMap.get(Type).totalCoverageMap.put('No Program',String.valueOf(Integer.valueof(radlCoverageMap.get(Type).totalCoverageMap.get('No Program')) + 1));
            aggregateCount.put(Type,(aggregateCount.containsKey(Type) ? (aggregateCount.get(Type) + 1) : 1));
    
         }
        
        if(radlCoverageMap.containsKey(Type)){
            // Aggregate count for the accounts
            if((Type == 'Customer' ? (!growerAccountIds.isEmpty() && growerAccountIds.contains(accountBusinessRole.Account_SFID__c)) : (!dealerAccountIds.isEmpty() && dealerAccountIds.contains(accountBusinessRole.Account_SFID__c)))){
                aggregateCount.put(Type,(aggregateCount.containsKey(Type) ? (aggregateCount.get(Type) + 1) : 1));
                // Aggregate count for the accounts with respect to the Radl
                radlCount = String.valueOf(Integer.valueof(radlCoverageMap.get(Type).totalCoverageMap.get(accountBusinessRole.Service_Level_Class_Descr__c)) + 1);
                radlCoverageMap.get(Type).totalCoverageMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);    
                // Aggregate count for the account to obtain the dealer's growth potential and the net sales for the accounts
                if(!accountSalesMap.isEmpty() && accountSalesMap.containsKey(accountBusinessRole.Account_SFID__c)){
                    aggregateCurrentSalesMap.put(Type,(aggregateCurrentSalesMap.containsKey(Type) ? (aggregateCurrentSalesMap.get(Type) + 1) : 1));
                    if(!radlCoverageMap.get(Type).netCurrentSalesperRadl.containskey(accountBusinessRole.Service_Level_Class_Descr__c)){
                        radlCoverageMap.get(Type).netCurrentSalesperRadl.put(accountBusinessRole.Service_Level_Class_Descr__c,1);
                    }
                    else{
                        radlCoverageMap.get(Type).netCurrentSalesperRadl.put(accountBusinessRole.Service_Level_Class_Descr__c, radlCoverageMap.get(Type).netCurrentSalesperRadl.get(accountBusinessRole.Service_Level_Class_Descr__c) + 1);
                    }
                     if(Type == 'AllAccountsWithProgram' && !accountSalesRadlMap.isEmpty() && accountSalesRadlMap.containsKey(accountBusinessRole.Account_SFID__c)){
                      aggregateCurrentSalesRadlMap.put(Type,(aggregateCurrentSalesRadlMap.containsKey(Type) ? (aggregateCurrentSalesRadlMap.get(Type) + 1) : 1));
                        if(!radlCoverageMap.get(Type).netRadlCoverage.containskey(accountBusinessRole.Service_Level_Class_Descr__c)){
                          radlCoverageMap.get(Type).netRadlCoverage.put(accountBusinessRole.Service_Level_Class_Descr__c,1);
                        }
                        else{
                            radlCoverageMap.get(Type).netRadlCoverage.put(accountBusinessRole.Service_Level_Class_Descr__c, radlCoverageMap.get(Type).netRadlCoverage.get(accountBusinessRole.Service_Level_Class_Descr__c) + 1);
                        }
                        radlCount = String.valueOf(Integer.valueof(radlCoverageMap.get(Type).radlCoverageSalesMap.get(accountBusinessRole.Service_Level_Class_Descr__c)) + accountSalesRadlMap.get(accountBusinessRole.Account_SFID__c));
                      radlCoverageMap.get(Type).radlCoverageSalesMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);
                     }
                    
                    radlCount = String.valueOf(Integer.valueof(radlCoverageMap.get(Type).currentSalesMap.get(accountBusinessRole.Service_Level_Class_Descr__c)) + accountSalesMap.get(accountBusinessRole.Account_SFID__c));
                    radlCoverageMap.get(Type).currentSalesMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);
                    
                    
                }
                // Aggregate count for the grower's and dealer's growth potential with respect to Radl          
                radlCount = radlCoverageMap.get(Type).growthPotentialMap.get(accountBusinessRole.Service_Level_Class_Descr__c);
                
                if(growerOpptyMap.containsKey(accountBusinessRole.Account_SFID__c)){
                    aggregateNetSalesGrowerOpptyMap.put(Type,aggregateNetSalesGrowerOpptyMap.containsKey(Type) ? (aggregateNetSalesGrowerOpptyMap.get(Type) + 1) : 1);
                    if(radlCoverageMap.get(Type).netGrowerOpptySales.containsKey(accountBusinessRole.Service_Level_Class_Descr__c)){
                        radlCoverageMap.get(Type).netGrowerOpptySales.put(accountBusinessRole.Service_Level_Class_Descr__c,1);
                    }
                    else{
                        radlCoverageMap.get(Type).netGrowerOpptySales.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCoverageMap.get(Type).netGrowerOpptySales.get(accountBusinessRole.Service_Level_Class_Descr__c) + 1);
                    }
                    radlCount = String.valueOf(Integer.valueof(radlCount) + growerOpptyMap.get(accountBusinessRole.Account_SFID__c));
                    radlCoverageMap.get(Type).growthPotentialMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);
                }
                if(dealerOpptyMap.containsKey(accountBusinessRole.Account_SFID__c)){
                    aggregateNetSalesDealerOpptyMap.put(Type,aggregateNetSalesDealerOpptyMap.containsKey(Type) ? (aggregateNetSalesDealerOpptyMap.get(Type) + 1) : 1);
                    if(radlCoverageMap.get(Type).netDealerOpptySales.containsKey(accountBusinessRole.Service_Level_Class_Descr__c)){
                        radlCoverageMap.get(Type).netDealerOpptySales.put(accountBusinessRole.Service_Level_Class_Descr__c,1);
                    }
                    else{
                        radlCoverageMap.get(Type).netDealerOpptySales.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCoverageMap.get(Type).netDealerOpptySales.get(accountBusinessRole.Service_Level_Class_Descr__c) + 1);
                    }
                    radlCount = String.valueOf(Integer.valueof(radlCount) + dealerOpptyMap.get(accountBusinessRole.Account_SFID__c));
                    radlCoverageMap.get(Type).growthPotentialMap.put(accountBusinessRole.Service_Level_Class_Descr__c,radlCount);                
                }
            }
        }
    }
    
    public static void RadlBasedPercentageCalculation(){
        if(!radlCoverageMap.isEmpty()){
            for(String CoverageType : radlCoverageMap.keyset()){
                system.debug('CoverageType'+CoverageType);
                // To calculate the avg rate in percentage for the accounts with respect to Radl
                if(!radlCoverageMap.get(CoverageType).totalCoverageMap.isEmpty()){
                    for(String radlType : radlCoverageMap.get(CoverageType).totalCoverageMap.keyset()){
                        if(!radlCoverageMap.get(CoverageType).totalCoverageMap.get(radlType).contains(':')){
                            Decimal radlCount = Integer.valueOf(radlCoverageMap.get(CoverageType).totalCoverageMap.get(radlType));
                            if(aggregateCount.containsKey(CoverageType) && radlCount > 0){
                                radlCoverageMap.get(CoverageType).totalCoverageMap.put(radlType,String.valueOf(radlCount)+':'+String.valueOf((((radlCount)/Decimal.valueof(aggregateCount.get(CoverageType)))*100).setScale(2))+'%');
                            }
                        }
                    }
                }
                // To calculate the avg net sales in percentage for the accounts with respect to Radl
                if(!radlCoverageMap.get(CoverageType).currentSalesMap.isEmpty()){
                    for(String radlType : radlCoverageMap.get(CoverageType).currentSalesMap.keyset()){
                        if(!radlCoverageMap.get(CoverageType).currentSalesMap.get(radlType).contains(':')){
                            Decimal radlCount = Integer.valueOf(radlCoverageMap.get(CoverageType).currentSalesMap.get(radlType));
                            Integer aggregateSalesPerRadl = radlCoverageMap.get(CoverageType).netCurrentSalesperRadl.get(radlType);
                            if(!aggregateCurrentSalesMap.isEmpty() && aggregateSalesPerRadl > 0){
                                radlCoverageMap.get(CoverageType).currentSalesMap.put(radlType,String.valueOf(radlCount)+':'+String.valueOf((((aggregateSalesPerRadl)/Decimal.valueof(aggregateCurrentSalesMap.get(CoverageType)))*100).setScale(2))+'%');
                            }
                        }
                    }
                }
                // To calculate the avg net sales for Radl coverage in percentage for the accounts with respect to Radl
                if(!radlCoverageMap.get(CoverageType).radlCoverageSalesMap.isEmpty()){
                    for(String radlType : radlCoverageMap.get(CoverageType).radlCoverageSalesMap.keyset()){
                        if(!radlCoverageMap.get(CoverageType).radlCoverageSalesMap.get(radlType).contains(':')){
                            Decimal radlCount = Integer.valueOf(radlCoverageMap.get(CoverageType).radlCoverageSalesMap.get(radlType));
                            Integer aggregateSalesPerRadl = radlCoverageMap.get(CoverageType).netRadlCoverage.get(radlType);
                            if(!aggregateCurrentSalesRadlMap.isEmpty() && aggregateSalesPerRadl > 0){
                                radlCoverageMap.get(CoverageType).radlCoverageSalesMap.put(radlType,String.valueOf(radlCount)+':'+String.valueOf((((aggregateSalesPerRadl)/Decimal.valueof(aggregateCurrentSalesRadlMap.get(CoverageType)))*100).setScale(2))+'%');
                            }
                        }
                    }
                }
                
                // To calculate the average growth potential for the accounts with respect to Radl
                if(!radlCoverageMap.get(CoverageType).growthPotentialMap.isEmpty()){
                    Integer count  = 0;
                    Integer aggregateRadl = 0;
                    Boolean isDealer = false;
                    if(!aggregateNetSalesDealerOpptyMap.isEmpty() && aggregateNetSalesDealerOpptyMap.containsKey(CoverageType)){
                        count = aggregateNetSalesDealerOpptyMap.get(CoverageType);
                        isDealer =  true;
                    }
                    else if(!aggregateNetSalesGrowerOpptyMap.isEmpty() && aggregateNetSalesGrowerOpptyMap.containsKey(CoverageType)){
                        count = aggregateNetSalesGrowerOpptyMap.get(CoverageType);
                        isDealer =  false;
                    }
                    
                    for(String radlType : radlCoverageMap.get(CoverageType).growthPotentialMap.keyset()){
                        if(!radlCoverageMap.get(CoverageType).growthPotentialMap.get(radlType).contains(':')){
                            aggregateRadl = (isDealer ? radlCoverageMap.get(CoverageType).netDealerOpptySales.get(radlType) : radlCoverageMap.get(CoverageType).netGrowerOpptySales.get(radlType));
                            Decimal radlCount = Integer.valueOf(radlCoverageMap.get(CoverageType).growthPotentialMap.get(radlType));    
                            if(radlCount > 0 && count > 0){
                                radlCoverageMap.get(CoverageType).growthPotentialMap.put(radlType,String.valueOf(radlCount)+':'+String.valueOf((((aggregateRadl)/Decimal.valueof(count))*100).setScale(2))+'%');
                            }
                        }
                    }
                }
            }
            system.debug('radlCoverageMap-------'+radlCoverageMap);
        }
    }
    
    public static void getAccountSales(String crop,String season,Set<Id> accountIds){
        dealerAccountIds = new Set<Id>();
        Set<Id> accountTouchPointIds = new Set<Id>();
        for(TouchPoint__c touchPoint : [SELECT Id,Account_SFID__c FROM TouchPoint__c WHERE Account_SFID__c IN:accountIds AND TouchPointTypes__c = '1:1 Visit']){
            accountTouchPointIds.add(touchPoint.Account_SFID__c);
        }
        // To get the aggregate growth potential and the net sales for the account
        for(Account_Sales__c accountSales : [SELECT Id,Account_SFID__c,Net_Sales_Qty__c,Opportunity__c FROM Account_Sales__c  
                                             WHERE Account_SFID__c IN:accountIds AND Selling_Season_Descr__c =:season AND Crop__c =:crop]){
               Integer netSales = (accountSales.Net_Sales_Qty__c == null ? 0 : Integer.valueOf(accountSales.Net_Sales_Qty__c));
               Integer netOpportunitySales = (accountSales.Opportunity__c == null ? 0 : Integer.valueOf(accountSales.Opportunity__c)); 
               dealerAccountIds.add(accountSales.Account_SFID__c);          
               if(!accountSalesMap.containsKey(accountSales.Account_SFID__c)){                    
                  accountSalesMap.put(accountSales.Account_SFID__c,netSales);
                   dealerOpptyMap.put(accountSales.Account_SFID__c,netOpportunitySales);
               }
               else{
                  accountSalesMap.put(accountSales.Account_SFID__c,accountSalesMap.get(accountSales.Account_SFID__c) + netSales);
                  dealerOpptyMap.put(accountSales.Account_SFID__c,dealerOpptyMap.get(accountSales.Account_SFID__c) + netOpportunitySales);
               }
                if(!accountTouchPointIds.isEmpty() &&  accountTouchPointIds.contains(accountSales.Account_SFID__c) && !accountSalesRadlMap.containsKey(accountSales.Account_SFID__c)){
                    accountSalesRadlMap.put(accountSales.Account_SFID__c,netSales);
                }
                else if(!accountTouchPointIds.isEmpty() &&  accountTouchPointIds.contains(accountSales.Account_SFID__c) && accountSalesRadlMap.containsKey(accountSales.Account_SFID__c)){
                    accountSalesRadlMap.put(accountSales.Account_SFID__c,accountSalesMap.get(accountSales.Account_SFID__c) + netSales);                                 
                }
          }
    }
    
    public static void getFarmingArea(String crop,String season,Set<Id> accountIds){
        growerAccountIds = new Set<Id>();
        // Get the aggregated growth potential from account farming area for the growers
        for(Account_Farming_Area__c accountFarmingArea : [SELECT Id,Account_SFID__c,Area_Opportunity__c FROM  Account_Farming_Area__c WHERE Account_SFID__c IN:accountIds
                                                          AND Area_Usage_Descr__c =:crop AND Selling_Season_Descr__c =:season]){
           growerAccountIds.add(accountFarmingArea.Account_SFID__c);
           Integer netOpportunitySales = (accountFarmingArea.Area_Opportunity__c == null ? 0 : Integer.valueOf(accountFarmingArea.Area_Opportunity__c));
           if(!growerOpptyMap.containsKey(accountFarmingArea.Account_SFID__c)){
                growerOpptyMap.put(accountFarmingArea.Account_SFID__c,netOpportunitySales);
           }
           else{
                growerOpptyMap.put(accountFarmingArea.Account_SFID__c,growerOpptyMap.get(accountFarmingArea.Account_SFID__c) + netOpportunitySales);
           }
       }
    }
    
    public static void clearCollectionData(){
        aggregateCount.clear();
        aggregateCurrentSalesMap.clear();
        aggregateNetSalesGrowerOpptyMap.clear();
        aggregateNetSalesDealerOpptyMap.clear();
        accountSalesMap.clear();
        dealerOpptyMap.clear();
        growerOpptyMap.clear();
        
    }
    
    public class RadlCoverageWrapper{
        public Map<String,String> totalCoverageMap {get;set;}        
        public Map<String,String> currentSalesMap {get;set;}
        public Map<String,String> radlCoverageSalesMap {get;set;}
        public Map<String,String> growthPotentialMap {get;set;}
        public Map<String,String> plannedProgramAllocatedAccountMap {get;set;}
        public Map<String,String> plannedProgramAllocatedAvgMap {get;set;}
        public Map<String,String> programAllocatedRadlCoverageMap {get;set;}
        public Map<String,Integer> netGrowerOpptySales {get;set;}
        public Map<String,Integer> netDealerOpptySales {get;set;}
        public Map<String,Integer> netCurrentSalesperRadl {get;set;}
        public Map<String,Integer> netRadlCoverage {get;set;}
        
        public RadlCoverageWrapper(){
            totalCoverageMap = new Map<String,String>();
            currentSalesMap = new Map<String,String>();
            radlCoverageSalesMap = new Map<String,String>();
            growthPotentialMap = new Map<String,String>();
            plannedProgramAllocatedAccountMap = new Map<String,String>();
            programAllocatedRadlCoverageMap = new Map<String,String>();
            plannedProgramAllocatedAvgMap = new Map<String,String>();
            netGrowerOpptySales = new Map<String,Integer>();
            netDealerOpptySales = new Map<String,Integer>();
            netCurrentSalesperRadl = new Map<String,Integer>();
            netRadlCoverage = new Map<String,Integer>();
            
            if(!radlSet.isEmpty()){
                for(String radl : radlSet){
                    totalCoverageMap.put(radl,'0');
                    netGrowerOpptySales.put(radl,0);
                }
                netCurrentSalesperRadl.putAll(netGrowerOpptySales);
                netRadlCoverage.putAll(netGrowerOpptySales);
                netDealerOpptySales.putAll(netGrowerOpptySales);
                radlCoverageSalesMap.putAll(totalCoverageMap);
                currentSalesMap.putAll(totalCoverageMap);
                growthPotentialMap.putAll(totalCoverageMap);
                programAllocatedRadlCoverageMap.putAll(totalCoverageMap);
                plannedProgramAllocatedAccountMap.putAll(totalCoverageMap);
                plannedProgramAllocatedAvgMap.putAll(totalCoverageMap);
                totalCoverageMap.put('No Program','0');

            }
        }
    }
}