({
	saveDashboardRec : function(component, event, helper) {
        debugger;
        var dashboardName = component.get('v.dashboardName');        
        if(dashboardName == undefined || dashboardName == "")        
          component.set("v.msg",'Enter Dashboard Name');        
        else
        {
            var lst = component.get("v.dashboardRecords");
            for(var key in lst)
            {
                if(lst[key].View_Name__c.trim() == dashboardName && lst[key].Id != component.get('v.dashboardId'))
                {
                   component.set("v.msg",'Dashboard name should not be duplicate'); 
                   break;
                }
            }
            
            var action = component.get('c.newDashboardRecord');
            debugger;
            action.setParams({
                "dashboardId" : component.get('v.dashboardId'),
                "dashboardName" : component.get('v.dashboardName'),
                "dashboardActive" : component.get('v.dashboardActive'),               
                "loggedInContact" : component.get('v.loggedInContact'),
                "globalFilterRecs" : component.get('v.globalFilterContacts'),
                "dashboardDefault" : component.get('v.dashboardDefault'),
                "typestr": component.get('v.typeStr')
            });
            action.setCallback(this,function(response){
                if(response.getState() == 'SUCCESS'){
                    debugger;
                    var result = response.getReturnValue();
                    if(component.get('v.dashboardActive')){
                        var evnt = $A.get('e.c:JO_Dashboard_ConfigEvnt');
                        evnt.setParams({ 
                            "optiontoAdd" : result,
                            "typeofAction" : component.get('v.typeStr')
                        });        
                        evnt.fire();
                    }
                    component.destroy();
                }
            });
            $A.enqueueAction(action);
            
        }
        
		
	},
    deleteDashboardRec : function(component, event, helper) {
      
      
            var action = component.get('c.deleteDashboardRecord');
            debugger;
            action.setParams({
                "dashboardId" : component.get('v.dashboardId')
            });
            action.setCallback(this,function(response){
                if(response.getState() == 'SUCCESS'){
                    debugger;
                    var result = response.getReturnValue();
                    component.set("v.msg",'Dashboard Deleted');
                    var evnt = $A.get('e.c:JO_Dashboard_ConfigEvnt');
                    evnt.setParams({ 
                        "optiontoAdd" : result,
                        "typeofAction" : component.get('v.typeStr')
                    });        
                    evnt.fire();
                }
                component.destroy();
            });
            $A.enqueueAction(action);
            
        
    }
})