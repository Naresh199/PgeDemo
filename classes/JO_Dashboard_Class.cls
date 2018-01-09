public class JO_Dashboard_Class {
    @AuraEnabled
    public static List<PGEPIEChart> getjobData(string query)
    {
        String qry;
        List<PGEPIEChart> data = new List<PGEPIEChart>();
        qry = query == ''?'Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c':query;
        decimal high=0,medium=0,low=0;
        for(job__c job: Database.query(qry))
        {
            if(job.Priority_Stage__c == 'High')   
                high++;
            if(job.Priority_Stage__c == 'Medium')   
                medium++;
            if(job.Priority_Stage__c == 'Low')   
                low++;
        }
        if(high>0)
        data.add(new PGEPIEChart('High',high));
        if(medium>0)
        data.add(new PGEPIEChart('Medium',medium));
        if(low>0)
        data.add(new PGEPIEChart('Low',low));
        return data;
    }
    @AuraEnabled
    public static List<PGEBarChart> getjobtabledetails(string query)
    {
        String qry;
        List<PGEBarChart> jobList = new List<PGEBarChart>();
        qry = query == ''?'Select count(Id) cnt, Job_Status__c FROM Job__c GROUP BY Job_Status__c':query;
        /*  if(query == '')
        		qry = 'Select count(Id) cnt, Job_Status__c FROM Job__c GROUP BY Job_Status__c';
        	else
	        	qry = query;
        */
        System.debug('qry : '+qry);
        AggregateResult[] groupedResults = Database.query(qry);
        for (AggregateResult ar : groupedResults)  {
            jobList.add(new PGEBarChart(integer.valueOf(ar.get('cnt')),String.valueOf(ar.get('Job_Status__c'))));
        }
        return jobList;
    }
    @AuraEnabled
    public static List<job__c> getjobtable(string status,string query,string stage)
    {
        List<Job__c> jobList = new List<Job__c>();
        System.debug('qry :'+query);
        if(status != '')
            jobList = [Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c where Job_Status__c =:status];
        else if(query != '')
            jobList = Database.query(query);
        else if(stage !=''){
            string q ='Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c where Priority_Stage__c =';
            q += '\''+stage+'\'';
            System.debug('q : '+q);
            jobList = database.query(q);
        }
        return jobList;
    }
    @AuraEnabled
    public static List<job__c> getFbarjobtable(string status, integer priority)
    {
        List<Job__c> jobList = new List<Job__c>();
        if(status != '' && priority != null)
        {
            string q ='Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c where Job_Status__c =';
            q += '\''+status+'\'';
            q += ' and Priority__c =';
            q += '\''+priority+'\'';
            System.debug('q : '+q);
            jobList = database.query(q);
        }
        return jobList;
    }
    @AuraEnabled
    public static List<String> getjobstatus() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = job__c.Job_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        options.sort();
        return options;
    }
    @AuraEnabled
    public static List<String> getprioritystage() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = job__c.Priority_Stage__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        options.sort();
        return options;
    }
    @AuraEnabled
    public static List<String> getpriority() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = job__c.Priority__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        options.sort();
        return options;
    }
    @AuraEnabled
    public static List<User> getusers() {
         List<User> urList= [Select id, Name FROM User WHERE isActive = true];
        urList.sort();
        return urList;
    }
    @AuraEnabled
    public static String getfilteredQuery(string status,string stage,string priority,string user) {
        string filteredQuery= '';
        string stus,stge,prty,cond,usr;
        string query = 'Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c';
        if(status != '')
            stus = '\'' + status + '\'';//'Job_Status__c ='+
        if(stage != '')
            stge = '\'' + stage + '\'';//' Priority_Stage__c ='+
        if(priority != '')
            prty = '\'' + priority + '\'';//' Priority__c ='
        if(user != '')
            usr = '\'' + user + '\'';
        if(status != '' || stage != '' || priority != '' || user != ''){
            filteredQuery = query;
            cond = ' where ';
        }
        if(status != '' && stage != '' && priority != '' && user != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge+ ' and Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '' && stage != '' && priority != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge+' and Priority__c ='+prty;
        else if(status != '' && priority != '' && user != '')
        	filteredQuery += cond+'Job_Status__c ='+stus+' and Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '' && stage != '' && user != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge+' and createdbyID='+usr;
        else if(stage != '' && priority != '' && user != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge+' and Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '' && stage != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge;
        else if(status != '' && priority != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority__c ='+prty;
        else if(status != '' && user != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and createdbyID='+usr;
        else if(stage != '' && priority != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge+' and Priority__c ='+prty;
        else if(stage != '' && user != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge+' and createdbyID='+usr;
        else if(priority != '' && user != '')
            filteredQuery += cond+'Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '')
            filteredQuery += cond+'Job_Status__c ='+stus;
        else if(stage != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge;
        else if(priority != '')
            filteredQuery += cond+'Priority__c ='+prty;
        else if(user != '')
            filteredQuery += cond+'createdbyID ='+usr;
        return filteredQuery;
    }
    @AuraEnabled
    public static String getcounttablefilteredQuery(string status,string stage,string priority,string user) {
        string filteredQuery= '';
        string stus,stge,prty,cond,usr;
       string query = 'Select count(Id) cnt, Job_Status__c FROM Job__c';
        if(status != '')
            stus = '\'' + status + '\'';//'Job_Status__c ='+
        if(stage != '')
            stge = '\'' + stage + '\'';//' Priority_Stage__c ='+
        if(priority != '')
            prty = '\'' + priority + '\'';//' Priority__c ='
        if(user != '')
            usr = '\'' + user + '\'';
        if(status != '' || stage != '' || priority != '' || user != ''){
            filteredQuery = query;
            cond = ' where ';
        }
        if(status != '' && stage != '' && priority != '' && user != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge+ ' and Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '' && stage != '' && priority != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge+' and Priority__c ='+prty;
        else if(status != '' && priority != '' && user != '')
        	filteredQuery += cond+'Job_Status__c ='+stus+' and Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '' && stage != '' && user != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge+' and createdbyID='+usr;
        else if(stage != '' && priority != '' && user != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge+' and Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '' && stage != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority_Stage__c ='+stge;
        else if(status != '' && priority != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and Priority__c ='+prty;
        else if(status != '' && user != '')
            filteredQuery += cond+'Job_Status__c ='+stus+' and createdbyID='+usr;
        else if(stage != '' && priority != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge+' and Priority__c ='+prty;
        else if(stage != '' && user != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge+' and createdbyID='+usr;
        else if(priority != '' && user != '')
            filteredQuery += cond+'Priority__c ='+prty+' and createdbyID='+usr;
        else if(status != '')
            filteredQuery += cond+'Job_Status__c ='+stus;
        else if(stage != '')
            filteredQuery += cond+'Priority_Stage__c ='+stge;
        else if(priority != '')
            filteredQuery += cond+'Priority__c ='+prty;
        else if(user != '')
            filteredQuery += cond+'createdbyID ='+usr;
        
        if(status != '' || stage != '' || priority != '' || user != ''){
        filteredQuery += ' GROUP BY Job_Status__c';
        }
        return filteredQuery;
    }
    @AuraEnabled
     public static List<PGEBarChart>  getJobByStatus(string query)
     {
         String qry;
         Map<String, Set<Integer>> jobDetailsMap = new Map<String, Set<Integer>>();
         List<PGEBarChart> jobList = new List<PGEBarChart>();
         qry = query == ''?'Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c':query;
       /*  if(query == '')
         {
             qry = 'Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c';
         }
         else
         {
             qry = query;
         }*/
         List<Job__c> jobTempList = Database.query(qry);
         if(jobTempList.size()>0)
         {
             for(Job__c job: jobTempList)
             {
                 if(jobDetailsMap.containsKey(job.Job_Status__c))
                 {
                     jobDetailsMap.get(job.Job_Status__c).add(Integer.valueOf(job.Priority__c)); 
                 }else
                 {   
                    jobDetailsMap.put(job.Job_Status__c, new Set<Integer>());
                    jobDetailsMap.get(job.Job_Status__c).add(Integer.valueOf(job.Priority__c)); 
                 }
             }
         }
         for(string job: jobDetailsMap.keySet())
         {
             for(integer j : jobDetailsMap.get(job))
             {
                 jobList.add(new PGEBarChart(job, integer.valueOf(j)));
             }
         }
         return jobList;
     }
    //code for drilldown
    public static map<string,Map<string,string>> drolldownfetch(string status,string qry)
    {
        map<string,Map<string,string>> drillmap = new map<string,Map<string,string>>();
        decimal a=0,b=0,b1=0,b2=0,b3=0,b4=0,b5=0;
        for(job__c job: Database.query(qry))
        {
            if(job.Job_Status__c == status)
            {
                a++;
                if(job.Priority__c == '1')
                    b++;
                if(job.Priority__c == '2')
                    b1++;
                if(job.Priority__c == '3')
                    b2++;
                if(job.Priority__c == '4')
                    b3++;
                if(job.Priority__c == '5')
                    b4++;
                if(job.Priority__c == '6')
                    b5++;
                if(drillmap.containsKey(job.Job_Status__c))
                {
                    drillmap.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drillmap.get(job.Job_Status__c).put('count', string.valueOf(a));
                    drillmap.get(job.Job_Status__c).put('one', String.valueOf(b));
                    drillmap.get(job.Job_Status__c).put('two', String.valueOf(b1));
                    drillmap.get(job.Job_Status__c).put('three', String.valueOf(b2));
                    drillmap.get(job.Job_Status__c).put('four', String.valueOf(b3));
                    drillmap.get(job.Job_Status__c).put('five', String.valueOf(b4));
                    drillmap.get(job.Job_Status__c).put('six', String.valueOf(b5));
                }
                else
                {
                    drillmap.put(job.Job_Status__c, new Map<string,string>());
                    drillmap.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drillmap.get(job.Job_Status__c).put('count', string.valueOf(a));
                    drillmap.get(job.Job_Status__c).put('one', String.valueOf(b));
                    drillmap.get(job.Job_Status__c).put('two', String.valueOf(b1));
                    drillmap.get(job.Job_Status__c).put('three', String.valueOf(b2));
                    drillmap.get(job.Job_Status__c).put('four', String.valueOf(b3));
                    drillmap.get(job.Job_Status__c).put('five', String.valueOf(b4));
                    drillmap.get(job.Job_Status__c).put('six', String.valueOf(b5));
                }
            }
        }
        return drillmap;
    }
    @AuraEnabled
    public static List<PGEBarChart> getjobsdrilldown(string query)
    {
        String qry;
        List<PGEBarChart> data = new List<PGEBarChart>();
        map<string,Map<string,string>> drilldown = new map<string,Map<string,string>>();
        
        qry = query == ''?'Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c':query;
     /*   if(query == '')
            qry = 'Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c';
        else
        {
            qry = query;
        }*/
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = job__c.Job_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        for(string op : options)
        {
            map<string,Map<string,string>> drilldown1 = new map<string,Map<string,string>>();
            drilldown1 = drolldownfetch(op,qry);
            drilldown.putAll(drilldown1);
        }
        for(String s : drilldown.keySet())
        {
            data.add(new PGEBarChart(s,drilldown.get(s)));
        }
        return data;
       // drilldown = drolldownfetch('APPR',qry);
     /*   for(job__c job: Database.query(qry))
        {
            if(job.Job_Status__c == 'ADER')
            {
               // drilldown = drolldownfetch(job.Job_Status__c,qry);
                //System.debug('@@ : '+drilldown);
                a++;
                if(job.Priority__c == '1')
                    b++;
                if(job.Priority__c == '2')
                    b1++;
                if(job.Priority__c == '3')
                    b2++;
                if(job.Priority__c == '4')
                    b3++;
                if(job.Priority__c == '5')
                    b4++;
                if(job.Priority__c == '6')
                    b5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(b));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(b1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(b2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(b3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(b4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(b5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(b));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(b1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(b2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(b3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(b4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(b5));
                }
                
            }
            
            if(job.Job_Status__c == 'APPR')
            {
                drilldown = drolldownfetch(job.Job_Status__c,qry);
                a1++;
                if(job.Priority__c == '1')
                    c++;
                if(job.Priority__c == '2')
                    c1++;
                if(job.Priority__c == '3')
                    c2++;
                if(job.Priority__c == '4')
                    c3++;
                if(job.Priority__c == '5')
                    c4++;
                if(job.Priority__c == '6')
                    c5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a1));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(c));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(c1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(c2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(c3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(c4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(c5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a1));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(c));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(c1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(c2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(c3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(c4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(c5));
                }
            }
            if(job.Job_Status__c == 'BSTS')
            {
                a2++;
                if(job.Priority__c == '1')
                    d++;
                if(job.Priority__c == '2')
                    d1++;
                if(job.Priority__c == '3')
                    d2++;
                if(job.Priority__c == '4')
                    d3++;
                if(job.Priority__c == '5')
                    d4++;
                if(job.Priority__c == '6')
                    d5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a2));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(d));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(d1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(d2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(d3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(d4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(d5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a2));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(d));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(d1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(d2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(d3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(d4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(d5));
                }
            }
            if(job.Job_Status__c == 'CONS')
            {
                a3++;
                if(job.Priority__c == '1')
                    e++;
                if(job.Priority__c == '2')
                    e1++;
                if(job.Priority__c == '3')
                    e2++;
                if(job.Priority__c == '4')
                    e3++;
                if(job.Priority__c == '5')
                    e4++;
                if(job.Priority__c == '6')
                    e5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a3));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(e));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(e1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(e2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(e3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(e4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(e5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a3));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(e));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(e1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(e2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(e3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(e4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(e5));
                }
            }
            if(job.Job_Status__c == 'DOCCID')
            {
                a4++;
                if(job.Priority__c == '1')
                    f++;
                if(job.Priority__c == '2')
                    f1++;
                if(job.Priority__c == '3')
                    f2++;
                if(job.Priority__c == '4')
                    f3++;
                if(job.Priority__c == '5')
                    f4++;
                if(job.Priority__c == '6')
                    f5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a4));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(f));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(f1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(f2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(f3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(f4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(f5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a4));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(f));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(f1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(f2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(f3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(f4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(f5));
                }
            }
            if(job.Job_Status__c == 'FICL')
            {
                a5++;
                if(job.Priority__c == '1')
                    g++;
                if(job.Priority__c == '2')
                    g1++;
                if(job.Priority__c == '3')
                    g2++;
                if(job.Priority__c == '4')
                    g3++;
                if(job.Priority__c == '5')
                    g4++;
                if(job.Priority__c == '6')
                    g5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a5));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(g));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(g1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(g2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(g3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(g4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(g5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a5));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(g));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(g1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(g2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(g3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(g4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(g5));
                }
            }
            if(job.Job_Status__c == 'MAPPIMP')
            {
                a6++;
                if(job.Priority__c == '1')
                    h++;
                if(job.Priority__c == '2')
                    h1++;
                if(job.Priority__c == '3')
                    h2++;
                if(job.Priority__c == '4')
                    h3++;
                if(job.Priority__c == '5')
                    h4++;
                if(job.Priority__c == '6')
                    h5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a6));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(h));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(h1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(h2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(h3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(h4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(h5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a6));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(h));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(h1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(h2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(h3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(h4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(h5));
                }
            }
            if(job.Job_Status__c == 'PEND')
            {
                a7++;
                if(job.Priority__c == '1')
                    i++;
                if(job.Priority__c == '2')
                    i1++;
                if(job.Priority__c == '3')
                    i2++;
                if(job.Priority__c == '4')
                    i3++;
                if(job.Priority__c == '5')
                    i4++;
                if(job.Priority__c == '6')
                    i5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a7));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(i));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(i1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(i2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(i3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(i4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(i5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a7));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(i));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(i1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(i2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(i3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(i4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(i5));
                }
            }
            if(job.Job_Status__c == 'SRDY')
            {
                a8++;
                if(job.Priority__c == '1')
                    j++;
                if(job.Priority__c == '2')
                    j1++;
                if(job.Priority__c == '3')
                    j2++;
                if(job.Priority__c == '4')
                    j3++;
                if(job.Priority__c == '5')
                    j4++;
                if(job.Priority__c == '6')
                    j5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a8));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(j));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(j1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(j2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(j3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(j4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(j5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a8));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(j));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(j1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(j2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(j3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(j4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(j5));
                }
            }
            if(job.Job_Status__c == 'SUBM')
            {
                a9++;
                if(job.Priority__c == '1')
                    k++;
                if(job.Priority__c == '2')
                    k1++;
                if(job.Priority__c == '3')
                    k2++;
                if(job.Priority__c == '4')
                    k3++;
                if(job.Priority__c == '5')
                    k4++;
                if(job.Priority__c == '6')
                    k5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a9));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(k));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(k1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(k2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(k3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(k4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(k5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a9));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(k));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(k1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(k2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(k3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(k4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(k5));
                }
            }
            if(job.Job_Status__c == 'UNSC')
            {
                a10++;
                if(job.Priority__c == '1')
                    l++;
                if(job.Priority__c == '2')
                    l1++;
                if(job.Priority__c == '3')
                    l2++;
                if(job.Priority__c == '4')
                    l3++;
                if(job.Priority__c == '5')
                    l4++;
                if(job.Priority__c == '6')
                    l5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a10));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(l));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(l1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(l2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(l3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(l4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(l5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a10));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(l));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(l1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(l2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(l3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(l4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(l5));
                }
            }
            if(job.Job_Status__c == 'UNSE')
            {
                a11++;
                if(job.Priority__c == '1')
                    m++;
                if(job.Priority__c == '2')
                    m1++;
                if(job.Priority__c == '3')
                    m2++;
                if(job.Priority__c == '4')
                    m3++;
                if(job.Priority__c == '5')
                    m4++;
                if(job.Priority__c == '6')
                    m5++;
                if(drilldown.containsKey(job.Job_Status__c))
                {
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a11));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(m));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(m1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(m2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(m3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(m4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(m5));
                }
                else
                {
                    drilldown.put(job.Job_Status__c, new Map<string,string>());
                    drilldown.get(job.Job_Status__c).put('Name', job.Job_Status__c);
                    drilldown.get(job.Job_Status__c).put('count', string.valueOf(a11));
                    drilldown.get(job.Job_Status__c).put('one', String.valueOf(m));
                    drilldown.get(job.Job_Status__c).put('two', String.valueOf(m1));
                    drilldown.get(job.Job_Status__c).put('three', String.valueOf(m2));
                    drilldown.get(job.Job_Status__c).put('four', String.valueOf(m3));
                    drilldown.get(job.Job_Status__c).put('five', String.valueOf(m4));
                    drilldown.get(job.Job_Status__c).put('six', String.valueOf(m5));
                }
            }
        }*/
    }
    public class PGEBarChart {
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public integer data{get;set;}
        @AuraEnabled
        public Set<Integer> priorityList{get;set;}
        @AuraEnabled
        public integer count{get;set;}
        @AuraEnabled
        public string One{get;set;}
        @AuraEnabled
        public string Two{get;set;}
        @AuraEnabled
        public string Three{get;set;}
        @AuraEnabled
        public string Four{get;set;}
        @AuraEnabled
        public string Five{get;set;}
        @AuraEnabled
        public string Six{get;set;}
        @AuraEnabled
        public string total{get;set;}
        @AuraEnabled
        public Map<string ,List<Integer>> plist{get;set;}
        @AuraEnabled
        public Map<string ,string> drill{get;set;}
        public PGEBarChart(String namevalue , Map<string ,List<Integer>> datavalue)
        {
            plist = datavalue;
            name = namevalue;
        }
        public PGEBarChart(String namevalue, integer datavalue)
        {
            name = namevalue;
            data = datavalue;
        }
        public PGEBarChart(integer datavalue ,String namevalue)
        {
            data = datavalue;
            name = namevalue;
        }
        public PGEBarChart(String namevalue , Set<Integer> datavalue)
        {
            priorityList = datavalue;
            name = namevalue;
        }
        public PGEBarChart(String namevalue, Map<string ,string> drills)
        {
            name = namevalue;
            drill = drills;
        }
    }
    public class PGEPIEChart {
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public Decimal data{get;set;}
        public PGEPIEChart(String namevalue, Decimal datavalue)
        {
            name = namevalue;
            data = datavalue;
        }
    }
    /*    @AuraEnabled
    public static List<PGEBarChart> getOrderData()
    {
        List<PGEBarChart> jobList = new List<PGEBarChart>();
        List<Job__c> jobTempList = [Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c];
        System.debug('@@jobTempList' + jobTempList.size());
        if(jobTempList.size()>0)
        {
            string[] abc = new String[]{};
            List<String> priorList = new List<String>();
            //Map<String, List<Integer>> jobDetailsMap = new Map<String, List<Integer>>();
            Map<String, Map<string ,List<Integer>>> jobDetailsMap = new Map<String, Map<string ,List<Integer>>>();
            for(Job__c job: jobTempList)
            {
                if(jobDetailsMap.containsKey(job.Job_Status__c))
                {
                    //priorList.addAll(jobDetailsMap.get(job.Job_Status__c));
                    //priorList.add(job.Priority_Stage__c);
                    //jobDetailsMap.get(job.Job_Status__c).add(Integer.valueOf(job.Priority__c)); 
                    jobDetailsMap.get(job.Job_Status__c).get(job.Job_Status__c).add(Integer.valueOf(job.Priority__c)); 
                }else
                {
                    //priorList.add(job.Priority_Stage__c);
                    jobDetailsMap.put(job.Job_Status__c, new Map<string ,List<Integer>>());
                    jobDetailsMap.get(job.Job_Status__c).put(job.Job_Status__c, new List<Integer>());
                    jobDetailsMap.get(job.Job_Status__c).get(job.Job_Status__c).add(Integer.valueOf(job.Priority__c));
                }
                
            }
            for(string job: jobDetailsMap.keySet())
            {
                // jobList.add(new PGEBarChart(String.valueOf(job.Job_Status__c), Integer.valueOf(job.Priority__c)));
                jobList.add(new PGEBarChart(job, jobDetailsMap.get(job)));
            }
            //jobList.sort();
            //jobStr = JSON.serialize(jobList);   
        }
        return jobList;
    }*/
    /*   @AuraEnabled
    public static List<job__c> getjobtable1(string stage)
    {
        List<Job__c> jobList = new List<Job__c>();
        //string st = stage.trim();
        System.debug('qry :'+stage);
        if(stage !=''){
        string q ='Select Id, Name, Job_Status__c, Priority__c, Priority_Stage__c from Job__c where Priority_Stage__c =';
        q += '\''+stage+'\'';
        System.debug('q : '+q);
         jobList = database.query(q);
        }
        		
        System.debug('joblist : '+jobList);
        return jobList;
    }*/
}