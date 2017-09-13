@istest
public class LeadTriggerHandler_Test{
    public testmethod static void UpdateStatusDNQ(){
     User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        RecursiveTriggerHandler.isFirstTime = True;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact medicalProfessionalCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        chapterAccount.Intake_Manager__c = nationalStaff.Id;
        Update chapterAccount;
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        newLead.ChapterName__c = chapterAccount.Id;
       // newLead.OwnerId =nationalStaff.Id;
        newLead.status = 'Inquiry';
        Insert newlead;
        system.assertequals(chapterAccount.Id,[SELECT ChapterName__r.Name FROM lead WHERE Id =: newlead.Id].ChapterName__c);
        system.assertequals('Referred',[SELECT status FROM lead WHERE Id =: newLead.Id].Status);
         RecursiveTriggerHandler.isFirstTime = True;
        newlead.Status= 'DNQ';
        //updateLeadStatus.Id = newlead.Id;
        Update newlead;
        system.assertequals('DNQ',[SELECT status FROM lead WHERE Id =: newlead.Id].Status);
         
        
    }
    
}