({    
    getTableData : function(component,event,helper){
        var action = component.get("c.generateTableRecords");
        action.setParams({
            viewId : component.get('v.viewId'),
            contactId: component.get('v.contactIds'),
            userConfigRec:component.get('v.userConfigRec')
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var result = '';
                var res = [];
                var columns = response.getReturnValue();  
                for(var f in columns){
                    var labelVal = columns[f].customLabel != null ? columns[f].customLabel : columns[f].fieldApiLabel;                    
                    var fp = {label : labelVal, type : columns[f].fieldType, name : columns[f].fieldAPI};
                    res.push(fp);
                }

                console.log(res);
                component.set("v.fieldSetValues", res);
                helper.getTableRows(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    getTableRows : function(component, event, helper){
        var action = component.get("c.getNotificationRec");
        var fieldSetValues = component.get("v.fieldSetValues");
        var setfieldNames = new Set();
        
        debugger;
        for(var c=0, clang=fieldSetValues.length; c<clang; c++)
        {          
            if(!setfieldNames.has(fieldSetValues[c].name) && fieldSetValues[c].type != 'LINK') 
            {                 
                setfieldNames.add(fieldSetValues[c].name);                   
                if(fieldSetValues[c].type == 'REFERENCE') 
                {                     
                    if(fieldSetValues[c].name.indexOf('__c') == -1) 
                    {                         
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('Id')) + '.Name');                          
                    }                     
                    else 
                    {                       
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('__c')) + '__r.Name');                              
                    }                 
                }             
            }         
        }         
        var arrfieldNames = [];         
        setfieldNames.forEach(v => arrfieldNames.push(v));
        console.log(arrfieldNames);
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            criteriafield: component.get("v.criteriafield"),
            conatcIds: component.get("v.contactIds"),
            userConfigRec: component.get("v.userConfigRec"),
            fieldNameJson: JSON.stringify(arrfieldNames),
            notificationIds : component.get('v.notificationIds')
        });
        action.setCallback(this, function(response) {
            //debugger;
            if(response.getState() == 'SUCCESS'){
                component.set("v.tableRecords", response.getReturnValue());
                helper.pagination(component,event,helper, component.get("v.tableRecords"));
            }
        })
        $A.enqueueAction(action);
    },
    pagination : function(component,event, helper, tableRecords){
        debugger;
        var pageSize = component.get("v.pageSize");
        // get size of all the records and then hold into an attribute "totalRecords"
        component.set("v.totalRecords", tableRecords.length);                 
        component.set("v.pagecount", Math.ceil(component.get("v.totalRecords") / pageSize));                
        // set star as 0
        component.set("v.startPage",0);
        component.set("v.endPage",pageSize-1);

        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(tableRecords.length> i)
                PaginationList.push(tableRecords[i]);                    
            component.set("v.pageNo",(Math.ceil(component.get("v.endPage") / pageSize)));
        }
        component.set('v.PaginationList', PaginationList);
    },
    next : function(component, event, helper){
        var sObjectList = component.get("v.tableRecords");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.pageNo",(Math.ceil(component.get("v.endPage") / pageSize)));
    },
    previous : function(component, event, helper){
        var sObjectList = component.get("v.tableRecords");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.pageNo",(Math.ceil(component.get("v.endPage") / pageSize)));
    },
})