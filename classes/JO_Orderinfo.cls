public class JO_Orderinfo 
{
    @AuraEnabled
    public static Contact getCustomerInfo(string ordId)
    {
        return [SELECT id, Name, Title, Email, Phone, Account.Name 
                FROM Contact 
                WHERE Id IN (SELECT Jb_Owner__c FROM Notifications__c where Notification_Order__c =:ordId)];
        
    }
}