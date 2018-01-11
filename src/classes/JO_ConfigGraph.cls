public class JO_ConfigGraph {

	@AuraEnabled
    public static JO_Wrapper.JO_StringWrapperConfig chartConfigData(String contactId, Customer_Config__c dashboardRec){
        ID recordTypeId = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Chart').getRecordTypeId();  
        List<JO_Wrapper.JO_ChartConfigWrapperConfig> chartWrapperList = new List<JO_Wrapper.JO_ChartConfigWrapperConfig>();
        JO_Wrapper.JO_StringWrapperConfig dualBoxList = new JO_Wrapper.JO_StringWrapperConfig();
        List<String> chartRight = new List<String>();
        List<String> jobOwnerIds = new List<String>();
        Set<Schema.PickListEntry> pickListValues = new Set<Schema.PickListEntry>();    
            
        pickListValues.addAll(JO_Util.retrievePicklistDescribe('Notifications__c','Notification_Status__c'));
        pickListValues.addAll(JO_Util.retrievePicklistDescribe('Order__c','OrderStatus__c'));
        
        for(Schema.PickListEntry plEntry: pickListValues){
            JO_Wrapper.JO_ChartConfigWrapperConfig ch = new JO_Wrapper.JO_ChartConfigWrapperConfig();
            ch.value = plEntry.getValue();
            ch.label = plEntry.getLabel();
            chartWrapperList.add(ch);            
        }        

        dualBoxList.left = new  List<JO_Wrapper.JO_ChartConfigWrapperConfig>();
        dualBoxList.left.addAll(chartWrapperList);
        //for(String str: contactId) jobOwnerIds.add('\''+str+'\'');
        for(Customer_Config__c conf: [SELECT Id,Json_Config__c,RecordTypeId FROM Customer_Config__c 
                                    WHERE RecordTypeId=:recordTypeId and Job_Owner__c =:contactId AND User_Config__c =: dashboardRec.Id])
        {
            if(String.isNotBlank(conf.Json_Config__c))
               chartRight.addAll(conf.Json_Config__c.split(','));
            
            dualBoxList.userConfigId = conf.id;            
        }
        dualBoxList.right = new  List<String>();
        if(chartRight.size()>0)
            dualBoxList.right.addAll(chartRight);
        else{
            for(JO_Wrapper.JO_ChartConfigWrapperConfig data: chartWrapperList) 
                dualBoxList.right.add(data.value);
            //dualBoxList.left = new List<JO_Wrapper.JO_ChartConfigWrapperConfig>();
        }
        return dualBoxList;
    }
    @AuraEnabled
    public static String UpdateUserConfig(List<String> filteredList,String loggedInUser,String userConfigId, Customer_Config__c dashboardRec){
        String a ='Successfully Updated';        
        String userConfigStatus ='';
        Customer_Config__c userConfigRecord;
        ID recordTypeId = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Chart').getRecordTypeId();        
        
        if(String.isNotBlank(userConfigId) && String.isNotBlank(loggedInUser)){
            userConfigRecord = [select id,Json_Config__c,RecordTypeId from Customer_Config__c where id=:userConfigId and Job_Owner__c=:loggedInUser];
        }
        
        if(filteredList.size()>0){
            userConfigStatus = String.join(filteredList, ',');
        }

        if(userConfigRecord==null){
            userConfigRecord = new Customer_Config__c();   
            userConfigRecord.Job_Owner__c = loggedInUser;
        }
        userConfigRecord.View_Name__c = 'Project By Status';
        userConfigRecord.User_Config__c = dashboardRec.Id;
        userConfigRecord.Sort_Order__c = 0;
        userConfigRecord.Json_Config__c = userConfigStatus;
        userConfigRecord.RecordTypeId = recordTypeId;
        upsert userConfigRecord;

        return a;
    }
    @AuraEnabled
    public static String getloggedUser(){
        String logUserContact;
        Contact con = [Select Id,Name,Related_User__c From Contact Where Related_User__c=:UserInfo.getUserId()];
        logUserContact = con.Id;
        system.debug('user Id:'+logUserContact);
        return logUserContact;
    }
}