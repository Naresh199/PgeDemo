({
    doinit : function(component, event, helper) {
        var action = component.get('c.getTask');		
        action.setParams({
            'RecId':component.get('v.recordId'),
        });
        action.setCallback(this,function(a){
            if(a.getState()=='SUCCESS'){
                debugger;
                component.set('v.comTempltes',a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    displaydetailpage : function(component, event, helper){        
        var recId = event.getSource().get("v.value");
        window.open("https://drmiuat--drmsuat.lightning.force.com/one/one.app#/sObject/"+recId+"/view");       
    },
    displayRecordDetails : function(component, event, helper){
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.recid;
        window.open("https://drmiuat--drmsuat.lightning.force.com/one/one.app#/sObject/"+recId+"/view");       
    },
})