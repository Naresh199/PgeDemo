public class JO_CommunicationHistory
{ 
   @testvisible private static Set<Id> taskWhatIDs = new set<Id>();
    @Auraenabled
    public Static List<wrapperData> getTask(String RecId)
    {
        List<Order__c> notifordlst=[select Id,Name,Notification_Order__c,Notification_Order__r.Name,Notification_Order__r.RecordType.Name,RecordType.Name,(select id,Name,RecordType.Name from  Sub_Orders__r) from Order__c where Notification_Order__c= :RecId];
        system.debug('Notification Object id Passed List ==>>'+notifordlst);
        
        List<Order__c> ordlst=[select Id,Name,Notification_Order__c,Notification_Order__r.Name,Notification_Order__r.RecordType.Name,RecordType.Name,(select id,Name,RecordType.Name from  Sub_Orders__r) from Order__c where Id= : RecId];
        system.debug('Oder Object Id Passed List ==>>'+ordlst);
        List<Order__c> suborderlist;
        for(Order__c ord : notifordlst)
        {
            suborderlist=ord.Sub_Orders__r;
            for(Order__c sord : suborderlist)
            {
                taskWhatIDs.add(sord.Id);
            }
            taskWhatIDs.add(ord.Id);
            taskWhatIDs.add(ord.Notification_Order__c);
            system.debug('Oder Object Id ==>>'+taskWhatIDs);
        }
        for(Order__c ord : ordlst)
        {
            suborderlist=ord.Sub_Orders__r;
            for(Order__c sord : suborderlist)
            {
                taskWhatIDs.add(sord.Id);
            }
            taskWhatIDs.add(ord.Id);
            system.debug('Oder Object Id ==>>'+taskWhatIDs);
        }
        List<EmailMessage> emailmess=[SELECT id,MessageDate,RelatedToId,Status,Subject FROM EmailMessage where RelatedToId In : taskWhatIDs order by MessageDate DESC];
        system.debug('Email sent List data==>>'+emailmess.size());
        List<WrapperData> wrapEmailList = new List<WrapperData>();
        
        for(EmailMessage emailmes : emailmess)
        {
            wrapEmailList.add(new wrapperData('','','',emailmes));
        }
        for(WrapperData wr : wrapEmailList)
        {
            String sObjName = wr.EmailMess.RelatedToId.getSObjectType().getDescribe().getLabel(); 
            system.debug('Object Name==>>'+sObjName);
            if(notifordlst.size()>0)
            {
                for(Order__c ordls : notifordlst)
                {
                    if(wr.EmailMess.RelatedToId == ordls.Id)
                    {
                        if(sObjName == 'Orders')
                        {
                            wr.RecordId=ordls.Id;
                            wr.RecordName=ordls.Name;
                            wr.RecordType=ordls.RecordType.Name + ':' + sObjName;
                        }
                    }
                    else if(wr.EmailMess.RelatedToId == ordls.Notification_Order__c)
                    {
                        if(sObjName == 'Notifications')
                        {
                            wr.RecordId=ordls.Notification_Order__c;
                            wr.RecordName=ordls.Notification_Order__r.Name;
                            wr.RecordType=ordls.Notification_Order__r.RecordType.Name + ':' + sObjName;
                        }
                    }
                }
                for(Order__c subord : suborderlist)
                {
                    if(wr.EmailMess.RelatedToId == subord.Id)
                    {
                        if(sObjName == 'Orders')
                        {
                            wr.RecordId=subord.Id;
                            wr.RecordName=subord.Name;
                            wr.RecordType=subord.RecordType.Name +':' + sObjName;
                        }
                    }
                }
            }
            else
            {
                for(Order__c ordls : ordlst)
                {
                    if(wr.EmailMess.RelatedToId == ordls.Id)
                    {
                        if(sObjName == 'Orders')
                        {
                            wr.RecordId=ordls.Id;
                            wr.RecordName=ordls.Name;
                            wr.RecordType=ordls.RecordType.Name + ':' + sObjName;
                        }
                    }
                }
                for(Order__c subord : suborderlist)
                {
                    if(wr.EmailMess.RelatedToId == subord.Id)
                    {
                        if(sObjName == 'Orders')
                        {
                            wr.RecordId=subord.Id;
                            wr.RecordName=subord.Name;
                            wr.RecordType=subord.RecordType.Name +':' + sObjName;
                        }
                    }
                }
            }
            
        }
        return wrapEmailList;
    }
    public class WrapperData
    {
        @Auraenabled
        public String RecordId {get; set;}
        @Auraenabled
        public String RecordName {get; set;}
        @Auraenabled
        public String RecordType {get; set;}
        @Auraenabled
        public EmailMessage EmailMess {get; set;}
        @Auraenabled
       @testvisible public string EmailTempName 
        {
            get
            {
                return EmailMess.Subject;
            }
        }
        public wrapperData(String RecordId,String RecordName,String RecordType,EmailMessage EmailMess)
        {
            this.RecordId=RecordId;
            this.RecordName=RecordName;
            this.RecordType=RecordType;
            this.EmailMess=EmailMess;
        }
    }
}