({
    doInit: function(component, event, helper)
    {
        helper.getChildRecors(component, event);
    },
    
    displayRecordDetails : function(component, event, helper)
    {
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.recid;
        window.open("/one/one.app#/sObject/"+recId+"/view");       
    },
    selectAll: function(component, event, helper) 
    {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var getAllId = component.find("Checkbox");
        if(! Array.isArray(getAllId))
        {
            if(selectedHeaderCheck == true)
            { 
                component.find("Checkbox").set("v.value", true);
                component.set("v.selectedCount", 1);
            }
            else
            {
                component.find("Checkbox").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        }
        else
        {
            if (selectedHeaderCheck == true)
            {
                for (var i = 0; i < getAllId.length; i++) 
                {
                    component.find("Checkbox")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                }
            } 
            else 
            {
                for (var i = 0; i < getAllId.length; i++)
                {
                    component.find("Checkbox")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            } 
        }  
        
    },
    closeSelected: function(component, event, helper)
    {
        var tempIDs = [];
        var status=[];
        debugger;
        var getAllId = component.find("Checkbox");
        // alert('selectrd list'+getAllId);
        var alertList = component.get("v.ListOfAlerts");
        if(alertList.length==0)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":$A.get('$Label.c.NoAlerts')
            });
            toastEvent.fire();
        }
        else
        {
            if(getAllId.length != null)
            {
                for (var i = 0; i < getAllId.length; i++)
                {        
                    if (getAllId[i].get("v.value") == true)
                    {
                        tempIDs.push(getAllId[i].get("v.text"));
                        
                    }
                }
            }
            else
            {
                if (getAllId.get("v.value") == true)
                {
                    tempIDs.push(getAllId.get("v.text"));
                }
            }
            if(tempIDs.length > 0)
            {
                debugger;       
                var count = 0;
                for(var key in alertList)
                {
                    for(var id in tempIDs)
                    {
                        if(alertList[key].RecordId == tempIDs[id]) 
                        {
                            if(alertList[key].status == 'Close')
                            {
                                count = count + 1;
                            }
                        }
                    }
                }
                
                if(count == 0)
                {
                    helper.addSelectedHelper(component, event, tempIDs);
                }
                else if(count==1)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        
                        "title": "Error!",
                        "message":$A.get('$Label.c.OneClosed')
                        
                    });
                    toastEvent.fire();
                }
                else if((count==tempIDs.length) && (count>1))
                {
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "title": "Error!",
                        "message":$A.get('$Label.c.AllAlertsAreClosed')
                    });
                    toastEvent.fire();
                }
                else if( (count>1) && (count<tempIDs.length))
                {
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        "title": "Error!",
                        "message":$A.get('$Label.c.SomeClosedAlerts')
                    });
                    toastEvent.fire();
                }
                
            }
            else if(tempIDs.length == 0)
            {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Error!",
                    "message":$A.get('$Label.c.NoAlertsSelected')
                });
                toastEvent.fire();
            }
            
        }
    },
})