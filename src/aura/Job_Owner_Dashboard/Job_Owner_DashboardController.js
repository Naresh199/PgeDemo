({
    hideWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", false);    },
    showWaiting : function (component, event, helper) {
        component.set("v.toggleSpinner", true);
    },
    collpasePortfolio :function (component, event, helper) {
    	component.set("v.isCollpased",event.getParams().isCollpased);
    	event.stopPropagation();
    	var isCollpased = component.find("isCollpased");
    	var isCollpased1 = component.find("isCollpased1");
        $A.util.toggleClass(isCollpased, "collapse");
        $A.util.toggleClass(isCollpased1, "collapse");
    },
    executeTest : function (component, event, helper) {
    	debugger;
	    var navEvt = $A.get("e.force:navigateToSObject");
	    navEvt.setParams({
	      "recordId": "a2W2F0000009xFPUAY",
	      "slideDevName": "detail",
	      "isredirect" : true
	    });
	    navEvt.fire();
	}
})