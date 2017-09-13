@isTest
Public class LeadDuplicate_ACTest
{
   
  // Creating duplicate lead and duplicate wish Family record.
  static testmethod void createDuplicateFamily()
  {
     Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
     Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
     Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
     newLead.Child_Age__c = '4';
     newLead.unique_wish_identifier__c = '1234567';
     insert newLead;
      
     Lead newdupLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
     newdupLead.Override_Dupe_Check__c = True;
     newdupLead.Child_Age__c = '4';
     newdupLead.unique_wish_identifier__c = '123456';
     insert newdupLead;
      
     ApexPages.currentPage().getParameters().put('wishFamily','True');
     ApexPages.currentPage().getParameters().put('Id',newLead.id);
     List<Lead> currLead = new List<Lead>();
     currLead.add(newLead);
     currLead.add(newdupLead);
     ApexPages.StandardSetController std = new ApexPages.StandardSetController(currLead);
     LeadDuplicate_AC controller = new LeadDuplicate_AC(std);
     controller.getdupLeadList();
     controller.getdupContactList();
     controller.getdupMedicalContactList();
     controller.getdupTreatingContactList();
     controller.getdupParentContactList();
     controller.nextStep();
  
  }
  // Selecting No duplicate Option on Lead Merge page.
  static testmethod void SelectNoDuplicate()
  {
     Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
     Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
     Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
     newLead.Child_Age__c = '4';
     newLead.unique_wish_identifier__c = '1234567';
     insert newLead;
      
     Lead newdupLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
     newdupLead.Override_Dupe_Check__c = True;
     newdupLead.Child_Age__c = '4';
     newdupLead.unique_wish_identifier__c = '1234568';
     insert newdupLead;
      
     ApexPages.currentPage().getParameters().put('wishFamily','True');
     ApexPages.currentPage().getParameters().put('Id',newLead.id);
     List<Lead> currLead = new List<Lead>();
     currLead.add(newLead);
     currLead.add(newdupLead);
     ApexPages.StandardSetController std = new ApexPages.StandardSetController(currLead);
     LeadDuplicate_AC controller = new LeadDuplicate_AC(std);
     controller.NoDuplicate = True; 
    
     controller.nextStep();
     controller.ContinuePartAForm();
     controller.CompleteDupeCheck();
  
  }
  
  // Creating duplicate medical professional contacts.
  static testmethod void duplicateMedicalProfessional()
  {
     Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
     Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
     Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
     
     
     newLead.Treating_Medical_Professional_First_Name__c = 'moss';
     newLead.Treating_Medical_Professional_Last_Name__c  = 'hart';
     newLead.Treating_Medical_Professional_Phone__c  = '9600467558';
     newLead.Treating_Medical_Professional_Email__c = 'testmawa1@gmail.com';
     newLead.Hospital_Treatment_Facility__c = 'Moss Hart AC';
     newLead.Child_Age__c = '4';
     newLead.unique_wish_identifier__c = '1234567';
     insert newLead;
     Lead newdupLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
     newdupLead.Override_Dupe_Check__c = True;
     newdupLead.Child_Age__c = '4';
     newdupLead.unique_wish_identifier__c = '1234568';
     insert newduplead;
     
     
     ApexPages.currentPage().getParameters().put('wishFamily','True');
     ApexPages.currentPage().getParameters().put('Id',newLead.id);
     List<Lead> currLead = new List<Lead>();
     currLead.add(newLead);
     currLead.add(newdupLead);
     ApexPages.StandardSetController std = new ApexPages.StandardSetController(currLead);
     LeadDuplicate_AC controller = new LeadDuplicate_AC(std);
    
     controller.getdupContactList();
     controller.getdupMedicalContactList();
     controller.getdupTreatingContactList();
     controller.getdupParentContactList();
       for(Lead currDup : currLead)
         {
           LeadDuplicate_AC.leadWrapper newWrapper = new LeadDuplicate_AC.LeadWrapper(currDup);
           newWrapper.selected = True;
           controller.wrapperList.add(newWrapper);
         }
     controller.getdupLeadList();
     controller.nextStep();
     Apexpages.currentPage().getParameters().put('recordId',currLead[0].id);
     controller.selectDefaultRecord();
     controller.mergeContacts();
  
  }
   //No duplicate creation.
   static testmethod void BlankLead()
  {
     List<Lead> currLead = new List<Lead>();
     ApexPages.StandardSetController std = new ApexPages.StandardSetController(currLead);
     LeadDuplicate_AC controller = new LeadDuplicate_AC(std);
  }

}