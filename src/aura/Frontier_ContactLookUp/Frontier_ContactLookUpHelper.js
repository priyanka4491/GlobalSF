({
    //typeahead already initialized
    typeaheadInitStatus : {},
    //"old value" to trigger reload on "v.value" change
    typeaheadOldValue : {},
    //suggestione function returned after a successful match
    cb: null,
    /*
    	Creates the typeahead component using RequireJS, jQuery, Bootstrap and Bootstrap Typeahead
    */
    createTypeaheadComponent: function(component){
        var inputVal='';
        var self = this;
        var globalId = component.getGlobalId();
        //loading libraries sequentially
        var inputElement = jQuery('[id="'+globalId+'_typeahead"]');
        //init the input element
        //console.log('component.get("v.nameValue")create=>'+component.get("v.nameValue"));
        //inputElement.val(component.get("v.nameValue"));
        
        //handles the change function
        inputElement.keyup(function(){
            if(inputElement.val() !== component.get('v.nameValue')){
                //component.set('v.nameValue',inputElement.val().substring(13, inputElement.val().indexOf("</td>")));
                component.set('v.value', null);
                //self.typeaheadOldValue[component.getGlobalId()] = null;
            }
        });

        //inits the typeahead
        inputElement.typeahead({
            hint: false,
            highlight: true,
            minLength: 1,
        },
		{
			name: 'objects',
            //displayKey: 'value',
            source: function(q,cb){
				//console.log('q=>'+q);
                //console.log('cb=>'+cb);
                self.cb = cb;
                q = (q || '').replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
                var compEvent = component.getEvent("inputLookupEvent");
				compEvent.setParams({"searchString" : q });
                compEvent.fire();
            },
        })
        //selects the element
        .bind('typeahead:selected', 
			function(evnt, suggestion){
    	        component.set('v.value', suggestion.objid);
                //console.log(' suggestion.value=>'+ suggestion.value);
                inputVal = suggestion.value;
                inputElement.val(suggestion.value.substring(suggestion.value.indexOf("all")+5, suggestion.value.indexOf("</span>")));
                //component.set('v.nameValue', suggestion.value.substring(13, inputElement.val().indexOf("</td>")));
	        })
        inputElement.on('blur', function(event){
            if(inputVal != ''){
               	inputElement.val(inputVal.substring(inputVal.indexOf("all")+5, inputVal.indexOf("</span>")));
            }
        })
    },
    
    /*
     * Searches objects (server call)
     */
    searchAction : function(component, searchString){
        var searchField = 'Name';
        if(!component.isValid()) return;
        
        var self = this;
        var isCustomQuery = component.get("v.isCustomQuery") ? component.get("v.isCustomQuery"):'';
        var customQueryWhere = component.get("v.customQueryWhere") ? component.get("v.customQueryWhere"):'';
        var action = component.get("c.searchSObject");
        action.setParams({
            'type' : component.get('v.type'),
            'searchString' : searchString,
            'condition' : component.get("v.condition"),   //WHERE AccountId=\'0019000000GtOozAAF\'',
            'fields' : 'Name', //Give needed API Fields of SObject
            'searchfield' : searchField,
            'isCustomQuery':isCustomQuery,
            'customQueryWhere':customQueryWhere
        });

        action.setCallback(this, function(a) {
            if(a.error && a.error.length){
                return $A.error('Unexpected error: '+a.error[0].message);
            }
            var result = a.getReturnValue();
            console.log('a.getReturnValue()=>'+a.getReturnValue());
            //console.log('Parse'+JSON.parse(result)[0].name);
            var matches, substrRegex;
            
            // an array that will be populated with substring matches
            var matches = [];
            
            // regex used to determine if a string contains the substring `q`
            var substrRegex = new RegExp(searchString, 'i');
            var strs = JSON.parse(result);
            var res = '';
            // iterate through the pool of strings and for any string that
            // contains the substring `q`, add it to the `matches` array
			//matches.push({value: '<table><tr><td><b>Name</b></td><td>Id</td></tr>',id:'select'})
            jQuery.each(strs, function(i, str) {
                if (substrRegex.test(str.Name)) {
                    // the typeahead jQuery plugin expects suggestions to a
                    // JavaScript object, refer to typeahead docs for more info
                    //matches.push({value:'<table><tr><td>'+str.value+'</td><td>'+str.id+'</td></tr></table>' , id:str.id})
                    //matches.push({value:str.value,id:str.id},{value:str.id,id:str.id});
                    var email = typeof str.Email != 'undefined' ? str.Email : '';
                    matches.push({value:'<div><span style="width:50%;word-wrap:break-all">'+str.Name+'</span><span style="width:50%;word-wrap:break-all;float:right">'+email+'</span></div>',objid:str.Id});
                }
            });
           

            if(!strs || !strs.length){
                //component.set('v.value', null);
            }
            self.cb(matches);
        });
        $A.enqueueAction(action);
    },
    
    
    /*
     * Method used on initialization to get the "name" value of the lookup
     */
    loadFirstValue : function(component) {
        
        //this is necessary to avoid multiple initializations (same event fired again and again)
        /*if(this.typeaheadInitStatus[component.getGlobalId()]){ 
			return;
        }
        
        this.typeaheadInitStatus[component.getGlobalId()] = true; */
        this.loadValue(component);
           
    },
    
    /*
     * Method used to load the initial value of the typeahead 
     * (used both on initialization and when the "v.value" is changed)
     */
    loadValue : function(component, skipTypeaheadLoading){
        //this.typeaheadOldValue[component.getGlobalId()] = component.get('v.value');
        //console.log('skipTypeaheadLoading=>'+skipTypeaheadLoading);
        var action = component.get("c.getCurrentValue");
        var self = this;
        action.setParams({
            'type' : component.get('v.type'),
            'value' : component.get('v.value'),
        });
        
        action.setCallback(this, function(a) {
            if(a.error && a.error.length){
                return $A.error('Unexpected error: '+a.error[0].message);
            }
            
            var result = a.getReturnValue();
            var globalId = component.getGlobalId();
            component.set('v.isLoading',false);
            if(result != null){
            	//component.set('v.nameValue',result.substring(13, result.indexOf("</td>")) || '');
            }
            //console.log('result=>'+result);
            if(result)jQuery('[id="'+globalId+'_typeahead"]').val(result || '');
            if(!skipTypeaheadLoading) self.createTypeaheadComponent(component);

        });
        $A.enqueueAction(action);
        
    }
})