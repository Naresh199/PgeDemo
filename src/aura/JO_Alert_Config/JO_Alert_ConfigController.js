({
    onLoadAlertConfig: function (component, event, helper) {
        helper.getTaskList (component, event, helper);   
        helper.getPickList (component, event, helper);
    },
  
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
        $A.createComponent(
            "c:Modal",{},
            function(newcomponent){
                if(component.isValid()){
                    var body = 	component.get("v.Tasks");
                    body.push(newcomponent);
                    component.set("v.body",body);
                }
            }
        )
    },    
    closeModel: function(component, event, helper) {
		 component.destroy();
    },  
    handleChange : function (component,event,helper) {
       helper.handle(component, event, helper);
    }, 
    saveAlert : function (component,event, helper) {
        helper.saveHandler(component, event, helper);
    },

  
    handleChange : function(component, event, helper){
        debugger;
        component.set('v.defaultOptions',event.getParam("value")); 
    }  
})