/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : VolunteerOpportunityTrigger_AT_Test is used to increase the code coverage for VolunteerOpportunityTrigger_AT trigger and VolunteerOpportunityTriggerHandler.
*****************************************************************************************************/
@isTest
public class VolunteerOpportunityTrigger_AT_Test {
    
    /*Submit volunteer Opportunity to approval process*/
    
    public testmethod static List<Volunteer_Opportunity__c>  SubmittoApproval(){   
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,3);
        List<Volunteer_Opportunity__c> volunteerOpportunityList = new List<Volunteer_Opportunity__c>();
        for(Volunteer_Opportunity__c processVolOpportunities : wishVolunteerOpportunityList){
            processVolOpportunities.Volunteer_Name__c = VolunteerContact.Id;
            volunteerOpportunityList.add(processVolOpportunities);
        }
        update volunteerOpportunityList;
        return volunteerOpportunityList;
    }
    
    
    public testmethod static void updateVolunteerOpportunity(){
        List<Volunteer_Opportunity__c> volOppList  = VolunteerOpportunityTrigger_AT_Test.SubmittoApproval();
        List<Volunteer_Opportunity__c> updateVOlOpportunity = new  List<Volunteer_Opportunity__c>();
        for(Volunteer_Opportunity__c currOpp : volOppList){
            updateVOlOpportunity.add(currOpp);
        }
        update updateVOlOpportunity;
    }
    
    //Create case team member when the approver approve the request 
    
    public testmethod static void  CreateCaseTeamMember(){   
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.ParentCasetoAddCaseMember(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        System.RunAs(new User(Id = UserInfo.getUserId())){
            List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,1);
            Volunteer_Opportunity__c updateVolOpportunity = new Volunteer_Opportunity__c();
            updateVolOpportunity.Id = wishVolunteerOpportunityList.get(0).Id;
            updateVolOpportunity.Status__c = 'Approved';
            updateVolOpportunity.Volunteer_Name__c = VolunteerContact.Id;
            update updateVolOpportunity;
            system.debug('@@@@@@ updateVolOpportunity @@@@@@@@@'+updateVolOpportunity);
        }
    }
    
    // Delete the approved volunteer opportunity 
    
    public testmethod static void  DeleteOpportunityCount(){   
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        volOpportunity.Volunteer_Name__c  = volunteerContact.Id;
        update volOpportunity;
        Volunteer_Opportunity__c  deleteOpportunity = new Volunteer_Opportunity__c ();
        deleteOpportunity.Id = volOpportunity.Id;
        deleteOpportunity.Volunteer_Name__c  = Null;
        update deleteOpportunity;
        delete deleteOpportunity;
    }
    
    // Create new wishVolunteerOpportunity when the reason inactive is not equal to null 
    
    public testmethod static void  CreateWishVolunteerOpportunityCount(){   
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.ParentCasetoAddCaseMember(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        System.RunAs(new User(Id = UserInfo.getUserId())){
            List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,1);
            Volunteer_Opportunity__c updateVolOpportunity = new Volunteer_Opportunity__c();
            updateVolOpportunity.Id = wishVolunteerOpportunityList.get(0).Id;
            updateVolOpportunity.Volunteer_Name__c = VolunteerContact.Id;
            updateVolOpportunity.Reason_Inactive__c = 'Moved';
            update updateVolOpportunity;
            
        }
    }
    
    // Create new nonWishVolunteerOpportunity when the reason inactive is not equal to null 
    
    public testmethod static void CreateNonWishVolunteerOpportunityCount(){   
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        volOpportunity.Volunteer_Name__c  = volunteerContact.Id;
        volOpportunity.Status__c = 'Approved';
        volOpportunity.Reason_Inactive__c = 'Moved';
        update volOpportunity;
        
    }
    
    //Update the NonWish Volunteer Opportunity count 
    
    public testmethod static void  UpdateNeededOpportunityCount(){   
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        Volunteer_Opportunity__c nonWishvolOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        volOpportunity.Volunteer_Name__c  = volunteerContact.Id;
        volOpportunity.Status__c = 'Approved';
        update volOpportunity;
        Volunteer_Opportunity__c  deleteOpportunity = new Volunteer_Opportunity__c ();
        deleteOpportunity.Id = volOpportunity.Id;
        deleteOpportunity.Volunteer_Name__c  = Null;
        deleteOpportunity.Status__c = 'Approved';
        update deleteOpportunity;
        delete deleteOpportunity;
    }
    
    //Update the NonWish Volunteer Opportunity registered count 
    public testmethod static void  UpdatetoRegisteredCount(){   
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        Volunteer_Opportunity__c nonWishvolOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);   
        volOpportunity.Volunteer_Name__c  = volunteerContact.Id;
        volOpportunity.Status__c = 'Approved';
        volOpportunity.Chapter_Role_Opportunity__c = chapterRole.id;
        volOpportunity.Reason_Inactive__c = Null;
        update volOpportunity;
        Volunteer_Opportunity__c  deleteOpportunity = new Volunteer_Opportunity__c ();
        deleteOpportunity.Id = volOpportunity.Id;
        deleteOpportunity.Volunteer_Name__c  = volunteerContact.id;
        deleteOpportunity.Chapter_Role_Opportunity__c = chapterRole.id;
        deleteOpportunity.Reason_Inactive__c = Null;
        update deleteOpportunity;
        delete deleteOpportunity;
        
    }
    
    public testmethod static void  createRecforNationalStaffasOwner(){   
        Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        
        System.runAs(nationalStaff) {
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
            Role__c nonWishRole = OrientationandTrainingUtil.createRole();
            Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
            Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
            OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
            Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        }
    }
    
    public testmethod static List<Volunteer_Opportunity__c>  RejectedWish(){   
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,3);
        List<Volunteer_Opportunity__c> volunteerOpportunityList = new List<Volunteer_Opportunity__c>();
        for(Volunteer_Opportunity__c processVolOpportunities : wishVolunteerOpportunityList){
            processVolOpportunities.Volunteer_Name__c = VolunteerContact.Id;
            processVolOpportunities.Reason_Inactive__c = 'Not Approved';
            volunteerOpportunityList.add(processVolOpportunities);
            
        }
        update volunteerOpportunityList;
        return volunteerOpportunityList;
    }
    
    public testmethod static void  RejectedNonWish(){   
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        Volunteer_Opportunity__c volOpportunity = OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);     
        volOpportunity.Volunteer_Name__c  = volunteerContact.Id;
        update volOpportunity;
        delete volOpportunity;
    }
    
    public testmethod static void  RemoveCaseTeamMember(){   
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.ParentCasetoAddCaseMember(wishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        System.RunAs(new User(Id = UserInfo.getUserId())){
            
            User currUser = OrientationandTrainingUtil.createActiveVolunteerUser(VolunteerContact.id);
            CaseTeamRole dbRole = [SELECT Id,Name From CaseTeamRole WHERE Name =: 'Wish Granter' Limit 1];
            CaseTeamMember caseMem = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,currUser.id,dbRole.Id);
            List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,1);
            Volunteer_Opportunity__c updateVolOpportunity = new Volunteer_Opportunity__c();
            updateVolOpportunity.Id = wishVolunteerOpportunityList.get(0).Id;
            updateVolOpportunity.Reason_Inactive__c = 'Non-responsive';
            updateVolOpportunity.Volunteer_Name__c = VolunteerContact.Id;
            update updateVolOpportunity;
            system.debug('@@@@@@ updateVolOpportunity @@@@@@@@@'+updateVolOpportunity);
        }
    }
    
}