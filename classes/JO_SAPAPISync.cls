public class JO_SAPAPISync 
{
    
    //Class variables declaration
    static list<SAP_API_Log__c> logFiles = new list<SAP_API_Log__c>();
    static Map<string,Id> notificationDetails = new Map<string,Id>();
    static Map<string,Id> orderDetails = new Map<string,Id>();
    static Map<String,Id> OrderOperDetails = new Map<String,Id>();
    static Map<String,Id> addressDetails = new Map<String,Id>();
    
    
    public static void SAP2SFSync(list<string> jobOwners)
    {
        system.debug('Start Time' + system.now());
        //Method variabes declaration
        SAP_API_Log__c pMNotifSetLogFile = new SAP_API_Log__c();
        SAP_API_Log__c orderSetLogFile = new SAP_API_Log__c();
        SAP_API_Log__c notifTasksSetLogFile = new SAP_API_Log__c();
        SAP_API_Log__c orderOperationLogFile = new SAP_API_Log__c();
        SAP_API_Log__c addressLogFile = new SAP_API_Log__c();
        
        List<PMNotifSet__x> pMNotifSetRecords = new List<PMNotifSet__x>();
        List<OrderSet__x> orderSetRecords = new List<OrderSet__x>();
        List<NotifTasksSet__x> notifTasksSetRecords = new List<NotifTasksSet__x>();
        List<OrderOperSet__x> orderOperationSetRecords = new List<OrderOperSet__x>();
        List<AddressSet__x> addressSetRecords = new List<AddressSet__x>();
        
        list<Notifications__c> notificationToAdd = new List<Notifications__c>();
        List<Order__c> orderToAdd = new List<Order__c>();
        List<Task> taskToAdd = new List<Task>();
        List<Order_Operation__c> orderOperToAdd = new List<Order_Operation__c>();
        List<Address__c> addressToAdd = new List<Address__c>();
        
        List<string> ExistingNotification = new List<string>();
        Map<string,Id> notifExist = new Map<string,Id>();
        
        string dateValueString; 
        
        List<string> existingOrder = new List<string>();
        Map<string,Id> orderExist = new Map<string,Id>();
        
        List<string> ExistingNotifTask = new List<string>();
        Map<string,Id> notifTaskExist = new Map<string,Id>();
        
        //PMNotifSet
        try
        {
            pMNotifSetLogFile.Start_Time__c = system.now();
            pMNotifSetLogFile.External_Object__c = 'PMNotifSet__x';
            
            pMNotifSetRecords = [SELECT Id, ExternalId, DisplayUrl, JobOwner__c, NotifChangedBy__c, NotifChangedDate__c, NotifChangedTime__c, NotifCreatedBy__c, NotifCreatedTime__c, NotifPriorityType__c, NotifPriority__c, NotifReportedBy__c, NotifReqEndDate__c, NotifReqEndTime__c, NotifReqStartDate__c, NotifReqStartTime__c, NotificationDesc__c, NotificationNum__c, NotificationType__c, ObjNumber__c, Root_ObjNumber__c, Root_NotifNumber__c, NotifCreatedDate__c FROM PMNotifSet__x where jobowner__c in :jobOwners];
            orderSetRecords = [SELECT Id, ExternalId, DisplayUrl, AccountingIndicator__c, AddressNumber__c, AllocationSet__c, ApplicantDesignFlag__c, ApplicationDescription__c, Application__c, AuthorizedAmount__c, COInternalOrderUser__c, ChangedBy__c, ChangedDate__c,ChangedOn__c, ChangedTime__c, ClientCostCenter__c, CloseDate__c, CostCenterBasicSettlement__c, CostCenter__c, CostCollector__c, CostEstimateNumber__c, CostingSheet__c, CostingVariant__c, CreatedBy__c, CreatedDate__c, CreatedTime__c, Description__c, DirectCostCollectorIndicator__c, EnvironmentalInvestmentReason__c, ExcludeManualPlanning__c, ExternalOrderNumber__c, FunctionalArea__c, FundingCycle__c, FundingIdentifier__c, GLAccountBasicSettlement__c, IntegratedPlanningIndicator__c, InterestProfile__c, InvestmentMeasureProfile__c, InvestmentObjectsScale__c, InvestmentReason__c, JobOwner__c, LeadOrdObjNumber__c, LeadOrderNumber__c, LeadOrder__c, Location__c, LogicalSystem__c, MaintenanceActivityType__c, MajorProjectIndicator__c, MajorWorkCategory__c, MultipleItemsOrder__c, NetEstimate__c, NotifObjNumber__c, NotificationNum__c, NotificationType__c, Notification__c, OMEN__c, ObjNumber__c, ObjectClass__c, OperativeDate__c, OrderCategory__c, OrderNumber__c, OrderStatus__c, OrderType__c, OrganizationalObjective__c, OverheadKey__c, PersonInchargeTelephone__c, PersonResponsible__c, PhaseOrderClosed__c, PhaseOrderCompleted__c, PhaseOrderCreated__c, PhaseOrderReleased__c, PlannedClosingDate__c, PlannedCompletionDate__c, PlannedReleaseDate__c, PlanningOrderLink__c, PlantRetirements__c, Plant__c, PostedCostCenter__c, ProcessCategory__c, ProcessingGroup__c, ProductionProcess__c, ProfitCenter__c, ProjectGTMillion__c, ReceiverCostCenter__c, RefurbishmentOrderIndicator__c, RegulatoryCategory__c, RegulatoryMajorWorkCategory__c, ReleaseDate__c, RequestingCompanyCode__c, RequestingOrder__c, ResultsAnalysisKey__c, Root_ObjNumber__c, SalesOrderItemNumber__c, SalesOrderNumber__c, SequenceNumber__c, SettlementCostElement__c, SpecialReportingItem__c, StartDate__c, TaxJurisdiction__c, TechnicalCompletionDate__c, VarianceKey__c, WBSElement__c, WorkEndDate__c, WorkStartDate__c, WorkType__c, Root_NotifNumber__c FROM OrderSet__x where jobowner__c in :jobOwners];       
            notifTasksSetRecords = [SELECT ExternalId, DisplayUrl, CompletedOn__c, CatalogType__c, CreatedOn__c, ChangedBy__c, ChangedOn__c, ChangedTime__c, CodeGroup__c, CompletedBy__c, CompletedTime__c, CreateAt__c, CreatedBy__c, FollowUpActionLog__c, FollowUpAction__c, JobOwner__c, LongTextindicator__c, NotifObjNumber__c, NotificationNum__c, ObjNumber__c,PlannedFinishDate__c, PlannedFinishTime__c, PlannedStartDate__c, PlannedStartTime__c, PrimaryLanguageIndicator__c, ResponsiblePersonFunction__c, ResponsiblePerson__c, Root_ObjNumber__c, ShortText__c, StatusOBJNR__c, TaskCode__c, TaskNumber__c, VersionNumber__c, Root_NotifNumber__c, Id FROM NotifTasksSet__x where jobowner__c in :jobOwners];
            
            if(pMNotifSetRecords.size() > 0 || !pMNotifSetRecords.isEmpty())
            {
                for(PMNotifSet__x notificationInstance : pMNotifSetRecords)
                {
                    ExistingNotification.add(notificationInstance.ExternalId);
                }
            }
            
            List<Notifications__c> existingNotif = [select id, sap_external_ID__c, name from Notifications__c where sap_external_ID__c in :ExistingNotification];
            
            if(existingNotif.size() > 0 || !existingNotif.isEmpty())
            {
                for(Notifications__c notifInstance : existingNotif)
                {
                    notifExist.put(notifInstance.sap_external_ID__c, notifInstance.id);
                }
            }
            
            system.debug('Sap Data Count: '+pMNotifSetRecords.size());
            for(PMNotifSet__x notificationInstance : pMNotifSetRecords)
            {
                system.debug('notificationInstance: '+notificationInstance);
                Notifications__c notificationObj = new Notifications__c();
                if(notifExist.containsKey(notificationInstance.ExternalId))
                {
                    notificationObj.Id = notifExist.get(notificationInstance.ExternalId);
                }
                //notificationObj.Jb_Owner__c = notificationInstance.JobOwner__c;
                notificationObj.NotifChangedBy__c = notificationInstance.NotifChangedBy__c;
                dateValueString = DateFormatFromString(notificationInstance.NotifChangedDate__c);
                system.debug('dateValueString: '+dateValueString);
                if(dateValueString != 'Error')
                {
                    notificationObj.NotifChangedDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                notificationObj.DisplayUrl__c = notificationInstance.DisplayUrl;
                notificationObj.SAP_External_Id__c = notificationInstance.ExternalId;
                notificationObj.Name = notificationInstance.NotificationNum__c;
                notificationObj.NotificationType__c = notificationInstance.NotificationType__c;
                //notificationObj.ObjNumber__c = Double.valueOf(notificationInstance.ObjNumber__c); Invalid Double error is occuring
                
                // Notifications & Orders Updated By KoteswaraRao @12-12-2017 03:30 PM
                notificationObj.NotifCreatedBy__c = notificationInstance.NotifCreatedBy__c;
                
                dateValueString = DateFormatFromString(notificationInstance.NotifCreatedDate__c);
                if(dateValueString != 'Error')
                {
                    notificationObj.NotifCreatedDate__c =  Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                notificationObj.NotificationDesc__c = notificationInstance.NotificationDesc__c;
                notificationObj.NotificationType__c = notificationInstance.NotificationType__c;
                //notificationObj.NotifPriority__c = notificationInstance.NotifPriority__c;
                notificationObj.NotifPriorityType__c = notificationInstance.NotifPriorityType__c;
                notificationObj.NotifReportedBy__c = notificationInstance.NotifReportedBy__c;
                
                dateValueString = DateFormatFromString(notificationInstance.NotifReqEndDate__c);
                if(dateValueString != 'Error')
                {
                    notificationObj.NotifReqEndDate__c =  Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                dateValueString = DateFormatFromString(notificationInstance.NotifReqStartDate__c);
                if(dateValueString != 'Error')
                {
                    notificationObj.NotifReqStartDate__c =  Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                notificationObj.Root_NotifNumber__c = Double.valueOf(notificationInstance.Root_NotifNumber__c);
                //notificationObj.Root_ObjNumber__c = Double.valueOf(notificationInstance.Root_ObjNumber__c);
                notificationToAdd.add(notificationObj);
            }
            system.debug('Notification to add Count: '+notificationToAdd.size());
            upsert notificationToAdd;
            system.debug('Notifications :'+notificationToAdd);
            pMNotifSetLogFile.Stop_Time__c = system.now();
            pMNotifSetLogFile.User__c = UserInfo.getUserId();
            for(Notifications__c notificationRec : notificationToAdd)
            {
                notificationDetails.put(notificationRec.Name, notificationRec.Id);
            }
        }
        catch(exception ex)
        {
            pMNotifSetLogFile.Is_Exception__c = true;
            pMNotifSetLogFile.Exception__c = 'Line Number : ' + ex.getLineNumber() + ' - Cause : ' + ex.getCause() + ' - Message : ' + ex.getMessage();
        }
        finally
        {
            logFiles.add(pMNotifSetLogFile);
            //insert pMNotifSetLogFile;
        }
        
        //OrderSet
        try
        {
            //
            orderSetLogFile.Start_Time__c = system.now();
            orderSetLogFile.External_Object__c = 'OrderSet__x';
            
            if(orderSetRecords.size() > 0 || !orderSetRecords.isEmpty())
            {
                for(OrderSet__x orderInstance : orderSetRecords)
                {
                    existingOrder.add(orderInstance.ExternalId);
                }
            }
            List<Order__c> existingOrd = [Select id,name,SAP_External_Id__c from Order__c where SAP_External_Id__c in : existingOrder];
            
            if(orderSetRecords.size() > 0 || !orderSetRecords.isEmpty())
            {
                for(Order__c orderInstance : existingOrd)
                {
                    orderExist.put(orderInstance.sap_external_ID__c, orderInstance.id);
                }
            }
            
            for(OrderSet__x orderSetInstance : orderSetRecords)
            {
                Order__c orderObj = new Order__c();
                if(orderExist.containsKey(orderSetInstance.ExternalId))
                {
                    orderObj.id = orderExist.get(orderSetInstance.ExternalId);
                }
                dateValueString = DateFormatFromString(orderSetInstance.ChangedDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.ChangedDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                Id notifId = notificationDetails.get(orderSetInstance.NotificationNum__c);
                orderObj.Notification_Order__c = notifId;
                orderObj.Notification__c = orderSetInstance.NotificationNum__c;
                //orderObj.ObjNumber__c = orderSetInstance.ObjNumber__c;
                orderObj.SAP_External_Id__c = orderSetInstance.ExternalId;
                
                orderObj.Name = orderSetInstance.OrderNumber__c;
                orderObj.OrderStatus__c = orderSetInstance.OrderStatus__c;
                //orderObj.AccountingIndicator__c = orderSetInstance.AccountingIndicator__c; //FIELD_CUSTOM_VALIDATION_EXCEPTION, Order Number should contain eight digits
                //orderObj.AddressNumber__c = Double.valueOf(orderSetInstance.AddressNumber__c);
                orderObj.AllocationSet__c = orderSetInstance.AllocationSet__c;
                orderObj.ApplicantDesignFlag__c = orderSetInstance.ApplicantDesignFlag__c;
                orderObj.Application__c = orderSetInstance.Application__c;
                orderObj.ApplicationDescription__c = orderSetInstance.ApplicationDescription__c;
                orderObj.AuthorizedAmount__c = orderSetInstance.AuthorizedAmount__c;
                orderObj.ChangedBy__c = orderSetInstance.ChangedBy__c;
                orderObj.ChangedOn__c = orderSetInstance.ChangedOn__c;
                orderObj.ClientCostCenter__c = orderSetInstance.ClientCostCenter__c;
                dateValueString = DateFormatFromString(orderSetInstance.CloseDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.CloseDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                orderObj.COInternalOrderUser__c = orderSetInstance.COInternalOrderUser__c;
                orderObj.CostCenter__c = orderSetInstance.CostCenter__c;
                orderObj.CostCenterBasicSettlement__c = orderSetInstance.CostCenterBasicSettlement__c;
                orderObj.CostCollector__c = orderSetInstance.CostCollector__c;
                orderObj.CostEstimateNumber__c = orderSetInstance.CostEstimateNumber__c;
                orderObj.CostingSheet__c = orderSetInstance.CostingSheet__c;
                orderObj.CostingVariant__c = orderSetInstance.CostingVariant__c;
                orderObj.CreatedBy__c = orderSetInstance.CreatedBy__c;
                //orderObj.CreatedById
                dateValueString = DateFormatFromString(orderSetInstance.CreatedDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.CreatedDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                //orderObj.Description__c = orderSetInstance.Description__c; //data value too large: EP 77 BEALE STREET SAN FRANCISCO (max length=18): [Description__c]
                orderObj.DirectCostCollectorIndicator__c = orderSetInstance.DirectCostCollectorIndicator__c;
                orderObj.EnvironmentalInvestmentReason__c = orderSetInstance.EnvironmentalInvestmentReason__c;
                orderObj.ExcludeManualPlanning__c = orderSetInstance.ExcludeManualPlanning__c;
                orderObj.ExternalOrderNumber__c = orderSetInstance.ExternalOrderNumber__c;
                orderObj.FunctionalArea__c = orderSetInstance.FunctionalArea__c;
                orderObj.FundingCycle__c = orderSetInstance.FundingCycle__c;
                orderObj.FundingIdentifier__c = orderSetInstance.FundingIdentifier__c;
                orderObj.GLAccountBasicSettlement__c = orderSetInstance.GLAccountBasicSettlement__c;
                //orderObj.Id = orderSetInstance.Id;
                orderObj.IntegratedPlanningIndicator__c = orderSetInstance.IntegratedPlanningIndicator__c;
                orderObj.InterestProfile__c = orderSetInstance.InterestProfile__c;
                orderObj.InvestmentMeasureProfile__c = orderSetInstance.InvestmentMeasureProfile__c;
                orderObj.InvestmentObjectsScale__c = orderSetInstance.InvestmentObjectsScale__c;
                orderObj.InvestmentReason__c = orderSetInstance.InvestmentReason__c;
                // orderObj.Job_Owner__c = orderSetInstance.JobOwner__c;
                // orderObj.LastModifiedById	
                orderObj.LeadOrder__c= orderSetInstance.LeadOrder__c;
                //orderObj.LeadOrderNumber__c = Double.valueOf(orderSetInstance.LeadOrderNumber__c);
                orderObj.Location__c = orderSetInstance.Location__c;
                orderObj.LogicalSystem__c = orderSetInstance.LogicalSystem__c;
                orderObj.MaintenanceActivityType__c = orderSetInstance.MaintenanceActivityType__c;
                orderObj.MajorProjectIndicator__c = orderSetInstance.MajorProjectIndicator__c;
                orderObj.MajorWorkCategory__c = Double.valueOf(orderSetInstance.MajorWorkCategory__c);
                orderObj.MultipleItemsOrder__c = orderSetInstance.MultipleItemsOrder__c;
                orderObj.NetEstimate__c = orderSetInstance.NetEstimate__c;
                //orderObj.NotificationNum__c = Double.valueOf(orderSetInstance.NotificationNum__c);
                orderObj.ObjectClass__c = orderSetInstance.ObjectClass__c;
                orderObj.OMEN__c = orderSetInstance.OMEN__c;
                dateValueString = DateFormatFromString(orderSetInstance.OperativeDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.OperativeDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                orderObj.OrderCategory__c = orderSetInstance.OrderCategory__c;
                //orderObj.Order_Notification__c
                orderObj.OrderNumber__c = Double.valueOf(orderSetInstance.OrderNumber__c);
                orderObj.OrderStatus__c = orderSetInstance.OrderStatus__c;
                orderObj.OrderType__c = orderSetInstance.OrderType__c;
                orderObj.OrganizationalObjective__c = orderSetInstance.OrganizationalObjective__c;
                orderObj.OverheadKey__c = orderSetInstance.OverheadKey__c;
                // orderObj.OwnerId
                //orderObj.Parent_Order__c
                orderObj.PersonInchargeTelephone__c = orderSetInstance.PersonInchargeTelephone__c;
                orderObj.PersonResponsible__c = orderSetInstance.PersonResponsible__c;
                orderObj.PhaseOrderClosed__c = orderSetInstance.PhaseOrderClosed__c;
                orderObj.PhaseOrderCompleted__c = orderSetInstance.PhaseOrderCompleted__c;
                orderObj.PhaseOrderCreated__c = orderSetInstance.PhaseOrderCreated__c;
                orderObj.PhaseOrderReleased__c = orderSetInstance.PhaseOrderReleased__c;
                orderObj.PlanningOrderLink__c = orderSetInstance.PlanningOrderLink__c;
                dateValueString = DateFormatFromString(orderSetInstance.PlannedClosingDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.PlannedClosingDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                dateValueString = DateFormatFromString(orderSetInstance.PlannedCompletionDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.PlannedCompletionDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                dateValueString = DateFormatFromString(orderSetInstance.PlannedReleaseDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.PlannedReleaseDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                orderObj.Plant__c = orderSetInstance.Plant__c;
                orderObj.PlantRetirements__c = orderSetInstance.PlantRetirements__c;
                orderObj.PostedCostCenter__c = orderSetInstance.PostedCostCenter__c;
                orderObj.ProcessCategory__c = orderSetInstance.ProcessCategory__c;
                orderObj.ProcessingGroup__c = orderSetInstance.ProcessingGroup__c;
                orderObj.ProductionProcess__c = orderSetInstance.ProductionProcess__c;
                orderObj.ProfitCenter__c = orderSetInstance.ProfitCenter__c;
                orderObj.ProjectGTMillion__c = orderSetInstance.ProjectGTMillion__c;
                orderObj.ReceiverCostCenter__c = orderSetInstance.ReceiverCostCenter__c;
                orderObj.RefurbishmentOrderIndicator__c = orderSetInstance.RefurbishmentOrderIndicator__c;
                orderObj.RegulatoryCategory__c = orderSetInstance.RegulatoryCategory__c;
                orderObj.RegulatoryMajorWorkCategory__c = orderSetInstance.RegulatoryMajorWorkCategory__c;
                dateValueString = DateFormatFromString(orderSetInstance.ReleaseDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.ReleaseDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                orderObj.RequestingCompanyCode__c = orderSetInstance.RequestingCompanyCode__c;
                orderObj.ResultsAnalysisKey__c = orderSetInstance.ResultsAnalysisKey__c;
                orderObj.Root_NotifNumber__c = orderSetInstance.Root_NotifNumber__c;
                orderObj.Root_ObjNumber__c = orderSetInstance.Root_ObjNumber__c;
                orderObj.SalesOrderItemNumber__c = orderSetInstance.SalesOrderItemNumber__c;
                orderObj.SalesOrderNumber__c = orderSetInstance.SalesOrderNumber__c;
                orderObj.SequenceNumber__c = Double.valueOf(orderSetInstance.SequenceNumber__c);
                orderObj.SettlementCostElement__c = orderSetInstance.SettlementCostElement__c;
                orderObj.SpecialReportingItem__c = orderSetInstance.SpecialReportingItem__c;
                dateValueString = DateFormatFromString(orderSetInstance.StartDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.StartDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                orderObj.TaxJurisdiction__c = orderSetInstance.TaxJurisdiction__c;
                dateValueString = DateFormatFromString(orderSetInstance.TechnicalCompletionDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.TechnicalCompletionDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                orderObj.VarianceKey__c = orderSetInstance.VarianceKey__c;
                orderObj.WBSElement__c = orderSetInstance.WBSElement__c;
                dateValueString = DateFormatFromString(orderSetInstance.WorkEndDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.WorkEndDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                dateValueString = DateFormatFromString(orderSetInstance.WorkStartDate__c);
                if(dateValueString != 'Error')
                {
                    orderObj.WorkStartDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                orderObj.WorkType__c = orderSetInstance.WorkType__c;
                orderToAdd.add(orderObj);
            }
            upsert orderToAdd;
            orderSetLogFile.Stop_Time__c = system.now();
            orderSetLogFile.User__c = UserInfo.getUserId();
            for(Order__c orderRec : orderToAdd)
            {
                orderDetails.put(orderRec.Name, orderRec.Id);
            }
        }
        catch(exception ex)
        {
            orderSetLogFile.Is_Exception__c = true;
            orderSetLogFile.Exception__c = 'Line Number : ' + ex.getLineNumber() + ' - Cause : ' + ex.getCause() + ' - Message : ' + ex.getMessage();
        }
        finally
        {
            logFiles.add(orderSetLogFile);
        }
        
        //NotifTasksSet
        try
        {
            //
            notifTasksSetLogFile.Start_Time__c = system.now();
            notifTasksSetLogFile.External_Object__c = 'NotifTasksSet__x';
            
            
            if(notifTasksSetRecords.size() > 0 || !notifTasksSetRecords.isEmpty())
            {
                for(NotifTasksSet__x notifTasksSetInstance : notifTasksSetRecords)
                {
                    ExistingNotifTask.add(notifTasksSetInstance.ExternalId);
                }
            } 
            
            List<Task> existingTasks = [select id, sap_external_ID__c from Task where SAP_External_Id__c in :ExistingNotifTask];
            
            if(existingTasks.size() > 0 || !existingTasks.isEmpty())
            {
                for(task notifTaskInstance : existingTasks)
                {
                    notifTaskExist.put(notifTaskInstance.sap_external_ID__c,notifTaskInstance.id);
                }
            } 
            
            for(NotifTasksSet__x notifTasksSetInstance : notifTasksSetRecords)
            {
                task taskObj = new task();
                if(notifTaskExist.containsKey(notifTasksSetInstance.ExternalId))
                {
                    taskObj.id = notifTaskExist.get(notifTasksSetInstance.ExternalId);
                }
                dateValueString = DateFormatFromString(notifTasksSetInstance.ChangedOn__c);
                if(dateValueString != 'Error')
                {
                    taskObj.ChangedOn__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                taskObj.ChangedBy__c = notifTasksSetInstance.ChangedBy__c;
                Id notifId = notificationDetails.get(notifTasksSetInstance.NotificationNum__c);
                taskObj.WhatId = notifId;
                taskObj.Notification__c = notifTasksSetInstance.NotificationNum__c;
                taskObj.TaskNumber__c = notifTasksSetInstance.TaskNumber__c;
                
                // this fields Created By KoteswaraRao @ 13-12-2017 11:30 AM
                taskObj.CatalogType__c = notifTasksSetInstance.CatalogType__c;
                taskObj.CodeGroup__c = notifTasksSetInstance.CodeGroup__c;
                taskObj.CompletedBy__c = notifTasksSetInstance.CompletedBy__c;
                
                dateValueString = DateFormatFromString(notifTasksSetInstance.CompletedOn__c);
                if(dateValueString != 'Error')
                {
                    taskObj.CompletedOn__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                taskObj.CreatedBy__c = notifTasksSetInstance.CreatedBy__c;
                
                dateValueString = DateFormatFromString(notifTasksSetInstance.CreatedOn__c);
                if(dateValueString != 'Error')
                {
                    taskObj.CreatedOn__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                
                taskObj.FollowUpAction__c = notifTasksSetInstance.FollowUpAction__c;
                taskObj.FollowUpActionLog__c = notifTasksSetInstance.FollowUpActionLog__c;
                // taskObj.JobOwner__c
                taskObj.LongTextindicator__c = notifTasksSetInstance.LongTextindicator__c;
                //taskObj.NotifObjNumber__c = Double.valueOf(notifTasksSetInstance.NotifObjNumber__c);
                //taskObj.ObjNumber__c = Double.valueOf(notifTasksSetInstance.ObjNumber__c);
                
                dateValueString = DateFormatFromString(notifTasksSetInstance.PlannedFinishDate__c);
                if(dateValueString != 'Error')
                {
                    taskObj.PlannedFinishDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                dateValueString = DateFormatFromString(notifTasksSetInstance.PlannedStartDate__c);
                if(dateValueString != 'Error')
                {
                    taskObj.PlannedStartDate__c = Date.valueOf(dateValueString);
                    dateValueString = '';
                }
                taskObj.PrimaryLanguageIndicator__c = notifTasksSetInstance.PrimaryLanguageIndicator__c;
                //taskObj.ResponsiblePerson__c = Double.valueOf(notifTasksSetInstance.ResponsiblePerson__c);
                //taskObj.ResponsiblePersonFunction__c = notifTasksSetInstance.ResponsiblePersonFunction__c;
                taskObj.Root_NotifNumber__c = Double.valueOf(notifTasksSetInstance.Root_NotifNumber__c);
                //taskObj.Root_ObjNumber__c = Double.valueOf(notifTasksSetInstance.Root_ObjNumber__c);
                //taskObj.ShortText__c = notifTasksSetInstance.ShortText__c;
                //taskObj.StatusOBJNR__c = notifTasksSetInstance.StatusOBJNR__c;
                taskObj.TaskCode__c  = notifTasksSetInstance.TaskCode__c;
                taskObj.TaskNumber__c = notifTasksSetInstance.TaskNumber__c;
                
                taskToAdd.add(taskObj);
            }
            upsert taskToAdd;
            notifTasksSetLogFile.Stop_Time__c = system.now();
            notifTasksSetLogFile.User__c = UserInfo.getUserId();
        }
        catch(exception ex)
        {
            notifTasksSetLogFile.Is_Exception__c = true;
            notifTasksSetLogFile.Exception__c = 'Line Number : ' + ex.getLineNumber() + ' - Cause : ' + ex.getCause() + ' - Message : ' + ex.getMessage();
        }
        finally
        {
            logFiles.add(notifTasksSetLogFile);
        } 
        /*
        // Updated OrderOperationSet and AddressSet By Saikumar.N on 12-12-2017 @ 11.30 PM
        //OrderOperationSet 
        try
        {
            orderOperationLogFile.Start_Time__c = system.now();
            orderOperationLogFile.External_Object__c = 'OrderOperSet__x';
            orderOperationSetRecords = [SELECT Id, ExternalId, DisplayUrl, ActivityType__c, ActualFinishDate__c, ActualFinishTime__c, ActualStartDate__c, ActualStartTime__c, Assembly__c, 
                                        ConfirmationNum__c, ControlKey__c, CostElement__c, EarlyFinishDate__c, EarlyFinishTime__c, EarlyStartDate__c, EarlyStartTime__c, EquipmentNumber__c, 
                                        FunctionalLocation__c, GeneralCounter__c, GroupCounter__c, Internalcounter__c, JobOwner__c, LatestFinishDate__c, LatestFinishTime__c, LatestStartDate__c,
                                        LatestStartTime__c, NextPlannedDate__c, NodeNumber__c, NotifObjNumber__c, NotificationNum__c, ObjNumber__c, OperationNumber__c, OperationsRoutingNum__c, 
                                        OrderNumber__c, OrderObjNumber__c, Plant__c, Root_ObjNumber__c, Sequence__c, ShortText1__c, ShortText2__c, SystemCondition__c, TaskListGroupKey__c, 
                                        TaskListType__c, WorkCenter__c, Root_NotifNumber__c FROM OrderOperSet__x where jobowner__c in :jobOwners];
            
            system.debug('Sap Data Count: '+orderOperationSetRecords.size());
            for(OrderOperSet__x orderOperationInstance : orderOperationSetRecords)
            {
                system.debug('orderOperationInstance: '+orderOperationInstance); 
                Order_Operation__c orderOperationObj = new Order_Operation__c();
                orderOperationObj.NotificationNum__c = orderOperationInstance.NotificationNum__c;
                orderOperationObj.NotifObjNumber__c = Integer.valueOf(orderOperationInstance.NotifObjNumber__c);
                orderOperationObj.OperationNumber__c =  orderOperationInstance.OperationNumber__c;
                orderOperationObj.OrderNumber__c = orderOperationInstance.OrderNumber__c ;
                orderOperToAdd.add(orderOperationObj);
            }
            system.debug('Order Operation to add Count: '+orderOperToAdd.size());
            upsert orderOperToAdd;
            system.debug('Order Operations :'+orderOperToAdd);
            orderOperationLogFile.Stop_Time__c = system.now();
            orderOperationLogFile.User__c = UserInfo.getUserId();
            for(Order_Operation__c orderOperationRec : orderOperToAdd)
            {
                OrderOperDetails.put(orderOperationRec.Name, orderOperationRec.Id);
            }
        }
        catch(exception ex)
        {
            orderOperationLogFile.Is_Exception__c = true;
            orderOperationLogFile.Exception__c = ex.getMessage();
        }
        finally
        {
            logFiles.add(orderOperationLogFile);
            //insert orderOperationLogFile;
        }
        
        //AddressSet 
        try{
            addressLogFile.Start_Time__c = system.now();
            addressLogFile.External_Object__c = 'AddressSet__x';
            addressSetRecords = [SELECT Id, ExternalId, DisplayUrl, AddressType__c, City__c, CompanyName__c, ContractLegalName__c, CustomerNumber__c, DayTelephoneExtension__c, 
                                 DayTelephone__c, EmailAddress__c, FaxNumber__c, FirstName__c, JobOwner__c, LastName__c, LegalStatusOther__c, LegalStatus__c, MiddleInitial__c,
                                 MobileTelePhone__c, NightTelephone__c, NotifObjNumber__c, NotificationNum__c, Root_ObjNumber__c, State__c, Street__c, Title__c, ZipCode__c,
                                 Root_NotifNumber__c FROM AddressSet__x where JobOwner__c in :jobOwners];
            system.debug('Sap Data Count: '+addressSetRecords.size());
            for(AddressSet__x addressInstance : addressSetRecords )
            {
                system.debug('addressInstance::'+addressInstance);
                Address__c addressObj = new Address__c();
                addressObj.CompanyName__c = addressInstance.CompanyName__c;
                addressObj.Name = addressInstance.FirstName__c;
                addressObj.EmailAddress__c = addressInstance.EmailAddress__c;
                addressObj.MobileTelePhone__c = addressInstance.MobileTelePhone__c;
                addressObj.NotifObjNumber__c = Integer.valueOf(addressInstance.NotifObjNumber__c);
                addressObj.Root_NotifNumber__c = Integer.valueOf(addressInstance.Root_NotifNumber__c);
                addressObj.Root_ObjNumber__c = Integer.valueOf(addressInstance.Root_ObjNumber__c) ;
                addressToAdd.add(addressObj);  
            }
            system.debug('Address to add Count: '+addressToAdd.size());
            upsert addressToAdd;
            system.debug('Address'+addressToAdd);
            addressLogFile.Stop_Time__c = system.now();
            addressLogFile.User__c = UserInfo.getUserId();
            for(Address__c addressRec : addressToAdd)
            {
                addressDetails.put(addressRec.Name, addressRec.Id);
            }
        }
        catch(exception ex)
        {
            addressLogFile.Is_Exception__c = true;
            addressLogFile.Exception__c = ex.getMessage();
        }
        finally
        {
            logFiles.add(addressLogFile);
            //insert addressLogFile;   
        }
        */
        //Insert all log files
        insert logFiles;
        system.debug('Stop Time' + system.now());
    }//End of SAP2SFSync Method
    
    public static string DateFormatFromString(string dateToChange)
    {
        string dateFormat = 'Error';
        if(dateToChange != null)
        {
            system.debug('dateToChange '+dateToChange +' dateToChange size '+dateToChange.length());
            if(dateToChange.length() >= 7)
            {
                system.debug('dateToChange '+dateToChange);
                string year = dateToChange.substring(0, 4);
                if(year != '0000')
                {
                    system.debug('year '+year);
                    string month = dateToChange.substring(4, 6);
                    system.debug('month '+month);
                    string day = dateToChange.substring(6, 8);
                    system.debug('day '+day);
                    dateFormat = year + '-' + month + '-' + day;
                }
            }
        }
        return dateFormat;
    }
}