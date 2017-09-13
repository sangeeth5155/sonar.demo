/********************************************************************
Created by : Vennila Paramasivam
Create Date : 07/15/2016.
Author : MST Solutions.
Description : Updating the Volunteer Profile from Prospective to Active Profile when
              Affiliation Record status is changed from Pending status to Active status.
              (When Volunteer Completes their Role Based training that time Affiliation
              status would update as Active at the same time User profile also update.
*********************************************************************/

Public class VolunteerOandTHandler
{
    @future
    public static void updateUser(Set<Id> userIds)
    {
       String prospectiveProfileId = label.Prospective_Volunteer;
       List<User> updateUserList = new List<User>();
       for(User currUser : [SELECT Id, ProfileId FROM User WHERE contactId IN :userIds AND ProfileId = :prospectiveProfileId])
       {
           User newUser = new User();
           newUser.id = currUser.id;
           newUser.ProfileId = label.Active_Volunteer_Profile;
           updateUserList.add(newUser);
       }
     
       if(updateUserList.size() > 0)
           update updateUserList;
    }


}