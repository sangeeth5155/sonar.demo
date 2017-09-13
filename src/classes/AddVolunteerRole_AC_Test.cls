/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : AddVolunteerRole_AC_Test is used to increase the code coverage for Application_AC controller.
*****************************************************************************************************/
@isTest
public class AddVolunteerRole_AC_Test{
    
    /* This method is used to create number of NonWishEvent Volunteer Opportunity count */
    
    public testmethod static void CreateNonWishEvent(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        User volunteerUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunteerContact.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(nonWishEvent);
        AddVolunteerRole_AC addRole = new AddVolunteerRole_AC(sc);
        PageReference pageRef = Page.AddVolunteerRole_VF;
        pageRef.getParameters().put('id', String.valueOf(nonWishEvent.Id));
        Test.setCurrentPage(pageRef);
        Volunteer_Count__c  volnteerCount = OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);
        addRole.addRow();
        addRole.RoleName = 'WishGranter';
        addRole.VolunteerCount = 3;
        addRole.isCommunity = false;
        Volunteer_Count__c   VolunteerNeededCount = [SELECT Id,Volunteer_Needed__c  FROM Volunteer_Count__c WHERE Id =: volnteerCount.Id];
        VolunteerNeededCount.Volunteer_Needed__c  = 2;
        update VolunteerNeededCount;
        addRole.EditRec();
        addRole.saveRec();
        addRole.cancelRec();
        addRole.ChapterRoleId = chapterRole.Id;
        addRole.register();
        
    }
    
    /*This method is used to remove the volunteer contact from NonWishEvent Volunteer Opportunity*/
    
    public testmethod static void RemoveVolunteerContactonNonwishEvent(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(nonWishEvent);
        AddVolunteerRole_AC addRole = new AddVolunteerRole_AC(sc);
        PageReference pageRef = Page.AddVolunteerRole_VF;
        pageRef.getParameters().put('id', String.valueOf(nonWishEvent.Id));
        Test.setCurrentPage(pageRef);
        Volunteer_Count__c  volnteerCount = OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);
        addRole.addRow();
        addRole.RoleName = 'WishGranter';
        addRole.VolunteerCount = 3;
        addRole.isCommunity = false;
        Volunteer_Count__c   VolunteerNeededCount = [SELECT Id,Volunteer_Needed__c  FROM Volunteer_Count__c WHERE Id =: volnteerCount.Id];
        VolunteerNeededCount.Volunteer_Needed__c  = 2;
        update VolunteerNeededCount;
        addRole.EditRec();
        if(addRole.volunteerCountToUpdateList.size() > 0)
        {
            addRole.volunteerCountToUpdateList.get(0).Chapter_Role__c = null;
        }
        addRole.saveRec();
        addRole.cancelRec();
        addRole.ChapterRoleId = chapterRole.Id;
        addRole.register();
        
    }
    
    /* This method is used to update number of NonWishEvent Volunteer Opportunity count */
    
    public testmethod static void UpdateNonWishEvent(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(nonWishEvent);
        AddVolunteerRole_AC addRole = new AddVolunteerRole_AC(sc);
        PageReference pageRef = Page.AddVolunteerRole_VF;
        pageRef.getParameters().put('id', String.valueOf(nonWishEvent.Id));
        Test.setCurrentPage(pageRef);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);
        addRole.addRow();
        addRole.RoleName = 'WishGranter';
        addRole.VolunteerCount = 3;
        addRole.isCommunity = false;
        addRole.saveRec();
        addRole.EditRec();
        addRole.cancelRec();
        addRole.ChapterRoleId = chapterRole.Id;
        addRole.register();
        
    }
    
    /* This method is used to Register the volunteer contact to NonWishEvent Volunteer Opportunity */
    
    public testmethod static void RegisterVolunteerContact(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Role__c nonWishRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.id,nonWishRole.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEvent.Id,chapterRole.Id,3);
        OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEvent.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(nonWishEvent);
        AddVolunteerRole_AC addRole = new AddVolunteerRole_AC(sc);
        PageReference pageRef = Page.AddVolunteerRole_VF;
        pageRef.getParameters().put('id', String.valueOf(nonWishEvent.Id));
        Test.setCurrentPage(pageRef);
        Non_Wish_Events__c nonWishEventRec = OrientationandTrainingUtil.CreateEventRec(chapterRole.Id,chapterAccount.Id);
        OrientationandTrainingUtil.createVolunteerCount(nonWishEventRec.Id,chapterRole.Id,3);
        OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(chapterAccount.Id,chapterRole.Id,nonWishEventRec.Id);
        addRole.addRow();
        addRole.addRow();
        addRole.RoleName = 'WishGranter';
        addRole.VolunteerCount = 3;
        addRole.isCommunity = false;
        addRole.saveRec();
        addRole.EditRec();
        addRole.cancelRec();
        addRole.ChapterRoleId = chapterRole.Id;
        addRole.register();
        
    }
    
}