public class AccountSelector {
    
    public static List<Account> getAccounts(String searchKeyword){
        
        if( searchKeyword != null && !String.isBlank(searchKeyword)){       
            
            String searchquery = 'FIND \''+ searchKeyword + '*\'IN ALL FIELDS RETURNING  Account(Id, Name,RecordTypeId, npe01__One2OneContact__c,Business__c, npe01__One2OneContact__r.Name, npo02__HouseholdPhone__c ,BillingAddress, RecordType.Name LIMIT 20)'; 
            List<List<SObject>> searchList = Search.query(searchquery);                     
            if(searchList[0].size()>0){
                
                List<Account> accountList = new List<Account>();
                accountList.addAll((List<Account>)searchList[0]);                               
                return accountList;             
            }
        }        
        return null;    
    }
    
    public static integer checkAccountInApproval(Id recordId){
        
        list<ProcessInstance> existingApprovals = [SELECT Id, TargetObjectId
                                                   FROM ProcessInstance 
                                                   WHERE TargetObjectId = :recordId
                                                   AND Status = 'Pending'];
        return existingApprovals.size();
    }
    public static List<Account> getAccountList(String searchKeyword){
        List<Account> accountList = new List<Account>();
        if( searchKeyword != null && !String.isBlank(searchKeyword)){       
            String name = '%' + searchKeyword + '%';            
            accountList =  [SELECT ID, 
                            Name 
                            FROM Account 
                            WHERE name LIKE :name LIMIT 30];                       
        }        
        return accountList;    
    }
    public static list<RecordType> getRecordType(){
        
        list<RecordType> recordTypeList = new list<recordType>([SELECT Id,Name FROM RecordType WHERE SobjectType='Account' LIMIT 50000]);        
        return recordTypeList;       
    } 
    public static list<Account> getAccountObject(Id accountRecordId){
        
        if(accountRecordId != null && !String.isEmpty(accountRecordId) ){
            list<Account> accList = [SELECT Id,
                                     Name,
                                     Account_Type__c,
                                     Giving_Status__c,
                                     Bill_Month__c,
                                     BillingCity,
                                     BillingCountry,
                                     BillingPostalCode,
                                     BillingState,
                                     BillingStreet,
                                     Address_Type__c,
                                     Do_not_mail__c,
                                     Experian_Override__c,
                                     Cell__c,
                                     Business__c,
                                     Residence__c,
                                     Preferred_Email__c,
                                     Personal_Email__c,
                                     Business_Email__c,
                                     Designation__c,                                        
                                     Preferred_Phone__c,
                                     Zip4Code__c,
                                     npe01__One2OneContact__c,
                                     npe01__One2OneContact__r.Name,
                                     DO_officer__c,
                                     DO_officer__r.Name,
                                     RecordTypeId,
                                     RecordType.Name,
                                     Account_Status__c,
                                     Offlist_Reason__c,
                                     Offlist_Date__c,
                                     Fax,
                                     Religious_Observance__c,
                                     Practice_Area__c,
                                     Note__c,
                                     Experian_Verified__c,
                                     Business_Phone_Ext__c,
                                     npo02__HouseholdPhone__c,
                                     npo02__Formal_Greeting__c,
                                     npo02__Informal_Greeting__c,
                                     Apartment_Number__c,
                                     Street_2__c,
                                     Industry,
                                     Campaign_Division__c
                                     FROM Account
                                     WHERE Id =:accountRecordId];            
            if(!accList.isEmpty() && accList.size() > 0){
                
                return accList;
            }
        }    
        return null;
    }
    public static List<Account> getDuplicateAccount(Id accountId,String accountName, String accountMailingCity,String accountMailingCountry,String accountMailingPostalCode,String accountMailingStreet,String accountMailingStreet2, String accountMailingZip4code, String accountMailingState, String accountAprtNumber){
        
        if( accountMailingStreet2 != null && !String.isBlank(accountMailingStreet2)){ 
            
            if(accountMailingStreet.contains(accountMailingStreet2)){
                
                accountMailingStreet = accountMailingStreet.remove(accountMailingStreet2);
                accountMailingStreet = AccountDomain.removeSpaceFromString(accountMailingStreet);
            }
        }       
        List<Account> accountList = [SELECT Name, 
                                     Id, 
                                     (SELECT npsp__MailingCity__c, 
                                      npsp__MailingCountry__c, 
                                      npsp__MailingPostalCode__c, 
                                      npsp__MailingState__c, 
                                      npsp__MailingStreet__c, 
                                      npsp__MailingStreet2__c,  
                                      Zip_4_Code__c                                                     
                                      FROM npsp__Addresses__r
                                      WHERE npsp__MailingCity__c =: accountMailingCity AND
                                      npsp__MailingCountry__c =: accountMailingCountry AND
                                      npsp__MailingPostalCode__c =: accountMailingPostalCode AND
                                      npsp__MailingState__c =:  accountMailingState AND
                                      npsp__MailingStreet__c =: accountMailingStreet AND
                                      npsp__MailingStreet2__c =: accountMailingStreet2  AND 
                                      Zip_4_Code__c =: accountMailingZip4code AND
                                      Apartment_Number__c =: accountAprtNumber AND
                                      npsp__Default_Address__c = true)
                                     FROM Account 
                                     WHERE Name =: accountName  AND
                                     Id !=: accountId];
        
        return accountList;         
    }
    public static Database.QueryLocator accountListByQueryLocator(String queryCriteria, Boolean checkCampaign){
        
        String query = 'SELECT Id, Name, Giving_Status__c, Donor_Type__c, RecordType.Name, RecordTypeId, npe01__One2OneContact__c';
        if(checkCampaign){
            
            query = query +' ,(SELECT Id, Amount,StageName,CloseDate,CampaignId'+
                ' FROM Opportunities'+
                queryCriteria+')';
        }                
        query = query + ' FROM Account'+
            ' WHERE Donor_Type__c =  \'Major Donor\' AND'+
            ' Giving_Status__c IN ( \'Prior\', \'Giver\') AND'+
            ' RecordType.Name = \'Organization\' AND' +
            ' Deceased__c = false';
        return Database.getQueryLocator(query);
    } 
    
     public Static List<Account> accountList(Set<Id> idSet){
        
        List<Account> accList = new List<Account>();
        accList = [Select RecordTypeId, Id, DO_officer__c, npe01__One2OneContact__c, npe01__One2OneContact__r.DO_Donor__c ,RecordType.Name
                   From Account
                   Where Id IN :idSet ];
        return accList;
    }
}