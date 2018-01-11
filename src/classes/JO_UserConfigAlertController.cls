public class JO_UserConfigAlertController {
    @AuraEnabled 
    public static Id getLoogedInContact(){
        return Userinfo.getUserId();
    }
    @AuraEnabled
    public static List<Contact> getAllJobOwners(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List < Contact > returnList = new List < Contact > ();
        
        List<Contact> conList= [Select id, FirstName,LastName,Email,JO_Corp_ID__c FROM Contact Where JO_Corp_ID__c!=NULL AND Name LIKE: searchKey  Order by JO_Corp_ID__c limit 300 ];
        for (Contact acc: conList) {
            returnList.add(acc);
        }
        return returnList;
    }
      
  
    @AuraEnabled
    public static String getloggedUser(){        
        return JO_Util.getLoggedInContact(UserInfo.getUserId());
    }
    
    
}