/************************************************************************************
Author : Mst Solutions
Created date: 11/21/2016
Description : This class is used to increase the code coverage for WishFollowUpTaskAlert_AC
*************************************************************************************/
@isTest
public class WishFollowUpTaskAlert_AC_Test {
    
    @testSetup static void setup(){  
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        User VolcurrUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
    }
    
    //This method is used to create volunteer follwup task activities not completed task if there is any open task for volunteer user
    static testMethod void wishRecurrenceMethod() {
        List<User> volUser = [SELECT Id, ContactId FROM User WHERE ContactId != null AND isActive = true LIMIT 1];
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Date reqDateCalc = System.Today().addDays(16);
        parentCase.End_Date__c = reqDateCalc;
        update parentCase;
        List<CaseTeamRole> teamRole = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];
        CaseTeamMember caseMember = OrientationandTrainingUtil.createCaseTeamMember(parentCase.Id,volUser[0].Id,teamRole[0].id);
        Task newTask = OrientationandTrainingUtil.wishPresentationNotSet(parentCase.Id);
        newTask.OwnerId = volUser[0].Id;
        update newTask;
        WishFollowUpTaskAlert_AC c = new WishFollowUpTaskAlert_AC();
        Database.executeBatch(c);
    }
}