public class JO_RestCallOut {
    
    // Method to perform callouts
    public static String MakeCallout(string JobOwnerID)
    {
        // define a response to caller
        // 
        String outcomeMsg;
        
        List<ExternalDataSource> lst = [SELECT Id, DeveloperName, CustomConfiguration , MasterLabel, Endpoint, PrincipalType, Protocol FROM ExternalDataSource where DeveloperName = 'JO_SAP'];
        
        ExternalDataSource ds = lst[0];
        
        // define basic information for later, store these in a protected custom setting
        string endpoint = ds.Endpoint; // be sure this is configured in "Remote Site Settings"
        string resource = 'PMNotifSet?';
        
        resource = resource +  '$filter=' + 'JobOwner%20eq%20%27' + JobOwnerID + '%27&$expand=Notif2Stat';
            
        string username = 'SDOCPIC'; 
        string password = 'testing1';
        string method = 'GET';  
        
        // check to ensure a callout can be performed using the Limits class. 
        // This is 100 callouts per execution as of Spring 16 release
        if (Limits.getCallouts() >= Limits.getLimitCallouts()) {
            outcomeMsg = 'Maximum number of callouts has been reached.';
            
            // check for credentials error
        } else if (endpoint == null || username == null || password == null) {
            outcomeMsg = 'Please verify your API Credentials';
            
            // configure and perform the callout
        } else {
            
            // define transaction variables
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http h = new Http();
            
            // Configure the request
            req.setEndpoint(endpoint + resource);
            req.setMethod(method);
            req.setTimeout(120000);
            
            // Add basic authentication to header
            // Create blob of user:pass
            Blob headerValue = Blob.valueOf(username + ':' + password);
            // Base 64 Encode the blob and prepend "Basic "
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            // Add the basic auth string to the Request Header
            req.setHeader('Authorization', authorizationHeader);            
            
            // Configure standard headers
            req.setHeader('Accept', '*/*');
            // This tells the API that we are sending and receiving the data as a JSON object 
            req.setHeader('Content-Type', 'application/json');
            // Additional headers may be needed / Refer to the API documentation. 
            // Use a service like runscope.com to test everything ahead of time.
            
            // Set the body json with the description parameter, basically a string with a key value pair construction.
            // This will look very different for each integration resource.  
            // Some APIs don't use a body to take the request, 
            // they may simply take additional resources "/resource/order/Ord#" in the URI 
            // or parameters "resource/?orderId=133" in the URI
            // req.setBody('{"filter" : "' + 'JobOwner%20eq%' + JobOwnerID + '"}');
            
            // Attempt the callout - create return error on exception
            try {
                
                system.debug('----- REQUEST DETAILS ----' + req);
                
                // Perform callout and set response
                res = h.send(req);
                
                // check response 
                if ((res.getStatusCode() == 200 || res.getStatusCode() == 201) && res.getBody() != null && res.getBody() != null) {
                    
                    system.debug('----- REST RESPONSE ----' + res.getBody());
                    // Deserialize the response untyped
                    Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    
                    for(String s: untypedMap.keySet())
                    {
                    	system.debug('----- REST RESPONSE RECORD ----' + s);
                    }
                    
                    // Check success of deserialization
                    // if(untypedMap.containsKey(keyToVerify)){
                    // The deserialized response contains the expected key!
                    outcomeMsg = 'Success!';
                    
                    // ---------------------------
                    // ---------------------------
                    // Insert business logic here
                    // ---------------------------
                    // ---------------------------
                    
                    // } else {
                    //   outcomeMsg = 'Error: Verify key not found in response';
                    // }
                }  
                else {
                	system.debug('-------- INVALID RESPONSE ------- ' + res);
                    outcomeMsg = 'Error: Callout failed. Please review the debug log for additional details.';
                }
                
            } catch (exception e) {
                // Unexpected exceptions will be caught here, like a deserialization error.
                // 
                system.debug('-------- RESPONSE ERROR ------- ' + e.getMessage());
                outcomeMsg = 'Error: An exception has been encountered while calling out to Integration:  ' + e.getMessage();
            }
        }
        
        // Return the response
        return outcomeMsg;
    }
    
}