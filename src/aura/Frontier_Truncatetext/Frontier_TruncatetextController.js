({
	onload : function(component, event, helper) {
                
        if( navigator.userAgent.match(/Android/i)
           || navigator.userAgent.match(/webOS/i)
           || navigator.userAgent.match(/iPhone/i)
           || navigator.userAgent.match(/iPad/i)
           || navigator.userAgent.match(/iPod/i)
           || navigator.userAgent.match(/BlackBerry/i)
           || navigator.userAgent.match(/Windows Phone/i)
          ){
            component.set("v.isMobile",true);
        }
        else {
            component.set("v.isMobile",false);
        }
        
        var fullString = component.get("v.inputText");
        var sublength = component.get("v.truncateLength");
        var subString="";
        if((component.get("v.identifyEvtList")) == 'frmEvntList'){
           if(component.get("v.isMobile") && fullString.length > 10){
            console.log('fullString' + fullString);
            subString = fullString.substring(0,sublength);
            console.log( 'subString' + subString);
            component.set("v.truncatedText",subString);  
        }
        else if(fullString.length > 40){
            subString = fullString.substring(0,sublength);
            console.log(subString + 'subString');
            component.set("v.truncatedText",subString);
        }
            else {
                component.set("v.truncatedText",fullString);
            } 
        }
        else{
            if(component.get("v.isMobile") && fullString.length > 40){
            console.log('fullString' + fullString);
            subString = fullString.substring(0,sublength);
            console.log( 'subString' + subString);
            component.set("v.truncatedText",subString);  
        }
        else if(fullString.length > 150){
            subString = fullString.substring(0,sublength);
            console.log(subString + 'subString');
            component.set("v.truncatedText",subString);
        }
            else {
                component.set("v.truncatedText",fullString);
            }
        }
        
	}
})