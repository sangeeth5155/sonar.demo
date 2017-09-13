/*****************************************************************************************
Created By : MST Solutions
Created Date : feb - 1 - 2017
Description : This test class used to perform unit testing for the 'Batch_ClosePresentationTask_AC'.
**********************************************************************************************/
@isTest
public class Batch_ClosePresentationTask_AC_Test {
    
    @testSetup
    public static void setUpData(){
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
    }
    
    //Create Obtain itinerary Task
    public static testmethod void CreateObtainitinerary() {
        List<Case> parentCaseList = [SELECT Id FROM Case LIMIT 1];
        if(parentCaseList.size() > 0) {
            List<Task> itneraryTaskList = OrientationandTrainingUtil.CreateObtainitinerary(parentCaseList[0].Id);
            try{
                insert itneraryTaskList;    
            }Catch(Exception ex){
                System.debug('Exception '+ex.getMessage());
            }
            Test.startTest();
            Batch_ClosePresentationTask_AC obj = new Batch_ClosePresentationTask_AC();
            DataBase.executeBatch(obj); 
            System.assertEquals(10,itneraryTaskList.size());
            Test.stopTest();
        }
    }
    public static testmethod void testschedule(){
        String CRON_EXP = '0 0 1 * * ? *';
        Test.startTest();
        System.schedule('Batch_ClosePresentationTask_AC_Schedule', CRON_EXP, new Batch_ClosePresentationTask_AC_Schedule());
        Test.stopTest();
    }
}