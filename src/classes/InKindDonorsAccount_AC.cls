public class InKindDonorsAccount_AC {
    public List<Account> inKindAccountList {get; set;}
    public InKindDonorsAccount_AC() {  
        inKindAccountList = [select Name, AccountNumber from Account]; 
    }
    
    
    
    
}