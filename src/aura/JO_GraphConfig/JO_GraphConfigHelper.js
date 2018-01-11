({
    setDualList: function (component, event, helper) {
        var action = component.get('c.chartConfigData');
        action.setParams({
            contactId : component.get('v.loggedInContact'),
            dashboardRec: component.get('v.dashboardRec')
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state == 'SUCCESS'){
                debugger;
                var chartWrapperData = res.getReturnValue();          
                component.set("v.listOptions",chartWrapperData.left);
                component.set('v.defaultOptions',chartWrapperData.right);
                component.set('v.userConfigId',chartWrapperData.userConfigId);
            }
            else{
                console.log('Failed::'+state);
            }
        });
        $A.enqueueAction(action);
    }    
})