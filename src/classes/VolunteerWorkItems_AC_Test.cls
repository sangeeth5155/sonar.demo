@isTest
public class VolunteerWorkItems_AC_Test {
    
    @testSetup static void setup(){  
        Constant_AC  constant = new Constant_Ac(); 
        Id nonWishEvents = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.nonWishEventRT).getRecordTypeId();
        Id wishEvents = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        System.RunAs(new User(Id = UserInfo.getUserId())) {
            User currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        }
        Role__c currRole = OrientationandTrainingUtil.createRole();
        Role__c currNonWishRole = OrientationandTrainingUtil.createNonWishRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.Id);
        Chapter_Role__c  currNonWishChapRole = OrientationandTrainingUtil.createChapter(acc.id,currNonWishRole.Id);
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.Id);
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case newParentWish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Volunteer_Opportunity__c wishVolunteerOpportunity = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(acc.Id,currChapRole.Id,newParentWish.Id);
        wishVolunteerOpportunity.Volunteer_Name__c = con.Id;
        update wishVolunteerOpportunity;
        Volunteer_Opportunity__c duplicateWishVolunteerOpportunity = OrientationandTrainingUtil.createDuplicateNewWishVolunteerOpportunity(acc.Id,currChapRole.Id,newParentWish.Id);
        duplicateWishVolunteerOpportunity.Volunteer_Name__c = con.Id;
        update duplicateWishVolunteerOpportunity;
        Volunteer_Opportunity__c wishVolunteerOpportunity1 = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(acc.Id,currChapRole.Id,newParentWish.Id);
        Non_Wish_Events__c nonWishEvent = OrientationandTrainingUtil.CreateEvent(acc.Id);
        Volunteer_Opportunity__c nonWishVolunteerOpportunity= OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(acc.Id,currChapRole.Id,nonWishEvent.Id);
        nonWishVolunteerOpportunity.Volunteer_Name__c = con.Id;
        update nonWishVolunteerOpportunity;
        Volunteer_Opportunity__c duplicateNonWishVolunteerOpportunity = OrientationandTrainingUtil.CreateNonWishDuplicateVolunteerOpportunity(acc.Id,currChapRole.Id,nonWishEvent.Id);
        Volunteer_Opportunity__c nonWishVolunteerOpportunity1= OrientationandTrainingUtil.CreateNonWishVolunteerOpportunity(acc.Id,currChapRole.Id,nonWishEvent.Id);
        /*Case ParentWish = OrientationandTrainingUtil.CreateParentCaseWithTravel(wishChild.Id);
        Volunteer_Opportunity__c closewishVolunteerOpportunity = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(acc.Id,currChapRole.Id,ParentWish.Id);
        closewishVolunteerOpportunity.Volunteer_Name__c = con.Id;
        update closewishVolunteerOpportunity;*/
    }
    
    public static testMethod void volunteerWishEvents() {
        
        user currUser = [SELECT Id,UserName FROM User WHERE UserName =:'joathanedwards@gmail.com'];
        Case dbCase = [SELECT Id,Status,Wish_Type__c FROM Case WHERE Wish_Type__c =: 'Disney World'];
        Volunteer_Opportunity__c dbOpp = [SELECT Id,Wish__c FROM Volunteer_Opportunity__c WHERE Wish__c =:dbCase.id Limit 1];
        System.RunAs(currUser) {
            test.startTest();
            PageReference pageref = Page.MyAssignment_VF;
            Test.setCurrentPageReference(pageref);
            VolunteerWorkItems_AC volunteerWorkitems = new VolunteerWorkItems_AC();
            volunteerWorkitems.volunteerOpportunityRecordId = dbOpp.Id;
            volunteerWorkitems.CurrentWish();
            volunteerWorkitems.HistoricalWish();
            volunteerWorkitems.getVolunteerAssignedWishEvents();
            volunteerWorkitems.getVolunteerAssignedNonWishEvents();
            volunteerWorkitems.getWishEvents();
            volunteerWorkitems.getNonWishEvents();
            volunteerWorkitems.RegisterWishEvents();
            volunteerWorkitems.registrationConfirmation();
            test.stopTest();
        }
    }     
    public static testMethod void volunteerClosedWish() {
        Test.startTest();
        user currUser = [SELECT Id,UserName FROM User WHERE UserName =:'joathanedwards@gmail.com'];
        
        Case dbCase = [SELECT Id,Status,Wish_Type__c FROM Case WHERE Wish_Type__c =: 'Disney World'];
        dbCase.Status = 'Closed';
        //update closedCase;
        
        System.RunAs(currUser) {
            
            PageReference pageref = Page.MyAssignment_VF;
            Test.setCurrentPageReference(pageref);
            VolunteerWorkItems_AC volunteerWorkitems = new VolunteerWorkItems_AC();
            volunteerWorkitems.CurrentWish();
            volunteerWorkitems.HistoricalWish();
            volunteerWorkitems.getClosedWish();
            
            
        }
        test.stopTest();
    }
    public static testMethod void volunteerClosedNonWish() {
        Test.startTest();
        user currUser = [SELECT Id,UserName FROM User WHERE UserName =:'joathanedwards@gmail.com'];
        Non_Wish_Events__c closedNonWish = [SELECT Id,Event_Text__c  FROM Non_Wish_Events__c WHERE Event_Text__c = 'Sending Wish Child'];
        closedNonWish.Event_Date__c = system.today() - 3;
        update closedNonWish;
        System.RunAs(currUser) {
            PageReference pageref = Page.MyAssignment_VF;
            Test.setCurrentPageReference(pageref);
            VolunteerWorkItems_AC volunteerWorkitems = new VolunteerWorkItems_AC();
            volunteerWorkitems.CurrentWish();
            volunteerWorkitems.HistoricalWish();
            volunteerWorkitems.getClosedNonWishEvents();
            
        }
         test.stopTest();
    }
   
    public static testMethod void volunteerRegisteredNonWish() {
        
        user currUser = [SELECT Id,UserName FROM User WHERE UserName =:'joathanedwards@gmail.com'];
        Non_Wish_Events__c dbNonWish = [SELECT Id,Event_Text__c  FROM Non_Wish_Events__c WHERE Event_Text__c = 'Sending Wish Child'];
        Volunteer_Opportunity__c dbOpp = [SELECT Id,Chapter_Name__r.Name,Non_Wish_Event__C,Chapter_Role_Opportunity__r.Role_Name__c FROM Volunteer_Opportunity__c WHERE Non_Wish_Event__C =: dbNonWish.Id Limit 1];
        System.RunAs(currUser) {
            PageReference pageref = Page.MyAssignment_VF;
            Test.setCurrentPageReference(pageref);
            VolunteerWorkItems_AC volunteerWorkitems = new VolunteerWorkItems_AC();
             volunteerWorkitems.volunteerOpportunityRecordId = dbOpp.Id;
            
            
        }
    }
   
}