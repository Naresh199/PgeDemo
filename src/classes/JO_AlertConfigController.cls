public class JO_AlertConfigController {
    @auraEnabled
    public static List<JO_Wrapper.JO_AlertConfigWrapper> getAlertWrapper(string contactId, Customer_Config__c userConfigRec)
    {        
        List<JO_Wrapper.JO_AlertConfigWrapper> alertConfigLst = new List<JO_Wrapper.JO_AlertConfigWrapper>();        
        List<JO_Wrapper.JO_AlertCountWrapper> alertList = new List<JO_Wrapper.JO_AlertCountWrapper>();        
        alertList.addall(JO_AlertController.getjobAlertsbyDashboard(new List<String>(), contactId, userConfigRec, true));        
        system.debug('alertList--------->'+alertList);        
        for(JO_Wrapper.JO_AlertCountWrapper c : alertList){
            alertConfigLst.add(new JO_Wrapper.JO_AlertConfigWrapper(
            c.alertId, 
            c.alertName, 
            c.isHide,
            c.IsEnabled, 
            c.sysPriority,
            c.selectedUserPriority, 
            c.sortorder, 
            c.alertType));
        }               
        system.debug('alertConfigLst------>'+alertConfigLst);        
        return alertConfigLst;
    }
   @auraEnabled
    public static List<String> getPrioritylists(String sObjectName,String picklistField){         
        return JO_Util.getPickListDescribe(sObjectName,picklistField);
    }
    public static string GetSortedJSON(String alertJson){
        
        List<JO_Wrapper.JO_AlertConfigWrapper> basedata = (List<JO_Wrapper.JO_AlertConfigWrapper>)JSON.deserialize(alertJson, List<JO_Wrapper.JO_AlertConfigWrapper>.Class);
        // system.debug('GetSortedJSON '+basedata);
        
        for(JO_Wrapper.JO_AlertConfigWrapper a : basedata)
        {
            if (a.isHidden)
                a.sortorder = a.sortorder + 100;
            else
                a.sortorder = a.sortorder >= 100 ? a.sortorder - 100 : a.sortorder;

        }

        // system.debug('@@@Data: '+sjson);
        return JSON.serialize(new JO_Wrapper.JO_AlertConfigWrapperList(basedata));
    }
    @auraEnabled
    public static String saveUserConfigForAlert(String configRec, Customer_Config__c dashboardId, string contactId){ 
        system.debug('-----front end ----'+configRec);
        List<Customer_Config__c> config = new List<Customer_Config__c> ();        
        config = [select id, name, Json_Config__c from Customer_Config__c where User_Config__c =: dashboardId.id and RecordType.Name = 'JO Alert'];
        boolean isUpdated = false; 
        try{
            if (config.size() > 0){                
                config[0].Json_Config__c = GetSortedJSON(configRec);
                config[0].View_Name__c = dashboardId.View_Name__c + ' Alerts';
                update config[0];
            }
            else
            {
                Customer_Config__c cust = new Customer_Config__c();
        		cust.Is_Active__c = true;
                cust.Is_Admin__c =  false;
                cust.Is_Default__c = true;       
        		cust.Sort_Order__c = 0;
                cust.Job_Owner__c = contactId;
                cust.User_Config__c = dashboardId.id;
                cust.Json_Config__c = GetSortedJSON(configRec);
                cust.View_Name__c = dashboardId.View_Name__c + ' Alerts';
                cust.RecordTypeId = JO_Util.getRecordTypeId('Customer_Config__c', 'JO Alert');
               //system.debug('configRec--------->'+cust);
                if(cust.Json_Config__c != null)
                    insert cust;  
                else  throw new AuraHandledException('JSON Configuration Records is null');
            }            
            isupdated = true;
        }        
        catch(System.UnexpectedException e){
            system.debug(e.getMessage());
        }        
        return isUpdated == true ? 'SUCCESS' : 'ERROR';        
    }
   
}