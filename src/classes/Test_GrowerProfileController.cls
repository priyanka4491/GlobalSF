public class Test_GrowerProfileController {
    @AuraEnabled    
    public static String GrowerFarmSizeDetails(Id growerAccId,String fiscalyr,String uom){
        system.debug('uom' + uom);
      GrowerAccountDataWrapper accountData = new GrowerAccountDataWrapper();
        List<Integer> areaShareList = new  List<Integer>();
     Integer areaMonShareTotal=0;
        Integer areaMonTotal=0;
        Id recordTypeId =[select id from Recordtype where Developername='Account_Farming_Area_Total_Farming_Area' LIMIT 1].id;
        system.debug('recordTypeId' +recordTypeId);
      List<Account_Farming_Area__c> accFarmingArea = new List<Account_Farming_Area__c>();
        String queryString= 'SELECT Id, Name,Account_SFID__c, Account_Business_Role_SFID__c, Parent_SFID__c,Area_Usage_Descr__c,Inbound_Area_Qty__c,Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c,Parent_SFID__r.Selling_Season_Descr__c,Inbound_Area_Use_UOM_Descr__c,Year__c, Year_Type__c From Account_Farming_Area__c Where Parent_SFID__c!=null AND Parent_SFID__r.Account_SFID__c =: growerAccId';  
        if(fiscalyr ==null ||fiscalyr=='FY17' ){
           queryString += ' AND Parent_SFID__r.Year__c=2017';
        }
        if(fiscalyr=='FY16' ){
           queryString += ' AND Parent_SFID__r.Year__c=2017'; 
        }
        accFarmingArea =Database.query(queryString);
        system.debug('-----' +queryString);
        system.debug('accFarmingArea' + accFarmingArea.size()) ;
        for(Integer i=0;i<accFarmingArea.size();i++){
           Integer areaMonsatoShare = Integer.valueOf((accFarmingArea[i].Inbound_Area_Qty__c/accFarmingArea[i].Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c)*100);
             areaMonShareTotal = areaMonShareTotal +areaMonsatoShare; 
             areaMonTotal = areaMonTotal + Integer.valueOf((accFarmingArea[i].Inbound_Area_Qty__c));
            areaShareList.add(areaMonsatoShare);
        }
        for(Integer i=0;i<areaShareList.size() && i<accFarmingArea.size();i++){
          accountData.Labels.add(areaShareList[i] + '% |' +accFarmingArea[i].Area_Usage_Descr__c+ ': ' + accFarmingArea[i].Inbound_Area_Qty__c +'' + accFarmingArea[i].Inbound_Area_Use_UOM_Descr__c) ; 
          accountData.growerAccountCroparea.add(areaShareList[i]);
        }
        accountData.othersShare=100 - areaMonShareTotal;
        accountData.othersArea=(Integer.valueOf((accFarmingArea[0].Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c)))- areaMonTotal;
        if(accountData.othersShare != 0){
       accountData.Labels.add(accountData.othersShare + '% |' +'Others'+ ': ' + accountData.othersArea +'' + 'Acre') ; 
        accountData.growerAccountCroparea.add(accountData.othersShare);
        }
        
        system.debug('areaShareList' +areaShareList);
        system.debug('accountData.Labels' +accountData.Labels[0]);
        for(Account_Farming_Area__c accfarming :accFarmingArea){
            accountData.growerAccountTotalArea=Integer.valueOf((accfarming.Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c));
        }
        
        
      return JSON.serialize(accountData);
    }
    
    @AuraEnabled    
    public static void getupdateFYArea(Id growerAccId,String crop1select,String crop2select, String crop3select,Integer totalArea, Integer  cornArea,Integer soyArea, Integer cottonArea, String seasonKey){
      List<Account_Farming_Area__c> accFarmingArea = new List<Account_Farming_Area__c>();
        List<Account_Farming_Area__c> accFarmupd = new List<Account_Farming_Area__c>();
        accFarmingArea = [SELECT Id, Name,Account_SFID__c, Account_Business_Role_SFID__c, Parent_SFID__c,Area_Usage_Descr__c,Inbound_Area_Qty__c,Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c,Parent_SFID__r.Selling_Season_Descr__c,Inbound_Area_Use_UOM_Descr__c,
                          RFM_Score__c, Selling_Season_Descr__c, Year__c, Year_Type__c, NPS__c From Account_Farming_Area__c Where RecordType.DeveloperName='Account_Farming_Area_Crop_Farming_Area' AND Parent_SFID__r.Account_SFID__c =: growerAccId];
      system.debug('accFarmingArea' + accFarmingArea) ;
	  for(Account_Farming_Area__c accFarmSize : accFarmingArea){
		if(crop1select == accFarmSize.Area_Usage_Descr__c){
			accFarmSize.Inbound_Area_Qty__c = cornArea;
		}
		if(crop2select == accFarmSize.Area_Usage_Descr__c){
			accFarmSize.Inbound_Area_Qty__c = soyArea;
		}
		if(crop2select == accFarmSize.Area_Usage_Descr__c){
			accFarmSize.Inbound_Area_Qty__c = cottonArea;
		}
		accFarmSize.Parent_SFID__r.Inbound_Total_Farm_Area_Qty__c = totalArea;
		accFarmupd.add(accFarmSize);
          System.debug('accFarmupd' + accFarmupd[0]);
	  }
	  update accFarmupd;
    }

    
    class GrowerAccountDataWrapper{
        public List<String> Labels {get;set;}
        public String growerAccountName {get;set;}
        public String growerAccountRADL {get;set;}
        public String growerPrimaryContactFirstName {get;set;}
        public String growerPrimaryContactLastName {get;set;}
        public String growerPrimaryContactEmail {get;set;}
        public String growerPrimaryContactPhone {get;set;}
        public String growerAddressLine {get;set;}
        Public String growerAreaTotal{get;set;} 
        public String phone{get;set;}	
        public String email{get;set;} 
        public List<String> growerSeason{get;set;}
        public String growercrop {get;set;}  
        public string growerRADL{get;set;}
        public string growerCornRADL{get;set;}
        public string growerSoyRADL{get;set;}
        public Integer growerAccountTotalArea{get;set;}
        public List<Integer> growerAccountCroparea{get;set;}

        public List<String> growerbrand {get;set;}
        public List<String> growerFamily {get;set;}
        public List<String> areaMonShare {get;set;}
        public Integer othersShare {get;set;}
        public Integer othersArea {get;set;}   
        public List<Integer> chartdata {get;set;}
        public Boolean displayMsg {get;set;}
        public List<String> buttonValue {get;set;}
        public GrowerAccountDataWrapper(){
            
            Labels = new List<String>();
            growerSeason=new List<String>();
            growerbrand = new List<String>();
            growerFamily = new List<String>();
            chartdata = new List<Integer>();
            areaMonShare = new List<String>();
            buttonValue =new List<String>();
            growerAccountCroparea=new List<Integer>();
        }
    }

}