/**********************************************************
Created by: Vennila Paramasivam & Kesavakumar Murugesan
Author : MST Solution
Created Date : 04/08/2016
Description : It will capture the lead from Referral form.
***********************************************************/

Public Class WishReferralFormOut_AC {
    Public Lead currLead{get;set;}
    Public boolean login{get;set;}
    Public String password{get;set;}
    Public String renderpdf{get;set;}
    Public String fileName{get;set;}
    Public String csv{get;set;}
    public Id accontId;
    public List<Lead> leaddata;
    public List<SiblingInfo> sibList {get;set;}
    
    public WishReferralFormOut_AC() {
        sibList = new List<SiblingInfo>();
        renderpdf='';
        ID leadId = ApexPages.currentPage().getParameters().get('LeadId');
        currLead = new Lead();
        leaddata=[Select Id,Name,Relationship_to_child__c,CreatedDate,Treating_Medical_Professional_Phone__c,PD_Condition_Description__c,Medical_Provider_Category__c,of_Siblings__c,
                  Other_Medical_Provider_Category__c,Sibling_Detail__c, Any_medical_reason_for_moving_quickly__c ,What_is_the_family_s_primary_spoken_lang__c, Referrer_FirstName__c,
                  Street, Email, Has_this_child_ever_received_prior_wish__c, Referrer_City__c, Referrer_Zip__c, Referrer_Last_Name__c,Title, Hospital_Treatment_Facility_Treating__c,
                  Referrer_Phone__c, Referrer_Email__c,FirstName, City, State, Country, Child_Middle_Initial__c, LastName, DOB__c, PostalCode, Gender__c, Parent_First_Name__c,
                  Parent_Last_Name__c, Phone, Childs_Qualifying_Diagnosis__c,PD_ICD_Code__c, Treating_Medical_Professional_First_Name__c, Treating_Medical_Professional_Last_Name__c,
                  Medical_Professional_Phone__c, Treating_Medical_Professional_Fax__c, Treating_Medical_Professional_Email__c, ChapterName__r.Id,is_Family_Aware_of_Referral__c,
                  Medical_Professional_First_Name__c,Medical_Professional_Last_Name__c,Medical_Professional_Email__c,Additional_Parent_Relationship_to_Child__c,Additional_Parent_First_Name__c,
                  Additional_Parent_Last_Name__c,Additional_Parent_Street__c,Additional_Parent_City__c,Additional_Parent_State__c,Additional_Parent_Postal_Code__c,Additional_Parent_Phone__c,
                  Additional_Parent_Email__c,Additional_Parent_Primary__c,Parent_Relationship_to_Child__c,Best_Contact_for_Physician_First_Name__c,Best_Contact_for_Physician_Last_Name__c,Best_contact_for_Physician_Email__c
                  from Lead where Id =: leadId];
        if(leaddata[0].Any_medical_reason_for_moving_quickly__c != null) {
            leaddata[0].Any_medical_reason_for_moving_quickly__c = leaddata[0].Any_medical_reason_for_moving_quickly__c.replaceAll('<[^>]+>',' ');
        }
        if(leaddata[0].Has_this_child_ever_received_prior_wish__c != null) {
            leaddata[0].Has_this_child_ever_received_prior_wish__c = leaddata[0].Has_this_child_ever_received_prior_wish__c.replaceAll('<[^>]+>',' ');
        }
        
        
        if(leaddata[0].Sibling_Detail__c != null) {
            String replaceString = '';
            Integer splitCount = 0;
            for(String sibDet : leaddata[0].Sibling_Detail__c.split('<br>')) {
                List<String>  newSibDet = new List<String>();
                splitCount = sibDet.countMatches('|');
                sibDet = sibDet.replace('|', ',');
                SiblingInfo newSeb = new SiblingInfo();
                newSibDet = sibDet.split(',');
                if(newSibDet.size() > 0) {
                    for(Integer i=0 ; i<newSibDet.size();i++) {
                        if(i==0) {
                            newSeb.firstName = sibDet.split(',')[0];
                        } 
                        
                        if(i==1) {
                            newSeb.lastName = sibDet.split(',')[1];
                        }
                        
                        if(i==2) {
                            newSeb.age = sibDet.split(',')[2];
                        }
                    }
                }
                
                
                sibList.add(newSeb);
                splitCount = 0;
            }
            
        }
        accontId= leaddata[0].ChapterName__r.Id;                           
        currLead = leaddata[0];
        
    }
    
    //Used to validate password for the form
    public pagereference submit(){
        //Used to get chapter password for referral form
        List<Account> accdata=[Select Id,Referral_Form_Password__c from Account where Id =: accontId];
        if(password == accdata[0].Referral_Form_Password__c){
            login = true;
        } else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invalid password. '));
        }
        return null;
    }
    
    //Used to export the current page as pdf
    public void exportPDF() {
        //assign render as value to the page
        renderpdf = 'pdf';
        
        //setup a default file name (Lead Name + Lead Created Date)
        string fileName = leaddata[0].Name+'_'+leaddata[0].CreatedDate+'.pdf';
        
        //We have to set the content disposition as attachment.
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename='+fileName);
    }
    
    //Used to export the current page as CSV
    public void exportCSV() {
        /* csv = 'Name,Relationship_to_child__c,CreatedDate,Treating_Medical_Professional_Phone__c,PD_Condition_Description__c,Medical_Provider_Category__c,of_Siblings__c,Other_Medical_Provider_Category__c';
        csv += ',Sibling_Detail__c,Any_medical_reason_for_moving_quickly__c,What_is_the_family_s_primary_spoken_lang__c,Referrer_FirstName__c,Street,Email,Has_this_child_ever_received_prior_wish__c';
        csv += ',Referrer_City__c,Referrer_Zip__c,Referrer_Last_Name__c,Title,Hospital_Treatment_Facility_Treating__c,Referrer_Phone__c,Referrer_Email__c,FirstName,City,State,Country,Child_Middle_Initial__c';
        csv += ',LastName, DOB__c,PostalCode, Gender__c,Parent_First_Name__c,Parent_Last_Name__c,Phone,Childs_Qualifying_Diagnosis__c,PD_ICD_Code__c,Treating_Medical_Professional_First_Name__c';
        csv += ',Treating_Medical_Professional_Last_Name__c,Medical_Professional_Phone__c,Treating_Medical_Professional_Fax__c,Treating_Medical_Professional_Email__c\n';
        
        csv += currLead.Name+','+currLead.Relationship_to_child__c+','+currLead.CreatedDate+','+currLead.Treating_Medical_Professional_Phone__c+','+currLead.PD_Condition_Description__c;
        csv += ','+currLead.Medical_Provider_Category__c+','+currLead.of_Siblings__c+','+currLead.Other_Medical_Provider_Category__c+','+currLead.Sibling_Detail__c;
        csv += ','+currLead.Any_medical_reason_for_moving_quickly__c+','+currLead.What_is_the_family_s_primary_spoken_lang__c+','+currLead.Referrer_FirstName__c+','+currLead.Street+','+currLead.Email;
        csv += ','+currLead.Has_this_child_ever_received_prior_wish__c+','+currLead.Referrer_City__c+','+currLead.Referrer_Zip__c+','+currLead.Referrer_Last_Name__c+','+currLead.Title;
        csv += ','+currLead.Hospital_Treatment_Facility_Treating__c+','+currLead.Referrer_Phone__c+','+currLead.Referrer_Email__c+','+currLead.FirstName+','+currLead.City+','+currLead.State;
        csv += ','+currLead.Country+','+currLead.Child_Middle_Initial__c+','+currLead.LastName+','+currLead.DOB__c+','+currLead.PostalCode+','+currLead.Gender__c+','+currLead.Parent_First_Name__c;
        csv += ','+currLead.Parent_Last_Name__c+','+currLead.Phone+','+currLead.Childs_Qualifying_Diagnosis__c+','+currLead.PD_ICD_Code__c+','+currLead.Treating_Medical_Professional_First_Name__c;
        csv += ','+currLead.Treating_Medical_Professional_Last_Name__c+','+currLead.Medical_Professional_Phone__c+','+currLead.Treating_Medical_Professional_Fax__c;
        csv += ','+currLead.Treating_Medical_Professional_Email__c+'\n'; 
        
        csv = 'Child Name,Gender,DOB,Relationship to Child,Medical Provider Category,Referrer Name, Date Submitted,Phone,Email,City,Postal,Family Name,Address,City,State,Postal Code,Email,Primary Number,Primary Spoken Language,No. of Sibilings,Primary Diagnosis,ICD Code,Medical Reason, Physician Name, Email, Phone, Hospital or Treatment Facility\n';
        csv += currLead.FirstName+' '+ currLead.Child_Middle_Initial__c+' '+currLead.LastName+','+currLead.Gender__c+','+currLead.DOB__c+','+currLead.Relationship_to_child__c;
        csv += ',' + currLead.Medical_Provider_Category__c+','+currLead.Referrer_FirstName__c+' '+currLead.Referrer_Last_Name__c+','+currLead.CreatedDate;
        csv += ',' + currLead.Referrer_Phone__c+','+currLead.Referrer_Email__c+','+currLead.Referrer_City__c+','+currLead.Referrer_Zip__c;
        csv += ',' + currLead.Parent_First_Name__c+' '+currLead.Parent_Last_Name__c+','+currLead.Street+','+currLead.City+','+currLead.State+','+currLead.PostalCode+','+currLead.Email;
        csv += ',' + currLead.Phone+','+currLead.What_is_the_family_s_primary_spoken_lang__c+','+currLead.of_Siblings__c+','+currLead.PD_Condition_Description__c+','+currLead.PD_ICD_Code__c;
        csv += ',' + currLead.Any_medical_reason_for_moving_quickly__c+','+currLead.Treating_Medical_Professional_First_Name__c+' '+currLead.Treating_Medical_Professional_Last_Name__c;
        csv += ',' + currLead.Treating_Medical_Professional_Email__c+','+currLead.Treating_Medical_Professional_Phone__c+','+currLead.Hospital_Treatment_Facility_Treating__c; */
        
        
        csv='Date Submitted,Is Family Aware,Relationship to Child,Referrer name,Referrer Phone,Referrer Email,Referrer City,Referrer Zip,Primary Diagnosis,ICD Code,Rush,Medical Provider Name';
        csv += ',Medical Provider Email,Medical Provider Phone,Medical Provider Category,Hospital or Treatment Facility,Child Name,Child Gender,Child DOB,Previous Wish';
        csv += ',Parent/Guardian Name,Address,City,State,Zip,Email,Phone,Primary Language,Relation Ship to Child,Best Physician Name,Best Physician Email,Number of Siblings';
        //,Sibling Name 1,Sibling Age 1,Sibling Name 2,Sibling Age 2,Sibling Name 3,Sibling Age 3,Sibling Name 4,Sibling Age 4,Sibling Name 5,Sibling Age 5,Sibling Name 6,Sibling Age 6,Sibling Name 7,Sibling Age 7,Sibling Name 8,Sibling Age 8,Sibling Name 9,Sibling Age 9,Sibling Name 10,Sibling Age 10';
        String strSiblings='';
        String strSiblingsInfo='';
        for( Integer i=0; i < sibList.size(); i++){
            strSiblings += ',Sibling Name '+ i+1 + ',Sibling Age ' + i+1 ;
            strSiblingsInfo += ',' +  sibList[i].firstName + ' ' + sibList[i].lastName + ',' + sibList[i].age;
        
        }
        if(strSiblings !=''){
            csv += strSiblings;
        }
        if(currLead.Additional_Parent_First_Name__c!=null){
            csv += ',Parent/Guardian 2 Name,Address,City,State,Zip,Email,Phone,Relation Ship to Child\n';
        }
        else{
            csv += '\n';
        }
        csv += currLead.CreatedDate+','+currLead.is_Family_Aware_of_Referral__c +','+currLead.Relationship_to_child__c+','+currLead.Referrer_FirstName__c+' '+currLead.Referrer_Last_Name__c;
        csv += ','+currLead.Referrer_Phone__c+','+currLead.Referrer_Email__c+','+currLead.Referrer_City__c+','+currLead.Referrer_Zip__c;
        //csv += ','+currLead.PD_Condition_Description__c+','+currLead.PD_ICD_Code__c +',' + currLead.Any_medical_reason_for_moving_quickly__c+',' + currLead.Medical_Professional_First_Name__c+' '+currLead.Medical_Professional_Last_Name__c;
        //csv += ','+currLead.Medical_Professional_Email__c+','+currLead.Medical_Professional_Phone__c+','+currLead.Medical_Provider_Category__c+','+currLead.Hospital_Treatment_Facility_Treating__c;
        csv += ','+currLead.PD_Condition_Description__c +','+currLead.PD_ICD_Code__c+',' + currLead.Any_medical_reason_for_moving_quickly__c+',' + currLead.Treating_Medical_Professional_First_Name__c+' '+currLead.Treating_Medical_Professional_Last_Name__c;
        csv += ','+currLead.Treating_Medical_Professional_Email__c+','+currLead.Treating_Medical_Professional_Phone__c+','+currLead.Medical_Provider_Category__c+','+currLead.Hospital_Treatment_Facility_Treating__c;
        csv += ','+currLead.FirstName+' '+ currLead.Child_Middle_Initial__c+' '+currLead.LastName+','+currLead.Gender__c+','+currLead.DOB__c+','+ currLead.Has_this_child_ever_received_prior_wish__c;
        csv += ','+currLead.Parent_First_Name__c+' '+currLead.Parent_Last_Name__c+','+currLead.Street+','+currLead.City+','+currLead.State+','+currLead.PostalCode+','+currLead.Email;
        csv += ','+currLead.Phone+','+currLead.What_is_the_family_s_primary_spoken_lang__c+','+currLead.Parent_Relationship_to_Child__c+','+currLead.Best_Contact_for_Physician_First_Name__c+' '+currLead.Best_Contact_for_Physician_Last_Name__c+','+currLead.Best_contact_for_Physician_Email__c+','+currLead.of_Siblings__c;
        if(strSiblingsInfo !=''){
            csv += strSiblingsInfo;
        }
        
        if(currLead.Additional_Parent_First_Name__c!=null){
            csv += ',' + currLead.Additional_Parent_First_Name__c+' '+currLead.Additional_Parent_Last_Name__c+','+currLead.Additional_Parent_Street__c+','+currLead.Additional_Parent_City__c;
            csv += ',' + currLead.Additional_Parent_State__c+','+currLead.Additional_Parent_Postal_Code__c+','+currLead.Additional_Parent_Email__c+','+currLead.Additional_Parent_Phone__c+','+currLead.Additional_Parent_Relationship_to_Child__c + '\n';
        }
        else{
            csv += '\n';
        }
        
          
        ContentVersion file = new ContentVersion(
          title = 'WishReferral.csv',
          versionData = Blob.valueOf( csv ),
          pathOnClient = '/WishReferral.csv'
        );
         
        //insert file;
        //System.debug( file );

        //setup a default file name (Lead Name + Lead Created Date)
        fileName = currLead.Name+'_'+currLead.CreatedDate+'.csv';
        
        //We have to set the content disposition as attachment. contentType="application/msword#BorrowerPNA.doc" applyBodyTag="false" application/octet-stream#{!fileName}.csv
        //Apexpages.currentPage().getHeaders().put('contentType', 'text/csv#' + fileName );
    }
    
    // Wrapper class for sibling info
    public class SiblingInfo {
        public String firstName {get;set;}
        public String lastName{get;set;}
        public String age{get;set;}
    }
}