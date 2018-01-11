({
    //Fetch the Notofication Orders from the Apex controller
    getNotificationOrders : function (component, event, helper) {        
        var action = component.get("c.getAllNotifyOrders");
        action.setParams({
            'notifyId' : component.get('v.recordId')
        });
        //Set up the callback
        debugger;
        var self = this;
        action.setCallback(this, function(response) {
            component.set("v.orders", response.getReturnValue());            
        });        
        $A.enqueueAction(action);                
    },        
})