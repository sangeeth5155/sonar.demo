/*****************************************************************************************************************
Author      : MST Solutions
Date        : 12/01/2016
Description : This class contains test method for CaseFile object
*******************************************************************************************************************/
@isTest
public class VolunteerTaskTransfer_AC_Test {

    static testmethod void transferTask() {
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        Task newTask = new Task();
        newTask.Subject = 'Conduct Interview';
        newTask.ActivityDate = Date.Today();
        newTask.WhatId = parentCase.Id;
        newTask.ownerId = volunterUser.Id;
        insert newTask;
        ApexPages.StandardController sc = new ApexPages.StandardController(newTask);
        VolunteerTaskTransfer_AC volunteerTask = new VolunteerTaskTransfer_AC(sc);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        volunteerTask.getAssigners();
        volunteerTask.assignerId = volunterUser.Id;
        volunteerTask.transferTask();
    }
}