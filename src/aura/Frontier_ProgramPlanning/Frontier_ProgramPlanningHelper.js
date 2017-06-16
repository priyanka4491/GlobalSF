({
	helperchangeProgram : function(component,event,helper,isInitialize) {
        
        component.set("v.tempAccountSelectedList",null);
        component.set("v.tempAccountList",null);
        
        component.set("v.isAllSelected",false); 
        if(component.get("v.searchString") != undefined){
            component.set("v.searchString","");
            component.set("v.searchText","");
        }
        if(component.find("searchByRADL") != undefined){
         component.find("searchByRADL").set("v.value","None");
        }
        var progId;
        if(!isInitialize){  
            
            component.set("v.isReviewed",false);            
            progId = event.getParam("progId"); 
        }
        else if(isInitialize && (component.get("v.progId") == '')){
            console.log('Redirect from review page');
           
            progId = 'Null';
        }
        else if(isInitialize && (component.get("v.progId") != null)){
             component.set("v.isReviewed",true);
            progId = component.get("v.progId");
            component.set("v.searchString",'');
            component.set("v.radlKey",'None');
        }
        var action = component.get("c.getProgramList");
        action.setParams({
            "progId": progId,
            "dealerId" : ((component.get("v.dealerId") == null || component.get("v.dealerId") == '' || component.get("v.dealerId") == undefined) ? 'Null' : component.get("v.dealerId"))
        });
        
        
         action.setCallback(this, function(response) {
           var state = response.getState();
            var programList = response.getReturnValue();
                          
             if(state == 'SUCCESS'){
                 component.set("v.programList", JSON.parse(programList[0]));
                 var program = JSON.parse(programList[1]);
                 component.set("v.currentPage",1);
                 component.set("v.Noofpages",10);
                 component.set("v.tablePageSize",5);
                 component.set("v.loadprograms",true);
                 
                 component.set("v.programDetail",JSON.parse(programList[1]));
                 console.log('IIIIIIIIIIII'+JSON.stringify(programList[1]));
                 
                 
                 var prgId = program.Id;
                 component.set("v.progId",prgId);
                                  console.log('<<<<<<<<<<<<<<<<<<<<<'+component.get("v.progId"));
                 if(programList[2] != ''){
                     console.log('EEEEEEEEE'+JSON.stringify(JSON.parse(programList[2])));
                     component.set("v.productList",JSON.parse(programList[2]));
                 }
                 
          var myEvent = $A.get("e.c:Frontier_ProgramHighlightEvent");
        myEvent.setParams({"programId": component.get("v.progId")});
        myEvent.fire();
                 if(component.isValid()){ 
            /*  $A.createComponent(
            "c:Frontier_ProgramPlanning_Chart",
            {
                program1:10,
                program2:20,
                program3:30
            },
            function(newCmp){
                console.log('Dynamiccccc'+newCmp);
               
                var cmp = component.find("chartDiv");
                if(cmp != undefined){
                    cmp.set("v.body", newCmp);
                }
                
            }
        ); */  
                 var programDetail = programList[1];
               this.radlCount(component,event,helper,programDetail);
               }
                 
             }
             else{
                 console.log(response.getState());
             }
        });
        $A.enqueueAction(action);
	},
    getAllAccounts : function(component,page,searchKey,radlKey,isInitialize,isSelected) {  
        console.log('Searchkey----------'+searchKey+'radlKey--------'+radlKey+'isSelected---'+isSelected);
        var program = component.get("v.programDetail");
        var pgmId = component.get("v.progId");
        var progId;
        if(!isInitialize){
            progId = component.get("v.progId");
        }
        else if(isInitialize && component.get("v.progId") == null){
            progId = 'Null';
        }
        else if(isInitialize && component.get("v.progId") != null){
            progId = component.get("v.progId");
        }
        if(radlKey == null){
            radlKey = 'None';
        }
       var action = component.get("c.getAccounts");
        action.setParams({ 
            searchKey : (searchKey == undefined || searchKey == null ? '' : searchKey), 
            radlKey : radlKey,
            pageSize : component.get("v.pageSize"),
            pageNumber : page,
            progId : progId,
            dealerId : ((component.get("v.dealerId") == null || component.get("v.dealerId") == '' || component.get("v.dealerId") == undefined) ? 'Null' : component.get("v.dealerId"))

        });
        
        //var action = component.get("c.setAccounts");
        action.setCallback(this, function(response) {
            var accounts = [];
            component.set("v.page",page);
            var accountList = response.getReturnValue();
            component.set("v.pages",Math.ceil((accountList[0])/component.get("v.pageSize")));
            component.set("v.total",accountList[0]);
            accounts = JSON.parse(accountList[1]);
            component.set("v.accounts", accounts); 
            
            if(component.get("v.accountIdsToDelete") == null){
            	//component.set("v.accountIdsToDelete",JSON.parse(accountList[2]));
            }
            if(!isSelected || component.get("v.isProgramChange")){
            component.set("v.accountSelectedList",JSON.parse(accountList[2]));
                console.log('isSelected'+isSelected);
             //component.set("v.deletedAccountIds",JSON.parse(accountList[2])); 
            }
            else {
                var accountSelected = JSON.parse(accountList[2]);
                var deletedAccounts = JSON.parse(accountList[2]);
             var accountsSel = component.get("v.accountSelectedList");
                var index;
                
               
                if(accountSelected != null){
					for (var i=0; i<accountSelected.length; i++) {
                     if(accountsSel != null){
                           
    				index = accountsSel.indexOf(accountSelected[i]);
    				if (index > -1) {
        				accountsSel.splice(index, 1);
    				}
					}
                       
                    }
            }
                
                if(component.get("v.accountIdsToDelete") != null){
                    var removeDeletedAccounts = component.get("v.accountIdsToDelete");
                    for (var i=0; i<removeDeletedAccounts.length; i++) {
    				index = accountsSel.indexOf(removeDeletedAccounts[i]);
    				if (index > -1) {
        				accountsSel.splice(index, 1);
    				}
					}
                }
               component.set("v.accountSelectedList",accountsSel);
              // component.set("v.deletedAccountIds",accountsSel);
		      }
            // To disable the Review button upon selecting the account
            var selectedAccountCount = component.get("v.accountSelectedList");
            selectedAccountCount = ((selectedAccountCount != null && selectedAccountCount.length > 0) ? selectedAccountCount.length : 0);
            component.set("v.selectedAccountCount",selectedAccountCount);
            if(selectedAccountCount == 0){
                component.set("v.notProgramSaved",true);
            }
            console.log('accountList.length'+accountList.length);
            if(accountList.length > 4){
            var accountProduct = JSON.parse(accountList[4]);
                console.log(accountProduct +'Stringifyyyyyy'+JSON.stringify(accountProduct))
            if(accountProduct != '' && accountProduct.length > 0){
                     var accountProducts = [];                     
                         for(var j = 0;j<accountProduct.length;j++){
                             accountProducts.push(accountProduct[j]);                             
                         }                     
                     if(accountProducts.length > 0){
                     component.set("v.associatedProducts",accountProducts);
                    }                             
                 }else{                    
                     component.set("v.addedProducts",null);
                 }
            }
            component.set("v.filteredAccountList",JSON.parse(accountList[3]));
            
            console.log('Inside getAllAccountsHelper');
            //if(isInitialize){
            this.applyPaginationToTable(component,event,component.get("v.accountSelectedList"),false);  
            //}
        });
        $A.enqueueAction(action);
    },
    accountListTable:function(component,event,helper){        
        
           var accounts = [];   
           var accountsToDelete = []; 
           var isChecked = event.getParam("isCheck");
           var accountId  = event.getParam("accountId");
           var temporaryAccountId = '';
           var accountList = component.get("v.accounts");
        // Accounts to delete
        var deletedAccountList = component.get("v.deletedAccountIds");
        var accountIdsToDelete = component.get("v.accountIdsToDelete");
        console.log('isChecked'+isChecked);
           if(component.get("v.accountSelectedList") != null){               
               accounts = component.get("v.accountSelectedList");
               //To avoid duplicate rows  insertion 
               for(var i =0;i<accounts.length;i++){
                   if(accountId == accounts[i].accId){
                       temporaryAccountId = accounts[i].accId;
                       break;
                   }
               }
           }
       // Reset the value that is already enabled
        if(accountIdsToDelete != null && accountIdsToDelete.length > 0){
            for(var k = 0;k<accountIdsToDelete.length;k++){
                   if(isChecked && accountId == accountIdsToDelete[k]){
                              accountIdsToDelete.splice(k,1);
                       break;
                    }           
            }
        }
        if(deletedAccountList != null && deletedAccountList.length > 0){
                   for(var j =0;j<deletedAccountList.length;j++){  
                       if(!isChecked && accountId != deletedAccountList[j].accId){
                           accountsToDelete.push(accountId); 
                           break;
                       }
                   }
               }
        else if(!isChecked){
            accountsToDelete.push(accountId); 
        }

        // To check whether the unchecked accounts are selected again or unchecked the accounts for deletion
           for(var i =0;i<accountList.length;i++){
               
               if(accountId == accountList[i].accId && temporaryAccountId != accountId && isChecked){
                   accounts.push(accountList[i]);
                   break;
               }
               /*else if(accountId == accountList[i].accId && temporaryAccountId == accountId && !isChecked){
                   console.log('Accounts to delete');
                   accountsToDelete.push(accountList[i].accId);  
                   break;
               }*/
             }
          for(var i =0;i<accounts.length;i++){
              if(accountId == accounts[i].accId  && !isChecked){
                   accounts.splice(i, 1);
                   break;
              }
           }
        
       
        if(accountsToDelete != null){
            console.log('accountsToDelete'+accountsToDelete);
                       component.set("v.accountIdsToDelete",accountIdsToDelete.concat(accountsToDelete));
        }
           component.set("v.accountSelectedList",accounts);    
        // To disable the review button if the account has been selected for the program
        var prevSelectedAccountCount = component.get("v.selectedAccountCount");
        var currentSelectedAccountCount = (accounts != null && accounts.length > 0) ? accounts.length : 0;
        if(currentSelectedAccountCount == 0 || currentSelectedAccountCount > prevSelectedAccountCount){
            component.set("v.notProgramSaved",true);
        }
        
       this.applyPaginationToTable(component,event,component.get("v.accountSelectedList"),false);  
},
    getAllPrograms:function(component,event,helper){        
        var action = component.get("c.getAllPrograms");
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS'){
            var programList = JSON.parse(response.getReturnValue());
            component.set("v.accountProgramWrapper", programList);
            }
            else{
                console.log('Error'+response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    associateProgramToAccounts:function(component,event,helper){ 
       
         var accounts =  JSON.stringify(component.get("v.accountSelectedList"));
        console.log('Accounts to insert======'+accounts);
        var accountIdsToDelete = JSON.stringify(component.get("v.accountIdsToDelete")); 
        var selectedProducts = JSON.stringify(component.get("v.selectedProducts"));
        
        console.log('selectedProducts'+selectedProducts);
        var program = component.get("v.programDetail");
        var selectedAccounts = component.get("v.accountSelectedList");
        var selectedAccountCount = ((selectedAccounts != null && selectedAccounts.length > 0) ? selectedAccounts.length : 0);
        var remainingCount = (program.Budget != 'NA' && (parseInt(program.Budget) >= program.Allocated) ? parseInt(program.Budget) - program.Allocated : 0);
		console.log('remainingCount'+remainingCount+'selectedAccounts.length'+selectedAccounts.length);
        if(selectedAccounts.length <= (remainingCount + program.Allocated) || program.Budget == 'NA')  {
        var action = component.get("c.assignProgram");
        action.setParams({
             "progId" : program.Id,
             "accounts" : accounts,
             "accountIdsToDelete" : accountIdsToDelete,
            "product" : selectedProducts
        });
             action.setCallback(this, function(a) {
                 if(a.getState() === 'SUCCESS'){
                    
                     this.showPopUp(component,event,'Saved Successfully !!');
                     component.set("v.notProgramSaved",false);
                    // alert('THE CHANGES HAS BEEN SAVED SUCCESSFULLY !!');
                    //$A.util.removeClass(component.find('removeAccountHeader'), 'slds-hide');
                    //$A.util.removeClass(component.find('removeAccount'), 'slds-hide');
                     
                 }
                 else{
                     console.log('Error Occured');
                 }
           });       
        $A.enqueueAction(action);
        }
        else {
            this.showPopUp(component,event,'Budget Exceeded');
        }
    },
    detachAccountFromProgram : function(component,event,helper,accountId){
        var program = component.get("v.programDetail");
        var action = component.get("c.removeAccountFromProgram");
        console.log('program.Id' +program.Id+'accountId'+accountId);
        action.setParams({
             "progId" : program.Id,
             "accountId" : accountId            
        });
             action.setCallback(this, function(a) {
                 if(a.getState() === 'SUCCESS'){
                     
                 }
           });       
        $A.enqueueAction(action);
    },
    ProgramDetailCount : function(component,event,helper){
        var program = component.get("v.programDetail");
        var action = component.get("c.getProgramDetailCount");
        action.setParams({
             "progId" : program.Id            
        });
             action.setCallback(this, function(a) {
                 if(a.getState() === 'SUCCESS'){
                     var programDetail = a.getReturnValue();
                    component.set("v.programDetail",JSON.parse(programDetail));
                     console.log('JSON.stringify(programDetail)'+JSON.stringify(programDetail));  
                     this.radlCount(component,event,helper,programDetail);
                 }
           });       
        $A.enqueueAction(action);        
    },
    applyPaginationToTable : function(component,event,totalRecords,isEventFired){
        component.set("v.isProgramChange",false);
        var page;
        var direction;
       
            page = component.get("v.currentPage") || 1;
                 
        direction = (isEventFired ? event.getParam("direction") :'' );
                if(direction === "previous"){
                    page = page - 1;
                }
               else if(direction === "next"){
            		page = page + 1;
               }
        
        // var totalRecords = component.get("v.accountSelectedList");
         var pageSize = component.get("v.tablePageSize");
         component.set("v.totalRecords",totalRecords.length);
         component.set("v.Noofpages",Math.ceil((totalRecords.length)/pageSize));
          var noOfRecordsToSkip = (page-1)*pageSize; 
         var accounts = [];
         for(var i = noOfRecordsToSkip; i < noOfRecordsToSkip + pageSize && i < totalRecords.length;i++){
             accounts.push(totalRecords[i]);
         }
			component.set("v.paginatedAccounts",accounts);
         component.set("v.currentPage",page);
    },
    showPopUp: function(component,event,message){  
    $A.createComponent("c:Frontier_PopUp",
                       {Message : message,
                        ComponentName : 'Frontier_ProgramPlanning'
                       },
                       function(newComp){
                           var comp = component.find("userpopup");
                           if(comp != undefined){
                           comp.set("v.body",newComp);
                           }
                       });
} ,  
    radlCount:function(component,event,helper,programDetail){
        var programDetail = JSON.parse(programDetail);
     console.log('Inside RADL'+JSON.stringify(programDetail));
                  $A.createComponent(
            "c:Frontier_ProgramPlanning_Radl",
            {
                dcount : programDetail.DevelopCount,
                acqcount : programDetail.AquireCount,
                rcount : programDetail.RetainCount,
                lcount : programDetail.LtCount
            },
            function(newCmp){
                
                var cmp = component.find("radlDivCount");
                if(cmp != undefined){
                cmp.set("v.body", newCmp);
                }
                
            }
                  );
    },
    checkAllAccounts : function(component,event,helper){
         var isAllSelected = component.get("v.isAllSelected");
             var myEvent = $A.get("e.c:Frontier_SelectAllEvent");
        myEvent.setParams({"filteredAccountList": component.get("v.filteredAccountList")});
        myEvent.setParams({"isAllSelected": isAllSelected});
        myEvent.fire();  
    },
    manipulateProduct : function(component,event,helper){
        
        var productWrapper = component.get("v.AccountProductWrapper");
        var accountId = component.get("v.triggeredAccountId");
        var productToSelect = JSON.stringify(productWrapper);
    var originalString = '"accountId":null';
    var replaceString = '"accountId":"'+accountId+'"';
        productToSelect = productToSelect.replace(originalString,replaceString);
        console.log('productToSelect'+productToSelect+'accountId'+accountId);
        var selectedProducts = component.get("v.selectedProducts"); 
        var productsToadd = new Array();
        var accountProduct = JSON.parse(productToSelect);
        console.log('accountProduct'+JSON.stringify(accountProduct));
        
        
        var associatedProducts =  component.get("v.associatedProducts");
        console.log('selectedProducts'+JSON.stringify(selectedProducts)+'JSON.stringify'+selectedProducts);
        console.log('associatedProduct'+JSON.stringify(associatedProducts));
        var isDuplicateAssociated = false;
        var isDuplicateSelected = false;
        if(associatedProducts != null && associatedProducts.length > 0){
            console.log('associatedProducts not null');
            for(var i = 0;i<associatedProducts.length;i++){
                console.log('Inside for loopppppppppp'+accountProduct.productId+'associatedProducts[i].productId'+associatedProducts[i].productId);
                if(accountProduct.accountId == associatedProducts[i].accountId 
                   && accountProduct.productId == associatedProducts[i].productId){
                    isDuplicateAssociated = true;
                    console.log('isDuplicateAssociated'+isDuplicateAssociated);
                }  
                }
            }
        
        else{
            isDuplicateAssociated = false;
        }
        
        if(selectedProducts != null && selectedProducts.length > 0){
            for(var i = 0;i<selectedProducts.length;i++){
                if(accountProduct.accountId == selectedProducts[i].accountId 
                       && accountProduct.productId == selectedProducts[i].productId){                    
                    isDuplicateSelected = true;
                    console.log('isDuplicateSelected Same Product'+isDuplicateSelected);
                }
                else if(accountProduct.accountId == selectedProducts[i].accountId  
                        && accountProduct.productId != selectedProducts[i].productId){
                    	productsToadd.push(selectedProducts[i]);
                    
                    console.log('isDuplicateSelected diff Product'+isDuplicateSelected);
                   // isDuplicateSelected = false;
                }
            }
        }
        else{
            isDuplicateSelected = false;
        }
        if(!isDuplicateAssociated && !isDuplicateSelected){
               component.set("v.ProductWrapper",accountProduct);

        }
        
        var selectedProductsToAdd = new Array();
        if((!isDuplicateAssociated && !isDuplicateSelected && selectedProducts == null) 
           || (!isDuplicateSelected && !isDuplicateAssociated)){
        	
            if(selectedProducts != null && selectedProducts.length > 0){
                for(var i = 0;i<selectedProducts.length;i++){
            	selectedProductsToAdd.push(selectedProducts[i]);
                }
            }
            selectedProductsToAdd.join(",");
            selectedProductsToAdd.push(accountProduct);
console.log('JSON Stringify selected Product'+JSON.stringify(selectedProductsToAdd));
            
            component.set("v.selectedProducts",selectedProductsToAdd);
        }
    },
     handleSubmitProgramAction : function(component,event,helper){
        console.log('Event Handled');
	      
                  if (component.isValid()) {
             $A.createComponent(
            "c:Frontier_ProgramPlanning",
            {
                
            },
            function(newCmp){
                var cmp = component.find("programBlock");
                cmp.set("v.body", []);
                cmp.set("v.body", newCmp);
            }
        );
                      
                      
                }
     }
})