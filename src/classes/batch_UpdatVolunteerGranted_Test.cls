@isTest(seeAllData=false)

public class batch_UpdatVolunteerGranted_Test{
   //create a volunteer opportunity with wish and voluntter to count the number of granted wishes and non granted wishes.
   public static testmethod void  countGrantedWishes(){
       case newParentGrantedCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
       newParentGrantedCase .Status = 'Granted';
       Insert newParentGrantedCase ;
       
       case newParentNotGrantedCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
       newParentNotGrantedCase .Status = 'New';
       Insert newParentNotGrantedCase ;
       
       Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(OrientationandTrainingUtil.createchapterAccount().Id);
       
       Volunteer_Opportunity__c newVolunteerOppGranted1= OrientationandTrainingUtil.newVolunteerOpportunityWithCaseandVolunteer(newParentGrantedCase.Id , volunteerCon.Id);
       newVolunteerOppGranted1.Migrated_Record__c = True;
       update newVolunteerOppGranted1;
     
       Volunteer_Opportunity__c newVolunteerOppGranted2 = OrientationandTrainingUtil.newVolunteerOpportunityWithCaseandVolunteer(newParentGrantedCase.Id , volunteerCon.Id);
       Volunteer_Opportunity__c newVolunteerOppnotGrantedCase1 = OrientationandTrainingUtil.newVolunteerOpportunityWithCaseandVolunteer(newParentNotGrantedCase .Id , volunteerCon.Id);
       Volunteer_Opportunity__c newVolunteerOppnotGrantedCase2 = OrientationandTrainingUtil.newVolunteerOpportunityWithCaseandVolunteer(newParentNotGrantedCase .Id , volunteerCon.Id);
        
        
        //Excecute the batch class for count the granted and non granted wishes.
        Database.executeBatch(new batch_UpdatVolunteerGranted());
        
       
   }
}