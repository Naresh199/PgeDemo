({
    doInit : function(component, event, helper) {
        debugger;
        if(event.getParams() != undefined && event.getType() != "aura:methodCall" && event.getType() != "aura:valueInit"){
            var params = event.getParams().notificationIds;
            component.set("v.notificationIds",params);
            event.stopPropagation(); 
           	
            if(component.get('v.tableRecords').length > 0){
                var nrecords = component.get('v.tableRecords')
                var selectRec = [];
                for(var i in nrecords){
                    for(var j in params){
                        if(nrecords[i].Id == params[j])
                            selectRec.push(nrecords[i]);
                    }                
                }
                helper.pagination(component,event,helper, selectRec);
                component.set('v.PaginationList', selectRec);
            }
        } 
        else{
            component.set("v.notificationIds",null);
            helper.getTableRows(component, event, helper);
        }
    },
    next :  function (component, event, helper) {
        helper.next(component, event, helper);
    },
    previous : function (component, event, helper) {
        helper.previous(component, event, helper);
    }
})