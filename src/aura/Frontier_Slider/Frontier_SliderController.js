({
	 currentSlide : function(component,event,helper) {
         console.log('Target'+event.currentTarget.id);
         var idVar = event.currentTarget.id;
         var n = parseInt(idVar.split('_')[1]);
         component.set("v.slideIndex",n);
         var slideIndex = n;
      helper.showSlides(slideIndex,component);
    },
     plusSlides : function(component,event,helper) { 
          
         
          var VarId = event.currentTarget.id;
         console.log('VarId' + VarId);
         var n = parseInt(VarId.split('_')[1]);
         var slideIndex = component.get("v.slideIndex");
        
        	 slideIndex += n;         
         
         
     if(slideIndex<=3){
         component.set("v.slideIndex",slideIndex);
     helper.showSlides(component.get("v.slideIndex"),component);
     }
    },
})