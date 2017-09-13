@isTest
public class ConflictOfInterestTrigger_AT_Test{
  // Mapping fields.
  public static testMethod void createConflictOfInterest(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
         Conflict_Of_Interest__c  coiRec = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
        }
 
   public static testMethod void updateConflictOfInterest(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        volunteerContact.Region_Chapter__C=chapterAccount.Id;
        Update volunteerContact;
         Conflict_Of_Interest__c  coiRec = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
         coiRec.Expiration_Date__c = Date.Today().addYears(1);
         update coiRec;
        }
        
   public static testMethod void nationalStaffConflictOfInterest(){
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
             volunteerContact.Region_Chapter__C=chapterAccount.Id;
            Update volunteerContact;
            Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
            newCOI.Volunteer_Contact__c = volunteerContact.Id;
            newCOI.Expiration_Date__c = system.today() + 3;
            newCOI.Current__C = True;
            insert newCOI;
       }
   }
   public static testMethod void UpdateOwnerConflictOfInterest(){
       Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
            volunteerContact.Region_Chapter__C=chapterAccount.Id;
            Update volunteerContact;
            Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
            newCOI.Volunteer_Contact__c = volunteerContact.Id;
            newCOI.Expiration_Date__c = system.today() + 3;
            newCOI.Signed_Date__c = system.today();
            newCOI.Current__C = false;
            insert newCOI;
            
       User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        
        System.runAs(nationalStaff) {
            newCOI.OwnerId=nationalStaff.Id;
            newCOI.Current__C = True;
            Update newCOI;
       }
   }
}