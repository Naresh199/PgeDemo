({
	getDefaultDashboard : function(component, event, helper) {
		debugger;
		var params = event.getParam("arguments");
        var action = component.get("c.getDefaultDashboardId");
        action.setStorable();
        /*actiom.setParams({});*/
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                params.callback(null, response.getReturnValue());
            } else{
                params.callback(response.getError());
            }
        });
        $A.enqueueAction(action);
	},
    getUserContact : function(component, event, helper) {
        debugger;
        var params = event.getParam("arguments");
        var action = component.get("c.getLoggedInContact");
        action.setStorable();
        /*action.setParams({
            UserId : null
        });*/
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                params.callback(null, response.getReturnValue());
            } else{
                params.callback(response.getError());
            }
        });
        $A.enqueueAction(action);
    },    
})