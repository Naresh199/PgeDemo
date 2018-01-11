({
    filterAction : function(component, event, helper) {
        debugger;
        helper.showWaiting(component, event, helper);
        var jobOwnerIds = event.getParams().jobOwnerIds;
        var loggedInContact = event.getParams().loggedInContact;
        var dashboardRec = event.getParams().dashboardId;
        if(dashboardRec != null){
            component.set('v.jobOwnerIds',jobOwnerIds);           
            component.set('v.loggedInContact',loggedInContact);   
            component.set('v.dashboardRec',dashboardRec);    
            component.set("v.renderCharts",true);           
            helper.loadBarChart(component, event, helper);
        }  
    },
    togglePieChart: function(component,event,helper){        
        component.set("v.renderCharts",false);        
        helper.loadPieChart(component,event,helper);
    },
    toggleBarChart: function(component,event,helper){
        component.set("v.renderCharts",true);
        helper.loadBarChart(component, event, helper); 
    },   
    openModelTask : function (component,event,helper){
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Chart Help',
                "body": $A.get('$Label.c.HelpTextForGraph')
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
    openGraphConfig: function(component,event,helper){
        debugger;
        $A.createComponent(
            "c:JO_GraphConfig",
            {
                "aura:id": "dynamicChild",
                "title": 'Configure Graph',
                "loggedInContact": component.get('v.loggedInContact'),
                "jobOwnerIds": component.get('v.jobOwnerIds'),
                "dashboardRec": component.get('v.dashboardRec')
            },
            function(messageBox){
                if(component.isValid()){
                    var targetComp = component.find('displayGraphConfigModal');
                    var body = targetComp.get("v.body");
                    body.push(messageBox);
                    targetComp.set('v.body',body);
                    
                    for(var i in body){
                        var dynaC = body[i].find('dynamicChild');
                        if(dynaC != undefined)
                            dynaC.doIntOnLoad();
                    }
                
                }
            }
        )
    },
    fetchNotificationIds: function(component,event,helper){
      debugger;      
      var action = component.get('c.fetchNotificationLsts');
      action.setParams({
        jobOwnerId: component.get('v.jobOwnerIds'),
        selectedStatus: event.getParams().SelectedStatus
      });
      event.stopPropagation();
      action.setCallback(this , function(response){        
          if(response.getState() == 'SUCCESS'){            
            debugger;
            component.set('v.selectedStatus',response.getReturnValue());          
            var evnt = $A.get("e.c:JO_TaskEvent");
            evnt.setParams({ 
             "jobOwnerIds" : component.get('v.jobOwnerIds'),
             "notificationIds" : response.getReturnValue(),
            });        
            evnt.fire();
            console.log('Success in fetchNotificationIds:'+response.getState());
          }
          else{
            console.log('Error in fetchNotificationIds:'+response.getState());
          } 
        });
      $A.enqueueAction(action);
    },
})