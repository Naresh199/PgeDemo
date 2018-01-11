({
    getViewsList :function(component, event, helper){
        debugger;
        
        var action = component.get('c.getSendData');  
        debugger;
        action.setParams({
            "EmailID":component.get("v.emailId"),
            "RecId": component.get("v.recordsendId") 
        });
        action.setCallback(this,function(response){
            debugger;
            if(response.getState() == 'SUCCESS'){
                debugger;
                component.set('v.comTempltes',response.getReturnValue());
            }
            else
            {
                consloe.log();
            }
        });
        $A.enqueueAction(action);
    },
    sendHelper : function(component, event, helper){
        debugger;
        var action = component.get('c.sendEmailTCust'); 
        action.setParams({
            "EmailAdd":component.find("to").get("v.value"),
            "Subject":component.find("subject").get("v.value"),
            "Html":component.find("body").get("v.value"),
            "RecordId":component.get('v.recordsendId'),
            "EmailID":component.get("v.emailId")
        });
     //    "attachment":component.find("attchfile").get("v.value")
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var storeResponse = response.getReturnValue();
                component.set("v.mailStatus", true);
            }
            else
            {
                consloe.log();
            }
            
        });
        $A.enqueueAction(action);
    },
    show: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    attachfiledata : function(component) {
        debugger;
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        debugger;
        var attachfilelist=[];
        attachfilelist.push(file);
         debugger;
        component.get('v.attachlist').push(attachfilelist[0]);
        debugger;
        component.set("v.fileToBeUploaded", true);
        var fr = new FileReader();
        
        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            
          //  alert('File Name 1==>>'+file.name);
            self.upload(component, file, fileContents);
            
        };
        
        fr.readAsDataURL(file);
    },
    
    upload: function(component, file, fileContents) {
        var action = component.get("c.addfiledata"); 
      //  alert('File Name 2==>>'+file.name);
        action.setParams({
            "EmailID":component.get("v.emailId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
        
            $A.enqueueAction(action); 
        
    }
})