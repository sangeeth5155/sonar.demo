public class ShoppingSpree_AC{
string caseId {get;set;}
string ddpId{get;set;}
public string ShoppingSpree{get;set;}
list<CaseTeamMember> caseTeamMemberList{get;set;}
list<Case> caseList {get;set;}
list<User> userDetailList;
public ShoppingSpree_AC(ApexPages.StandardController controller) {
         caseList =  new list<Case>();
          caseId  = ApexPages.currentPage().getparameters().get('ID'); 
          system.debug('caseId t@@@@@@@@@@@@' + caseId );
         caseTeamMemberList = new list<CaseTeamMember>();
         userDetailList = new list<User>();
         Set<Id> teamMemberSet = new Set<Id>();
         for(CaseTeamMember currentMember : [SELECT ID,ParentId,TeamRole.Name,Member.Name,MemberId FROM CaseTeamMember WHERE ParentId =: caseId AND TeamRole.Name =: 'Wish Granter' Limit 2] ){
             teamMemberSet.add(currentMember.MemberId); 
         }
         system.debug('teamMemberSet@@@@@@@@@@@@' + teamMemberSet);
         userDetailList = [SELECT Id , Name, contactId,contact.phone,contact.Name FROM USER WHERE Id IN: teamMemberSet];
         system.debug('userDetailList@@@@@@@@@@@@ ' + userDetailList );
         caseId = ApexPages.CurrentPage().getparameters().get('id');
         //ddpId = 'a1k5B000000ChJa';
         ddpId = Label.Shopping_Spree_DDP;
         ShoppingSpree = '/apex/loop__looplus?eid='+caseId +'&sidebar='+false+'&hidecontact='+true+'&hideddp='+true+'&ddpIds='+ddpId+'&autorun='+true;
             
        
    }
    
    public void updateCaseTeamMember(){
       List<case> updateCaseList = new List<case>();
        system.debug('Inside  updateCaseTeamMember' + userDetailList);
         If(userDetailList.SIZE() > 0){
             Case updCase = new Case(Id = caseId);
             if((updCase.Wish_Granter_1__c == NULL || updCase.Wish_Granter_1_Cell__c == NULL) || (updCase.Wish_Granter_1__c != userDetailList[0].Name)){
                 updCase.Wish_Granter_1__c = userDetailList[0].Name;
                 updCase.Wish_Granter_1_Cell__c = userDetailList[0].contact.phone;
             }
             if(userDetailList.size() > 1 && ((updCase.Wish_Granter_2__c == NULL || updCase.Wish_Granter_2_Cell__c == NULL) || updCase.Wish_granter_2__c  != userDetailList[1].Name)){
                 updCase.Wish_granter_2__c  = userDetailList[1].Name;
                 updCase.Wish_Granter_2_Cell__c = userDetailList[1].contact.phone;
             }
             updateCaseList.add(updCase);
         }
         if(updateCaseList.size() > 0)
             update updateCaseList;
    }

}