({
	 selectContact : function(component, event, helper){      
    // get the selected Account from list  
      var getSelectAccount = component.get("v.contact");
    // call the event   
      var compEvent = component.getEvent("oSelectedContactEvent");
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"conatctByEvent" : getSelectAccount });  
    // fire the event  
         compEvent.fire();
    },
})