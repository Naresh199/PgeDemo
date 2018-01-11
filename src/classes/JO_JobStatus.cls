public class JO_JobStatus {
    
    @Auraenabled
    public static List<JO_Status__c> getJOStatus(string taskId){
        return [Select id,Name,Status__c,CreatedDate from JO_Status__c where Notification_Task__c = :taskId]; 
    }
}