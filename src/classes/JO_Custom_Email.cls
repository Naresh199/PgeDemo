public class JO_Custom_Email 
{
    @AuraEnabled
    public static List<WrapperData> getSendData(string EmailID, string RecId) 
    {
        string UsID=UserInfo.getUserId();
        User activeUser=[select id,Name,Email from User where id=:UsID];
        String userEmail = activeUser.Email;
        Id rec=Id.valueof(RecId);
        String sObjName = rec.getSObjectType().getDescribe().getLabel(); 
        Notifications__c nf;
        Order__c ord;
        if(sObjName == 'Notifications')
        {
             nf=[select id,Name,Jb_Owner__c,Customer_Email__c,JobOwnerEmail__c,ApplicantAddress__c,Customer__c,EmailTemplateDate__c from Notifications__c where id=:RecId];
        }
        else if(sObjName == 'Orders')
        {
             ord=[select id,Name,Notification_Order__c,Notification_Order__r.EmailTemplateDate__c,Notification_Order__r.JobOwnerEmail__c,Notification_Order__r.Jb_Owner__c,Notification_Order__r.Customer_Email__c,Notification_Order__r.ApplicantAddress__c from Order__c where id =: RecId];
        }
        
        Email_Template_Master__c emptmp=[select id,Name,Business_Name__c,Email_Template__c from Email_Template_Master__c where Email_Template__c=: EmailID];
        system.debug('Email master list==>'+emptmp);
       // EmailTemplate tmp=[select id, Name,Subject,CreatedDate,HtmlValue,Body,DeveloperName from EmailTemplate where id =: EmailID];
        Savepoint sp = Database.setSavepoint();
        Messaging.singleEmailMessage mail=new Messaging.singleEmailMessage();
        
        mail.setTemplateId(emptmp.Email_Template__c); 
        if(sObjName == 'Notifications')
        {
            mail.setToAddresses(new String[] { nf.JobOwnerEmail__c });
            system.debug('Contact Id==>>'+nf.Jb_Owner__c);
            mail.setWhatId(nf.Id);
            system.debug('Contact Id==>>'+nf.Jb_Owner__c);
            mail.setTargetObjectId(nf.Jb_Owner__c);
        }
        else if(sObjName == 'Orders'){
            mail.setToAddresses(new String[] { ord.Notification_Order__r.JobOwnerEmail__c });
            mail.setWhatId(ord.Id);
            system.debug('Contact Id==>>'+ord.Notification_Order__r.Jb_Owner__c);
            mail.setTargetObjectId(ord.Notification_Order__r.Jb_Owner__c);
        }
        mail.setSaveAsActivity(false);
        mail.setTreatTargetObjectAsRecipient(false); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        Database.rollback(sp);
        string HtmlBody=mail.getHtmlbody();
        List<WrapperData> wrapEmailList = new List<WrapperData>();
        string UserEmal;
        string CustomerEmail;
        string Htmltmpbody;
        string subject;
        string businessname;
        if(sObjName == 'Notifications')
        {
            UserEmal=userEmail;
            CustomerEmail=nf.Customer_Email__c;
            Htmltmpbody=HtmlBody;
            subject=emptmp.Name;
            businessname=emptmp.Business_Name__c;
            wrapEmailList.add(new wrapperData(UserEmal,CustomerEmail,Htmltmpbody,subject,businessname));
        }
        else if(sObjName == 'Orders')
        {
            UserEmal=userEmail;
            CustomerEmail=ord.Notification_Order__r.Customer_Email__c;
            Htmltmpbody=HtmlBody;
            subject=emptmp.Name;
            businessname=emptmp.Business_Name__c;
            wrapEmailList.add(new wrapperData(UserEmal,CustomerEmail,Htmltmpbody,subject,businessname));
        }
        return wrapEmailList;
    }
    @AuraEnabled
    public static void addfiledata(String EmailID,String fileName, String base64Data, String contentType) 
    {
        
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        List<Attachment> aad = new List<Attachment>();
        Attachment a = new Attachment();
        a.parentId = EmailID;
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        system.debug('Email Tempalte Id==>'+EmailID);
        insert a;
    }
    @AuraEnabled
    public static void sendEmailTCust(string EmailAdd,string Subject,string Html,string RecordId,string EmailID) 
    {
        system.debug('Template Id==>>'+EmailID);
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(EmailAdd);
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName(Subject); 
        mail.setSubject(Subject);
        mail.setHtmlBody(Html);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setTreatTargetObjectAsRecipient(false); 
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :EmailID])
        {
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
        }
        mail.setFileAttachments(fileAttachments);
        mail.setWhatId(RecordId);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    public class WrapperData
    {
        @Auraenabled
        public string UserEmail {get; set;}
        @Auraenabled
        public string CustomerEmail {get; set;}
        @Auraenabled
        public string Htmlbody {get; set;}
        @Auraenabled
        public string subject {get; set;}
        @Auraenabled
        public string businessname {get; set;}
        public wrapperData(string UserEmail,string CustomerEmail,string Htmlbody,string subject,string businessname)
        {
            this.UserEmail=UserEmail;
            this.CustomerEmail=CustomerEmail;
            this.Htmlbody=Htmlbody;
            this.subject=subject;
            this.businessname=businessname;
        }
    }
}