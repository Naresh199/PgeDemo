({
	doinit : function(component, event, helper) {
		var action = component.get('c.getCustomerInfo');
        action.setParams({'ordId':component.get('v.recordId')});
        action.setCallback(this,function(a){
            if(a.getState()=='SUCCESS'){
                component.set('v.ordCustomer',a.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        
	}
})