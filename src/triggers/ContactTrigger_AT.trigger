/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : ContactTrigger_AT is used to assign the account Name for Volunteer contact. Based on the current logged in user role.
Updating Affiliation status based on the application status.
*****************************************************************************************************/

trigger ContactTrigger_AT on Contact(Before Insert, after insert, Before Update,After update,After delete, Before delete) {
    
    string userId = UserInfo.getUserId();
    Constant_AC  constant = new Constant_AC();
    Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
    Id wichChildRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.contactWishChildRT).getRecordTypeId();
    Id familyContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    Id MedicalProfContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
    Id boardMemberRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.boardMemberRT).getRecordTypeId();
    List<Contact> contactList= new List<Contact>();
    Set<Id> volunteerIdSet = new Set<Id>();
    Map<String, String> monthValMap = new Map<String, String>();
    monthValMap.put('January','1');
    monthValMap.put('February','2');
    monthValMap.put('March','3');
    monthValMap.put('April','4');
    monthValMap.put('May','5');
    monthValMap.put('June','6');
    monthValMap.put('July','7');
    monthValMap.put('August','8');
    monthValMap.put('September','9');
    monthValMap.put('October','10');
    monthValMap.put('November','11');
    monthValMap.put('December','12');
    
    
    // Birthdate concatenation.
    if(Trigger.isBefore && Trigger.isInsert)
    {
        for(Contact newContact : Trigger.new)
        {
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
            {
                if(newContact.RecordTypeId == volunteerRecordTypeId){
                    contactList.add(newContact );
                    newContact.Region_Chapter__c = newContact.AccountId;
                }
                
                if(newContact.birth_day__c != Null && newContact.birth_year__c != Null && newContact.birth_month__c != Null)
                {
                    date dtConverted = Date.valueOf(newContact.birth_year__c+'-'+monthValMap.get(newContact.birth_month__c)+'-'+newContact.birth_day__c);
                    newContact.BirthDate = dtConverted ;
                }
            }
            system.debug('%BeforeInsert MailingCountry 1%'+newContact.MailingState);
           
                //newContact.MailingCountry = 'United States';
                //newContact.OtherCountry = 'United States';
           system.debug('%BeforeInsert MailingCountry 2%'+newContact.MailingState);
        }
    }
    // Birthdate concatenation at before update.
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        Set<Id> wishChildIdSet = new Set<Id>();
        Map<Id,Contact> wishFamilyMap = new Map<Id,Contact>();
        Set<Id> wishFamliySet = new Set<Id>();
        set<Id> recallWishChild = new Set<Id>();
        List<Account> accList = new List<Account>();
        Map<Id,Account> houseHoldAccountMap = new Map<Id,Account>();
        Set<Id> icdCodeInfoIdSet = new Set<Id>();
        Map<Id, Set<Integer>> icdInfoMap = new Map<Id, Set<Integer>>();
        List<Contact> conICDList = new List<Contact>();
        for(Contact newContact : Trigger.new)
        { 
            
             system.debug('%BeforeInsert MailingCountry 3%'+newContact.MailingState);
                //newContact.MailingCountry = 'United States';
                //newContact.OtherCountry = 'United States';
           
            
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
            {
                if(newContact.SD1_ICD_Code__c != Trigger.oldMap.get(newContact.Id).SD1_ICD_Code__c && newContact.SD1_ICD_Code__c != null) {
                    icdCodeInfoIdSet.add(newContact.SD1_ICD_Code__c);
                    conICDList.add(newContact);
                    if(icdInfoMap.containsKey(newContact.Id)) {
                        icdInfoMap.get(newContact.Id).add(1);
                    } else {
                        icdInfoMap.put(newContact.Id, new Set<Integer>{1});
                    }
                }
                //To update Secondary Diagnosis2 if ICD Code2 value is changed
                if(newContact.SD2_ICD_Code__c != Trigger.oldMap.get(newContact.Id).SD2_ICD_Code__c && newContact.SD2_ICD_Code__c != null) {
                    icdCodeInfoIdSet.add(newContact.SD2_ICD_Code__c);
                    conICDList.add(newContact);
                    if(icdInfoMap.containsKey(newContact.Id)) {
                        icdInfoMap.get(newContact.Id).add(2);
                    } else {
                        icdInfoMap.put(newContact.Id, new Set<Integer>{2});
                    }
                }
                //To update Secondary Diagnosis3 if ICD Code3 value is changed
                if(newContact.SD3_ICD_Code__c != Trigger.oldMap.get(newContact.Id).SD3_ICD_Code__c && newContact.SD3_ICD_Code__c != null) {
                    icdCodeInfoIdSet.add(newContact.SD3_ICD_Code__c);
                    conICDList.add(newContact);
                    if(icdInfoMap.containsKey(newContact.Id)) {
                        icdInfoMap.get(newContact.Id).add(3);
                    } else {
                        icdInfoMap.put(newContact.Id, new Set<Integer>{3});
                    }
                }
                //To update Secondary Diagnosis4  if ICD Code4 value is changed
                if(newContact.SD4_ICD_Code__c != Trigger.oldMap.get(newContact.Id).SD4_ICD_Code__c && newContact.SD4_ICD_Code__c != null) {
                    icdCodeInfoIdSet.add(newContact.SD4_ICD_Code__c);
                    conICDList.add(newContact);
                    if(icdInfoMap.containsKey(newContact.Id)) {
                        icdInfoMap.get(newContact.Id).add(4);
                    } else {
                        icdInfoMap.put(newContact.Id, new Set<Integer>{4});
                    }
                }
                
                 //To update Secondary Diagnosis4  if ICD Code4 value is changed
                if(newContact.ICD_10_Code__c != Trigger.oldMap.get(newContact.Id).ICD_10_Code__c && newContact.ICD_10_Code__c != null) {
                    icdCodeInfoIdSet.add(newContact.ICD_10_Code__c);
                    conICDList.add(newContact);
                    if(icdInfoMap.containsKey(newContact.Id)) {
                        icdInfoMap.get(newContact.Id).add(5);
                    } else {
                        icdInfoMap.put(newContact.Id, new Set<Integer>{5});
                    }
                }
                
                
                if(newContact.RecordTypeId == volunteerRecordTypeId && newContact.RecordTypeId != Trigger.oldMap.get(newContact.Id).RecordTypeId){
                   newContact.AccountId = newContact.Region_Chapter__c;   
                }
                if(newContact.Birth_Month__c != Null && newContact.Birth_Day__c != Null && newContact.Birth_Year__c != Null)
                {
                    if(newContact.Birth_Year__c != trigger.oldmap.get(newContact.Id).Birth_Year__c || newContact.Birth_Month__c != trigger.oldmap.get(newContact.Id).Birth_Month__c || newContact.Birth_Day__c != trigger.oldmap.get(newContact.Id).Birth_Day__c )
                    {
                        contactList.add(newContact );
                    }
                    if(newContact.birth_day__c != Null && newContact.birth_year__c != Null && newContact.birth_month__c != Null)
                    {
                        date dtConverted = Date.valueOf(newContact.birth_year__c+'-'+monthValMap.get(newContact.birth_month__c)+'-'+newContact.birth_day__c);
                        newContact.BirthDate = dtConverted ;
                    }
                }
                
                
                 if(newContact.RecordTypeId == volunteerRecordTypeId || newContact.RecordTypeId == boardMemberRT)
                 {
                 
                    if(newContact.is_Active_Volunteer__c == false && (newContact.Active_Board_Member__c == True || newContact.Active_Non_Wish_Granter__c==True
                            || newContact.Active_Single_Day_Event_Volunteer__c == True || newContact.Active_Wish_Granter__c == True))
                    {
                        newContact.is_Active_Volunteer__c = True;
                    }  
                    
                    if(newContact.is_Active_Volunteer__c == True && (newContact.Active_Board_Member__c == false && newContact.Active_Non_Wish_Granter__c==false
                            && newContact.Active_Single_Day_Event_Volunteer__c == false && newContact.Active_Wish_Granter__c == false))
                    {
                        newContact.is_Active_Volunteer__c = false;
                    } 
                 
                 }
                
                if(newContact.RecordTypeId == wichChildRecordTypeId && newContact.IsContactInfoUpdated__c == true)
                {
                    if(newContact.Hidden_First_Name__c != Null)
                    {
                        newContact.FirstName =  newContact.Hidden_First_Name__c;
                        newContact.Hidden_First_Name__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_Last_Name__c != Null)
                    {
                        newContact.LastName  =  newContact.Hidden_Last_Name__c;
                        newContact.Hidden_Last_Name__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_Phone__c != Null){
                        newContact.Phone =   newContact.Hidden_Phone__c; 
                        newContact.Hidden_Phone__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.HiddenOtherPhone__c!= Null){
                        newContact.OtherPhone =   newContact.HiddenOtherPhone__c; 
                        newContact.HiddenOtherPhone__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.HiddenMobilePhone__c!= Null){
                        newContact.MobilePhone =   newContact.HiddenMobilePhone__c; 
                        newContact.HiddenMobilePhone__c= Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_Email__c != Null){
                        newContact.Email  =   newContact.Hidden_Email__c;
                        newContact.Hidden_Email__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    } 
                    if(newContact.Hidden_Street__c != Null){
                        newContact.MailingStreet =   newContact.Hidden_Street__c; 
                        newContact.Hidden_Street__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_city__c != Null){
                        newContact.MailingCity =   newContact.Hidden_city__c;
                        newContact.Hidden_city__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_State__c != Null){
                        newContact.MailingState =   newContact.Hidden_State__c; 
                        newContact.Hidden_State__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_Country__c != Null){
                        newContact.MailingCountry =   newContact.Hidden_Country__c;
                        newContact.Hidden_Country__c  = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    if(newContact.Hidden_Zip_Code__c != Null){
                        newContact.MailingPostalCode =   newContact.Hidden_Zip_Code__c; 
                        newContact.Hidden_Zip_Code__c = Null;
                        newContact.IsContactInfoUpdated__c = false;
                        
                    }
                    else{
                        wishChildIdSet.add(newContact.Id);
                        newContact.IsContactInfoUpdated__c = false;
                    }
                    
                }
                
                if(newContact.RecordTypeId == wichChildRecordTypeId && newContact.IsRejected_Contact_Info__c == true || newContact.isRecall_Contact_Info__c == true)
                {
                    if(newContact.Hidden_First_Name__c != Null || newContact.Hidden_Last_Name__c != Null ||  newContact.Hidden_Phone__c != Null|| 
                       newContact.Hidden_Email__c != Null || newContact.Hidden_Street__c != Null ||  newContact.Hidden_State__c != Null || 
                       newContact.Hidden_Country__c != Null ||   newContact.Hidden_Zip_Code__c != Null ||  newContact.Hidden_city__c != Null){ 
                           
                           newContact.Hidden_First_Name__c = Null;
                           newContact.Hidden_Last_Name__c = Null;
                           newContact.Hidden_Phone__c = Null;
                           newContact.Hidden_Email__c = Null;
                           newContact.Hidden_Street__c = Null;
                           newContact.Hidden_State__c = Null;
                           newContact.Hidden_Country__c  = Null;
                           newContact.Hidden_Zip_Code__c = Null;
                           newContact.Hidden_city__c = Null;
                       }
                    else
                    {
                        recallWishChild .add(newContact.Id);
                        newContact.IsRejected_Contact_Info__c  = false;
                        newContact.isRecall_Contact_Info__c = false;
                    }
                }
            } 
            
             system.debug('%BeforeInsert MailingCountry 4%'+newContact.MailingState);
        }
         
        if(wishChildIdSet.size() > 0 && RecursiveTriggerHandler.accountRecursive == true)
        {
          RecursiveTriggerHandler.accountRecursive = false;
            for(npe4__Relationship__c dbRelationShip : [SELECT Id,npe4__Contact__c,npe4__RelatedContact__c FROM npe4__Relationship__c WHERE npe4__Contact__c IN: wishChildIdSet AND npe4__RelatedContact__r.RecordTypeId =: familyContactRecordTypeId]){
                wishFamliySet.add(dbRelationShip.npe4__RelatedContact__c);  
                
            }
            
            for(Contact dbWishFamily : [SELECT Id,Name,FirstName,LastName,Phone,Email,MailingStreet,MailingCity,AccountId,Account.npe01__SYSTEM_AccountType__c,Hidden_Use_as_Household_Address__c,Use_as_Household_Address__c,MailingState,MailingCountry,MailingPostalCode,Hidden_First_Name__c,
                                        Hidden_Last_Name__c,Hidden_Street__c,Hidden_Phone__c ,Hidden_Email__c,Hidden_city__c,
                                        Hidden_State__c,Hidden_Country__c,Hidden_Zip_Code__c,Same_as_Household_Address__c,Hidden_Same_Address__c,OtherPhone,MobilePhone,HiddenMobilePhone__c,HiddenOtherPhone__c From Contact WHERE Id IN: wishFamliySet])
            {
               
              
               
                if(dbWishFamily.Hidden_Use_as_Household_Address__c == true){
                   dbWishFamily.Use_as_Household_Address__c = true;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
               }
               if(dbWishFamily.Hidden_Use_as_Household_Address__c == false){
                   dbWishFamily.Use_as_Household_Address__c = false;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
               }
                
                if(dbWishFamily.Hidden_First_Name__c != Null){
                    dbWishFamily .FirstName =  dbWishFamily.Hidden_First_Name__c;
                    
                    dbWishFamily.Hidden_First_Name__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_Last_Name__c != Null){
                    dbWishFamily.LastName  =  dbWishFamily.Hidden_Last_Name__c;
                    dbWishFamily.Hidden_Last_Name__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_Phone__c != Null){
                    dbWishFamily.Phone =   dbWishFamily.Hidden_Phone__c; 
                    dbWishFamily.Hidden_Phone__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.HiddenMobilePhone__c != Null){
                    dbWishFamily.MobilePhone=   dbWishFamily.HiddenMobilePhone__c; 
                    dbWishFamily.HiddenMobilePhone__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.HiddenOtherPhone__c != Null){
                    dbWishFamily.otherPhone =   dbWishFamily.HiddenOtherPhone__c; 
                    dbWishFamily.HiddenOtherPhone__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_Email__c != Null){
                    dbWishFamily.Email  =   dbWishFamily.Hidden_Email__c;
                    dbWishFamily.Hidden_Email__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_Street__c != Null){
                      
                    dbWishFamily.MailingStreet =   dbWishFamily.Hidden_Street__c; 
                    dbWishFamily.Hidden_Street__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_city__c != Null){
                  
                    dbWishFamily.MailingCity =   dbWishFamily.Hidden_city__c;
                    dbWishFamily.Hidden_city__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_State__c != Null){
                   
                    dbWishFamily.MailingState =   dbWishFamily.Hidden_State__c; 
                    dbWishFamily.Hidden_State__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_Country__c != Null ){
                  
                    dbWishFamily.MailingCountry =   dbWishFamily.Hidden_Country__c;
                    dbWishFamily.Hidden_Country__c  = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                if(dbWishFamily.Hidden_Zip_Code__c != Null){
                   
                    dbWishFamily.MailingPostalCode =   dbWishFamily.Hidden_Zip_Code__c; 
                    dbWishFamily.Hidden_Zip_Code__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                
                if(dbWishFamily.Hidden_Use_as_Household_Address__c == true){
                     Account newAcc = new Account();
                     newAcc.Id = dbWishFamily.AccountId;
                     newAcc.BillingStreet = dbWishFamily.MailingStreet;
                     newAcc.BillingCity = dbWishFamily.MailingCity;
                     newAcc.BillingState = dbWishFamily.MailingState;
                     newAcc.BillingCountry = dbWishFamily.MailingCountry;
                     newAcc.BillingPostalCode = dbWishFamily.MailingPostalCode;
                     dbWishFamily.Use_as_Household_Address__c = true;
                     dbWishFamily.Hidden_Use_as_Household_Address__c = false;
                     
                     wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                     houseHoldAccountMap.put(newAcc.Id,newAcc);
                }
                if(dbWishFamily.Hidden_Same_Address__c == true){
                     dbWishFamily.Same_as_Household_Address__c  = true;
                     dbWishFamily.Hidden_Same_Address__c = false;
                     wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
                
                if(dbWishFamily.Hidden_Same_Address__c == false){
                     dbWishFamily.Same_as_Household_Address__c  = false;
                    
                     wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                }
              
            }
           
                
            if(wishFamilyMap.size() > 0)
                update wishFamilyMap.Values();
              if(houseHoldAccountMap.size() > 0)
           
                update houseHoldAccountMap.Values();
                  
        }
        
        
        
        if(recallWishChild.size() > 0)
        {
            for(npe4__Relationship__c dbRelationShip : [SELECT Id,npe4__Contact__c,npe4__RelatedContact__c FROM npe4__Relationship__c WHERE npe4__Contact__c IN: recallWishChild AND npe4__RelatedContact__r.RecordTypeId =: familyContactRecordTypeId]){
                
                wishFamliySet.add(dbRelationShip.npe4__RelatedContact__c);  
                
            }
            for(Contact dbWishFamily : [SELECT Id,Name,FirstName,LastName,Phone,Email,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,Hidden_First_Name__c,
                                        Hidden_Last_Name__c,Hidden_Street__c,Hidden_Phone__c ,Hidden_Email__c ,Hidden_city__c ,Hidden_State__c,Hidden_Country__c,Hidden_Zip_Code__c  From Contact WHERE Id IN: wishFamliySet])
            {
                if(dbWishFamily.Hidden_First_Name__c != Null || dbWishFamily .Hidden_Last_Name__c != Null ||  dbWishFamily.Hidden_Phone__c != Null|| 
                   dbWishFamily.Hidden_Email__c != Null || dbWishFamily .Hidden_Street__c != Null ||  dbWishFamily.Hidden_State__c != Null || 
                   dbWishFamily.Hidden_Country__c != Null ||   dbWishFamily .Hidden_Zip_Code__c != Null ||  dbWishFamily.Hidden_city__c != Null)
                { 
                    
                    dbWishFamily.Hidden_First_Name__c = Null;
                    dbWishFamily.Hidden_Last_Name__c = Null;
                    dbWishFamily.Hidden_Phone__c = Null;
                    dbWishFamily.Hidden_Email__c = Null;
                    dbWishFamily.Hidden_Street__c = Null;
                    dbWishFamily.Hidden_State__c = Null;
                    dbWishFamily.Hidden_Country__c  = Null;
                    dbWishFamily.Hidden_Zip_Code__c = Null;
                    dbWishFamily.Hidden_city__c = Null;
                    wishFamilyMap.put(dbWishFamily.Id,dbWishFamily);
                    
                }
                
            }
            
           
            
            if(wishFamilyMap.size() > 0)
                update wishFamilyMap.Values();
            
        }
        if(icdInfoMap.size() > 0) {
            ContactTriggerHandler.MatchConditionDescription(icdInfoMap,conICDList,icdCodeInfoIdSet);
        }
        
    }
    
    
    
    // Affiliation Status update whenever Application status is changed.
    // creating task for volunteer manager whenever zipcode has been changed.
    // Whenever volunteer role has been changed on volunteer role field, volunteer rold record has created/deleted based on that.
    // This after update trigger is used to update the wish child contact's recipient name and email if it is changed in related contact
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<Contact> conList = new List<Contact>();
        Map<Id,Contact> contactAccountIdMap = new Map<Id,Contact>();
        Map<String,List<Contact>> contactMapforSharing = new Map<String,List<Contact>>();
        
        for(Contact conCurrRec: [SELECT Id,migrated_record__c, AccountId,RecordTypeId,Region_Chapter__c, 
                                Region_Chapter__r.Name,MailingState FROM Contact WHERE Id IN :Trigger.newMap.keySet()])
        {
            
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
            {
               /* if(conCurrRec.RecordTypeId == volunteerRecordTypeId || conCurrRec.RecordTypeId == boardMemberRT)
                {
                    contactAccountIdMap.put(conCurrRec.id,conCurrRec);
                }
                else
                {
                   // if(RecursiveTriggerHandler.isFirstTime == true ) 
                    conList.Add(conCurrRec);
                } */
                 conList.Add(conCurrRec);
            }
            
            if(conCurrRec.Region_Chapter__c!= Null)
            {
               if(contactMapforSharing.containsKey(conCurrRec.Region_Chapter__r.Name))
                   contactMapforSharing.get(conCurrRec.Region_Chapter__r.Name).add(conCurrRec);
               else
                   contactMapforSharing.put(conCurrRec.Region_Chapter__r.Name, new List<contact>{conCurrRec});
                  
            }
            system.debug('%BeforeInsert MailingCountry 5%'+conCurrRec.MailingState);
            
        }
        
        //if(contactMapforSharing.size() > 0)
          //ChapterStaffRecordSharing_AC.ContactSharing(contactMapforSharing);
        
        if(conList.size() > 0){
            ContactTriggerHandler.CreateAffliation(conList);
        }
      /*  if(contactAccountIdMap.size() > 0){
            ContactTriggerHandler.updateAffiliation(contactAccountIdMap);
        }*/
        
        
        
    }
   
    if(Trigger.isAfter && Trigger.isupdate)
    {
        system.debug('************ Inside after update');
        set<Id> volunteercontactSet = new Set<Id>();
        Map<Id,Contact> volunteerContactMap = new Map<Id,Contact>();
        Set<Id> rejectedApplicationIds = new Set<Id>();
        Map<Id,Contact> updateEmailContactMap = new Map<Id,Contact>();
        //list<Contact> updateEmailContact = new list<Contact>();
        Set<String> zipCodesSet = new Set<String>();
        Map<Id,Contact> contactMap = new Map<Id, Contact>();
        set<string> contactIdsForEmailChange = new set<string>();
        map<string,contact> m1 = new map<string,contact>();
        map<string,Contact> updateUserInfo = new map<string,Contact>();
        Map<Id, Contact> contactOldMap = new Map<Id, Contact>();
        Set<Id>  MedicalProfContactSet = new Set<Id>();
        Set<Id> addressSet = new Set<Id>();
        Map<Id,Contact> wishFamilyContacMap = new Map<Id,Contact>();
        map<id,Contact> wishChilPhotoMap = new map<id,Contact>();
        List<Contact> conList = new List<Contact>();
        Set<Id> contactIdSet = new Set<Id>();
        
        Contact updatedCon;
        for(Contact newContact : trigger.new)
        {
               if(newContact.recordTypeId == volunteerRecordTypeId && trigger.oldMap.get(newContact.Id).recordTypeId != volunteerRecordTypeId){
                   conList.add(newContact);    
               }
                
                
               /* if(newContact.recordTypeId == wichChildRecordTypeId && trigger.oldMap.get(newContact.Id).recordTypeId == familyContactRecordTypeId ){
                    contactIdSet.add(newContact.Id);
                }*/
              /*  if(newContact.Wish_Child_Photo__c != Null && trigger.oldmap.get(newContact.id).Wish_Child_Photo__c != newContact.Wish_Child_Photo__c){
                    wishChilPhotoMap.put(newContact.id, newContact);
                }*/
                if(newContact.is_Application__c == 'Complete' && newContact.is_Application__c != trigger.oldmap.get(newContact.id).is_Application__c){
                    volunteercontactSet.add(newContact.Id);
                    
                }
                if(newContact.is_Application__c == 'Rejected' && newContact.is_Application__c != trigger.oldmap.get(newContact.id).is_Application__c)
                {
                    rejectedApplicationIds.add(newContact.id);
                }
                
                if(newContact.recordTypeId == MedicalProfContactRecordTypeId  &&(newContact.Name != trigger.oldMap.get(newContact.Id).Name||
                                                                                 newContact.Email!= trigger.oldMap.get(newContact.Id).Email)){
                                                                                     
                                                                                     MedicalProfContactSet.add(newContact.Id);
                                                                                 }
                
                if((newContact.recordTypeId == volunteerRecordTypeId) && newContact.Volunteer_Role__c != Null && (newContact.Volunteer_Role__c != Trigger.oldMap.get(newContact.id).Volunteer_Role__c))
                {
                    volunteerContactMap.put(newContact.id, newContact);
                }
                
                if(newContact.MailingPostalCode != Trigger.oldMap.get(newContact.id).MailingPostalCode && newContact.RecordTypeId == volunteerRecordTypeId && newContact.MailingAddressVerified__c == false)
                {
                    contactMap.put(newContact.id, newContact);
                    if(newContact.MailingPostalCode != null && String.valueOf(newContact.MailingPostalCode).length() > 5 && String.valueOf(newContact.MailingPostalCode).contains('-')) {
                        zipCodesSet.add(String.valueOf(newContact.MailingPostalCode).split('-')[0]);
                    } else {
                        zipCodesSet.add(newContact.MailingPostalCode);
                    }
                    
                }
                if(newContact.Email != Null && trigger.oldMap.get(newContact.id).Email != newContact.Email && trigger.oldMap.get(newContact.id).Email != Null){
                    
                    contactIdsForEmailChange.add(newContact.id);
                    string temp,fname,lname;
                    fname= trigger.oldMap.get(newContact.id).Firstname != null ? trigger.oldMap.get(newContact.id).Firstname :'';
                    temp= fname+' '+trigger.oldMap.get(newContact.id).lastname+'-'+trigger.oldMap.get(newContact.id).email;
                    m1.put(temp,newContact);                       
                    
                }
                
                if(newContact.Same_as_Household_Address__c != trigger.oldMap.get(newContact.Id).Same_as_Household_Address__c && newContact.Same_as_Household_Address__c == true){
                    addressSet.add(newContact.Id);
                }
           
            if((newContact.RecordTypeId == volunteerRecordTypeId) && (newContact.FirstName != Null && trigger.oldMap.get(newContact.id).FirstName != newContact.FirstName) || (newContact.LastName != Null && trigger.oldMap.get(newContact.id).LastName != newContact.LastName) || (newContact.MobilePhone!= Null && trigger.oldMap.get(newContact.id).MobilePhone!= newContact.MobilePhone) || (newContact.Email != Null && trigger.oldMap.get(newContact.id).Email != newContact.Email)){
                
                updateUserInfo.put(newContact.id,newContact);
                contactOldMap.put(newContact.id, Trigger.oldMap.get(newContact.id));
            }
            
            if(newContact.RecordTypeId == familyContactRecordTypeId && newContact.Relationship__c != trigger.oldMap.get(newContact.id).Relationship__c){
                wishFamilyContacMap.put(newContact.Id,newContact);
            }
            
            system.debug('%BeforeInsert MailingCountry 6%'+newContact.MailingState);
        }
        
        
        if(RecursiveTriggerHandler.isFirstTime || Test.isRunningTest()){
            system.debug('Recursive Trigger'+RecursiveTriggerHandler.isFirstTime);
            RecursiveTriggerHandler.isFirstTime = false;
            if(contactIdsForEmailChange.size()>0)
            {
                system.debug('************ contactIdsForEmailChange size' + contactIdsForEmailChange.size());
                string temp;
                string temp1;
                
                for(npe4__Relationship__c newRelationShip : [SELECT ID,Name,Parent_Legal_Guardian__c,npe4__RelatedContact__c,npe4__RelatedContact__r.LastName,npe4__RelatedContact__r.FirstName,npe4__RelatedContact__r.Name,npe4__RelatedContact__r.Email,npe4__Contact__c,
                                                             npe4__Contact__r.Recipient_Email__c,npe4__Contact__r.Second_Recipient_Email__c,npe4__Contact__r.First_Recipient_Name__c,
                                                             npe4__Contact__r.Second_Recipient_Name__c FROM npe4__Relationship__c WHERE Parent_Legal_Guardian__c =: true
                                                             AND npe4__RelatedContact__c IN:contactIdsForEmailChange]){
                                                                 
                                                                 temp = newRelationShip.npe4__Contact__r.First_Recipient_Name__c+'-'+newRelationShip.npe4__Contact__r.Recipient_Email__c;
                                                                 temp1 = newRelationShip.npe4__Contact__r.Second_Recipient_Name__c+'-'+newRelationShip.npe4__Contact__r.Second_Recipient_Email__c;
                                                                 if(m1.containsKey(temp)){
                                                                     contact con = new contact();
                                                                     con.id = newRelationShip.npe4__Contact__c;
                                                                     con.Recipient_Email__c = m1.get(temp).Email;
                                                                     //con.First_Recipient_Name__c = m1.get(temp).Name;
                                                                     //updateEmailContact.add(con);
                                                                     updateEmailContactMap.put(con.Id,con);
                                                                 }
                                                                 else if(m1.containsKey(temp1)){
                                                                     
                                                                     contact con = new contact();
                                                                     con.id = newRelationShip.npe4__Contact__c;
                                                                     con.second_Recipient_Email__c = m1.get(temp1).Email;
                                                                     // con.Second_Recipient_Name__c = m1.get(temp1).Name;
                                                                     //updateEmailContact.add(con);
                                                                     updateEmailContactMap.put(con.Id,con);
                                                                 }
                                                                 
                                                             }
            }
        }
     
        if(updateEmailContactMap.size()>0){
            Update updateEmailContactMap.Values();
        }
       
        if(volunteercontactSet.size() > 0){
            ContactTriggerHandler.updateOrgAffiliationStatustopending(volunteercontactSet);
        }
        if(rejectedApplicationIds.size() > 0)
        {
            ContactTriggerHandler.updateOrgAffiliationStatustoDeclined(rejectedApplicationIds);
        }
        
        if(volunteerContactMap.size() > 0)
            ContactTriggerHandler.CreateVolunteerRoles(volunteerContactMap);
        
        if(zipCodesSet.size() > 0)
            ContactTriggerHandler.CreateZipcodeUpdateTask(zipCodesSet,contactMap);
        if(MedicalProfContactSet.size() > 0)
            ContactTriggerHandler.updateMedicalProfConatctInfo(MedicalProfContactSet);
        
        if(updateUserInfo.size() > 0){
            ContactTriggerHandler.updateUserDetails(updateUserInfo,contactOldMap);
        }
        
        if(addressSet.size() > 0){
            ContactTriggerHandler.updateHouseHoldAddress(addressSet);
        }
        if(wishFamilyContacMap.size() > 0)
        ContactTriggerHandler.updateRelationship(wishFamilyContacMap);
        
        if(conList.Size() > 0){
             ContactTriggerHandler.CreateAffliation(conList);
        }
        
        //if(contactIdSet.Size() > 0)
           // ContactTriggerHandler.updateAffiliation(contactIdSet);
    }
    
     //Reset the address verification checkbox if the address has changed
    if(trigger.isBefore && trigger.isUpdate)
    {
        for(Contact newContact : trigger.new){
            // the mailing address is already marked as verified
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null &&
            // one of the mailing address fields changed
            (newContact.MailingStreet != Trigger.oldMap.get(newContact.Id).MailingStreet ||
            newContact.MailingState != Trigger.oldMap.get(newContact.Id).MailingState ||
            newContact.MailingStateCode != Trigger.oldMap.get(newContact.Id).MailingStateCode ||
            newContact.MailingCity != Trigger.oldMap.get(newContact.Id).MailingCity ||
            newContact.MailingPostalCode != Trigger.oldMap.get(newContact.Id).MailingPostalCode
            )
            ){
                system.debug('Update MailingAddressVerified__c>>>>'+newContact.MailingAddressVerified__c);
                newContact.MailingAddressVerified__c = false;
                newContact.MailingAddressVerificationAttempted__c = null;
                newContact.County__c = ' ';
                
            }
            
            // the other address is already marked as verified
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null &&
            // one of the other address fields changed
            (newContact.OtherStreet != Trigger.oldMap.get(newContact.Id).OtherStreet ||
            newContact.OtherState != Trigger.oldMap.get(newContact.Id).OtherState ||
            newContact.OtherStateCode != Trigger.oldMap.get(newContact.Id).OtherStateCode ||
            newContact.OtherCity != Trigger.oldMap.get(newContact.Id).OtherCity ||
            newContact.OtherPostalCode != Trigger.oldMap.get(newContact.Id).OtherPostalCode
            )
            ){
                newContact.OtherAddressVerified__c = false;
                newContact.OtherAddressVerificationAttempted__c = null;
                
            }
        }
    
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
       Map<Id,Contact> conMap = new Map<Id,Contact>();
       for(Contact con : Trigger.old)
       {
           conMap.put(con.id,con);
           
       }
       if(conMap.size() > 0){
          contactTriggerHandler.UpdateAffiliationPrimaryStatus(conMap);
          contactTriggerHandler.validateContact(conMap);
          }
       
         
         
    }
}