({
    doInit : function(component, event, helper) {
        debugger;
       var options = component.get("v.dashboardRecords");        
        for(var key in options)
        {
            if(options[key].View_Name__c == 'Default'){
                component.set("v.defaultDashboard",options[key].Id);
            }
            if(options[key].View_Name__c == 'Default' && options[key].Id == component.get("v.dashboardId"))
            {
                component.set("v.defaultSelection",options[key].Id);
                component.set("v.defaultDashboard",options[key].Id);
                component.set("v.dashboardId",options[key].Id);
            }
            else if(options[key].View_Name__c != 'Default' && options[key].Id == component.get("v.dashboardId"))
            {
                 component.set("v.editDisabled",false);
                component.set("v.deleteDisabled",false);
                 component.set("v.cloneDisabled",false);
                 component.set("v.defaultSelection",options[key].Id);
                //component.set("v.defaultDashboard",options[key].Id);
                component.set("v.dashboardId",options[key].Id);

            }
            
        }
    },
    saveDashboard : function(component, event, helper) {
       helper.saveDashboardRec(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.destroy();
    },
    closeNotification : function(component, event, helper) {
        component.set("v.showNotif",false);
    },
    loadOption : function(component, event, helper) {
       component.set("v.defaultSelection",component.find('selectV').get('v.value'));
        component.set("v.dashboardId",component.find('selectV').get('v.value'));
        if(component.find('selectV').get('v.value') != component.get("v.defaultDashboard"))
        {
            component.set("v.editDisabled",false);
            component.set("v.deleteDisabled",false);
        }
        if(component.find('selectV').get('v.value') == component.get("v.defaultDashboard"))
        {
            component.set("v.editDisabled",true);
            component.set("v.deleteDisabled",true);
        }
        component.set("v.cloneDisabled",false);
        component.set("v.show",false);
    },
    editDashboard : function(component, event, helper) {
        component.set("v.show",true); 
        component.set("v.editDisabled",true);
        component.set("v.deleteDisabled",true);
         component.set("v.cloneDisabled",true);
        component.set("v.typeStr",'Edit');
        var rec = component.get("v.defaultSelection");
        var options = component.get("v.dashboardRecords");
        for(var key in options)
        {
            if(options[key].Id == rec)
            {
               component.set("v.dashboardActive",options[key].Is_Active__c);
                component.set("v.dashboardDefault",options[key].Is_Default__c);
                component.set("v.dashboardName",options[key].View_Name__c);
                component.set("v.dashboardId",options[key].Id);
            }
            
        }
    },
    newDashboard : function(component, event, helper) {
       component.set("v.show",true);
        component.set("v.typeStr",'New');
        component.set("v.dashboardActive",true);
        component.set("v.dashboardDefault",false);
        component.set("v.dashboardName",'');
       
    },
    deleteDashboard : function(component, event, helper) {
        component.set("v.typeStr",'Delete');     
        helper.deleteDashboardRec(component, event, helper);
    }
    
})