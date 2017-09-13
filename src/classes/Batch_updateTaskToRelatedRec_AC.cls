/* This batch class is used to update the "Lead ET : Online Wish Referral Received" Task to assosiate Lead */
global class Batch_updateTaskToRelatedRec_AC implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
          return Database.getQueryLocator([SELECT Id, CreatedDate FROM Lead WHERE CreatedDate > : Date.valueOf('2017-06-10') ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> leadList) {
        List<Task> updateTaskList = new List<Task>();
        Map<Id,Task> taskMap = new Map<Id,Task>();
             
        for(Task currTask : [SELECT Id,WhoId,Subject,CreatedDate FROM Task WHERE Subject = 'Lead ET : Online Wish Referral Received' AND WhoId = Null AND CreatedDate > : Date.valueOf('2017-06-10') ]){
            taskMap.put(currTask.Id,currTask);
        }
        
        for(Lead currLead : leadList){
            system.debug('Lead Id'+currLead);
            for(Task currTask : taskMap.values()){
                system.debug('');
                if( string.valueOf(currTask.createdDate).substring(0,17)==  string.valueOf(currLead.CreatedDate).substring(0,17)){
                    currTask.whoId = currLead.Id;
                    updateTaskList.add(currTask);
                    taskMap.remove(currTask.Id);
                    break;
                }
            }
        }
        
        if(updateTaskList.Size() > 0){
            Update updateTaskList;
        }
       
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}