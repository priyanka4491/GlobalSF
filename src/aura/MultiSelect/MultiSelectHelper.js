({
  setInfoText: function(component, values) {
    
    if (values.length == 0) {
      component.set("v.infoText", "Select an option...");
    }
    if (values.length == 1) {
      component.set("v.infoText", values[0]);
    }
    else if (values.length > 1) {
      component.set("v.infoText", values.length + " options selected");
    }
  },

  getSelectedValues: function(component){
    var options = component.get("v.options_");
    var values = [];
    options.forEach(function(element) {
      if (element.selected) {
        values.push(element.value);
      }
    });
    return values;
  },

  getSelectedLabels: function(component){
    var options = component.get("v.options_");
    var labels = [];
    options.forEach(function(element) {
      if (element.selected) {
        labels.push(element.label);
      }
    });
    return labels;
  },    
    setProgramDropdownOptions : function(component,event,helper){
        var accId = component.get("v.accId");
        var programs = component.get("v.programs");
        var opt;
        var options = [];
        if(programs){
            for(var i in programs){
                opt = [{'label':'','value':'','selected':false}]
                opt.label =	programs[i].Name;
                opt.value = accId +"-"+ programs[i].Id;
                options.push(opt);
            }
        }
        if(options && options.length > 0){
            component.set("v.options",options)
        }		
    },

  despatchSelectChangeEvent: function(component,values,currentId){
    var compEvent = component.getEvent("selectChangeEvent");
    compEvent.setParams({ "values": values,"selectedId":currentId});
    compEvent.fire();
  }
})