public with sharing class JO_PortfolioController {
	public JO_PortfolioController() {}

	@AuraEnabled
    public static JO_Wrapper.PortfolioListViews generateListViews(String[] contactIds, Customer_Config__c userConfigRec){ 
    	List<String> rTypeIds = JO_Util.fetchRecordTypeIdList('Notifications__c', (new Set<String>{'AS','WR'})) ;
    	List<JO_Wrapper.PortfolioViews> allViewLst = new List<JO_Wrapper.PortfolioViews>();
        AggregateResult  records = [SELECT count(Id) allCount FROM Notifications__c WHERE Jb_Owner__c IN:contactIds AND NotificationType__c IN('AS','WR') ];
       
        String soqlStr ='SELECT Id, Name, View_Name__c, User_Config__c, Json_Config__c, RecordTYpe.Name, Job_Owner__c, Is_Active__c, Is_Admin__c, Is_Default__c, Sort_Order__c '; 
        soqlStr +='FROM Customer_Config__c ';
        soqlStr +='WHERE (User_Config__c = null OR User_Config__c =\''+userConfigRec.Id+'\') AND Is_Active__c= true And (RecordType.Name=\'JO Portfolio\' OR RecordType.Name=\'JO Admin Views\') ';
        soqlStr +='Order by Sort_Order__c, View_Name__c';
        system.debug(soqlStr);
        
        for(Customer_Config__c config : Database.query(soqlStr)){                     
            JO_Wrapper.PortfolioFieldsList results = (JO_Wrapper.PortfolioFieldsList)JSON.deserialize(config.Json_Config__c, JO_Wrapper.PortfolioFieldsList.Class);
            JO_Wrapper.PortfolioViews portfolio = new JO_Wrapper.PortfolioViews(config.View_Name__c,config.Id,config.Is_Admin__c,config.Is_Default__c,config.Is_Active__c, results.viewfields,Integer.valueOf(config.Sort_Order__c));
            allViewLst.add(portfolio);
        }   
        
        JO_Wrapper.PortfolioListViews viewsLsit = new JO_Wrapper.PortfolioListViews();
        viewsLsit.allViewLst.addAll(allViewLst);
        viewsLsit.recordCount = Integer.valueOf(records.get('allCount'));
        return viewsLsit;
    } 
    @AuraEnabled
    public static List<JO_Wrapper.PortfolioFields> generateTableRecords(String[] contactIds,String viewId, Customer_Config__c userConfigRec){         
        List<JO_Wrapper.PortfolioFields> jsonStructureData = new List<JO_Wrapper.PortfolioFields>();        
        
        for(JO_Wrapper.PortfolioViews val: generateListViews(contactIds,userConfigRec).allViewLst){
            if(val.viewId == viewId){
                for(JO_Wrapper.PortfolioFields apiVal: val.viewfields){
                    if(apiVal.visible) jsonStructureData.add(apiVal);
                }
            }            
        }
        return jsonStructureData;
    }

    @AuraEnabled
    public static List<Sobject> getNotificationRec(String sObjectName, string criteriafield, List<String> conatcIds,  Customer_Config__c userConfigRec, string fieldNameJson,String[] notificationIds){
        
        List<sObject> lstResult = new List<sObject>();
        //String notifRecords = '[]';
        try{     
            Set<String> setFieldNames = new Set<String>();
            List<String> cIds = new List<String>();
            for(String s : conatcIds) cIds.add('\'' + s + '\'');

            List<String> fieldNames = (List<String>) JSON.deserialize(fieldNameJson, List<String>.class);
            List<String> rTypeIds = JO_Util.fetchRecordTypeIdList('Notifications__c', (new Set<String>{'AS','WR'})) ;
            String query = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + sObjectName;
            if(criteriafield != NULL && criteriafield != ''){
                query += ' WHERE ' + criteriafield + ' IN  ' +  cIds +' AND RecordTypeId IN' + rTypeIds+' AND NotifPriorityType__c IN(\'High\',\'Low\',\'Medium\')';
            }
            if(notificationIds.size() > 0){
                List<String> strLst = new List<String>();
                for(String str : notificationIds)
                        strLst.add('\'' + str + '\'');
                query += ' AND  Id IN'+strLst;
            }

            System.debug('query : '+query);
            for(sObject s : Database.query(query)){
                lstResult.add(s);
            }
        }
        catch(Exception e){
            //result += e.getLineNumber() + ' : ' + e.getMessage();
        }
        return lstResult;
    } 


    @AuraEnabled
    public static JO_Wrapper.PortfolioViews editView(String contactId,String portfolio){
        
        JO_Wrapper.PortfolioViews pfv = (JO_Wrapper.PortfolioViews)JSON.deserialize(portfolio, JO_Wrapper.PortfolioViews.class);
        List<JO_Wrapper.PortfolioFields> PortfolioFieldslst = new List<JO_Wrapper.PortfolioFields>();
        for(JO_Wrapper.PortfolioFields  viewfields : pfv.viewfields){
            Schema.DisplayType fType = JO_Util.getFieldDescribe('Notifications__c',viewfields.fieldAPI).getType();
            system.debug(fType);
            viewfields.visible = false;
            viewfields.order = 0 ;
            viewfields.fieldType = String.valueOf(fType);
            PortfolioFieldslst.add(viewfields);
        }
        JO_Wrapper.PortfolioViews newview = new JO_Wrapper.PortfolioViews('','',false,false,false, PortfolioFieldslst, 0);
        
        return newview;
    }
    @AuraEnabled
    public static JO_Wrapper.PortfolioViews saveView(String contactId,Customer_Config__c userConfigRec, String portfolio){

        List<JO_Wrapper.PortfolioFields> PortfolioFieldslst = new List<JO_Wrapper.PortfolioFields>();
        JO_Wrapper.PortfolioViews pfv = (JO_Wrapper.PortfolioViews)JSON.deserialize(portfolio, JO_Wrapper.PortfolioViews.class);
 
        JO_Wrapper.PortfolioFieldsList portFlds = new JO_Wrapper.PortfolioFieldsList(pfv.viewfields);
        Customer_Config__c config = new Customer_Config__c();
        config.Id = String.isNotBlank(pfv.viewId) ? pfv.viewId : null;
        config.View_Name__c = pfv.viewName;
        config.Is_Active__c = boolean.valueOf(pfv.isActive);
        config.Is_Admin__c =  boolean.valueOf(pfv.isAdmin);
        config.Is_Default__c = boolean.valueOf(pfv.isDefault);       
        config.Json_Config__c = JSON.serialize(portFlds);  
        config.Sort_Order__c = pfv.sortOrder;
        config.Job_Owner__c = contactId;
        config.User_Config__c = userConfigRec.Id;
        upsert config;
        
        JO_Wrapper.PortfolioFieldsList results = (JO_Wrapper.PortfolioFieldsList)JSON.deserialize(config.Json_Config__c, JO_Wrapper.PortfolioFieldsList.Class);
        JO_Wrapper.PortfolioViews newview = new JO_Wrapper.PortfolioViews(config.View_Name__c,config.Id,config.Is_Admin__c,config.Is_Default__c,config.Is_Active__c,results.viewfields,Integer.valueOf(config.Sort_Order__c));

        return newview;
    }
    @AuraEnabled
    public static List<Customer_Config__c> deleteViewRec(String viewId){
        List<Customer_Config__c> delList = new List<Customer_Config__c>();
        Customer_Config__c cusConfig = [Select Id From Customer_Config__c Where Id=:viewId]; 
        delList.add(cusConfig);
        if(delList.Size() > 0)
            delete delList;
        return delList;
    }

}