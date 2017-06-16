public with sharing class FrontierTestController {
    
    @AuraEnabled
        public static String getAccounts(String ProductId, String result){
        List<FRRestAccDetail.ResponseWrapper> responseResults = new List<FRRestAccDetail.ResponseWrapper>();
        responseResults.add((FRRestAccDetail.ResponseWrapper)JSON.deserialize(result,FRRestAccDetail.ResponseWrapper.Class));
        AccountDataWrapper AccountData = new AccountDataWrapper();
        if(!responseResults.isEmpty()){              
            for(FRRestAccDetail.ResponseData ref: responseResults[0].results[0].data){  
                accountData.TotalOpportunity = Integer.valueOf(ref.DLR_OPRTNTY_AREA_QTY);
                if(ProductId == 'Corn'){  
                    accountData.RADLClass.add(String.valueOf(ref.DLR_RADL_CD));                                 
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
                else if(ProductId == 'Soy'){  
                    accountData.RADLClass.add(String.valueOf(ref.DLR_RADL_CD));                 
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
            }
        }
        return JSON.serialize(accountData);
    }
// Wrapper class to serialize as JSON as return Value

    class AccountDataWrapper{
        public List<String> RADLClass {get;set;}
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
            salesData = new List<Integer>();
            orderData = new List<Integer>();
        }
    }
}