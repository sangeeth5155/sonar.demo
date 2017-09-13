global class DiagnosisVerficationRemainder_AC implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
         String ReferredStatus = 'Referred';
         String partAStatus = 'Pending Diagnosis Verification';
         
         String query = 'SELECT Id, Status, Sub_Status__c, OwnerId, Referred_Date__c, Part_A_Sent__c, Treating_Medical_Professional_Email__c  FROM Lead WHERE ((Status = \''+partAStatus+'\') ' +
                         ' OR (Status = \''+ReferredStatus+'\'))';
                        
         
         return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Lead> scope) 
    {
    
        List<Task> createTaskList = new List<Task>();
        List<Lead> updateLeadList = new List<Lead>();
        for(Lead currLead : scope)
        {
          if(currLead.Status == 'Referred')
          {
             
              if((currLead.Referred_Date__c).addDays(3) == Date.Today())
              {
                 Task newTask = new Task();
                 newTask.OwnerId = currLead.OwnerId;
                 newTask.Priority = 'Normal';
                 newTask.Status = 'Not Started';
                 newTask.Subject = 'Send Diagnosis Verification';
                 newTask.whoId = currLead.id;
                 newTask.Account_Email__c = currLead.Treating_Medical_Professional_Email__c;
                 createTaskList.add(newTask);
                 
              }
          else if(currLead.Sub_Status__c == 'Pending Diagnosis Verification')
           {
              
            if((currLead.Part_A_Sent__c).addDays(7) == Date.Today())
            {
                 Task newTask = new Task();
                 newTask.OwnerId = currLead.OwnerId;
                 newTask.Priority = 'Normal';
                 newTask.Status = 'Not Started';
                 newTask.Subject = '7 days reminder for Diagnosis Verification';
                 newTask.whoId = currLead.id;
                 createTaskList.add(newTask);
                 
                 Lead newLead = new Lead();
                 newLead.id = currLead.id;
                 newLead.Diagnosis_Pending_Days__c = '7';
                 updateLeadList.add(newLead);
                 
            }
            if((currLead.Part_A_Sent__c).addDays(14) == Date.Today())
            {
                 Task newTask = new Task();
                 newTask.OwnerId = currLead.OwnerId;
                 newTask.Priority = 'Normal';
                 newTask.Status = 'Not Started';
                 newTask.Subject = '14 days reminder for Diagnosis Verification';
                 newTask.whoId = currLead.id;
                 newTask.Account_Email__c = currLead.Treating_Medical_Professional_Email__c;
                 createTaskList.add(newTask);
                 Lead newLead = new Lead();
                 newLead.id = currLead.id;
                 newLead.Diagnosis_Pending_Days__c = '14';
                 updateLeadList.add(newLead);
            }
            if((currLead.Part_A_Sent__c).addDays(21) == Date.Today())
            {
                 Task newTask = new Task();
                 newTask.OwnerId = currLead.OwnerId;
                 newTask.Priority = 'Normal';
                 newTask.Status = 'Not Started';
                 newTask.Subject = '21 days reminder for Diagnosis Verification';
                 newTask.whoId = currLead.id;
                 newTask.Account_Email__c = currLead.Treating_Medical_Professional_Email__c;
                 createTaskList.add(newTask);
                 Lead newLead = new Lead();
                 newLead.id = currLead.id;
                 newLead.Diagnosis_Pending_Days__c = '21';
                 updateLeadList.add(newLead);
            }
          
         } 
       }
    } 
  }  
    global void finish(Database.BatchableContext BC) {
    }
}