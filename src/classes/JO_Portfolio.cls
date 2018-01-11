public class JO_Portfolio {     
    @AuraEnabled
    public static List<Sobject> getNotificationRec(String sObjectName, string criteriafield, List<String> conatcIds,  Customer_Config__c userConfigRec, string fieldNameJson,String[] notificationIds){
        
        List<sObject> lstResult = new List<sObject>();
        //String notifRecords = '[]';
        try{     
            Set<String> setFieldNames = new Set<String>();
            List<String> cIds = new List<String>();
            for(String s : conatcIds) cIds.add('\'' + s + '\'');

            List<String> fieldNames = (List<String>) JSON.deserialize(fieldNameJson, List<String>.class);
            List<String> rTypeIds = JO_Util.fetchRecordTypeIdList('Notifications__c', (new Set<String>{'AS','WR'})) ;
            String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sObjectName;
            if(criteriafield != NULL && criteriafield != ''){
                query += ' WHERE ' + criteriafield + ' IN  ' +  cIds +' AND RecordTypeId IN' + rTypeIds+'';
            }
            if(notificationIds.size() > 0){
                List<String> strLst = new List<String>();
                for(String str : notificationIds)
                        strLst.add('\'' + str + '\'');
                query += ' AND  Id IN'+strLst;
            }

            System.debug('query : '+query);
            for(sObject s : Database.query(query)){
                lstResult.add(s);
            }
        }
        catch(Exception e){
            //result += e.getLineNumber() + ' : ' + e.getMessage();
        }
        return lstResult;
    }  

    public static List<Notifications__c> getNotificationRec(List<String> jobOwners,  Customer_Config__c userConfigRec, JO_Wrapper.PortfolioFieldsList flist){
        
        System.debug(userConfigRec.Id);
        
        List<String> rTypeIds = JO_Util.fetchRecordTypeIdList('Notifications__c', (new Set<String>{'AS','WR'}));

        string qry = 'Select Id, RecordType.DeveloperName, RecordType.Name ';

        List<string> contactSet = new List<string>();

        for(string str :jobOwners) contactSet.add('\''+str+'\'');

        for(JO_Wrapper.PortfolioFields fl : flist.viewfields)
        {
            if (fl.fieldType == 'LINK')
                continue;
            qry = qry + ', ' + fl.fieldAPI;
        } 
        
        qry = qry + ' FROM Notifications__C ' + 'where Jb_Owner__c IN '+ contactSet + 'and recordTypeID IN'+rTypeIds;

        system.debug('------- QUERY FOR ALL TAB -----' + qry);

        List<Notifications__c> notifRecords = Database.query(qry);
        /*
        List<Notifications__c> notifRecords = [SELECT ID,Name,Jb_Owner__r.Name,Notification_Order__r.Name, NotificationDesc__c,CreatedBy.Name,NotificationType__c,Customer__r.Name,
                                               NotifPriority__c,NotifPriorityType__c,NotifDate__c,Notification_Status__c 
                                               FROM Notifications__c 
                                               WHERE Jb_Owner__c IN:conatcIds AND NotificationType__c IN('AS','WR')];
        */
        
        return notifRecords;
    } 
    @AuraEnabled
    public static List<Notifications__c> getPortfolioTable(string queryStr, List<String> conatcIds){
        List<Notifications__c> jobList = new List<Notifications__c>();    
        if(conatcIds.size() > 0){
            List<String> conatctSet = new List<String>();            
            for(string str :conatcIds){
                conatctSet.add('\''+str+'\''); 
            }
            string q = queryStr;
            jobList = database.query(queryStr);
            
        }
        return jobList; 
    }

    //////// Implemented Platform Cache ////////////////////////////////
    public static Customer_Config__c GetALLTabConfig()
    {
        Customer_Config__c rec = null;
        Cache.OrgPartition orgPart = JO_Util.GetJOPartition();      

        
        if(orgPart != null)
            rec = (Customer_Config__c)orgPart.get('JOALLTAB');

        if (rec == null)
        {
            rec = [SELECT Id, Name, View_Name__c, User_Config__c, Json_Config__c, RecordTYpe.Name, RecordTYpe.DeveloperName, Job_Owner__c, Is_Active__c, Is_Admin__c, Is_Default__c, Sort_Order__c  
            FROM Customer_Config__c where Is_Active__c = true And RecordType.DeveloperName='JO_Admin_Views' limit 1];

            orgPart.put('JOALLTAB', rec);
            return rec;
        }
        else
        {
            return rec;
        }

    }

    //////// Implemented Platform Cache ////////////////////////////////
    public static List<Customer_Config__c> GetPortfolioViews(Customer_Config__c userConfigRec)  
    {
        List<Customer_Config__c> recs = new List<Customer_Config__c>();
        // Cache.OrgPartition orgPart = JO_Util.GetJOPartition();      

        // if(orgPart != null)
        //      recs = (List<Customer_Config__c>)orgPart.get(userConfigRec.Id);

        // if (recs == null)
        // {
            recs = [SELECT Id, Name, View_Name__c, User_Config__c, Json_Config__c, RecordTYpe.Name, RecordTYpe.DeveloperName, Job_Owner__c, Is_Active__c, Is_Admin__c, Is_Default__c, Sort_Order__c  
            FROM Customer_Config__c where Is_Active__c = true and User_Config__c =: userConfigRec.Id
            And RecordType.DeveloperName='JO_Portfolio'
            Order by Sort_Order__c, View_Name__c];

        //    orgPart.put(userConfigRec.Id, recs);
             return recs;
        // }
        // else
        // {
        //     return recs;
        // }

    }


    @AuraEnabled
    public static JO_Wrapper.PortfolioViewsAndRecords generateConfigRec(String[] contactIds, Customer_Config__c userConfigRec){     

        //////// Implemented Platform Cache ////////////////////////////////
        
        List<Customer_Config__c> myViews = new List<Customer_Config__c>();

        myViews.add(GetALLTabConfig()); 

        myViews.addall(GetPortfolioViews(userConfigRec));

        JO_Wrapper.PortfolioFieldsList ALLTABFIELDS = null;
        List<JO_Wrapper.PortfolioViews> allViewLst = new List<JO_Wrapper.PortfolioViews>();
        
        for(Customer_Config__c config : myViews){
            
            JO_Wrapper.PortfolioFieldsList flist = (JO_Wrapper.PortfolioFieldsList)JSON.deserialize(config.Json_Config__c, JO_Wrapper.PortfolioFieldsList.Class);

            if (config.RecordType.DeveloperName == 'JO_Admin_Views')
                ALLTABFIELDS = flist;

            JO_Wrapper.PortfolioViews portfolio = new JO_Wrapper.PortfolioViews(config.View_Name__c,
                config.Id, config.Is_Admin__c, config.Is_Default__c, config.Is_Active__c, 
                flist.viewfields, Integer.valueOf(config.Sort_Order__c));

            allViewLst.add(portfolio);
        }   

        List<Notifications__c>  records = getNotificationRec(contactIds, userConfigRec, ALLTABFIELDS);

        JO_Wrapper.PortfolioViewsAndRecords precords = new JO_Wrapper.PortfolioViewsAndRecords(allViewLst,records);
        
        precords.recordCount = records.size();
        
        return precords;

    }
    @AuraEnabled
    public static List<JO_Wrapper.PortfolioFields> generateTableRecords(String[] contactIds,String viewId, Customer_Config__c userConfigRec){         
        List<JO_Wrapper.PortfolioFields> jsonStructureData = new List<JO_Wrapper.PortfolioFields>();        
        
        for(JO_Wrapper.PortfolioViews val: JO_Portfolio.generateConfigRec(contactIds,userConfigRec).allViewLst){
            if(val.viewId == viewId){
                for(JO_Wrapper.PortfolioFields apiVal: val.viewfields){
                    if(apiVal.visible) jsonStructureData.add(apiVal);
                }
            }            
        }
        return jsonStructureData;
    }
    @AuraEnabled
    public static JO_Wrapper.PortfolioViews editView(String contactId,String portfolio){
        
        JO_Wrapper.PortfolioViews pfv = (JO_Wrapper.PortfolioViews)JSON.deserialize(portfolio, JO_Wrapper.PortfolioViews.class);
        List<JO_Wrapper.PortfolioFields> PortfolioFieldslst = new List<JO_Wrapper.PortfolioFields>();
        for(JO_Wrapper.PortfolioFields  viewfields : pfv.viewfields){
            Schema.DisplayType fType = JO_Util.getFieldDescribe('Notifications__c',viewfields.fieldAPI).getType();
            system.debug(fType);
            viewfields.visible = false;
            viewfields.order = 0 ;
            viewfields.fieldType = String.valueOf(fType);
            PortfolioFieldslst.add(viewfields);
        }
        JO_Wrapper.PortfolioViews newview = new JO_Wrapper.PortfolioViews('','',false,false,false, PortfolioFieldslst, 0);
        
        return newview;
    }
    @AuraEnabled
    public static JO_Wrapper.PortfolioViews saveView(String contactId,Customer_Config__c userConfigRec, String portfolio){

        List<JO_Wrapper.PortfolioFields> PortfolioFieldslst = new List<JO_Wrapper.PortfolioFields>();
        JO_Wrapper.PortfolioViews pfv = (JO_Wrapper.PortfolioViews)JSON.deserialize(portfolio, JO_Wrapper.PortfolioViews.class);
        /*
        for(JO_Wrapper.PortfolioFields  viewfields : pfv.viewfields){
            Schema.DisplayType fType = JO_Util.getFieldDescribe('Notifications__c',viewfields.fieldAPI).getType();
            system.debug(fType);
            viewfields.fieldType = String.valueOf(fType);
            PortfolioFieldslst.add(viewfields);
        }*/
        JO_Wrapper.PortfolioFieldsList portFlds = new JO_Wrapper.PortfolioFieldsList(pfv.viewfields);
        Customer_Config__c config = new Customer_Config__c();
        config.Id = String.isNotBlank(pfv.viewId) ? pfv.viewId : null;
        config.View_Name__c = pfv.viewName;
        config.Is_Active__c = boolean.valueOf(pfv.isActive);
        config.Is_Admin__c =  boolean.valueOf(pfv.isAdmin);
        config.Is_Default__c = boolean.valueOf(pfv.isDefault);       
        config.Json_Config__c = JSON.serialize(portFlds);  
        config.Sort_Order__c = pfv.sortOrder;
        config.Job_Owner__c = contactId;
        config.User_Config__c = userConfigRec.Id;
        upsert config;
         JO_Wrapper.PortfolioFieldsList results = (JO_Wrapper.PortfolioFieldsList)JSON.deserialize(config.Json_Config__c, JO_Wrapper.PortfolioFieldsList.Class);
           
          system.debug('>>>>>>:::pfvFinal'+results);
       
        JO_Wrapper.PortfolioViews newview = new JO_Wrapper.PortfolioViews(config.View_Name__c,config.Id,config.Is_Admin__c,config.Is_Default__c,config.Is_Active__c,results.viewfields,Integer.valueOf(config.Sort_Order__c));
        system.debug('>>>>>>:::newview'+newview);
        return newview;
    }
    @AuraEnabled
    public static List<Customer_Config__c> deleteViewRec(String viewId){
        List<Customer_Config__c> delList = new List<Customer_Config__c>();
        Customer_Config__c cusConfig = [Select Id From Customer_Config__c Where Id=:viewId]; 
        delList.add(cusConfig);
        if(delList.Size() > 0)
            delete delList;
        return delList;
    }
}