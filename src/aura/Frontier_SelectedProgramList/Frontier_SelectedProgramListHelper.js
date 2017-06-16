({
	 applyPaginationToTable : function(component,event,totalRecords){
        //component.set("v.isProgramChange",false);
        console.log('Inside helper Pagination' +totalRecords);
        var page;
        var direction;
       
            page = component.get("v.currentPage") || 1;
                 
        direction =  event.getParam("direction");
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
         var programs = [];
         for(var i = noOfRecordsToSkip; i < noOfRecordsToSkip + pageSize && i < totalRecords.length;i++){
             programs.push(totalRecords[i]);
         }
			
         component.set("v.currentPage",page);
         component.set("v.programListAfterSkip",programs);
    }
})