({
    doInit : function(component, event, helper) {
        var action = component.get("c.getUserInfo");
        action.setStorable();
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set('v.loggeInUser' ,response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);
        //var uName = $A.get("$User.Alias");
        var timezone = $A.get("$Locale.timezone");
        //console.log('Time Zone Preference in Salesforce ORG :'+timezone);
        var mydate = new Date().toLocaleString({timeZone: timezone})
        //console.log('Date Instance with Salesforce Locale timezone : '+mydate);
        var dd = Date.parse(mydate);
        component.set('v.todate',dd);
        console.log(component.get('v.todate'));
    /*
        var localDate = new Date();        
        console.log('Local Date in Your Laptop : '+localDate);
        var timezone = localDate.getTimezoneOffset();        
        console.log('>>>>>>>>>>>>>>:'+timezone); 
        
        var now = new Date();
              
        // Returns date in the format "Jun 8, 2017"
        console.log('x :',$A.localizationService.formatDate(now));
        
        // Returns date in the format "Jan 15, 2017"
        console.log('x :',$A.localizationService.formatDate(mydate));
        
        // Returns date in the format "2017 01 15"
        console.log('x :',$A.localizationService.formatDate(mydate, "YYYY MM DD"));
        
        // Returns date in the format "June 08 2017, 01:45:49 PM"
        console.log('x :',$A.localizationService.formatDate(mydate, "MMMM DD YYYY, hh:mm:ss a"));
        
        // Returns date in the format "Jun 08 2017, 01:48:26 PM"
        console.log('x :',$A.localizationService.formatDate(mydate, "MMM DD YYYY, hh:mm:ss a"));
    */
        
    }
    
})