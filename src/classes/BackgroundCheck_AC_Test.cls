/*--*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar Nallusamy
Date        : 7/12/2016
Description : This test class used for unit test and code coverage
*******************************************************************************************************************/

@isTest
public class BackgroundCheck_AC_Test{
    //This method is used to create test data for Account & volunteer contact.
    @testSetup static void setup(){   
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        User currentVoulnteerUser;
        System.RunAs(new User(Id = UserInfo.getUserId())){
        currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
        OrientationandTrainingUtil.createBackgroundCheck(currentVoulnteerUser.ContactId);
        
        OrientationandTrainingUtil.createDynamicContent();
    }
    //This method is used to test the functionality by using specific user    
    public static testMethod void createVolunteerCommunityUser(){
        User dbUser = [SELECT Id,UserRoleId,UserName,ProfileId,Email,FirstName,LastName,isActive From User WHERE Email =:'jonathanEdwards@gmail.com' Limit 1];
        
        system.RunAs(dbUser){
            Test.StartTest();
            BackgroundCheck_AC backCheck = new BackgroundCheck_AC();
            backCheck.saveRec();
            Test.StopTest();
        }
    }
    
    public static testMethod void createVolunteerCommunityUserBackCheck(){
        User dbUser = [SELECT Id,UserRoleId,UserName,ProfileId,Email,FirstName,ContactId,LastName,isActive From User WHERE Email =:'jonathanEdwards@gmail.com' Limit 1];
        system.RunAs(dbUser){
            Test.StartTest();
            OrientationandTrainingUtil.createBackgroundCheck(dbUser.ContactId);
            Background_check__c backgroundCheck = OrientationandTrainingUtil.createBackgroundCheck(dbUser.ContactId);
            backgroundCheck.Resided_in_US_for_past_7_years__c = 'Yes';
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            OrientationandTrainingUtil.createDynamicContent();
            VolunteerLanding_AC_Test.BGCRecordSharing(dbUser.id,backgroundCheck.id);
            update backgroundCheck;
          
            BackgroundCheck_AC backCheck = new BackgroundCheck_AC();
            backCheck.backGroundCheck = backgroundCheck;
          
            backCheck.statusValue = true;
            backCheck.whyNeedBGCheck = 'To Verify';
            backCheck.isBGFinished = true;
            backCheck.residingInPast7Years = 'Yes';
            backCheck.areYouinUS7Yrs = 'Yes';
            backgroundCheck.Date_Completed__c = Date.Today();
            backgroundCheck.Status__c  = 'Approved';
            
         
            backCheck.saveRec();
            backCheck.getResidedValues();
            Test.StopTest();
        }
    }
  
    
}