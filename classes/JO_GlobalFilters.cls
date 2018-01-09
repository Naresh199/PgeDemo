public class JO_GlobalFilters {
    
    @AuraEnabled 
    public static Id getLoogedInContact(){
        return Userinfo.getUserId();
    }
    /*********Globbal filter Job Owners**********************/    
    @AuraEnabled
    public static List<Contact> getAllJobOwners() {
        
        // Added Platform Cache for Default Dashboard Record
        
        Cache.OrgPartition orgPart = JO_Util.GetJOPartition();
        
        List<Contact> ls = (List<Contact>) orgPart.get('DBUSERS');
        
        if (ls == null)
        {
            ls = [Select id, FirstName,LastName,Email,JO_Corp_ID__c, JO_Display_Name__c FROM Contact Where RecordType.DeveloperName = 'Dashboard_User' Order by JO_Corp_ID__c limit 1000];
            orgPart.put('DBUSERS',ls);
        }	
        return ls;
    }
    
    /************** To get Logged In user as default Job owner In global filters***************/
    @AuraEnabled
    public static String getloggedUser(){        
        return JO_Util.getLoggedInContact(UserInfo.getUserId());
    }
    @AuraEnabled
    public static List<Customer_Config__c> getDashboardViews(String contactId){
        List<Customer_Config__c> config = [SELECT Id, Job_Owner__c, View_Name__c, User_Config__c, Is_Active__c, Is_Admin__c, Is_Default__c, Json_Config__c
                                            FROM Customer_Config__c WHERE RecordType.Name='JO Dashboard' AND Job_Owner__c = :contactId  order by Is_Default__c desc];
        return config;  
    }
   @AuraEnabled
    public static List<Customer_Config__c> newDashboardRecord(String dashboardId, String dashboardName, boolean dashboardActive, String loggedInContact, List<String> globalFilterRecs, boolean dashboardDefault, String typestr)
    { 
        system.debug('Starting in method'+dashboardId);
         List<Customer_Config__c> returnConfig = new List<Customer_Config__c>();
         List<Customer_Config__c> updateConfig = new List<Customer_Config__c>();
         List<Customer_Config__c> relatedCustomConfig = new List<Customer_Config__c>();  
        string filteredJobOwners = '';
        for(String jb : globalFilterRecs){filteredJobOwners += jb+',';}
            filteredJobOwners = filteredJobOwners.removeEnd(',');
        if(typestr == 'New')
        {
            if(dashboardDefault == true)
            {
              List<Customer_Config__c> configrec = [Select Id,User_Config__c,Is_Active__c,Job_Owner__c,Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c 
                                                    From Customer_Config__c 
                                                    Where Job_Owner__c=:loggedInContact AND Is_Default__c=true];
             if(configrec.size() > 0)
             {
                configrec[0].Is_Default__c = false;
                 upsert configrec;
             }
            }
             
            Customer_Config__c configDashboard = new Customer_Config__c();
            configDashboard.View_Name__c = dashboardName;
            configDashboard.Job_Owner__c = loggedInContact;
            configDashboard.Json_Config__c = filteredJobOwners;
            configDashboard.Is_Active__c = dashboardActive;
            configDashboard.Is_Default__c = dashboardDefault;
            configDashboard.Is_Admin__c = false;
            configDashboard.RecordTypeId = JO_Util.getRecordTypeId('Customer_Config__c', 'JO Dashboard');
            upsert configDashboard;
            returnConfig.add(configDashboard);
            for(Customer_Config__c conf :[Select Id,User_Config__c,Is_Active__c,Job_Owner__c,Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c From Customer_Config__c Where User_Config__c=:dashboardId].clone()){
                conf.Id = null;
                conf.User_Config__c = configDashboard.Id;          
                relatedCustomConfig.add(conf);
            }
            upsert relatedCustomConfig;
            
        }
        if(typestr == 'Edit')
        {
            system.debug('>>>>>>>>'+dashboardId);
            Customer_Config__c conf = [Select Id,User_Config__c,Is_Active__c,Job_Owner__c,Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c 
                                       From Customer_Config__c Where Id=:dashboardId];
            system.debug('>>>>>'+conf);
            if(conf.Is_Default__c == dashboardDefault && dashboardDefault == true)
            {
                system.debug('>>>>>InsideOe'+conf);
                conf.View_Name__c = dashboardName;
                conf.Is_Active__c = dashboardActive;
                conf.Is_Default__c = dashboardDefault;
                conf.Json_Config__c = filteredJobOwners;
                updateConfig.add(conf);
                update updateConfig;
                returnConfig.add(conf);
            }
            else if(dashboardDefault == true)
            {
                 system.debug('>>>>loggedInContact'+loggedInContact);
                List<Customer_Config__c> configrecEdit = [Select Id,User_Config__c,Is_Active__c,Job_Owner__c,Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c From Customer_Config__c Where Job_Owner__c=:loggedInContact AND Is_Default__c=true AND RecordType.Name='JO Dashboard' AND Is_Admin__c=false];
               
                if(configrecEdit.size() > 0)
                {
                    configrecEdit[0].Is_Default__c = false;
                    upsert configrecEdit;
                } 
                     system.debug('>>>>'+configrecEdit);
                    conf.View_Name__c = dashboardName;
                    conf.Is_Active__c = dashboardActive;
                    conf.Is_Default__c = dashboardDefault; 
                    conf.Json_Config__c = filteredJobOwners;
                    system.debug('conf.View_Name__c'+conf.View_Name__c+'conf.Is_Active__c'+conf.Is_Active__c+'conf.Is_Default__c'+conf.Is_Default__c);
                    upsert conf;
                    system.debug('>>>>'+conf);
                    returnConfig.add(conf);
               
            }
            else
            { 
                conf.View_Name__c = dashboardName;
                conf.Is_Active__c = dashboardActive;
                conf.Is_Default__c = dashboardDefault;
                conf.Json_Config__c = filteredJobOwners;
                system.debug('conf.View_Name__c'+conf.View_Name__c+'conf.Is_Active__c'+conf.Is_Active__c+'conf.Is_Default__c'+conf.Is_Default__c);
                upsert conf;
                returnConfig.add(conf); 
            }
            
        }
        
        system.debug('relatedCustomConfig:'+relatedCustomConfig);
        
        return returnConfig;
    }
    @AuraEnabled
    public static List<Customer_Config__c> deleteDashboardRecord(String dashboardId)
    {
        system.debug('>>>>>start8ing'+dashboardId);
        List<Customer_Config__c> delList = new List<Customer_Config__c>();
        Customer_Config__c conf = [Select Id,User_Config__c,Is_Active__c,Job_Owner__c,Is_Admin__c,RecordTypeId,Is_Default__c,Json_Config__c,Sort_Order__c,User_Module__c,View_Name__c From Customer_Config__c Where Id=:dashboardId];
        delList.add(conf) ;
        List<Customer_Config__c> delLst = [Select Id,User_Config__c  From Customer_Config__c Where User_Config__c=:dashboardId];
       
        if(delList.Size() > 0)
        delete delList;

        if(delLst.Size() > 0) delete delLst;
        system.debug('>>>>delete '+conf);
        return delList;
    }
    /************** periods drop down data in global filters component ******************/
    /* @AuraEnabled
    public static Map<String,String> getPeriods(){
        Map<String,String> periodMap = new Map<String,String>();
        Map<String,DateUtilitiFunctions__c> custMap = DateUtilitiFunctions__c.getAll();
        for(String p :custMap.keySet()){
            if(custMap.get(p).Is_Active__c)
                periodMap.put(custMap.get(p).name, custMap.get(p).Function__c);
        }     
        system.debug('periodMap:'+periodMap);
        return periodMap;
    }*/

}