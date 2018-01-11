({
     hideWaiting : function (component, event, helper) {
       component.set("v.toggleSpinner", false);    },
    showWaiting : function (component, event, helper) {
       component.set("v.toggleSpinner", true);
    },
	showAlertCount : function (component,event,helper){
        debugger;
        var action = component.get("c.getjobAlerts");
        action.setStorable();
        action.setParams({
            conatcIds : component.get('v.filterContacts'),
            loggedInContact: component.get('v.loggedInContact'),
            userConfigRec : component.get('v.dashboardRec')
        })
        action.setCallback(this , function(a){
            debugger;
            var isHideCount=0,isNotHideCount=0,alertTotal=0,isActiveCount=0,isNotActiveCount=0;
            var alertArray= [];
            var state = a.getState();
               if (state === "SUCCESS"){
                debugger;
               	helper.hideWaiting(component, event, helper)
                var array = a.getReturnValue();
                alertTotal = array.length
                //console.table(alertTotal);
                for (var i = 0; i < array.length; i++) { 
                    //alertArray.push(array[i]);
                   if(array[i].isHide == true && array[i].isEnabled == true){  
                        isActiveCount+=1;    
                        alertArray.push(array[i]);                  
                    }
                   isNotHideCount = alertTotal - isActiveCount;
                }
                console.table(alertArray);
                component.set("v.alertList", alertArray);
                component.set('v.hideCount',isNotHideCount);
                component.set('v.activeCount',isActiveCount);
                component.set('v.totalAlertCount',alertTotal);
            }
           else if (state === "ERROR") {
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action)
    
    }
})