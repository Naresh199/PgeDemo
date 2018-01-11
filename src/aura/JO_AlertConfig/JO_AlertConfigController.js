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
    saveAlert : function (component,event, helper) {
        helper.saveHandler(component, event, helper);
    },

 onAlertTypeChange : function(component,event,helper)
    { 
        debugger;
        var listAlerts = component.get("v.alertType");
        var arrayOfAlertType = [];
        var inte = component.find("internalId").get("v.value");
        var ext = component.find("externalId").get("v.value") ;
        for (var i = 0; i < listAlerts.length; i++) 
        {
            if(inte && listAlerts[i].alertType == "Internal")                
            {
                listAlerts[i].isHidden = true;
                arrayOfAlertType.push(listAlerts[i]);               
            }
            else if(inte && !ext && listAlerts[i].alertType == "External" )
            {
                listAlerts[i].isHidden = false;
                arrayOfAlertType.push(listAlerts[i]);  
            }
            
            if(ext && listAlerts[i].alertType == "External")                
            {
                listAlerts[i].isHidden = true;
                arrayOfAlertType.push(listAlerts[i]);
            }
            else if(!inte && ext && listAlerts[i].alertType == "Internal" )
            {
                listAlerts[i].isHidden = false;
            }	
            
        }
        if(!inte && !ext )
        {
            arrayOfAlertType = listAlerts;
        }        
        component.set("v.alertList",arrayOfAlertType)
    }  
})