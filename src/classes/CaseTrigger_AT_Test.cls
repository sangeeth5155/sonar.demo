/************************************************************************************
Author : Mst Solutions
Description : This class is used to increase the code coverage for CaseTrigger_AT and CaseTriggerHandler
*************************************************************************************/
@isTest
public class CaseTrigger_AT_Test {
    
    @testSetup static void methodName() {
        User sysAdminUser = OrientationandTrainingUtil.createrSystemAdminUserwithMgr();
    }
    
    static void createTask(String subject, String parentCaseId)
    {
        Task newTask = new Task();
        newTask.Subject = subject;
        newTask.ActivityDate = Date.Today();
        newTask.Priority = '4';
        newTask.WhatId = parentCaseId;
        insert newTask;
    }
    static void createTask(String subject, String parentCaseId, String recordTypeId)
    {
        Task newTask = new Task();
        newTask.Subject = subject;
        newTask.ActivityDate = Date.Today();
        newTask.Priority = '4';
        newTask.WhatId = parentCaseId;
        newTask.RecordTypeId = recordTypeId;
        insert newTask;
    }
    
    
    static testmethod void CreateNewCase()
    {
        User currUser = OrientationandTrainingUtil.createrSystemAdminUserwithMgr();
        System.RunAs(currUser)
        {
            Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
            /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
            Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
            Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
            Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
            Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
            createTask('Procure Icebreaker Gift',parentCase.id);
            parentCase.interview_Date__c = Date.Today().addDays(5);
            update parentCase;
            
        }
    }
    
