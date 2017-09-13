/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest public with sharing class ForgotPasswordControllerTest {
     @IsTest(SeeAllData=false) 
    public static void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        User currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = currUser.username; 
        controller.success = true;
        controller.displayAckMsg = true;
        System.assertEquals(controller.forgotPassword(),null); 
    }
     @IsTest(SeeAllData=false) 
    public static void InvalidUser() {
        // Instantiate a new controller with all parameters in the page
        Account acc = OrientationandTrainingUtil.createVolunteerAccount();
        Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
        OrientationandTrainingUtil.createAffiliation(con.id);
        User currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'Sample@demo.com'; 
        System.assertEquals(controller.forgotPassword(),null); 
    }
    
}