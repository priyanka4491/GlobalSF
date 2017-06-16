public without sharing class Frontier_GrowerProfileController {
    //This growerAccountDetails method use to get all the account related informations.
    
    public static Map<Id,Integer> growerAccountMap = new Map<Id,Integer>();
    @AuraEnabled    
        public static string growerAccountDetails(String growerAccount, String growerAccComm, String season)
    {
        System.debug('growerAccComm'+growerAccComm);
        List<Account_Business_Role__c> accountRecordsList = new List<Account_Business_Role__c>();
        List<Account_Communication__c> growerAccComAddress = new List<Account_Communication__c>();
        List<Account_Communication__c> growerAccComPhone = new List<Account_Communication__c>();
        List<Account_Communication__c> growerAccComEmail = new List<Account_Communication__c>();       
        List<Account_Farming_Area__c> accFarmingArea = new List<Account_Farming_Area__c>();
        Contact accontact = new Contact();
        List<Account_Contact__c> accContact = new List<Account_Contact__c>();
        List<Contact_Communication__c> contactEmail = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactPhone = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactAddress = new List<Contact_Communication__c>();    
        List<Account_Farming_Area__c> listOfCrops = new List<Account_Farming_Area__c>();
        List<Account_Farming_Area__c> listofParentCrops = new List<Account_Farming_Area__c>();
        GrowerAccountDataWrapper accountData = new GrowerAccountDataWrapper();
        Integer count=0;
        Account grower = new Account();
        Set<Id> territoryaccIdSet = new Set<Id>();
        
        //Get Accounts of current user's territory from Util
        territoryaccIdSet = Util.getTerritoryAccountIds(); 
            System.debug('season==============>'+season);
            // grab grower account details
            grower = [SELECT Id, Name, Phone From Account Where Id =: growerAccount];
            
            accountRecordsList= [SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,                                
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
                                                                 AND   Account_SFID__r.Archive_Ind__c = 'N'
                                                                 AND   Account_SFID__c= :growerAccount];
            
            
            // grab grower account address details 
            if(growerAccComm != null && growerAccComm != ''){                     
                growerAccComAddress = [SELECT Id, Account_SFID__c, State_Name__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                                       WHERE Id =: growerAccComm];
                growerAccComPhone = [SELECT Id, Account_SFID__c, State_Name__c, Parent_SFID__c, Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Extension_Number__c, Phone_Number__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                                    WHERE RecordType.DeveloperName = 'Account_Communication_Phone_Role_Business_Role'
                                    AND Archive_Ind__c = 'N'
                                    AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                    AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                    AND Account_SFID__c =: growerAccount];
                growerAccComEmail = [SELECT Id, Account_SFID__c, State_Name__c,Parent_SFID__c, Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, has_Do_Not_Email_Ind__c,Email_Addr__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                                    WHERE RecordType.DeveloperName = 'Account_Communication_Email_Role_Business_Role'
                                    AND Archive_Ind__c = 'N'
                                    AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                    AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                                    AND Id =: growerAccount];
            }
            accFarmingArea = [SELECT Id, Name, RecordTypeId,Account_SFID__c, Account_Business_Role_SFID__c, Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c,Area_Usage_Descr__c,
                              RFM_Score__c, Selling_Season_Descr__c, Year__c, Year_Type__c, NPS__c FROM Account_Farming_Area__c WHERE Account_SFID__c =: growerAccount];
            
            // grab grower account primary contact details            
            accContact = [SELECT Id, Account_SFID__c, Contact_SFID__c, is_Primary_Contact__c, Role_Descr__c 
                                             FROM Account_Contact__c WHERE Account_SFID__c =: growerAccount 
                                             AND RecordType.DeveloperName = 'Account_Contact_Account_Contact_Relationship' 
                                             AND Contact_SFID__c != null];
        	
        	 //Getting Grower Specfic Dealer Count
             for(Account_Org_Relationship__c growerAccounts : [SELECT Id, Parent_Account_SFID__c, Parent_Acct_Bus_Role_SFID__c, Child_Account_SFID__c, 
                                              Child_Acct_Bus_Role_SFID__c, HC_Integration_Key__c, Archive_Date__c, Archive_Ind__c
                                              FROM Account_Org_Relationship__c WHERE Parent_Account_SFID__c IN :territoryaccIdSet AND Child_Account_SFID__c =:growerAccount
                                                               						 AND Parent_Acct_Bus_Role_SFID__r.Role_Descr__c = 'Partner' 
                                  											 		 AND Parent_Account_SFID__r.Account_Global_Party_ID__c != null 
                                       										  		 AND Child_Account_SFID__r.Account_Global_Party_ID__c != null]){
                    
                    if(growerAccounts.Parent_Account_SFID__c != Null && growerAccounts.Parent_Acct_Bus_Role_SFID__c != Null){
                        if(!growerAccountMap.containskey(growerAccounts.Child_Account_SFID__c)){
                            count = 1;
                            growerAccountMap.put(growerAccounts.Child_Account_SFID__c,count);
                        }
                        else{
                           growerAccountMap.put(growerAccounts.Child_Account_SFID__c,growerAccountMap.get(growerAccounts.Child_Account_SFID__c)+1);
                        }
                    }
            }            
            if(!accContact.isEmpty()){            
                List<UserRecordAccess> lstUserRecordAccess;
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
                // grab grower account contact details
                accontact = [SELECT Id, FirstName, LastName, Name, MobilePhone, Email, MailingStreet, MailingCity, MailingState,
                                     MailingCountry FROM Contact WHERE Id = : accContact[0].Contact_SFID__c];
                
                contactEmail= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                        Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                        is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                                                        is_Primary_Communication__c, Parent_SFID__r.Archive_Ind__c, Parent_SFID__r.Parent_SFID__r.Archive_Ind__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                        From Contact_Communication__c 
                                                        WHERE   RecordType.DeveloperName = 'Contact_Communication_Email_Role_Business_Role'
                                                        AND Archive_Ind__c = 'N'AND Parent_SFID__r.Archive_Ind__c = 'N' 
                                                        AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N' AND Contact_SFID__c =: accontact.Id];
                
                contactPhone= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                                                        Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                                                        is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c,Phone_Number__c, Postal_Code__c,
                                                        is_Primary_Communication__c,  Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                                                        From Contact_Communication__c 
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
            
           /* listofParentCrops = [SELECT Id, Account_SFID__c, RecordTypeId, Account_Business_Role_SFID__c, Area_Usage_Descr__c, Area_Qty__c, 
                                 Inbound_Area_Qty__c, Inbound_Area_Use_UOM_Descr__c, Inbound_Total_Farm_Area_Qty__c, NPS__c, 
                                 Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c, RFM_Score__c  , Selling_Season_Descr__c,
                                 Total_Farming_Area_Qty__c, Area_Usage_UOM_Descr__c,Year__c, Year_Type__c
                                 FROM Account_Farming_Area__c WHERE RecordTypeId =: parentFarmrecordType.Value__c AND Account_SFID__c = : growerAccount];
            
            
            if(listofParentCrops != null && listofParentCrops.size() >0){
                listOfCrops = [SELECT Id,Name,Account_SFID__c, RecordTypeId, Account_Business_Role_SFID__c, Area_Usage_Descr__c, Area_Qty__c, 
                               Inbound_Area_Qty__c, Inbound_Area_Use_UOM_Descr__c, Inbound_Total_Farm_Area_Qty__c, NPS__c, 
                               Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c, RFM_Score__c  , Selling_Season_Descr__c,
                               Total_Farming_Area_Qty__c, Area_Usage_UOM_Descr__c,Year__c, Year_Type__c
                               From Account_Farming_Area__c WHERE Selling_Season_Descr__c =: season AND RecordTypeId =: croprecordType.Value__c AND Account_SFID__c = : growerAccount];
            }*/
           listOfCrops = [SELECT Id,Name,Account_SFID__c, RecordTypeId, Account_Business_Role_SFID__c, Area_Usage_Descr__c, Area_Qty__c, 
                               Inbound_Area_Qty__c, Inbound_Area_Use_UOM_Descr__c, Inbound_Total_Farm_Area_Qty__c, NPS__c, 
                               Parent_SFID__c, Probability_ff_Purchase__c, Service_Level_Class_Descr__c, RFM_Score__c  , Selling_Season_Descr__c,
                               Total_Farming_Area_Qty__c, Area_Usage_UOM_Descr__c,Year__c, Year_Type__c
                               From Account_Farming_Area__c WHERE Selling_Season_Descr__c ='SUMMER' AND Year__c =2016 AND Parent_SFID__c != null AND Account_SFID__c = : growerAccount];
            system.debug('listOfCrops' +listOfCrops);
            // grab season picklist value
            Schema.DescribeFieldResult fieldResult = Account_Farming_Area__c.Selling_Season_Descr__c.getDescribe();
            List<Schema.PicklistEntry> pick_list_values = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                accountData.growerSeason.add(a.getValue()); //add the value and label to our final list
            }       
        List<GrowerCropWrapper> accGrowerCropList = new List<GrowerCropWrapper>();
        if(!listOfCrops.isEmpty()){
            for(Account_Farming_Area__c AFA : listOfCrops){
                GrowerCropWrapper GCW = new GrowerCropWrapper();
                GCW.cropName = (AFA.Area_Usage_Descr__c != null ? AFA.Area_Usage_Descr__c : '');
                GCW.cropRADL = (AFA.Service_Level_Class_Descr__c != null ? AFA.Service_Level_Class_Descr__c : '');
                GCW.cropNPS = (String.valueOf(AFA.NPS__c) != null ? String.valueOf(AFA.NPS__c) : '');
                GCW.cropPOP = (String.valueOf(AFA.Probability_ff_Purchase__c) != null ? String.valueOf(AFA.Probability_ff_Purchase__c) : '');
                GCW.cropRFM = (String.valueOf(AFA.RFM_Score__c) != null ? String.valueOf(AFA.RFM_Score__c) : '');
                if(GCW != null){
                    accGrowerCropList.add(GCW);
                }            
            }
        }
        accountData.growerCropWrapperList.addAll(accGrowerCropList);
        system.debug('accountData.growerCropWrapperList=============>'+accountData.growerCropWrapperList);
        // assigning to the wrapper variables
        accountData.growerPrimaryContactFirstName = (accontact.FirstName != null ? accontact.FirstName : '');
        accountData.growerPrimaryContactLastName = (accontact.LastName != null ? accontact.LastName : '');
        accountData.growerPrimaryContactEmail = !contactEmail.isEmpty() ?(contactEmail[0].Parent_SFID__r != null ? (contactEmail[0].Parent_SFID__r.Parent_SFID__r != null ? (contactEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c != null ? contactEmail[0].Parent_SFID__r.Parent_SFID__r.Email_Addr__c : ''):''):''):'';
        accountData.growerPrimaryContactPhone = !contactPhone.isEmpty() ? (contactPhone[0].Parent_SFID__r != null ? (contactPhone[0].Parent_SFID__r.Parent_SFID__r != null ? (contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c  != null ? contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c  : ''):''):''):'';
        accountData.growerAccountName = (grower.Name != null ? grower.Name : '');
        accountData.growerAddressLine =  !growerAccComAddress.isEmpty() ?(String.valueOf(growerAccComAddress[0].Street_Addr__c) != null ? String.valueOf(growerAccComAddress[0].Street_Addr__c) : '')+ ', ' +
            (String.valueOf(growerAccComAddress[0].City_Name__c) != null ? String.valueOf(growerAccComAddress[0].City_Name__c) : '')+ ', ' +
            (String.valueOf(growerAccComAddress[0].State_Name__c) != null ? String.valueOf(growerAccComAddress[0].State_Name__c) : '')+'.' :'';
        accountData.phone =  !growerAccComPhone.isEmpty() ? String.valueOf(growerAccComPhone[0].Parent_SFID__r) != null ? 
            				String.valueOf(growerAccComPhone[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            				String.valueOf(growerAccComPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            				String.valueOf(growerAccComPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        accountData.email = !growerAccComEmail.isEmpty() ? String.valueOf(growerAccComEmail[0].Parent_SFID__r) != null ? 
            				String.valueOf(growerAccComEmail[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            				String.valueOf(growerAccComEmail[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            				String.valueOf(growerAccComEmail[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        //accountData.dealer = (grower.Dealer_SFID__r.Name != null ? grower.Dealer_SFID__r.Name : '');
        accountData.dealerCount = (growerAccountMap.get(growerAccount) != null ? growerAccountMap.get(growerAccount) : 0);
        accountData.growerAccountRADL = !accountRecordsList.isEmpty() ? (accountRecordsList[0].Service_Level_Class_Descr__c != null ? accountRecordsList[0].Service_Level_Class_Descr__c  : '') : '' ;
        accountData.sapId = (accountRecordsList[0].Account_Identifiers__r.isEmpty() ? Null : accountRecordsList[0].Account_Identifiers__r[0].Source_System_ID__c);
        accountData.accCommunicationId = accountRecordsList[0].Account_Communications__r.isEmpty() ? Null : (accountRecordsList[0].Account_Communications__r[0].Parent_SFID__r  != Null ? (accountRecordsList[0].Account_Communications__r[0].Parent_SFID__r.Parent_SFID__r != Null ? accountRecordsList[0].Account_Communications__r[0].Parent_SFID__r.Parent_SFID__r.Id :'') :'') ;        
        return JSON.serialize(accountData);
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
        //Public String growerAreaTotal{get;set;} 
        public String phone{get;set;}   
        public String email{get;set;} 
        public List<String> growerSeason{get;set;}
        //public String growercrop {get;set;}  
        //public String dealer {get;set;}
        //public string growerRADL{get;set;}
        //public string growerCornRADL{get;set;}
        //public string growerSoyRADL{get;set;}
        public List<String> growerbrand {get;set;}
        public List<String> growerFamily {get;set;}
        public List<String> areaMonShare {get;set;}
        //public String othersShare {get;set;}
       // public String othersArea {get;set;}  
        public String sapId {get;set;}
        public String accCommunicationId {get;set;}
        public Integer dealerCount {get;set;}
        public List<Integer> chartdata {get;set;}
       // public Boolean displayMsg {get;set;}
        public List<String> buttonValue {get;set;}
        public List<String> growerCrops {get;set;}
        public List<GrowerCropWrapper> growerCropWrapperList {get;set;}
        public GrowerAccountDataWrapper(){
            
            Labels = new List<String>();
            growerSeason=new List<String>();
            growerbrand = new List<String>();
            growerFamily = new List<String>();
            chartdata = new List<Integer>();
            areaMonShare = new List<String>();
            buttonValue =new List<String>();
            growerCrops = new List<String>();
            growerCropWrapperList = new List<GrowerCropWrapper>();
        }
    }
    Class GrowerCropWrapper{
        public String cropName {get;set; } 
        public String cropRADL {get;set; }
        public String cropNPS {get;set; }
        public String cropPOP {get;set; }
        public String cropRFM {get;set; }
        public GrowerCropWrapper(){
            
        }
    }
    }