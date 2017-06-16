/********************************************************************************************
Class Name : Frontier_AccountController 
Description : 1) This class describes the sales details based on the response obtained
with respect to the account.
2) The resultant data would be used to display the chart for the current and the 
previous years sales.
Author      : Cognizant
CreatedDate : 8/1/2016
*********************************************************************************************/

public with sharing class Frontier_AccountController {
    @TestVisible private Static String Status = ''; 
    @TestVisible private Static String BayerStatus = ''; 
    @AuraEnabled
    //Method to get the Account details and serialized into callout response 
    public static String AccountDetails(String CropType, String result, Id accId){
        AccountDataWrapper AccountData = new AccountDataWrapper();
        //Get Users from group for Bayer's Demo
       
        try{
                List<FRRestAccDetail.ResponseWrapper> responseResults = new List<FRRestAccDetail.ResponseWrapper>();
                responseResults.add((FRRestAccDetail.ResponseWrapper)JSON.deserialize(result,FRRestAccDetail.ResponseWrapper.Class));
                
                if(!responseResults.isEmpty()){              
                    for(FRRestAccDetail.ResponseData ref: responseResults[0].results[0].data){  
                        accountData.TotalOpportunity = Integer.valueOf(ref.DLR_OPRTNTY_AREA_QTY);
                        if(CropType == 'Corn'){            
                            accountData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY));  
                            accountData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY));
                            accountData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CY_QTY));                    
                            accountData.PrevYearsSales = Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY);
                            accountData.PrevYearSales = Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY);
                            accountData.CYOrders = '';
                            accountData.CYSales = String.valueof(ref.CORN_NET_SLS_CY_QTY);
                            accountData.MonsantoAcres = Integer.valueOf(ref.CORN_MON_AREA_CY);
                            accountData.MonsantoShare = (Decimal.valueof(ref.MON_LAND_SHR_PCT)).setScale(0);
                        }
                        else if(CropType == 'Soy'){            
                            accountData.orderData.add(Integer.valueOf(ref.SOY_NET_SLS_CYM2_QTY));  
                            accountData.orderData.add(Integer.valueOf(ref.SOY_NET_SLS_CYM1_QTY));
                            accountData.orderData.add(Integer.valueOf(ref.SOY_NET_SLS_CY_QTY));                    
                            accountData.PrevYearsSales = Integer.valueOf(ref.SOY_NET_SLS_CYM2_QTY);
                            accountData.PrevYearSales = Integer.valueOf(ref.SOY_NET_SLS_CYM1_QTY);
                            accountData.CYOrders = '';
                            accountData.CYSales = String.valueOf(ref.SOY_NET_SLS_CY_QTY);
                            accountData.MonsantoAcres = Integer.valueOf(ref.SOY_MON_AREA_CY);
                            accountData.MonsantoShare = (Decimal.valueof(ref.MON_LAND_SHR_PCT)).setScale(0);
                        }        
                        else{
                            accountData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY));  
                            accountData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY));
                            accountData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CY_QTY));                   
                            accountData.PrevYearsSales = Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY);
                            accountData.PrevYearSales = Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY);
                            accountData.CYOrders = '';
                            accountData.CYSales = String.valueOf(ref.CORN_NET_SLS_CY_QTY);
                            accountData.MonsantoAcres = Integer.valueOf(ref.CORN_MON_AREA_CY);
                            accountData.MonsantoShare = (Decimal.valueof(ref.MON_LAND_SHR_PCT)).setScale(0);
                        }         
                    }
                }  
            
        }
        catch(Exception e){
            System.debug('The following error has been occured' + e.getMessage()); 
        }  
        return JSON.serialize(accountData);
    }
    
    
    // Wrapper class to serialize as JSON as return Value
    
    class AccountDataWrapper{
        public List<String> Labels {get;set;}
        public List<Integer> salesData {get;set;}
        public List<Integer> orderData {get;set;}
        public Integer PrevYearsSales {get;set;}
        public Integer PrevYearSales {get;set;}
        public String CYOrders {get;set;}
        public String CYSales {get;set;}
        public Integer MonsantoAcres {get;set;}
        public Decimal MonsantoShare {get;set;}
        public Integer TotalOpportunity {get;set;}
        
        public AccountDataWrapper(){
            Labels = new List<String>{'2PY Sales','PY Sales','CY Sales'};
            salesData = new List<Integer>();
            orderData = new List<Integer>();
        }
    }
    
    
}