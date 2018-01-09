@IsTest
public class JO_GlobalFiltersTest {
    
    testMethod static void logedInContactTest()
    {
        test.startTest();
        JO_GlobalFilters.getLoogedInContact();
        test.stopTest();
    }
    
    testMethod static void AllJobOwnersTest()
    {
        test.startTest();
        JO_GlobalFilters.getAllJobOwners();
        test.stopTest();   
    }
    /*
testMethod static void loggedUserTest()
{
test.startTest();
JO_GlobalFilters.getloggedUser();
test.stopTest();   
}*/
    
    testMethod static void dashboardViewsTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        Insert con;
        
        
        test.startTest();
        JO_GlobalFilters.getDashboardViews(con.id);
        test.stopTest();   
        
        
    }
    
    // typestr== 'New'
    testMethod static void newDashboardRecordTest()
    {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        lstCon.add(con);
        
        Contact con1 = new Contact();
        con1.AccountId = acc.Id;
        con1.LastName = 'Test Contact1';
        lstCon.add(con1);
        Insert lstCon;
        
        List<String> lstStr = new List<String>();
        for(Contact c:lstCon)
        {
            lstStr.add(c.name);
        }
        Id RecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        
        Customer_Config__c PDb = new Customer_Config__c();
        PDb.Job_Owner__c = con.id;
        PDb.Is_Active__c = true;
        PDb.Is_Default__c = true;
        PDb.RecordTypeId = RecordType;
        Insert PDb;
        
        Customer_Config__c CDb = new Customer_Config__c();
        CDb.User_Config__c = PDb.Id;
        CDb.Job_Owner__c = con.id;
        CDb.Is_Active__c = true;
        CDb.Is_Default__c = true;
        CDb.RecordTypeId = RecordType;
        Insert CDb;
        
        String dashboardId = PDb.Id;
        String dashboardName = PDb.Name;
        Boolean dashboardActive = PDb.Is_Active__c;
        Boolean dashboardDefault = PDb.Is_Default__c;
        String loggedInContact = Con.Id;
        List<String> globalFilterRecs = lstStr;
        String typestr = 'New';
        
        
        test.startTest();
        JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
        test.stopTest();   
        
        
    }
    // typestr== 'Edit'
    testMethod static void newDashboardRecordTest2()
    {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        lstCon.add(con);
        
        Contact con1 = new Contact();
        con1.AccountId = acc.Id;
        con1.LastName = 'Test Contact1';
        lstCon.add(con1);
        Insert lstCon;
        
        List<String> lstStr = new List<String>();
        for(Contact c:lstCon)
        {
            lstStr.add(c.name);
        }
        Id RecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        
        Customer_Config__c PDb = new Customer_Config__c();
        PDb.Job_Owner__c = con.id;
        PDb.Is_Active__c = true;
        PDb.Is_Default__c = true;
        PDb.RecordTypeId = RecordType;
        Insert PDb;
        
        Customer_Config__c PDb1 = new Customer_Config__c();
        PDb1.Job_Owner__c = con.id;
        PDb1.Is_Active__c = true;
        PDb1.Is_Default__c = false;
        PDb1.RecordTypeId = RecordType;
        Insert PDb1;
        
        
        Customer_Config__c CDb = new Customer_Config__c();
        CDb.User_Config__c = PDb.Id;
        CDb.Job_Owner__c = con.id;
        CDb.Is_Active__c = true;
        CDb.Is_Default__c = true;
        CDb.RecordTypeId = RecordType;
        Insert CDb;
        
        String dashboardId = PDb.Id;
        String dashboardName = PDb.Name;
        Boolean dashboardActive = PDb.Is_Active__c;
        Boolean dashboardDefault = PDb.Is_Default__c;
        String loggedInContact = Con.Id;
        List<String> globalFilterRecs = lstStr;
        String typestr ='Edit';
        
        
        test.startTest();
        JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
        test.stopTest();   
        
         String dashboardId1 = PDb1.id;
        JO_GlobalFilters.newDashboardRecord(dashboardId1, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
        
        
    }
    
    // IsAdmi== false
    testMethod static void newDashboardRecordTest3()
    {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        lstCon.add(con);
        
        Contact con1 = new Contact();
        con1.AccountId = acc.Id;
        con1.LastName = 'Test Contact1';
        lstCon.add(con1);
        Insert lstCon;
        
        List<String> lstStr = new List<String>();
        for(Contact c:lstCon)
        {
            lstStr.add(c.name);
        }
        Id RecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        
        Customer_Config__c PDb = new Customer_Config__c();
        PDb.Job_Owner__c = con.id;
        PDb.Is_Active__c = true;
        PDb.Is_Default__c = true;
        PDb.Is_Admin__c = false;
        PDb.RecordTypeId = RecordType;
        Insert PDb;
        
        Customer_Config__c CDb = new Customer_Config__c();
        CDb.User_Config__c = PDb.Id;
        CDb.Job_Owner__c = con.id;
        CDb.Is_Active__c = true;
        CDb.Is_Default__c = true;
        CDb.Is_Admin__c = false;
        CDb.RecordTypeId = RecordType;
        Insert CDb;
        
        PDb.Is_Default__c = false;
		upsert PDb;
        
        CDb.Is_Default__c = false;
		upsert CDb;

        
        String dashboardId = PDb.Id;
        String dashboardName = PDb.Name;
        Boolean dashboardActive = PDb.Is_Active__c;
        Boolean dashboardDefault = PDb.Is_Default__c;
        String loggedInContact = Con.Id;
        List<String> globalFilterRecs = lstStr;
        String typestr ='Edit';
        
        
        test.startTest();
        JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
        test.stopTest();   
        
        
    }  
    
    // IsAdmi== false
    testMethod static void newDashboardRecordTest4()
    {
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        lstCon.add(con);
        
        Contact con1 = new Contact();
        con1.AccountId = acc.Id;
        con1.LastName = 'Test Contact1';
        lstCon.add(con1);
        Insert lstCon;
        
        List<String> lstStr = new List<String>();
        for(Contact c:lstCon)
        {
            lstStr.add(c.name);
        }
        Id RecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        
        Customer_Config__c PDb = new Customer_Config__c();
        PDb.Job_Owner__c = con.id;
        PDb.Is_Active__c = true;
        PDb.Is_Default__c = false;
        //PDb.Is_Admin__c = false;
        PDb.RecordTypeId = RecordType;
        Insert PDb;
        
        Customer_Config__c CDb = new Customer_Config__c();
        CDb.User_Config__c = PDb.Id;
        CDb.Job_Owner__c = con.id;
        CDb.Is_Active__c = true;
        CDb.Is_Default__c = false;
        // CDb.Is_Admin__c = false;
        CDb.RecordTypeId = RecordType;
        Insert CDb;
        
        String dashboardId = PDb.Id;
        String dashboardName = PDb.Name;
        Boolean dashboardActive = PDb.Is_Active__c;
        Boolean dashboardDefault = PDb.Is_Default__c;
        String loggedInContact = Con.Id;
        List<String> globalFilterRecs = lstStr;
        String typestr ='Edit';
        
        
        test.startTest();
        JO_GlobalFilters.newDashboardRecord(dashboardId, dashboardName, dashboardActive, loggedInContact, globalFilterRecs, dashboardDefault, typestr);
        test.stopTest();   
        
        
    }
    
    //Delete DashBoard
    testMethod static void deleteDashboardRecordTest()
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        lstCon.add(con);
        
        Contact con1 = new Contact();
        con1.AccountId = acc.Id;
        con1.LastName = 'Test Contact1';
        lstCon.add(con1);
        Insert lstCon;
        
        List<String> lstStr = new List<String>();
        for(Contact c:lstCon)
        {
            lstStr.add(c.name);
        }
        Id RecordType = Schema.SObjectType.Customer_Config__c.getRecordTypeInfosByName().get('JO Dashboard').getRecordTypeId();
        
        Customer_Config__c PDb = new Customer_Config__c();
        PDb.Job_Owner__c = con.id;
        PDb.Is_Active__c = true;
        PDb.Is_Default__c = true;
        PDb.RecordTypeId = RecordType;
        Insert PDb;
        
        Customer_Config__c CDb = new Customer_Config__c();
        CDb.User_Config__c = PDb.Id;
        CDb.Job_Owner__c = con.id;
        CDb.Is_Active__c = true;
        CDb.Is_Default__c = true;
        CDb.RecordTypeId = RecordType;
        Insert CDb;
        
        String dashboardId = PDb.Id;
        
        test.startTest();
        JO_GlobalFilters.deleteDashboardRecord(dashboardId);
        test.stopTest();   
        
        
    }
    
}