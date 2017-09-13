/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : Unit TEst for Converting Prospective Volunteer as Active one.
*****************************************************************************************************/
@isTest
public class VolunteerOandTTriggerHandler_Test{
    
    // Converting Prospective Volunteer As Active.
    static testmethod void completeTraining()
    {
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
          system.debug('@@@@@@@@@@@@ contact ############'+con);             
         OrientationandTrainingUtil.createAffiliation(con.id);
             
         
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
         {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
         }
        // System.RunAs(currUser)
         //{         
         
            // Backgroud check creationn.
            system.debug('@@@@@@@@@@@ contact ############'+con.Id);             
             Background_check__c currBC = OrientationandTrainingUtil.createBackgroundCheck(con.id);
             currBC.Date_Completed__C = Date.Today();
             currBC.status__c = 'Approved';
             update currBC;
             
             Conflict_Of_Interest__c  createCOI = OrientationandTrainingUtil.createCOI(con.id);
             
              Role__c currRole = OrientationandTrainingUtil.createRole();
              Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
              Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
              Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
              Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
              Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
              Volunteer_Orientation_Training__c  createVolTraining = OrientationandTrainingUtil.createVolTraining(currOandT.id,currOffering.id,con.id,'Registered');
              
              createVolTraining.Volunteer_Attendance__c = 'Completed';
              update createVolTraining;
            
         //}
       }
 }