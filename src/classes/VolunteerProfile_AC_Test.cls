/*--*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Chandrasekar Nallusamy
Date        : 7/18/2016
Description : This test class used for unit test and code coverage
*******************************************************************************************************************/
@isTest
public class VolunteerProfile_AC_Test{
    
    // This test class used to cover all the picklist value retrieve function.
    static testmethod void coverAllPicklistFunction()
    {
    
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
         {
                Role__c currRole = OrientationandTrainingUtil.createRole();
                Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
                Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
                Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
                Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
                Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
                Volunteer_Orientation_Training__c  createVolOrientation = OrientationandTrainingUtil.createVolTraining(currOandT.id,currOffering.id,con.id,'Registered');
                Background_check__c currBC = OrientationandTrainingUtil.createBackgroundCheck(con.id);
                Conflict_Of_Interest__c currCOI = OrientationandTrainingUtil.createCOI(con.id);
                
               
                VolunteerProfile_AC profileController = new VolunteerProfile_Ac();
                profileController.getStates();
                profileController.getGender();
                profileController.getBirthDay();
                profileController.getBirthYear();
                profileController.getBirthMonth();
                profileController.getRaceEthnicity();
                profileController.getPreferedEmail();
                profileController.getProfessionalSKills();
                profileController.getLanguages();
                profileController.getOtherState();
                profileController.getAddType();
                profileController.getMake_A_Wish();
                profileController.getConatctAtWork();
                profileController.getEmpState();
                profileController.getRelationShip();
                profileController.getPreferedPhoneType();
               // Adding value for mulitselect list.
                profileController.raceEthinicityList.add('English');
                profileController.languagesList.add('English');
                profileController.langToRead.add('English');
                profileController.langToWrite.add('English');
                profileController.langToSpeak.add('English');
                profileController.langToUndetstand.add('English');
                profileController.professionalSkillsList.add('English');
                
                profileController.SavePersonalInfo();
                profileController.EditPersonalInfo();
                profileController.CancelPersonalInfo();
                
              //  profileController.SaveEmployeeInfo();
                profileController.EditEmployeeInfo();
                profileController.CancelEmpInfo();
                
             //   profileController.SaveEmergencyInfo();
                profileController.EditEmergencyInfo();
                profileController.CancelEmergencyInfo();
                
               
         }
    
        
     
    }
     // This test class used to cover all the picklist value retrieve function.
    static testmethod void UpdateContactInfowithHomePhoneType()
    {
    
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.VolunteerContactwithHomePhone(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
         {
               
               VolunteerProfile_AC profileController = new VolunteerProfile_Ac();
               
               
                profileController.SavePersonalInfo();
                 
         }
    
    }
   
   
    
    // This method is used to update the volunteer contact personal informations
     static testmethod void UpdateContactInfo()
    {
    
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
         {
               
               VolunteerProfile_AC profileController = new VolunteerProfile_Ac();
               
               profileController.getStates();
                profileController.getGender();
                profileController.getBirthDay();
                profileController.getBirthYear();
                profileController.getBirthMonth();
                profileController.getRaceEthnicity();
                profileController.getPreferedEmail();
                profileController.getProfessionalSKills();
                profileController.getLanguages();
                profileController.getOtherState();
                profileController.getAddType();
                profileController.getMake_A_Wish();
                profileController.getConatctAtWork();
                profileController.getEmpState();
                profileController.getRelationShip();
                profileController.getPreferedPhoneType();
               // Adding value for mulitselect list.
                profileController.raceEthinicityList.add('English');
                profileController.languagesList.add('English');
                profileController.langToRead.add('English');
                profileController.langToWrite.add('English');
                profileController.langToSpeak.add('English');
                profileController.langToUndetstand.add('English');
                profileController.professionalSkillsList.add('English');
                
                // profileController.contactInstance[0].Name = 'Test';
                 profileController.contactInstance[0].Email = 'Test@gmail.com';
                 profileController.contactInstance[0].Birth_Month__c  = 'May';
                 profileController.contactInstance[0].Birth_Month__c  = 'May';
                 profileController.contactInstance[0].Birth_Day__c  = '1';
                 profileController.contactInstance[0].HomePhone = '8220708920';
                 profileController.contactInstance[0].MailingStreet = 'Test';
                 profileController.contactInstance[0].MailingCity ='Test';
                 profileController.contactInstance[0].MailingPostalCode = '12345';
                 profileController.contactInstance[0].County__c = 'Test';
                 profileController.contactInstance[0].mailingstatecode = 'AZ';
                 profileController.contactInstance[0].Understand__c = 'English';
                 profileController.contactInstance[0].Read__c = 'English';
                 profileController.contactInstance[0].Write__c = 'English';
                 profileController.contactInstance[0].Language__c = 'English';
                 profileController.contactInstance[0].Speak__c = 'English';
                 profileController.contactInstance[0].Preferred_Phone_Types__c = 'Home';
                 profileController.contactInstance[0].Alternate_Phone_Type__c = 'Mobile';
                
                profileController.SavePersonalInfo();
                 
         }
    
        
     
    }
    
    
     // This test class used to Employee Update.
    static testmethod void UpdateEmployeeContactInfo()
    {
    
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         VolunteerProfile_AC profileController;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
         {
               
                profileController = new VolunteerProfile_Ac();
                profileController.contactInstance[0].id = con.id;
                
         }
         profileController.SavePersonalInfo();
         profileController.SaveEmployeeInfo();
    }
    
     // This test class used to Emergency Update.
    static testmethod void UpdateEmergencyContactInfo()
    {
    
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         VolunteerProfile_AC profileController;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
         {
               
                profileController = new VolunteerProfile_Ac();
                profileController.contactInstance[0].id = con.id;
                profileController.contactInstance[0].Emergency_Contact_Relationship__c = 'Friend';
                profileController.contactInstance[0].Emergency_Contact__c = 'Friend';
                profileController.contactInstance[0].Emergency_Contact_Phone__c = '8220708920';
               
         }
         
          profileController.SaveEmergencyInfo();
    }
}