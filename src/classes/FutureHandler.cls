//This class is used to update the record that not ownned by current loggedin user
public class FutureHandler {
    @future
    public static void UpdateTask(Id taskId) {
        List<Task> taskList = [SELECT Id FROM Task WHERE Id =: taskId];
        if(taskList.size() > 0) {
            taskList[0].Status = 'Completed';
            update taskList;
        }
    }
}