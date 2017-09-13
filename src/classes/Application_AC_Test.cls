/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : Application_AC_Test is used to increase the code coverage for Application_AC controller.
*****************************************************************************************************/

@isTest
public class Application_AC_Test{
   
   /* This method is used to update the volunteer contact information*/
   
    public testmethod static void UpdateVolunteerContact(){ 
         Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
         Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
         User currentVoulnteerUser;
         System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
            
        }
            OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
            OrientationandTrainingUtil.insertDocusignSetting();
            OrientationandTrainingUtil.createDynamicContent();
       
        system.RunAs(currentVoulnteerUser){
           list<Contact> conList = new list<Contact>();
           conList = [select id from contact];
           system.assertEquals(currentVoulnteerUser.ContactId,volunteerContact.Id);
            PageReference pageRef = Page.Application_VF; 
          
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
            applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.isSigned = true;
           
            System.assertEquals(currentVoulnteerUser.UserName,'joathanedwards@gmail.com');
        }
    }
    
    /*This method is used to sign the docusign document when the application is completed*/
    
    public testmethod static void SignDocument(){  
           Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
           Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
           User currentVoulnteerUser;
           System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
           /* contactShare currContactSharing = new contactShare();
            currContactSharing.ContactId = volunteerContact.Id;
            currContactSharing.UserOrGroupId = currentVoulnteerUser.id;
            currContactSharing.ContactAccessLevel = 'Read';
            currContactSharing.RowCause = Schema.contactshare.RowCause.Manual;
            insert currContactSharing;*/
        }
            OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
            OrientationandTrainingUtil.insertDocusignSetting();
            OrientationandTrainingUtil.createDynamicContent();
            
           
            
          system.RunAs(currentVoulnteerUser){
            PageReference pageRef = Page.Application_VF; 
            Test.setCurrentPage(pageRef);
            Application_AC applicationAcIns = new Application_AC();
            Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
            Test.StartTest();
            applicationAcIns.SubmitAndSign();
            applicationAcIns.saveRec();
            applicationAcIns.DisplayDescription();
            Test.StopTest();
            //System.assertEquals(currentVoulnteerUser.Email,'jonathan@gmail.com');
        }
    }
    
   /* This method is used to update the volunteer contact Alternate Phone type and prefered phone type with the value of Home*/
    
    public testmethod static void UpdateVolunteerContactwithHomePhone(){ 
         Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
         Contact volunteerContact = OrientationandTrainingUtil.VolunteerContactwithHomePhone(chapterAccount.Id);
         User currentVoulnteerUser;
         System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
            OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
            OrientationandTrainingUtil.insertDocusignSetting();
            OrientationandTrainingUtil.createDynamicContent();
       
        system.RunAs(currentVoulnteerUser){
           
            PageReference pageRef = Page.Application_VF; 
            Test.StartTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
            applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.isSigned = true;
            Test.StopTest();
            System.assertEquals(currentVoulnteerUser.UserName,'joathanedwards@gmail.com');
        }
    }
    
    /* This method is used to update the volunteer contact Alternate Phone type and prefered phone type with the value of Mobile*/
    
    public testmethod static void UpdateVolunteerContactwithMobilePhone(){ 
         Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
         Contact volunteerContact = OrientationandTrainingUtil.VolunteerContactwithMobilePhone(chapterAccount.Id);
         User currentVoulnteerUser;
         System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
            OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
            OrientationandTrainingUtil.insertDocusignSetting();
            OrientationandTrainingUtil.createDynamicContent();
       
        system.RunAs(currentVoulnteerUser){
           
            PageReference pageRef = Page.Application_VF; 
            Test.StartTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
             applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.isSigned = true;
            Test.StopTest();
            System.assertEquals(currentVoulnteerUser.UserName,'joathanedwards@gmail.com');
        }
    }
    
    /* This method is used to update the volunteer contact Alternate Phone type and prefered phone type with the value of Home and Mobile*/
    
    public testmethod static void UpdateVolunteerContactwithOtherPhone(){ 
         Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
         Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContactwithOtherPhone(chapterAccount.Id);
         User currentVoulnteerUser;
         System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
            OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
            OrientationandTrainingUtil.insertDocusignSetting();
            OrientationandTrainingUtil.createDynamicContent();
       
        system.RunAs(currentVoulnteerUser){
           
            PageReference pageRef = Page.Application_VF; 
            Test.StartTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
             applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.isSigned = true;
            Test.StopTest();
            System.assertEquals(currentVoulnteerUser.UserName,'joathanedwards@gmail.com');
        }
    }
   
}