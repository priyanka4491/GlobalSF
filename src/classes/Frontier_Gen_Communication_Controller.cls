public with sharing class Frontier_Gen_Communication_Controller { 
    
    @AuraEnabled 
    public static String getCommunicationDetails(Id recordId)
    {   
        String communicationDetails;
        //Verify current context is Account or Contact
        If(Schema.Account.SObjectType == recordId.getSobjectType())
        {
            // Call Account Communication Details method.
            communicationDetails = getAccCommunicationDetails(recordId);
            
        }else If(Schema.Contact.SObjectType == recordId.getSobjectType())
        {
            // Call Account Communication Details method.
            communicationDetails = getConCommunicationDetails(recordId);    		
        }
        System.debug('Communication Details'+communicationDetails);
        return communicationDetails; 
    }
    //This method retrives Account Communication Details
    @AuraEnabled 
    public static String getAccCommunicationDetails (Id recordId)
    {
        Id accountId = recordId;
        Account accountRecord = [SELECT Id, Name From Account Where Id =: accountId];
        List<Account_Communication__c> comAddress = new List<Account_Communication__c>();
        List<Account_Communication__c> comPhone = new List<Account_Communication__c>();
        List<Account_Communication__c> comEmail = new List<Account_Communication__c>();
        
            comAddress = [SELECT Id, Account_SFID__c, State_Name__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                          WHERE RecordType.DeveloperName = 'Account_Communication_Address_Role_Business_Role'
                        	AND Archive_Ind__c = 'N'
                        	AND Parent_SFID__r.Archive_Ind__c = 'N' 
                        	AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                          	AND Account_SFID__c =: accountId];
            
            comPhone = [SELECT Id, Account_SFID__c, State_Name__c, Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Extension_Number__c, Phone_Number__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                        WHERE RecordType.DeveloperName = 'Account_Communication_Phone_Role_Business_Role'
                        AND Archive_Ind__c = 'N'
                        AND Parent_SFID__r.Archive_Ind__c = 'N' 
                        AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                        AND Account_SFID__c =: accountId];
            
            comEmail = [SELECT Id, Account_SFID__c, State_Name__c,Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c,has_Do_Not_Email_Ind__c,Email_Addr__c, Street_Addr__c, City_Name__c, Postal_Code__c FROM Account_Communication__c 
                        WHERE RecordType.DeveloperName = 'Account_Communication_Email_Role_Business_Role'
                        AND Archive_Ind__c = 'N'
                        AND Parent_SFID__r.Archive_Ind__c = 'N' 
                        AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                        AND Account_SFID__c =: accountId];
        
        CommunicationDataWrapper communicationData = new CommunicationDataWrapper();
        communicationData.commAddress = !comAddress.isEmpty() ?(String.valueOf(comAddress[0].Street_Addr__c) != null ? String.valueOf(comAddress[0].Street_Addr__c) : '')+ ', ' +
            (String.valueOf(comAddress[0].City_Name__c) != null ? String.valueOf(comAddress[0].City_Name__c) : '')+ ', ' +
            (String.valueOf(comAddress[0].State_Name__c) != null ? String.valueOf(comAddress[0].State_Name__c) : '')+'.' :'';
        
        communicationData.commPhone = !comPhone.isEmpty() ? String.valueOf(comPhone[0].Parent_SFID__r) != null ? 
            String.valueOf(comPhone[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            String.valueOf(comPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            String.valueOf(comPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        
        communicationData.commEmail = !comEmail.isEmpty() ? String.valueOf(comEmail[0].Parent_SFID__r)	 != null ? 
            String.valueOf(comEmail[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            String.valueOf(comEmail[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            String.valueOf(comEmail[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        
        communicationData.recordName = accountRecord.Name;
        
        communicationData.objectRecordType = 'Dealer Account';
        
        return JSON.serialize(communicationData);
    }
    
    @AuraEnabled 
    public static String getConCommunicationDetails(Id recordId)
    {
        Id contactId = recordId;
        System.debug('Received contactId'+contactId);
        
        Contact contactDetails = new Contact();
        List<Contact_Communication__c> contactAddress = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactPhone = new List<Contact_Communication__c>();
        List<Contact_Communication__c> contactEmail = new List<Contact_Communication__c>();
        
        if(contactId != null){            
            List<UserRecordAccess> lstUserRecordAccess;
            lstUserRecordAccess = [SELECT RecordId,MaxAccessLevel,HasAllAccess, 
                                   HasDeleteAccess, 
                                   HasEditAccess,
                                   HasReadAccess, 
                                   HasTransferAccess 
                                   FROM UserRecordAccess 
                                   WHERE UserId =: UserInfo.getUserId()
                                   AND RecordId =: contactId];
            ContactShare contactRecordShare = new ContactShare();
            if(lstUserRecordAccess[0].HasReadAccess == False)
            {
                contactRecordShare.ContactId = contactId;
                contactRecordShare.UserOrGroupId = UserInfo.getUserId();
                contactRecordShare.ContactAccessLevel = 'Read';
                contactRecordShare.RowCause = Schema.ContactShare.RowCause.Manual;
                insert contactRecordShare;    
            }
            contactDetails = [SELECT Id, FirstName, LastName, Name, MobilePhone, Email, MailingStreet, MailingCity, MailingState,
                         	 MailingCountry FROM Contact WHERE Id = : contactId];
            
            contactAddress= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                             Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                             is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                             is_Primary_Communication__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                             FROM Contact_Communication__c 
                             WHERE   RecordType.DeveloperName = 'Contact_Communication_Address_Role_Business_Role'
                             AND Archive_Ind__c = 'N'
                             AND Parent_SFID__r.Archive_Ind__c = 'N' 
                             AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                             AND Contact_SFID__c =: contactId];
            
            contactPhone= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                           Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                           is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c,Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c,Phone_Number__c, Postal_Code__c,
                           is_Primary_Communication__c,  Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                           From Contact_Communication__c 
                           WHERE   RecordType.DeveloperName = 'Contact_Communication_Phone_Role_Business_Role'
                           AND Archive_Ind__c = 'N'
                           AND Parent_SFID__r.Archive_Ind__c = 'N' 
                           AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N'
                           AND Contact_SFID__c =: contactId];
            
            contactEmail= [SELECT Id, Account_Business_Role_SFID__c, Archive_Date__c, Archive_Ind__c, City_Name__c, Contact_SFID__c,
                           Country_Name__c, has_Do_Not_Call_Ind__c, has_Do_Not_Email_Ind__c, Email_Addr__c, Phone_Extension_Number__c, 
                           is_Fax__c, Geocode__c, HC_Integration_Key__c, is_Mobile_Phone__c, Parent_SFID__c, Parent_SFID__r.Parent_SFID__r.Email_Addr__c ,Parent_SFID__r.Parent_SFID__r.Phone_Number__c, Phone_Number__c, Postal_Code__c,
                           is_Primary_Communication__c, Parent_SFID__r.Archive_Ind__c, Parent_SFID__r.Parent_SFID__r.Archive_Ind__c, Role_Descr__c, State_Name__c, Street_Addr__c, is_Voice_Phone__c
                           From Contact_Communication__c 
                           WHERE   RecordType.DeveloperName = 'Contact_Communication_Email_Role_Business_Role'
                           AND Archive_Ind__c = 'N'AND Parent_SFID__r.Archive_Ind__c = 'N' 
                           AND Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = 'N' AND Contact_SFID__c =: contactId];
        }
        CommunicationDataWrapper communicationData = new CommunicationDataWrapper();
        communicationData.commAddress = !contactAddress.isEmpty() ?(String.valueOf(contactAddress[0].Street_Addr__c) != null ? String.valueOf(contactAddress[0].Street_Addr__c) : '')+ ', ' +
            (String.valueOf(contactAddress[0].City_Name__c) != null ? String.valueOf(contactAddress[0].City_Name__c) : '')+ ', ' +
            (String.valueOf(contactAddress[0].State_Name__c) != null ? String.valueOf(contactAddress[0].State_Name__c) : '')+'.' :'';
        
        communicationData.commPhone = !contactPhone.isEmpty() ? String.valueOf(contactPhone[0].Parent_SFID__r) != null ? 
            String.valueOf(contactPhone[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            String.valueOf(contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            String.valueOf(contactPhone[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        
        communicationData.commEmail = !contactEmail.isEmpty() ? String.valueOf(contactEmail[0].Parent_SFID__r) != null ? 
            String.valueOf(contactEmail[0].Parent_SFID__r.Parent_SFID__r) != null ? 
            String.valueOf(contactEmail[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) != null ? 
            String.valueOf(contactEmail[0].Parent_SFID__r.Parent_SFID__r.Phone_Number__c) :'':'':'':'';
        
        communicationData.recordName = contactDetails.Name;
        
        communicationData.objectRecordType = 'Contact';
        
        return JSON.serialize(communicationData);
        }
        
        class CommunicationDataWrapper{
            public String commAddress {get;set;}
            public String commPhone {get;set;}
            public String commEmail {get;set;}
            public String recordName {get;set;}
            public String objectRecordType {get;set;}
        }
        
    }