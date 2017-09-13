/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 8/24/2016
Description : 
When new case comment is created then it will send the email to the corresponding contact Mac team. 
*******************************************************************************************************************/
trigger CaseCommentTrigger_AT on CaseComment (After insert) {
    Constant_AC  constant = new Constant_AC();
    public Id partARecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(constant.partARecordTypeId).getRecordTypeId();
    if(Trigger.isAfter && Trigger.isInsert){        
        Map<Id,case> UpdatecaseCommentMap = new Map<Id,case>();        
        set<Id> caseIds = new Set<Id>();
        Map<Id,Case> caseMap = new Map<Id,Case>();             
        for(CaseComment newComment : trigger.new){
            if(newComment.CommentBody != Null)
                caseIds.add(newComment.ParentId);           
        }
        for(Case dbcase :[SELECT Id,Case_Comment__c,Case_ThreadId__c FROM Case WHERE Id IN: caseIds]){
            caseMap.put(dbcase.Id,dbcase); 
        }
        for(CaseComment newComment : trigger.new){                       
            if(caseMap.containsKey(newComment.ParentId) ){                               
                if(!updatecaseCommentMap.containsKey(newComment.ParentId)){ 
                    case updateCase = new Case(); 
                    updateCase.Id = newComment.ParentId;
                    if(caseMap.get(newComment.ParentId).Case_Comment__c != Null){
                    	updateCase.Case_Comment__c =  caseMap.get(newComment.ParentId).Case_Comment__c + '\n'+'----------------------------------------------------------------------------'+'\n'+newComment.Commentbody;   
                    }else{
                    	updateCase.Case_Comment__c =  newComment.Commentbody;   
                    }
                    updatecaseCommentMap.put(updateCase.Id,updateCase);
                }
                else{
                    String concatComment = updatecaseCommentMap.get(newComment.ParentId).Case_Comment__c;
                    concatComment = concatComment + '\n'+'----------------------------------------------------------------------------'+'\n'+ newComment.Commentbody;                    
                    updatecaseCommentMap.get(newComment.ParentId).Case_Comment__c = concatComment;
                }
                
            }
        }
        if(UpdatecaseCommentMap.size() > 0){
            try{
            	update UpdatecaseCommentMap.Values();    
            }catch(Exception ex){
                System.debug('Exception ex'+ex.getMessage());
            }
            
        }
        //For apex email testing
        if(caseIds.size() > 0){
           // CaseCommentTriggerHandler_AC.sendEmail(caseIds);
        }
    }
    
    
    
}