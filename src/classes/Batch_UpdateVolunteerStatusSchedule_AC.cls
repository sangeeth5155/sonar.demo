/*****************************************************************************************
Created By  : MST
CreatedDate :06/07/2017
Author : MST Solutions
Description : This schedule class used to run the Batch_UpdateVolunteerStatus_AC class in every day 12.00Am and 12.00Pm
*********************************************************************************************/
global class Batch_UpdateVolunteerStatusSchedule_AC implements Schedulable{
    global void execute(SchedulableContext SC){
        Database.executeBatch(new Batch_UpdateVolunteerStatus_AC(),25);
       
    }
}