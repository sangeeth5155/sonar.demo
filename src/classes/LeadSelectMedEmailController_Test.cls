@isTest
public class LeadSelectMedEmailController_Test{

    //select best contact physician to receive DV Form. 
    public static testmethod  void sendDVFormToBestPhysician(){
        Account chapterAc = OrientationandTrainingUtil.createchapterAccount();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAc.Id);
        newLead.Best_contact_for_Physician_Email__c = 'bestContact@mail.com';
        newLead.Best_Contact_for_Physician_First_Name__c = 'Testbest';
        newLead.Best_Contact_for_Physician_Last_Name__c = 'physician';
        Insert  newLead;
        PageReference pageRef = Page.LeadSelectMedEmail_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',newLead.Id);
        LeadSelectMedEmailController_AC selectLead = new LeadSelectMedEmailController_AC();
        selectLead.updateLead();
        selectLead.GoToLeadViewPage();
        
        
    }
}