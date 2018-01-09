@istest
public class JO_updateAlertTest {
    
    static testMethod void JO_updateAlert(){
        
        List<Id> taskWhatID=new list<Id>(); 
        
        Notifications__c notif=new Notifications__c();
        notif.Template_C_Sent__c=datetime.newInstance(2017, 9, 11, 13, 3, 0);
        notif.Template_G_Sent__c=datetime.newInstance(2017, 12, 12, 13, 13, 10);
        insert notif;
        list<Notifications__c> nlist;
        
        list<Alert__c> altlist=new list<Alert__c>();
        Alert__c alt=new Alert__c();
        alt.Status__c='open';
        alt.Alert_Numbers__c='11';
        alt.Notifications__c=notif.id;
        insert alt;
        altlist.add(alt);
        
        List<Alert__c> alertList = [Select ID, Name, Status__c, Alert_Numbers__c from Alert__c where Notifications__c  =: notif.Id  and Status__c='open'];
        system.debug('The alert list is' +alertList);
        
        /*Alert__c alt1=new Alert__c();
        alt1.Status__c='open';
        alt1.Alert_Numbers__c='13';
        //alt1.Notifications__c=notif.id;
        insert alt1;
        altlist.add(alt1);*/
        
        system.assertequals(1,altlist.size());
        
        JO_updateAlert joup=new JO_updateAlert();
        JO_updateAlert.updateAlert(taskWhatID);
    }
    
}