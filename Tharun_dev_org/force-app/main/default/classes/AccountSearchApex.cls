public with sharing class AccountSearchApex {
    @AuraEnabled(cacheable=true)
    public static list<Account> getAccountList(string searchKey) {
        string searchKeyword = '%' + searchKey + '%';
         // create account list to store search result
         list<Account> accountList = new list<Account>();
         for(Account acc:[SELECT id,Name FROM Account WHERE name LIKE : searchKeyword]){
            accountList.add(acc);
           
         }
         System.debug('account names'+accountList);
         return accountList;
    }
}