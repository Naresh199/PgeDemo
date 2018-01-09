public class JO_JobDBAppController {
    public static List<String> userDetails {get; set;}

    @AuraEnabled
    public static List<String> getUserInfo(){
        userDetails = new  List<String>();
        userDetails.add(UserInfo.getName()); 
        userDetails.add([Select Id,Name,Related_User__c From Contact Where Related_User__c=:UserInfo.getUserId()].Id);  
        return userDetails;
    }
}