/**************************************************************************************
Description : This trigger will restrict the volunteer role updates from outside chapter stafff.
Based on the Volunteer Role Status, It will update Affiliation Status.
***************************************************************************************/

Trigger VolunteerRole_AT on Volunteer_Roles__c (before update,after update,after insert) 
{
    if(Trigger.isUpdate){
        if(trigger.isBefore){
            Set<String> chapterNamesSet = new Set<String>();
            for(Volunteer_Roles__c currRec : Trigger.new)
            {
                chapterNamesSet.add(currRec.Chapter_Name__c); 
            }
            
            Map<String, String> chapterRoleMap = new Map<String,String>();
            
            if(chapterNamesSet.size() > 0)
                chapterRoleMap = ChapterStaffRecordSharing_AC.FindChapterRole(chapterNamesSet);
            
            List<User> currUser = [SELECT id,UserRole.Name,Profile.Name FROM User WHERE id = :userInfo.getUserId() limit 1];  
            
            for(Volunteer_Roles__c currRec : Trigger.new)
            {
                if(chapterRoleMap.get(currRec.Chapter_Name__c) != currUser[0].UserRole.Name && currUser[0].UserRole.Name != 'National Staff' && currUser[0].profile.Name != 'System Administrator' && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                {
                    currRec.addError('Insufficient previlege to update this record. Please contact system administrator.');
                    
                }
            } 
            
            
        }
        //This event used to update volunteer opportunity status as out of compliance or approved based on the volunteer role status      
        if(trigger.isAfter)
        {
            map<id,list<Volunteer_Roles__c>> volunteerRoleMap = new map<id,list<Volunteer_Roles__c>>();
            map<id,list<Volunteer_Roles__c>> volunteerRoleStatusMap = new map<id,list<Volunteer_Roles__c>>();
            for(Volunteer_Roles__c newVolRole : trigger.new)
            {
                if(newVolRole.Status__c != trigger.oldMap.get(newVolRole.id).Status__c && (newVolRole.Status__c == 'Out of Compliance' || newVolRole.Status__c == 'Trained')){
                    if(volunteerRoleMap.containsKey(newVolRole.Volunteer_Name__c)){
                        volunteerRoleMap.get(newVolRole.Volunteer_Name__c).add(newVolRole);
                    }
                    else
                    {
                        volunteerRoleMap.put(newVolRole.Volunteer_Name__c, new list<Volunteer_Roles__c> {newVolRole});
                    }
                 }
                  
                 if((newVolRole.Status__c == 'Former - Chapter' || newVolRole.Status__c == 'Former - Volunteer' || newVolRole.Status__c == 'Not Approved' ||
                         newVolRole.Status__c == 'Out of Compliance' || newVolRole.Status__c == 'Trained') && (newVolRole.Status__c != Trigger.oldMap.get(newVolRole.id).Status__c))
                 {
                       if(volunteerRoleStatusMap.containsKey(newVolRole.Volunteer_Name__c))
                       {
                            volunteerRoleStatusMap.get(newVolRole.Volunteer_Name__c).add(newVolRole);
                       }
                       else
                       {
                            volunteerRoleStatusMap.put(newVolRole.Volunteer_Name__c, new list<Volunteer_Roles__c>{newVolRole});
                       }
                 } 
            }
            if(volunteerRoleMap.size() > 0)
            {
                VolunteerRoleTriggerHandler.updatevolunteerOpportunity(volunteerRoleMap);
            }
            
            if(volunteerRoleStatusMap.size() > 0)
            {
               VolunteerRoleTriggerHandler.updateVolunteerRoleStatus(volunteerRoleStatusMap,'Update');
            }
            
            
        }
    }
    //Update Affiliation Status.
    if(Trigger.isInsert)
    {
         Map<id,list<Volunteer_Roles__c>> volunteerRoleStatusMap = new Map<id,list<Volunteer_Roles__c>>();
         for(Volunteer_Roles__c newVolRole : trigger.new)
         {
                      if(volunteerRoleStatusMap.containsKey(newVolRole.Volunteer_Name__c))
                       {
                            volunteerRoleStatusMap.get(newVolRole.Volunteer_Name__c).add(newVolRole);
                       }
                       else
                       {
                            volunteerRoleStatusMap.put(newVolRole.Volunteer_Name__c, new list<Volunteer_Roles__c>{newVolRole});
                       }
         
         }
         
         if(volunteerRoleStatusMap.size() > 0)
         {
               VolunteerRoleTriggerHandler.updateVolunteerRoleStatus(volunteerRoleStatusMap,'Insert');
         }
    }
}