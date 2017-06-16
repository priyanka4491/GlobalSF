({
	loadCalender : function(component, event, helper) {
				$('#mycalendar').monthly({
			mode: 'event',
			//jsonUrl: 'events.json',
			dataType: 'json',
			//xmlUrl: 'events.xml',
          events:{"monthly": [{id:1,name:"Sales Visit & Proposal",startdate:"2017-2-8",enddate:"2017-2-8",starttime:"12:00",endtime:"2:00",
                               color:"rgba(0, 255, 0, 0.498039215686275)",url:""},
                             {id:2,name:"Field Check",startdate:"2017-2-12",enddate:"2017-2-12",starttime:"11:00",endtime:"12:00",
                               color:"rgba(102, 204, 255, 1)",url:""}]}
		});
	},
    
    addNewTouchPoint : function(component, event, helper){
      console.log("I ma in lightining...");  
    }
})