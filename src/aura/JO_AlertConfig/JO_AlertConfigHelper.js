({   
   getTaskList: function (component, event, helper) {   
       debugger;
       var action = component.get('c.getAlertWrapper'); 
       action.setStorable();
       action.setParams({
          contactId : component.get('v.contactId'),
          userConfigRec : component.get('v.dashBoardRecId')
       });
       action.setCallback(this , function(response){  
           console.table(response.getReturnValue());
           if (response.getState() === "SUCCESS") {
               debugger;
               component.set('v.alertList', response.getReturnValue());
               component.set("v.alertType",response.getReturnValue());
               console.table(component.get('v.alertList'));
           }
          
           else{
                alert('hi');
               alert('Error in getTaskList:'+response.getState());
               alert('error'+response.getError());
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
           
           }
       });            
       $A.enqueueAction(action);  
   },
   getPickList : function (component, event, helper){
        var action = component.get('c.getPrioritylists');
        action.setStorable();
        action.setParams({
            sObjectName :'Contact_Alert__c',
            picklistField :'Priority__c'
        }); 
        
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
              component.set('v.userPriority',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
   },    
   saveHandler: function(component, event, helper) {
        debugger; 
       
        var action = component.get('c.userConfigForAlert');
     
        //action.setStorable();
        console.table(component.get("v.alertList"));
        action.setParams({            
            configRec: JSON.stringify(component.get("v.alertList")),
            dashboardId: component.get("v.dashBoardRecId"),
            contactId: component.get('v.contactId')
        })
        action.setCallback(this,function(res){
     
            var state = res.getState();
            if(state == "SUCCESS"){
              
                debugger;
                console.log('111:'+res.getReturnValue());   
                component.set('v.msg',res.getReturnValue()); 
                var evntCmp = component.getEvent("chartEvnt");
                var viscount=0;
                var hidecount =0;
                 var jacw = component.get("v.alertList");
                for( var i = 0;i<jacw.length; i++)
                {
                    if(jacw[i].isHidden)
                    {
                        viscount++;
                    }
                    else
                    {
                        hidecount ++;
                    }
                }
          
                var evntCmp = component.getEvent("chartEvnt");
                debugger;
                    evntCmp.setParams({ 
                        "jobOwnerIds" : component.get('v.jobOwnerIds'),
                        "loggedInContact" : component.get('v.contactId'),
                        "dashboardId" : component.get('v.dashBoardRecId'),
                        "visiblecount" : viscount,
                        "hidecount" : hidecount
                    });   
                    evntCmp.fire();
            }
            else{
                console.log('error ctr:'+state);
            }
             component.destroy();
        })        
        $A.enqueueAction(action);
    }
})