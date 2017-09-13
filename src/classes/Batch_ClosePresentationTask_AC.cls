/*****************************************************************************************
Created By  : MST
CreatedDate : 2/1/2017
Author : MST Solutions
Description : This class is used to close task with subject "Obtain itinerary and/or wish packet"
when the due date is passed
**********************************************************************************************/
global class Batch_ClosePresentationTask_AC implements Database.Batchable<sObject> {
    
    //Used to get all due date passed records with subject "Obtain itinerary and/or wish packet"
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date todayPassed = Date.today();
        String taskSubject = 'Obtain itinerary and/or wish packet';
        String query = 'SELECT Id, isClosed, ActivityDate FROM Task WHERE isClosed = false AND ActivityDate =: todayPassed AND Subject =: taskSubject';
        return Database.getQueryLocator(query);
    }
    
    //Used to update the status of the record to 'Completed'
    global void execute(Database.BatchableContext BC, List<Task> taskList) {
        List<Task> closeTaskList = new List<Task>();
        for(Task closeTask : taskList) {
            closeTask.status = 'Completed';
            closeTaskList.add(closeTask);
        }
        if(closeTaskList.size() > 0) {
            update closeTaskList;
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        
    }
}