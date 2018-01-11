({
    getDashboardViews : function(component, event, helper){
        debugger;
        var action = component.get('c.getDashboardViews');
        action.setParams({
            contactId : component.get('v.loggedInContact')
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                component.set('v.dashboardViews',response.getReturnValue());
                for(var key in response.getReturnValue())
                {
                    if(response.getReturnValue()[key].Is_Default__c == true && response.getReturnValue()[key].Is_Admin__c == false){
                      component.set("v.defaultSelection",response.getReturnValue()[key].Id);
                      component.set('v.selectedDashboard', response.getReturnValue()[key].Id); 
                      component.set('v.userConfigRec', response.getReturnValue()[key]);
                      component.set('v.dashboardId',response.getReturnValue()[key].Id);
                    }
                }
            if(component.get("v.defaultSelection") == undefined)
            {
                 for(var key in response.getReturnValue()){
                    if (response.getReturnValue()[key].Is_Admin__c == true ) {
                component.set("v.defaultSelection",response.getReturnValue()[key].Id);
              component.set('v.selectedDashboard', response.getReturnValue()[key].Id); 
              component.set('v.userConfigRec', response.getReturnValue()[key]);
              component.set('v.dashboardId',response.getReturnValue()[key].Id);
            } 

            }
               
            }
            //Add additional Logic
            var dashRec = [];
            var lst = component.get('v.dashboardViews');
            debugger;
            for(var res in lst)
            {
                 var isSelected = lst[res].Id == component.get('v.dashboardId') ? true : false;
                    dashRec.push({value:lst[res].Id, label:lst[res].View_Name__c,selected:isSelected});
            }

            component.set('v.dashbdLst',dashRec);
               var jonLst = []; 
               var selectedJob ='';

               var jobOwn =   component.get('v.userConfigRec');
             selectedJob = jobOwn.Json_Config__c;
    
                if(selectedJob.includes(','))
                {
                    jonLst = selectedJob.split(',');
                }
                else jonLst.push(selectedJob);
                component.set('v.selectedJobOwnerId',jonLst);
                var jobOwnerList = [];
                var jobOwnerlst =component.get('v.allJobOwnerRecords');  

                for(var key in jobOwnerlst){
                  var isSelected = jonLst.includes(jobOwnerlst[key].Id) ? true : false;
                    jobOwnerList.push({value:jobOwnerlst[key].Id, label:jobOwnerlst[key].JO_Corp_ID__c +'-'+ jobOwnerlst[key].FirstName+' '+jobOwnerlst[key].LastName,selected:isSelected});                   
                
                } 
                component.set('v.allJobOwners',jobOwnerList);
               // component.set('v.selectedJobOwnerId',component.get('v.loggedInContact')); 
                helper.globalCompEvent(component, event, helper, component.get('v.loggedInContact'), component.get('v.selectedJobOwnerId'), component.get('v.userConfigRec'));
            }
        });
        $A.enqueueAction(action);
    },
    /*loggedInJobOwner : function(component, event, helper){
        debugger;       
        var action = component.get("c.getloggedUser");
        action.setStorable();
        action.setCallback(this,function(rStr){
            if(rStr.getState = 'SUCCESS'){               
                component.set('v.loggedInContact',rStr.getReturnValue());
                var jobOwnerArr = new Array();
                jobOwnerArr.push(rStr.getReturnValue());  
                helper.globalCompEvent(component, event, helper, jobOwnerArr, component.get('v.loggedInContact'), component.get("v.defaultSelection"));
            }
        });
        $A.enqueueAction(action);
    },*/
    getAllJobOwnerList : function(component, event, helper){
        var action = component.get("c.getAllJobOwners");
        action.setStorable();
        action.setCallback(this,function(rval){
            if(rval.getState = 'SUCCESS'){  
                debugger;
                var jobOwnerList = [];
                var jobsOW = rval.getReturnValue();
                component.set("v.allJobOwnerRecords",jobsOW);
                for (var key in jobsOW) {
                    debugger;
                    var selectedLst = component.get('v.selectedJobOwnerId');

                    var isSelected = selectedLst.includes(jobsOW[key].Id) ? true : false;
                    jobOwnerList.push({value:jobsOW[key].Id, label:jobsOW[key].JO_Corp_ID__c +'-'+ jobsOW[key].FirstName+' '+jobsOW[key].LastName,selected:isSelected});                   
                }
                component.set('v.allJobOwners',jobOwnerList);                
            }
        });
        $A.enqueueAction(action);
    },
    periods : function(component, event, helper){

        var action = component.get("c.getPeriods");
        action.setStorable();
        action.setCallback(this,function(rval){
            if(rval.getState = 'SUCCESS'){   
                var periodsArr = [];
                var conts = rval.getReturnValue();                
                for (var key in conts ) {
                    periodsArr.push({value:conts[key], label:key});
                }
                component.set("v.allPeriods",periodsArr);
                //console.table(component.get('v.allPeriods'));
            }
        });
        $A.enqueueAction(action);
	},
    refreshJOBFinal : function (component, event, helper,typeAction){
        debugger;

        var jobOwnerRecs = component.get("v.allJobOwnerRecords");
        if(typeAction != 'Event')
        {
            var selectedDashboardId = component.find('selectV').get('v.value');
        
            if(selectedDashboardId != "" || selectedDashboardId != undefined)
            {
                component.set('v.defaultSelection',selectedDashboardId);
               component.set('v.dashboardId',selectedDashboardId); 
            }
        }
        
        var selectedDashboard = component.get("v.dashboardViews");  
        /*var selectedContact = $('[id$=picklist]').select2("val");
        component.set('v.selectedJobOwnerId',selectedContact);*/ 
        var jonLst = []; 
        for(var key in selectedDashboard)
        {
            if(selectedDashboard[key].Id == component.get('v.dashboardId')){
               component.set("v.userConfigRec",selectedDashboard[key]);  
               
            }
        }
        var selectedJob =  component.get("v.userConfigRec").Json_Config__c;
        if(selectedJob.includes(','))
        {
            jonLst = selectedJob.split(',');
        }
        else jonLst.push(selectedJob);
        component.set('v.selectedJobOwnerId',jonLst);
        
        var jobOwnerList =[];
        var jobsOW = component.get("v.allJobOwnerRecords");
        for (var key in jobsOW) {
        var isSelected = (jonLst.includes(jobsOW[key].Id)) ? true : false;
        jobOwnerList.push({value:jobsOW[key].Id, label:jobsOW[key].JO_Corp_ID__c +'-'+ jobsOW[key].FirstName+' '+jobsOW[key].LastName,selected:isSelected});                   
        }
        component.set('v.allJobOwners',jobOwnerList); 

        helper.globalCompEvent(component, event, helper, component.get('v.loggedInContact'), component.get("v.selectedJobOwnerId"), component.get("v.userConfigRec"));        
    },
    globalCompEvent : function(component, event, helper, loggedInContact, jobOwnerIds, dashboardId){  
    debugger;       
        var evnt = $A.get('e.c:JO_GlobalFilterEvent');
        evnt.setParams({
            "loggedInContact" : loggedInContact,
            "jobOwnerIds" : jobOwnerIds,
            "dashboardId" : dashboardId
        });        
        evnt.fire();
    },
    openDashBoardModel : function(component, event, helper){ 
        debugger;
        var selectedConatct = $('[id$=picklist]').select2("val");
        component.set('v.selectedJobOwnerId',selectedConatct);
        $A.createComponent(
            "c:JO_Dashboard_Config",
            {
                'aura:id': 'dynamicChild',
                'title' : 'Dashboard Configuration',
                'dashboardId' : component.get("v.dashboardId"),   //'0032F000005tC2F' //component.get('v.contactId')
                'loggedInContact': component.get("v.loggedInContact"),
                'globalFilterContacts': component.get("v.selectedJobOwnerId"),
                'dashboardRecords': component.get("v.dashboardViews")
                //'dashboardRec': component.get('v.dashboardRec')
            },
            function(msgBox){
                if(component.isValid()){
                    var targetCmp = component.find('dashboardBody');
                    var body = targetCmp.get('v.body');
                    body.push(msgBox);
                    targetCmp.set('v.body', body);
                }
                for(var i in body){
                    debugger;
                    var dynaC = body[i].find('dynamicChild');
                    if(dynaC != undefined)
                        dynaC.doIntOnLoad();
                }
            }
        );
    },
    
    updateOptions : function(component, helper){ 
        debugger;
       var newOption = component.get("v.dashboardViews");        
        component.set("v.dashboardViews",newOption);
    }
    
})