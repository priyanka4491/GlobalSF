({
	rerender : function(cmp, helper){
      //  $A.util.addClass(document.getElementById(cmp.get("v.progId")), 'changeMe');
      this.superRerender();
     // document.getElementById(cmp.get("v.progId")).style = 'background:#D3D3D3;width:100%;text-align: initial;';
     cmp.set("v.highlightPanel",'background:#D3D3D3;width:100%;text-align: initial;');
        console.log('After render child'+cmp.get("v.progId"));
        console.log('After render child Id'+document.getElementById(cmp.get("v.progId")));
    
    // do custom rerendering here
}
})