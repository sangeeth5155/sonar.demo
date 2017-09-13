/************************************************************************************
Author : Mst Solutions
Created date: 11/21/2016
Description : This class is used to increase the code coverage for CloseVolunteerActivities_AC
*************************************************************************************/
@isTest
public class CloseVolunteerActivities_AC_Test {
    
    //Used to create volunteer User, Chapter Account, and Volunteer Contact
    @testSetup static void setup(){  
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        User VolcurrUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
    }
    
    //Close a task using Mark Completed custom javascript button from the volunteer task pagelayout
    static testMethod void openWishActivities() {
        User volUser = [SELECT Id, ContactId FROM User WHERE ContactId != null AND isActive = true LIMIT 1];
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Task newTask = OrientationandTrainingUtil.wishPresentationNotSet(parentCase.Id);
        newTask.Subject = 'Conduct Intial Wish Visit';
        newTask.OwnerId = volUser.Id;
        newTask.Status = 'Not Started';
        update newTask;
        System.assertEquals('Not Started', newTask.Status);
        System.RunAs(volUser) {
            CloseVolunteerActivities_AC.CloseTask(newTask.Id);
        }
        
        //Used to check salesforce governor limits
        OrientationandTrainingUtil.checkGovernorLimits();
    }
    
}