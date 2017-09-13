@isTest
public class WishReferralFormOut_AC_Test {
    
    @TestSetup static void crateLead()
    {
        Lead currLead = new Lead();
        currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        currLead.Has_this_child_ever_received_prior_wish__c = 'Yes';
        currLead.Any_medical_reason_for_moving_quickly__c  = 'Yes';
        currLead.Relationship_To_Child__c = 'Self';
        currLead.Referrer_FirstName__c = 'Testing';
        currLead.Referrer_Last_Name__c = 'Testing';
        currLead.Referrer_Phone__c= '8220708920';
        currLead.Referrer_Email__c= 'mcavennila@gmail.com';
        currLead.Referrer_City__c= 'karur';
        currLead.Referrer_Zip__c= '35004';
        currLead.Sibling_Detail__c = 'Sam | Jaba | 1 ';
        currLead.is_Family_Aware_of_Referral__c= 'yes';
        currLead.FirstName= 'Testing1';
        currLead.Child_Middle_Initial__c= 'Testing2';
        currLead.Gender__c= 'Male';
        currLead.Child_Age__c= '16';
        currLead.PD_Condition_Description__c = 'Liver Transplant';
        currLead.DOB__c=Date.valueOf('2000-09-11');
        currLead.Parent_First_Name__c = 'Testing3';
        currLead.Parent_Last_Name__c = 'Testing3';
        currLead.Street = 'Karur';
        currLead.City= 'Karur';
        currLead.state= 'Arizona';
        currLead.PostalCode= '35004';
        currLead.Email= 'mcavennila@gmail.com';
        currLead.Phone= '8220708920';
        currLead.LastName= 'Test Last';
        currLead.Company= 'MST';
        currLead.unique_wish_identifier__c = '12332222';
        currLead.What_is_the_family_s_primary_spoken_lang__c= 'English';
        currLead.Hospital_Treatment_Facility_Treating__c= 'Malignant Neoplasm';
        currLead.Treating_Medical_Professional_First_Name__c = 'Treaing 1';
        currLead.Treating_Medical_Professional_Last_Name__c= 'Treaing 1';
        currLead.Treating_Medical_Professional_Phone__c = '8220708921';
        currLead.Treating_Medical_Professional_Email__c= 'mcavennila@gmail.com';
        currLead.Any_medical_reason_for_moving_quickly__c= 'yes';
        Insert currLead;
        
    }
    
    public static testMethod void TestWishReferralFormOut() 
    {
        Lead currLead = [SELECT id from Lead];
        PageReference pageRef = Page.WishReferralFormOut_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('LeadId',currLead.Id);
        WishReferralFormOut_AC wishreferral = new WishReferralFormOut_AC();
    }
    
   
    
    public static testMethod void TestexportPDF() 
    {
        Lead currLead = [SELECT id from Lead];
        PageReference pageRef = Page.WishReferralFormOut_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('LeadId',currLead.Id);
        WishReferralFormOut_AC wishreferral = new WishReferralFormOut_AC();
        ApexPages.currentPage().getParameters().put('p','df');
        wishreferral.exportPDF();
    }
    
    public static testMethod void Testsubmit() 
    {
        Lead currLead = [SELECT id from Lead];
        PageReference pageRef = Page.WishReferralFormOut_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('LeadId',currLead.Id);
        WishReferralFormOut_AC wishreferral = new WishReferralFormOut_AC();
        wishreferral.login = true;
        ApexPages.currentPage().getParameters().put('p','df');
        
        Account acc=new Account();
        acc.Name='test Account';
        acc.Referral_Form_Password__c='12345';
        insert acc;
        wishreferral.accontId = acc.Id;
        wishreferral.password='12345';
        wishreferral.submit();
    }
    
    
    public static testMethod void NonMatchPassword() 
    {
        Lead currLead = [SELECT id from Lead];
        PageReference pageRef = Page.WishReferralFormOut_VF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('LeadId',currLead.Id);
        WishReferralFormOut_AC wishreferral = new WishReferralFormOut_AC();
        wishreferral.login = true;
        ApexPages.currentPage().getParameters().put('p','df');
        
        Account acc=new Account();
        acc.Name='test Account';
        acc.Referral_Form_Password__c='123455';
        insert acc;
        wishreferral.accontId = acc.Id;
        wishreferral.password='12345';
        wishreferral.submit();
        wishreferral.exportCSV();
    }
}