/*************************************************************************************************
Author   : MST Solutions
CreatedBy: Kanagaraj 
CreatedDate : 05/27/2015
Description : This UserTrigger_AT is used to create a public group and public group member when ever a new
              user record is created.
*************************************************************************************************/

trigger UserTrigger_AT on User (after insert,after update,before update,before insert) {
    List<User> newUserList = new List<User>();
    Map<Id,User> prospectiveUserMap = new Map<Id,User>();
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        Map<Id, Id> newUserRoleIdMap = new Map<Id, Id>(); // Used to hold the new user role Id
        Set<string> userIdsSet = new Set<string>(); // useed to holds unique rolename
        for(User newUser : Trigger.new){
           if(newUser.Migrated_User__c == false && newUser.created_from_portal__c == true)
           {
                if(newUser.State != null){
                    newUserList.add(newUser);
                }
                
                system.debug('newUser.ProfileId+++++++++++++++++ ' +newUser.ProfileId);
                system.debug('label.Prospective_Volunteer_Profile+++++++++++++++++ ' +label.Prospective_Volunteer_Profile);
                if((newUser.ProfileId == label.Prospective_Volunteer || newUser.ProfileId == String.valueOf(label.Active_Volunteer_Profile).trim()) && (newUser.contactId != Null))
                   
                {
                  System.debug('Admin1+++++++++++++++++++ ' );
                  prospectiveUserMap.put(newUser.contactId, newUser);
                } 
              

                if(newUser.UserRoleId != null) {
                    newUserRoleIdMap.put(newUser.Id, newUser.UserRoleId);
                }
             }
            if(newUser.Migrated_User__c == false && newUser.UserRoleId != Null){
                userIdsSet.add(newUser.Id);
                
            }
        }
       // UserTriggerHandler userHandlerIns = new UserTriggerHandler();
       // if(newUserList.size() > 0)
          //userHandlerIns.createpublicGroup(newUserList);
        if(prospectiveUserMap.size() > 0)
        {
            UserTriggerHandler.UpdateVolunteerInfo(prospectiveUserMap);
        }

        //Used to add new user to chatter group based on their role name
        if(newUserRoleIdMap.size() > 0 ) {
            System.debug('newUserRoleIdMap>>>>>>>>>'+newUserRoleIdMap);
            UserTriggerHandler.AddInternalUserToChatterGroup(newUserRoleIdMap);
        }
       
   //Used to update chapter name in the user record based on the user role     
       /* if(userIdsSet.size() > 0){
            UserTriggerHandler.updateUserChapterName(userIdsSet);
        }*/
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        Set<Id> inActiveUserIdSet = new Set<Id>();
        Set<Id> inactiveUserSet=new Set<Id>();
        Set<Id> activeUserSet=new Set<Id>();
        Map<Id, Id> newUserRoleIdMap = new Map<Id, Id>(); // Used to hold the new user role Id
        Map<Id, Id> oldUserRoleIdMap = new Map<Id, Id>(); // Used to hold the new user role Id
        Set<string> userIdsSet = new Set<string>(); // useed to holds unique rolename
         for(User newUser : Trigger.new)
         {
            if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
             {
                 if(newUser.IsActive == false && trigger.oldMap.get(newUser.Id).IsActive != newUser.IsActive){
                     System.debug('RecMatch>>>>>');
                     inActiveUserIdSet.add(newUser.Id);
                 }
                  if(newUser.ContactId != Null  && newUser.IsActive  == false && trigger.oldMap.get(newUser .id).IsActive == True){
                    inactiveUserSet.add(newUser.ContactId);
                  } 
                  
                  if(newUser.ContactId != Null  && newUser.IsActive  == True && trigger.oldMap.get(newUser .id).IsActive == False){
                    activeUserSet.add(newUser.ContactId);
                  } 
                  
                 if(newUser.UserRoleId != Null && newUser.UserRoleId != trigger.oldMap.get(newUser.id).UserRoleId){
                     userIdsSet.add(newUser.id);
                 }
                 }

            if(newUser.UserRoleId != null && Trigger.oldMap.get(newUser.Id).UserRoleId != newUser.UserRoleId) {
                newUserRoleIdMap.put(newUser.Id, newUser.UserRoleId);
                oldUserRoleIdMap.put(newUser.Id, Trigger.oldMap.get(newUser.Id).UserRoleId);
            }

          }
   //Used to update chapter name in the user record based on the user role        
       /* if(userIdsSet.size() > 0){
             UserTriggerHandler.updateUserChapterName(userIdsSet);
        }*/
        
        if(inActiveUserIdSet.size() > 0) {
            System.debug('CallMet>>>>>');
            UserTriggerHandler.updateUser(inActiveUserIdSet);
        }
            
        
         if(inactiveUserSet.size() > 0 && inactiveUserSet != Null){
            InactiveVolunteerHandler.createTaskforVolunteerManager(inactiveUserSet);
            InactiveVolunteerHandler.updateBCandCOIVolunteerInactive(inactiveUserSet,True);
         }
        if(activeUserSet.Size() > 0){
            Set<Id> activeVolunteerIdSet = new Set<Id>();
            for(npe5__Affiliation__c currAff : [SELECT id,npe5__Status__c,npe5__Contact__c  FROM npe5__Affiliation__c WHERE  npe5__Contact__c IN :activeUserSet]){
                   
                   if(currAff.npe5__Status__c == 'Active'){
                       activeVolunteerIdSet.add(currAff.npe5__Contact__c); 
                   }              
            }
            if(activeVolunteerIdSet.Size() > 0){
                InactiveVolunteerHandler.updateBCandCOIVolunteerInactive(activeVolunteerIdSet,False);
            }
               
        }
         //Used to add new user to chatter group based on their role name
        if(newUserRoleIdMap.size() > 0 ) {
            System.debug('newUserRoleIdMap>>>>>>>>>'+newUserRoleIdMap);
            UserTriggerHandler.AddInternalUserToChatterGroup(newUserRoleIdMap);
        }

        if(oldUserRoleIdMap.size() > 0 ) {
            System.debug('oldUserRoleIdMap>>>>>>>>>'+oldUserRoleIdMap);
            UserTriggerHandler.RemoveInternalUserToChatterGroup(oldUserRoleIdMap);
        }
         
    }
    
     Set<Id> UserIdSet=new Set<Id>();
     if(Trigger.isbefore && Trigger.isInsert)
     {
      for(User newUser : Trigger.new)
      {
       if(newUser.IsActive == true){
        newUser.dsfs__DSProSFUsername__c = Label.DSProSFUsername;
        }
       }
     }
     if(Trigger.isbefore && Trigger.isUpdate)
     {
         Set<Id> inActiveCommunityUserIdSet = new Set<Id>();
         for(User newUser : Trigger.new)
         {
             if(Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
             {
                 if(newUser.IsActive == false && trigger.oldMap.get(newUser.Id).IsActive == True )
                 {
                    
                    newUser.Inactive_Date__c=system.Today();
                 }
                 if(newUser.IsActive == true && trigger.oldMap.get(newUser.Id).IsActive == False ){
                      newUser.Inactive_Date__c=null;
                 }
              }
         }
     }   
}