({
	generateView : function(component, event, helper) { 
        debugger;
		var dflst = component.get('v.portfolioList');  
        for(var df in dflst){ 
            if(dflst[df].isDefault == true){
                component.set('v.defaultPortfolio',dflst[df]);
                component.set('v.portfolio',component.get('v.defaultPortfolio')); 
                break;
            }
        }
        var pickVal = component.get('v.defaultPortfolio');
        var selectedPick = [];
        var allPick = [];
        for(var key in pickVal.viewfields)
        {
            debugger; 
             if(pickVal.viewfields[key].visible == true)
                {
                    selectedPick.push(pickVal.viewfields[key].fieldAPI);
                    allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
                }
            else
                 allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
        }
        component.set("v.listOptions",allPick);
        component.set("v.defaultOptions",selectedPick);
        
        var selectedV = component.get('v.portfolio');
        var dfViewId = selectedV.isDefault == true ? selectedV.viewId : '';
        helper.selectViews(component, dflst, dfViewId);
	},
    cloneview : function(component, event, helper){
        debugger;
        var clonedPortfolio = {};
        var portfolio = component.get("v.defaultPortfolio");
        var  viewfields = portfolio.viewfields;
		for(var f in viewfields){
            clonedPortfolio.viewfields = viewfields;
        }
        clonedPortfolio.viewId = '';
        clonedPortfolio.viewName = "";
        clonedPortfolio.sortOrder = component.get('v.portfolioList').length;
        clonedPortfolio.isAdmin = false;
        clonedPortfolio.isDefault = false;
        clonedPortfolio.isActive = true;
        component.set('v.portfolio',clonedPortfolio);        
	},
    saveNewView : function(component, event, helper){
        debugger;     
        var portfolio = component.get("v.portfolio");
        var portList = component.get('v.portfolioList');
        if(portfolio.viewName == undefined || portfolio.viewName == ""){
           component.set('v.msg', 'Enter view Name.'); 
        }
        else{

            var count = 0;
        for(var key in portList)
        {
         if(portList[key].viewName.trim() == portfolio.viewName.trim() && portList[key].viewId != portfolio.viewId){
            count = count+1;
         }   
        }
        if(count >0)
        {
           component.set('v.msg', 'View name should not be duplicate.');   
        }
        else{
        var cmpList = component.get("v.defaultOptions");
        for(var key in portfolio.viewfields)
        {
            for(var option in cmpList)
            {
                if(cmpList[option] == portfolio.viewfields[key].fieldAPI){                    
                    portfolio.viewfields[key].visible = true;
                    var num = parseInt(option)+1;
                    portfolio.viewfields[key].order = num;  
                }
            }
            if(!cmpList.includes(portfolio.viewfields[key].fieldAPI))
            {
                debugger; 
                portfolio.viewfields[key].visible = false;                
                portfolio.viewfields[key].order = 0;  
                
            }
        }
        var portfolioJSON = JSON.stringify(portfolio);
        var contact = component.get('v.contactId');
        var action = component.get('c.saveView');
        action.setParams({
            contactId : contact[0],
            userConfigRec: component.get('v.dashboardRec'),
            portfolio : portfolioJSON
            //seleArray : component.get("v.listOptions")
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                debugger;
                component.set('v.msg', 'View saved.');
                var portfolio = component.get('v.portfolio');
                //portfolio.viewId = response.getReturnValue();
                var insertedPortfolio = response.getReturnValue();
                component.get('v.portfolioList').push(insertedPortfolio);
                var evnt = $A.get('e.c:JO_Portfolio_Config_Event');
                evnt.setParams({
                    "portfolioRec" : insertedPortfolio,
                    "typeAct" : component.get("v.typeAction")                 
                });        
                evnt.fire();
                helper.selectViews(component, component.get('v.portfolioList'), portfolio.viewId);
            }
        });
        $A.enqueueAction(action);
    }
        }
    }, 
    loadViewRec : function(component, event, helper){
        debugger;
        var dflst = component.get('v.portfolioList');
        var selectV = component.find('selectV').get('v.value');
        for(var df in dflst){
            if(dflst[df].viewId == selectV){ 
                if(dflst[df].viewName != 'All')
                {
                    component.set("v.editDisabled",false);
                }
                else component.set("v.editDisabled",true);
                component.set('v.portfolio',dflst[df]); 
                break;
            }
        }
        var pickVal = component.get('v.portfolio');
        var selectedPick = [];
        var allPick = [];
        for(var key in pickVal.viewfields)
        {
            debugger; 
            if(pickVal.viewfields[key].fieldType == "LINK")
                continue;
            else{
                    if(pickVal.viewfields[key].visible == true)
                {
                    selectedPick.push(pickVal.viewfields[key].fieldAPI);
                    allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
                }
                else
                    allPick.push({ value : pickVal.viewfields[key].fieldAPI , label:  pickVal.viewfields[key].customLabel});
                }
        }
        component.set("v.listOptions",allPick);
        component.set("v.defaultOptions",selectedPick);

        helper.selectViews(component, dflst, selectV);
    },
    selectViews : function(component, dflst, selectV){
        debugger;
        var vArr = [];
        for(var df in dflst){
            if(dflst[df].viewName != 'Notifications')
            {
                var isSelected = (selectV == dflst[df].viewId) ? true : false; //(? true :false)
                vArr.push({ value : dflst[df].viewId , label: dflst[df].viewName, selected: isSelected}); 
            }
           
        }
        component.set('v.viewList', vArr);
    },
    deleteViewRec : function(component, event, helper ){
        
       var selectV = component.find('selectV').get('v.value'); 
        var action = component.get('c.deleteViewRec');
        action.setParams({
            viewId : selectV
        });
        action.setCallback(this,function(response){
            
             debugger;
             component.set('v.msg', 'View Deleted.');
             var finalLst = [];
             var dflst = component.get('v.portfolioList');
             for(var key in dflst){
                if(dflst[key].viewId != response.getReturnValue()[0].Id){
                  finalLst.push(dflst[key]);  
                }

             }
             component.set('v.portfolioList',finalLst);
            helper.generateView(component, event, helper );
        });
         $A.enqueueAction(action);
    }
})