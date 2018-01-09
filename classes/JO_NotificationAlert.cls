public class JO_NotificationAlert {
    private static Set<Id> orderIDs = new set<Id>();
    
    Public Class NotifOrderAlert
    {
        
        @Auraenabled
        public String RecordId {get; set;}
        @Auraenabled
        public String ObjectId {get; set;}
        @Auraenabled
        public String alertName {get; set;}
        @AuraEnabled
        public String objectNumber {get; set;}
        @AuraEnabled
        public String objectType {get; set;}
        @AuraEnabled
        public DateTime alertCreatedDate{get;set;}                 
        @AuraEnabled
        public String cycleTime {get; set;}
        @AuraEnabled
        public DateTime alertCloseDate{get; set;}
        @AuraEnabled
        public String status {get;set;}        
        public NotifOrderAlert(String RecordId,String ObjectId, String name, DateTime alertCreatedDate, DateTime alertCloseDate, String cycleTime, 
                               String Status, String recordTypeName, String objctName)
        {
            this.RecordId = RecordId;
            this.ObjectId=ObjectId;
            this.alertName = name;
            this.cycleTime = cycleTime;
            this.status = status;
            this.objectType = recordTypeName;
            this.alertCreatedDate = alertCreatedDate;
            this.alertCloseDate = alertCloseDate;
            this.objectNumber = objctName;
            
        }
    }
    @AuraEnabled
    public static List<NotifOrderAlert> getAlerts(string RecId)
    {
        List<Alert__c> lstarts = new List<Alert__c>();
        List<NotifOrderAlert> wrapalertlist=new  List<NotifOrderAlert>();
        Id rec=Id.valueof(RecId);
        String sObjName2 = rec.getSObjectType().getDescribe().getLabel();        
        system.debug('name of sobject'+sObjName2);
        
        if(sObjName2 == 'Notifications')
        {
            List<Order__c> notifordlst=[select Id,Name,Notification_Order__c,Notification_Order__r.Name,Notification_Order__r.RecordType.Name,RecordType.Name,
                                        (select id,Name,RecordType.Name from  Sub_Orders__r) from Order__c where Notification_Order__c= :RecId];
            system.debug('notification and child fields'+notifordlst);
            if(notifordlst.size()>0)
            {
                for(Order__c ord : notifordlst)
                {            
                    for(Order__c sord : ord.Sub_Orders__r)
                    {
                        orderIDs.add(sord.Id);
                    }
                    orderIDs.add(ord.Id);
                    orderIDs.add(ord.Notification_Order__c);
                    system.debug('Order Object Id ==>>'+orderIDs);
                }
                lstarts=[select id, Name, Notifications__c, Notifications__r.Name, Notifications__r.RecordType.Name, Status__c, Alert_Close_Date__c, Cycle_Time_Info__c, CreatedDate,Alert_Numbers__c, 
                         Orders__c, Orders__r.Name,Orders__r.RecordType.Name 
                         from Alert__c where Notifications__c In:orderIDs or Orders__c in: orderIDs order by CreatedDate DESC];
                system.debug('Notification and order related alerts ==>>'+lstarts.size());
            }
        }else
        {
            List<Order__c> ordlst=[select Id,Name,Notification_Order__c,Notification_Order__r.Name,Notification_Order__r.RecordType.Name,RecordType.Name,
                                   (select id,Name,RecordType.Name from  Sub_Orders__r) from Order__c where Id= : RecId];
            system.debug('Order Object Id Passed List ==>>'+ordlst);  
            if(ordlst.size()>0)
            {
                for(Order__c ord : ordlst)
                {
                    for(Order__c sord : ord.Sub_Orders__r)
                    {
                        orderIDs.add(sord.Id);
                    }
                    orderIDs.add(ord.Id);
                    system.debug('Order Object Id ==>>'+orderIDs);
                } 
                lstarts=[select id, Name, Status__c, Alert_Close_Date__c, Cycle_Time_Info__c, CreatedDate,Notifications__r.Name,Notifications__r.RecordType.Name,Alert_Numbers__c,
                         Orders__c, Orders__r.Name,Orders__r.RecordType.Name 
                         from Alert__c where Orders__c In :orderIDs order by CreatedDate DESC];
                system.debug('Notification and order related alerts1 ==>>'+lstarts);
            }
        }       
        
        if(lstarts.size()>0)
        {
            
            for(Alert__c alertVar: lstarts)
            {   
                if(alertVar.Notifications__r.Name != null)
                {
                    wrapalertlist.add(new NotifOrderAlert(alertVar.ID,alertVar.Notifications__c, alertVar.Name, alertVar.CreatedDate, alertVar.Alert_Close_Date__c, 
                                                          alertVar.Cycle_Time_Info__c,alertVar.Status__c, 
                                                          alertVar.Notifications__r.RecordType.Name, alertVar.Notifications__r.Name));
                }else if( alertVar.Orders__r.Name != null)
                {
                    wrapalertlist.add(new NotifOrderAlert(alertVar.ID,alertVar.Orders__c, alertVar.Name, alertVar.CreatedDate, alertVar.Alert_Close_Date__c,
                                                          alertVar.Cycle_Time_Info__c,alertVar.Status__c, alertVar.Orders__r.RecordType.Name, alertVar.Orders__r.Name));
                }
                
            }
            System.debug('@@ wrapalertlist Size: ' + wrapalertlist.size());
        }
        return wrapalertlist;
    }
    @AuraEnabled
    public static  void getSelectedRecords(List<String> lstRecordId)
    {
        system.debug('record id'+lstRecordId);
        
        List<ID> alertIds = new List<ID>();        
        
        if(lstRecordId.size()>0)
        {
            alertIds.addAll(lstRecordId);
        }
        
        List<Alert__c> lstAlert=[select id,Name,Status__c,Alert_Close_Date__c,Alert_Numbers__c  from  Alert__c where ID in: alertIds];
        if(lstAlert.size()>0)
        {
            for(Alert__c rec: lstAlert)
            {
                /*if (rec.Status__c == 'Close')
continue;*/            	
                rec.Status__c = 'close';
                rec.Alert_Close_Date__c = System.now();
            }
            update lstAlert;
        }
    }   
    
}