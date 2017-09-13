/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 26/05/2016
Description : LeadTriggerHandler is used to assign the case owner as a queue dynamically based on the lead state.And also if any duplicate records available in leads or contact then it displayed as a duplicate leads and contacts.
And also it is used to call the approval process automatically when the record is created. And also convert the lead automatically when approver 
approve the record.
*******************************************************************************************************************/

Public Class LeadTriggerHandler{
    
    /* When the lead is create it check if any duplicate records available in leads or contact then it displayed as a duplicate leads and contacts.
And also Assign the case owner as a queue dynamically based on the lead state. */
    Constant_AC  constant = new Constant_AC();
    Id staffTaskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
    public Id medicalProfessionalRecordTypeId = Schema.SobjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
    public Id wishChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
    public Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    public Id organizationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.OrganizationRT).getRecordTypeId();
    public Id HouseholdRT=Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.HouseholdRT).getRecordTypeId();
    public Id parentwishRecTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    public Id partARecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();
    public Id chapterecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.chapterRT).getRecordTypeId();
    public Id hospitalTreatMentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(constant.hospitalTreatment).getRecordTypeId();
    public boolean falg = true;
    Map<String,Account> newAccountMap = new Map<String,Account>();
    Map<String,Account> medicalAccountMap = new Map<String,Account>();
    List<Lead>convertedLeadList = new List<Lead>();
    Map<Id,Lead> convertedLeadMap = new Map<Id,Lead>();
    String convertedAccId;
    /*Convert the lead records when it is approved.*/
    public void onAfterUpdate(List<Lead> newLeads){
        RecursiveTriggerHandler.isFirstTime = false;
        Map<Id,Id> leadContactMap = new Map<Id, Id>();
        System.debug('onAfterUpdate>>>>>>>>>>>>>>>>>>>>');
        Map<Id,Lead> convertedAccountMap = new Map<Id,Lead>();
        List<Account> updateAcccountList = new List<Account>();
        Map<id,Contact> conMap = new Map<Id,Contact>();
        Map<Id,Lead> LeadMap = new Map<id,Lead>();
        Map<Id,Lead> leadFamilyMap = new Map<Id,Lead>();
        Set<Id> convertedLeadIds = new Set<Id>();
        set<Id> conId = new set<Id>();
        Set<Id> accountIds = new Set<Id>();
        List<Case>caseList = new List<Case>();
        List<cg__ContactFile__c> ConFileList = new List<cg__ContactFile__c>();
        
        List<npe4__Relationship__c> wishFamilyRelationList = new List<npe4__Relationship__c>();
        List<Contact> siblingList = new List<Contact>();
        LeadStatus convertStatus = [select MasterLabel from LeadStatus where IsConverted = true limit 1];
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        List<Case> partACaseList = new List<Case>();
        List<dsfs__DocuSign_Status__c > dsfsList = new List<dsfs__DocuSign_Status__c>();
        Set<String> leadFamilyFirstNameSet = new Set<String>();
        Set<String> leadFamilyLastNameSet = new Set<String>();
        Set<String> leadFamilyEmailSet = new Set<String>();
        Set<String> leadFamilyPhoneSet = new Set<String>();
        Set<Id> chapterIdSet = new Set<Id>();
        set<Id> leadIdSet = new Set<Id>();
        List<npe4__Relationship__c> relationShipList = new List<npe4__Relationship__c>();
        Map<Id,Account> chapterUserMap = new Map<Id,Account>();
        Map<String,Contact> contactFamilyNameMap = new Map<String,Contact>();
        Map<String,Contact> contactFamilyEmailMap = new Map<String,Contact>();
        Map<String,Contact> contactFamilyPhoneMap = new Map<String,Contact>();
        Map<String,Contact> contactFamilyAddressMap = new Map<String,Contact>();
        List<Task> rushReminderList = new List<Task>();
        Id ChapterId;
        for(Lead processNewLeads: newLeads){
            Database.LeadConvert lc = new Database.LeadConvert();
            LeadMap.put(processNewLeads.Id,processNewLeads);
            lc.setLeadId(processNewLeads.Id);
            lc.setDoNotCreateOpportunity(true); 
            lc.setConvertedStatus(convertStatus.MasterLabel);
            leadConverts.add(lc);
        }
        System.debug('Lead Convertion start1:');
        if (!leadConverts.isEmpty()) {
            System.debug('Lead Convertion start2:');
            
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
            //List<String> SiblingList = new List<String>();
            Map<Id,Lead> convertedLeadMap = new Map<Id,Lead>();
            for(Database.LeadConvertResult convertLeads :lcr){
                leadContactMap.put(convertLeads.getLeadId(),convertLeads.getContactId());
                accountIds.add(convertLeads.getAccountId());
                conId.add(convertLeads.getContactId());
                convertedLeadIds.add(convertLeads.getLeadId());
                
                
            }
            if(leadContactMap.size() > 0) {
                List<Diagnosis_Verification__c> diagnosisList = new List<Diagnosis_Verification__c>();
                for(Diagnosis_Verification__c diagnosisInfo : [SELECT Id, Contact__c, Lead__c FROM Diagnosis_Verification__c WHERE Lead__c IN : leadContactMap.keySet()]) {
                    diagnosisInfo.Contact__c = leadContactMap.get(diagnosisInfo.Lead__c);
                    diagnosisList.add(diagnosisInfo);
                }
                if(diagnosisList.size() > 0) {
                    System.debug('>>>diagnosisList>>>>>>>'+diagnosisList);
                    update diagnosisList;
                }
                updateDocusignStatus(leadContactMap);
            }
            
            for(Lead convertedLeads : [SELECT Id,Name,DOB__c,FirstName, Why_do_you_feel_would_be_eligible_Wish__c, LastName,createdDate,Migrated_Record__c,I_am_Recognized_To_Practice_As_a__c,Sibling_Detail__c,Medical_Provider_Category__c,ChapterName__r.Name,ChapterName__c,Treating_Medical_Professional_First_Name__c,ConvertedContactId,ConvertedAccountId,
                                       Other_Relationship_To_Child__c,Relationship_to_child__c,LeadSource,Treating_Medical_Professional_Phone__c,Treating_Medical_Professional_Email__c,
                                       is_Family_Aware_of_Referral__c,Treating_Medical_Professional_Last_Name__c,Referrer_City__c,
                                       Referrer_Email__c,Referrer_FirstName__c,Referrer_Last_Name__c,Referrer_Phone__c,Referrer_Zip__c,
                                       Parent_First_Name__c,What_is_the_family_s_primary_spoken_lang__c,Parent_Last_Name__c,Email,
                                       Phone,City,CountryCode,PostalCode,StateCode,Street,Treating_Medical_Professional_Contact_Id__c,
                                       Medical_Professional_ContactId__c,Wish_Family_ContactId__c,Best_contact_for_Physician_Email__c,
                                       Best_Contact_for_Physician_First_Name__c,Best_Contact_for_Physician_Last_Name__c,
                                       Additional_Parent_First_Name__c,Additional_Parent_Last_Name__c,Additional_Parent_City__c,
                                       Additional_Parent_Email__c,Additional_Parent_Phone__c,Additional_Parent_Postal_Code__c,
                                       Additional_Parent_State__c,Additional_Parent_Street__c,Hidden_Additional_Parent_Id__c,
                                       Hidden_Best_Contact_Person_Id__c,Parent_Relationship_to_Child__c,
                                       Additional_Parent_Relationship_to_Child__c,How_Did_you_hear_about_Make_A_Wish__c
                                       FROM Lead WHERE Id IN: convertedLeadIds])
             {
                                           leadFamilyMap.put(convertedLeads.Id,convertedLeads);
                                           convertedLeadMap.put(convertedLeads.ConvertedContactId,convertedLeads);
                                           convertedAccountMap.put(convertedLeads.ConvertedAccountId,convertedLeads);
                                           chapterIdSet.add(convertedLeads.ChapterName__c);
                                           leadFamilyFirstNameSet.add(convertedLeads.FirstName);
                                           leadFamilyLastNameSet.add(convertedLeads.LastName);
                                           leadFamilyEmailSet.add(convertedLeads.Email);
                                           leadFamilyPhoneSet.add(convertedLeads.Phone);
                                           
                                           if(convertedLeads.Treating_Medical_Professional_Contact_Id__c != Null){
                                               
                                               npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                                               newRelationShip.npe4__Contact__c = convertedLeads.ConvertedContactId;
                                               newRelationShip.npe4__Type__c = 'Medical Professional';
                                               If(convertedLeads.Treating_Medical_Professional_First_Name__c == convertedLeads.Referrer_FirstName__c
                                                    && convertedLeads.Treating_Medical_Professional_Last_Name__c == convertedLeads.Referrer_Last_Name__c && 
                                                    (convertedLeads.Treating_Medical_Professional_Phone__c == convertedLeads.Referrer_Phone__c 
                                                    || convertedLeads.Treating_Medical_Professional_Email__c == convertedLeads.Referrer_Email__c)){
                                                                  
                                                                   newRelationShip.Referring_Medical_Professional__c = true;
                                               }
                                               newRelationShip.Qualifying_Medical_Professional__c = True;
                                               newRelationShip.npe4__RelatedContact__c = convertedLeads.Treating_Medical_Professional_Contact_Id__c;
                                               newRelationShip.npe4__Status__c = 'Active';
                                               relationShipList.add(newRelationShip);
                                               
                                           }
                                           else{
                                               leadIdSet.add(convertedLeads.Id);
                                           }
                                           if(convertedLeads.Medical_Professional_ContactId__c != Null ){
                                               
                                               npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                                               newRelationShip.npe4__Contact__c = convertedLeads.ConvertedContactId;                                               
                                               newRelationShip.npe4__Type__c = 'Medical Professional';
                                               newRelationShip.Referring_Medical_Professional__c = true;
                                               If(convertedLeads.Treating_Medical_Professional_First_Name__c == convertedLeads.Referrer_FirstName__c
                                                    && convertedLeads.Treating_Medical_Professional_Last_Name__c == convertedLeads.Referrer_Last_Name__c && 
                                                    (convertedLeads.Treating_Medical_Professional_Phone__c == convertedLeads.Referrer_Phone__c 
                                                    || convertedLeads.Treating_Medical_Professional_Email__c == convertedLeads.Referrer_Email__c)){
                                                       
                                                       newRelationShip.Qualifying_Medical_Professional__c = True; 
                                                }
                                                        
                                               newRelationShip.npe4__RelatedContact__c = convertedLeads.Medical_Professional_ContactId__c ;
                                               newRelationShip.npe4__Status__c = 'Active';
                                               relationShipList.add(newRelationShip);
                                               
                                           }
                                           else{
                                               leadIdSet.add(convertedLeads.Id);
                                           }
                                           if(convertedLeads.Wish_Family_ContactId__c != Null){
                                               npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                                               newRelationShip.npe4__Contact__c = convertedLeads.ConvertedContactId;
                                               newRelationShip.npe4__Type__c = convertedLeads.Parent_Relationship_to_Child__c;
                                               //newRelationShip.npe4__Type__c = 'Family';
                                               newRelationShip.Hidden_isparentFirst__c = True;
                                               newRelationShip.npe4__RelatedContact__c = convertedLeads.Wish_Family_ContactId__c;
                                               newRelationShip.npe4__Status__c = 'Active';
                                               if(ConvertedLeads.Relationship_to_Child__c == 'Parent/Guardian')
                                                   newRelationShip.Referring_Medical_Professional__c=True;
                                               relationShipList.add(newRelationShip);
                                           }
                                           
                                           else{
                                               leadIdSet.add(convertedLeads.Id);
                                           }
                                           
                                           if(convertedLeads.Hidden_Additional_Parent_Id__c!= Null){
                                               npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                                               newRelationShip.npe4__Contact__c = convertedLeads.ConvertedContactId;
                                               newRelationShip.Hidden_isparentFirst__c = true;
                                               newRelationShip.npe4__Type__c = convertedLeads.Additional_Parent_Relationship_to_Child__c;
                                               newRelationShip.npe4__RelatedContact__c = convertedLeads.Hidden_Additional_Parent_Id__c;
                                               newRelationShip.npe4__Status__c = 'Active';
                                               relationShipList.add(newRelationShip);
                                           }
                                           
                                           else{
                                               leadIdSet.add(convertedLeads.Id);
                                           }
                                           
                                           
                                           if(convertedLeads.Hidden_Best_Contact_Person_Id__c!= Null)
                                           {
                                               npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                                               newRelationShip.npe4__Contact__c = convertedLeads.ConvertedContactId;
                                               newRelationShip.npe4__Type__c = 'Medical Professional';
                                               newRelationShip.npe4__RelatedContact__c = convertedLeads.Hidden_Best_Contact_Person_Id__c;
                                               newRelationShip.npe4__Status__c = 'Active';
                                               if(convertedLeads.Best_Contact_for_Physician_First_Name__c == convertedLeads.Referrer_FirstName__c
                                                    && convertedLeads.Best_Contact_for_Physician_Last_Name__c == convertedLeads.Referrer_Last_Name__c && 
                                                    (convertedLeads.Best_contact_for_Physician_Email__c == convertedLeads.Referrer_Email__c))
                                             {
                                                               newRelationShip.Referring_Medical_Professional__c = true;
                                                               //newRelationShip.Qualifying_Medical_Professional__c = True; 
                                                }
                                                
                                                 if(convertedLeads.Treating_Medical_Professional_First_Name__c == convertedLeads.Best_Contact_for_Physician_First_Name__c
                                                        && convertedLeads.Treating_Medical_Professional_Last_Name__c == convertedLeads.Best_Contact_for_Physician_Last_Name__c && 
                                                       (convertedLeads.Treating_Medical_Professional_Email__c == convertedLeads.Best_contact_for_Physician_Email__c)){
                                                       
                                                       newRelationShip.Qualifying_Medical_Professional__c = True;
                                                  }
                                                
                                               relationShipList.add(newRelationShip);
                                           }
                                           
                                           else
                                           {
                                               leadIdSet.add(convertedLeads.Id);
                                           }
             }
            
            
            for(Account conAccount : [SELECT Id,Name,Volunteer_Manager__c,Intake_Manager__c,Volunteer_Manager__r.Name,Volunteer_Manager__r.Email,RecordTypeId FROM Account Where Id IN: accountIds]){
                if(chapterIdSet.contains(conAccount.Id)){
                    ChapterId = conAccount.Id;
                    chapterUserMap.put(conAccount.Id,conAccount);
                }
                
                if(convertedAccountMap.containsKey(conAccount.Id)){
                    if(convertedAccountMap.get(conAccount.Id).FirstName == Null){
                        conAccount.Name = convertedAccountMap.get(conAccount.Id).LastName + ' '+ ' & '+' ' +'Family Household';
                        conAccount.RecordTypeId=HouseholdRT;
                        conAccount.PrimaryLanguage__c = convertedAccountMap.get(conAccount .Id).What_is_the_family_s_primary_spoken_lang__c;
                    }
                    else{
                        conAccount.Name = convertedAccountMap.get(conAccount.Id).FirstName + ' ' +convertedAccountMap.get(conAccount.Id).LastName + ' '+ ' & '+' ' +'Family Household';
                        conAccount.PrimaryLanguage__c = convertedAccountMap.get(conAccount .Id).What_is_the_family_s_primary_spoken_lang__c;
                        conAccount.RecordTypeId=HouseholdRT;
                    }
                    updateAcccountList.add(conAccount );
                }
            }
            
            List<cg__ContactFile__c> ContactFileFolders = new List<cg__ContactFile__c>();
            for(contact con : [SELECT Id,FirstName,Birthdate,Language__c,Migrated_Record__C,Lead_Created_Date__c,Relationship_to_Wish_Child__c,Referrer_FirstName__c,Referrer_Last_Name__c,Referrer_Phone__c,Referrer_Email__c,Referrer_City__c,Referrer_Zip__c,Relationship__c,Inquiry_Referral_Method__c,Is_Family_Aware_of_Referral__c,Parent_Guardian_Name__c,RecordTypeId,AccountId,LastName,MailingCity,OwnerId,MailingState,MailingPostalCode,Wish_How_Did_you_hear_about_Make_A_Wish__c  FROM Contact WHERE Id in:conId]){
                IF(convertedLeadMap.containsKey(con.Id)){
                    
                    con.Lead_Created_Date__c = Date.valueOf(convertedLeadMap.get(con.Id).createdDate);
                    con.Birthdate = convertedLeadMap.get(con.Id).DOB__c;
                    con.RecordTypeId = wishChildRecordTypeId;
                    con.Language__c = convertedLeadMap.get(con.Id).What_is_the_family_s_primary_spoken_lang__c;
                    con.Region_Chapter__c =  convertedLeadMap.get(con.Id).ChapterName__c;
                    con.Inquiry_Referral_Method__c =convertedLeadMap.get(con.Id).Leadsource;
                    con.Referrer_City__c =convertedLeadMap.get(con.Id).Referrer_City__c;
                    con.Referrer_Email__c =convertedLeadMap.get(con.Id).Referrer_Email__c;
                    con.Referrer_FirstName__c =convertedLeadMap.get(con.Id).Referrer_FirstName__c;
                    con.Referrer_Last_Name__c =convertedLeadMap.get(con.Id).Referrer_Last_Name__c;   
                    con.Referrer_Phone__c =convertedLeadMap.get(con.Id).Referrer_Phone__c;
                    con.Referrer_Zip__c =convertedLeadMap.get(con.Id).Referrer_Zip__c;
                    con.Relationship__c =convertedLeadMap.get(con.Id).Relationship_to_child__c;
                    con.Relationship_to_Wish_Child__c=convertedLeadMap.get(con.Id).Other_Relationship_To_Child__c;
                    con.Is_Family_Aware_of_Referral__c =convertedLeadMap.get(con.Id).Is_Family_Aware_of_Referral__c;
                    con.migrated_Record__c = convertedLeadMap.get(con.Id).migrated_record__c;
                    con.Wish_How_Did_you_hear_about_Make_A_Wish__c = convertedLeadMap.get(con.Id).How_Did_you_hear_about_Make_A_Wish__c;
                    
                    con.Hidden_Medical_Physician__c = convertedLeadMap.get(con.Id).Treating_Medical_Professional_First_Name__c+' '+convertedLeadMap.get(con.Id).Treating_Medical_Professional_Last_Name__c;
                    conMap.put(con.Id,con);
                    
                    cg__ContactFile__c picFolder =new cg__ContactFile__c();
                    picFolder.cg__Contact__c = con.Id;
                    picFolder.cg__Content_Type__c = 'Folder';
                    picFolder.cg__File_Name__c = 'Photos';
                    picFolder.cg__WIP__c = false;
                    ContactFileFolders.add(picFolder);
                    
                    cg__ContactFile__c docFolder =new cg__ContactFile__c();
                    docFolder.cg__Contact__c = con.Id;
                    docFolder.cg__Content_Type__c = 'Folder';
                    docFolder.cg__File_Name__c = 'Documents';
                    docFolder.cg__WIP__c = false;
                    ContactFileFolders.add(docFolder);
                    
                    cg__ContactFile__c videosFolder =new cg__ContactFile__c();
                    videosFolder.cg__Contact__c = con.Id;
                    videosFolder.cg__Content_Type__c = 'Folder';
                    videosFolder.cg__File_Name__c = 'Videos';
                    videosFolder.cg__WIP__c = false;
                    ContactFileFolders.add(videosFolder);  
                    
                    Task newTask = new Task();
                    newTask.OwnerId = con.OwnerId;
                    newTask.Subject = 'Send Welcome Letter/Make Welcome Call';
                    newTask.WhoId = con.Id;
                    newTask.Description = 'Send Welcome Letter/Make Welcome Call';
                    newTask.Status = 'In Progress';
                    newTask.ActivityDate = system.today() + 10;
                    newTask.RecordTypeId = staffTaskRT;
                    rushReminderList.add(newTask);   
                }
            }
            
            for(Database.LeadConvertResult convertLeads :lcr){
                if(leadFamilyMap.containsKey(convertLeads.getLeadId())){
                    if(leadFamilyMap.get(convertLeads.getLeadId()).Sibling_Detail__c != Null){
                        if(leadFamilyMap.get(convertLeads.getLeadId()).Sibling_Detail__c.contains('<br>')){
                            system.debug('@@@@@@ ENTER INTO SIBLING DETAILS @@@@@@'+leadFamilyMap.get(convertLeads.getLeadId()).Sibling_Detail__c);    
                            for(String currsiblings : leadFamilyMap.get(convertLeads.getLeadId()).Sibling_Detail__c.split('<br>')){
                                system.debug('@@@@@@ ENTER INTO SIBLING DETAILS1 @@@@@@'+currsiblings);    
                                if(currsiblings.contains('|') ){
                                    system.debug('@@@@@@ ENTER INTO SIBLING DETAILS2 @@@@@@'+currsiblings);    
                                    List<String>siblingdetails = currsiblings.split('\\|');
                                    if(siblingdetails.size() == 3){
                                        
                                        Contact newFamily = new Contact();
                                        newFamily.FirstName = siblingdetails [0].trim();
                                        newFamily.lastName = siblingdetails [1].trim();
                                        newFamily.Sibling_Age__c = siblingdetails [2].trim();
                                        newFamily.Wish_Child_Id_Hidden__c = convertLeads.getcontactId();
                                        newFamily.RecordTypeId = wishFamilyRecordTypeId;
                                        newFamily.AccountId = convertLeads.getAccountId();
                                        newFamily.Region_Chapter__c = leadFamilyMap.get(convertLeads.getLeadId()).ChapterName__c;
                                        newFamily.Language__c = leadFamilyMap.get(convertLeads.getLeadId()).What_is_the_family_s_primary_spoken_lang__c;
                                        if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.isNumeric()){
                                            siblingList.add(newFamily);
                                        }
                                        if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && newFamily.LastName.containsOnly('-') && newFamily.Sibling_Age__c.isNumeric()){
                                            newFamily.LastName = 'Unknown';
                                            siblingList.add(newFamily);
                                        }
                                        if(newFamily.FirstName.containsOnly('-') && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.isNumeric()){
                                            newFamily.FirstName = '';
                                            siblingList.add(newFamily);
                                        }
                                        if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.containsOnly('-')){
                                            newFamily.Sibling_Age__c = Null;
                                            siblingList.add(newFamily);
                                        }
                                        if(newFamily.FirstName.containsOnly('-') && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.containsOnly('-')){
                                            newFamily.FirstName = '';
                                            newFamily.Sibling_Age__c = Null;
                                            siblingList.add(newFamily);
                                        }
                                        if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && newFamily.LastName.containsOnly('-')  && newFamily.Sibling_Age__c.containsOnly('-')){
                                            newFamily.LastName = 'Unknown';
                                            newFamily.Sibling_Age__c = Null;
                                            siblingList.add(newFamily);
                                        }
                                    }
                                }
                            }
                            
                        }
                        else if(leadFamilyMap.get(convertLeads.getLeadId()).Sibling_Detail__c.contains('|')){
                            list<String> siblingdetails = leadFamilyMap.get(convertLeads.getLeadId()).Sibling_Detail__c.split('\\|');
                            
                            if(siblingdetails .size() == 3){
                                
                                Contact newFamily = new Contact();
                                newFamily.FirstName = siblingdetails [0].trim();
                                newFamily.lastName = siblingdetails [1].trim();
                                newFamily.Sibling_Age__c = siblingdetails[2].trim();
                                newFamily.Wish_Child_Id_Hidden__c = convertLeads.getcontactId();
                                newFamily.RecordTypeId = wishFamilyRecordTypeId;
                                newFamily.AccountId = convertLeads.getAccountId();
                                newFamily.Region_Chapter__c = leadFamilyMap.get(convertLeads.getLeadId()).ChapterName__c;
                                newFamily.Language__c = leadFamilyMap.get(convertLeads.getLeadId()).What_is_the_family_s_primary_spoken_lang__c;
                                if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.isNumeric()){
                                    siblingList.add(newFamily);
                                }
                                if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && newFamily.LastName.containsOnly('-') && newFamily.Sibling_Age__c.isNumeric()){
                                    newFamily.LastName = 'Unknown';
                                    siblingList.add(newFamily);
                                }
                                if(newFamily.FirstName.containsOnly('-') && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.isNumeric()){
                                    newFamily.FirstName = '';
                                    siblingList.add(newFamily);
                                }
                                if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.containsOnly('-')){
                                    newFamily.Sibling_Age__c = Null;
                                    siblingList.add(newFamily);
                                }
                                if(newFamily.FirstName.containsOnly('-') && (!newFamily.LastName.containsOnly('-') && newFamily.LastName != Null) && newFamily.Sibling_Age__c.containsOnly('-')){
                                    newFamily.FirstName = '';
                                    newFamily.Sibling_Age__c = Null;
                                    siblingList.add(newFamily);
                                }
                                if((!newFamily.FirstName.containsOnly('-') && newFamily.FirstName != Null) && newFamily.LastName.containsOnly('-')  && newFamily.Sibling_Age__c.containsOnly('-')){
                                    newFamily.LastName = 'Unknown';
                                    newFamily.Sibling_Age__c = Null;
                                    siblingList.add(newFamily);
                                }
                            }
                        }
                        
                    }
                }
                
                if(LeadMap.containsKey(convertLeads.getLeadId())) {
                    case newcase = new case();
                    newcase .RecordTypeId = parentwishRecTypeId;
                    newcase.contactId = convertLeads.getcontactId();
                    newCase.Hidden_Lead_Id__c = convertLeads.getLeadId();
                    newCase.Qualified_Date__c= System.today();
                    newCase.Migrated_Record__c = LeadMap.get(convertLeads.getLeadId()).Migrated_Record__c; 
                    newCase.Qualifying_Medical_Professional_Name__c=LeadMap.get(convertLeads.getLeadId()).Treating_Medical_Professional_First_Name__c +' '+LeadMap.get(convertLeads.getLeadId()).Treating_Medical_Professional_Last_Name__c;
                    newcase.Qualifying_Medical_Professional_Email__c=LeadMap.get(convertLeads.getLeadId()).Treating_Medical_Professional_Email__c;
                    if(conMap.containsKey(convertLeads.getcontactId()))
                    {
                        newcase.ownerId = conMap.get(convertLeads.getcontactId()).ownerId;
                        newCase.ChapterName__c = LeadMap.get(convertLeads.getLeadId()).chapterName__c;
                        newCase.Hidden_Primary_Diagnosis__c = LeadMap.get(convertLeads.getLeadId()).PD_Condition_Description__c ;
                        
                        System.debug('Parent Wishes 123' + LeadMap.get(convertLeads.getLeadId()).chapterName__c);
                    }
                    newcase.AccountId = convertLeads.getAccountId();
                    
                    Date myDate = Date.ValueOf( LeadMap.get(convertLeads.getLeadId()).CreatedDate);
                    String dateval = String.valueof(myDate);
                    if(LeadMap.get(convertLeads.getLeadId()).FirstName != NULL){
                        newcase.Subject = LeadMap.get(convertLeads.getLeadId()).FirstName + ' ' + LeadMap.get(convertLeads.getLeadId()).LastName;
                    }
                    else{
                        newcase.Subject = LeadMap.get(convertLeads.getLeadId()).LastName;
                    }
                    if(chapterUserMap.size() > 0){
                        if(chapterUserMap.get(ChapterId).Volunteer_Manager__r.Name != Null && chapterUserMap.get(ChapterId).Volunteer_Manager__r.Email != Null){
                            newcase.VOlunteer_Manager_Name__c = chapterUserMap.get(ChapterId).Volunteer_Manager__r.Name;
                            newcase.Volunteer_Manager_Email__c =chapterUserMap.get(ChapterId).Volunteer_Manager__r.Email;
                        }
                        
                        if(chapterUserMap.get(ChapterId).Intake_Manager__c != Null)
                        { 
                            newCase.OwnerId = chapterUserMap.get(ChapterId).Intake_Manager__c;
                        }
                    }
                    newcase.Status = 'Qualified';
                    newcase.Hidden_Why_do_you_feel__c = LeadMap.get(convertLeads.getLeadId()).Why_do_you_feel_would_be_eligible_Wish__c;
                    newcase.Origin = 'Web';
                    if(LeadMap.get(convertLeads.getLeadId()).Is_We_Need_To_Expedite_The_Process__c == 'Yes') {
                        newCase.Rush__c = true;
                        newCase.Rush_Explanation__c = LeadMap.get(convertLeads.getLeadId()).Please_Explain__c;
                        newCase.Rush_Timeframe__c = 'Select timeframe';
                    }
                    if(LeadMap.get(convertLeads.getLeadId()).Referred_Date__c != null)
                        newCase.Referral_Date__c = LeadMap.get(convertLeads.getLeadId()).Referred_Date__c;
                    if(LeadMap.get(convertLeads.getLeadId()).Inquiry_Date__c!= null)
                        newCase.Inquiry_Date__c= LeadMap.get(convertLeads.getLeadId()).Inquiry_Date__c;
                    newCase.Diagnosis_Verification_Receive_Date__c = LeadMap.get(convertLeads.getLeadId()).Part_A_Received__c;
                    newCase.Diagnosis_Verification_Sent_Date__c = LeadMap.get(convertLeads.getLeadId()).Part_A_Sent__c;
                    
                    if(LeadMap.get(convertLeads.getLeadId()).PD_Condition_Description__c != null) {
                        newCase.Hidden_All_Primary__c  = LeadMap.get(convertLeads.getLeadId()).PD_Condition_Description__c +'\n';
                    }
                    if(LeadMap.get(convertLeads.getLeadId()).SD1_Condition_Description__c != null) {
                        newCase.Hidden_All_Primary__c  += LeadMap.get(convertLeads.getLeadId()).SD1_Condition_Description__c +'\n';
                    }
                    if(LeadMap.get(convertLeads.getLeadId()).SD2_Condition_Description__c != null) {
                        newCase.Hidden_All_Primary__c  += LeadMap.get(convertLeads.getLeadId()).SD2_Condition_Description__c +'\n';
                    }
                    if(LeadMap.get(convertLeads.getLeadId()).SD3_Condition_Description__c != null) {
                        newCase.Hidden_All_Primary__c  += LeadMap.get(convertLeads.getLeadId()).SD3_Condition_Description__c+'\n';
                    }
                    if(LeadMap.get(convertLeads.getLeadId()).SD4_Condition_Description__c != null) {
                        newCase.Hidden_All_Primary__c  += LeadMap.get(convertLeads.getLeadId()).SD4_Condition_Description__c;
                    }
                    if(LeadMap.get(convertLeads.getLeadId()).unique_wish_identifier__c!= null) {
                        newcase.Lead__c = LeadMap.get(convertLeads.getLeadId()).Id;
                        newcase.Unique_Wish_Record_Identifier__c= LeadMap.get(convertLeads.getLeadId()).unique_wish_identifier__c;
                        newcase.Fund_Id__c = LeadMap.get(convertLeads.getLeadId()).unique_wish_identifier__c;
                        newcase.Wish_Assist__c= true;
                    }
                    
                    caseList.add(newcase);
                }
            }
            
            for(Case dbPartAcase : [SELECT Id,CaseNumber,Lead__c,ContactId FROM Case WHERE Lead__c IN:convertedLeadIds]){
                if(leadFamilyMap .containsKey(dbPartAcase.Lead__c)){
                    dbPartAcase.ContactId = leadFamilyMap.get(dbPartAcase.Lead__c).ConvertedContactId;
                    partACaseList.add(dbPartAcase);
                }
            }
            
            for(dsfs__DocuSign_Status__c dbdsfsLead : [SELECT Id,dsfs__Lead__c,dsfs__Envelope_Status__c FROM dsfs__DocuSign_Status__c  WHERE dsfs__Lead__c IN: convertedLeadIds AND dsfs__Envelope_Status__c =: 'Completed']){
                System.debug('@@@@@@@ leadFamilyMap Out Side Loop #######'+leadFamilyMap );
                if(leadFamilyMap .containsKey(dbdsfsLead.dsfs__Lead__c)){
                    System.debug('@@@@@@@ leadFamilyMap #######'+leadFamilyMap );
                    dbdsfsLead.dsfs__Contact__c = leadFamilyMap.get(dbdsfsLead.dsfs__Lead__c).ConvertedContactId;
                    System.debug('********** dbdsfsLead.dsfs__Contact__c #######'+dbdsfsLead.dsfs__Contact__c);
                    dsfsList.add(dbdsfsLead );
                    System.debug('********** dsfsList #######'+dsfsList);
                }
            }
            
            if(ContactFileFolders.size() > 0)
            {
                insert  ContactFileFolders;
            }
            
            Map<Id, Id> docFolderContactsMAP = new Map<Id, Id>();
            for(cg__ContactFile__c contactFile: [SELECT Id, cg__Contact__c from cg__ContactFile__c where cg__File_Name__c =: 'Documents' and cg__Contact__c in: conId]){
                docFolderContactsMAP.put(contactFile.cg__Contact__c, contactFile.Id);                                              
            }                                                
            
            for(Lead_File__c leadFile: [SELECT Id, Content_Type__c, Description__c, File_Name__c, File_Size__c,
                                        Is_Latest_Version__c, Key__c, Parent__c, Parent_Folder_Id__c, Private__c, Version_Description__c,
                                        Version_Id__c, WIP__c from Lead_File__c where Parent__c in: convertedLeadIds]){
                                            
                                            cg__ContactFile__c cFile=new cg__ContactFile__c();
                                            
                                            cFile.cg__Contact__c = leadFamilyMap.get(leadFile.Parent__c).ConvertedContactId;
                                            cFile.cg__Content_Type__c = leadFile.Content_Type__c;
                                            cFile.cg__Description__c = leadFile.Description__c;
                                            cFile.cg__File_Name__c = leadFile.File_Name__c;
                                            //cFile.cg__File_Size__c = leadFile.File_Size__c;
                                            cFile.cg__Is_Latest_Version__c =  leadFile.Is_Latest_Version__c;
                                            cFile.cg__Key__c = leadFile.Key__c;
                                            cFile.cg__Parent_Folder_Id__c = docFolderContactsMAP.get(leadFamilyMap.get(leadFile.Parent__c).ConvertedContactId);
                                            cFile.cg__Private__c = leadFile.Private__c;
                                            cFile.cg__Version_Description__c = leadFile.Version_Description__c;
                                            cFile.cg__Version_Id__c = leadFile.Version_Id__c;
                                            cFile.cg__WIP__c = leadFile.WIP__c;
                                            
                                            ConFileList.add(cFile); 
                                            
                                        }
        } 
        
        if(ConFileList.size() > 0)
        {
            insert ConFileList;
        }
        if(siblingList.size() > 0)
           insert siblingList;
        
        if(siblingList.size() > 0){
            for(Contact processsiblingList : siblingList){
                npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                newRelationShip.npe4__Contact__c = processsiblingList .Id;
                newRelationShip.npe4__Type__c = 'Sibling';
                newRelationShip.npe4__RelatedContact__c = processsiblingList.Wish_Child_Id_Hidden__c;
                newRelationShip.npe4__Status__c = 'Active';
                relationShipList.add(newRelationShip);
            }
        }
        if(updateAcccountList.size() > 0)
            update updateAcccountList;
        if(dsfsList.size() > 0)
            system.debug('%%%%% dsfsList %%%%%%%%'+dsfsList);
        update dsfsList;
        if(partACaseList.Size() > 0)
            update partACaseList;
        if(conMap.size() > 0)
            update conMap.values();
        if(caseList.size() > 0)
            insert caseList;
        if(relationShipList.size() > 0)
        {
            System.debug('relationShipList++++++++++++++++++++++++++++++++++++++ ' + relationShipList);
            insert relationShipList;
        }
        if(rushReminderList.size() > 0)
            insert rushReminderList;
        if(leadIdSet.size() > 0){
            dupeCheckonAccount(convertedLeadIds);
        }
        
        List<npe5__Affiliation__c> affliationList = new List<npe5__Affiliation__c>();
        for(npe5__Affiliation__c currAff : [SELECT Id,npe5__Contact__c,Constituent_Code__c FROM npe5__Affiliation__c WHERE npe5__Contact__c IN :conMap.Keyset() AND Constituent_Code__c ='Wish Family']){
            currAff.Constituent_Code__c ='Wish Child';
            affliationList.add(currAff);
        }
        if(affliationList.Size() > 0)
            Update affliationList;
    } 
    
    
    public void dupeCheckonAccount(Set<Id> convertedLeadIds){
        Set<String> medicalfacilytySet = new Set<String>();
        Set<String> treatingfacilytySet = new Set<String>();
        for(Lead  processconvertedLeads : [SELECT ID,Name,Hospital_Treatment_Facility__c,I_am_Recognized_To_Practice_As_a__c,Medical_Provider_Category__c,Hospital_Treatment_Facility_Treating__c,Medical_Professional_Last_Name__c,Medical_Professional_Phone__c,
                                           Medical_Professional_Email__c,Medical_Professional_First_Name__c,Treating_Medical_Professional_First_Name__c,Treating_Medical_Professional_Last_Name__c,
                                           Treating_Medical_Professional_Phone__c,Treating_Medical_Professional_Email__c,ConvertedContactId,ConvertedAccountId,Parent_First_Name__c,Parent_Last_Name__c,Email,Phone,CountryCode,  
                                           Street,StateCode,City,PostalCode,Wish_Family_ContactId__c,ChapterName__c,Treating_Medical_Professional_Contact_Id__c,Medical_Professional_ContactId__c,What_is_the_family_s_primary_spoken_lang__c,
                                           Referrer_FirstName__c,Referrer_Last_Name__c,Referrer_Phone__c,Referrer_Email__c,Relationship_to_child__c,Migrated_Record__c,
                                           Best_Contact_for_Physician_First_Name__c,Best_Contact_for_Physician_Last_Name__c,Best_contact_for_Physician_Email__c,
                                           Additional_Parent_First_Name__c,Additional_Parent_Last_Name__c,Additional_Parent_City__c,
                                           Additional_Parent_Email__c,Additional_Parent_Phone__c,Additional_Parent_Postal_Code__c,
                                           Additional_Parent_State__c,Additional_Parent_Street__c,Hidden_Additional_Parent_Id__c,
                                           Hidden_Best_Contact_Person_Id__c,Parent_Relationship_to_Child__c,Additional_Parent_Relationship_to_Child__c
                                            FROM Lead WHERE Id IN:convertedLeadIds ]){
                                               
                                               convertedAccId = processconvertedLeads.ConvertedAccountId;
                                               //medicalfacilytySet.add(processconvertedLeads.Hospital_Treatment_Facility__c);
                                               treatingfacilytySet.add(processconvertedLeads.Hospital_Treatment_Facility_Treating__c);
                                               convertedLeadList.add(processconvertedLeads);
                                               convertedLeadMap.put(processconvertedLeads.Id,processconvertedLeads);
                                           }
        for(Account dbAccount : [SELECT id,Name,RecordTypeId FROM Account WHERE RecordTypeId =: hospitalTreatMentRecordTypeId AND Name IN: treatingfacilytySet]){
            medicalAccountMap.put(dbAccount.Name,dbAccount);
            
        }
        
        for(Lead  processconvertedLeads :  [SELECT ID,Name,Hospital_Treatment_Facility__c,Migrated_Record__c,Hospital_Treatment_Facility_Treating__c,ChapterName__c FROM Lead WHERE Id IN:convertedLeadIds]){
            
            if(!medicalAccountMap.containsKey(processconvertedLeads.Hospital_Treatment_Facility_Treating__c)){
                if(processconvertedLeads.Hospital_Treatment_Facility_Treating__c != Null){
                    Account newAccount = new Account();
                    newAccount.Name = processconvertedLeads.Hospital_Treatment_Facility_Treating__c;
                    newAccount.RecordTypeId = hospitalTreatMentRecordTypeId;
                    newAccount.Migrated_Record__c = processconvertedLeads.Migrated_Record__c;
                    newAccountMap.put(newAccount.Name,newAccount);
                }
            }
            
        }
        
        if(newAccountMap.Size() > 0){
            insert newAccountMap.Values();
            dupeCheckonContact(convertedLeadMap);
        }
        if(medicalAccountMap.size() > 0){
            dupeCheckonContact(convertedLeadMap);
        }
        
    }
    public void dupeCheckonContact(Map<Id,Lead> convertedLeadMap)
    {
        Set<String> qualifyFirstNameSet = new Set<String>();
        Set<String> qualifyLastNameSet = new Set<String>();
        Set<String> qualifyPhoneNameSet = new Set<String>();
        Set<String> qualifyEmailNameSet = new Set<String>();
        Set<String> referringFirstNameSet = new Set<String>();
        Set<String> referringLastNameSet = new Set<String>();
        Set<String> referringPhoneNameSet = new Set<String>();
        Set<String> referringEmailNameSet = new Set<String>();
        Set<String> sameReferringFirstNameSet = new Set<String>();
        Set<String> sameReferringLastNameSet = new Set<String>();
        Set<String> sameReferringPhoneNameSet = new Set<String>();
        Set<String> sameReferringEmailNameSet = new Set<String>();
        
        Set<String> bestPersonFirstNameSet = new Set<String>();
        Set<String> bestPersonLastNameSet = new Set<String>();
        Set<String> bestPersonEmailNameSet = new Set<String>();
        
        Set<String> familyContactLastNameSet = new Set<String>();
        Set<String> additionalParentLastNameSet = new Set<String>();
        List<Contact> referringContact = new List<Contact>();
        List<Contact> newSameContact = new List<Contact>();
        List<Contact> qualifyingContact = new List<Contact>();
        List<Contact> WishFamilyContactList = new List<Contact>();
        List<npe4__Relationship__c> relationList = new List<npe4__Relationship__c>();
        List<npe5__Affiliation__c> affiliationList = new List<npe5__Affiliation__c>();
        Set<Id> WishFamilyContactIdSet = new Set<Id>();
        Set<Id> additionalFamilyConIdSet = new Set<Id>();
        String WishFmailyConId;
        List<npe5__Affiliation__c> updateaffiliationList = new List<npe5__Affiliation__c>();
        Id convertedConId;
        
        List<Contact> newContactList = new List<Contact>();
        Map<String,String> relationshipTypeMap = new Map<String,String>();
        Map<string,Boolean> firstParentMap = new Map<string,Boolean>();
        
        for(Lead processConvertedLead : convertedLeadMap.Values()){
            convertedConId = processConvertedLead.ConvertedContactId;
            
            
             if(((processConvertedLead.Treating_Medical_Professional_First_Name__c == processConvertedLead.Referrer_FirstName__c) 
                && (processConvertedLead.Referrer_FirstName__c == processConvertedLead.Best_Contact_for_Physician_First_Name__c)&&
                (processConvertedLead.Treating_Medical_Professional_First_Name__c == processConvertedLead.Best_Contact_for_Physician_First_Name__c))  
                && ((processConvertedLead.Treating_Medical_Professional_Last_Name__c == processConvertedLead.Referrer_Last_Name__c)
                && (processConvertedLead.Referrer_Last_Name__c == processConvertedLead.Best_Contact_for_Physician_Last_Name__c) 
                && (processConvertedLead.Treating_Medical_Professional_Last_Name__c == processConvertedLead.Best_Contact_for_Physician_Last_Name__c))
                && ((processConvertedLead.Treating_Medical_Professional_Phone__c == processConvertedLead.Referrer_Phone__c)
                || (processConvertedLead.Treating_Medical_Professional_Email__c == processConvertedLead.Referrer_Email__c)) 
                && (processConvertedLead.Referrer_Email__c == processConvertedLead.Best_contact_for_Physician_Email__c)
                && (processConvertedLead.Treating_Medical_Professional_Email__c  == processConvertedLead.Best_contact_for_Physician_Email__c))
               {
                   if(processConvertedLead.Relationship_to_child__c == 'Medical Professional' && processConvertedLead.Medical_Professional_ContactId__c == Null &&
                                   processConvertedLead.Treating_Medical_Professional_Contact_Id__c == Null && processConvertedLead.Hidden_Best_Contact_Person_Id__c == Null){
                       sameReferringFirstNameSet.add(processConvertedLead.Treating_Medical_Professional_First_Name__c);
                       sameReferringLastNameSet.add(processConvertedLead.Treating_Medical_Professional_Last_Name__c);
                       sameReferringPhoneNameSet.add(processConvertedLead.Treating_Medical_Professional_Phone__c);
                       sameReferringEmailNameSet.add(processConvertedLead.Treating_Medical_Professional_Email__c);
                   }
               }
            
            
            
            else if(processConvertedLead.Treating_Medical_Professional_First_Name__c == processConvertedLead.Referrer_FirstName__c
                    && processConvertedLead.Treating_Medical_Professional_Last_Name__c == processConvertedLead.Referrer_Last_Name__c && 
                    (processConvertedLead.Treating_Medical_Professional_Phone__c == processConvertedLead.Referrer_Phone__c 
                    || processConvertedLead.Treating_Medical_Professional_Email__c == processConvertedLead.Referrer_Email__c))
             {
                   if(processConvertedLead.Relationship_to_child__c == 'Medical Professional' && (processConvertedLead.Medical_Professional_ContactId__c == Null && processConvertedLead.Treating_Medical_Professional_Contact_Id__c == Null ))
                   {
                       sameReferringFirstNameSet.add(processConvertedLead.Treating_Medical_Professional_First_Name__c);
                       sameReferringLastNameSet.add(processConvertedLead.Treating_Medical_Professional_Last_Name__c);
                       sameReferringPhoneNameSet.add(processConvertedLead.Treating_Medical_Professional_Phone__c);
                       sameReferringEmailNameSet.add(processConvertedLead.Treating_Medical_Professional_Email__c);
                   }
                    if(processConvertedLead.Best_Contact_for_Physician_Last_Name__c != Null && processConvertedLead.Hidden_Best_Contact_Person_Id__c == Null){
                        if(processConvertedLead.Relationship_to_child__c == 'Medical Professional'){
                            bestPersonFirstNameSet.add(processConvertedLead.Best_Contact_for_Physician_First_Name__c); 
                            bestPersonLastNameSet.add(processConvertedLead.Best_Contact_for_Physician_Last_Name__c);
                            bestPersonEmailNameSet.add(processConvertedLead.Best_contact_for_Physician_Email__c);
                        } 
                     }
               }
               
               
            else if(processConvertedLead.Treating_Medical_Professional_First_Name__c == processConvertedLead.Best_Contact_for_Physician_First_Name__c
                    && processConvertedLead.Treating_Medical_Professional_Last_Name__c == processConvertedLead.Best_Contact_for_Physician_Last_Name__c  &&
                   (processConvertedLead.Treating_Medical_Professional_Email__c == processConvertedLead.Best_contact_for_Physician_Email__c))
            {
                   if(processConvertedLead.Relationship_to_child__c == 'Medical Professional' && processConvertedLead.Hidden_Best_Contact_Person_Id__c == Null &&  processConvertedLead.Treating_Medical_Professional_Contact_Id__c == Null)
                   {
                       sameReferringFirstNameSet.add(processConvertedLead.Treating_Medical_Professional_First_Name__c);
                       sameReferringLastNameSet.add(processConvertedLead.Treating_Medical_Professional_Last_Name__c);
                       sameReferringPhoneNameSet.add(processConvertedLead.Treating_Medical_Professional_Phone__c);
                       sameReferringEmailNameSet.add(processConvertedLead.Treating_Medical_Professional_Email__c);
                   }
                   if(processConvertedLead.Referrer_Last_Name__c != Null && processConvertedLead.Medical_Professional_ContactId__c == Null){
                    if(processConvertedLead.Relationship_to_child__c == 'Medical Professional'){
                        qualifyFirstNameSet.add(processConvertedLead.Referrer_FirstName__c ); 
                        qualifyLastNameSet.add(processConvertedLead.Referrer_Last_Name__c);
                        qualifyPhoneNameSet.add(processConvertedLead.Referrer_Phone__c );
                        qualifyEmailNameSet.add(processConvertedLead.Referrer_Email__c);
                    } 
                }
             }
             
             else if(processConvertedLead.Best_Contact_for_Physician_First_Name__c == processConvertedLead.Referrer_FirstName__c
                    && processConvertedLead.Best_Contact_for_Physician_Last_Name__c == processConvertedLead.Referrer_Last_Name__c && 
                    (processConvertedLead.Best_contact_for_Physician_Email__c == processConvertedLead.Referrer_Email__c))
             {
                   if(processConvertedLead.Relationship_to_child__c == 'Medical Professional' && processConvertedLead.Medical_Professional_ContactId__c == Null && processConvertedLead.Hidden_Best_Contact_Person_Id__c == Null)
                   {
                       sameReferringFirstNameSet.add(processConvertedLead.Referrer_FirstName__c);
                       sameReferringLastNameSet.add(processConvertedLead.Referrer_Last_Name__c );
                       sameReferringPhoneNameSet.add(processConvertedLead.Referrer_Phone__c);
                       sameReferringEmailNameSet.add(processConvertedLead.Referrer_Email__c);
                   }
                    if(processConvertedLead.Treating_Medical_Professional_Last_Name__c != Null && processConvertedLead.Treating_Medical_Professional_Contact_Id__c == Null)
                     {
                        referringFirstNameSet.add(processConvertedLead.Treating_Medical_Professional_First_Name__c);
                        referringLastNameSet.add(processConvertedLead.Treating_Medical_Professional_Last_Name__c);
                        referringPhoneNameSet.add(processConvertedLead.Treating_Medical_Professional_Phone__c);
                        referringEmailNameSet.add(processConvertedLead.Treating_Medical_Professional_Email__c);
                     }
                  
               }
               
                   
            else{
                if(processConvertedLead.Treating_Medical_Professional_Last_Name__c != Null && processConvertedLead.Treating_Medical_Professional_Contact_Id__c == Null){
                    referringFirstNameSet.add(processConvertedLead.Treating_Medical_Professional_First_Name__c);
                    referringLastNameSet.add(processConvertedLead.Treating_Medical_Professional_Last_Name__c);
                    referringPhoneNameSet.add(processConvertedLead.Treating_Medical_Professional_Phone__c);
                    referringEmailNameSet.add(processConvertedLead.Treating_Medical_Professional_Email__c);
                }
                
                if(processConvertedLead.Referrer_Last_Name__c != Null && processConvertedLead.Medical_Professional_ContactId__c == Null){
                    if(processConvertedLead.Relationship_to_child__c == 'Medical Professional'){
                        qualifyFirstNameSet.add(processConvertedLead.Referrer_FirstName__c ); 
                        qualifyLastNameSet.add(processConvertedLead.Referrer_Last_Name__c);
                        qualifyPhoneNameSet.add(processConvertedLead.Referrer_Phone__c );
                        qualifyEmailNameSet.add(processConvertedLead.Referrer_Email__c);
                    } 
                }
                
                if(processConvertedLead.Best_Contact_for_Physician_Last_Name__c != Null && processConvertedLead.Hidden_Best_Contact_Person_Id__c== Null){
                    if(processConvertedLead.Relationship_to_child__c == 'Medical Professional'){
                        bestPersonFirstNameSet.add(processConvertedLead.Best_Contact_for_Physician_First_Name__c); 
                        bestPersonLastNameSet.add(processConvertedLead.Best_Contact_for_Physician_Last_Name__c);
                        bestPersonEmailNameSet.add(processConvertedLead.Best_contact_for_Physician_Email__c);
                    } 
                }
            }
            
            if(processConvertedLead.Parent_Last_Name__c != Null && processConvertedLead.Wish_Family_ContactId__c == Null){
                FamilyContactLastNameSet.add(processConvertedLead.Parent_Last_Name__c);
            }
            
            if(processConvertedLead.Parent_Last_Name__c != Null && processConvertedLead.Wish_Family_ContactId__c != Null)
            { 
                WishFamilyContactIdSet.add(processConvertedLead.Wish_Family_ContactId__c);
            }
            
            if(processConvertedLead.Additional_Parent_Last_Name__c!= Null && processConvertedLead.Wish_Family_ContactId__c == Null){
                additionalParentLastNameSet.add(processConvertedLead.Additional_Parent_Last_Name__c);
            }
            
            if(processConvertedLead.Additional_Parent_Last_Name__c!= Null && processConvertedLead.Hidden_Additional_Parent_Id__c!= Null)
            { 
                WishFamilyContactIdSet.add(processConvertedLead.Hidden_Additional_Parent_Id__c);
            }
        }
        if (WishFamilyContactIdSet.Size() > 0){
            
            for(npe5__Affiliation__c dbFamilyContactAffiliation : [SELECT Id,npe5__Contact__c,npe5__Organization__c,npe5__Primary__c 
                                                                   FROM npe5__Affiliation__c WHERE 
                                                                   npe5__Contact__c =: WishFamilyContactIdSet 
                                                                   AND npe5__Primary__c =: true]){
                npe5__Affiliation__c updateAffliRec = new npe5__Affiliation__c();
                updateAffliRec.Id = dbFamilyContactAffiliation.Id;
                updateAffliRec.npe5__Primary__c = false;
                updateaffiliationList.add(updateAffliRec);
                
                npe5__Affiliation__c newAff = new npe5__Affiliation__c();
                newAff.npe5__Contact__c = dbFamilyContactAffiliation.npe5__Contact__c;
                newAff.npe5__Organization__c = convertedAccId;
                newAff.npe5__StartDate__c = Date.Today();
                newAff.npe5__Status__c = 'Active';
                newAff.npe5__Primary__c = true;
                affiliationList.add(newAff);
                
                system.debug('@@@@@ affiliationList @@@@@@@'+affiliationList);
                system.debug('@@@@@ affiliationList @@@@@@@'+affiliationList.size());
            }
        }  
        if(FamilyContactLastNameSet.size() > 0){
            for(Lead processConvertedLead : convertedLeadMap.Values()){
                Contact newWishFamily = new Contact();
                newWishFamily.FirstName= processConvertedLead.Parent_First_Name__c;
                newWishFamily.LastName = processConvertedLead.Parent_Last_Name__c;
                newWishFamily.Email = processConvertedLead.Email;
                newWishFamily.Phone = processConvertedLead.Phone;
                newWishFamily.MailingCountryCode = processConvertedLead.CountryCode;
                newWishFamily.MailingStreet = processConvertedLead.Street;
                newWishFamily.MailingStateCode = processConvertedLead.StateCode;
                newWishFamily.MailingCity= processConvertedLead.City;
                newWishFamily.MailingPostalCode = processConvertedLead.PostalCode;
                newWishFamily.Wish_Child_Id_Hidden__c = processConvertedLead .ConvertedContactId;
                newWishFamily.AccountId = processConvertedLead.ConvertedAccountId;
                newWishFamily.RecordTypeId = wishFamilyRecordTypeId;
                newWishFamily.Region_Chapter__c = processConvertedLead.ChapterName__c;
                newWishFamily.Language__c = processConvertedLead.What_is_the_family_s_primary_spoken_lang__c;
                newWishFamily.Relationship__c = processConvertedLead.Relationship_to_child__c;
                newWishFamily.Migrated_Record__c = processConvertedLead.Migrated_Record__c;
                if( processConvertedLead.Relationship_to_child__c == 'Parent/Guardian')
                            newWishFamily.Type_Of_Contact__c = 'Parent/Guardian';
                            
                newContactList.add(newWishFamily);
                firstParentMap.put(newWishFamily.FirstName + '-' + newWishFamily.LastName + '-' + newWishFamily.Email+ '-' + newWishFamily.Phone,true);
                relationshipTypeMap.put(newWishFamily.FirstName + '-' + newWishFamily.LastName + '-' + newWishFamily.Email+ '-' + newWishFamily.Phone,processConvertedLead.Parent_Relationship_to_Child__c);
            }
          /*  if(WishFamilyContactList.size() > 0){
                insert WishFamilyContactList;
                
                for(Contact processFamilyContact : WishFamilyContactList){
                    
                    npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                    newRelationShip.npe4__Contact__c = processFamilyContact.Wish_Child_Id_Hidden__c;
                    newRelationShip.npe4__Type__c = 'Family';
                    newRelationShip.npe4__RelatedContact__c = processFamilyContact.Id;
                    newRelationShip.npe4__Status__c = 'Active';
                    if(processFamilyContact.Relationship__c == 'Parent/Guardian')
                         newRelationShip.Referring_Medical_Professional__c = true;
                    relationList.add(newRelationShip);
                    
                }
                
            }*/
        }
        
        if(additionalParentLastNameSet.size() > 0){
          List<Contact> additionalContactList = new List<Contact>();
            for(Lead processConvertedLead : convertedLeadMap.Values()){
                Contact newWishFamily = new Contact();
                newWishFamily.FirstName= processConvertedLead.Additional_Parent_First_Name__c;
                newWishFamily.LastName = processConvertedLead.Additional_Parent_Last_Name__c;
                newWishFamily.Email = processConvertedLead.Additional_Parent_Email__c;
                newWishFamily.Phone = processConvertedLead.Additional_Parent_Phone__c;
                newWishFamily.MailingCountryCode = processConvertedLead.CountryCode;
                newWishFamily.MailingStreet = processConvertedLead.Additional_Parent_Street__c;
                newWishFamily.MailingState = processConvertedLead.Additional_Parent_State__c;
                newWishFamily.MailingCity= processConvertedLead.Additional_Parent_City__c;
                newWishFamily.MailingPostalCode = processConvertedLead.Additional_Parent_Postal_Code__c;
                newWishFamily.Wish_Child_Id_Hidden__c = processConvertedLead .ConvertedContactId;
                newWishFamily.AccountId = processConvertedLead.ConvertedAccountId;
                newWishFamily.RecordTypeId = wishFamilyRecordTypeId;
                newWishFamily.Region_Chapter__c = processConvertedLead.ChapterName__c;
                //newWishFamily.Type_Of_Contact__c = '';
               // newWishFamily.Language__c = processConvertedLead.Additional_Parent_Primary__c;
                //newWishFamily.Relationship__c = processConvertedLead.Relationship_to_child__c;
                newWishFamily.Migrated_Record__c = processConvertedLead.Migrated_Record__c;
                //relationshipTypeMap.put();
                firstParentMap.put(newWishFamily.FirstName + '-' + newWishFamily.LastName + '-' + newWishFamily.Email+ '-' + newWishFamily.Phone,true);
               relationshipTypeMap.put(newWishFamily.FirstName + '-' + newWishFamily.LastName + '-' + newWishFamily.Email+ '-' + newWishFamily.Phone,processConvertedLead.Additional_Parent_Relationship_to_Child__c);
                newContactList.add(newWishFamily);
            }
           /* if(additionalContactList.size() > 0){
                insert additionalContactList;
                
                for(Contact processFamilyContact : additionalContactList){
                    
                    npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                    newRelationShip.npe4__Contact__c = processFamilyContact.Wish_Child_Id_Hidden__c;
                    newRelationShip.npe4__Type__c = 'Family';
                    newRelationShip.npe4__RelatedContact__c = processFamilyContact.Id;
                    newRelationShip.npe4__Status__c = 'Active';
                    if(processFamilyContact.Relationship__c == 'Parent/Guardian')
                         newRelationShip.Referring_Medical_Professional__c = true;
                    relationList.add(newRelationShip);
                    
                }
                
            }*/
        }
        
        if(sameReferringFirstNameSet.Size()>0 && sameReferringLastNameSet.size() > 0 && (sameReferringPhoneNameSet.size() > 0 || sameReferringEmailNameSet.size() > 0)){
            List<npe4__Relationship__c> sameNameRelationList = new List<npe4__Relationship__c>();
            for(Lead processConvertedLead : convertedLeadMap.Values()){
                contact newMedicalcon = new contact();
                newMedicalcon.FirstName = processConvertedLead.Treating_Medical_Professional_First_Name__c;
                newMedicalcon.LastName = processConvertedLead.Treating_Medical_Professional_Last_Name__c;
                if(medicalAccountMap.containsKey(processConvertedLead .Hospital_Treatment_Facility_Treating__c))
                    newMedicalcon.AccountId = medicalAccountMap.get(processConvertedLead .Hospital_Treatment_Facility_Treating__c).Id;
                if(newAccountMap.containsKey(processConvertedLead .Hospital_Treatment_Facility_Treating__c))
                    newMedicalcon.AccountId = newAccountMap.get(processConvertedLead .Hospital_Treatment_Facility_Treating__c).Id;
                newMedicalcon.Phone = processConvertedLead.Treating_Medical_Professional_Phone__c;
                newMedicalcon.Email = processConvertedLead.Treating_Medical_Professional_Email__c;
                newMedicalcon.Provider_Type__c  = processConvertedLead.Medical_Provider_Category__c;
                newMedicalcon.RecordTypeId = medicalProfessionalRecordTypeId;
                newMedicalcon.Region_Chapter__c = processConvertedLead.ChapterName__c;
                newMedicalcon.Migrated_Record__c = processConvertedLead.Migrated_Record__c;
                newMedicalcon.Type_Of_Contact__c = 'Both';
                newContactList.add(newMedicalcon);
            }
            
            
           /* if(newSameContact .size() > 0){
                insert newSameContact ;
                
                
                for(Contact proccessSameContact : newSameContact ){
                    npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                    newRelationShip.npe4__Contact__c = convertedConId;
                    newRelationShip.npe4__Type__c = 'Medical Professional';
                    newRelationShip.Referring_Medical_Professional__c = true;
                    newRelationShip.Qualifying_Medical_Professional__c = true;
                    newRelationShip.npe4__RelatedContact__c = proccessSameContact.Id;
                    newRelationShip.npe4__Status__c = 'Active';
                    relationList.add(newRelationShip);
                    
                    
                }
                
            }*/
        }  
        if(referringFirstNameSet.size() > 0 && referringLastNameSet.Size() > 0 && (referringPhoneNameSet.Size() > 0 || referringEmailNameSet.Size() > 0)){
            List<npe4__Relationship__c> referringRelationList = new List<npe4__Relationship__c>();
            for(Lead processConvertedLead : convertedLeadMap.Values()){
                contact newMedicalcon = new contact();
                newMedicalcon.FirstName = processConvertedLead.Treating_Medical_Professional_First_Name__c;
                newMedicalcon.LastName = processConvertedLead.Treating_Medical_Professional_Last_Name__c;
                if(medicalAccountMap.containsKey(processConvertedLead .Hospital_Treatment_Facility_Treating__c))
                    newMedicalcon.AccountId = medicalAccountMap.get(processConvertedLead .Hospital_Treatment_Facility_Treating__c).Id;
                if(newAccountMap.containsKey(processConvertedLead .Hospital_Treatment_Facility_Treating__c))
                    newMedicalcon.AccountId = newAccountMap.get(processConvertedLead .Hospital_Treatment_Facility_Treating__c).Id;
                newMedicalcon.Phone = processConvertedLead.Treating_Medical_Professional_Phone__c;
                newMedicalcon.Email = processConvertedLead.Treating_Medical_Professional_Email__c;
                newMedicalcon.Provider_Type__c  = processConvertedLead.I_am_Recognized_To_Practice_As_a__c;
                newMedicalcon.RecordTypeId = medicalProfessionalRecordTypeId;
                newMedicalcon.Region_Chapter__c = processConvertedLead.ChapterName__c;
                newMedicalcon.Migrated_Record__c = processConvertedLead.Migrated_Record__c;
                newMedicalcon.Type_Of_Contact__c = 'Qualifing';
                newContactList.add(newMedicalcon);
            }
            
            
           /* if(referringContact .size() > 0){
                insert referringContact ;
                
                
                for(Contact proccessSameContact : referringContact ){
                    npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                    newRelationShip.npe4__Contact__c = convertedConId;
                    newRelationShip.npe4__Type__c = 'Medical Professional';
                    newRelationShip.Qualifying_Medical_Professional__c = true;
                    newRelationShip.npe4__RelatedContact__c = proccessSameContact.Id;
                    newRelationShip.npe4__Status__c = 'Active';
                    relationList.add(newRelationShip);
                    
                    
                }
                
                
            }*/
        }
        
        
        
        if(qualifyFirstNameSet.size() > 0 && qualifyLastNameSet.Size() > 0 && (qualifyPhoneNameSet.Size() > 0 || qualifyEmailNameSet.Size() > 0)){
            List<npe4__Relationship__c> qualifyingRelationList = new List<npe4__Relationship__c>();
            for(Lead processConvertedLead : convertedLeadMap.Values()){
                contact newMedicalcon = new contact();
                newMedicalcon.FirstName = processConvertedLead.Referrer_FirstName__c;
                newMedicalcon.LastName = processConvertedLead.Referrer_Last_Name__c;
                newMedicalcon.AccountId = processConvertedLead.ChapterName__c;
                newMedicalcon.Phone = processConvertedLead.Referrer_Phone__c;
                newMedicalcon.Email = processConvertedLead.Referrer_Email__c;
                newMedicalcon.Provider_Type__c  = processConvertedLead.Medical_Provider_Category__c;
                newMedicalcon.RecordTypeId = medicalProfessionalRecordTypeId;
                newMedicalcon.Region_Chapter__c = processConvertedLead.ChapterName__c;
                newMedicalcon.Migrated_Record__c = processConvertedLead.Migrated_Record__c;
                newMedicalcon.Type_Of_Contact__c = 'Referring';
                newContactList.add(newMedicalcon);
            }
            
            
           /* if(qualifyingContact.size() > 0){
                insert qualifyingContact;
                
                for(Contact proccessSameContact : qualifyingContact ){
                    npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                    newRelationShip.npe4__Contact__c = convertedConId;
                    newRelationShip.npe4__Type__c = 'Medical Professional';
                    newRelationShip.Referring_Medical_Professional__c = true;
                    newRelationShip.npe4__RelatedContact__c = proccessSameContact.Id;
                    newRelationShip.npe4__Status__c = 'Active';
                    relationList.add(newRelationShip);
                    
                }
                
            }*/
        } 
        
        
         if(bestPersonFirstNameSet.size() > 0 && bestPersonLastNameSet.Size() > 0){
            List<contact> bestPhysicanConList = new List<contact>();
            for(Lead processConvertedLead : convertedLeadMap.Values()){
                contact newMedicalcon = new contact();
                newMedicalcon.FirstName = processConvertedLead.Best_Contact_for_Physician_First_Name__c;
                newMedicalcon.LastName = processConvertedLead.Best_Contact_for_Physician_Last_Name__c;
                newMedicalcon.AccountId = processConvertedLead.ChapterName__c;
                newMedicalcon.Email = processConvertedLead.Best_contact_for_Physician_Email__c;
                newMedicalcon.Provider_Type__c  = processConvertedLead.Medical_Provider_Category__c;
                newMedicalcon.RecordTypeId = medicalProfessionalRecordTypeId;
                newMedicalcon.Region_Chapter__c = processConvertedLead.ChapterName__c;
                newMedicalcon.Migrated_Record__c = processConvertedLead.Migrated_Record__c;
                //newMedicalcon.Type_Of_Contact__c = '';
                newContactList.add(newMedicalcon);
            }
            
            
           /* if(bestPhysicanConList.size() > 0){
                insert bestPhysicanConList;
                
                for(Contact proccessSameContact : bestPhysicanConList){
                    npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                    newRelationShip.npe4__Contact__c = convertedConId;
                    newRelationShip.npe4__Type__c = 'Medical Professional';
                    newRelationShip.Referring_Medical_Professional__c = true;
                    newRelationShip.npe4__RelatedContact__c = proccessSameContact.Id;
                    newRelationShip.npe4__Status__c = 'Active';
                    relationList.add(newRelationShip);
                    
                }
                
            }*/
        } 
        
        
        if(newContactList.size() > 0)
        {
           insert newContactList;
        
              for(Contact currContact: newContactList)
              {
                        npe4__Relationship__c newRelationShip = new npe4__Relationship__c();
                        newRelationShip.npe4__Contact__c = convertedConId;
                        if(currContact.RecordTypeId == medicalProfessionalRecordTypeId)
                        {
                           newRelationShip.npe4__Type__c = 'Medical Professional';
                        }
                        else if(currContact.RecordTypeId == wishFamilyRecordTypeId)
                        {
                          newRelationShip.Hidden_isparentFirst__c = firstParentMap.get(currContact.FirstName+ '-' + currContact.LastName + '-' + currContact.Email+ '-' +currContact.Phone);
                          newRelationShip.npe4__Type__c = relationshipTypeMap.get(currContact.FirstName+ '-' + currContact.LastName + '-' + currContact.Email+ '-' +currContact.Phone);
                        }
                        if(currContact.Type_Of_Contact__c == 'Referring' || currContact.Type_Of_Contact__c == 'Parent/Guardian')
                           newRelationShip.Referring_Medical_Professional__c = true;
                        else if(currContact.Type_Of_Contact__c == 'Qualifing')
                           newRelationShip.Qualifying_Medical_Professional__c = true;
                        else if(currContact.Type_Of_Contact__c == 'Both')
                        {
                            newRelationShip.Referring_Medical_Professional__c = true;
                            newRelationShip.Qualifying_Medical_Professional__c = true;
                        }
                        newRelationShip.npe4__RelatedContact__c = currContact.Id;
                        newRelationShip.npe4__Status__c = 'Active';
                        relationList.add(newRelationShip);
                        
               }
        
        }
        
        if(relationList.size() > 0)
            insert relationList;
        
        if(updateaffiliationList.size() > 0)
            update updateaffiliationList;
        if(affiliationList.size() > 0)
            insert affiliationList;
        
    }
    public static void UpdateChatperName(Set<String> postalCodesSet,List<Lead> updateChapterOnLeadList)
    {
        System.debug('postalCodesSet>>>'+postalCodesSet);
        String postalString;
        Map<String,String> zipCodeChapterMap = new Map<String,String>();
        
        
        for(Zip_Code__c currZipCode :  [SELECT id, Name,Office__r.Chapter__c, Office__r.Referral_Email_Address__c FROM Zip_Code__c WHERE Name IN :postalCodesSet])
        {
            zipCodeChapterMap.put(currZipCode.Name,currZipCode.Office__r.Chapter__c);
            
        }
        
        
        
        for(Lead currLead : updateChapterOnLeadList)
        {
            if(String.valueOf(currLead.PostalCode).length() > 5 && String.valueOf(currLead.PostalCode).contains('-')) {
                postalString = String.valueOf(currLead.PostalCode).split('-')[0];
            } else {
                postalString = currLead.PostalCode;
            }
            
            if(zipCodeChapterMap.containsKey(postalString))
            {
                if(zipCodeChapterMap.get(postalString) != currLead.ChapterName__c) {
                    currLead.ChapterName__c = zipCodeChapterMap.get(postalString);
                }
                
            }
            else
            {
                //currLead.ChapterName__c = Null;
            }
        }
        
    }
    
    
    public static void UpdateChatperfields(Set<String> postalCodesSet,List<Lead> updateChapterOnLeadList)
    {
        Map<String,String> zipCodeChapterMap = new Map<String,String>();
        Map<String,String> zipCodeReferralMap = new Map<String,String>();
        Map<String,Boolean> chapterActiveMap = new Map<String,Boolean>();
        System.debug('Postal Codes >>>>>>>>> 1' + postalCodesSet );
        System.debug('Postal Codes >>>>>>>>> 2' + updateChapterOnLeadList);
        
        for(Zip_Code__c currZipCode :  [SELECT id, Name,Office__r.Chapter__c, Office__r.Referral_Email_Address__c FROM Zip_Code__c WHERE Name IN :postalCodesSet])
        {
            zipCodeChapterMap.put(currZipCode.Name,currZipCode.Office__r.Chapter__c);
            zipCodeReferralMap.put(currZipCode.Name,currZipCode.Office__r.Referral_Email_Address__c);
        }
        
        for(Account accdata: [select Id, Onboarded_on_SF__c from Account where id in : zipCodeChapterMap.values()]){
            chapterActiveMap.put(accdata.Id, accdata.Onboarded_on_SF__c);
        }
        
        for(Lead currLead : updateChapterOnLeadList)
        {
            if(zipCodeReferralMap.containsKey(currLead.PostalCode))
            {
                currLead.Office_Referral_Email__c= zipCodeReferralMap.get(currLead.PostalCode);
                
            }
            else  if(zipCodeReferralMap.containsKey(currLead.Referrer_Zip__c))
            {
                currLead.Office_Referral_Email__c= zipCodeReferralMap.get(currLead.Referrer_Zip__c);
                
            }
            else
            {
                currLead.Office_Referral_Email__c= Null;
            }
            
            if(chapterActiveMap.containsKey(currLead.ChapterName__c)){
                currLead.Is_Chapter_Active__c=chapterActiveMap.get(currLead.ChapterName__c);
            }
        }
        
    }
    
    Public static void ToUpdateMedicalInfo(Set<String> conditionDescriptionsSet,Set<String> icdCodesSet,List<Lead> leadUpdateToMedicalInfoList)
    {
        if(icdCodesSet.size() > 0)
        {   
            Map<Id, String> conditionInfoMap = new Map<Id, String>();
            Set<Id> conditionDescriptionIdSet = new Set<Id>();
            Map<String, ICD_Codes__c> icdCodesMap = new Map<String, ICD_Codes__c>();
            for(ICD_Codes__c currRec : [SELECT Id,Name, Condition_Description__r.MAW_Name__c,Group1__c,
                                        Condition_Description__c, Condition_Description__r.Code_to_Use__c,Condition_Description__r.Name
                                        FROM ICD_Codes__c WHERE Id IN :icdCodesSet])
            {
                icdCodesMap.put(currRec.Id,currRec);
                if(currRec.Condition_Description__c != null) {
                    conditionDescriptionIdSet.add(currRec.Condition_Description__c);
                }
                
            }
            Map<Id,Set<Id>> iCDforCondionDescMap = new Map<Id, Set<Id>>();
            for(ICD_Codes__c icdInfo : [SELECT Id, Condition_Description__c FROM ICD_Codes__c WHERE Condition_Description__c IN :conditionDescriptionIdSet]) {
                if(iCDforCondionDescMap.containsKey(icdInfo.Condition_Description__c)) {
                    iCDforCondionDescMap.get(icdInfo.Condition_Description__c).add(icdInfo.Id);
                } else {
                    iCDforCondionDescMap.put(icdInfo.Condition_Description__c, new Set<Id>{icdInfo.Id});
                }
            }
            for(Lead currLead : leadUpdateToMedicalInfoList)
            {
                if(icdCodesMap.containsKey(currLead.PD_ICD_Code__c ))
                {
                    //currLead.Short_Description__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Short_Description__c;
                    //currLead.Long_Description__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Long_Description__c;
                    //currLead.Group_1__c  = icdCodesMap.get(currLead.PD_ICD_Code__c).Group1__c ;
                    if(icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__c != Null)
                    {
                        currLead.PD_Condition_Description__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__r.Name;
                        currLead.Childs_Qualifying_Diagnosis__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__r.Code_to_Use__c;
                    } else {
                        currLead.PD_Condition_Description__c = '';
                        currLead.Childs_Qualifying_Diagnosis__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__r.Code_to_Use__c;
                    }
                }
                if(currLead.PD_ICD_Code__c != null) {
                    if(icdCodesMap.containsKey(currLead.PD_ICD_Code__c) && icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__c != null) {
                        currLead.Maw_Name__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__r.MAW_Name__c;
                        if(iCDforCondionDescMap.containsKey(icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__c)) {
                            if(iCDforCondionDescMap.get(icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__c).contains(currLead.PD_ICD_Code__c)) {
                                currLead.PD_Condition_Description__c = icdCodesMap.get(currLead.PD_ICD_Code__c).Condition_Description__r.Name;
                                
                            }
                        }
                    }
                }
            }
        }
        if(conditionDescriptionsSet.size() > 0)
        {
            Map<String, Condition_Description__c> descriptionMap = new Map<String, Condition_Description__c>();
            for(Condition_Description__c currRec : [SELECT Id, MAW_Name__c, Name FROM Condition_Description__C WHERE Name IN :conditionDescriptionsSet])
            {
                descriptionMap.put(currRec.Name,currRec);
            }
            for(Lead currLead : leadUpdateToMedicalInfoList)
            {
                if(descriptionMap.containsKey(currLead.PD_Condition_Description__c))
                {
                    currLead.Maw_Name__c = descriptionMap.get(currLead.PD_Condition_Description__c).MAW_Name__c;
                    
                }
            }
        }
        
    }
    
    public static void findDuplicateRecords(List<Lead> leadList)
    {
        
        Set<String> leadFNamesSet = new Set<String>();
        Set<String> leadLNamesSet = new Set<String>();
        Set<Date> leadbDaysSet = new Set<Date>();
        Set<String> AddressSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> zipCodesSet = new Set<String>();
        Set<String> citySet = new Set<String>();
        Set<String> emailsSet = new Set<String>();
        Set<String> stateSet = new Set<String>();
        Set<Id> leadIds = new Set<Id>();
        Set<String> chaptersSet = new Set<String>();
        
        set<String> exFNamesSet = new Set<String>();
        Set<String> exLNamesSet = new Set<String>();
        Set<Date> exbDaysSet = new Set<Date>();
        Set<String> exAddressSet = new Set<String>();
        Set<String> exphoneSet = new Set<String>();
        Set<String> exemailsSet = new Set<String>();
        
        List<lead> noDupLeadRec = new List<Lead>();
        Constant_Ac constant = new Constant_AC();
        String wishChild = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        
        String instanceUrl = label.Instance_Url;
        
        for(Lead currLead : leadList)
        {
            if(currLead.FirstName != Null)
                leadFNamesSet.add(currLead.FirstName);
            if(currLead.LastName != Null)
                leadLNamesSet.add(currLead.LastName);
            if(currLead.DOB__c != Null)
                leadbDaysSet.add(currLead.DOB__c);
            
            addressSet.add(currLead.City+'-'+currLead.State+'-'+currLead.PostalCode);
            if(currLead.PostalCode != Null)
                zipCodesSet.add(currLead.PostalCode);
            if(currLead.city!= Null)
                citySet.add(currLead.city);
            if(currLead.State!= Null)
                stateSet.add(currLead.State);
            if(currLead.Phone!= Null)
                phoneSet.add(currLead.Phone);
            if(currLead.Email!= Null)
                emailsSet.add(currLead.Email);
            
            chaptersSet.add(currLead.chapterName__c);
            if(currLead.id != Null)    
                leadIds.add(currLead.id);
            
            
            System.debug('lead Address++++++++++++++++++++++++' +currLead.FirstName+'-'+currLead.LastName+'-'+currLead.Phone+'-'+currLead.Email+'-'+ currLead.City+'-'+currLead.State+'-'+currLead.PostalCode);  
        }
        
        
        List<Lead> exLeads = [SELECT Id,LastName,Street,FirstName, Email, chapterName__c,Phone, DOB__c,
                              City,State,PostalCode FROM Lead 
                              WHERE (LastName IN :leadLNamesSet OR FirstName IN :leadFNamesSet OR DOB__c IN :leadbDaysSet
                                     OR Phone IN :phoneSet OR Email IN :emailsSet OR (State IN :stateSet AND Postalcode IN :zipCodesSet AND city IN :citySet)) 
                              AND ChapterName__c IN :chaptersSet
                              AND Id NOT IN :leadIds AND isConverted = false];
        
        
        List<Contact> exContacts = [SELECT Id, LastName,AccountId,MailingStreet,FirstName, Email, Phone, BirthDate,Region_Chapter__r.Name,
                                    MailingCity, MailingState, MailingPostalCode 
                                    FROM Contact WHERE (LastName IN :leadLNamesSet OR FirstName IN :leadFNamesSet OR BirthDate IN :leadbDaysSet
                                                        OR ((MailingState IN :stateSet AND MailingPostalCode IN :zipCodesSet AND MailingCity IN :citySet) OR 
                                                            Phone IN :phoneSet OR Email IN :emailsSet)) AND Region_Chapter__c =: chaptersSet AND RecordTypeId = :wishChild]; 
        
        
        
        for(Lead currLead : leadList)
        {
            boolean isDuplicate = false;
            for(Lead exLead : exLeads)
            {
                
                if(currLead.ChapterName__c == exLead.ChapterName__c)
                {
                    if(currLead.FirstName == exLead.FirstName && currLead.LastName == exLead.LastName)
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    } 
                    
                    else if((currLead.FirstName == exLead.FirstName || currLead.LastName == exLead.LastName) && 
                            ((currLead.Street == exLead.Street && currLead.State == exLead.State && currLead.City == exLead.City && currLead.PostalCode == exLead.PostalCode) 
                             || currLead.Phone == exLead.Phone || currLead.Email == exLead.Email))
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    }
                    
                    else if((currLead.DOB__c == exLead.DOB__c) && 
                            ((currLead.Street == exLead.Street && currLead.State == exLead.State && currLead.City == exLead.City && currLead.PostalCode == exLead.PostalCode) 
                             || currLead.Phone == exLead.Phone || currLead.Email == exLead.Email))
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    }
                    
                    else if((currLead.DOB__c == exLead.DOB__c) && (currLead.FirstName == exLead.FirstName || currLead.LastName == exLead.LastName))
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    }   
                    
                    
                }
            }
            
            for(Contact exCon : exContacts)
            {
                if(currLead.ChapterName__c == exCon.Region_Chapter__c)
                {
                    if(currLead.FirstName == exCon.FirstName && currLead.LastName == exCon.LastName)
                    { 
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    } 
                    
                    else if((currLead.FirstName == exCon.FirstName || currLead.LastName == exCon.LastName) && 
                            ((currLead.Street == exCon.MailingStreet && currLead.State == exCon.MailingState && currLead.City == exCon.MailingCity && currLead.PostalCode == exCon.MailingPostalCode) 
                             || currLead.Phone == exCon.Phone || currLead.Email == exCon.Email))
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    }
                    
                    else if((currLead.DOB__c == exCon.BirthDate) && 
                            ((currLead.Street == exCon.MailingStreet && currLead.State == exCon.MailingState && currLead.City == exCon.MailingCity && currLead.PostalCode == exCon.MailingPostalCode) 
                             || currLead.Phone == exCon.Phone || currLead.Email == exCon.Email))
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    }
                    
                    else if((currLead.DOB__c == exCon.BirthDate) && (currLead.FirstName == exCon.FirstName || currLead.LastName == exCon.LastName))
                    {
                        isDuplicate = True;
                        currLead.addError('There might be a duplicate Wish Child. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+currLead.id+'>here </a> to review the duplicates.',false); 
                    }   
                    
                    
                }
            }
            
            if(isDuplicate == false)
                noDupLeadRec.add(currLead);
            
        }                           
        
        if(noDupLeadRec.size() > 0)
        {
            FindDupContacts(noDupLeadRec);
        }                       
        
    } 
    
    public static void FindDupContacts(List<Lead> leadRecords)
    {
        Constant_AC  constant = new Constant_AC();
        Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id wishFamilyRT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id medicalProfessionalRT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
        
        Set<String> mProfessionalFName = new Set<String>();
        Set<String> mProfessionalLName = new Set<String>();
        Set<String> mProfessionalPhone = new Set<String>();
        Set<String> mProfessionalEmail = new Set<String>();
        
        Set<String> tProfessionalFName = new Set<String>();
        Set<String> tProfessionalLName = new Set<String>();
        Set<String> tProfessionalPhone = new Set<String>();
        Set<String> tProfessionalEmail = new Set<String>();
        
        Set<string> bestPhysicianFName = new Set<String>();
        Set<string> bestPhysicianLName = new Set<String>();
        Set<string> bestPhysicianEmail = new Set<String>();
         
        Set<String> leadFNamesSet = new Set<String>();
        Set<String> leadLNamesSet = new Set<String>();
        Set<Date> leadbDaysSet = new Set<Date>();
        Set<String> AddressSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> zipCodesSet = new Set<String>();
        Set<String> citySet = new Set<String>();
        Set<String> emailsSet = new Set<String>();
        Set<String> stateSet = new Set<String>();
        Set<Id> leadIds = new Set<Id>();
        Set<String> chaptersSet = new Set<String>();
        String instanceUrl = label.Instance_Url;
        
        for(Lead newLead : leadRecords)
        {
            mProfessionalFName.add(newLead.Medical_Professional_First_Name__c);
            mProfessionalLName.add(newLead.Medical_Professional_Last_Name__c);
            mProfessionalPhone.add(newLead.Medical_Professional_Phone__c);
            mProfessionalEmail.add(newLead.Medical_Professional_Email__c);
            
            tProfessionalFName.add(newLead.Treating_Medical_Professional_First_Name__c);
            tProfessionalLName.add(newLead.Treating_Medical_Professional_Last_Name__c);
            tProfessionalPhone.add(newLead.Treating_Medical_Professional_Phone__c);
            tProfessionalEmail.add(newLead.Treating_Medical_Professional_Email__c);
            
            leadFNamesSet.add(newLead.Parent_First_Name__c);
            leadLNamesSet.add(newLead.Parent_Last_Name__c);
            emailsSet.add(newLead.Email);
            phoneSet.add(newLead.Phone);
            zipCodesSet.add(newLead.PostalCode);
            stateSet.add(newLead.State);
            AddressSet.add(newLead.Street);
            citySet.add(newLead.City);
            leadbDaysSet.add(newLead.DOB__c);
            chaptersSet.add(newLead.chapterName__c);
            
            bestPhysicianFName.add(newLead.Best_contact_for_Physician_Email__c);
            bestPhysicianLName.add(newLead.Best_Contact_for_Physician_First_Name__c);
            bestPhysicianEmail.add(newLead.Best_Contact_for_Physician_Last_Name__c);
            
        }
        
        List<Contact> dupMedicalContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                                            MailingState, MailingPostalCode FROM Contact
                                            WHERE (FirstName IN :mProfessionalFName AND LastName IN :mProfessionalLName 
                                                   AND (Phone = :mProfessionalPhone Or Email IN :mProfessionalEmail) 
                                                   AND RecordTypeId = :MedicalProfessionalRT)];
        
        List<Contact> dupTreatingContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                                             MailingState, MailingPostalCode FROM Contact
                                             WHERE (FirstName IN :tProfessionalFName AND 
                                                    LastName IN :tProfessionalLName
                                                    AND (Phone = :tProfessionalPhone Or Email =: tProfessionalEmail) 
                                                    AND RecordTypeId = :MedicalProfessionalRT)]; 
       
       List<Contact> dupPhysicianContacts = [SELECT id,FirstName,LastName,Name,Email FROM Contact WHERE
                                                   FirstName IN :bestPhysicianFName AND LastName IN :bestPhysicianLName AND
                                                   Email IN:bestPhysicianEmail AND RecordTypeId = :MedicalProfessionalRT];
        
        List<Contact> dupFamilyContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                                           MailingState, MailingPostalCode,MailingStreet FROM Contact
                                           WHERE (FirstName IN :leadFNamesSet AND LastName IN :leadLNamesSet AND 
                                                  (((Email IN :emailsSet OR Phone IN :phoneSet) 
                                                    AND (MailingStreet IN :AddressSet AND MailingState IN :stateSet 
                                                         AND MailingPostalCode IN :zipCodesSet 
                                                         AND MailingCity IN :citySet))  
                                                   OR ((Phone IN :phoneSet OR (MailingStreet IN :AddressSet AND MailingState = :stateSet 
                                                                               AND MailingPostalCode IN :zipCodesSet 
                                                                               AND MailingCity = :citySet))
                                                       AND Email = :emailsSet)  OR (((MailingStreet = :AddressSet AND MailingState = :stateSet 
                                                                                      AND MailingPostalCode = :zipCodesSet 
                                                                                      AND MailingCity = :citySet) OR (Email = :emailsSet) )
                                                                                    AND Phone = :phoneSet))) AND RecordTypeId = :wishFamilyRT];  
        
        
        
        for(Lead newLead : leadRecords)
        { 
            Boolean medicalFlag = false;
            boolean treatingFlag = false;
            boolean familyFlag = false;
            boolean physicianFlag = false;
            for(Contact medicalCon : dupMedicalContacts)
            {
                if(medicalCon.FirstName == newLead.Medical_Professional_First_Name__c && 
                   medicalCon.LastName == newLead.Medical_Professional_Last_Name__c && 
                   (medicalCon.Phone == newLead.Medical_Professional_Phone__c || medicalCon.Email == newLead.Medical_Professional_Email__c))
                    
                {
                    
                    medicalFlag = true;
                }
                
            }  
            
            for(Contact treatingCon : dupTreatingContacts)
            {
                if(treatingCon.FirstName == newLead.Treating_Medical_Professional_First_Name__c && 
                   treatingCon.LastName == newLead.Treating_Medical_Professional_Last_Name__c && 
                   (treatingCon.Phone == newLead.Treating_Medical_Professional_Phone__c || treatingCon.Email == newLead.Treating_Medical_Professional_Email__c))
                    
                {
                    
                    treatingFlag = true;
                }
                
            }  
            
            for(Contact physicianCon : dupPhysicianContacts){
            
                if(physicianCon.FirstName == newLead.Best_Contact_for_Physician_First_Name__c && physicianCon.LastName == newLead.Best_Contact_for_Physician_Last_Name__c && physicianCon.Email== newLead.Best_Contact_for_Physician_Email__c ){
                    physicianFlag = True;   
                }
            }
            
            for(Contact familyCon : dupFamilyContacts)
            {
                if(familyCon.FirstName == newLead.Parent_First_Name__c && 
                   familyCon.LastName == newLead.Parent_Last_Name__c && 
                   (((familyCon.Phone == newLead.Phone || familyCon.Email == newLead.Email) && (familyCon.MailingStreet == newLead.Street
                                                                                                && familyCon.MailingState == newLead.State && familyCon.MailingCity == newLead.City 
                                                                                                && familyCon.MailingPostalCode == newLead.PostalCode)) || ((familyCon.Phone==newLead.Phone || (familyCon.MailingStreet == newLead.Street &&
                                                                                                                                                                                               familyCon.MailingState == newLead.State 
                                                                                                                                                                                               && familyCon.MailingPostalCode==newLead.PostalCode 
                                                                                                                                                                                               && familyCon.MailingCity == newLead.City))
                                                                                                                                                           && familyCon.Email == newLead.Email) || (((familyCon.MailingStreet == newLead.Street && familyCon.MailingState == newLead.State 
                                                                                                                                                                                                      && familyCon.MailingPostalCode == newLead.PostalCode 
                                                                                                                                                                                                      && familyCon.MailingCity == newLead.City) || (familyCon.Email == newLead.Email) )
                                                                                                                                                                                                    && familyCon.Phone == newLead.Phone)))
                    
                {
                    
                    familyFlag = true;
                }
                
            }  
            
            
            if((medicalFlag == True || treatingFlag == True) && familyFlag == True && physicianFlag == True) 
                newLead.addError('There might be an existing Wish Family and Medical Professional.Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+newlead.id+'&wishFamily=true&manual=true'+'>here </a> to review the existing record.',false); 
            else if(medicalFlag == True || treatingFlag == True)     
                newLead.addError('There might be an existing Medical Professional. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+newlead.id+'&wishFamily=true&manual=true'+'>here </a> to review the existing record.',false); 
            else if(physicianFlag){
                newLead.addError('There might be an existing Best Physician Contact. Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+newlead.id+'&wishFamily=true&manual=true'+'>here </a> to review the existing record.',false); 
            }
            else if(familyFlag == True)
                newLead.addError('There might be an existing Wish Family.Please click <a href='+instanceUrl+'/apex/LeadDuplicate_VF?id='+newlead.id+'&wishFamily=true&manual=true'+'>here </a> to review the existing record.',false); 
            
            
            
        }                        
        
    }
    
    public static void updateLeadOwner(List<Lead> leadsToupdateList, Set<String> chaptersSet)
    {
       Map<Id,Account> chapterMap = new Map<Id,Account>([SELECT id,Intake_Manager__c FROM Account WHERE id IN :chaptersSet]);
       System.debug('chapterMap++++++++++++++++++++ ' + chapterMap);
      
       for(Lead currLead : leadsToUpdateList)
       {
          
           if(chapterMap.containsKey(currLead.ChapterName__c))
            {
              System.debug('chapterMap.get(currLead.ChapterName__c).Intake_Manager__c++++++++++++++++ ' + chapterMap.get(currLead.ChapterName__c).Intake_Manager__c);
              if(chapterMap.get(currLead.ChapterName__c).Intake_Manager__c != Null)
                   currLead.OwnerId = chapterMap.get(currLead.ChapterName__c).Intake_Manager__c;
              else
                   currLead.OwnerId = label.Salesforce_Support_User_Id;
            }
          
       }
       
      
    }
    
    
    
    public void CreateNewCase(List<Lead> LeadList){
        List<Case> newCaseList = new List<Case>();
        
        Map<Id,String> accountEmailMap = new Map<Id,String>();
        set<Id> accountIdSet = new Set<Id>();
        Map<Id,String> emailMap = new Map<Id,String>();
        for(Lead process : LeadList){
            accountIdSet.add(process.ChapterName__c);
        }
        if(accountIdSet.size() > 0){
            for(Account dbChapterAcc : [SELECT Id,MAC_Email_del__c,RecordTypeId FROM Account WHERE Id IN:accountIdSet AND RecordTypeId =: chapterecordTypeId]){
                emailMap.put(dbChapterAcc.Id,dbChapterAcc.MAC_Email_del__c);
            }
        }
        for(Lead processLead : LeadList){
            case newcase = new case();
            newCase.status = 'Eligibility Review Pending';
            newCase.origin = 'Email';
            newCase.Subject = 'Eligibility Review';
            newCase.recordTypeId = partARecordTypeId;
            newCase.OwnerId = processLead.OwnerId;
            newCase.Hidden_Why_do_you_feel__c = processLead.Why_do_you_feel_would_be_eligible_Wish__c;
            if(emailMap.containsKey(processLead.ChapterName__c)){
                newCase.MAC_Email__c = emailMap.get(processLead.ChapterName__c);
            }
            newCase.Lead__c = processLead.id;
            newCase.AccountId = processLead.ChapterName__c;
            newCase.ChapterName__c = processLead.ChapterName__c;
            newCaseList.add(newcase);
        }
        
        if(newCaseList.Size() > 0)
            insert newCaseList;
    }
    public String getRandom()
    {
        Integer len=6;
        final String chars='0123456789';
        String randStr='';
        While(randStr.length() < len)
        {
            Integer idx=Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    
    /*  public void updateLeadStatus(List<Lead> medicalList){
System.debug('MedicalList>>>>>>>>>');
List<Lead> updateLeadList = new List<Lead>();
Lead newLead = new Lead();
for(Lead processMedicalQuestion :medicalList){
String medicalQuestion = processMedicalQuestion.Medical_Questions__c;
if(medicalQuestion.contains('Yes')){
System.debug('Yes>>>>>>>>>');
processMedicalQuestion.RFI_Form_Info_Hidden__c = 'Qualified';
updateLeadList.add(processMedicalQuestion);
}
else{
System.debug('No>>>>>>>>>');
processMedicalQuestion.RFI_Form_Info_Hidden__c = 'Not Qualified';
updateLeadList.add(processMedicalQuestion);
}
}
}*/
    
    
    /*public static void LeadRegionValidation(Map<Id, Lead> leadRegionCodeValidationMap){

Map<Id,Id> defaultRegionLeadMap = new Map<Id, Id>();
Set<Id> defualtRegionChapterSet = new Set<Id>();
for(Lead regionCheck : leadRegionCodeValidationMap.values()) {
defualtRegionChapterSet.add(regionCheck.ChapterName__c);
defaultRegionLeadMap.put(regionCheck.ChapterName__c, regionCheck.Id);
}

Set<Id> chapterRegionSet = new Set<Id>();
if(defualtRegionChapterSet.size() > 0) {
for(AggregateResult aggr : [SELECT Count(Id) cnt ,Chapter_Name__c cName FROM Regions__c WHERE Chapter_Name__c != null AND Chapter_Name__c IN : defualtRegionChapterSet GROUP BY Chapter_Name__c]) {
chapterRegionSet.add((Id)aggr.get('cName'));
}

if(chapterRegionSet.size() > 0) {
for(Lead inValidRegion : leadRegionCodeValidationMap.values()) {
if(!chapterRegionSet.contains(inValidRegion.ChapterName__c) && defaultRegionLeadMap.containsKey(inValidRegion.ChapterName__c)) {
if(leadRegionCodeValidationMap.containsKey(defaultRegionLeadMap.get(inValidRegion.ChapterName__c))) {
leadRegionCodeValidationMap.get(defaultRegionLeadMap.get(inValidRegion.ChapterName__c)).addError('Please select region that belongs to chapter'); 
}
}
}
}
}
}*/
    
    public static void populateRegionCode(Map<Id, Lead> leadMap, Set<Id> leadChapterSet) {
        
        Set<Id> chapterRegionSet = new Set<Id>();
        Set<Id> defaultchapterRegionSet = new Set<Id>();
        for(AggregateResult aggr : [SELECT Count(Id) cnt ,Chapter_Name__c cName FROM Regions__c WHERE Chapter_Name__c != null AND Chapter_Name__c IN : leadChapterSet GROUP BY Chapter_Name__c]) {
            chapterRegionSet.add((Id)aggr.get('cName'));
        }
        
        List<Regions__c> regionCodeList = [SELECT Id, Chapter_Name__c FROM Regions__c WHERE Chapter_Name__c = null LIMIT 1];
        
        for(Lead leadUpdate : leadMap.values()) {
            if(!chapterRegionSet.contains(leadUpdate.ChapterName__c)) {
                if(regionCodeList.size() > 0) {
                    leadUpdate.Region_Code__c = regionCodeList.get(0).Id;
                }
            }
        }
    }
    @future    
    public static void updateDocusignStatus(Map<Id, Id> leadContactMap) {
        List<dsfs__DocuSign_Status__c> docusignStatusList = new List<dsfs__DocuSign_Status__c>();
        for(dsfs__DocuSign_Status__c docusignStatus : [SELECT Id, dsfs__Lead__c, dsfs__Envelope_Status__c, dsfs__Contact__c FROM dsfs__DocuSign_Status__c WHERE dsfs__Lead__c IN : leadContactMap.keySet() AND dsfs__Subject__c = 'Diagnosis Verification Form']) {
            if(docusignStatus.dsfs__Contact__c == null) {
                docusignStatus.dsfs__Contact__c = leadContactMap.get(docusignStatus.dsfs__Lead__c);
                docusignStatusList.add(docusignStatus);
            }
        }
        
        if(docusignStatusList.size() > 0) {
            update docusignStatusList;
        }
    }
    //Create and assign the task to lead intake user when the lead status is updated with DNQ.
    public static void createTaskforDNQLeads(Map<Lead,Id> lead_ChapterIdMap){
        Constant_AC  constant = new Constant_Ac();
        Id staffTaskRT = Schema.SObjectType.Task.getRecordTypeInfosByName().get(constant.staffTaskRT).getRecordTypeId();
        Map<Id,Id> leadIntakeUserMap = new Map<Id,Id>();
        for(Account currRec : [SELECT Id,Intake_Manager__c FROM Account WHERE Id IN :lead_ChapterIdMap.Values()]){
            leadIntakeUserMap.put(currRec.Id,currRec.Intake_Manager__c);
        }
                
        Task newTask;
        List<Task> newTaskList = new List<Task>();
        for(Lead currLead:lead_ChapterIdMap.keyset()){
            newTask = new Task();
            newTask.Subject='Referral DNQ';
            newTask.ActivityDate=System.today().addDays(3);
            newTask.OwnerId=leadIntakeUserMap.get(currLead.ChapterName__c);
            newTask.WhoId=currLead.Id;
            newTask.RecordTypeId = staffTaskRT;
            newTaskList.add(newTask);
       }
       if(newTaskList.Size() > 0){
           Insert newTaskList;
       }
     
    }
    
    
    //Used to populated Condition Description based on ICD Code values
    public static void MatchConditionDescription(Map<Id, Set<Integer>> icdInfoMap, List<Lead> leadRecList, Set<Id> icdCodeRecSet) {
        Map<Id, ICD_Codes__c> icdCodeDetails = new Map<Id, ICD_Codes__c>();
        for(ICD_Codes__c icdInfo : [SELECT Id, Name, Group1__c,
                                    Condition_Description__c, Condition_Description__r.Code_to_Use__c, Condition_Description__r.Name
                                    FROM ICD_Codes__c WHERE Id IN : icdCodeRecSet]){
                                        icdCodeDetails.put(icdInfo.Id, icdInfo);
                                    }
        
        for(Lead updatePD : leadRecList) {
            if(icdInfoMap.containsKey(updatePD.Id)) {
                for(Integer icdField : icdInfoMap.get(updatePD.Id)) {
                    if(icdField == 1 && icdCodeDetails.containsKey(updatePD.SD1_ICD_Code__c)) {
                        updatePD.SD1_Condition_Description__c = icdCodeDetails.get(updatePD.SD1_ICD_Code__c).Condition_Description__r.Name;
                    } if(icdField == 2 && icdCodeDetails.containsKey(updatePD.SD2_ICD_Code__c)) {
                        updatePD.SD2_Condition_Description__c = icdCodeDetails.get(updatePD.SD2_ICD_Code__c).Condition_Description__r.Name;
                    } if(icdField == 3 && icdCodeDetails.containsKey(updatePD.SD3_ICD_Code__c)) {
                        updatePD.SD3_Condition_Description__c = icdCodeDetails.get(updatePD.SD3_ICD_Code__c).Condition_Description__r.Name;
                    } if(icdField == 4 && icdCodeDetails.containsKey(updatePD.SD4_ICD_Code__c)) {
                        updatePD.SD4_Condition_Description__c = icdCodeDetails.get(updatePD.SD4_ICD_Code__c).Condition_Description__r.Name;
                    }
                }
            }
        }
    }
    /*public static void CreateDiagnosisVerification(List<Lead> newLeadList, Set<String> conditionSescriptionSet) {
Map<String, Id> conditionDescriptionMap = new Map<String, Id>();
if(conditionSescriptionSet.size() > 0) {
for(Condition_Description__c condDes : [SELECT Id, Name FROM Condition_Description__c WHERE Name IN : conditionSescriptionSet]) {
conditionDescriptionMap.put(condDes.Name, condDes.Id);
} 
}

Map<Id,Id> diagnosisConditionMap = new Map<Id, Id>();
List<Diagnosis_Verification__c> diagnosisVerificationList = new List<Diagnosis_Verification__c>();
for(Lead newLead : newLeadList) {
Diagnosis_Verification__c newDiagnosis = new Diagnosis_Verification__c();
newDiagnosis.ICD_Code__c = newLead.PD_ICD_Code__c;
newDiagnosis.Lead__c = newLead.Id;
newDiagnosis.Primary_Diagnosis__c = newLead.PD_Condition_Description__c;
newDiagnosis.PCD_ICD__c = newLead.PCD_ICD__c;
newDiagnosis.Order__c = 0;
if(conditionDescriptionMap.containsKey(newLead.PD_Condition_Description__c)) {
newDiagnosis.Condition_Description__c = conditionDescriptionMap.get(newLead.PD_Condition_Description__c);
}
diagnosisConditionMap.put(newDiagnosis.Id,newDiagnosis.Condition_Description__c);
diagnosisVerificationList.add(newDiagnosis);
}
if(diagnosisVerificationList.size() > 0) {
insert diagnosisVerificationList;
}
}*/
}