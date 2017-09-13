/*****************************************************************************************
Created By  : MST
CreatedDate : 12/01/2016
Author : MST Solutions
Description : This schedule class used to run the batch_changeVolunOppSatus class in particular time interval
*********************************************************************************************/
global class batch_changeVolunOppSatusSchedule_AC implements Schedulable{
    global void execute(SchedulableContext SC){
        Database.executeBatch(new batch_changeVolunOppSatus(),25);
    }
}