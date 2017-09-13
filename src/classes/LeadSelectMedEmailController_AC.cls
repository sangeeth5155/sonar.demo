/**************************************************************************************
Author : MST Solutions
Description : This class referred in the LeadSelectMedEmail_VF.Intake form contains both treating medical professional and 
best contact for physicians Then the user must select who have received DV form. 

****************************************************************************************/
public class LeadSelectMedEmailController_AC{
    public boolean success {get;set;}
    public Lead currLead {get;set;}
    public string URLToRedirect {get;set;}
    
    public LeadSelectMedEmailController_AC(){
        currLead = [SELECT id,Best_Contact_for_Physician_Last_Name__c ,Best_Contact_for_Physician_First_Name__C,Best_contact_for_Physician_Email__c,
                    Treating_Medical_Professional_First_Name__c,Of_Times_Email_Sent__c,Treating_Medical_Professional_Last_Name__c,Treating_Medical_Professional_Email__c FROM Lead WHERE id =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
    }
    
    //Update the Lead medical professional type.
    public void updateLead(){       
        URLToRedirect = URL.getSalesforceBaseUrl().toExternalForm()+'/'+currLead.Id;
        currLead.Hidden_DV_form_Medical_professional_Type__c = Apexpages.currentPage().getParameters().get('type');
        //currLead.Hidden_Send_DV_Email__c = email;
        currLead.Sub_Status__c='Pending Diagnosis Verification'; 
        currLead.Dup_Check__c= 'Block Lead Dup'; 
        
        IF( currLead.Of_Times_Email_Sent__c == Null )
            currLead.Of_Times_Email_Sent__c =  0;
        
        currLead.Of_Times_Email_Sent__c= currLead.Of_Times_Email_Sent__c+1; 
        Update currLead;
        
        success = True;
    }
    
    //Go to the lead detail page.
    public pageReference GoToLeadViewPage(){
        pageReference page = new pageReference('/'+currLead.Id);
        return page;
    }
    
}