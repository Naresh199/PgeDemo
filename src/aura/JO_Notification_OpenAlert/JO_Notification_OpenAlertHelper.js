({
    getChildRecors : function(component,event) {
        var action = component.get('c.getAlerts');
        action.setParams({
            'RecId':component.get('v.recordId'),
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.ListOfAlerts', response.getReturnValue());
                if (response.getReturnValue() == 0) {
                    component.set("v.error",true);     
                }else{
                    component.set("v.renderCheckbox",true);  
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    addSelectedHelper:function(component, event, selectRecordsIds){
        debugger;
        var action = component.get('c.getSelectedRecords');
        action.setParams({
            "lstRecordId": selectRecordsIds
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message":$A.get('$Label.c.SucessfulUpdation')
                });
                toastEvent.fire();
                this.getChildRecors(component,event);
              }
            });
        $A.enqueueAction(action);
    },
})