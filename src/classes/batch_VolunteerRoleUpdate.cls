global class batch_VolunteerRoleUpdate implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        
         
               return Database.getQueryLocator([SELECT id,Status__c,Volunteer_Name__c,Role_Name__c,Chapter_Role__c
                                               FROM Volunteer_Roles__c
                                               WHERE Migrated_Record__c = True
                                              ]);
    }
   
    global void execute(Database.BatchableContext BC, List<Volunteer_Roles__c> scope) 
    {
            Set<Id> volunteerContactIds = new Set<Id>();
            Map<Id,List<Volunteer_Roles__c>> volunteerRolesMap = new  Map<Id,List<Volunteer_Roles__c>>();
            Map<Id,Volunteer_Roles__c> updateVolunteerRole = new Map<Id,Volunteer_Roles__c>();
            Map<Id,Boolean> volunteerTrainingMap = new Map<Id,Boolean>();
            
            Set<Id> chapterRoleIds = new Set<Id>();
                
            for(Volunteer_Roles__c currRole : scope)
            {
               volunteerContactIds.add(currRole.Volunteer_Name__c); 
               chapterRoleIds.add(currRole.Chapter_Role__c);
               
              if(volunteerRolesMap.containsKey(currRole.Volunteer_Name__c))
              {
                  volunteerRolesMap.get(currRole.Volunteer_Name__c).add(currRole);
              }
              else
              {
                  volunteerRolesMap.put(currRole.Volunteer_Name__c, new List<Volunteer_Roles__c>{currRole});    
              }
            }
            
            
            
            
            
            
            for(Volunteer_Orientation_Training__c currTraining : [SELECT id,Class_Offering__c,Class_Offering__r.Chapter_Role_O_T__r.Role_Name__c,
                                                                  Volunteer_Attendance__c,Volunteer__c from Volunteer_Orientation_Training__c
                                                                  WHERE Volunteer__c IN :volunteerContactIds])
            {
            
                volunteerTrainingMap.put(currTraining.Volunteer__c,True);
                if(volunteerRolesMap.containsKey(currTraining.Volunteer__c))
                {
                    for(Volunteer_Roles__c currRec : volunteerRolesMap.get(currTraining.Volunteer__c))
                    {
                        
                        Volunteer_Roles__c updateRec = new Volunteer_Roles__c();
                        updateRec.id = currRec.id;
                        
                        if(currTraining.Class_Offering__r.Chapter_Role_O_T__r.Role_Name__c == currRec.Role_Name__c)
                        {
                             
                             if(currTraining.Volunteer_Attendance__c == 'Completed')
                             {
                                 updateRec.Status__c = 'Trained';
                                 updateVolunteerRole.put(updateRec.id,updateRec);
                             }
                            else
                            {
                             if(updateVolunteerRole.containsKey(updateRec.id))
                             {
                               if(updateVolunteerRole.get(updateRec.id).status__c != 'Trained')
                               {
                                updateRec.Status__c = 'Pending Training';
                                updateVolunteerRole.put(updateRec.id,updateRec);
                               }
                             }
                             else
                              {
                                   updateRec.Status__c = 'Pending Training';
                                   updateVolunteerRole.put(updateRec.id,updateRec);
                              }
                            }
                                
                           
                        }
                        
                        else
                        {
                        
                          if(updateVolunteerRole.containsKey(updateRec.id))
                          {
                            if(updateVolunteerRole.get(updateRec.id).status__c != 'Trained')
                            {
                               updateRec.Status__c = 'Pending Training';
                               updateVolunteerRole.put(updateRec.id,updateRec);
                            }
                          }
                          else
                          {
                               updateRec.Status__c = 'Pending Training';
                               updateVolunteerRole.put(updateRec.id,updateRec);
                          }
                             
                        }
                       
                    }
                }
            }
            
            Set<String> requiredTrainingCO = new Set<String>();
            for(Chapter_Role_O_T__c currCOT : [SELECT id, Chapter_Role__c, Required__c FROM Chapter_Role_O_T__c
                                               WHERE required__c=True AND Chapter_Role__c IN :chapterRoleIds])
            {
               requiredTrainingCO.add(currCOT.Chapter_Role__c);
            }
            
            
            
            
           for(Volunteer_Roles__c currRole : scope)
            {
            
              if(currRole.Volunteer_Name__c != Null)
              {
                  Volunteer_Roles__c updateRec = new Volunteer_Roles__c();
                  updateRec.id = currRole.id;
                  if(!(volunteerTrainingMap.containsKey(currRole.Volunteer_Name__c)) && requiredTrainingCO.contains(currRole.Chapter_Role__c))
                          updateRec.Status__c = 'Pending Training';
                  else if(!((volunteerTrainingMap.containsKey(currRole.Volunteer_Name__c)) && requiredTrainingCO.contains(currRole.Chapter_Role__c)))
                          updateRec.Status__c = 'Trained';
                   updateVolunteerRole.put(updateRec.id,updateRec);
              }
            }
            
            
            if(updateVolunteerRole.size() > 0)
                 update updateVolunteerRole.values();
            
       
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}