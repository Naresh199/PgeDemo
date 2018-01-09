public class JO_NotificationOrders{
/**
* On basis of field set, Create Dynamic SOQL
*/
    public static List<Schema.FieldSetMember> getFields() {
        return SObjectType.Order__c.FieldSets.OrderFieldset.getFields();
    }

    @AuraEnabled
    Public static List<Order__c> getAllNotifyOrders(String notifyId) {
        Id rec=Id.valueof(notifyId);
        String sObjName =rec.getSObjectType().getDescribe().getLabel();
        
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : getFields()) {
                query += f.getFieldPath() + ', ';
            }
            if(sObjName == 'Notifications')
            {
                query += 'Id,('+query +'Id FROM Sub_Orders__r) FROM Order__c WHERE Notification_Order__c  = \''+ notifyId +'\'';
            }
            else if(sObjName == 'Orders')
            {
                query += 'Id,('+query +'Id FROM Sub_Orders__r) FROM Order__c WHERE Id  = \''+ notifyId +'\'';
                system.debug('query>>>>>'+query);
                system.debug('query11111>>>>>'+Database.query(query));
            }
            return Database.query(query);
        }
        catch(Exception e)
        {
            //addError('There is error while Fetching existing Question using Dynamic SOQL in Field Set. Error Detail - '+e.getMessage()); //This is Utility Method to display error message on VF Page
        }
        return null;
    }

 }