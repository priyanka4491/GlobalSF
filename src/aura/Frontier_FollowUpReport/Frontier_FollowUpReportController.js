({
	doInit : function(component, event, helper) {
        console.log("hjghgj");
    var page = component.get("v.page") || 1;
        var ispageChange = false;
        var isInitialize = true;
	helper.getsTaskObjectRecords(component,event,helper,page,ispageChange,isInitialize,component.get("v.taskId"));	
	},
    FollowUpList:function(component,event,helper){
        //var page = component.get("v.page") || 1;
        var page = 1;
        var ispageChange = false;
        var isInitialize = true;
        if(component.get("v.prevId") != ''){
               component.set("v.SortBy"+component.get("v.prevId"),"onMouseOut");
          }
        helper.getsTaskObjectRecords(component,event,helper,page,ispageChange,isInitialize,'');
     },
    pageChange: function(component,event,helper) {
        var page = component.get("v.page") || 1;        
        var direction = event.getParam("direction");        
        page = direction === "previous" ? (page - 1) : (page + 1);
        var ispageChange = true;        
        var isInitialize = false;
        helper.getsTaskObjectRecords(component,event,helper,page,ispageChange,isInitialize,'');    
    },
  /*  showIcon : function(component,event){
        if(event.target.id != null && component.get("v.SortBy"+event.target.id) != 'onClick'){
            component.set("v.SortBy"+event.target.id,"onHover");
        }
    },
    hideIcon : function(component,event){
        if(event.target.id != null && component.get("v.SortBy"+event.target.id) != 'onClick'){
            component.set("v.SortBy"+event.target.id,"onMouseOut");
        }
    }, */
    sortDirection : function(component,event,helper){
        var previousId;
        if(event.target.id != '' && component.get("v.prevId") != '' && component.get("v.prevId") != event.target.id){
            console.log('Before'+component.get("v.SortBy"+component.get("v.prevId")));
           component.set("v.SortBy"+component.get("v.prevId"),"onMouseOut");
            console.log('After'+component.get("v.SortBy"+component.get("v.prevId")));
        }
        var page = component.get("v.page") || 1;
        if(event.target.id != ''){
        	component.set("v.SortBy"+event.target.id,"onClick");
        }
         var ispageChange = false;
        var isInitialize = false;
        component.set("v.prevId",event.target.id); 
        helper.getsTaskObjectRecords(component,event,helper,page,ispageChange,isInitialize); 
        
        
    }
})