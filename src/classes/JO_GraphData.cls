public class JO_GraphData {  
    /*
    This method is utilised in fetching user configutation data related to charts.
    Parameters
    contactId: it has details on the loggedInUser.
    status: Map of Picklist values available for Notifications.
    userConfigRec: This parameter contains details of the loggedIn user dasboard details.
    Output:
    Provides the list of user configuration data related to selected JobOwner.
    */   
    public static List<String> getConfigStatusLst(String contactId, Map<string,string> status,Customer_Config__c userConfigRec){
        List<String> configStatus = new List<String>(); 
        Id chartRecordType = JO_Util.getRecordTypeId('Customer_Config__c','JO Chart');
        
        if(userConfigRec!=null){
            for(Customer_Config__c uConfig : [SELECT Id,Json_Config__c FROM Customer_Config__c 
                                            WHERE Job_Owner__c=:contactId AND 
                                            User_Config__c =:userConfigRec.Id AND 
                                            RecordTypeId =:chartRecordType]){
                if(String.isNotBlank(uConfig.Json_Config__c)){
                    for(String chartStaus : uConfig.Json_Config__c.split(',')){
                        configStatus.add(chartStaus);
                    }
                }
                    
            }
        }
        if(configStatus.size() > 0)
            return configStatus;
        else return status.values();
    }

    /*
    This method is utilised in generating the Barchart Data which in invoked in 'getBarChartData' method.
    Parameters:
    status: Map of Picklist values available for Notifications.
    notiStatusList: List of order & notification records grouped by its Status.
    userConfigRec: This parameter contains details of the loggedIn user dasboard details.
    Output:
    Returns a data which has the data about status & count for Barchart.
    */
    public static map<string,Map<string,string>> convertBarData(Map<string,string> status,List<AggregateResult> notiStatusList,Customer_Config__c userConfigRec)
    {
        map<string,Map<string,string>> drillmap = new map<string,Map<string,string>>();
        Map<string,string> configmap = new Map<string,string>();        
        map<String,String> configStatus = new map<String,String>(); 
       
        List<String> configStatusLst = getConfigStatusLst(JO_Util.getLoggedInContact(UserInfo.getUserId()),status,userConfigRec);
        
        if(configStatusLst.size()>0){
            for(String str :configStatusLst){
                configStatus.put(str, str);
            }
        }
        if(notiStatusList.size()>0){
            for(AggregateResult  job: notiStatusList)
            {
                if(status.containsKey(string.valueof(job.get('Status'))) && configStatus.containsKey(string.valueof(job.get('Status'))))
                {
                    if (configmap.containsKey(string.valueof(job.get('Status'))))
                    {
                        integer rr = integer.valueof(configmap.get(string.valueof(job.get('Status'))));
                        rr = rr + integer.valueof(string.valueof(job.get('Recs')));
                        configmap.put(string.valueof(job.get('Status')),string.valueof(rr));
                    }
                    else{
                        configmap.put(string.valueof(job.get('Status')),string.valueof(job.get('Recs')));
                    }
                }
            }
        }
        for(String stts :configStatusLst){
            drillmap.put(stts, new Map<string,string>());
            if(configmap.containsKey(stts)){                
                drillmap.get(stts).put('Name',stts);
                drillmap.get(stts).put('count',configmap.get(stts));
            }
            else { 
                drillmap.get(stts).put('Name',stts);
                drillmap.get(stts).put('count','0');
            }
        }                
        return drillmap;    
    }   
    /*
    This method is used in genrating the Piechart data for the piechart displayed in the dashboard.
    Parameters:
    query: List of selected jobOwner ids
    userConfigRec: This parameter contains details of the loggedIn user dasboard details.
    Output:
    Returns the list of wrapper class of piechart which is utilised in displaying piechart.
    */
    @AuraEnabled
    public static List<JO_Wrapper.JO_PIEChart > getPieChartData(List<string> jobOwnerIds,Customer_Config__c userConfigRec)
    {
        String statusQuery1,statusQuery2;
        List<String> contactSet = new List<String>();
        List<String> recordTypeSet = new List<String>();                
        Set<String> recordTypeName = new Set<String>{'AS','WR'};       
        Map<string,string> status = new Map<string,string>();        
        map<String, String> configStatus = new map<String, String>(); 
        Map<string,JO_Wrapper.JO_PIEChart> data = new  Map<string,JO_Wrapper.JO_PIEChart>();
        recordTypeSet = JO_Util.fetchRecordTypeIdList('Notifications__c',recordTypeName);        
        
        //for(String stts : JO_Util.getPickListDescribe('Notifications__c','Notification_Status__c'))    
        for(Schema.PicklistEntry val: JO_Util.retrievePicklistDescribe('Notifications__c','Notification_Status__c'))        
            status.put(val.getLabel(),val.getValue());
        //for(String orSts: JO_Util.getPickListDescribe('Order__c','OrderStatus__c'))
        for(Schema.PicklistEntry val: JO_Util.retrievePicklistDescribe('Order__c','OrderStatus__c'))
            status.put(val.getLabel(),val.getValue());

        List<String> configStatusLst = getConfigStatusLst(JO_Util.getLoggedInContact(UserInfo.getUserId()), status,userConfigRec);
        for(String str :configStatusLst) configStatus.put(str, str);
        
        if(jobOwnerIds.size()>0){
            for(string str :jobOwnerIds) contactSet.add('\''+str+'\'');             
            statusQuery1 = 'SELECT Count(Id) Recs, Notification_Status__c Status FROM Notifications__c  where Jb_Owner__c IN '+contactSet + 'and recordTypeID IN'+recordTypeSet+' and Notification_Order__c = null group by Notification_Status__c';           
            statusQuery2 = 'SELECT Count(Id) Recs, OrderStatus__c Status FROM Order__c  where Notification_Order__r.Jb_Owner__c IN '+contactSet + 'and Notification_Order__r.recordTypeID IN'+recordTypeSet+' group by OrderStatus__c';
        }
        
        List<AggregateResult> recs1 = Database.query(statusQuery1);
        List<AggregateResult> recs2 = Database.query(statusQuery2);
        recs1.addAll(recs2);
        for(AggregateResult job : recs1)
        {
            if(status.containsKey(string.valueof(job.get('Status'))) && configStatus.containsKey(string.valueof(job.get('Status'))))
            { 
                if(data.containsKey(string.valueof(job.get('Status'))))
                {     
                    JO_Wrapper.JO_PIEChart p = data.get(string.valueof(job.get('Status')));
                    p.data = p.data + decimal.valueof(string.valueof(job.get('Recs')));
                    data.put(string.valueof(job.get('Status')),p);                 
                }
                else{
                    data.put(string.valueof(job.get('Status')), new JO_Wrapper.JO_PIEChart (string.valueof(job.get('Status')),decimal.valueof(string.valueof(job.get('Recs')))));
                }
            }
        }
        return data.values();
    }    

    /*
    This method is used in generating the data for the Barchart displayed in the JO Dashboard.
    Parameters:
    jobOwnerIds: List of jobOwnerIds in the global filter.
    userConfigRec: This parameter contains details of the loggedIn user dasboard details.
    Output:
    returns a list of wrapper class of barchart which is utilised in displaying barchart.
    */   
    @AuraEnabled
    public static List<JO_Wrapper.JO_BarChart> getBarChartData(List<String> jobOwnerIds,Customer_Config__c userConfigRec)
    { 
        List<String> contactSet = new List<String>();
        List<String> recordTypeSet = new List<String>();                
        Set<String> recordTypeName = new Set<String>{'AS','WR'};
        Map<String,String> optionsMap = new Map<String,String>();
        List<JO_Wrapper.JO_BarChart> data = new List<JO_Wrapper.JO_BarChart>();        
        String statusQuery1 = '',statusQuery2='';      

        recordTypeSet = JO_Util.fetchRecordTypeIdList('Notifications__c',recordTypeName);
        if(jobOwnerIds.size()>0)
        {  
            for(string str :jobOwnerIds) contactSet.add('\''+str+'\'');
            statusQuery1 = 'SELECT Count(Id) Recs, Notification_Status__c Status FROM Notifications__c  where Jb_Owner__c IN '+contactSet + 'and recordTypeID IN'+recordTypeSet+' and Notification_Order__c = null group by Notification_Status__c';           
            statusQuery2 = 'SELECT Count(Id) Recs, OrderStatus__c Status FROM Order__c  where Notification_Order__r.Jb_Owner__c IN '+contactSet + 'and Notification_Order__r.recordTypeID IN'+recordTypeSet+' group by OrderStatus__c';
        }      
        
        //for(String ss: JO_Util.getPickListDescribe('Notifications__c','Notification_Status__c'))
        for(Schema.PicklistEntry val: JO_Util.retrievePicklistDescribe('Notifications__c','Notification_Status__c'))
            optionsMap.put(val.getLabel(),val.getValue());       

        //for(String orSts: JO_Util.getPickListDescribe('Order__c','OrderStatus__c'))
        for(Schema.PicklistEntry val: JO_Util.retrievePicklistDescribe('Order__c','OrderStatus__c'))
            optionsMap.put(val.getLabel(),val.getValue());

        List<AggregateResult> notiStatusList = Database.query(statusQuery1);
        List<AggregateResult> OrderStatusList = Database.query(statusQuery2);
        notiStatusList.addAll(OrderStatusList);

        map<string,Map<string,string>> drilldown = convertBarData(optionsMap,notiStatusList,userConfigRec);        
        
        for(String s : drilldown.keySet())
        {
            data.add(new JO_Wrapper.JO_BarChart(s,drilldown.get(s)));
        }      
        return data;      
    }
    
    /* 
    This method is used to retrieve the Notification IDs while clicking on the Bar/Pie Chart plots
    Parameters:
    jobOwnerId: Selected JO IDs from the Global Filter Component 
    selectedStatus: Clicked Status on the Bar/Pie Chart
    Output: Returns List of Notification records based on parameters 
    */
    @AuraEnabled
    public static List<Id> fetchNotificationLsts(List<String> jobOwnerId, String selectedStatus){       
        
        List<Id> recs = new List<Id>();
        Set<Id> recId = new Set<Id>();
        
        for(Notifications__c notification: [SELECT ID FROM Notifications__c WHERE Notification_Status__c=:selectedStatus AND Jb_Owner__c IN:jobOwnerId AND Notification_Order__c = null]){
            recId.add(notification.ID);
        }
        for(Order__c order : [SELECT Notification_Order__c FROM Order__c WHERE OrderStatus__c=:selectedStatus AND Notification_Order__r.Jb_Owner__c IN:jobOwnerId]){
            if (order.Notification_Order__c != null)                
                recId.add(order.Notification_Order__c);                
        }
        recs.addAll(recId);
        system.debug('----- NOTIF IDs: ' + recs.size());       
        return recs;
    }   

}