@isTest
public class JO_OrderinfoTest{
  
    Static  Testmethod void JO_Orderinfo()
    {
        Contact con1 = new Contact();
        con1.LastName = 'JO User one';
        con1.Email = 'abc@g.com';
        insert con1;
        List<Contact> conList = new list<Contact>();
        conList.add(con1); 
        
        Task task = New Task();
        task.Notification__c = 'test02';
        insert task;
        
        Order__c Ord1 = new Order__c();
        Ord1.Name='Test2';
        insert Ord1;
        
        Notifications__c not1 = new Notifications__c();
        not1.Name = 'Notification one';
        not1.Jb_Owner__c = con1.Id;
        not1.Notification_Status__c = 'SUBM';
        not1.Notification_Order__c = Ord1.id;
        insert not1;
        List<Notifications__c> notList = new List<Notifications__c>();
        notList.add(not1);
        JO_Orderinfo joOrder=new JO_Orderinfo();
        JO_Orderinfo.getCustomerInfo(Ord1.Id);
        
    }
   
}