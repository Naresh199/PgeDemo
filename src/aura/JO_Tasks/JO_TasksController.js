({
    fireTaskEvent : function(component, event, helper) {
        debugger;
        var alertId = event.target.getAttribute("data-recId");
        var alertList = component.get('v.alertList');
        var notificationQuery = '';
        for(var i in alertList){
            if(alertList[i].alertId === alertId && alertList[i].notificationQuery != undefined)
                notificationQuery = alertList[i].notificationQuery;
        }
        if(notificationQuery != '')
        {  
            var action = component.get("c.notificationQuery");
            action.setStorable();
            action.setParams({
                "strQuery": notificationQuery,
                "jobOwnerIds" : component.get('v.filterContacts')
            }); 
            action.setCallback(this,function(res)
             { 
                 var state = res.getState();
                 var recIds = [];
                 if(state == "SUCCESS")
                 {    
                     var respo = res.getReturnValue();
                     for(var key in respo)
                     {
                        recIds.push(respo[key].Id); 
                     }
                     component.set("v.notificationIds",recIds) ;
                     var evnt = $A.get('e.c:JO_TaskEvent');//component.getEvent('passNotificationIds');
                     evnt.setParams({ 
                         "jobOwnerIds" : component.get("v.filterContacts"),
                         "notificationIds" : component.get("v.notificationIds")
                     });       
                     evnt.fire();
                 }
                 else if (state === "ERROR") {
                    var errors = res.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
             });  
            $A.enqueueAction(action);             
        }    
    },
    setContactIds : function(component, event, helper){
        helper.showWaiting(component, event, helper)
        var params = event.getParams().jobOwnerIds;
        var loggedInContact = event.getParams().loggedInContact;
        var dashboardRec = event.getParams().dashboardId;
        
        if(params != null && params.length>0){
            component.set('v.filterContacts',params);
            component.set('v.loggedInContact',loggedInContact);
            component.set('v.dashboardRec',dashboardRec);
            helper.showAlertCount (component, event, helper);
            event.stopPropagation();            
        }        
    },
   
 
    openModelTask : function (component,event,helper){
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Alert Help',
                "body": $A.get('$Label.c.JoDashHelpTextForTask')
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('ModalDialogPlaceholder');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );
	},    
    openModelConfig : function (component,event,helper)  { 
        $A.createComponent(
            "c:JO_Alert_Config",
            {
                "aura:id": "dynamicChild",
                "title": 'Alert config',
                "contactId": component.get('v.loggedInContact'),
                "jobOwnerIds": component.get('v.filterContacts'),
                "dashBoardRecId" : component.get('v.dashboardRec')                
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('AlertConfigModel');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                    
                    for(var i in body){
                        var dynaC = body[i].find('dynamicChild');
                        if(dynaC != undefined)
                            dynaC.doInitOnLoad();
                    }
                }                
            }
        );
	}
 })