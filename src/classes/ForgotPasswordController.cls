/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;}  
    public boolean displayAckMsg{get;set;} 
    public boolean success;
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
    
     List<User> currUser = [SELECT ID FROM USER WHERE USERNAME = :username];
     if(currUser.size() > 0)
     {
        success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
          //return pr;
           displayAckMsg = True;
        }
     }
     else
     {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Username not exist in system');
            ApexPages.addMessage(myMsg);
            return null;
     }
        return null;
     
    }
}