    static testmethod void CreateInterviewDate()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        createTask('Complete/upload wish family packet',parentCase.id);
        parentCase.interview_Date__c = Date.Today().addDays(5);
        update parentCase;
    }
    
    static testmethod void UpdateCaseTeamMember()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
      /*  Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        parentCase.Case_Member_Count__c = 2;
        update parentCase;
    }
    
    static testmethod void UpdateInterviewDate()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        parentCase.interview_date__c = null;
        update parentCase;
        Task newTask = new Task();
        newTask.Subject = 'Test';
        newTask.Status = 'Completed';
        newTask.ActivityDate = Date.Today();
        newTask.Priority = '4';
        newTask.WhatId = parentCase.id;
        insert newTask;
        
    }
    
    static testmethod void UpdateStatusGranted()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        volunterCon.Number_of_wishes_active__c = 0;
        update volunterCon;
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        
        Volunteer_Opportunity__c  newVolOpp = new Volunteer_Opportunity__c();
        newVolOpp.Wish__c = parentCase.id;
        newVolOpp.Volunteer_Name__c = volunterCon.id;
        insert newVolOpp;
        
        parentCase.Status = 'Granted';
        update parentCase;
    }
    
    static testmethod void UpdatePresentationDate()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        WishGrantedSubCaseTaskList__c newRec = new WishGrantedSubCaseTaskList__c();
        newRec.Task_Subject__c = 'Schedule Wish Presentation (add date, time, location name and address)';
        newRec.Name = 'Schedule Wish Presentation';
        newRec.Due_Date__c = 5;
        newRec.Description__c = 'Test';
        insert newRec;
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.VolunteerTaskRT).getRecordTypeId();
        createTask('Schedule Wish Presentation (add date, time, location name and address)',parentCase.id,wishGrantTaskRT);
        
        Case wishGrantedCase = OrientationandTrainingUtil.createWishGrantCase(wishChild.id,parentCase.id);
        wishGrantedCase.Presentation_Date__c = Date.Today().addDays(5);
        wishGrantedCase.Time__c = '1:30';
        wishGrantedCase.Location_Address__c = 'Sample';
        wishGrantedCase.Name_of_Location__c = 'Sample';
        wishGrantedCase.Wish_Presentation_Set__c  = True;
        update wishGrantedCase;
    }
    
    static testmethod void UpdatePresentationDate1()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        WishGrantedSubCaseTaskList__c newRec = new WishGrantedSubCaseTaskList__c();
        newRec.Task_Subject__c = 'Test';
        newRec.Name = 'Schedule Wish Presentation';
        newRec.Due_Date__c = 5;
        newRec.Description__c = 'Test';
        insert newRec;
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_AC constant = new Constant_AC();
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.VolunteerTaskRT).getRecordTypeId();
        createTask('Test',parentCase.id,wishGrantTaskRT);
        
        Case wishGrantedCase = OrientationandTrainingUtil.createWishGrantCase(wishChild.id,parentCase.id);
        wishGrantedCase.Presentation_Date__c = Date.Today().addDays(5);
        wishGrantedCase.Wish_Presentation_Set__c  = True;
        wishGrantedCase.Time__c = '1:30';
        wishGrantedCase.Location_Address__c = 'Sample';
        wishGrantedCase.Name_of_Location__c = 'Sample';
        update wishGrantedCase;
        case setNullPresentation = new Case();
        setNullPresentation.Presentation_Date__c = null;
        setNullPresentation.Wish_Presentation_Set__c  = false;
        setNullPresentation.Id = wishGrantedCase.Id;
        update setNullPresentation;
    }
    
    static testmethod void UpdatePresentationDateNull()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        WishGrantedSubCaseTaskList__c newRec = new WishGrantedSubCaseTaskList__c();
        newRec.Task_Subject__c = 'Schedule Wish Presentation (add date, time, location name and address)';
        newRec.Name = 'Schedule Wish Presentation';
        newRec.Due_Date__c = 5;
        newRec.Description__c = 'Test';
        insert newRec;
        
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.ChapterName__c = chapterAccount.id;
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Presentation_Date__c = System.today();
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.ContactId = wishChild.Id;
        insert newParentWish;
        
        
        
        Id wishGrantTaskRT = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.VolunteerTaskRT).getRecordTypeId();
        createTask('Schedule Wish Presentation (add date, time, location name and address)',newParentWish.id,wishGrantTaskRT);
        newParentWish.Presentation_Date__c = null;
        update newParentWish;
    }
    
    Static testmethod void UpdateStatusasRTA()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
        Regions__c regionRec = OrientationandTrainingUtil.createRegion(chapterAccount.Id);
        insert regionRec;
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        wishChild.Region_Chapter__c = ChapterAccount.Id;
        wishChild.Region_Code__c =regionRec.Id;
        wishChild.County__c = 'Karur';
        update wishChild; 
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        parentCase.Status = 'Ready To Assign';
        parentCase.ChapterName__c = ChapterAccount.id;
        parentCase.Sub_Status__c = 'Testing';
        
        update parentCase;
    }
    
    Static testmethod void CreateAnticipationCase()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case updateCase = new Case();
        updateCase.Id = parentCase .Id;
        updateCase.Start_Date__c = null;
        update updateCase;
        Chapter_Action_Track__c newTrack = OrientationandTrainingUtil.createChapterActionTrack(); insert newTrack;
        newTrack.Chapter_Name__c = parentCase.ChapterName__c;
        update newTrack;
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        insert anticipationCase;
        
        
        
    }
    Static testmethod void CreateAnticipationCaseOther()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Chapter_Action_Track__c newTrack = OrientationandTrainingUtil.otherActionTrack(); insert newTrack;
        newTrack.Chapter_Name__c = parentCase.ChapterName__c;
        update newTrack;
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        insert anticipationCase;
        
        
        
    }
    
    Static testmethod void CreateDeterminationCase()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
        
        WishDeterminationSubCaseTaskList__c newTask = new WishDeterminationSubCaseTaskList__c();
        newTask.Name = 'Test';
        newTask.Due_Date__c = 5;
        newTask.Task_Subject__c = 'Test';
        insert newTask;
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id); 
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        Chapter_Action_Track__c newTrack = OrientationandTrainingUtil.createChapterActionTrack(); insert newTrack;
        newTrack.Chapter_Name__c = parentCase.ChapterName__c;
        update newTrack;
        String wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishDeterminationRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        insert anticipationCase;
        
        
        
    }
    
    Static testmethod void UpdateWishType()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Id taskPlanningRecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get(constant.VolunteerTaskRT).getRecordTypeId();
        Task newTask = new Task();
        newTask.Subject = 'Test';
        newTask.ActivityDate = Date.Today();
        newTask.Priority = '4';
        newTask.RecordTypeid = taskPlanningRecordTypeId;
        newTask.WhatId = parentCase.id;
        insert newTask;
        parentCase.Wish_Type__c = 'Test';
        update parentCase;
        
        
    }
    Static testmethod void UpdateStatusasWD()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_Ac constant = new Constant_Ac();
        String wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishDeterminationRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        insert anticipationCase;
        parentCase.Status = 'Wish Determined';
        parentCase.Sub_Status__c = 'Within Policy';
        update parentCase;
        
        
    }
    Static testmethod void UpdateStatusasDNQ()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case eligiblityCase= OrientationandTrainingUtil.CreatePartAWishRec();
        insert eligiblityCase;
        eligiblityCase.Status = 'DNQ - Chapter Staff';
        update eligiblityCase;
    }
    
    
    Static testmethod void UpdateStatusasAbandoned()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        createTask('Test',parentCase.id);
        parentCase.Status = 'Closed';
        parentCase.Sub_Status__c = 'Abandoned';
        update parentCase;
    }
    
    Static testmethod void UpdateStatusasHold()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        parentCase.Status = 'on Hold';
        update parentCase;
    }
    Static testmethod void UpdateStatusasinActive()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        parentCase.Status = 'inActive';
        update parentCase;
    }
    
    Static testmethod void UpdateWishChildFormFlag()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        parentCase.Update_Wish_Child_Form_Info__c = True;
        update parentCase;
    }
    
    @isTest static void PartACasestatusAsEscalated(){
        
        Constant_AC  constant = new Constant_Ac(); 
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Account acc = OrientationandTrainingUtil.MakeAWishAmericaAcc();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '059-17-12367';
        insert newLead;
        Contact dbMedicalCon = OrientationandTrainingUtil.CreateMedicalProfContact();
        Case PartACase = OrientationandTrainingUtil.CreatePartAWishRec();
        PartACase.Local_MCA_Team__c = dbMedicalCon.Id;
        PartACase.Lead__c = newLead.Id;
        insert PartACase; 
        dsfs__DocuSign_Status__c docuSignRec = OrientationandTrainingUtil.createDocusignStatus(newLead.Id);
        docuSignRec.dsfs__Envelope_Status__c = 'Completed';
        update docuSignRec;
        Blob b = Blob.valueOf('Test Data'); 
        Attachment attachment = new Attachment();  
        attachment.ParentId = docuSignRec.id;  
        attachment.Name = 'Test Attachment for Parent';  
        attachment.Body = b; 
        insert attachment;
        PartACase.Status = 'Escalated';
        update PartACase;
        Test.stopTest();
        
    }
    /*@isTest static void PartACasestatusAsApproved(){
        
        Constant_AC  constant = new Constant_Ac(); 
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();
        Account acc = OrientationandTrainingUtil.MakeAWishAmericaAcc();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
        newLead.Child_Age__c = '4';
        insert newLead;
        Contact dbMedicalCon = OrientationandTrainingUtil.CreateMedicalProfContact();
        Case PartACase = OrientationandTrainingUtil.CreatePartAWishRec();
        PartACase.Local_MCA_Team__c = dbMedicalCon.Id;
        PartACase.Lead__c = newLead.Id;
        insert PartACase; 
        Test.stopTest();
        Test.startTest();
        PartACase.Status = 'Approved - Chapter Staff';
        update PartACase;
        Test.stopTest();
        
        
    }*/
    
    
    @isTest static void PartACasestatusAsDNQ(){
        
        Constant_AC  constant = new Constant_Ac(); 
        Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        Test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Account acc = OrientationandTrainingUtil.MakeAWishAmericaAcc();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
        newLead.Child_Age__c = '4';
        newLead.unique_wish_identifier__c = '059-17-12367';
        insert newLead;
        Contact dbMedicalCon = OrientationandTrainingUtil.CreateMedicalProfContact();
        Case PartACase = OrientationandTrainingUtil.CreatePartAWishRec();
        PartACase.Local_MCA_Team__c = dbMedicalCon.Id;
        PartACase.Lead__c = newLead.Id;
        insert PartACase; 
        PartACase.Status = 'DNQ - Chapter Staff';
        update PartACase;
        Test.stopTest();
        
    }
    
    Static testmethod void CreateWishGrantedCase()
    {
        Constant_AC constant = new Constant_AC();
        Id wishGrantTaskRT = Schema.Sobjecttype.Chapter_Action_Track__c.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        
        Chapter_Action_Track__c newActionTrack = new Chapter_Action_Track__c();
        newActionTrack.Task_Name__c ='Sample Task';
        newActionTrack.Due_Days__c =10.0;
        newActionTrack.Description__c='sample';
        newActionTrack.RecordTypeId = wishGrantTaskRT;
        insert newActionTrack;
        
        WishGrantedSubCaseTaskList__c wishGrantedTask = new WishGrantedSubCaseTaskList__c();
        wishGrantedTask.Description__c = 'Test';
        wishGrantedTask.Due_Date__c = 10;
        wishGrantedTask.Task_Subject__c = 'Test';
        wishGrantedTask.Name = 'Task1';
        insert wishGrantedTask;
        
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id); 
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        Case wishGrantedCase = OrientationandTrainingUtil.createWishGrantCase(wishChild.id,parentCase.id);
    }
    
    Static testmethod void CreateWishExpense()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
        /*Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Chapter_Action_Track__c newTrack = OrientationandTrainingUtil.createChapterActionTrack(); insert newTrack;
        newTrack.Chapter_Name__c = parentCase.ChapterName__c;
        update newTrack;
        Id wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();        
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishPlanningRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        insert anticipationCase;
        
        Wish_Expense__c currExpense = new Wish_Expense__c();
        currExpense.Case__c = parentCase.id;
        currExpense.Budget_Approval_Status__c = 'Submitted';
        currExpense.Projected_Approval_Status__c = 'Submitted';
        currExpense.Projected_Cash__c = 0;
        currExpense.Projected_In_Kind__c = 0;
        insert currExpense;
        
        anticipationCase.Budget_Approval_Status__c = 'Approved';
        update anticipationCase;
        
    }

     Static testmethod void CreateDiagnosisVerificationReview()
     {
        Case caseDiagnosis = new Case();
        caseDiagnosis.subject = 'Test Eligibility Review';
        caseDiagnosis.RecordTypeId = '01236000000OJntAAG';
        caseDiagnosis.Status = 'New';
        caseDiagnosis.Origin = 'Email';
        insert caseDiagnosis;
       
     }
    
    static testmethod void ChangeCaseOwner() {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Constant_Ac constant = new Constant_Ac();
        String wishDeterminationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishDeterminationRT).getRecordTypeId();
        List<User> currUser = [SELECT Id FROM User WHERE email = 'testmawa@gmail.com'];
        Case anticipationCase = parentCase.clone();
        anticipationCase.RecordTypeId = wishDeterminationRecordTypeId;
        anticipationCase.parentId = parentCase.id;
        insert anticipationCase;
        parentCase.OwnerId = currUser[0].Id;
        update parentCase;
    }
    
    static testMethod void caseTeamMemberFunc() {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        CaseTeamRole volunteerManager = [SELECT Id FROM CaseTeamRole WHERE Name = 'Volunteer Manager'];   
        List<User> currUser = [SELECT Id FROM User WHERE email = 'testmawa@gmail.com'];
        //CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,userinfo.getUserid(),volunteerManager.id);
       
        Case updateCaseStat = new Case();
        updateCaseStat.OwnerId = currUser[0].Id;
        updateCaseStat.Id = parentCase.Id;
        update updateCaseStat;
    }
    
    static testMethod void createVolOpp() {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        wishChild.County__c = 'Karur';
        update wishChild;
        
        Role__c newRole = new Role__c();
        newRole.Name = 'Wish Granter';
        insert newRole;
        Chapter_Role__c newCR = new Chapter_Role__c();
        newCR.Role_Name__c = newRole.Id;
        newCR.Chapter_Name__c = chapterAccount.Id;
        insert newCR;
        Regions__c regionRec = OrientationandTrainingUtil.createRegion(chapterAccount.Id);
        insert regionRec;
        Contact newCon = new Contact();
        newCon.Id = wishChild.Id;
        newCon.Region_Chapter__c = ChapterAccount.Id;
        newCon.Region_Code__c =regionRec.Id;
        update newCon; 
        
        RecursiveTriggerHandler.isFirstTime = true;
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Case updateStatus = new Case();
        updateStatus.Id = parentCase.Id;
        updateStatus.ChapterName__c = chapterAccount.Id;
        updateStatus.Status = 'Ready to Assign';
        updateStatus.Sub_Status__c = 'Assign in Portal';
        
        update updateStatus;
    }
    
    Static testmethod void AnticipationAsNull()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Constant_AC constant = new Constant_AC();
        chapterAccount.Volunteer_Manager__c = userinfo.getUserId();
        update ChapterAccount;
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case newParentWish = new Case();
        newParentWish.RecordTypeId = parentWishRecordTypeId;
        newParentWish.Subject = 'Parent Wish';
        newParentWish.Interview_date__c = System.today();
        newParentWish.Wish_Type__c = 'Disney World';
        newParentWish.Start_Date__c = null;
        newParentWish.End_Date__c = System.today();
        newParentWish.ContactId = wishChild.Id;
        newParentWish.Status = 'New';
       // newParentWish.Anticipated_Start_Date__c = System.today();
        newParentWish.LiabilitySignerMapKeyPair__c = 'Vennila';
        insert newParentWish;
        Case updateCase = new Case();
        updateCase.Id = newParentWish.Id;
        updateCase.Start_Date__c = System.today();
        update updateCase;
        
        
    }
    
    
}