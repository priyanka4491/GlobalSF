public with sharing class Frontier_DealerDetailsController {
    //This dealerAccountDetails method use to get all the account related informations.
    @AuraEnabled    
    public static string dealerAccountDetails(String dealerAccount, String dealerAccComm, String season)
    {
        system.debug('dealerAccount'+dealerAccount+'dealerAccComm'+dealerAccComm+'season'+season);  
        List<Account_Farming_Area__c> listOfCrops = new List<Account_Farming_Area__c>();
        dealerAccountDataWrapper accountData = new dealerAccountDataWrapper();
        List<Account_Business_Role__c> accountRecordsList = new List<Account_Business_Role__c>();
        List<Account_Communication__c> dealerAccComAddress = new List<Account_Communication__c>();
        List<Account_Communication__c> dealerAccComPhone = new List<Account_Communication__c>();
        List<Account_Communication__c> dealerAccComEmail = new List<Account_Communication__c>();
        List<Account_Farming_Area__c> accFarmingArea = new List<Account_Farming_Area__c>();
         List<Territory2> territoryList = new List<Territory2>();
        List<Account_Sales__c> accSalesList = new List<Account_Sales__c>(); 
        List<UserTerritory2Association> userTerritoryList = new List<UserTerritory2Association>();

        List<Account_Contact__c> accContact = new List<Account_Contact__c>();
        List<Contact_Communication__c> contactEmail = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactPhone = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactAddress = new List<Contact_Communication__c>();
        Account dealer = new Account();
        List<Account_Farming_Area__c> listofParentCrops = new List<Account_Farming_Area__c>();
        Contact accontact = new Contact();
        //List<dealerCropWrapper> accdealerCropList = new List<dealerCropWrapper>();
        List<Account_Org_Relationship__c> listGrowerAccounts = null;
        
            Set<Id> dealerIdSet = new Set<Id>();
            Set<Id> dealerABSIdSet = new Set<Id>();
            // grab dealer account details
            
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds();
            
            if(dealerAccount != null){
            dealer = [SELECT Id, Name, Phone FROM Account WHERE Id =: dealerAccount];
            
            
           
            accountRecordsList = [SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,                                
                                                                Role_Descr__c,Business_Unit_Descr__c, 
                                                                (SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),
                                                                (SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,      
                                                                 Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,   
                                                                 Parent_SFID__r.Role_Descr__c FROM Account_Communications__r 
                                                                 WHERE   Archive_Ind__c = 'N' AND  Parent_SFID__r.Archive_Ind__c = 'N' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                                 AND   RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role' AND  Parent_SFID__r.Role_Descr__c = 'Business'
                                                                 LIMIT 1)
                                                                FROM    Account_Business_Role__c
                                                                WHERE   Archive_Ind__c = 'N'
                                  							    AND   Account_SFID__r.Account_Global_Party_ID__c != null
                                                                AND Account_SFID__r.Archive_Ind__c = 'N'
                                                                AND Role_Descr__c = 'Partner'
                                                                AND Account_SFID__c =:dealerAccount
                                                               ];
            }
            if(!accountRecordsList.isEmpty()){
                for(Account_Business_Role__c accountBusiness : accountRecordsList){
                    dealerIdSet.add(accountBusiness.Account_SFID__c);
                    dealerABSIdSet.add(accountBusiness.Id);
                }            
            }
            if(!dealerIdSet.isEmpty()){
                //Getting Dealer Specific Grower Count
                listGrowerAccounts = [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c, 
                                      Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                      FROM Account_Org_Relationship__c
                                      WHERE Parent_Account_SFID__c IN :dealerIdSet
                                      AND Child_Account_SFID__c IN :territoryaccIdSet 
                                      AND Child_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Customer' 
                                      AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                      AND Child_Account_SFID__r.Account_Global_Party_ID__c != null];    
            }
        	System.debug('dealerAccComm'+dealerAccComm);
            // grab dealer account address details
            if(dealerAccComm != null && dealerAccComm != ''){
            dealerAccComAddress = [SELECT Id, Account_SFID__c, State_Name__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                                    WHERE Id =: dealerAccComm];
            dealerAccComPhone = [SELECT Id, Account_SFID__c, State_Name__c, Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Extension_Number__c, Phone_Number__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                                    WHERE RecordType.DeveloperName = 'Account_Communication_Phone_Role_Business_Role'
                                    AND Archive_Ind__c = 'N'
                                    AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                    AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                    AND Account_SFID__c =: dealerAccount];
            dealerAccComEmail = [SELECT Id, Account_SFID__c, State_Name__c,Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c,has_Do_Not_Email_Ind__c,Email_Addr__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                                    WHERE RecordType.DeveloperName = 'Account_Communication_Email_Role_Business_Role'
                                    AND Archive_Ind__c = 'N'
                                    AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                    AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                    AND Account_SFID__c =: dealerAccount];
                System.debug('inside accomunication');
            
            // grab dealer account farming areas
            
            accFarmingArea = [SELECT Id, Name, RecordTypeId,Account_SFID__c, Account_Business_Role_SFID__c, Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c,Area_Usage_Descr__c,
                              RFM_Score__c, Selling_Season_Descr__c, Year__c, Year_Type__c, NPS__c FROM Account_Farming_Area__c WHERE Account_SFID__c =: dealerAccount];
           System.debug('dealerAccount'+dealerAccount);
            }
            if(dealerAccount != null){
            // grab dealer account primary contact details
            accContact = [SELECT Id, Account_SFID__c, Contact_SFID__c, is_Primary_Contact__c, Role_Descr__c 
                                             FROM Account_Contact__c WHERE Account_SFID__c =: dealerAccount 
                                             AND RecordType.DeveloperName = 'Account_Contact_Account_Contact_Relationship'
                                             AND Contact_SFID__c != null ];  
            }
            List<UserRecordAccess> lstUserRecordAccess;
            if(!accContact.isEmpty()){
                lstUserRecordAccess = [SELECT RecordId,MaxAccessLevel,HasAllAccess, 
                                           HasDeleteAccess, 
                                           HasEditAccess,
                                           HasReadAccess, 
                                           HasTransferAccess 
                                           FROM UserRecordAccess 
                                           WHERE UserId =: UserInfo.getUserId()
                                           AND RecordId =: accContact[0].Contact_SFID__c];
                ContactShare contactRecordShare = new ContactShare();
                if(lstUserRecordAccess[0].HasReadAccess == False)
                {
                    contactRecordShare.ContactId = accContact[0].Contact_SFID__c;
                    contactRecordShare.UserOrGroupId = UserInfo.getUserId();
                    contactRecordShare.ContactAccessLevel = 'Read';
                    contactRecordShare.RowCause = Schema.ContactShare.RowCause.Manual;
                    insert contactRecordShare;    
                }     
                // grab dealer account contact details
                accontact = [SELECT Id, FirstName, LastName, Name, MobilePhone, Email, MailingStreet, MailingCity, MailingState,
                                     MailingCountry FROM Contact WHERE Id = : accContact[0].Contact_SFID__c];
                contactEmail= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                        Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                        is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                                                        is_Primary_Communication__c, Parent_SFID__r.Archive_Ind__c, Parent_SFID__r.Parent_SFID__r.Archive_Ind__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                        FROM Contact_Communication__c 
                                                        WHERE   RecordType.DeveloperName = 'Contact_Communication_Email_Role_Business_Role'
                                                        AND Archive_Ind__c = 'N'
                                                        AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                        AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                        AND Contact_SFID__c =: accontact.Id];
                
                contactPhone= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                        Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                        is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c,Phone_Number__c, Postal_Code__c,
                                                        is_Primary_Communication__c,  Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                        FROM Contact_Communication__c 
                                                        WHERE   RecordType.DeveloperName = 'Contact_Communication_Phone_Role_Business_Role'
                                                        AND Archive_Ind__c = 'N'
                                                        AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                        AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                        AND Contact_SFID__c =: accontact.Id];
                
                contactAddress= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                          Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                          is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                                                          is_Primary_Communication__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                          FROM Contact_Communication__c 
                                                          WHERE   RecordType.DeveloperName = 'Contact_Communication_Address_Role_Business_Role'
                                                          AND Archive_Ind__c = 'N'
                                                          AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                          AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                                          AND Contact_SFID__c =: accontact.Id];
            }
            Recordtypes__c croprecordType = Recordtypes__c.getValues('AccountFarmingAreaCropFarmingArea');
            Recordtypes__c parentFarmrecordType = Recordtypes__c.getValues('AccountFarmingAreaTotalFarmingArea');            
            
            listofParentCrops = [SELECT Id, Account_SFID__c, RecordTypeId, Account_Business_Role_SFID__c, Area_Usage_Descr__c, Area_Qty__c, 
                                 Inbound_Area_Qty__c, Inbound_Area_Use_UOM_Descr__c, Inbound_Total_Farm_Area_Qty__c, NPS__c, 
                                 Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c, RFM_Score__c  , Selling_Season_Descr__c,
                                 Total_Farming_Area_Qty__c, Area_Usage_UOM_Descr__c,Year__c, Year_Type__c
                                 FROM Account_Farming_Area__c WHERE RecordTypeId =: parentFarmrecordType.Value__c AND Account_SFID__c = : dealerAccount];
            
            
            if(listofParentCrops != null && listofParentCrops.size() >0)
            {
                listOfCrops = [SELECT Id,Name,Account_SFID__c, RecordTypeId, Account_Business_Role_SFID__c, Area_Usage_Descr__c, Area_Qty__c, 
                               Inbound_Area_Qty__c, Inbound_Area_Use_UOM_Descr__c, Inbound_Total_Farm_Area_Qty__c, NPS__c, 
                               Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c, RFM_Score__c  , Selling_Season_Descr__c,
                               Total_Farming_Area_Qty__c, Area_Usage_UOM_Descr__c,Year__c, Year_Type__c
                               FROM Account_Farming_Area__c WHERE Selling_Season_Descr__c =: season AND RecordTypeId =: croprecordType.Value__c AND Account_SFID__c = : dealerAccount];
            }            
            if(listGrowerAccounts != null){
                accountData.growerCount = listGrowerAccounts.size();
            }
            else{
                accountData.growerCount = 0;
            }
            // grab season picklist value
            Schema.DescribeFieldResult fieldResult = Account_Farming_Area__c.Selling_Season_Descr__c.getDescribe();
            List<Schema.PicklistEntry> pick_list_values = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                accountData.dealerSeason.add(a.getValue()); //add the value and label to our final list
            } 
        userTerritoryList = [SELECT Id, IsActive, RoleInTerritory2, Territory2Id, UserId FROM 
                             UserTerritory2Association WHERE UserId =: UserInfo.getUserId()];
        if(!userTerritoryList.isEmpty()){
            territoryList = [SELECT Id, Name, DeveloperName, Division__c FROM 
                             Territory2 WHERE Id =: userTerritoryList[0].Territory2Id];
        }
        system.debug('territoryList'+territoryList);
       
       accsalesList=[Select Id,Name,Account_SFID__c,Brand_Name__c,Crop__c,Net_Sales_Qty__c,Opportunity__c,Account_Business_Role_SFID__r.Service_Level_Class_Descr__c,Year__c,Business_Unit_Descr__c,Account_Business_Role_SFID__r.Role_Descr__c From Account_Sales__c where Account_SFID__c=:dealerAccount  AND Account_Business_Role_SFID__r.Role_Descr__c='Partner'] ;
        system.debug('accsalesList'+accsalesList);
        /*for(Account_Sales__c accsales : accsalesList){
            dealerCropWrapper GCW = new dealerCropWrapper();
            GCW.cropName = (accsales.Crop__c != null ? accsales.Crop__c : '');
            GCW.cropRADL = (accsales.Account_Business_Role_SFID__r.Service_Level_Class_Descr__c != null ? accsales.Account_Business_Role_SFID__r.Service_Level_Class_Descr__c : '');
            //GCW.cropNPS = (String.valueOf(AFA.NPS__c) != null ? String.valueOf(AFA.NPS__c) : '');
            //GCW.cropPOP = (String.valueOf(AFA.Probability_ff_Purchase__c) != null ? String.valueOf(AFA.Probability_ff_Purchase__c) : '');
            //GCW.cropRFM = (String.valueOf(AFA.RFM_Score__c) != null ? String.valueOf(AFA.RFM_Score__c) : '');
            accdealerCropList.add(GCW);
        }*/
        //accountData.dealerCropWrapperList.addAll(accdealerCropList); 
        // assigning to the wrapper variables
        accountData.dealerAccountName = (dealer.Name != Null ? dealer.Name : '');
        accountData.dealerPrimaryContactFirstName = (accontact.FirstName != null ? accontact.FirstName : '');
        accountData.dealerPrimaryContactLastName = (accontact.LastName != null ? accontact.LastName : '');
        accountData.dealerPrimaryContactEmail = !contactEmail.isEmpty() ?(contactEmail[0].Parent_SFID__r != null ? (contactEmail[0].Parent_SFID__r.Parent_SFID__r != null ? (contactEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c != null ? contactEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c : ''):''):''):'';
        accountData.dealerPrimaryContactPhone = !contactPhone.isEmpty() ? (contactPhone[0].Parent_SFID__r != null ? (contactPhone[0].Parent_SFID__r.Parent_SFID__r != null ? (contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c  != null ? contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c  : ''):''):''):'';
        accountData.dealerAddressLine = !dealerAccComAddress.isEmpty() ?(String.valueOf(dealerAccComAddress[0].Street_Addr__c) != null ? String.valueOf(dealerAccComAddress[0].Street_Addr__c) : '')+ ', ' +
                                        (String.valueOf(dealerAccComAddress[0].City_Name__c) != null ? String.valueOf(dealerAccComAddress[0].City_Name__c) : '')+ ', ' +
                                        (String.valueOf(dealerAccComAddress[0].State_Name__c) != null ? String.valueOf(dealerAccComAddress[0].State_Name__c) : '')+'.' : '';
        
        accountData.phone = !dealerAccComPhone.isEmpty() ? String.valueOf(dealerAccComPhone[0].Parent_SFID__r) != null ? 
            				String.valueOf(dealerAccComPhone[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            				String.valueOf(dealerAccComPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            				String.valueOf(dealerAccComPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        
        accountData.email = !dealerAccComEmail.isEmpty() ? String.valueOf(dealerAccComEmail[0].Parent_SFID__r) != null ? 
                            String.valueOf(dealerAccComEmail[0].Parent_SFID__r.Parent_SFID__r) != null ? 
                            String.valueOf(dealerAccComEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c) != null ? 
                            String.valueOf(dealerAccComEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c) : '':'':'':'';
                                            
        accountData.dealer = (String.valueOf(dealer.Name) != null ? String.valueOf(dealer.Name) : '');
        accountData.dealerId = (String.valueOf(dealer.Id) != null ? String.valueOf(dealer.Id) : '');
        accountData.dealerAccountRADL = (accountRecordsList[0].Service_Level_Class_Descr__c != null ? accountRecordsList[0].Service_Level_Class_Descr__c : '');
        accountData.sapId = (accountRecordsList[0].Account_Identifiers__r.isEmpty() ? '' : accountRecordsList[0].Account_Identifiers__r[0].Source_System_ID__c);
        accountData.accCommunicationId = (accountRecordsList[0].Account_Communications__r.isEmpty() ? '' :accountRecordsList[0].Account_Communications__r[0].Parent_SFID__r.Parent_SFID__r.Id);
        return JSON.serialize(accountData);
    }    
    
    class dealerAccountDataWrapper{
        public List<String> Labels {get;set;}
        public String dealerAccountName {get;set;}
        public String dealerAccountRADL {get;set;}
        public String dealerPrimaryContactFirstName {get;set;}
        public String dealerPrimaryContactLastName {get;set;}
        public String dealerPrimaryContactEmail {get;set;}
        public String dealerPrimaryContactPhone {get;set;}
        public String dealerAddressLine {get;set;}
        //Public String dealerAreaTotal{get;set;} 
        public String phone{get;set;}   
        public String email{get;set;} 
        public List<String> dealerSeason{get;set;}
        //public String dealercrop {get;set;}  
        public String dealer {get;set;}
        //public string dealerRADL{get;set;}
        
        //public string dealerCornRADL{get;set;}
        //public string dealerSoyRADL{get;set;}
        public List<String> dealerbrand {get;set;}
        public List<String> dealerFamily {get;set;}
        public List<String> areaMonShare {get;set;}
        //public String othersShare {get;set;}
        //public String othersArea {get;set;}  
        public String sapId {get;set;}
        public String accCommunicationId {get;set;}
        public String dealerId {get;set;}
        public List<Integer> chartdata {get;set;}
        //public Boolean displayMsg {get;set;}
        public List<String> buttonValue {get;set;}
        public List<String> dealerCrops {get;set;}
        //public List<dealerCropWrapper> dealerCropWrapperList {get;set;}
        public Integer growerCount{get;set;}
        public dealerAccountDataWrapper(){            
            Labels = new List<String>();
            dealerSeason=new List<String>();
            dealerbrand = new List<String>();
            dealerFamily = new List<String>();
            chartdata = new List<Integer>();
            areaMonShare = new List<String>();
            buttonValue =new List<String>();
            dealerCrops = new List<String>();
            //dealerCropWrapperList = new List<dealerCropWrapper>();
        }
    }
   /* Class dealerCropWrapper{
        public String cropName {get;set; } 
        public String cropRADL {get;set; }
        public String cropNPS {get;set; }
        public String cropPOP {get;set; }
        public String cropRFM {get;set; }
        public dealerCropWrapper(){
        }
    }*/
}