Public class UserRoleUtility
{
   public static Map<Id,String> getUserRole(Set<Id> userIds)
   {
      Map<Id,String> userRoleMap = new Map<Id,String>();
      for(User currUser : [SELECT Id, UserRole.Name FROM User WHERE id IN :userIds])
      {
          userRoleMap.put(currUser.Id, currUser.UserRole.Name);
      }
      return userRoleMap;
   }

}