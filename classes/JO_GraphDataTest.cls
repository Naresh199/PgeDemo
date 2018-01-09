@isTest
public class JO_GraphDataTest {

	@testSetup
	static void dataCreation(){
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(Alias = 'testUsr', Email='testUser_axiom01@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testUser@testorg01.com');
        insert testUser; 
        User testUser1 = new User(Alias = 'testUsr', Email='testUser1_axiom01@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testUser1@testorg01.com');
        insert testUser1;              

		Id contactRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Dashboard User').getRecordTypeId();
		Contact con1 = new Contact();
		con1.LastName = 'JO User one';
		con1.Email = 'abc@g.com';
		con1.RecordTypeId = contactRecType;
		con1.Related_User__c = testUser1.Id;		
		insert con1;
		Contact con2 = new Contact();
		con2.LastName = 'JO User two';
		con2.Email = 'xyz@g.com';
		con2.RecordTypeId = contactRecType;
		con2.Related_User__c = testUser.Id;
		insert con2;

		Id notiRecType = Schema.SObjectType.Notifications__c.getRecordTypeInfosByName().get('AS').getRecordTypeId();		
		List<Notifications__c> notList = new List<Notifications__c>();
		Notifications__c not1 = new Notifications__c();
		not1.RecordTypeId = notiRecType;
		not1.Name = 'Notification one';
		not1.Jb_Owner__c = con2.Id;
		not1.Notification_Status__c = 'SUBM';
		notList.add(not1);
		Notifications__c not2 = new Notifications__c();
		not2.RecordTypeId = notiRecType;
		not2.Name = 'Notification two';
		not2.Jb_Owner__c = con2.Id;
		not2.Notification_Status__c = 'SUBM';
		notList.add(not1);

		Id configDashRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        Customer_Config__c cust = new Customer_Config__c(); 
        cust.Job_Owner__c = con2.Id;        
        cust.View_Name__c = 'Default Dashboard';
        cust.RecordTypeId = configDashRecType;
        insert cust;        
        Id configChartRecType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Chart').getRecordTypeId();
        Customer_Config__c cust1 = new Customer_Config__c(); 
        cust1.Job_Owner__c = con2.Id;        
        cust1.View_Name__c = 'Chart Configurations';
        cust1.RecordTypeId = configChartRecType;
        cust1.Json_Config__c = 'SUBM,PEND,APPR'; 
        cust1.User_Config__c= cust.Id;       
        insert cust1;
        
	}

	static testMethod void fetchNotificationLsts(){
		List<String> jobOwnerIds = new List<String>();
		List<Notifications__c> noList = [select id from Notifications__c where Notification_Status__c='SUBM'];
		for(Contact a: [select id from contact where LastName IN('JO User one','JO User two')])
		{
			jobOwnerIds.add(String.valueOf(a));
		}
		Test.startTest();
			List<Id> nlist =JO_GraphData.fetchNotificationLsts(jobOwnerIds,'SUBM');
		Test.stopTest();
		system.assertEquals(noList.size(),nlist.size(),'Successfully Executed');
	}

	static testMethod void getConfigStatusLst(){
		Contact c1 = [SELECT id FROM contact where LastName='JO User two'];
		Contact c2 = [SELECT id FROM contact where LastName='JO User one'];
		Customer_Config__c cust1 = [SELECT id,Json_Config__c FROM Customer_Config__c where View_Name__c='Default Dashboard'];
		Map<String,String> status = new Map<String,String>();
		status.put('SUBM','SUBM');
		status.put('PEND','PEND');
		status.put('APPR','APPR');
		Test.startTest();
			List<String> configList = JO_GraphData.getConfigStatusLst(String.valueOf(c1.Id),status,cust1);
			system.assert(configList.size()>0,'Successfully Executed');
			List<String> configList1 = JO_GraphData.getConfigStatusLst(String.valueOf(c2.Id),status,cust1);
			system.assert(configList1.size()>0,'Successfully Executed');
		Test.stopTest();
	}

	static testMethod void getPieChartData(){
		List<String> jobOwnerIds = new List<String>();		
		User loggedUser = [SELECT id,LastName FROM User WHERE Email='testUser_axiom01@testorg.com'];
		Customer_Config__c cust1 = [SELECT id,Json_Config__c FROM Customer_Config__c where View_Name__c='Default Dashboard'];
		for(Contact a: [Select Id,lastname From Contact Where Related_User__c=:loggedUser.id]){
			jobOwnerIds.add(String.valueOf(a.id));
		}
		
		Test.startTest();
			system.runAs(loggedUser){
				List<JO_Wrapper.JO_PIEChart> bList = JO_GraphData.getPieChartData(jobOwnerIds,cust1);
			}
		Test.stopTest();
	}

	static testMethod void getBarChartData(){
		List<String> jobOwnerIds = new List<String>();		
		User loggedUser = [SELECT id,LastName FROM User WHERE UserName='testUser@testorg01.com'];
		
		Customer_Config__c cust1 = [SELECT id,Json_Config__c FROM Customer_Config__c where View_Name__c='Default Dashboard'];
		for(Contact a: [Select Id,lastname From Contact Where Related_User__c=:loggedUser.id]){			
			jobOwnerIds.add(String.valueOf(a.Id));
			system.debug('@@@:jobOwnerIds:'+a.lastname);
		}				
		Test.startTest();
			system.runAs(loggedUser){
				List<JO_Wrapper.JO_BarChart> bList = JO_GraphData.getBarChartData(jobOwnerIds,cust1);
			}
		Test.stopTest();
	}
}