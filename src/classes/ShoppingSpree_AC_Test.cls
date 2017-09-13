@isTest
public class ShoppingSpree_AC_Test {
    public static testMethod void createParentCase(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild();
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact volContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        User volUser = OrientationandTrainingUtil.createVolunteerUser(volContact.id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        CaseTeamRole  wishRole = [SELECT Id,Name FROM CaseTeamRole WHERE Name = 'Wish Granter'];
        OrientationandTrainingUtil.createCaseTeamMember(caseId.id,volUser.id,wishRole.Id);
        ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.Itinerary_VF;
        pageRef.getParameters().put('ID',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        ShoppingSpree_AC newShoppingSpree = new ShoppingSpree_AC(sc);
        newShoppingSpree.updateCaseTeamMember();
    }
    
}