({
    
    
    getAllJobOwnerList : function(component,event,getInputkeyWord){
        debugger;
        var action = component.get("c.getAllJobOwners");
       
     
        action.setCallback(this,function(rval){
            if(rval.getState = 'SUCCESS'){  
                debugger;
                var jobOwnerList = [], arr=[];
                var str = '';
                var jobsOW = rval.getReturnValue();
                component.set("v.allJobOwnerRecords",jobsOW);
                for (var key in jobsOW) {
                   
                    console.log('beforif'+jobsOW[key].FirstName);
                    if(jobsOW[key].FirstName.includes(getInputkeyWord)){
                       //alert('--->'+jobsOW[key].FirstName);
                        arr.push(jobsOW[key].FirstName);
                    }
                }
                component.set('v.listOfSearchRecords',arr); 
                      
                    //var isSelected = (component.get("v.loggedInContact") == jobsOW[key].Id) ? true : false;
                   // jobOwnerList.push({value:jobsOW[key].Id, label:/*jobsOW[key].JO_Corp_ID__c +'-'+*/ jobsOW[key].FirstName+' '+jobsOW[key].LastName,selected:isSelected});                   
             
                         
            }
        });
        $A.enqueueAction(action);
    },
    
    
	searchHelper : function(component,event,getInputkeyWord) {
    //    debugger;
	  // call the apex class method 
     var action = component.get("c.getAllJobOwners");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
          });
      // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})