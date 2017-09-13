@isTest
public class WishReferralForm_AC_Test {

    public static testMethod void relationshipNone() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.warningMsg = 'test';
        controller.displayWarningPopup = true;
        controller.CreateLead();
        controller.currLead.Child_Age__c = 'Under 2.5';
       
    }
    public static testMethod void relationshipSelf() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Self';
        controller.CreateLead();
        controller.CopyReferralInfo();
        controller.currLead.Child_Age__c = '5';
       
    }
    public static testMethod void relationshipSelf1() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Self';
        controller.currLead.Referrer_FirstName__c = 'Testing';
        controller.currLead.Referrer_Last_Name__c = 'Testing';
        controller.currLead.Referrer_Phone__c= '8220708920';
        controller.currLead.Referrer_Email__c= 'mcavennila@gmail.com';
        controller.currLead.Referrer_City__c= 'karur';
        controller.currLead.Referrer_Zip__c= '35004';
        controller.currLead.is_Family_Aware_of_Referral__c= 'yes';
        controller.currLead.FirstName= 'Testing1';
        controller.currLead.Child_Middle_Initial__c= 'Testing2';
        controller.lastName= 'Testing2';
        controller.currLead.Gender__c= 'Male';
        controller.currLead.Child_Age__c= '16';
        controller.currLead.DOB__c=Date.valueOf('2000-09-11');
        controller.currLead.Parent_First_Name__c = 'Testing3';
        controller.currLead.Parent_Last_Name__c = 'Testing3';
        controller.currLead.Street = 'Karur';
        controller.currLead.City= 'Karur';
        controller.currLead.state= 'Arizona';
        controller.currLead.PostalCode= '35004';
        controller.currLead.Email= 'mcavennila@gmail.com';
        controller.currLead.Phone= '8220708920';
        controller.currLead.What_is_the_family_s_primary_spoken_lang__c= 'English';
        controller.diagnosisFilter= 'c00';
        controller.selectedDiagnosis= 'Malignant Neoplasm';
        controller.currLead.Hospital_Treatment_Facility_Treating__c= 'Malignant Neoplasm';
        controller.currLead.Treating_Medical_Professional_First_Name__c = 'Treaing 1';
        controller.currLead.Treating_Medical_Professional_Last_Name__c= 'Treaing 1';
        controller.currLead.Treating_Medical_Professional_Phone__c = '8220708921';
        controller.currLead.Treating_Medical_Professional_Email__c= 'mcavennila@gmail.com';
        controller.currLead.Any_medical_reason_for_moving_quickly__c= 'yes';
        controller.CreateLead();
        controller.CopyReferralInfo();
        
    }
    public static testMethod void relationshipSelf2() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        Contact con = WishReferralForm_AC_Test.createContact();
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Self';
        controller.currLead.Referrer_FirstName__c = 'Testing';
        controller.currLead.Referrer_Last_Name__c = 'Testing';
        controller.currLead.Referrer_Phone__c= '8220708920';
        controller.currLead.Referrer_Email__c= 'mcavennila@gmail.com';
        controller.currLead.Referrer_City__c= 'karur';
        controller.currLead.Referrer_Zip__c= '35004';
        controller.currLead.is_Family_Aware_of_Referral__c= 'yes';
        controller.currLead.FirstName= 'Testing1';
        controller.currLead.Child_Middle_Initial__c= 'Testing2';
        controller.lastName= 'Testing2';
        controller.currLead.Gender__c= 'Male';
        controller.currLead.Child_Age__c= '16';
        controller.currLead.DOB__c=Date.valueOf('2000-09-11');
        controller.currLead.Parent_First_Name__c = 'Testing3';
        controller.currLead.Parent_Last_Name__c = 'Testing3';
        controller.currLead.Street = 'Karur';
        controller.currLead.City= 'Karur';
        controller.currLead.state= 'Arizona';
        controller.currLead.PostalCode= '35004';
        controller.currLead.Email= 'mcavennila@gmail.com';
        controller.currLead.Phone= '8220708920';
        controller.currLead.What_is_the_family_s_primary_spoken_lang__c= 'English';
        controller.diagnosisFilter= 'c00';
        controller.selectedDiagnosis= 'Malignant Neoplasm';
        controller.currLead.Hospital_Treatment_Facility_Treating__c= 'Malignant Neoplasm';
        controller.currLead.Treating_Medical_Professional_First_Name__c = 'Treaing 1';
        controller.currLead.Treating_Medical_Professional_Last_Name__c= 'Treaing 1';
        controller.currLead.Treating_Medical_Professional_Phone__c = '8220708921';
        controller.currLead.Treating_Medical_Professional_Email__c= 'mcavennila@gmail.com';
        controller.currLead.Any_medical_reason_for_moving_quickly__c= 'yes';
        controller.CreateLead();
        controller.CopyReferralInfo();
        
    }
    public static testMethod void relationshipOther() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Other';
        controller.CreateLead();
        
    }
    public static testMethod void relationshipMedicalProfessional() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Medical professional';
        controller.CreateLead();
    }
    public static testMethod void MedicalFirstNameblank() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Medical professional';
        controller.currLead.LastName = 'Test'; 
        controller.CreateLead();
    }
    public static testMethod void relationshipFamily() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Parent/Guardian';
        controller.currLead.LastName = 'Test'; 
        controller.currLead.DOB__c = Date.Today()-1050;
        controller.currlead.Child_Age__c = '16';
        controller.CreateLead();
    }
     public static testMethod void relationshipSibling() 
    {
       
        PageReference pageRef = Page.WishReferralForm_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('isSuccess','Test');
        WishReferralForm_AC  controller = new WishReferralForm_AC();
        controller.currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        controller.currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        controller.currLead.Relationship_To_Child__c = 'Parent/Guardian';
        controller.currLead.LastName = 'Test'; 
        controller.currLead.DOB__c = Date.Today()-1050;
        controller.currlead.Of_Siblings__c = '2';
        controller.getSiblingList();
        controller.CreateLead();
        controller.getStates();
        controller.copyReferrerInfo  = True;
        controller.CopyReferralInfo();
        controller.getRelationships();
        controller.getNoOfSiblings();
        WishReferralForm_AC.searchDiagnosis('c00');
        WishReferralForm_AC.searchCondition('Mali');
        controller.disPlayChildForm();
    }
    public static testmethod void callmethods()
    {
        WishReferralForm_AC obj=new WishReferralForm_AC();
        obj.getNonMedicalReqFields();
        obj.getMedicalRequiredFields();
        obj.getSelfRequiredFields();
        obj.getRelationshipsToChild();
        obj.getHereAboutMAW();
    }
    
    static contact createContact()
    {
      Contact currCon = new Contact();
      currcon.FirstName = 'Testing1';
      currcon.lastName = 'Testing2';
      currCon.Birthdate = Date.valueOf('2000-09-11');
      currCon.Phone = '8220708920';
      currCon.Email = 'mcavennila@gmail.com';
      currCon.Diagnosis__c = 'Test';
      insert currCon;
      return currCon;
    }
   
}