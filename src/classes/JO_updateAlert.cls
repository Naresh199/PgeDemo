Global class JO_updateAlert
{
    @InvocableMethod
    Global static void updateAlert(List<ID> taskWhatID)
    {
        System.debug('@@ Inside invocable method');
        Map<ID, String> tasksubjectNotifList;
        if(taskWhatID != null)
        { 
            List<Notifications__c> notifList = [Select ID, Template_C_Sent__c, Template_G_Sent__c from Notifications__c where ID =: taskWhatID];
            
            List<Alert__c> alertList = [Select ID, Name, Status__c, Alert_Numbers__c from Alert__c 
                                        where Notifications__c  =: taskWhatID 
                                        and Status__c='open'];
            System.debug('@@ alertList: '+ alertList);
            if(alertList.size() >0)
            {
                for(Alert__c alertVar: alertList)
                {
                    if(alertVar.Alert_Numbers__c== '1') //&& alertVar.Name.contains('New Application Call Customer')
                    {
                        alertVar.status__c = 'Close'; 
                    }                                         
                }
                update alertList;
            }
            
        }
    }
    
}