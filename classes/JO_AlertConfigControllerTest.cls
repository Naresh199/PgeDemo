@isTest
private class JO_AlertConfigControllerTest
{
    @testSetup
  static void JO_AlertConfigController()
  {
     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='testUser_axiom01@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testUser@testorg01.com');
        insert testUser;               

		Id contactRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dashboard User').getRecordTypeId();
		List<Contact> conList = new List<Contact>();
		Contact con1 = new Contact();
		con1.LastName = 'JO User one';
		con1.Email = 'abc@g.com';
		con1.RecordTypeId = contactRecType;
		con1.Related_User__c = testUser.Id;
		conList.add(con1);
		Contact con2 = new Contact();
		con2.LastName = 'JO User two';
		con2.Email = 'abc@g.com';
		con2.RecordTypeId = contactRecType;
		con2.Related_User__c = testUser.Id;
		conList.add(con2);
		insert conList;

		Id notiRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('AS').getRecordTypeId();		
		List<Notifications__c> notList = new List<Notifications__c>();
		Notifications__c not1 = new Notifications__c();
		not1.RecordTypeId = notiRecType;
		not1.Name = 'Notification one';
		not1.Jb_Owner__c = con1.Id;
		not1.Notification_Status__c = 'SUBM';
		notList.add(not1);
		Notifications__c not2 = new Notifications__c();
		not2.RecordTypeId = notiRecType;
		not2.Name = 'Notification two';
		not2.Jb_Owner__c = con1.Id;
		not2.Notification_Status__c = 'SUBM';
		notList.add(not1);

		Id configDashRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        Customer_Config__c cust = new Customer_Config__c(); 
        cust.Job_Owner__c = con2.Id;        
        cust.View_Name__c = 'Default Dashboard';
        cust.RecordTypeId = configDashRecType;
        insert cust;        
      Id configAlertRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Alert').getRecordTypeId();
      Customer_Config__c cust1 = new Customer_Config__c(); 
      cust1.Job_Owner__c = con2.Id;        
      cust1.View_Name__c = 'Alert Configurations';
      cust1.RecordTypeId = configAlertRecType;
      cust1.Json_Config__c = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 
      cust1.User_Config__c= cust.Id;       
      insert cust1;
      
      
      Jo_Alert__c jOAlert = New Jo_Alert__c();
      jOAlert.Name = 'Inactive order start ZIOCF';
      joAlert.Alert_Type__c = 'External';
      joAlert.Alert_Is_Enabled__c = True;
      joAlert.Sort__c = 26;
      Insert joAlert;
	}
   static testMethod void getAlert(){
		Contact c1 = [SELECT id FROM contact where LastName='JO User two'];
       Customer_Config__c userConfigRec = [SELECT id FROM Customer_Config__c where View_Name__c = 'Default Dashboard'];
		Test.startTest();
		List<JO_Wrapper.JO_AlertConfigWrapper> joConfig = JO_AlertConfigController.getAlertWrapper(String.valueOf(c1.Id), userConfigRec);
		Test.stopTest();
		
	}
    
    static testMethod void userConfigAlert(){
		Contact c1 = [SELECT id FROM contact where LastName='JO User two'];
        String configRec = '{"viewfields":[{"alertType":"External","Id":"a2O2F0000006I2OUAU","isEnabled":true,"isHidden":true,"joAlertName":"New Application Call Customer","selectedUserPriority":"High","sortOrder":2,"sysPriority":"High"},{"alertType":"External","Id":"a2O2F0000006I3WUAU","isEnabled":true,"isHidden":true,"joAlertName":"Send Request for Additional Email","selectedUserPriority":"High","sortOrder":3,"sysPriority":"High"}]}'; 

       Customer_Config__c userConfigRec = [SELECT id FROM Customer_Config__c where View_Name__c = 'Default Dashboard'];
		Test.startTest();
		String configList = JO_AlertConfigController.userConfigForAlert(configRec,userConfigRec,String.valueOf(c1.Id));
			
		Test.stopTest();
		
	}
}