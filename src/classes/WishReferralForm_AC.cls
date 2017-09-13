/**********************************************************
Created by: Vennila Paramasivam
Author : MST Solution
Created Date : 04/08/2016
Description : It will capture the lead from Referral form.
***********************************************************/

global Class WishReferralForm_AC
{
    Public Lead currLead{get;set;}
    public string diagnosisFilter{get;set;}
    public String selectedDiagnosis{get; set;}
    public boolean displayChildFrm{get;set;}{displayChildFrm=false;}
    public String lastName{get;set;}
    public boolean displayAckMsg{get;set;}
    public List<siblingWrapper> currList;
    public String warningMsg{get;set;}
    public boolean displayWarningPopup{get;set;}
    public boolean copyReferrerInfo{get;set;}
    public boolean copyReferrerInfoToWish{get;set;}
    public string currState{get;set;}
    public string additionalParentState{get;set;}
    public static string icdOrPcd;
    public string refChildFormParent{get;set;}
    
    public WishReferralForm_AC()
    {
        currLead = new Lead();
        copyReferrerInfoToWish =false;
        copyReferrerInfo =false;
        icdOrPcd = '';
        
        if(ApexPages.currentPage().getParameters().get('isSuccess') != Null)
            displayAckMsg = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isSuccess'));
        
    }
    
    
    // Creating new Lead.
    Public PageReference CreateLead()
    {
        Constant_AC  constant = new Constant_Ac();    
        Id staffTaskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
        currLead.PCD_ICD__c = icdOrPcd;
        if(currLead.Relationship_to_child__c != Null)
            currLead.Relationship_to_child__c = currLead.Relationship_to_child__c.trim();
        currLead.Country = 'United States';
        /* currLead.ICD_10_Code__c = diagnosisFilter;
currLead.Primary_Diagnosis__c = selectedDiagnosis;*/
        List<ICD_Codes__c> icdCodeInfoList = [SELECT Id, Long_Description__c, Condition_Description__r.MAW_Name__c,Group1__c,
                                                     Condition_Description__c, Condition_Description__r.Code_to_Use__c
                                                     FROM ICD_Codes__c WHERE Name =: diagnosisFilter LIMIT 1];
        if(icdCodeInfoList.size() > 0) {
            currLead.PD_ICD_Code__c = icdCodeInfoList[0].Id;
        }
        currLead.PD_Condition_Description__c = selectedDiagnosis;
        
        currLead.Company = 'Make-A-Wish';
        currLead.LastName = lastName;
        String zipCode='';
        String label = '';
        Boolean flag = True;
        CurrLead.State = currState;
        currLead.LeadSource = 'Online';
        CurrLead.Additional_Parent_State__c = additionalParentState;
        
        System.debug('diagnosisFilter++++++++++++++++++++++ ' + diagnosisFilter); 
        System.debug('selectedDiagnosis++++++++++++++++++++++ ' + selectedDiagnosis);
        
        if(currLead.Has_this_child_ever_received_prior_wish__c != Null)
            currLead.Has_this_child_ever_received_prior_wish__c = currLead.Has_this_child_ever_received_prior_wish__c.trim();
        
        System.debug('currLead.Relationship_to_child__c+++++++++++++++++++++++++++++'+currLead.Relationship_to_child__c);
        if(currLead.Any_medical_reason_for_moving_quickly__c == 'Yes')
        {
            currLead.Any_medical_reason_for_moving_quickly__c = '<font color="Red">'+currLead.Any_medical_reason_for_moving_quickly__c +'</font>';
            
        }
        
        if(currLead.Has_this_child_ever_received_prior_wish__c == 'Yes')
        {
            currLead.Has_this_child_ever_received_prior_wish__c = '<font color="Red">'+currLead.Has_this_child_ever_received_prior_wish__c+'</font>';
        }
        if(currLead.Relationship_to_child__c == Null || currLead.Relationship_to_child__c == '')
        {
            flag = false;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Relationship To Child');
            ApexPages.addMessage(msg);
            return null;
        }
        
        
        
        
        
        /* if(currLead.Of_Siblings__c != Null && currLead.Of_Siblings__c != 'Unknown')
{    if(currLead.Relationship_To_Child__c == 'Parent/Guardian' || currLead.Relationship_To_Child__c == 'Self'){
if(currList.size() == integer.valueOf(currLead.Of_Siblings__c))
{
for(integer i=0;i<integer.valueOf(currLead.Of_Siblings__c);i++)
{
if(currList[i].lName == '' || currList[i].lName == Null || currList[i].age == Null || currList[i].age == '' || integer.valueOf(currList[i].age) >= 100 || integer.valueOf(currList[i].age) <= 0)
{
flag = false;
ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter siblings details. Last name and age are required.' );
ApexPages.addMessage(msg);
return null;
}

}

}
}
}*/
        
        
        if(flag == false)
        {
            if(label != '')
            {
                label = label.removeEnd(',');
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete following mandatory fields : ' +label );
                ApexPages.addMessage(msg);
                return null;
            }
        } 
        if(flag == True)
        {
            if(currLead.Postalcode!= Null && currLead.Postalcode !='')
                zipCode = currLead.Postalcode;
            else
                zipCode = currLead.Referrer_Zip__c;
            
            if(currLead.PD_ICD_Code__c != Null)
            {
                if(icdCodeInfoList.size() > 0)
                {
                    //currLead.Short_Description__c = icdCodeInfoList[0].Short_Description__c;
                    //currLead.Long_Description__c= icdCodeInfoList[0].Long_Description__c;
                    //currLead.Group_1__c= icdCodeRecList[0].Group1__c;
                    currLead.Childs_Qualifying_Diagnosis__c = icdCodeInfoList[0].Condition_Description__r.Code_to_Use__c;
                    
                }                           
            }
            
            if(currLead.PD_Condition_Description__c != Null)
            {
                List<Condition_Description__c> descriptionList = [SELECT Id, Maw_Name__c
                                                                  FROM Condition_Description__c WHERE Name = :currLead.PD_Condition_Description__c limit 1];
                
                if(descriptionList.size() > 0)
                {
                    currLead.MAW_Name__c = descriptionList[0].MAW_Name__c;
                }                           
            }
            
            if(currList!=Null)
            {
                for(siblingWrapper currVal : currList)
                {
                    
                    if(currLead.Sibling_Detail__c== Null)
                    {
                        currLead.Sibling_Detail__c='';
                    }
                    if(currVal.fName != Null && currVal.fName != '')
                    {
                        currLead.Sibling_Detail__c+= currVal.fName+' | ';
                    }
                    else
                    {
                        currLead.Sibling_Detail__c+= '-'+' | ';  
                    }
                    if(currVal.lName!= Null && currVal.lName != '')
                    {
                        currLead.Sibling_Detail__c+=currVal.lName+' | ';
                    }
                    else
                    {
                        currLead.Sibling_Detail__c+= '-'+' | ';  
                    }
                    if(currVal.age!= Null && currVal.age != '')
                    {
                        currLead.Sibling_Detail__c+=currVal.age+'<br>';
                    }
                    else
                    {
                        currLead.Sibling_Detail__c+= '-'+'<br>';  
                    }  
                }
            }  
            
            
            
            // Route to Chapter.
            List<Zip_Code__c> findChapterviaZipCode = new List<Zip_Code__c>();
            if(zipCode != '')
                findChapterViaZipCode = [SELECT id, Office__c, Office__r.Chapter__c,Office__r.Chapter__r.Intake_Manager__c 
                                         FROM Zip_Code__c WHERE Name = :zipCode limit 1]; 
            
            
            if(findChapterviaZipCode.size()>0)
            {
                if(findChapterviaZipCode[0].Office__c != Null)
                    currLead.chapterName__c = findChapterviaZipCode[0].Office__r.Chapter__c;
                if(findChapterviaZipCode[0].Office__r.chapter__c != Null)
                {
                    if(findChapterviaZipCode[0].Office__r.chapter__r.Intake_Manager__c != Null)
                        currLead.OwnerId =  findChapterviaZipCode[0].Office__r.chapter__r.Intake_Manager__c;
                }
            }
            else
            {
                List<Account> currAccount = [SELECT id,Intake_Manager__c FROM Account Where Name = 'Make-A-Wish America' limit 1];
                if(currAccount.size() > 0)
                {
                    currLead.chapterName__c = currAccount[0].id;
                    if(currAccount[0].Intake_Manager__c != Null)
                        currLead.OwnerId = currAccount[0].Intake_Manager__c;
                }
                
            }
            try
            {
                
                List<Contact> contactDupCheck = [SELECT id,OwnerId, AccountId FROM CONTACT WHERE LastName = :currLead.LastName AND 
                                                 FirstName = :currLead.FirstName AND Birthdate = :currLead.DOB__c AND
                                                 ((Phone = :currLead.Phone OR Email = :currLead.Email OR 
                                                   (MailingCity = :currLead.City AND MailingState = :currLead.State 
                                                    AND MailingPostalCode = :currLead.PostalCode))) limit 1];
                
                List<Lead> leadDupCheck = [SELECT id, OwnerId, ChapterName__c, Status FROM Lead WHERE (LastName = :currLead.LastName AND 
                                                                                                       FirstName = :currLead.FirstName AND DOB__c = :currLead.DOB__c) AND
                                           ((Phone = :currLead.Phone OR Email = :currLead.Email OR 
                                             (City = :currLead.City AND State = :currLead.State 
                                              AND PostalCode = :currLead.PostalCode)))
                                           AND isConverted=false limit 1];
                boolean redirection;                                
                if(contactDupCheck.size() > 0 && leadDupCheck.size() > 0)
                {
                    Lead updateLead = new Lead();
                    updateLead.id = leadDupCheck[0].id;
                    updateLead.status = 'Duplicate';
                    update updateLead;
                    
                    Task newTask = WishReferralForm_AC.createTask(contactDupCheck[0].id,contactDupCheck[0].ownerId,contactDupCheck[0].accountId, 'Duplicate Inquiry/Referral Submitted',staffTaskRT);
                    if(newTask.id != Null)
                        redirection = true;
                }
                else if(contactDupCheck.size() > 0)
                {
                    Task newTask = WishReferralForm_AC.createTask(contactDupCheck[0].id,contactDupCheck[0].ownerId,contactDupCheck[0].accountId, 'Duplicate Inquiry/Referral Submitted',staffTaskRT);
                    if(newTask.id != Null)
                        redirection = true;
                }
                else if(leadDupCheck.size() > 0)
                {
                    if(leadDupCheck[0].Status == 'Referred') {
                        Task newTask = WishReferralForm_AC.createTask(leadDupCheck[0].id,leadDupCheck[0].ownerId,leadDupCheck[0].ChapterName__c, 'Duplicate Referral Submitted',staffTaskRT);
                        if(newTask.id != Null)
                            redirection = true;
                    } else if(leadDupCheck[0].Status == 'Inquiry') {
                        Task newTask = WishReferralForm_AC.createTask(leadDupCheck[0].id,leadDupCheck[0].ownerId,leadDupCheck[0].ChapterName__c, 'Duplicate Inquiry Submitted',staffTaskRT);
                        if(newTask.id != Null)
                            redirection = true;
                    }
                    
                    
                }
                else
                {
                    
                    if(currLead.Relationship_To_child__c == 'Other')
                    {
                        currLead.Status = 'Inquiry';
                        currLead.RFI_Form_Info_Hidden__c = 'Inquiry';
                    }
                    else
                    {
                        currLead.Status = 'Referred';
                        currLead.RFI_Form_Info_Hidden__c = 'Referred';
                        
                        System.debug('currLead.RFI_Form_Info_Hidden__c ++++++++++++++++++++++ ' + currLead.RFI_Form_Info_Hidden__c);
                    }
                    
                    if(currLead.Relationship_To_Child__c == 'Medical Professional' && 
                       (currLead.Medical_Provider_Category__c  == 'Nurse Practitioner' || currLead.Medical_Provider_Category__c == 'Physician Assistant' || currLead.Medical_Provider_Category__c == 'Physician'))
                    {
                        currLead.Medical_Professional_First_Name__c = currLead.Referrer_FirstName__c;
                        currLead.Medical_Professional_Last_Name__c = currLead.Referrer_Last_Name__c;
                        currLead.Medical_Professional_Phone__c = currLead.Referrer_Phone__c;
                        currLead.Medical_Professional_Email__c = currLead.Referrer_Email__c;
                        currLead.Hospital_Treatment_Facility__c = currLead.Hospital_Treatment_Facility_Treating__c;
                        
                    }
                    
                    insert currLead;
                    if(currLead.id != Null)
                        redirection = true;
                }
                if(redirection == true)
                {
                    PageReference reference=new PageReference('/apex/WishReferralForm_VF?isSuccess=True&chid='+refChildFormParent + '&rel=' + currLead.Relationship_to_child__c);
                    reference.setRedirect(true);
                    return reference;
                }
            }
            Catch(DMLException e)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getmessage());
                ApexPages.addMessage(msg);
                return null;
            }
        }
        return null;
        
    }
    
    // Auto Complete the ICD Code values.
    @RemoteAction
    global static List<ICD_Codes__c> searchDiagnosis(String searchTerm) {
        icdOrPcd = 'ICD';
        List<ICD_Codes__c> icdCodes = Database.query('Select Id, Name,Condition_Description__c, Condition_Description__r.Name from ICD_Codes__c where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' AND Hidden_ICD_Code__c = false');
        return icdCodes;
    } 
    
    // Auto Complete the Dianosis field value.
    @RemoteAction
    global static List<Condition_Description__c> searchCondition(String searchTerm) {
        icdOrPcd = 'PCD';
        List<Condition_Description__c> conditionDescriptions = Database.query('Select Id, Name, Code_To_Use__c from Condition_Description__c where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        if(!(conditionDescriptions.size() > 0))
        {
            conditionDescriptions =[Select Id, Name, Code_To_Use__c from Condition_Description__c WHERE Not_Listed__c = True];
        }
        return conditionDescriptions;
    } 
    
    // Fetch the relationship picklist values from Relationship_To_child field and displaying as a Radio Button.
    public List<SelectOption> getRelationships(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.Relationship_To_Child__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues)
        {      options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
         
        }  
        return options;
    }   
    
    // Based on the Family Aware of Referral field, Child form would render.
    public void disPlayChildForm()
    {
        
        if(currLead.Relationship_To_Child__c != 'Medical Professional')
        {
            currLead.Medical_Provider_Category__c = '';
            copyReferrerInfo = false;
        }
        
        if(currLead.Relationship_To_Child__c == 'Self' && currLead.is_Family_Aware_of_Referral__c=='Yes')
        {
            currLead.FirstName = currLead.Referrer_FirstName__c;
            lastName = currLead.Referrer_Last_Name__c;
            
        }
        
        if(currLead.Relationship_To_Child__c == 'Parent/Guardian' && currLead.is_Family_Aware_of_Referral__c=='Yes')
        { 
            currLead.Parent_First_Name__c = currLead.Referrer_FirstName__c;
            currLead.Parent_Last_Name__c = currLead.Referrer_Last_Name__c;
            currLead.City = currLead.Referrer_City__c;
            currLead.PostalCode =  currLead.Referrer_Zip__c;
            currLead.Email = currLead.Referrer_Email__c;
            currLead.Phone = currLead.Referrer_Phone__c;
            
        }
        if(currLead.Medical_Provider_Category__c != 'Nurse Practitioner' &&  currLead.Medical_Provider_Category__c != 'Physician' && currLead.Medical_Provider_Category__c != 'Physician Assistant')
        {
            copyReferrerInfo=false;
        }
        
        if(currLead.of_Siblings__c != Null && currLead.of_Siblings__c != '0' && currLead.Of_Siblings__c != 'Unknown')
        {
            
            getSiblingList();
        }
        
        
        
    }
    
    
    // Referrer and Medical Provider is same, then Referrer details would display on Medical Provider section also.
    public void CopyReferralInfo()
    {
        if(currLead.Relationship_To_Child__c != 'Self' && copyReferrerInfo == True)
        {
            currLead.Treating_Medical_Professional_First_Name__c= currLead.Referrer_FirstName__c;
            currLead.Treating_Medical_Professional_Last_Name__c= currLead.Referrer_Last_Name__c;
            currLead.Treating_Medical_Professional_Phone__c= currLead.Referrer_Phone__c;
            currLead.Treating_Medical_Professional_Email__c= currLead.Referrer_Email__c;
            currLead.Medical_Professional_First_Name__c = currLead.Referrer_FirstName__c;
            currLead.Medical_Professional_Last_Name__c = currLead.Referrer_Last_Name__c;
            currLead.Medical_Professional_Phone__c = currLead.Referrer_Phone__c;
            currLead.Medical_Professional_Email__c = currLead.Referrer_Email__c;
        }
        else
        {
            currLead.Treating_Medical_Professional_First_Name__c='';
            currLead.Treating_Medical_Professional_Last_Name__c= '';
            currLead.Treating_Medical_Professional_Phone__c= '';
            currLead.Treating_Medical_Professional_Email__c= '';
            currLead.Medical_Professional_First_Name__c = '';
            currLead.Medical_Professional_Last_Name__c = '';
            currLead.Medical_Professional_Phone__c = '';
            currLead.Medical_Professional_Email__c = '';
        }
        
        
        
    } 
    
    // Based on the number of siblings field, data entry data table would display.
    Public List<siblingWrapper> getSiblingList()
    {
        currList = new List<siblingWrapper>();
        System.debug('currLead.of_Siblings__c++++++++++++++++++++++++++++ ' +currLead.of_Siblings__c);
        if(currLead.of_Siblings__c != Null && currLead.Of_Siblings__c != 'Unknown')
        {
            for(integer i=0;i<integer.valueOf(currLead.of_Siblings__c);i++)
            {
                currList.add(new siblingWrapper());
            }
        }
        return currList;
    }
    
    //Capturing State Picklist values.   
    public List<SelectOption> getStates() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.State_Picklist__c.getDescribe();
        options.add(new SelectOption('', 'Select an option')); 
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues){
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }  
        return options;
    }  
    
     //Capturing Parent Relationship to child Picklist values.   
    public List<SelectOption> getRelationshipsToChild() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.Parent_Relationship_to_Child__c.getDescribe();
        options.add(new SelectOption('', 'Select an option')); 
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues){
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }  
        return options;
    }  
    
     //Capturing Parent Relationship to child Picklist values.   
    public List<SelectOption> getHereAboutMAW() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.How_Did_you_hear_about_Make_A_Wish__c.getDescribe();
        options.add(new SelectOption('', 'Select an option')); 
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues){
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }  
        return options;
    }  
    
    //Capturing State Picklist values.   
    public List<SelectOption> getNoOfSiblings() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Lead.of_Siblings__c.getDescribe();
        options.add(new SelectOption('', 'Please Select')); 
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry currVal : picklistValues){
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
            
        }  
        return options;
    } 
    
    // Self Fieldset, it holds the mandatory fields of Self relationship.
    public List<Schema.FieldSetMember> getSelfRequiredFields() {
        return SObjectType.Lead.FieldSets.Self_Required_Fields.getFields();
    }
    // Medical Referral Field set contains the mandatory fields of Medical Professional.
    public List<Schema.FieldSetMember> getNonMedicalReqFields() {
        return SObjectType.Lead.FieldSets.Non_Medical_Referral_Required_Fields.getFields();
    }
    // Non Medical Referral field set contains the mandatory fields of Non Medical Professional.
    public List<Schema.FieldSetMember> getMedicalRequiredFields() {
        return SObjectType.Lead.FieldSets.Medical_Referral_Required_Form.getFields();
    }
    
    
    // Creating Task 
    
    private static Task createTask(Id whoId,Id ownerId,Id whatId, String subject, Id recordTypeId)
    {  
        Constant_AC constant = new Constant_AC();
        Id taskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get(constant.taskRT).getRecordTypeId();
        Task newTask = new Task();
        newTask.Subject = subject;
        newTask.RecordTypeId = recordTypeId;
        newTask.OwnerId = UserInfo.getUserId();
        newTask.whoId = whoId;
        newTask.Status = 'Not Started';
        newTask.activityDate = Date.Today() + 10;
        if(ownerId != Null)
            newTask.OwnerId = ownerId;
        
        //newTask.whatId = whatId;
        newTask.RecordTypeId = taskRT;
        insert newTask;
        System.debug('newTask.id +++++++++++++++++++++++++++++++ ' + newTask.id);
        return newTask;
        
    }
    
    
    
    
    // Wrapper for capturing n number of sibling details.   
    public class siblingWrapper
    {
        public string fName{get;set;}
        public string lName{get;set;}
        public string age{get;set;}
        
    }
    
    
    
}