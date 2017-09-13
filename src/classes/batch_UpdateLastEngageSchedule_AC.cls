/*****************************************************************************************
Created By  : MST
CreatedDate : 10/20/2016
Author : MST Solutions
Description : This schedule class used to run the batch_UpdateVolunteerLastEngage  class in particular time interval
*********************************************************************************************/
global class batch_UpdateLastEngageSchedule_AC implements Schedulable{
    global void execute(SchedulableContext SC){
        Database.executeBatch(new batch_UpdateVolunteerLastEngage(),25);
    }
}