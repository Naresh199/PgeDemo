({
    displayEmaildetails : function(component, event, helper) {
        helper.getViewsList(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.destroy();
    },
    sendMail : function(component, event, helper) {
        var tomail = component.find("to").get("v.value");
        if ($A.util.isEmpty(tomail) || !tomail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {
            helper.sendHelper(component, event, helper);
        }
    },
    closeMessage : function(component, event, helper) {
        location.reload();
    },
    preview :function(component, event, helper) 
    {
        debugger;
        alert('This feature is currently unavailable');
    },
    fileToBeUploaded:function(component,event,helper){
        debugger;
         helper.attachfiledata(component);
    },
})