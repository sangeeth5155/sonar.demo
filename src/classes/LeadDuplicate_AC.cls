/**************************************************************************************
Author : MST Solutions
Description : This class referred in the LeadDuplicate_VF. If the users tries to created a duplicate or potentially 
duplicate lead manually in Salesforce, system should not allow them to create/update a lead. It should display 
error message along with duplicate page link. If the user clicks that link, it would redirect the user to 
duplicate page and will display all the duplicate records related with current record. 
Here, User can merge the records.
****************************************************************************************/

Public Class LeadDuplicate_AC
{
   public string currId{get;set;}
   public Lead currLead{get;set;}
   public Integer selectedRecordsCount {get; private set;} {this.selectedRecordsCount = 0;}
   public List<FieldRow> fieldRows {get; private set;}
   private static final String MASTER_KEY = '$MASTER$';
   public List<leadWrapper> wrapperList = new List<leadWrapper>();
   private Map<String, Lead> selectedRecords;
   public Integer step {get; private set;}
   public boolean isFamilyInfo{get;set;}
   public string contactId{get;set;}
   public string bestToConId{get;set;}
   public string treatingContactId{get;set;}
   public string medicalConId{get;set;}
   public boolean displayPartASuccess{get;set;}
   public boolean noDuplicate{Get;set;}
   public string masterLeadId;
   public boolean displayLeadDupPopup{get;set;}
   public string additionalParentId{get;set;}
   
   Id wishFamilyRT;
   Id medicalProfessionalRT;
   Id wishChild;
   public boolean hideTreatingSection{get;set;}
   
   
   public List<Lead> masterLeadList {get;set;}
   
   // Standard set controller for displaying matching duplicates.
   public LeadDuplicate_AC(ApexPages.StandardSetController controller)
   {
       selectedRecords = new Map<String, Lead>();
       fieldRows = new List<FieldRow>();
       step = 2;
       isFamilyInfo = false;
       noDuplicate = false;
       displayLeadDupPopup = false;
       hideTreatingSection = false; 
        Constant_AC  constant = new Constant_Ac(); 
        wishFamilyRT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        medicalProfessionalRT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        wishChild = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        
       if(ApexPages.currentPage().getParameters().get('wishFamily') != Null)
          isFamilyInfo = Boolean.valueOf(ApexPages.currentPage().getParameters().get('wishFamily'));
       
       if(ApexPages.currentPage().getParameters().get('Id') != Null)
                currId= ApexPages.currentPage().getParameters().get('Id');
                
       if(currId != Null)
       {
        // Querying current lead info.
         currLead = [SELECT Id, FirstName,Name,Of_Times_Email_Sent__c,LastName,Parent_Last_Name__c,Parent_First_Name__c, 
                     Email, DOB__c ,Phone,chapterName__c,chapterName__r.Name, Best_Contact_for_Physician_First_Name__c,
                      Best_Contact_for_Physician_Last_Name__c, Best_contact_for_Physician_Email__c ,
                     City, State, Street, PostalCode, Medical_Professional_First_Name__c, Medical_Professional_Last_Name__c,
                     Medical_Professional_Phone__c, Medical_Professional_Email__c, Treating_Medical_Professional_First_Name__c,
                     Treating_Medical_Professional_Last_Name__c,Treating_Medical_Professional_Phone__c,  
                     Additional_Parent_City__c,Additional_Parent_Email__c,Additional_Parent_First_Name__c,
                     Additional_Parent_Last_Name__c,Additional_Parent_Phone__c,Additional_Parent_Postal_Code__c,
                     Additional_Parent_State__c,Additional_Parent_Street__c,
                     Treating_Medical_Professional_Email__c FROM Lead
                     WHERE id = :currId limit 1];
         masterLeadList = new List<Lead>();
         masterLeadList.add(currLead); 
       }
       else
       {
          currLead = new Lead();
       }
       
      // checking medical info and treating medical info is same or not. if it is same, then we are displaying duplicates on same table.
       if(currLead.id != Null)
       {
          if(currLead.Medical_Professional_First_Name__c != Null && currLead.Medical_Professional_Last_Name__c != Null &&
             (currLead.Medical_Professional_Phone__c != Null || currLead.Medical_Professional_Email__c != Null))
           {
          
            if(currLead.Medical_Professional_First_Name__c == currLead.Treating_Medical_Professional_First_Name__c && 
               currLead.Treating_Medical_Professional_Last_Name__c == currLead.Medical_Professional_Last_Name__c && 
               (currLead.Treating_Medical_Professional_Phone__c == currLead.Medical_Professional_Phone__c || 
                currLead.Treating_Medical_Professional_Email__c  == currLead.Medical_Professional_Email__c))
                {
                   hideTreatingSection = True;
                
                }
             }
       }
    
   
   }


  // Fetching all duplicate lead records related with current lead id.
   public List<leadWrapper> getdupLeadList()
   {
        List<Lead> dupLeads = new List<Lead>();
       
       
          
        if(currLead.id != Null)
        {
          dupLeads = [SELECT id, FirstName,Name, LastName, Email, Phone, City, DOB__c,State, PostalCode,
                      ChapterName__r.name,ChapterName__c  FROM Lead
                      WHERE ((LastName = :currLead.LastName AND FirstName = :currLead.FirstName) OR
                      (LastName = :currLead.LastName AND ((State = :currLead.State AND City = :currLead.City AND Street = :currLead.Street
                      AND PostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) 
                      OR (FirstName = :currLead.FirstName
                      AND ((State = :currLead.State AND City = :currLead.City AND Street = :currLead.Street
                      AND PostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) OR  (DOB__C = :currLead.DOB__c AND 
                      ((State = :currLead.State AND City = :currLead.City  AND Street = :currLead.Street
                      AND PostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) OR  (DOB__C = :currLead.DOB__c AND
                      (LastName = :currLead.LastName OR FirstName = :currLead.FirstName))) AND Id != :MasterLeadList[0].Id AND isConverted = false];
        }
       
       if(wrapperList.size() <= 0)
       {
        if(dupLeads.size() > 0)
        {
         for(Lead currDup : dupLeads)
         {
           leadWrapper newWrapper = new LeadWrapper(currDup);
          
           wrapperList.add(newWrapper);
         }
        }
      }
       return wrapperList;
   }
   
   // Fetching Duplicate Wish Child based on the current lead.
   public List<Contact> getdupContactList()
   {
        List<Contact> dupContacts = new List<Contact>();
        if(currLead.id != Null)
        {
          dupContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode,Region_Chapter__r.Name FROM Contact
                         WHERE ((LastName = :currLead.LastName AND FirstName = :currLead.FirstName) OR
                         (LastName = :currLead.LastName AND ((MailingState = :currLead.State AND MailingCity = :currLead.City AND MailingStreet =: currLead.Street
                         AND MailingPostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) 
                         OR (FirstName = :currLead.FirstName
                         AND ((MailingState = :currLead.State AND MailingCity = :currLead.City AND MailingStreet =: currLead.Street 
                         AND MailingPostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email )) OR  (BirthDate = :currLead.DOB__c AND 
                         ((MailingState = :currLead.State AND MailingCity = :currLead.City AND MailingStreet =: currLead.Street
                         AND MailingPostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) 
                         OR  (Birthdate = :currLead.DOB__c AND
                         (LastName = :currLead.LastName OR FirstName = :currLead.FirstName))) AND RecordTypeId = :wishChild];
                         
        }
        return dupContacts;
   }
  // Querying duplicate Medical Professional based on the current lead. 
  public List<Contact> getdupMedicalContactList()
   {
        List<Contact> dupContacts = new List<Contact>();
        if(currLead.id != Null)
        {
          dupContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Medical_Professional_First_Name__c AND LastName = :currLead.Medical_Professional_Last_Name__c 
                         AND (Phone = :currLead.Medical_Professional_Phone__c Or Email =: currLead.Medical_Professional_Email__c) 
                         AND RecordTypeId = :MedicalProfessionalRT)];
                         
        }
        return dupContacts;
   }
  // Querying duplicate Treating Medical Professional based on the current lead. 
   public List<Contact> getdupTreatingContactList()
   {
        List<Contact> dupContacts = new List<Contact>();
     
        if(currLead.id != Null)
        {
          dupContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Treating_Medical_Professional_First_Name__c AND 
                         LastName = :currLead.Treating_Medical_Professional_Last_Name__c 
                         AND (Phone = :currLead.Treating_Medical_Professional_Phone__c Or Email =: currLead.Treating_Medical_Professional_Email__c) 
                         AND RecordTypeId = :MedicalProfessionalRT)];
                         
        }
        return dupContacts;
   }
  
  
  // Querying duplicate Best Contact Person in Physician hospital based on the current lead. 
   public List<Contact> getbestPhysicianContactList()
   {
        List<Contact> dupContacts = new List<Contact>();
     
        if(currLead.id != Null)
        {
          dupContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Best_Contact_for_Physician_First_Name__c AND 
                         LastName = :currLead.Best_Contact_for_Physician_Last_Name__c 
                         AND  Email =: currLead.Best_contact_for_Physician_Email__c 
                         AND RecordTypeId = :MedicalProfessionalRT)];
                         
        }
        return dupContacts;
   }
   
   
  // Querying duplicate Wish Family based on the current lead. 
   public List<Contact> getdupParentContactList()
   {
        List<Contact> dupContacts = new List<Contact>();
        if(currLead.id != Null)
        {
          dupContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Parent_First_Name__c AND LastName = :currLead.Parent_Last_Name__c AND 
                               (((Email = :currLead.Email OR Phone = :currLead.Phone) 
                               AND (MailingStreet = :currLead.Street AND MailingState = :currLead.State 
                               AND MailingPostalCode = :currLead.PostalCode 
                               AND MailingCity = :currLead.City))  
                               OR ((Phone = :currLead.Phone OR (MailingStreet = :currLead.Street AND MailingState = :currLead.State 
                               AND MailingPostalCode = :currLead.PostalCode 
                               AND MailingCity = :currLead.City))
                               AND Email = :currLead.Email)  OR (((MailingStreet = :currLead.Street AND MailingState = :currLead.State 
                               AND MailingPostalCode = :currLead.PostalCode 
                               AND MailingCity = :currLead.City) OR (Email = :currLead.Email) )
                               AND Phone = :currLead.Email))) AND RecordTypeId = :wishFamilyRT];
                         
        }
        return dupContacts;
   }
   
   
    // Querying duplicate Additional Wish Family based on the current lead. 
   public List<Contact> getAdditionalParentContactList()
   {
        List<Contact> dupContacts = new List<Contact>();
        if(currLead.id != Null)
        {
          dupContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                        
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Additional_Parent_First_Name__c AND LastName = :currLead.Additional_Parent_Last_Name__c AND 
                               (((Email = :currLead.Additional_Parent_Email__c OR Phone = :currLead.Additional_Parent_Phone__c) 
                               AND (MailingStreet = :currLead.Additional_Parent_Street__c AND MailingState = :currLead.Additional_Parent_State__c 
                               AND MailingPostalCode = :currLead.Additional_Parent_Postal_Code__c 
                               AND MailingCity = :currLead.Additional_Parent_City__c))  
                               OR ((Phone = :currLead.Additional_Parent_Phone__c OR (MailingStreet = :currLead.Additional_Parent_Street__c AND MailingState = :currLead.Additional_Parent_State__c
                               AND MailingPostalCode = :currLead.Additional_Parent_Postal_Code__c
                               AND MailingCity = :currLead.Additional_Parent_City__c))
                               AND Email = :currLead.Additional_Parent_Email__c)  OR (((MailingStreet = :currLead.Additional_Parent_Street__c AND MailingState = :currLead.Additional_Parent_State__c
                               AND MailingPostalCode = :currLead.Additional_Parent_Postal_Code__c
                               AND MailingCity = :currLead.Additional_Parent_City__c) OR (Email = :currLead.Additional_Parent_Email__c) )
                               AND Phone = :currLead.Additional_Parent_Phone__c))) AND RecordTypeId = :wishFamilyRT];
                         
        }
        return dupContacts;
   }
   
   
   // Mark the Master record by default for merging. If user want to change, then can change it using radio button.
   public void selectDefaultRecord() {
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        //UTIL_Debug.debug('Selected Record: ' + recordId);
        if (recordId != null && selectedRecords.keySet().contains(recordId)) {
            for (FieldRow row : fieldRows) {
                if (row.showRadio) {
                    row.selectedValue = recordId; 
                }
            }
        }
    }
   
   // Its redirect the user to Merge page once they choosen duplicates.
   // If user checks no duplicate checkbox , then it will update the record as No Duplicate Found and allowed as a duplicate record.
   public pageReference nextStep() 
   {
   
        set<Id> mergeIds = new set<Id>(); 
        for (leadWrapper c : wrapperList) 
        {
            System.debug('c++++++++++++++++++++++++++++++++++++++ ' + c);
            if(c.selected) {
                mergeIds.add(c.currentLead.Id);
            }
        }
        
      if(noDuplicate == True && mergeIds.size() > 0)
      {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You can either choose "No duplicate Found" or any lead(s) under Select Existing Leads.'));
            return null;
      }      
            
      else if(noDuplicate == True)
      {
         Lead updateLead = new Lead();
         updateLead.id = currLead.id;
         updateLead.Override_Dupe_Check__c = True;
         updateLead.Dup_Check__c = 'Block Lead Dup';
         update updateLead;
         PageReference reference=new PageReference('/'+currLead.id);
         reference.setRedirect(true);
         return reference;
      }
      else
      {
        /*  set<Id> mergeIds = new set<Id>(); 
            for (leadWrapper c : wrapperList) {
            System.debug('c++++++++++++++++++++++++++++++++++++++ ' + c);
                if (c.selected) {
                    mergeIds.add(c.currentLead.Id);
                }
            } */
            
            System.debug('mergeIds+++++++++++++++++++++++++++++ ' + mergeIds);
            mergeIds.add(MasterLeadList[0].Id);
            System.debug('mergeIds1++++++++++++++++++++++++++++++++++++++ ' + mergeIds);
       
            loadMergeCandidates(mergeIds);
      }
      
      return null;
   }
   
  // Wrapper class 
   public class leadWrapper {
      public Lead currentLead{get; set;}
      public Boolean selected {get; set;}
       public leadWrapper(Lead currLead) {
            currentLead = currLead;
            selected = false;
        }
   }
   
  
  //Submitting for Diagnosis Verification. 
   public pageReference ContinuePartAForm()
   {
   
      Lead updateLead = new Lead();
      updateLead.id = currLead.Id;
      if(currLead.Of_Times_Email_Sent__c != Null)
        updateLead.Of_Times_Email_Sent__c = currLead.Of_Times_Email_Sent__c+1;
      else
        updateLead.Of_Times_Email_Sent__c = 1;
     
      updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
      updateLead.Override_Dupe_Check__c = True;
      updateLead.Medical_Professional_ContactId__c = medicalConId;
      if(hideTreatingSection == false && (treatingContactId != Null && treatingContactId !=''))
         updateLead.Treating_Medical_Professional_Contact_Id__c = treatingContactId;
      else if(hideTreatingSection == True)
          updateLead.Treating_Medical_Professional_Contact_Id__c = medicalConId;
      updateLead.Wish_Family_ContactId__c = contactId;
      updateLead.Hidden_Best_Contact_Person_Id__c = bestToConId;
      updateLead.Hidden_Additional_Parent_Id__c = additionalParentId;
      updateLead.Contact_Dup_Check__c = 'Block Contact Dup';
      if(currLead.Best_contact_for_Physician_Email__c == Null)
         updateLead.Hidden_DV_form_Medical_professional_Type__c = 'Treating Medical Professional';
      updateLead.Dup_Check__c = 'Block Lead Dup';
      Update updateLead;
      if(currLead.Best_contact_for_Physician_Email__c == Null || currLead.Best_contact_for_Physician_Email__c == '' || currLead.Treating_Medical_Professional_Email__c == currLead.Best_contact_for_Physician_Email__c){
          displayPartASuccess = True;
          return null;
      }
      else{
         PageReference reference = new PageReference('/apex/LeadSelectMedEmail_VF?id='+currLead.Id);
         reference.setRedirect(true);
         return reference;
      }
       return null;   
      
   }
   //Completing dupcheck
   public PageReference CompleteDupeCheck()
   {
   
      Lead updateLead = new Lead();
      updateLead.id = currLead.Id;
         
      updateLead.Sub_Status__c = 'Pending Diagnosis Verification';
      updateLead.Override_Dupe_Check__c = True;
      updateLead.Medical_Professional_ContactId__c = medicalConId;
      if(hideTreatingSection == false && (treatingContactId != Null && treatingContactId !=''))
         updateLead.Treating_Medical_Professional_Contact_Id__c = treatingContactId;
      else if(hideTreatingSection == True)
          updateLead.Treating_Medical_Professional_Contact_Id__c = medicalConId;
      updateLead.Wish_Family_ContactId__c = contactId;
      updateLead.Hidden_Best_Contact_Person_Id__c = bestToConId;
      updateLead.Hidden_Additional_Parent_Id__c = additionalParentId;
      updateLead.Contact_Dup_Check__c = 'Block Contact Dup';
      updateLead.Dup_Check__c = 'Block Lead Dup';
      Update updateLead;
     PageReference reference=new PageReference('/'+currLead.id);
     reference.setRedirect(true);
     return reference;
      
   }
   
   // Redirecting to Lead Detail page.
   public pagereference GoToLeadViewPage()
   {
     displayPartASuccess = false;
     PageReference reference=new PageReference('/'+currLead.id);
     reference.setRedirect(true);
     return reference;
   
   }
   
   
  
     /*******************************************************************************************************
    * @description Shows the next step of the wizard where user can see the diff of the records before merge.
    */
    private void loadMergeCandidates(set<Id> mergeCandidates) 
    {
       
       boolean flag=true; 
       System.debug('mergeCandidates+++++++++++++++++++++++++++++ ' + mergeCandidates);
        // Check we have atleast 2 and not more than 3 records selected for merge. If not throw an error. 
        if (mergeCandidates.size() <=1) {
            flag=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select an existing lead to merge or check "No Duplicate Found" if the leads displayed are not duplicates.'));
            return;
          
        }
        
        if (mergeCandidates.size() > 3 ) {
            flag=false;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select 2 leads for merging'));
           //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You can not merge more than 3 leads at a time'));
            return;
           
        }
        
        if(flag == True)
        {
            selectedRecordsCount = mergeCandidates.size();
            Set<String> fieldsSet = new Set<String>();
            
             for(Schema.FieldSetMember f : getMergeFields())
             {
                fieldsSet.add((f.getFieldPath()).tolowercase());
                System.debug('f.getFieldPath()++++++++++++++++++++++++++++++++ ' +f.getFieldPath());
             }
                
            Map<String, Schema.SObjectField> leadFields= Schema.SObjectType.Lead.fields.getMap();
            Map<String, Schema.DescribeFieldResult> standardFieldMap = new Map<String, Schema.DescribeFieldResult>();
            Map<String, Schema.DescribeFieldResult> customFieldMap = new Map<String, Schema.DescribeFieldResult>();
            
            // Construct the query string
            String query = 'Select id, name, ';
            for (String fieldName : leadFields.keySet()) {
                Schema.SobjectField f = leadFields.get(fieldName);
                Schema.DescribeFieldResult fResult = f.getDescribe();
                
                // Only include the fields which are updateable and accessible
                if (fResult.isUpdateable() && fResult.isAccessible()) {
                    // If the field is type lookup, select the parent name  
                    
                        string relName = fResult.getRelationshipName();
                        if (string.isBlank(relName)) {
                            query += (fieldName + ',');
                        } else {
                            //find the Name field for the related object
                            string nameField = getRelatedObjNameField(fResult);
        
                            if (nameField!=null) {
                                query += (relName + '.' + nameField + ',');
                            }
                        }
                        // Collect the standard and custom fields separately for sorting
                        if(fResult.isCustom()) {
                          System.debug('fieldName+++++++++++++++++++++++++++++++++++++++++++++ ' +fieldName);
                          if(fieldsSet.contains(fieldName))
                             customFieldMap.put(fieldName, fResult);
                        } else {
                            standardFieldMap.put(fieldName, fResult);
                        }
                    }
               
            }
            // Adding some non-updateable system fields which we need to add to the record diff table.
            query +=  'createdby.name, createddate, LastModifiedBy.name, LastModifiedDate';
            // Finally completing the query by appending the table name and the filter clause
            query += ' from Lead where id IN :mergeCandidates';
            
            //UTIL_Debug.debug('The contact query is: ' + query);
            
            List<Lead> leads;
            try {
                leads = Database.query(query); // Query the records
                // Ensure we got back the same number of records as expected. In case any record got deleted/moved since last search.
                if (leads == null || leads.size() != mergeCandidates.size()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.npe01.Contact_Merge_Error_Query_Failed + ' ' + Label.npe01.Contact_Merge_Error_please_retry));
                    return;
                }
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.npe01.Contact_Merge_Error_Contact_not_found + ' Error: ' + e));
                return;
            }
            
            
            System.debug('query++++++++++++++++++++++++++++++++++++++++++ ' + query);
            // Update the list of searched records with only the ones selected
            wrapperList.clear();
            for (lead c : leads) {
                this.selectedRecords.put(c.id, c);    
            }
            
            System.debug(' this.selectedRecords++++++++++++++++++++++++++++++++ ' + this.selectedRecords);
            
            // Sort the standard fields list by name before creating the list of FieldRow for merge UI
            List<String> standardFieldList = new List<String>();
            standardFieldList.addAll(standardFieldMap.keySet());
            standardFieldList.sort();
            
            // Sort the custom fields list by name before creating the list of FieldRow for merge UI
            List<String> customFieldList = new List<String>();
            customFieldList.addAll(customFieldMap.keySet());
            customFieldList.sort();
            
            // Add the first row of type header with contact names as titles
            FieldRow temp = new FieldRow('', '', false, 'header');
            for (Sobject c: leads) {
                lead leadRec = (lead) c;
                temp.values.add(new Cell(leadRec.id, leadRec.name));  
            }
            fieldRows.add(temp);
            
            // Add second row to select the master record. Select the one which is last modified
            temp = new FieldRow(MASTER_KEY, 'Master Record', true, null);
            {
                DateTime lastModifiedDate;
                for (Sobject c: leads) {
                    temp.values.add(new Cell(c.id, null));
                    if (lastModifiedDate == null || 
                        (lastModifiedDate != null && (DateTime)c.get('lastModifiedDate') > lastModifiedDate)) {
                        temp.selectedValue = c.id;
                        lastModifiedDate = (DateTime)c.get('lastModifiedDate');
                    }   
                }
            }
            fieldRows.add(temp);
            
            // Add a dummy row to add a 'Standard Fields' header before the list of standard fields
            fieldRows.add(new FieldRow('Standard Fields', 'Standard Fields', false, 'separator'));
            
            // Add all standard fields to the list of FieldRow in sorted manner
            for (String fieldName: standardFieldList) {
                addFieldComparisonRows(fieldName, standardFieldMap.get(fieldName), leads);
            }
            
            // Add a dummy row to add a 'Custom Fields' header before the list of custom fields
            fieldRows.add(new FieldRow('Custom Fields', 'Custom Fields', false, 'separator'));
            
            // Add all custom fields to the list of FieldRow in sorted manner
            for (String fieldName: customFieldList) {
                addFieldComparisonRows(fieldName, customFieldMap.get(fieldName), leads);
            }
            
            // Add a dummy row to add a 'System Fields' header before the list of system fields
            fieldRows.add(new FieldRow('System Fields', 'System Fields', false, 'separator'));
            
            // Add created by and last modified by system fields to the list of FieldRow
            FieldRow createdByRow = new FieldRow('CreatedById', 'Created By', false, null), 
                lastModifiedByRow = new FieldRow('LastModifiedById', 'Last Modified By', false, null);
            for (Sobject c: leads) {
                SObject createdBy = c.getSObject('createdby');
                SObject modifiedBy = c.getSObject('lastModifiedBy');
                createdByRow.values.add(new Cell(c.id, (createdBy != null ? createdBy.get('name') : '') + ' ' + c.get('createdDate')));
                lastModifiedByRow.values.add(new Cell(c.id, (modifiedBy != null ? modifiedBy.get('name') : '') + ' ' + c.get('LastModifiedDate'))); 
            }
            fieldRows.add(createdByRow);
            fieldRows.add(lastModifiedByRow);
            this.step = 3;
        // If everything looks good go to "choose winning contact" step
        }
        
    }
     
      private string getRelatedObjNameField(Schema.DescribeFieldResult fieldDesc) 
      {
        string nameField = 'Name';
        Map<String, Schema.SObjectField> mapRelatedObjectFields = fieldDesc.getReferenceTo()[0].getDescribe().fields.getMap();

        //if Name isn't the correct name field, find it
        if (!mapRelatedObjectFields.containsKey(nameField)) {
            nameField = null;
            for (String relatedFieldName : mapRelatedObjectFields.keySet()) {
                if (mapRelatedObjectFields.get(relatedFieldName).getDescribe().isNameField())
                    return relatedFieldName;
            }
        }
        return nameField;
     }
    
    // Wrapper class for displaying selected records for merge with radio button.
      public class FieldRow {
      
        public String fieldLabel {get; private set;}
        public String fieldName {get; private set;} 
        public boolean showRadio {get; private set;}
        public List<Cell> values {get; private set;}
        public String selectedValue {get; set;}
        public String styleClass {get; private set;}
        public FieldRow() {
            this.values = new List<Cell>();
        }
        
        public FieldRow(String fieldName, String fieldLabel, boolean showRadio, String styleClass) {
            this();
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.showRadio = showRadio;
            this.styleClass = styleClass;
        }
    }
    
    // Wrapper class for maintaining 
      public class Cell {
       
        public String objId {get; private set;} 
        public String value {get; private set;}
        public Cell(String objectId, String value) {
            this.objId = objectId;
            this.value = value;
        }
    }
    
      private void addFieldComparisonRows(String fieldName, Schema.DescribeFieldResult fieldDesc, List<SObject> objs) {
        // Create a new FieldRow item
        FieldRow row = new FieldRow();
        row.fieldName = fieldName;
        
        // For standrd lookup type fields, use the relationship name as the field label
        if (!fieldDesc.isCustom() && fieldDesc.getRelationshipName() != null) {
            row.fieldLabel = fieldDesc.getRelationshipName();
        } else {
            row.fieldLabel = fieldDesc.getLabel();
        }
        
        row.values = new List<Cell>();
        
        boolean isDifferent = false; // flag to indicate whether atleast one pair of field values is different across all contacts
        boolean isNull = true; // flag to indicate whether all the field values are null
        Integer idx = 0;
        
        List<String> values = new List<String>();
        DateTime lastModifiedDate = null;
        String prev;
        
        // Iterate over all contacts to find the field values and add them to row values
        for (SObject c : objs) {
            // For lookup fields set the name as the values
            if (fieldDesc.getRelationshipName() != null) {
                Sobject obj = c.getSObject(fieldDesc.getRelationshipName());
                if (obj != null) {
                    values.add(String.valueOf(obj.get(getRelatedObjNameField(fieldDesc))));
                } else {
                    values.add(null);
                }   
            } else {
                values.add(String.valueOf(c.get(fieldName)));
            }
            
            isNull &= (c.get(fieldName) == null); // Check if the value is null
            
            if (idx == 0) {
                prev = String.valueOf(c.get(fieldName));
            }
            if (idx > 0 && !isNull) {
                // Check if atleast one of the values is different. If yes then update the isDifferent flag
                String current = String.valueOf(c.get(fieldName));
                if ((prev != null && !prev.equals(current)) || 
                    (current != null && !current.equals(prev))) {
                    isDifferent = true;
                }
                prev = current;
            }
            
            // Select the default value for the field. A non-null value on the latest modified record 
            if (c.get(fieldName) != null && (lastModifiedDate == null || 
                (lastModifiedDate != null && (DateTime)c.get('lastModifiedDate') > lastModifiedDate))) {
                row.selectedValue = c.id;
                lastModifiedDate = (DateTime)c.get('lastModifiedDate');
            }
            
            idx++;
        }

        // If atleast one record has a non-null field value, then add it to the list of fieldRows.
        if (!isNull) {
            for (Integer i=0; i < values.size(); i++) {
                String val = values[i];
                if (val != null && val.length() > 255) {
                    val = val.substring(0, 251) + ' ...';
                }
                row.values.add(new Cell(objs[i].id, val));
            }
            // Show the select radio only if the field values are different. 
            // Dont let user choose the account as you dont want users to assign a differnt account in One to One case.
            row.showRadio = (isDifferent && !fieldName.equalsIgnoreCase('accountId'));
            fieldRows.add(row);
        }
    }
    
   /* private boolean isNPSPHiddenField(string strField) {
        list<string> listStrField = new list<string>{
            'npe01__SystemAccountProcessor__c',
            'npo02__SystemHouseholdProcessor__c',
            'npe01__SystemIsIndividual__c',
            'Current_Address__c'
        };

        for (string strF : listStrField) {
           if (strField.equalsIgnoreCase(strF))
               return true;
        }
        return false;
    }*/
    
    public PageReference mergeContacts() {
        SObject master;
        // Find the master record based the selected value of the Master FieldRow
        for (FieldRow row : fieldRows) {
            if (row.showRadio && row.fieldName.equals(MASTER_KEY)) {
                master = new Lead(id = row.selectedValue,Override_Dupe_Check__c=True);             
                break;
            }
        }
        
        if (master != null) {
            // Update the field values of master record based on the selected value for each field.
            for (FieldRow row : fieldRows) {
                if (row.showRadio && !row.fieldName.equals(MASTER_KEY) && row.selectedValue != master.id) {
                    SObject selectedRecord = this.selectedRecords.get(row.selectedValue);
                    
                    //UTIL_Debug.debug('Assigning field: ' + row.fieldName);
                    
                    // Sobject.put is not happy when sobject.get returns null. It throws an exception System.SObjectException: Illegal assignment from Object to String.
                    // But instead when you pass a null directly to put, it works fine. And hence, this if statement.
                    if (selectedRecord.get(row.fieldName) == null) {
                        master.put(row.fieldName, null);    
                    } else {
                        Object val = selectedRecord.get(row.fieldName);
                        //UTIL_Debug.debug('Setting value: ' + val);
                        master.put(row.fieldName, val);
                        //UTIL_Debug.debug('Set value: ' + master.get(row.fieldName));
                    }
                }
            }
            
            // Group all the loosing records separately.
            List<Lead> losers = new List<Lead>();
            
            for (Lead c : this.selectedRecords.values()) {
                if (c.id != master.id) {
                    c.Override_Dupe_Check__c=True;
                    losers.add(c);
                }   
            }
        
            // before proceeding further first lock the records for change
            List<Lead> allContacts = new List<Lead>();
            allContacts.add((lead)master);
            allContacts.addAll(losers);
            List<lead> lock = [Select id from lead where id IN :allContacts for update];
            
            if (lock == null || lock.size() != allContacts.size()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, label.npe01.Contact_Merge_Error_Lock_failed  + ' ' + label.npe01.Contact_Merge_Error_please_retry) );
                return null;
            }
            
            System.SavePoint sp = Database.setSavepoint();
            try {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
              
                Database.SaveResult sr = Database.update(master, dml);
                if (!sr.isSuccess()) {
                    string strErr = label.npe01.Contact_Merge_Error_Merge_Failed + ' Error: ';
                    for (Database.Error err : sr.getErrors()) {
                        strErr += err.getMessage() + '\n';
                    }
                    Database.rollback(sp);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, strErr));
                    return null;
                }
                
                duplicateMerge_AC.mergeContacts((lead)master, losers);
                masterLeadId = master.id;
                Lead currLead = [SELECT id,FirstName,Name, LastName, Email, Phone, City, DOB__c,State, PostalCode,Street,
                                 ChapterName__r.name,ChapterName__c FROM  Lead WHERE Id = :master.id limit 1];
                // Checking duplicates again.
             System.debug('currLead++++++++++++++++++++++++= ' + currLead);     
             List<Lead>   duplicateLeadList = [SELECT id, FirstName,Name, LastName, Email, Phone, City, DOB__c,State, PostalCode,
                                              ChapterName__r.name,ChapterName__c  FROM Lead
                                              WHERE ((LastName = :currLead.LastName AND FirstName = :currLead.FirstName) OR
                                              (LastName = :currLead.LastName AND ((State = :currLead.State AND City = :currLead.City AND Street = :currLead.Street
                                              AND PostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) 
                                              OR (FirstName = :currLead.FirstName
                                              AND ((State = :currLead.State AND City = :currLead.City AND Street = :currLead.Street
                                              AND PostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) OR  (DOB__C = :currLead.DOB__c AND 
                                              ((State = :currLead.State AND City = :currLead.City AND Street = :currLead.Street
                                              AND PostalCode = :currLead.PostalCode) OR Phone = :currLead.Phone OR Email = :currLead.Email)) OR  (DOB__C = :currLead.DOB__c AND
                                              (LastName = :currLead.LastName OR FirstName = :currLead.FirstName))) AND Id != :currLead.Id AND isConverted = false
                                              AND ChapterName__c =:currLead.ChapterName__c];
                
             System.debug('duplicateLeadList++++++++++++++++++++++++= ' + duplicateLeadList);        
                
             if(duplicateLeadList.size() > 0)
              {
                displayLeadDupPopup = true;
              }
              else
              {
                   Lead updateLead = new Lead();
                   updateLead.id = masterLeadId;
                   updateLead.Dup_Check__c = 'Block Lead Dup';
                   update updateLead;
                   return new PageReference('/' + updateLead.id); 
                 
              }   
                
                // Update the master with the selected values
               
            } catch (Exception e) {
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, label.npe01.Contact_Merge_Error_Merge_Failed + ' Error: ' + e));
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, label.npe01.Contact_Merge_Error_No_Master));
        }
        
        return null;
    }
    
     public List<Schema.FieldSetMember> getMergeFields() {
        return SObjectType.Lead.FieldSets.Merge_Fields.getFields();
    }
    
    
   Public PageReference isYes()
   {
      PageReference pr = new PageReference('/apex/LeadDuplicate_VF?id='+masterLeadId);
      pr.setRedirect(true); 
      return pr;
   }
   
   Public PageReference isNo()
   {
       Lead updateLead = new Lead();
       updateLead.id = masterLeadId;
       updateLead.Dup_Check__c = 'Block Lead Dup';
       update updateLead;
       return new PageReference('/' + updateLead.id);   
   }
}