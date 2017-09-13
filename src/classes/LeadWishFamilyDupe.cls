global class LeadWishFamilyDupe {

  webservice static String FindFamilyContactDupe(Id leadId){
        Constant_AC  constant = new Constant_AC();
        Id wishFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id wishFamilyRT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id medicalProfessionalRT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
       
        Lead currLead =  [SELECT Id, FirstName,Name,Of_Times_Email_Sent__c,LastName,Parent_Last_Name__c,Parent_First_Name__c, 
                             Email, DOB__c ,Phone,chapterName__c, 
                             City, State, Street, PostalCode, Medical_Professional_First_Name__c, Medical_Professional_Last_Name__c,
                             Medical_Professional_Phone__c, Medical_Professional_Email__c, Treating_Medical_Professional_First_Name__c,
                             Treating_Medical_Professional_Last_Name__c,Treating_Medical_Professional_Phone__c, Treating_Medical_Professional_Email__c , 
                             Best_contact_for_Physician_Email__c,Best_Contact_for_Physician_Last_Name__c ,Best_Contact_for_Physician_First_Name__c,
                             Additional_Parent_City__c,Additional_Parent_Email__c,Additional_Parent_First_Name__c,Additional_Parent_Last_Name__c,
                             Additional_Parent_Phone__c,Additional_Parent_Postal_Code__c,Additional_Parent_State__c,Additional_Parent_Street__c FROM Lead
                             WHERE id = :leadId limit 1];
                             
                             
        
        List<Contact> dupMedicalContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Medical_Professional_First_Name__c AND LastName = :currLead.Medical_Professional_Last_Name__c 
                         AND (Phone = :currLead.Medical_Professional_Phone__c Or Email =: currLead.Medical_Professional_Email__c) 
                         AND RecordTypeId = :MedicalProfessionalRT)];
                         
        List<Contact> dupTreatingContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Treating_Medical_Professional_First_Name__c AND 
                         LastName = :currLead.Treating_Medical_Professional_Last_Name__c 
                         AND (Phone = :currLead.Treating_Medical_Professional_Phone__c Or Email =: currLead.Treating_Medical_Professional_Email__c) 
                         AND RecordTypeId = :MedicalProfessionalRT)];
                         
      List<Contact> dupBestContactPhysicians = [SELECT id,FirstName,LastName,Email FROM Contact 
                         WHERE LastName =: currLead.Best_Contact_for_Physician_Last_Name__c AND FirstName=: currLead.Best_Contact_for_Physician_First_Name__c AND
                         Email=: currLead.Best_contact_for_Physician_Email__c AND  RecordTypeId = :MedicalProfessionalRT ]; 
                         
        List<Contact> dupFamilyContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
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
                               AND Phone = :currLead.Phone))) AND RecordTypeId = :wishFamilyRT];  
          List<Contact> dupAdditionalFamilyContacts = [SELECT id, FirstName,Name, LastName, Email, Phone, MailingCity, BirthDate,
                         MailingState, MailingPostalCode FROM Contact
                         WHERE (FirstName = :currLead.Additional_Parent_First_Name__c AND LastName = :currLead.Additional_Parent_Last_Name__c AND 
                               (((Email = :currLead.Additional_Parent_Email__c OR Phone = :currLead.Additional_Parent_Phone__c) 
                               AND (MailingStreet = :currLead.Additional_Parent_Street__c AND MailingState = :currLead.Additional_Parent_State__c
                               AND MailingPostalCode = :currLead.Additional_Parent_Postal_Code__c
                               AND MailingCity = :currLead.Additional_Parent_City__c))  
                               OR ((Phone = :currLead.Additional_Parent_Phone__c OR (MailingStreet = :currLead.Additional_Parent_Street__c  AND MailingState = :currLead.Additional_Parent_State__c
                               AND MailingPostalCode = :currLead.Additional_Parent_Postal_Code__c
                               AND MailingCity = :currLead.Additional_Parent_City__c))
                               AND Email = :currLead.Additional_Parent_Email__c )  OR (((MailingStreet = :currLead.Additional_Parent_Street__c AND MailingState = :currLead.Additional_Parent_State__c
                               AND MailingPostalCode = :currLead.Additional_Parent_Postal_Code__c
                               AND MailingCity = :currLead.Additional_Parent_City__c) OR (Email = :currLead.Additional_Parent_Email__c ) )
                               AND Phone = :currLead.Additional_Parent_Phone__c ))) AND RecordTypeId = :wishFamilyRT];  
           
                              
          if((dupMedicalContacts.size() > 0 || dupTreatingContacts.size() >0) && (dupFamilyContacts.size() > 0 || dupAdditionalFamilyContacts.Size() >0)) 
             return 'There might be an existing Wish Family and Medical Professional. Please click on [OK] to review the existing record.';                   
          else if(dupMedicalContacts.size() > 0 || dupTreatingContacts.size() >0)     
             return 'There might be an existing Medical Professional. Please click on [OK] to review the existing record.';
          else if(dupFamilyContacts.size() > 0)
             return 'There might be an existing Wish Family. Please click on [OK] to review the existing record.';
          else if(dupAdditionalFamilyContacts.Size() > 0)
             return 'There might be an existing Additional Parent/Guardian. Please click on [OK] to review the existing record.'; 
          else if(dupBestContactPhysicians.Size() > 0)
              return 'There might be an existing Best Physician Contact. Please click on [OK] to review the existing record.';
          else return null;
                         
                                                             
                         
  }
  
    webservice static String FindLeadDupe(Id leadId)
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
        
        String instanceUrl = label.Instance_Url;
        Constant_Ac constant = new Constant_AC();
        String wishChild = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
        
        List<Lead> leadList =  [SELECT Id, FirstName,Name,Of_Times_Email_Sent__c,LastName,Parent_Last_Name__c,Parent_First_Name__c, 
                             Email, DOB__c ,Phone,chapterName__c,
                             City, State, Street, PostalCode, Medical_Professional_First_Name__c, Medical_Professional_Last_Name__c,
                             Medical_Professional_Phone__c, Medical_Professional_Email__c, Treating_Medical_Professional_First_Name__c,
                             Treating_Medical_Professional_Last_Name__c,Treating_Medical_Professional_Phone__c, Treating_Medical_Professional_Email__c FROM Lead
                             WHERE id = :leadId AND isConverted = false limit 1];
        
       
        
       List<Lead> exLeads = [SELECT Id,LastName,Street,FirstName, Email, chapterName__c,Phone, DOB__c,
                             City,State,PostalCode FROM Lead 
                             WHERE (LastName = :leadList[0].LastName OR FirstName = :leadList[0].firstName OR DOB__c =:leadList[0].DOB__c
                             OR Phone =:leadList[0].Phone OR Email =:leadList[0].Email OR (State =:leadList[0].State AND Postalcode =:leadList[0].PostalCode AND city =:leadList[0].City)) 
                             AND ChapterName__c =:leadList[0].ChapterName__c
                             AND Id != :leadList[0].id AND isConverted = false];
                               
                               
       List<Contact> exContacts = [SELECT Id, LastName,AccountId,MailingStreet,FirstName, Email, Phone, BirthDate,Region_Chapter__r.Name,
                                   MailingCity, MailingState, MailingPostalCode
                                   FROM Contact WHERE (LastName =:leadList[0].LastName OR FirstName =:leadList[0].firstName OR BirthDate =:leadList[0].DOB__c
                                   OR ((MailingState =:leadList[0].State AND MailingPostalCode =:leadList[0].PostalCode AND MailingCity =:leadList[0].City) OR 
                                   Phone =:leadList[0].Phone OR Email =:leadList[0].Email)) AND Region_Chapter__c =: leadList[0].ChapterName__c AND RecordTypeId = :wishChild];   
        
        
       for(Lead currLead : leadList)
        {
         
           for(Lead exLead : exLeads)
           {
           
             if(currLead.ChapterName__c == exLead.ChapterName__c)
             {
              if(currLead.FirstName == exLead.FirstName && currLead.LastName == exLead.LastName)
              {
                return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
              } 
              
              else if((currLead.FirstName == exLead.FirstName || currLead.LastName == exLead.LastName) && 
                 ((currLead.Street == exLead.Street && currLead.State == exLead.State && currLead.City == exLead.City && currLead.PostalCode == exLead.PostalCode) 
                 || currLead.Phone == exLead.Phone || currLead.Email == exLead.Email))
               {
                 return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
                 
               }
               
               else if((currLead.DOB__c == exLead.DOB__c) && 
                 ((currLead.Street == exLead.Street && currLead.State == exLead.State && currLead.City == exLead.City && currLead.PostalCode == exLead.PostalCode) 
                 || currLead.Phone == exLead.Phone || currLead.Email == exLead.Email))
                  {
                     return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
                  }
                  
               else if((currLead.DOB__c == exLead.DOB__c) && (currLead.FirstName == exLead.FirstName || currLead.LastName == exLead.LastName))
               {
                  return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
               }   
                  
               
             }
           }
           
           for(Contact exCon : exContacts)
           {
               if(currLead.ChapterName__c == exCon.Region_Chapter__c)
                 {
                  if(currLead.FirstName == exCon.FirstName && currLead.LastName == exCon.LastName)
                  { 
                     return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
                  } 
                  
                  else if((currLead.FirstName == exCon.FirstName || currLead.LastName == exCon.LastName) && 
                     ((currLead.Street == exCon.MailingStreet && currLead.State == exCon.MailingState && currLead.City == exCon.MailingCity && currLead.PostalCode == exCon.MailingPostalCode) 
                     || currLead.Phone == exCon.Phone || currLead.Email == exCon.Email))
                   {
                     return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
                   }
                   
                   else if((currLead.DOB__c == exCon.BirthDate) && 
                     ((currLead.Street == exCon.MailingStreet && currLead.State == exCon.MailingState && currLead.City == exCon.MailingCity && currLead.PostalCode == exCon.MailingPostalCode) 
                     || currLead.Phone == exCon.Phone || currLead.Email == exCon.Email))
                      {
                        return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
                      }
                      
                   else if((currLead.DOB__c == exCon.BirthDate) && (currLead.FirstName == exCon.FirstName || currLead.LastName == exCon.LastName))
                   {
                     return 'There might be a duplicate Wish Child. Please click [OK] to review the duplicates.';
                   }   
                      
                   
                 }
              }
        
          
         }                               
        
        return null;
    } 
    
}