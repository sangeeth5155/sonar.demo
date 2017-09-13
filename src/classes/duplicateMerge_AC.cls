/*******************************************************************
Author: MST Solutions
Description : Merging lead records. 
******************************************************************/


public class duplicateMerge_AC {
    
    /*******************************************************************************************************
    * @description Min number of leads that can be merged.
    */
    public final Integer MERGE_MINIMUM = 2;
    
    /*******************************************************************************************************
    * @description Max number of leads that can be merged.
    */
    public final Integer MERGE_LIMIT = 3;
    
    /*******************************************************************************************************
    * @description lead for the winning record.
    */
    public Lead winner {get; set;}
    
    /*******************************************************************************************************
    * @description List for the losing records.
    */
    public List<lead> losers {get; set;}
    
    /*******************************************************************************************************
    * @description Exception raised by the lead merge process.
    */
    public class leadMergeException extends Exception {} 
        
    /*******************************************************************************************************
    * @description Merges the winner and losers.
    * @param winner The winner record.
    * @param losers The loser records.
    * @return Boolean Whether the merge was successful.
    */
    public static Boolean mergeContacts(Lead winner, List<Lead> losers) {
        boolean successfulMerge = false;
        
        List<Account> winnerAccount = new List<Account>();
        Set<Id> loserAccountIds = new Set<Id>();
        List<Account> loserAccounts = new List<Account>();
        List<Account> loserAccountsToBeMerged = new List<Account>();
        List<Account> loserAccountsToBeDeleted = new List<Account>();
    
        Id winningAccountId = null;
        Boolean winnerAccountIsOneToOne = false;
        
           
       
        
        
        //merge the leads
        
       
      
        
       
        Lead winnerMakePrivate = new Lead();
        if(winnerAccountIsOneToOne){            
            winnerMakePrivate = new Lead(Id = winner.id,Override_Dupe_Check__c=True);
        } else {
            winnerMakePrivate = new Lead(Id = winner.id,Override_Dupe_Check__c=True);
        }
        List<Lead> losersMakePrivate = new List<Lead>();
        
        for(Lead contactForUpdate : losers){
            // only do this for One2One losers
                
                Lead loserMakePrivate = new Lead(id=contactForUpdate.id,Override_Dupe_Check__c=True);
                losersMakePrivate.add(loserMakePrivate);
            }
      
            
        //set the account to null and mark private so that trigger won't reset the Account
        if (winningAccountId!=null && winnerAccountIsOneToOne){         
            update winnerMakePrivate;           
        }
        
        if(losersMakePrivate.size()>0){
            update losersMakePrivate;
        }

        merge winnerMakePrivate losers;
        
       
       
       
        if (loserAccountsToBeDeleted.size() > 0) {
            delete loserAccountsToBeDeleted;
        }
        successfulMerge = true;
        return successfulMerge;
    }   
}