({
    doInit:function(component,event,helper){
      
      var searchKey = '';
        var radlKey = 'None';
       var page = component.get("v.page") || 1;
        
      helper.helperchangeProgram(component,event,helper,true); 
      helper.getAllAccounts(component,page,searchKey,radlKey,true,false);
        
    },
    pageChange: function(component, event, helper) {
         var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'ProgramplanAccountList'){
        var page;
        var direction;
        var radlKey;
        var searchKey = component.get("v.searchString");
            radlKey = component.get("v.radlKey");
            if(searchKey == undefined){
                searchKey='';
            }
             if(radlKey == undefined )
            {
                radlKey='None';
            }
            page = component.get("v.page") || 1;
            direction = event.getParam("direction");
            page = direction === "previous" ? (page - 1) : (page + 1);
            //radlKey = component.find("searchByRADL").get("v.value");
            

        var isSelectedAccount = false;
            if(component.get("v.accountSelectedList") != '' && (radlKey == 'None' ||searchKey == '')){
            isSelectedAccount = true;
        }
       /* else if(component.get("v.deletedAccountIds") != null){
            isSelectedAccount = true;
        }*/
            if(component.get("v.isAllSelected")){
              component.set("v.isAllSelected",true); 
                //helper.checkAllAccounts(component,event,helper);
            }

            helper.getAllAccounts(component,page,searchKey,radlKey,false,isSelectedAccount);
        }        
        },
    
    
     tableChange: function(component,event,helper) {
         var cmpName = event.getParam("compName");
        console.log('cmpName' + cmpName);
        if(cmpName == 'ProgramAccount'){
         var isEventFired = true;
        helper.applyPaginationToTable(component,event,component.get("v.accountSelectedList"),isEventFired);
        }
     },
    
    searchKey: function(component, event){       
       var myEvent = $A.get("e.c:Frontier_AccountSearchkey");
        myEvent.setParams({"searchKey": event.target.value});
        myEvent.fire();
    },
    sortKey: function(component,event){
        var sortEvent = $A.get("e.c:Frontier_AccountSortkey");
        var selectCmp = component.find("searchByRADL").get("v.value");
        console.log("Selected" +selectCmp);
        sortEvent.setParams({"sortbyValue": selectCmp});
        sortEvent.fire();  
    },
    searchKeyChange: function(component, event,helper){
        var searchKey,radlKey;
        var page = 1;
        searchKey = event.getParam("searchKey");
        var isEmptySearch = false;
        radlKey = event.getParam("sortbyValue");
        console.log('searchKey----' +searchKey+'radlKey----'+radlKey+'component.get("v.searchString")'+component.get("v.searchString"));
        if(searchKey != undefined){
            component.set("v.searchString",searchKey);
            console.log('searchKey Available' +searchKey);
        }
        else if(component.get("v.searchString") != null || component.get("v.searchString") != undefined || component.get("v.searchString") != ''){
            searchKey = component.get("v.searchString");
            console.log('searchKey Retained' +searchKey)
        }
            else if(searchKey == undefined || component.get("v.searchString") == null || searchKey == '' ||
                  searchKey == null || component.get("v.searchString") == '' || component.get("v.searchString") == undefined){
                if(component.get("v.searchText") == undefined || component.get("v.searchText") == null
                  || component.get("v.searchText") == ''){
                searchKey = '';
               component.set("v.searchString",'');
                    isEmptySearch = true;
                    console.log('No searchKey' +searchKey)
                }
                
                
            }
        
         //radlKey = component.find("searchByRADL").get("v.value");
       // console.log('radlKey-----'+radlKey);
        
        
        if(radlKey != undefined || radlKey != null){
           component.set("v.radlKey",radlKey);
        }
        else if(component.get("v.radlKey") != null){
            radlKey = component.get("v.radlKey");
            console.log('Radl Key Retain----++' +searchKey)
        }
            else if(radlKey == undefined || radlKey == '' || component.get("v.radlKey") == null || radlKey == null){
                radlKey = 'None';
                 if(component.find("searchByRADL") == undefined){
                radlKey = component.set("v.radlKey",'None');
                 }
            }
                
        console.log('searchKey'+searchKey+'radlKey'+radlKey);
         var isSelectedAccount = false;
        if((component.get("v.accountSelectedList") != '') && ((radlKey == 'None' && searchKey != '')  
      || (radlKey != 'None' && searchKey == '') || (radlKey != 'None' && searchKey != '') 
                     || (radlKey == 'None' && searchKey == ''))){
            console.log('Inside selected' + radlKey+searchKey);
            isSelectedAccount = true;
        }
        console.log('searchKey--------------'+searchKey+'component.get("v.searchString")'+component.get("v.searchString"));
  
            helper.getAllAccounts(component,page,searchKey,radlKey,false,isSelectedAccount);
    },
    assignProgramToAccount:function(component,event,helper){     
        helper.associateProgramToAccounts(component,event,helper);
        helper.ProgramDetailCount(component,event,helper);
    },
    
     
    addPgm : function(component){
        
        document.getElementById("newProgramSectionId").style.display = "block";
        document.getElementById("backGroundSectionId").style.display = "block";
        
        
    },
    getDone : function(component,event,helper){
        document.getElementById("newProgramSectionId").style.display = "none";
        document.getElementById("backGroundSectionId").style.display = "none";
        component.set("v.addRadl",true);
         var searchKey;
            var page = 1;
            searchKey = (component.get("v.prevRadl") != null && component.get("v.addRadl") ? component.get("v.prevRadl") : '');
        var isSelectedAccount = false;
        if(component.get("v.accountSelectedList") != null){
            isSelectedAccount = true;
        } 
        var radlKey = component.find("searchByRADL").get("v.value");
        helper.getAllAccounts(component,page,searchKey,radlKey,false,isSelectedAccount);
       // component.set("v.clear",false);
    },
    clearData : function(component,event,helper){
        document.getElementById("newProgramSectionId").style.display = "none";
        document.getElementById("backGroundSectionId").style.display = "none";
        document.getElementById(component.get("v.prevRadl")).style='';
         component.set("v.searchString",'');
        component.set("v.prevRadl","");
        component.set("v.addRadl",false);
        var page = 1;
            var searchKey = (component.get("v.prevRadl") != null && component.get("v.addRadl") ? component.get("v.prevRadl") : '');
        var isSelectedAccount = false;
        if(component.get("v.accountSelectedList") != null){
            isSelectedAccount = true;
        } 
        var radlKey = component.find("searchByRADL").get("v.value");
        helper.getAllAccounts(component,page,searchKey,radlKey,false,isSelectedAccount);
        //component.set("v.clear",true);
    },
    changeprogram:function(component,event,helper){       
        component.set("v.associatedProducts",null); 
         component.set("v.accountSelectedList",null);
component.set("v.isProgramChange",true);
        helper.helperchangeProgram(component,event,helper,false);
        component.set("v.progId",event.getParam("progId"));
        var searchKey = '';
       var page = 1;   
        var radlKey = 'None';
        helper.getAllAccounts(component,page,searchKey,radlKey,false,false);
        
    },
    onCheck:function(component,event,helper){  
        component.set("v.isProductSelected",false);
        helper.accountListTable(component,event,helper);
    },
    
    reviewProgram:function(component,event,helper){  
        
        var progId = event.target.id;
        var header = component.find("headerSection");
        console.log('progId'+progId);
        if (component.isValid()) {
         $A.createComponent(
            "c:Frontier_Review_MasterComponent",
            {
                progId : progId,
                dealerId  : component.get("v.dealerId"),
                associatedProducts : component.get("v.associatedProducts"),
                selectedProducts : component.get("v.selectedProducts")
            },
            function(newCmp){
                var cmp = component.find("programBlock");
                cmp.set("v.body",[]);
                cmp.set("v.body", newCmp);	
            }
         );}
      
    },
    handleSubmitAction  : function(component,event,helper) {
        helper.handleSubmitProgramAction(component,event,helper);
    },
    selectRadl:function(component,event,helper){
        component.set("v.addRadl",false);
        if(component.get("v.prevRadl") != ''){
           var radl =  component.get("v.prevRadl");
            document.getElementById(radl).style = 'color:grey';
        }
        component.set("v.searchString",event.target.id);
        component.set("v.prevRadl",event.target.id);
        document.getElementById(event.target.id).style='color:black;font-weight:bold';
        
        
        
    },
    selectProduct : function(component,event){      
       
         if(component.get("v.dealerId") == null){
        document.getElementById("newProgramSectionId1").style.display = "block";
        document.getElementById("backGroundSectionId1").style.display = "block";   
         }
         else{             
         document.getElementById(component.get("v.dealerId")+"newProgramSectionId1").style.display = "block";
        document.getElementById(component.get("v.dealerId")+"backGroundSectionId1").style.display = "block";   
         }        
            
    },
    
     addProduct : function(component,event){   
         component.find("productCode").set("v.value",'None');
         component.find("ChargeType").set("v.value",'None');
         component.set("v.productQty",null);
         component.set("v.triggeredAccountId",event.target.id);
          component.set("v.isProductSelected",false);
         if((component.get("v.dealerId")) == ''){
        document.getElementById("newProgramSectionId1").style.display = "block";
        document.getElementById("backGroundSectionId1").style.display = "block";   
         }
         else{             
         document.getElementById(component.get("v.dealerId")+"newProgramSectionId1").style.display = "block";
        document.getElementById(component.get("v.dealerId")+"backGroundSectionId1").style.display = "block";   
         }
        
    },
    
    productSelection : function(component,event,helper){
        var prodcode = component.find("productCode");
        var chargeType = component.find("ChargeType");
        var Qty = component.find("Qty");
        
		var isError = false;
        if (prodcode.get("v.value") == 'None') {
           isError = true;
            prodcode.set("v.errors", [{message:"Select the product code "}]);
        }
        else if (chargeType.get("v.value") == 'None') {
           isError = true;
            chargeType.set("v.errors", [{message:"Select the charge type "}]);
        }
        else if (Qty.get("v.value") == null) {
           isError = true;
            Qty.set("v.errors", [{message:"Select the Quantity"}]);
        }
        else {
            isError = false;
            prodcode.set("v.errors", null);
            chargeType.set("v.errors",null);
            Qty.set("v.errors",null);
            
        }
        
        
        
        
        if(!isError){ 
         if(component.get("v.dealerId") == ''){
        document.getElementById("newProgramSectionId1").style.display = "none";
        document.getElementById("backGroundSectionId1").style.display = "none";   
         }
         else{             
         document.getElementById(component.get("v.dealerId")+"newProgramSectionId1").style.display = "none";
        document.getElementById(component.get("v.dealerId")+"backGroundSectionId1").style.display = "none";   
         }
        
        var productWrap;
        var productPrice = component.find("Price").get("v.value") != 'None' ? component.find("Price").get("v.value") : null;
        var productCode = component.find("productCode").get("v.value") != 'None' ? component.find("productCode").get("v.value") : null;
 
        productWrap = '{"Qty":'+(component.get("v.productQty") != null ? component.get("v.productQty") : null)+',"ProductCode":"'+((productCode != null && productCode != 'None') ? productCode.split(':')[0]:null)+'","productId":"'+((productCode != null && productCode != 'None') ? productCode.split(':')[1]:null)+'","price":'+((productPrice != null && productPrice != 'None') ? productPrice.split(':')[0]:null)+',"chargeType":"'+(component.find("ChargeType").get("v.value") != 'None' ? component.find("ChargeType").get("v.value") : null)+'","accountId":null}';
        
        console.log('Product Wrapppppppppppppp'+productWrap);
        component.set("v.AccountProductWrapper",JSON.parse(productWrap));
        component.set("v.isProductSelected",true);
        helper.manipulateProduct(component,event,helper);
        }
    },
    clearSelection : function(component,event,helper){
       /* var prodLength = component.get("v.productList") || 1;
        var selectedProducts = component.get("v.selectedProducts");        
        var accountId = component.get("v.triggeredAccountId");        
        if(selectedProducts != null && selectedProducts.length > 0){
            for(var i = 0; i < selectedProducts.length;i++){
                if(accountId == selectedProducts[i].accountId){
                    selectedProducts.splice(i, prodLength.length);
                }
            }
        }
             component.set("v.selectedProducts",selectedProducts);*/
         if(component.get("v.dealerId") == ''){
        document.getElementById("newProgramSectionId1").style.display = "none";
        document.getElementById("backGroundSectionId1").style.display = "none";   
         }
         else{             
         document.getElementById(component.get("v.dealerId")+"newProgramSectionId1").style.display = "none";
        document.getElementById(component.get("v.dealerId")+"backGroundSectionId1").style.display = "none";   
         }
        
      
    },
    removeAccount : function(component,event,helper){
        console.log('event.target.id' +event.target.id);
        if(event.target.id != undefined){
            helper.detachAccountFromProgram(component,event,helper,event.target.id);
            var searchKey = ''; 
             var page = component.get("v.page") || 1;
            var radlKey = 'None';
            var notProgramSaved = component.get("v.notProgramSaved");
            if(notProgramSaved){
               // helper.showPopUp(component,event,'Please Save');
            }
            else{
                   helper.getAllAccounts(component,page,searchKey,radlKey,true,false);
            }

            helper.ProgramDetailCount(component,event,helper);
        }
    },
    selectAllAccounts : function(component,event,helper){
       var accountSelectedList = component.get("v.accountSelectedList");
        var filteredAccountList = component.get("v.filteredAccountList");
         
        var accountList;
        if(component.get("v.isAllSelected")){     
            console.log(component.get("v.tempAccountSelectedList")+component.get("v.tempAccountList"));
            if(component.get("v.tempAccountSelectedList") == '' || component.get("v.tempAccountSelectedList") == null){
               
                if(accountSelectedList != null){
                	component.set("v.tempAccountSelectedList",accountSelectedList);
                }
            }
            if(component.get("v.tempAccountList") == '' || component.get("v.tempAccountList") == null){
                accountList = component.get("v.accounts")
                component.set("v.tempAccountList",accountList);
            }
             var selectedList = [];
           // selectedList.push(accountSelectedList);
           if((accountSelectedList != null || accountSelectedList != undefined || accountSelectedList != '') && accountSelectedList.length > 0)
           {
               for(var j = 0;j<accountSelectedList.length;j++){
                   selectedList.push(accountSelectedList[j]);
               }
           }
            
           
           
            var currentIndex;
            if(filteredAccountList != null && filteredAccountList.length > 0){               
                for(var i = 0;i<filteredAccountList.length;i++){
                    currentIndex = null;
                    if((accountSelectedList != null || accountSelectedList != undefined || accountSelectedList != '') && accountSelectedList.length > 0){
                        for(var j = 0;j<accountSelectedList.length;j++){
  							if (filteredAccountList[i].accId == accountSelectedList[j].accId) {
                                 currentIndex = i;
                                continue;
  							}                            
                        }
                        if(currentIndex == null){
                            filteredAccountList[i]['isSelected'] = true;
                        selectedList.push(filteredAccountList[i]);  
                        }
                    }
                    else{
                        selectedList.push(filteredAccountList[i]);    
                    }
                }                 
            }
            if((selectedList != null || selectedList != undefined || selectList != '') && selectedList.length > 0){
                //console.log('selectedList'+selectedList);
                //selectedList.push(accountSelectedList);
                component.set("v.accountSelectedList",selectedList);            
        		
            }
        component.set("v.accounts",filteredAccountList);
            if(accountSelectedList == undefined || accountSelectedList == null || accountSelectedList == ''){
                component.set("v.accountSelectedList",filteredAccountList);            
                }
        }
        else if(component.get("v.isAllSelected") == false){
            accountSelectedList = component.get("v.tempAccountSelectedList");
            accountList = component.get("v.tempAccountList");
            component.set("v.accountSelectedList",accountSelectedList);
            if(accountList){
                component.set("v.accounts",accountList);
            }
            console.log("accountIteration" + component.get("v.accounts"));
        }
        if(accountSelectedList != null){
        helper.applyPaginationToTable(component,event,component.get("v.accountSelectedList"),false);  
        }
       //helper.checkAllAccounts(component,event,helper);     
    },
     associateProductToAccount : function(component,event,helper){
         selectedProducts = event.getParam("selectedProducts");
         console.log('selectedProducts'+selectedProducts.length);
         if(selectedProducts != null && selectedProducts.length > 0){
        component.set("v.selectedProducts",event.getParam("selectedProducts"));
         component.set("v.isProductSelected",false);
         }
         console.log("Event Handled");
     },
    showProgramScreen : function(component,event,helper){
        var progId = event.getParam("progId");
        $A.createComponent(
            "c:Frontier_ProgramPlanning",
            {
                progId : progId
            },
            function(newCmp){
                var cmp = component.find("programBlock");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
    }

    

    
})