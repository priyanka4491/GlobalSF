/********************************************************************************************
Class Name : Frontier_SalesOrderController 
Description : 1) This class describes the sales details based on the response obtained
with respect to the account.
2) The resultant data would be used to display the chart for the current and the 
previous years sales.
Author      : Cognizant
CreatedDate : 8/1/2016
*********************************************************************************************/

public with sharing class Frontier_SalesOrderController {    
    @AuraEnabled
    //Method to get the SalesDetails based on the Response result
    public static String SalesDetails(String CropType,String result,Id accId){   
        System.debug('Results Obtained =================>'+result); 
        Map<String,BayersSettings__c> bayerSetting = new Map<String,BayersSettings__c>();
            for(BayersSettings__c bayer : BayersSettings__c.getAll().values()) {
            bayerSetting.put(bayer.Name,bayer);
            }
        List<FRRestAccDetail.ResponseWrapper> responseResults = new List<FRRestAccDetail.ResponseWrapper>();
        responseResults.add((FRRestAccDetail.ResponseWrapper)JSON.deserialize(result,FRRestAccDetail.ResponseWrapper.Class));
        SalesOrderDataWrapper salesOrderData = new SalesOrderDataWrapper();
        if(!responseResults.isEmpty()){              
            for(FRRestAccDetail.ResponseData ref: responseResults[0].results[0].data){                 
                if(CropType == 'Corn'){            
                    salesOrderData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY));  
                    salesOrderData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY));
                    salesOrderData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CY_QTY));
                    salesOrderData.salesData.add(0);
                    salesOrderData.salesData.add(300);
                    salesOrderData.salesData.add(0);
                    salesOrderData.PrevYearsSales = Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY);
                    salesOrderData.PrevYearSales = Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY);
                    salesOrderData.CYOrders = '';
                    salesOrderData.CYSales = String.valueof(ref.CORN_NET_SLS_CY_QTY);
                    salesOrderData.MonsantoAcres = Integer.valueOf(ref.CORN_MON_AREA_CY);
                    salesOrderData.MonsantoShare = (Decimal.valueof(ref.MON_LAND_SHR_PCT)).setScale(0);
                }
                else if(CropType == 'Soy'){            
                    salesOrderData.orderData.add(Integer.valueOf(ref.SOY_NET_SLS_CYM2_QTY));  
                    salesOrderData.orderData.add(Integer.valueOf(ref.SOY_NET_SLS_CYM1_QTY));
                    salesOrderData.orderData.add(Integer.valueOf(ref.SOY_NET_SLS_CY_QTY));
                    salesOrderData.salesData.add(0);
                    salesOrderData.salesData.add(300);
                    salesOrderData.salesData.add(100);
                    salesOrderData.PrevYearsSales = Integer.valueOf(ref.SOY_NET_SLS_CYM2_QTY);
                    salesOrderData.PrevYearSales = Integer.valueOf(ref.SOY_NET_SLS_CYM1_QTY);
                    salesOrderData.CYOrders = '';
                    salesOrderData.CYSales = String.valueOf(ref.SOY_NET_SLS_CY_QTY);
                    salesOrderData.MonsantoAcres = Integer.valueOf(ref.SOY_MON_AREA_CY);
                    salesOrderData.MonsantoShare = (Decimal.valueof(ref.MON_LAND_SHR_PCT)).setScale(0);
                }        
                else{
                    salesOrderData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY));  
                    salesOrderData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY));
                    salesOrderData.orderData.add(Integer.valueOf(ref.CORN_NET_SLS_CY_QTY));
                    salesOrderData.salesData.add(0);
                    salesOrderData.salesData.add(300);
                    salesOrderData.salesData.add(0);
                    salesOrderData.PrevYearsSales = Integer.valueOf(ref.CORN_NET_SLS_CYM2_QTY);
                    salesOrderData.PrevYearSales = Integer.valueOf(ref.CORN_NET_SLS_CYM1_QTY);
                    salesOrderData.CYOrders = '';
                    salesOrderData.CYSales = String.valueOf(ref.CORN_NET_SLS_CY_QTY);
                    salesOrderData.MonsantoAcres = Integer.valueOf(ref.CORN_MON_AREA_CY);
                    salesOrderData.MonsantoShare = (Decimal.valueof(ref.MON_LAND_SHR_PCT)).setScale(0);
                }
                
            }
        }
        
        return JSON.serialize(salesOrderData);
    }
    
    /**
* Wrapper class to serialize as JSON as return Value
* */
    class SalesOrderDataWrapper
    {
        public List<String> Labels {get;set;}
        public List<Integer> salesData {get;set;}
        public List<Integer> orderData {get;set;}
        public Integer PrevYearsSales {get;set;}
        public Integer PrevYearSales {get;set;}
        public String CYOrders {get;set;}
        public String CYSales {get;set;}
        public Integer MonsantoAcres {get;set;}
        public Decimal MonsantoShare {get;set;}
        
        public SalesOrderDataWrapper(){
            Labels = new List<String>{'2PY Sales','PY Sales','CY Sales'};
            salesData = new List<Integer>();
            orderData = new List<Integer>();
        }
    }
    
    
}