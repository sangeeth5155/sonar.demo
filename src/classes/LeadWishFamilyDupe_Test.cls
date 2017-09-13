@isTest
Public class LeadWishFamilyDupe_Test
{

   static testmethod void createRecords()
   {
     Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
     Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
     Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
     newLead.Child_Age__c = '4';
     newLead.unique_wish_identifier__c = '123456';
     insert newLead;
     LeadWishFamilyDupe.FindFamilyContactDupe(newLead.id);
   
   }
   
    /*This method is used to increase the code coverage for findDuplicateRecords method */ 
   public testmethod static void FindWishChildDupe(){ 
         
         Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
         Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
         Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
         newLead.unique_wish_identifier__c = '1234567';
         newLead.Child_Age__c = '4';
         insert newLead;
         Lead dupeLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
         dupeLead.Override_Dupe_Check__c = true;
         dupeLead.unique_wish_identifier__c = '123456';
         insert dupeLead;  
         LeadWishFamilyDupe.FindLeadDupe(dupeLead.id);
        
        
   }
   
    /*This method is used to increase the code coverage for findDuplicateRecords method */ 
   public testmethod static void FindLeadDupe(){ 
         
         Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
         Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
         Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
         newLead.unique_wish_identifier__c = '1234567';
         newLead.Child_Age__c = '4';
         newLead.State = 'Arizona';
         newLead.PostalCode  = '35004';
         newLead.street ='test';
         newLead.Phone = '8220708920';
         insert newLead;
         Lead dupeLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id); 
         dupeLead.LastName='John';
         dupeLead.city = 'Karur';
         dupeLead.State = 'Arizona';
         dupeLead.PostalCode  = '35004';
         dupeLead.street ='test';
         dupeLead.Phone = '8220708920';
         dupeLead.Override_Dupe_Check__c = true;
         dupeLead.unique_wish_identifier__c = '123456';
         insert dupeLead;  
         LeadWishFamilyDupe.FindLeadDupe(dupeLead.id);
        
        
   }

}