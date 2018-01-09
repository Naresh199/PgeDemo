@istest
public class JO_NotificationOrdersTest {
    Static Testmethod void JO_NotificationOrdersinfo() {
        
        List<Notifications__c> notList = new List<Notifications__c>();
        Notifications__c not1 = new Notifications__c();
        not1.Name = 'Notification one';
        not1.Notification_Status__c = 'SUBM';
        insert not1;
        notList.add(not1);
        
         Notifications__c not2 = new Notifications__c();
        not1.Name = '123';
        not1.Notification_Status__c = 'cancel';
        insert not2;
        notList.add(not2);
        
        
        Order__c Ord1 = new Order__c();
        Ord1.Name='23475097';
        insert Ord1;
        
        test.startTest();
        JO_NotificationOrders jon=new JO_NotificationOrders();
        JO_NotificationOrders.getFields();
        JO_NotificationOrders.getAllNotifyOrders(not1.id);
        test.stopTest();
    }
    Static Testmethod void JO_NotificationOrdersinfoElse() {
        
        //List<Notifications__c> notList = new List<Notifications__c>();
        Notifications__c not1 = new Notifications__c();
        not1.Name = 'Notification one';
        not1.Notification_Status__c = 'SUBM';
        insert not1;
        
        
         
        
        List<Order__c> ordlist = new List<Order__c>();
        Order__c Ord1 = new Order__c();
        Ord1.Name='93475097';
        insert Ord1;
        ordlist.add(ord1);
        
        test.startTest();
        JO_NotificationOrders jon=new JO_NotificationOrders();
        JO_NotificationOrders.getFields();
        JO_NotificationOrders.getAllNotifyOrders(ord1.id);
        test.stopTest();
    }
   
   
    
}