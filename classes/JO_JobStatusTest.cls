@isTest
Private class JO_JobStatusTest
{
    Static Testmethod void JO_JobStatus()
    {
        
        Contact con1 = new Contact();
        con1.LastName = 'JO User one';
        con1.Email = 'abc@g.com';
        insert con1; 
        
        Task task = New Task();
        task.Notification__c = 'test02';
        //task.Who = con1.id;
        insert task;
        
        JO_Status__c joStatus =  New JO_Status__c();
        joStatus.Name = 'test01';
        joStatus.Status__c = 'SUBM';
        joStatus.CreatedDate = system.today();
        joStatus.Notification_Task__c = task.id;
        insert joStatus;
    }
    Static testMethod void JOStatus()
    {
        String taskId = 'tets03';
        List<JO_Status__c> jostatuslist = [SELECT id From JO_Status__c];
        Test.startTest();
        List<JO_Status__c> nlist =JO_JobStatus.getJOStatus(taskId);
        Test.stopTest();
    }
    
}