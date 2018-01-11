({
    doinit : function(component, event, helper) {
        var action = component.get('c.getJOStatus');		
        action.setParams({'taskId':component.get('v.recordId')});
        action.setCallback(this,function(a){
            if(a.getState()=='SUCCESS'){
                component.set('v.jobStatus',a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})