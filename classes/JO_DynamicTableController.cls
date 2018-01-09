public class JO_DynamicTableController {
    @AuraEnabled
    public static List<JO_Wrapper.PortfolioFields> generateTableRecords(String[] contactId,String viewId, Customer_Config__c userConfigRec){         
        List<JO_Wrapper.PortfolioFields> jsonStructureData = new List<JO_Wrapper.PortfolioFields>();        

        for(JO_Wrapper.PortfolioViews val: JO_Portfolio.generateConfigRec(contactId,userConfigRec).allViewLst){
            if(val.viewId == viewId){
                for(JO_Wrapper.PortfolioFields apiVal: val.viewfields){
                    if(apiVal.visible) jsonStructureData.add(apiVal);
                }
            }            
        }
        return jsonStructureData;
    }
    @AuraEnabled
    public static List<Notifications__c> getNotificationRec(String ObjectName, String[] fieldstoget, List<String> contactIds,  Customer_Config__c userConfigRec){ 
        
        List<Notifications__c> notifRecords = [SELECT ID,Name,Jb_Owner__r.Name,Notification_Order__r.Name, NotificationDesc__c,CreatedBy.Name,NotificationType__c,Customer__r.Name,
                                               NotifPriority__c,NotifPriorityType__c,NotifDate__c,Notification_Status__c 
                                               FROM Notifications__c 
                                               WHERE Jb_Owner__c IN:contactIds AND NotificationType__c IN('AS','WR') AND NotifPriorityType__c IN('High','Low','Medium') LIMIT 100];
        return notifRecords; 
    }
}