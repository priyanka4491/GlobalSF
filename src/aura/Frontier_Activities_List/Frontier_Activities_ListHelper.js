({
    getsObjectRecords : function(component,event,page1,productID, flag) {
        console.log('inside getsobj');
        var validItem = true;
        var page = page1 || 1;
        var pageSize=component.get("v.pageSize");
        var searchText;
        var searchContactText;
        console.log(pageSize + 'pageSize');
        if (flag && typeof event.target !== 'undefined'  ){
            if(event.target.id == 'searchText' ) {
                searchText = document.getElementById(event.target.id).value;
                /* Commented By Priyanka S
                  searchContactText = (document.getElementById('searchContact').value != null ? document.getElementById('searchContact').value : '');*/
                console.log(searchText + 'searchText');
            }
             /*Commented By Priyanka S
            else if(event.target.id == 'searchContact'){
                searchContactText = document.getElementById(event.target.id).value;
                searchText = (document.getElementById('searchText').value != null ? document.getElementById('searchText').value : '');

                console.log(searchContactText + 'searchContactText');
                }*/
        }else if(flag) {
            searchText = (document.getElementById('searchText').value != null ? document.getElementById('searchText').value : '');
            /* Commented By Priyanka S
            searchContactText = (document.getElementById('searchContact').value != null ? document.getElementById('searchContact').value : '');*/
        }
        var searchType = component.find("searchType").get("v.value");
        var fromDateCmp = component.find("fromDate");
        var fromDate = fromDateCmp.get("v.value");
        console.log('From Date'+fromDate);
        var toDateCmp = component.find("toDate");
        var toDate = toDateCmp.get("v.value");
        if(flag && fromDate !== '' && toDate !== '' && toDate !== null && fromDate !== null){
            var frmActvDate = new Date(fromDate);
            var toActvDate = new Date(toDate);
            console.log(frmActvDate);
            console.log(toActvDate);
            if(frmActvDate > toActvDate){
                validItem = false;
                component.set("v.errorMsg","***From date should be less than to date***");
            }else{
                validItem = true;
                component.set("v.errorMsg","");
            }
        }
        if(!flag && document.getElementById('searchContact') != undefined){
              document.getElementById('searchContact').innerHTML = '';
        }
        if(validItem){
            if(searchText == '' || searchText == 'undefined'){
                searchText = null;
            }
            if(searchContactText == '' || searchContactText == 'undefined'){
                searchContactText = null;
            }
            if(fromDate == ''){
                fromDate = null;
            }
            if(toDate == ''){
                toDate = null;
            }
            console.log(searchText + 'searchText');
            console.log("Selected" +searchText + '' + searchType+''+fromDate+''+toDate);
            var action = component.get("c.findActivities");
            var fields = component.get("v.fields");
            action.setParams({
                ObjectName : component.get("v.object"),
                fieldstoget : fields.join(),
                pageNumber : page,
                pageSize : component.get("v.pageSize"),
                searchText : searchText,
                searchContact : searchContactText,
                searchType : searchType,
                fromDate : fromDate,
                toDate : toDate,
                accId : productID
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var visitlist = [];
                    component.set("v.latestRecords",response.getReturnValue());
                    component.set("v.page",page);
                    var retResponse = response.getReturnValue();
                    console.log("retResponse"+ retResponse);
                    component.set("v.total",JSON.parse(retResponse[0]));
                    component.set("v.pages",Math.ceil((JSON.parse(retResponse[0]))/component.get("v.pageSize")));
                    visitlist = JSON.parse(retResponse[1]);
                    component.set("v.VisitDataList", visitlist);
                }else if (state === "ERROR"){
                    console.log('Error');
                }
            });
            $A.enqueueAction(action);
        }
    }
});