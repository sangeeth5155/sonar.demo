/**************************************************************************************************
Description : Its updating the Active flag as True whenever new records are inserted. And also its 
preventing duplicate active background check record.
Its updating Affiliation Record status based the Background check verification status.
***************************************************************************************************/

trigger BackGroundCheck_AT on Background_check__c (Before insert, Before update, After insert,After update) {
   
   //This is used to get volunteer conatct email and store value in hidden email field to send an email to this value
    if(Trigger.isBefore && Trigger.isInsert)
    {   Set<Id> volunteerIds = new Set<Id>();
        Map<Id,Contact> conMap = new Map<Id, Contact>();
        for(Background_check__c  currRec : Trigger.new)
        {
           if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
          {
               if(!Test.isRunningTest())
               {
                    if(currRec.Date_Completed__c != null && (currRec.Status__c != Null))
                        currRec.current__c = True;
               }
               volunteerIds.add(currRec.Volunteer__c);
          }
          if(currRec.Date_Completed__c != null)
          {
               currRec.Date__c = currRec.Date_Completed__c.addYears(3);
          }
        }
       
        if(volunteerIds.size() > 0)
        {
            BackGroundCheckTriggerHandler.UpdateHiddenEmailField(volunteerIds,Trigger.new);
        }
    }
    
// After Insert Begins Here----------------------
 // Deactivating Existing Records. 
    if(Trigger.isAfter && Trigger.isInsert)
    {
        Set<Id> newRecordIds = new Set<Id>();
        Set<Id> volunteerIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Map<String,List<Background_check__c>> bgcMap = new Map<String,List<Background_check__c>>();
        Map<Id,Background_check__c>   expirationDateMap = new Map<Id,Background_check__c>(); 
       
        for(Background_check__c currRec : Trigger.new)
        {
          ownerIds.add(currRec.OwnerId);
        }
        
        Map<Id,String> userRoleMap = UserRoleUtility.getUserRole(ownerIds);
       
      //  Map<String,List<Background_check__c>> bgcMap = new Map<String,List<Background_check__c>>();
        for(Background_check__c  currRec : Trigger.new)
        {
          if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
          {
            if(currRec.current__c == True)
            {
                newRecordIds.add(currRec.id);
                volunteerIds.add(currRec.Volunteer__c);
            }
            
          if(currRec.Account_Name__c != Null && userRoleMap.get(currRec.OwnerId) == 'National Staff')
          {  
           if(bgcMap.containsKey(currRec.Account_Name__c))
            {
                bgcMap.get(currRec.Account_Name__c).add(currRec);
            }
            else
                bgcMap.put(currRec.Account_Name__c,new List<Background_check__c>{currRec});
           }
           
             if(currRec.Date__c != Null && currRec.current__c == True)
             {
                 expirationDateMap.put(currRec.id,currRec);
             }
            
          }
          
        }
        if(newRecordIds.size() > 0 && volunteerIds.size() > 0)
        {
            BackGroundCheckTriggerHandler.DeactivateExistingRecords(newRecordIds,volunteerIds);
        }
        
       if(bgcMap.size() > 0)
        {
            ChapterStaffRecordSharing_AC.BGCRecordSharing(bgcMap);
        }
        
       if(expirationDateMap.size() > 0)
       {
          BackGroundCheckTriggerHandler.UpdateVolunteerExpirationDate(expirationDateMap);
       }
        
    }
    
// Before Update Event Begins Here---------------------------------------------------------

  // Preventing Duplicate Active Background Check.
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        Set<Id> newRecordIds = new Set<Id>();
        Set<Id> volContactIdSet = new Set<Id>();
        Set<Id> volunteerIds = new Set<Id>();
        for(Background_check__c currRec : Trigger.new)
        {   
                volunteerIds.add(currRec.volunteer__c);
                if(currRec.Date_Completed__c != null && currRec.Date_Completed__c != Trigger.oldMap.get(currRec.id).Date_Completed__c )
                {
                    currRec.Date__c = currRec.Date_Completed__c.addYears(3);
                }
                
                if((currRec.Date_Completed__c != null && CurrRec.Date_Completed__c != Trigger.oldMap.get(currRec.id).Date_Completed__c) 
                    && (currRec.Status__c != Null) && currRec.Status__c != Trigger.oldMap.get(currRec.id).status__c)
                {
                   currRec.current__c = True;
                }
              
              
                if(currRec.current__c == True && Trigger.oldMap.get(currRec.id).current__c == false)
                { 
                    newRecordIds.add(currRec.id);
                    volContactIdSet.add(currRec.volunteer__c);
                }
           
           
           
        }
        if(volunteerIds.size() > 0)
        {
          BackGroundCheckTriggerHandler.UpdateHiddenEmailField(volunteerIds,Trigger.new);
        }
    
      /*  List<Background_check__c> exActiveRecList = [SELECT Id FROM Background_check__c WHERE current__c = True AND ID NOT IN :newRecordIds];
    
        for(Background_check__c currRec : Trigger.new)
        {
           
            if(currRec.current__c == True && Trigger.oldMap.get(currRec.id).current__c == false)
            {
                if(exActiveRecList.size() > 0 && volContactIdSet.contains(currRec.volunteer__c))
                    currRec.addError('Active Background Check Already Exist'); 
            }
          
        }*/
     }
  
  
 // After  Update Events Begins Here -------------------------------
    
    // Updating Affiliation Status.
    If(Trigger.isAfter && Trigger.isUpdate)
    {
        Set<Id> rejectedIds = new Set<Id>();
        set<Id> approvedVolunteerIds = new Set<Id>();
        Map<Id,Background_check__c>   expirationDateMap = new Map<Id,Background_check__c>(); 
        Set<Id> newRecordIds = new Set<Id>();
        Set<Id> volunteerIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Set<Id> volunteerContactIdSet = new Set<Id>();
        Set<Id> backgroundRejectedSet = new Set<Id>();
        Map<String,List<Background_check__c>> bgcMap = new Map<String,List<Background_check__c>>();
        Set<String> chapterNamesSet = new Set<String>();
        Map<Id,String> chapterNameMap = new Map<Id,String>();
        Map<String,String> chapterRoleMap = new Map<String,String>();
        List<User> currUser = [SELECT Id,UserRole.Name,Profile.Name FROM User WHERE Id =: UserInfo.getUserID() Limit 1];
        for(Background_check__c dbBackgroundCheckRec : trigger.new)
        {
            if(dbBackgroundCheckRec.Status__c == 'Approved' && dbBackgroundCheckRec.Status__c != Null && trigger.oldmap.get(dbBackgroundCheckRec.Id).Status__c != 'Approved')
            {
                approvedVolunteerIds.add(dbBackgroundCheckRec.Volunteer__c);
            }
            if((dbBackgroundCheckRec.Status__c == 'Rejected') && (Trigger.oldMap.get(dbBackgroundCheckRec.id).Status__c != 'Rejected') && dbBackgroundCheckRec.Status__c != Null)
            {
                rejectedIds.add(dbBackgroundCheckRec.Volunteer__c);
            }
            
            if(dbBackgroundCheckRec.Date__c != Null && Trigger.oldMap.get(dbBackgroundCheckRec.id).Date__c <> dbBackgroundCheckRec.Date__c && dbBackgroundCheckRec.current__c == True)
            {
                 expirationDateMap.put(dbBackgroundCheckRec.Volunteer__c,dbBackgroundCheckRec);
            }
            
            if(dbBackgroundCheckRec.current__c == True && Trigger.oldMap.get(dbBackgroundCheckRec.id).current__c == false)
            {
                newRecordIds.add(dbBackgroundCheckRec.id);
                volunteerIds.add(dbBackgroundCheckRec.volunteer__c);
            }
            
            if(dbBackgroundCheckRec.HiddenBackgroundExpire__c == true && trigger.oldMap.get(dbBackgroundCheckRec.Id).HiddenBackgroundExpire__c == false)
            {
                volunteerContactIdSet.add(dbBackgroundCheckRec.Volunteer__c);
            }
            if(dbBackgroundCheckRec.Hidden_Background_Rejected__c == true && trigger.oldMap.get(dbBackgroundCheckRec.Id).Hidden_Background_Rejected__c == false)
            {
                backgroundRejectedSet.add(dbBackgroundCheckRec.Volunteer__c);
            }
           // if(dbBackgroundCheckRec.ownerId != Trigger.oldMap.get(dbBackgroundCheckRec.id).ownerId)
              //  ownerIds.add(dbBackgroundCheckRec.ownerId);
            if(dbBackgroundCheckRec.Account_Name__c != Null && currUser[0].UserRole.Name != 'National Staff' && currUser[0].profile.Name != 'System Administrator' && currUser[0].profile.Name != 'Integration'  && currUser[0].profile.Name != 'Active Volunteer (Login)' && currUser[0].profile.Name != 'Active Volunteer (Member)'){
               chapterNamesSet.add(dbBackgroundCheckRec.Account_Name__c );
               chapterNameMap.put(dbBackgroundCheckRec.Id,dbBackgroundCheckRec.Account_Name__c ); 
            }
        }
        
        if(chapterNamesSet.Size() > 0){
            chapterRoleMap=ChapterStaffRecordSharing_AC.FindChapterRole(chapterNamesSet);
        
            for(Background_check__c currRec :Trigger.New){ 
                system.debug('Chapter Name****************'+chapterNameMap.get(currRec.Id));
                if((chapterRoleMap.get(chapterNameMap.get(currRec.Id)) != currUser[0].UserRole.Name || currRec.Account_Name__C != Trigger.oldMap.get(currRec.Id).Account_Name__C) && !Test.isRunningTest())
               {
                     currRec.addError('Insufficient previlege to update this record. Please contact system administrator.');        
               }
            }
       } 
        
     /*   Map<id, String> userRoleMap = UserRoleUtility.getUserRole(ownerIds);
        
        
        for(Background_check__c currRec : Trigger.new)
        {
          if(currRec.Account_Name__c != Null && userRoleMap.get(currRec.OwnerId) == 'National Staff' 
                  && currRec.OwnerId != Trigger.oldMap.get(currRec.id).ownerId)
          {  
           if(bgcMap.containsKey(currRec.Account_Name__c))
            {
                bgcMap.get(currRec.Account_Name__c).add(currRec);
            }
            else
                bgcMap.put(currRec.Account_Name__c,new List<Background_check__c>{currRec});
           }
        }*/
        
       /* if(volunteerIds.size() > 0)
        {
          BackGroundCheckTriggerHandler.UpdateHiddenEmailField(volunteerIds,Trigger.new);
        }*/
        
        if(newRecordIds.size() > 0 && volunteerIds.size() > 0)
        {
            BackGroundCheckTriggerHandler.DeactivateExistingRecords(newRecordIds,volunteerIds);
        }

        if(rejectedIds.size() > 0)
        {
            BackGroundCheckTriggerHandler.UpdateAffiliationStatusToDeclined(rejectedIds);
        }

        if(approvedVolunteerIds.size() > 0)
        {
            BackGroundCheckTriggerHandler.UpdateAffiliationStatusToPending(approvedVolunteerIds);
        }
        if(expirationDateMap.size() > 0)
        {
            BackGroundCheckTriggerHandler.UpdateVolunteerExpirationDate(expirationDateMap);
        }
        
        if(volunteerContactIdSet.size() > 0)
        BackGroundCheckTriggerHandler.UpdateVOppAndVRoleStatus(volunteerContactIdSet,'backgroundcheck');
        
        if(backgroundRejectedSet.size() > 0)
        BackGroundCheckTriggerHandler.UpdateVOppAndVRoleStatus(backgroundRejectedSet,'backgroundcheck');

    }
    

}