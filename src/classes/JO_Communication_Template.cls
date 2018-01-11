public class JO_Communication_Template{
    private static Set<Id> taskWhatIDs = new set<Id>();
    @AuraEnabled
    public static List<WrapperData> getEmailtemplate(string RecId) {
        List<Email_Template_Master__c> Emlst;
        List<Notifications__c> Notifilst = [SELECT Id,Name, Notification_Order__c FROM  Notifications__c WHERE Id =:RecId];
        List<Order__c> ordlst=[select id,Name,Notification_Order__c from Order__c where id =: RecId];
        if(Notifilst.size() >0)
        {
            Emlst =[SELECT Id,Name, Email_Template__c,Business_Name__c,Sort_Order__c,Object_Type__c,Object_Record_Type__c,Is_Active__c FROM Email_Template_Master__c where Object_Type__c='Notification' order by Sort_Order__c ];
        }
        else
        {
            Emlst =[SELECT Id,Name, Email_Template__c,Business_Name__c,Sort_Order__c,Object_Type__c,Object_Record_Type__c,Is_Active__c FROM Email_Template_Master__c where Object_Type__c='Order' order by Sort_Order__c ];
        }
        for(Notifications__c lst :Notifilst)
        {
            taskWhatIDs.add(lst.Id);
        }
        for(Order__c ord : ordlst)
        {
            taskWhatIDs.add(ord.Id);
        }
        
        List<EmailMessage> emmes=[SELECT id,MessageDate,RelatedToId,Status,Subject,CreatedBy.Name FROM EmailMessage where RelatedToId In : taskWhatIDs order by CreatedDate DESC ];        
        List<WrapperData> wrapEmailList = new List<WrapperData>();
        Map<String,Integer> recordcount=new Map<String,Integer>(); 
        for(Email_Template_Master__c em : Emlst)
        {
            wrapEmailList.add(new wrapperData(null,'',em,'',0));
        }
        for(EmailMessage tk : emmes)
            {
                
                system.debug(tk.Subject +'<<===Record Count ==>>'+recordcount);
                
                if(recordcount.get(tk.Subject) != null){
                    recordcount.put(tk.Subject, recordcount.get(tk.Subject)+1) ;                
                }
                else {
                    recordcount.put(tk.Subject, 1);
                }
                
            }
        for(WrapperData w : wrapEmailList)
        {
            for(EmailMessage tk : emmes)
            {
                if(w.EmailTemp.Name.contains(string.valueof(tk.Subject)))
                {
                    w.SentDate=tk.MessageDate;
                    w.SentByName=tk.CreatedBy.Name;
                    w.EmailmessageId=tk.id;
                    break;
                }
            }
            
            w.recordCount = recordcount.get(w.EmailTemp.Name);
        }
        
        return wrapEmailList;
    }
    public class WrapperData
    {
        @Auraenabled
        public DateTime  SentDate {get; set;}
        @Auraenabled
        public string SentByName {get; set;}
        @Auraenabled public Integer recordCount {get; set;}
        @Auraenabled
        public Email_Template_Master__c EmailTemp {get; set;}
        @Auraenabled
        public string EmailmessageId {get; set;}
        @Auraenabled
       @testvisible public string EmailTempName 
        {
            get
            {
                return EmailTemp.Name;
            }
        }
        public wrapperData(DateTime  SentDate,string SentByName,Email_Template_Master__c EmailTemp,string EmailmessageId, Integer recordCount)
        {
            this.SentDate=SentDate;
            this.EmailTemp=EmailTemp;
            this.recordCount=recordCount;
            this.SentByName=SentByName;
            this.EmailmessageId=EmailmessageId;
        }
    }    
}