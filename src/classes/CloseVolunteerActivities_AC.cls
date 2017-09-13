/************************************************************************************
Author : Mst Solutions
Created date: 3/202/2017
Description : This class is used to close the task when the volunteer clicks on "Mark Task Completed" button from task pagelayout
*************************************************************************************/
global class CloseVolunteerActivities_AC {
    
    //Used to close the volunteer task when mark completed button clicked by volunteer users from the task pagelayout
    webservice static Id CloseTask(Id taskId){
        List<Task> taskList = [SELECT Id FROM Task WHERE Id =: taskId];
        if(taskList.size() > 0) {
            taskList[0].Status = 'Completed';
            update taskList;
        }
        return null;
    }
}