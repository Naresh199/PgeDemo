({ 
    displayAllTabsData : function(component, event, helper){
      helper.getViewsList(component, event, helper);
    },
    hideWaiting : function (component, event, helper) {
       component.set("v.toggleSpinner", false);    
    },
    showWaiting : function (component, event, helper) {
       component.set("v.toggleSpinner", true);
    },
    linkToSAP : function(component, event){ 
        debugger;
        var notifyVal = event.getSource().get("v.value")
        component.set('v.sapLink','https://sapdv8db1.comp.pge.com:1443/sap/bc/gui/sap/its/webgui?transaction='+notifyVal);
        window.open(component.get('v.sapLink'));  
    },
    displayPortfolioTable : function(component,event,helper){     

        debugger;
        var params = event.getParams().notificationIds;
        var records = component.get("v.jdetails");
        /*var childComponent = component.find("porforlioGridId");
        childComponent.fetchTaskEventData('a2W2F0000009wYaUAI',component.get('v.filterContacts'),component.get('v.dashboardRec'),params);
        */
        event.stopPropagation();
        var evnt  =  $A.get('e.c:JO_PortfolioEvent');
        evnt.setParams({
            viewId:'a2W2F0000009wYaUAI',  
            contactIds:component.get('v.filterContacts'),
            userConfigRec:component.get('v.dashboardRec'), 
            notificationRec:params,  
        });
        evnt.fire();

        /*var alertList = [];        
        for(var key in params){
            if(params[key].Notification_Order__c == undefined)
            {
                alertList.push(params[key]); 
            }
            
        }*/
        component.set("v.all",params); 
        component.set("v.allTabTotal",params.length);   
        //component.set("v.notificationDetails",alertList);
        //component.set("v.notifTabTotal",alertList.length);       
          
    },
    displaydetailpage : function(component, event, helper){        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.recid;
        window.open("https://drmiuat--drmsuat.lightning.force.com/"+recId);       
    },
    reFireGlobalEvent : function (component, event, helper){
        var evnt = $A.get('e.c:JO_RefreshEvent');
        evnt.fire();
        var childComponent = component.find("porforlioGridId");
        childComponent.fetchTaskEventData('Notifications__c',component.get('v.fieldSetValues'),component.get('v.filterContacts'),component.get('v.dashboardRec'));
    },
    
    openModelTask : function (component,event,helper){
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Portfolio Help',
                "body": $A.get('$Label.c.JoDashHelpTextForPortfolio')
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
    viewSettings :function (component, event, helper){
        debugger;
        var portfolio = component.get("v.body");
        $A.createComponent(
            "c:JO_HelpModel",
            {
                "title": 'Portfolio',
                "body":  portfolio
            },
            function(msgBox){                
                if (component.isValid()) {
                    var targetCmp = component.find('PortfolioPopOut');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );        
    },
    openModel : function(component, event, helper) {
		$A.createComponent(
            "c:JO_PortfolioConfig",
            {   
                'aura:id': 'dynamicChild',
                'title' : 'Portfolio Configuration',
                'contactId' : component.get("v.filterContacts"),
                'portfolioList': component.get('v.portfolioList'),
                'dashboardRec': component.get('v.dashboardRec')
            },
            function(msgBox){
                if(component.isValid()){
                    var targetCmp = component.find('pfbody');
                    var body = targetCmp.get('v.body');
                    body.push(msgBox);
                    targetCmp.set('v.body', body);
                }
                for(var i in body){
                   var dynaC = body[i].find('dynamicChild');
                   if(dynaC != undefined)
                       dynaC.doIntOnLoad();
                }
            }
        );
	},
    loadView : function(component, event,helper) {
        debugger;
        var selectVC = component.find('selectV').get('v.value'); 
        var pickVal =  selectVC.split('#');
        var viewName = pickVal[2]+'('+pickVal[1]+')';

        if(selectVC != 'None' && selectVC != 'All') {            
            helper.addTab(component, event,viewName,pickVal[2], pickVal[0]); 
        }
    },
    addContent : function(component, event,helper) {
        debugger;
        var tab = event.getSource();
        switch (tab.get('v.id')){
            case tab.get('v.id'):                
                console.table(component.get('v.all'));
                helper.getTableData(component, event,helper, tab.get('v.id').split('#')[1]);
                $A.createComponent(
                    "c:JO_PortfolioGrid",
                    {   
                        'aura:id': 'dynamicChild',
                        'sObjectName': "Notifications__c",
                        'fieldSetValues' :component.get("v.fieldSetValues"),
                        'contactIds' : component.get("v.filterContacts"),
                        'userConfigRec': component.get("v.dashboardRec")
                    },
                    function(datatable){
                        if(component.isValid()){
                            tab.set('v.body', datatable);
                        }
                        /*for(var i in body){
                           var dynaC = body[i].find('dynamicChild');
                           if(dynaC != undefined)
                              dynaC.doIntOnLoad();
                        }*/
                    }
                );
                
                         
                break;
            default : break;
        }
    },
    handleSelectedTabIdChange : function(component, event,helper) { 
        debugger;    
        var selected = component.get("v.selectTab");
    },
    refreshListViews : function(component, event,helper) {
        debugger;
        var finalArray = [];
        var existingPortfolioRec = component.get('v.portfolioList');
        var params = event.getParams().portfolioRec;  
        var type =  event.getParams().typeAct; 
        if(type == 'New')
        {
            
           component.get('v.portfolioList').push(params);
        } 
        if(type == 'Edit')
        {
            for(var key in existingPortfolioRec)
            {
              
                if(params.viewId != existingPortfolioRec[key].viewId)
                {
                    finalArray.push(existingPortfolioRec[key]);
                }
            }
            component.set('v.portfolioList',finalArray); 
            component.get('v.portfolioList').push(params);
        }
        if(type == 'Delete'){
           for(var key in existingPortfolioRec)
            {
              
                if(params.Id != existingPortfolioRec[key].viewId)
                {
                    finalArray.push(existingPortfolioRec[key]);
                }
            }
            component.set('v.portfolioList',finalArray); 
        }
        var finalLst = component.get('v.portfolioList');
        var selectV = component.find('selectV').get('v.value'); 
        var viewsList = [];
        for(var result in finalLst)
        {
         if(finalLst[result].viewName != 'Notifications' && finalLst[result].viewName != 'All')
                {
                    var isSelected = (selectV == finalLst[result].viewName) ? true : false; 
                    viewsList.push({ value : finalLst[result].viewId+'#'+finalLst[result].count+'#'+finalLst[result].viewName, label: finalLst[result].viewName, selected: isSelected}); 
                }
        }
        component.set('v.viewList', viewsList);
    }
       
   
})