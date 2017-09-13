@isTest
public class WishParticipants_Test{
    @isTest static void createRelationship(){
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        npe4__Relationship__c relationship = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,wishFamily.Id);
        relationship.npe4__Type__c = 'Family';
        Update relationship;
        PageReference pageRef = Page.WishParticipants_VF;
        Test.setCurrentPage(pageRef);
         ApexPages.StandardController stdController = new ApexPages.StandardController(wish);
        WishParticipants_AC wishparticipant =  new WishParticipants_AC(stdController);
        wishparticipant.getParticipantsConList();
    }
}