({
    doinit : function(component, event, helper) {
       
        var action = component.get('c.getEmailtemplate');	
        action.setParams({'RecId':component.get('v.recordId')});
        debugger;
        action.setCallback(this,function(a){
            if(a.getState()=='SUCCESS'){
                debugger;
                component.set('v.CommTemp',a.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);
    },
     displaydetailpage : function(component, event, helper){        
         var emailId = event.getSource().get("v.value");
         if(emailId!=null )
         {
            window.open("https://drmiuat--drmsuat.lightning.force.com/one/one.app#/sObject/"+emailId);        
         }
         else 
         {
             alert('Please check the data.');
         }
    },
    sendEmailInfo :  function(component, event, helper){
        var emailId = event.getSource().get("v.value");
    	$A.createComponent(
            "c:JO_Custom_Email",
            {   
                'aura:id': 'dynamicChild',
                'title' : '',
                "emailId":emailId,
                "recordsendId":component.get('v.recordId')
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
    }
   
})