({
    collapsePortfolio : function(component, event, helper) {
        component.set('v.isCollapsed', true);
        var evnt = $A.get('e.c:JO_CollapseEvent');
        evnt.setParams({"isCollpased" : false});        
        evnt.fire();
        
    },
    expandPortfolio : function(component, event, helper) {
        component.set('v.isCollapsed', false);
        var evnt = $A.get('e.c:JO_CollapseEvent');
        evnt.setParams({"isCollpased" : true});        
        evnt.fire();
    },
    doinit : function(component, event, helper) {
        debugger;
        var service = component.find("service");
        service.getUserContactId($A.getCallback(function(error, data) {
            // TODO: Add error handling
            component.set('v.loggedInContact', data);
            helper.getDashboardViews(component, event, helper);
        })); 
       
        helper.getAllJobOwnerList(component, event, helper);
	},    
    scriptsLoaded : function(component, event, helper) {
       $(".select2Class").select2({
           placeholder: "Select Multiple values"
       });
	},
    backToHome : function(component, event, helper)
    {
        window.open("https://drmiuat--drmsuat.lightning.force.com/");
    },
    onChangeJobOwner  : function(component, event, helper) {
        var allJB = component.get('v.allJobOwners');
        for(var jId  in allJB){          
            if(allJB[jId].Id == component.get('v.selectedJobOwnerId')){
                component.set('v.selectedJobOwnerName',allJB[jId].Name);
                break;
            }
        }		
        console.log(component.get('v.selectedJobOwnerName'));
    },
    onChangePeriod  : function(component, event, helper) {
        var allPer = component.get('v.allPeriods');
		if(component.get('v.selectedPeriod') == 'Custom Date')
           component.set("v.customdate",true);
       
        for (var key in allPer ) {
            console.log('::::'+allPer[key].label +'::'+key +'::'+component.get('v.selectedPeriod'));
            if(allPer[key].value == component.get('v.selectedPeriod')){
            	component.set('v.selectedPeriodName',allPer[key].label);
                break;
            }
        }
        console.log(component.get('v.selectedPeriodName'));
    },
    gSearch : function(component, event, helper) { 
        window.open("https://drmiuat--drmsuat.lightning.force.com/one/one.app?source=aloha#/sObject/Notifications__c/list?filterName=00B2F000000MdLdUAK");
              
    },
    graph : function(component, event, helper) {
      
        window.open(component.get('v.joReportUrl'));
    },
    loadDashboard : function(component, event, helper){

    },
    newDashboard : function(component, event, helper){
       helper.openDashBoardModel (component, event, helper);
    },
    refreshJOBLst : function (component, event, helper){
        debugger;

        var jobOwnerRecs = component.get("v.allJobOwnerRecords");
        var selectedDashboardId = component.find('selectV').get('v.value');
        if(selectedDashboardId !="" || selectedDashboardId != undefined)
        {
           component.set('v.dashboardId',selectedDashboardId); 
        }
        
        var selectedDashboard = component.get("v.dashboardViews");  
        var selectedContact = $('[id$=picklist]').select2("val");
        component.set('v.selectedJobOwnerId',selectedContact); 
      
        for(var key in selectedDashboard)
        {
            if(selectedDashboard[key].Id == component.get('v.dashboardId')){
               component.set("v.userConfigRec",selectedDashboard[key]);  
               //selectedJob = selectedDashboard[key].Json_Config__c;
            }
        }
        /*var selectedJob =  component.get("v.userConfigRec").Json_Config__c;
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
        component.set('v.allJobOwners',jobOwnerList); */

        helper.globalCompEvent(component, event, helper, component.get('v.loggedInContact'), component.get("v.selectedJobOwnerId"), component.get("v.userConfigRec"));        
    },
    refreshJOB : function (component, event, helper){
        helper.refreshJOBFinal(component, event, helper,'onChange');
    },
    addOptiontoList : function(component, event, helper){
        debugger;
        var options = event.getParams().optiontoAdd; 
        var typeAct = event.getParams().typeofAction;
        var newOption = component.get("v.dashboardViews");
        var updateOptions = [];
        if(typeAct== 'New'){
            component.set("v.defaultSelection",options[0].Id);            
            for(var key in options)
            {
               component.get("v.dashboardViews").push(options[key]); 
                component.set("v.userConfigRec",options[key]);
                component.set('v.dashboardId',options[key].Id);
            }
            component.set("v.dashboardViews",newOption); 
        }
        if(typeAct== 'Edit'){
            component.set("v.defaultSelection",options[0].Id); 
            for(var key in newOption)
            {
                if(newOption[key].Id == options[0].Id){
                    updateOptions.push(options[0]);
                }
                else updateOptions.push(newOption[key])
                
            }
            component.set("v.dashboardViews",updateOptions); 
            for(var key1 in options)
            {
                component.set("v.userConfigRec",options[key1]);
                 component.set('v.dashboardId',options[key1].Id);
            }
                
        }
     var jonLst = []; 
     var selectedJob ='';    
    
           selectedJob = options[0].Json_Config__c;
        
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


        if(typeAct== 'Delete'){
            for(var key in newOption)
            {
                if(newOption[key].Is_Default__c == true)
                {
                    component.set("v.defaultSelection",newOption[key].Id);
                    component.set("v.userConfigRec",newOption[key]);
                     component.set('v.dashboardId',newOption[key].Id);
                }
                if(newOption[key].Id != options[0].Id)
                {
                    updateOptions.push(newOption[key]);
                }
                
            }
            component.set("v.dashboardViews",updateOptions); 

             var jonLst = []; 
     var selectedJob ='';    

           selectedJob = component.get("v.userConfigRec").Json_Config__c;
        
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
            
     }
     event.stopPropagation(); 
     component.find('selectV').set('v.value', component.get('v.dashboardId'));
     var dashRec = [];
     var lst = component.get('v.dashboardViews');
     //component.get('v.dashboardViews').clear();
        debugger;
        for(var res in lst)
        {
             var isSelected = lst[res].Id == component.get('v.dashboardId') ? true : false;
                dashRec.push({value:lst[res].Id, label:lst[res].View_Name__c,selected:isSelected});
        }
        component.set('v.dashbdLst',dashRec);
        //component.find('selectV').get('v.value') = "";
        helper.refreshJOBFinal(component, event, helper,'Event');
        debugger;    
    },
   
    handleChange : function(component, event, helper){
        debugger;
      var selectedContact = $('[id$=picklist]').select2("val");
        component.set('v.selectedJobOwnerId',selectedContact);  
    }
    
})