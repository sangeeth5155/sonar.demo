@isTest
Public class CreateNewWish_ACTest
{

    Static testmethod void CreateParentWish()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
       /* Constituent_Code__c consTituent = OrientationandTrainingUtil.createWishParentGuardiansContituentCode();
        Constituent_Code__c  cinstChild = OrientationandTrainingUtil.createWishChildContituentCode();*/
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id); 
        User volunterUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunterCon.id);
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter'];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(parentCase.id,volunterUser.id,roleRec.id);
        //CreateNewWish_AC  newWish = new CreateNewWish_AC();
        CreateNewWish_AC.CreateCase(parentCase.id);
       
    }
}