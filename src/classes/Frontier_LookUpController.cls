public class Frontier_LookUpController {
    
     /*
     * Loads the initial value of the given SObject type with ID "value"
	 */
	@AuraEnabled
    public static String getCurrentValue(String type, String value){
        if(String.isBlank(type)){
            return null;
        }
        
        ID lookupId = null;
        try{   
        	lookupId = (ID)value;
        }catch(Exception e){
            return null;
        }
        
        if(String.isBlank(lookupId)){
            return null;
        }
        
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        if(objType == null){
            return null;
        }

        String nameField = getSobjectNameField(objType);
        String query = 'Select Id, '+nameField+' From '+type+' Where Id = \''+lookupId+'\'';
        System.debug('### Query: '+query);
        List<SObject> oList = Database.query(query);
        if(oList.size()==0) {
            return null;
        }
		return (String) oList[0].get(nameField);
    }
    
    /*
     * Utility class for search results
	*/
    /*public class SearchResult{
        public String name{get;Set;}
        public String id{get;set;}
        public String email{get;set;}
    }*/
    
    /*
     * Returns the "Name" field for a given SObject (e.g. Case has CaseNumber, Account has Name)
	*/
    private static String getSobjectNameField(SobjectType sobjType){
        
        //describes lookup obj and gets its name field
        String nameField = 'Name';
        Schema.DescribeSObjectResult dfrLkp = sobjType.getDescribe();
        for(schema.SObjectField sotype : dfrLkp.fields.getMap().values()){
            Schema.DescribeFieldResult fieldDescObj = sotype.getDescribe();
            if(fieldDescObj.isNameField() ){
            	nameField = fieldDescObj.getName();
                break;
            }
        }
        return nameField;
    }
	
    /*
     * Searchs (using SOSL) for a given Sobject type
     */
    @AuraEnabled
    public static String searchSObject(String type, String searchString,string condition,string fields,string searchfield, boolean isCustomQuery,String customQueryWhere){
        
        string conditions = condition != ''? ' '+condition+' ' : '';
        if(String.isBlank(type) || String.isBlank(searchString)){
            return null;
        }
        
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        if(objType == null){
            return null;
        }        
        //String nameField = getSobjectNameField(objType);
        
        if(isCustomQuery){
            String accListQuery,finalwhere;
            
            Set<Id> accountIds =  new Set<Id>();
            Set<Id> territoryaccIds = new Set<Id>();

           	List<Account_Business_Role__c> accountRecordsList = new List<Account_Business_Role__c>();
            
            System.debug('accountTypeinLookup' +customQueryWhere);
            
            if(customQueryWhere != null){
                if(customQueryWhere == 'Dealer' || String.valueof(customQueryWhere).replaceAll( '\\s+', '') == 'Dealer-Dealer'){
                    finalwhere = ' AND (Role_Descr__c = \'Partner\')';
                }
                else if(customQueryWhere == 'Grower' || customQueryWhere.contains('Grower')){
                    finalwhere =  ' AND (Role_Descr__c=\'Customer\' AND Role_Category_Descr__c = \'Consumer\' AND Business_Unit_Descr__c = \'Customer\')';
                }
                else if(customQueryWhere == 'Both'){
                    finalwhere = ' AND ((Role_Descr__c = \'Partner\') OR (Role_Descr__c=\'Customer\' AND Role_Category_Descr__c = \'Consumer\' AND Business_Unit_Descr__c = \'Customer\'))';
                }
                
            }
			
            System.debug('finalwhereinLookup' +finalwhere);
            territoryaccIds = Util.getTerritoryAccountIds();		

            accListQuery = 'SELECT Account_SFID__c,Account_SFID__r.Name,Service_Level_Class_Descr__c,'                                
                +'Role_Descr__c,Business_Unit_Descr__c,' 
                +'(SELECT Source_System_ID__c FROM Account_Identifiers__r LIMIT 1),'
                +'(SELECT Parent_SFID__r.Parent_SFID__r.Id,Parent_SFID__r.Parent_SFID__r.Street_Addr__c,Parent_SFID__r.Parent_SFID__r.City_Name__c,'      
                +'Parent_SFID__r.Parent_SFID__r.State_Name__c,Parent_SFID__r.Parent_SFID__r.Country_Name__c,'   
                +'Parent_SFID__r.Role_Descr__c FROM Account_Communications__r' 
                +' WHERE   Archive_Ind__c = \'N\' AND  Parent_SFID__r.Archive_Ind__c = \'N\' AND   Parent_SFID__r.Parent_SFID__r.Archive_Ind__c = \'N\''
                +' AND   RecordType.DeveloperName = \'Account_Communication_Address_Role_Business_Role\' AND  Parent_SFID__r.Role_Descr__c = \'Business\''
                +' LIMIT 1)'
                +' FROM  Account_Business_Role__c'
                +' WHERE Account_SFID__c =: territoryaccIds'
                +' AND Archive_Ind__c = \'N\''
                +' AND   Account_SFID__r.Archive_Ind__c = \'N\'' + finalwhere + ' AND Account_SFID__r.Name LIKE \'%'+searchString+'%\' LIMIT 50';
            
            try{
                System.debug('accListQuery' + accListQuery);
                accountRecordsList = Database.query(accListQuery);
                System.debug('accountRecordsList' + accountRecordsList);
            }
            catch(Exception e){
                system.debug('Error Occured on getting the account communication detais. =========>'+e.getMessage());
            }  
            
            for(Account_Business_Role__c accRoleList : accountRecordsList){
                accountIds.add(accRoleList.Account_SFID__c);
            }
            
            searchString = '\'*'+searchString+'*\'';
            String soslQuery = 'FIND :searchString IN '+searchfield+' FIELDS RETURNING '
                + type +'(Id,'+fields+' Where Id IN :accountIds ORDER BY '+searchfield+') LIMIT 20';
            System.debug('SOSL QUERY: '+soslQuery);
            List<List<SObject>> results =  Search.query(soslQuery);
            
            system.debug('results[0]=>'+results[0]);
            return JSON.serialize(results[0]);
        }
        else{
            searchString = '\'*'+searchString+'*\'';
            String soslQuery = 'FIND :searchString IN '+searchfield+' FIELDS RETURNING '
                + type +'(Id,'+fields+conditions+' ORDER BY '+searchfield+') LIMIT 20';
            System.debug('SOSL QUERY: '+soslQuery);
            List<List<SObject>> results =  Search.query(soslQuery);
            
            /*List<SearchResult> output = new List<SearchResult>();
            if(results.size()>0){
                for(SObject sobj : results[0]){
                    SearchResult sr = new SearchResult();
                    sr.id = (String)sobj.get('Id');
                    sr.Name = (String)sobj.get('name');
                    sr.email = (String)sobj.get('email');
                    output.add(sr)   ;
                }
            }*/
            system.debug('results[0]=>'+results[0]);
            return JSON.serialize(results[0]);
        }
    }

}