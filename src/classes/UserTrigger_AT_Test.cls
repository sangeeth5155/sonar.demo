/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : UserTrigger_AT_Test is used to increase the code coverage for Application_AC controller.
*****************************************************************************************************/
@isTest
public class UserTrigger_AT_Test {
    
   /*This method is used to create a system Addmin user records*/
    @testSetup static void setup(){   
         OrientationandTrainingUtil.createrSystemAdminUser();
     
     }
     /*This method is used to create a prospectiv user records*/
     
     public testmethod static void createProspectiveUser(){ 
       User dbUser = [SELECT Id,UserRoleId,UserName,ProfileId,Email,FirstName,LastName,isActive From User WHERE FirstName =: 'Test FirstName' Limit 1];
       system.RunAs(dbUser){
       Test.StartTest();
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.id);
       Test.StopTest();
       }
     }
     
    /*This method is used to create a public Group records*/
    
     public testmethod static void createPublicGroup(){ 
         User dbUser = [SELECT Id,UserRoleId,UserName,ProfileId,Email,FirstName,LastName,isActive From User WHERE FirstName =: 'Test FirstName' Limit 1];
         system.RunAs(dbUser){
         Test.StartTest();
         OrientationandTrainingUtil.cretateGroup();
         //TestClassUtil.createProspectiveVolunteerUserthree();
         Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
         contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
         OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.id);
         Test.StopTest();
         }
     }
     
     public testmethod static void updateUser(){
            system.RunAs( new user(ID = UserInfo.getUserID())){
            Account chapterAcc = OrientationandTrainingUtil.createVolunteerAccount();
            Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact chapterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAcc.Id);
            Contact chaptercontact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
            Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon(); 
            case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
            Account chapterAccountWithVolunteerManager=OrientationandTrainingUtil.createVolunteerAccountwithVolunteerManager();
            case updatecase = new Case();
            updatecase.isEmailWishGranter__c = true;
            updatecase.InActiveWishGranter__c = 'test';
            updatecase.Id = parentCase.Id;
            update updateCase;
            
            //CaseTeamRole caseRole = OrientationandTrainingUtil.CreateCaseTeamRole();
            CaseTeamRole role = [SELECT Id,Name FROM CaseTeamRole WHERE Name =: 'Wish Granter'];
            User ArizonaVolunterrUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(chapterCon.Id);
            User AlabamaVolunterrUser = OrientationandTrainingUtil.createVolunteerUser(chaptercontact .Id);
            CaseTeamMember ArizonacasTemMember = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,ArizonaVolunterrUser.Id,role.Id);
            CaseTeamMember AlabamacasTemMember = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,AlabamaVolunterrUser.Id,role.Id);
            User queryAlabamaUser = [SELECT Id,IsActive from User WHERE Id =:AlabamaVolunterrUser.Id];
            Volunteer_Opportunity__c volunteerOpportunityRec= OrientationandTrainingUtil.NewnonWishVolunteerOpportunity(chapterAccountWithVolunteerManager.Id,chaptercontact.Id);
            user updateUser = new User();
            updateUser.Id = queryAlabamaUser.Id;
            updateUser.IsActive = false;
            update updateUser;
            }
           
           
           
     }
     
    public testmethod static void Test_AddInternalUserToChatterGroup() {
        system.RunAs( new user(ID = UserInfo.getUserID())){
            CollaborationGroup newGroup = OrientationandTrainingUtil.createCollaborationGroup('America');
            UserRole newUserRole = new UserRole();
            newUserRole.Name  = 'America - Chapter';
            Insert newUserRole;
            User newUser = OrientationandTrainingUtil.createUserWithRole(newUserRole.Id);
        }
    }
    
    public testmethod static void Test_RemoveInternalUserToChatterGroup() {
        system.RunAs( new user(ID = UserInfo.getUserID())){
            //CollaborationGroup newGroup = OrientationandTrainingUtil.createCollaborationGroup('Alabama');
            //CollaborationGroup newGroup1 = OrientationandTrainingUtil.createCollaborationGroup('Arizona');
            UserRole newUserRole = new UserRole();
            newUserRole.Name  = 'Alabama - Chapter';
            Insert newUserRole;
            UserRole newUserRole1 = new UserRole();
            newUserRole1.Name  = 'Arizona - Chapter';
            Insert newUserRole1;
            User newUser = OrientationandTrainingUtil.createUserWithRole(newUserRole.Id);
            newUser.UserRoleId = newUserRole1.Id;
            update newUser;
        }
    }
    
}