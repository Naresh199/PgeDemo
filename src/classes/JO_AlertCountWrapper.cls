public class JO_AlertCountWrapper{
    @AuraEnabled public String alertId;
    @AuraEnabled public String alertNo;
    @AuraEnabled public String alertQuery;
    @AuraEnabled public String notificationQuery;
    @AuraEnabled public String nofticationId;
    @AuraEnabled public List<Id> lstNotifications;
    @AuraEnabled public String alertName;
    @AuraEnabled public Integer alertCount;
}