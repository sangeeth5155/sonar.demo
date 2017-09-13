/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest 
global class CommunitiesLoginControllerTest {
  
  // Login As Prospective User Profile
   
    static testmethod void loginAsProspectiveUser () {
       
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;   
         System.RunAs(new User(Id = UserInfo.getUserId()))
         {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
         }
         
         System.RunAs(currUser)
         {
             
             CommunitiesLoginController controller = new CommunitiesLoginController();
             controller.userName = 'joathanedwards@gmail.com';
             controller.login();
         }
            
    } 
    
    // Login As Prospective User Profile
   
    static testmethod void loginAsActiveUser () {
       
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;   
         System.RunAs(new User(Id = UserInfo.getUserId()))
         {
              currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
         }
         
         System.RunAs(currUser)
         {
             
             CommunitiesLoginController controller = new CommunitiesLoginController();
             controller.userName = 'joathanedwards@gmail.com';
             controller.login();
         }
            
    } 
    
     // Creating custom setting values.
   
    static testmethod void createCustomSettingValueforActive() {
       
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;   
         System.RunAs(new User(Id = UserInfo.getUserId()))
         {
              currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
         }
         
         System.RunAs(currUser)
         {
             HoldCurrentChapter__c currVal = new HoldCurrentChapter__c();
             currVal.Name = currUser.id;
             currVal.CurrentChapter__c = acc.name;
             insert currVal;
             
             CommunitiesLoginController controller = new CommunitiesLoginController();
             controller.userName = 'joathanedwards@gmail.com';
             controller.login();
         }
            
    } 
     // Login as wrong user.
   
    static testmethod void loginAsWrongUser() {
       
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;   
         System.RunAs(new User(Id = UserInfo.getUserId()))
         {
              currUser = OrientationandTrainingUtil.createActiveVolunteerUser(con.id);
         }
         
         System.RunAs(currUser)
         {
            
             CommunitiesLoginController controller = new CommunitiesLoginController();
             controller.userName = 'vennila@gmail.com';
             controller.login();
         }
            
    } 
}