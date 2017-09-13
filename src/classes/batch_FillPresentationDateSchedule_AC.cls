/*****************************************************************************************
Created By  : MST
CreatedDate : 10/20/2016
Author : MST Solutions
Description : This schedule class used to run the batch_FillWishPresentationDate class in particular time interval
*********************************************************************************************/
global class batch_FillPresentationDateSchedule_AC implements Schedulable{
    global void execute(SchedulableContext SC){
        Database.executeBatch(new batch_FillWishPresentationDate(),25);
    }
}