public  class JO_EmailCustom {
    @AuraEnabled
    public static List<WrapperData> sendEmail(string RecId, string EmailID) {
        
        
        string UsID=UserInfo.getUserId();
        User us=[select id,Name,Email from User where id=:UsID];
        List<Notifications__c> nflst=[select id,Name,Customer_Email__c,ApplicantAddress__c,Customer__c,EmailTemplateDate__c from Notifications__c where id=:RecId];
        List<Order__c> ordlst=[select id,Name,Notification_Order__c,Notification_Order__r.EmailTemplateDate__c,Job_Owner__c,Notification_Order__r.Customer_Email__c,Notification_Order__r.ApplicantAddress__c from Order__c where id =: RecId];
        
        EmailTemplate em=[select id, Name,Subject,CreatedDate,HtmlValue,Body,DeveloperName from EmailTemplate where id =: EmailID];
        List<WrapperData> wrapEmailList = new List<WrapperData>();
        string userEmail;
        string CustomerEmail;
        String EmailTemplateDate;
        string ApplicantAddress;
        string Customer;
        string htmlbody;
        String html;
        string Bcc;
        string cc;
        if(nflst.size()>0)
        {
            for(Notifications__c nf :nflst)
            {
                 userEmail=us.Email;
                 CustomerEmail=nf.Customer_Email__c;
                 EmailTemplateDate=nf.EmailTemplateDate__c;
                 ApplicantAddress=nf.ApplicantAddress__c;
                 Customer=nf.Customer__c;
                 htmlbody=em.HtmlValue;
                 html = htmlbody.stripHtmlTags();
            }
            wrapEmailList.add(new wrapperData(userEmail,CustomerEmail,em,ApplicantAddress,Customer,html,EmailTemplateDate,'',''));
        }
        else
        {
            for(Order__c ord : ordlst)
            {
                userEmail=us.Email;
                 CustomerEmail=ord.Notification_Order__r.Customer_Email__c;
                 EmailTemplateDate=ord.Notification_Order__r.EmailTemplateDate__c;
                 ApplicantAddress=ord.Notification_Order__r.ApplicantAddress__c;
                 Customer=ord.Job_Owner__c;
                 htmlbody=em.HtmlValue;
                 html = htmlbody.stripHtmlTags();
            }
             wrapEmailList.add(new wrapperData(userEmail,CustomerEmail,em,ApplicantAddress,Customer,html,EmailTemplateDate,'',''));
        }
        
      //  system.debug('Wrapper Data==>>>'+wrapEmailList);
        return wrapEmailList;
    }
    @AuraEnabled
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody, string RecId,string TemplateId, string ccmail, string bccmail)
    {
        system.debug('Record Email ==>>'+mMail);
        system.debug('Record Subject ==>>'+mSubject);
        system.debug('Record Body ==>>'+mbody);
        system.debug('Record Id ==>>'+RecId);
        system.debug('Record Template ID ==>>'+TemplateId);
        system.debug('Record CC ==>>'+ccmail);
        system.debug('Record Bcc ==>>'+bccmail);        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendbcc = new List<String>();
        sendbcc.add(bccmail);
         List<String> sendTo = new List<String>();
        sendTo.add(mMail);
         List<String> sendcc = new List<String>();
        sendcc.add(ccmail);
        mail.setToAddresses(sendTo);
       // mail.setCcAddresses(sendcc);
      //  mail.setBccAddresses(sendbcc);
         String Recd='a2R2F000000EjZhUAK';
        mail.setReplyTo('dineshreddyvakati@gmail.com');
        mail.setSenderDisplayName(mSubject); 
        mail.setSubject(mSubject);
        mail.setHtmlBody(mbody);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setTreatTargetObjectAsRecipient(false); 
        mail.setTemplateId(TemplateId);
        mail.setWhatId(Recd);
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
        public string ApplicantAddress {get; set;}
        @Auraenabled
        public string Customer {get; set;}
        @Auraenabled
        public String EmailTemplateDate {get; set;}
        @Auraenabled
        public EmailTemplate EmailTemp {get; set;}
        @Auraenabled
        public string html {get; set;}
        @Auraenabled
        public string bcc {get; set;}
        @Auraenabled
        public string cc {get; set;}
        public wrapperData(string UserEmail,string CustomerEmail,EmailTemplate EmailTemp,string ApplicantAddress, string Customer,string html, String EmailTemplateDate,string bcc,string cc)
        {
            this.UserEmail=UserEmail;
            this.CustomerEmail=CustomerEmail;
            this.ApplicantAddress=ApplicantAddress;
            this.Customer=Customer;
            this.EmailTemplateDate=EmailTemplateDate;
            this.EmailTemp=EmailTemp;
            this.html=html;
            this.bcc=bcc;
            this.cc=cc;
        }
    }
}