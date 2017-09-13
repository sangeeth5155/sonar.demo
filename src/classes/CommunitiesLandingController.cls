/**
* An apex page controller that takes the user to the right start page based on credentials or lack thereof
*/
public with sharing class CommunitiesLandingController {
    
    List<Profile> userProfileName = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        
        if(userProfileName.size()>0 && (userProfileName[0].Name == 'Active Volunteer (Login)' || userProfileName[0].Name == 'Active Volunteer (Member)')) {
            if(!String.isEmpty(startUrl)) {
                PageReference landingPage = new PageReference(startUrl);
                return landingPage;
            } else {
                return page.VolunteerLanding_VF;
            }
            //return page.VolunteerLanding_VF;
        } else if(userProfileName.size()>0 && (userProfileName[0].Name == 'Prospective Volunteer (Login)' || userProfileName[0].Name == 'Prospective Volunteer (Member)')) {
            return page.VolunteerWelcomePage_VF;
        } else {
            return page.CommunitiesLogin;
        }
    }
    
    public CommunitiesLandingController() {}
}