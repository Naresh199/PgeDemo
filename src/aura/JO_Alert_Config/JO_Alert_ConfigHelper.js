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
            debugger;
            console.table(response.getReturnValue());
            if (response.getState() === "SUCCESS") {
                
                component.set('v.alertList', response.getReturnValue());
                component.set("v.alertType",response.getReturnValue());
                console.table(component.get('v.alertList'));
                
                var pickVal = component.get('v.alertList');
                var selectedPick = [];
                var allPick = [];
                for(var key in pickVal)
                {
                    if(pickVal[key].isHidden == true)
                    {
                        selectedPick.push(pickVal[key].Id);
                        allPick.push({ value : pickVal[key].Id , label:  pickVal[key].joAlertName});
                    }
                    else 
                        allPick.push({ value : pickVal[key].Id , label:  pickVal[key].joAlertName});
                }
                component.set("v.listOptions",allPick);
                component.set("v.defaultOptions",selectedPick);
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
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
    handle: function (component,event,helper) {
        component.set('v.defaultOptions',event.getParam("value"));
    }, 
    saveHandler: function(component, event, helper) {
        debugger;       
        var vlt = component.get("v.listOptions");
        var cmpList = component.get("v.defaultOptions");
         console.table(component.get("v.defaultOptions"));
        if(cmpList.length > 0){
            var alertLst = component.get("v.alertList")        
            for(var key in alertLst)
            {
                for(var option in cmpList)
                {
                    if(cmpList[option] == alertLst[key].Id){                    
                        alertLst[key].isHidden = true;
                       var num = parseInt(option)+1;
                       alertLst[key].sortOrder = num;  
                    }
                }
                if(!cmpList.includes(alertLst[key].Id))
                {
                    alertLst[key].isHidden = false;
                    alertLst[key].sortOrder = alertLst[key].sortOrder != 0 ? alertLst[key].sortOrder : 0; 
                }
            }
            component.set("v.alertList",alertLst);
            var action = component.get('c.saveUserConfigForAlert');
            action.setStorable();
            action.setParams({     
                filteredList: cmpList,
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
                            viscount++;
                        else
                            hidecount ++;
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
                component.destroy();
            })        
            $A.enqueueAction(action);
        }
        else alert('please select atleast one alert.')
    }
})