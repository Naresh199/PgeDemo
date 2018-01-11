Global class JO_Wrapper implements Comparable {
    
    public enum SORT_BY {SortNo}
    
    public static SORT_BY sortBy = SORT_BY.SortNo;
    
    global Integer compareTo(Object objToCompare) {
        //Sort by BookName Alphabetically
        /*if(sortBy == SORT_BY.SortNo)
        {
            return BookTitle.compareTo(((Book)objToCompare).BookTitle);
        }
        else //Sort by Book price
        {
            return Integer.valueOf(Price - ((Book)objToCompare).Price);
        }*/
        return 0;
    }

    
    
    public class PortfolioFieldsList {
        @auraEnabled public List<PortfolioFields> viewfields{get; set;}
        public PortfolioFieldsList(List<PortfolioFields> lsds)
        {
            this.viewfields = lsds;
        }
    }
    public class PortfolioViewsAndRecords {
        @auraEnabled public List<JO_Wrapper.PortfolioViews> allViewLst {get; set;} 
        @auraEnabled public List<Notifications__c> records{get; set;}
        @auraEnabled public Integer recordCount{get; set;}
        public PortfolioViewsAndRecords(List<JO_Wrapper.PortfolioViews> allViewLst,List<Notifications__c> records){
            this.allViewLst = allViewLst;
            this.records = records;
        }
    }
    public class PortfolioListViews {
        @auraEnabled public List<JO_Wrapper.PortfolioViews> allViewLst {get; set;} 
        @auraEnabled public Integer recordCount{get; set;}
        public PortfolioListViews(){
            this.allViewLst = new List<JO_Wrapper.PortfolioViews>() ;
        }
    }
    public class PortfolioFields{
        @auraEnabled public String fieldAPI{get; set;} 
        @auraEnabled public String fieldType{get; set;}
        @auraEnabled public String fieldApiLabel{get; set;} 
        @auraEnabled  public String customLabel {get; set;}
        @auraEnabled public boolean visible {get; set;}
        @auraEnabled public decimal order {get; set;}
        public PortfolioFields (String flds,String sysLabel,String customLabel, boolean visible, decimal order){
            this.fieldAPI = flds;
            this.fieldType = String.valueOf(JO_Util.getFieldDescribe('Notifications__c',flds).getType());
            this.fieldApiLabel = sysLabel;
            this.customLabel = customLabel; 
            this.visible = visible;
            this.order = order;
        }
    }
    public class PortfolioViews{
        @auraEnabled public String viewName {get; set;}
        @auraEnabled public integer count {get; set;}
        @auraEnabled public String  viewId {get; set;}
        @auraEnabled public boolean isAdmin {get; set;}
        @auraEnabled public boolean isDefault {get; set;}
        @auraEnabled public boolean isActive {get; set;}
        @auraEnabled public Integer sortOrder  {get; set;}
        @auraEnabled public String dashboardId  {get; set;}
        @auraEnabled public List<PortfolioFields> viewfields{get; set;}        
        public PortfolioViews(String viewName, String viewId,boolean isAdmin,boolean isDefault,boolean isActive, List<PortfolioFields> viewfields, Integer sortOrder){
            this.viewName = viewName;
            this.viewId = viewId;
            this.isAdmin = isAdmin;
            this.isDefault = isDefault;
            this.isActive = isActive;
            this.viewfields = viewfields;
            this.count = 0;
            this.sortOrder = sortOrder;
        }
    }
    public class JO_StringWrapper{
        @AuraEnabled public List<JO_ChartConfigWrapper> left{get;set;}
        @AuraEnabled public List<String> right{get;set;}
        @AuraEnabled public String userConfigId {get;set;}
        //@AuraEnabled public String recordTypeId {get;set;}
    }
    
    public class JO_ChartConfigWrapper{
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String label{get;set;}
        //@AuraEnabled public List<String> userConfigList{get;set;}
    }
    
    public class JO_BarChart {
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public Map<string ,string> drill{get;set;}
        public JO_BarChart(String namevalue, Map<string ,string> drills) {
            name = namevalue;
            drill = drills;
        }
        
    }
    public class JO_PIEChart {
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public Decimal data{get;set;}        
        public JO_PIEChart(String namevalue, Decimal datavalue)
        {
            name = namevalue;
            data = datavalue;
        }        
    }
    
    public class JO_AlertCountWrapper{
        @AuraEnabled public String alertId{get;set;} 
        @AuraEnabled public String alertNo{get;set;} 
        @AuraEnabled public String alertQuery{get;set;} 
        @AuraEnabled public String notificationQuery{get;set;} 
        @AuraEnabled public String nofticationId{get;set;} 
        @AuraEnabled public List<Id> lstNotifications{get;set;} 
        @AuraEnabled public String alertName{get;set;} 
        @AuraEnabled public Integer alertCount{get;set;} 
        @AuraEnabled public boolean isHide{get;set;} 
        @auraEnabled public boolean isEnabled {get;set;} 
        @auraEnabled public String sysPriority {get;set;}
        @auraEnabled public String alertType {get;set;}
        @auraEnabled public Integer sortOrder {get;set;}
        @auraEnabled public String selectedUserPriority {get;set;}
    }
    
    public class JO_AlertConfigWrapperList {
        @auraEnabled public List<JO_AlertConfigWrapper> viewfields{get; set;}
        public JO_AlertConfigWrapperList(List<JO_AlertConfigWrapper> lsds)
        {
            this.viewfields = lsds;
        }
    }
    
    public class JO_AlertConfigWrapper{
        @auraEnabled public String Id {get;set;}
        @auraEnabled public String joAlertName {get;set;} 
        @auraEnabled public boolean isHidden {get;set;} 
        @auraEnabled public boolean isEnabled {get;set;} 
        @auraEnabled public String sysPriority {get;set;}
        @auraEnabled public String alertType {get;set;}
        //@auraEnabled public List<String> userPriority {get;set;} 
        @auraEnabled public Integer sortOrder {get;set;}
        @auraEnabled public String selectedUserPriority {get;set;}
      
        
        public JO_AlertConfigWrapper(String cAlertId, String joName,boolean isHidden,boolean isEnabled,String selectedUserPriority,String sysPriority, Integer sortOrder, String alertType){
            this.Id = cAlertId;
            this.joAlertName = joName;
            this.isHidden = isHidden ;
            this.isEnabled = isEnabled !=null ? isEnabled : true;
            this.selectedUserPriority = selectedUserPriority != null? selectedUserPriority : '';   
            this.sysPriority = sysPriority;
            this.alertType = alertType;
            this.sortOrder = sortOrder;
        }
    }
    
    public class JO_AlertConfigWrapperViews{
        @auraEnabled public String viewName {get; set;}
        @auraEnabled public Id viewId {get; set;}
        @auraEnabled public boolean isAdmin {get; set;}
        @auraEnabled public boolean isDefault {get; set;}
        @auraEnabled public boolean isActive {get; set;}
        @auraEnabled public Integer sortOrder  {get; set;}
        @auraEnabled public String dashboardId  {get; set;}
        @auraEnabled public List<JO_AlertConfigWrapper> viewfields {get;set;}
        public JO_AlertConfigWrapperViews(String viewName, Id viewId,boolean isAdmin,boolean isDefault,boolean isActive, Integer sortOrder,List<JO_AlertConfigWrapper> viewfields){
            this.viewName = viewName;
            this.viewId = viewId;
            this.isAdmin = isAdmin;
            this.isDefault = isDefault;
            this.isActive = isActive;
            this.sortOrder = sortOrder;
            this.DashboardId = DashboardId;
            this.viewfields = viewfields;
        }
    }
    public class JO_StringWrapperConfig{
        @AuraEnabled public List<JO_ChartConfigWrapperConfig> left{get;set;}
        @AuraEnabled public List<String> right{get;set;}    
        @AuraEnabled public String userConfigId {get;set;}
    }
    
    public class JO_ChartConfigWrapperConfig{
        @AuraEnabled public String value{get;set;}
        @AuraEnabled public String label{get;set;}
    }
}