/**
* An apex page controller that takes the user to the right start page based on credentials or lack thereof
*/
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest
    public static void ActiveVolunteer() {
        // Instantiate a new controller with all parameters in the page
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact volContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Profile profileInfo = [SELECT Id FROM Profile WHERE Name = 'Active Volunteer (Login)'];
        
        User newActiveVolunteerUser = new User(  firstname = 'ActiveMAWA',lastName = 'User',email = 'activemawauser@dummygmail.com',Username = 'activemawauser@dummygmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = profileInfo.Id ,ContactId = volContact.Id,isActive = true);
        insert newActiveVolunteerUser;
        System.runAs(newActiveVolunteerUser) {
            CommunitiesLandingController controller = new CommunitiesLandingController();
            controller.forwardToStartPage();
            
        }
    }
    @IsTest
    public static void ProspectiveVolunteer() {
        // Instantiate a new controller with all parameters in the page
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact volContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Profile profileInfo = [SELECT Id FROM Profile WHERE Name = 'Prospective Volunteer (Login)'];
        
        User newProspectiveUser = new User(  firstname = 'ProspectiveMAWA',lastName = 'User',email = 'prospectivemawauser@dummygmail.com',Username = 'prospectivemawauser@dummygmail.com',
                                           EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                           LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = profileInfo.Id ,ContactId = volContact.Id,isActive = true);
        insert newProspectiveUser;
        System.runAs(newProspectiveUser) {
            CommunitiesLandingController controller = new CommunitiesLandingController();
            controller.forwardToStartPage();
            
        }
    }
    
    @IsTest
    public static void UserLoginWithReturnURL() {
        // Instantiate a new controller with all parameters in the page
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact volContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Profile profileInfo = [SELECT Id FROM Profile WHERE Name = 'Active Volunteer (Login)'];
        
        User newActiveVolunteerUser = new User(  firstname = 'Jonathann',lastName = 'Edwardss',email = 'jonath23an@gmail.com',Username = 'jonath23an@gmail.com',
                                               EmailEncodingKey = 'ISO-8859-1',Alias = 'jone',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                               LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = profileInfo.Id ,ContactId = volContact.Id,isActive = true);
        insert newActiveVolunteerUser;
        System.runAs(newActiveVolunteerUser) {
            String startUrl = 'https://mawa.com';
            apexpages.currentpage().getparameters().put('startUrl' , startUrl);
            CommunitiesLandingController controller = new CommunitiesLandingController();
            controller.forwardToStartPage();
            
        }
    }
}