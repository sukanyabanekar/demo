public class AccountDomain {
    //domain changes debug
    public static void insertAccountRecord(Account accountObj, Id recordTypeId){       
        if(accountObj != null && recordTypeId != null){            
            accountObj.RecordTypeId = recordTypeId; 
            if(String.isEmpty(String.valueOf(accountObj.Address_Start_Date__c))){
                accountObj.Address_Start_Date__c = system.today();    	    
            }   
            if(accountObj.Id != null){
                Account accountToInsert = copyAccountDetails(accountObj);
                update accountToInsert;
            }
            else{
                insert accountObj;    
            }
            
        }
    }
    public static void changeHouseHoldName(List<sObject> newList, List<sObject> oldList){
        Map<Id,Account> mapNew = new Map<Id,Account>((List<Account>) newlist);
        Map<Id,Account> mapOld= new map<Id,Account>((List<Account>) oldList);
        Set<Id> contactIdSet=new Set<Id>();
        Set<Id> setAccountId = new Set<Id>();
        Id hRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.label.ContactSelector_Household).getRecordTypeId();
        for(Account accObject: mapNew.values()){
            if(accObject.RecordTypeId == hRecordType
               && (accObject.npe01__One2OneContact__c <> mapOld.get(accObject.Id).npe01__One2OneContact__c
                  )){
                      contactIdSet.add(accObject.npe01__One2OneContact__c); 
                      setAccountId.add(accObject.Id);
                  }
        }
        if(contactIdSet <> NULL && !contactIdSet.isEmpty()){
            List<Contact> lstContact= ContactSelector.getAccount(contactIdSet);
            if(lstContact <> NULL && !lstContact.isEmpty()){
                ContactDomain.householdNaming(lstContact,setAccountId,false);
            }
        }
    }
    
    //Update Experian verified on Account object
    public static List<Account> assignVerifiedAddress(npsp__Address__c addressObject){
        List<Account> accountList = new List<Account>();
        Account accountObjVerified = AddressSelector.getAccount(addressObject.npsp__Household_Account__c);
        Account objAccount= new Account();
        objAccount.Id = addressObject.npsp__Household_Account__c;
        objAccount.Address_Type__c = addressObject.npsp__Address_Type__c;
        objAccount.Do_not_mail__c = addressObject.Do_Not_Mail__c;
        objAccount.Experian_Override__c = addressObject.Override__c;
        objAccount.Zip4Code__c = addressObject.Zip_4_Code__c;
        objAccount.Street_2__c = addressObject.npsp__MailingStreet2__c;
        objAccount.Apartment_Number__c = addressObject.Apartment_Number__c;
        if(addressObject.npsp__Verified__c == true){
            if(accountObjVerified.Experian_Verified__c <> NULL 
               && String.isNotBlank(accountObjVerified.Experian_Verified__c)){
                   if(!accountObjVerified.Experian_Verified__c.Contains(system.Label.AddressService_AddressVerified)){
                       objAccount.Experian_Verified__c =system.Label.AddressService_AddressVerified +';'+ accountObjVerified.Experian_Verified__c;
                   }
               }
            else{
                objAccount.Experian_Verified__c =system.Label.AddressService_AddressVerified;
            }
        }
        else if(addressObject.npsp__Verified__c == false ){
            if(accountObjVerified.Experian_Verified__c <> NULL 
               && String.isNotBlank(accountObjVerified.Experian_Verified__c)){
                   if(accountObjVerified.Experian_Verified__c.Contains(system.Label.AddressService_AddressVerified)) {
                       objAccount.Experian_Verified__c = accountObjVerified.Experian_Verified__c.remove(system.Label.AddressService_AddressVerified );
                   }
                   else if(accountObjVerified.Experian_Verified__c.Contains(system.Label.AddressService_AddressVerified + ';')){
                       objAccount.Experian_Verified__c = accountObjVerified.Experian_Verified__c.remove(system.Label.AddressService_AddressVerified +';' );
                   }
               }
        }
        accountList.add(objAccount);
        if(accountList <> NULL && !accountList.isEmpty()){
            update accountList;
            return accountList;
        }
        return NULL;
    }
    public static String removeSpaceFromString( String stringWithSpace){
        
        
        if( stringWithSpace != null && !String.isBlank(stringWithSpace)){ 
            
            return stringWithSpace.replaceAll( '\\s+', ' ').trim();
        }
        return null;
    }
    public static Account copyAccountDetails(Account oldAccount){
        
        Account newAccountDetails = new Account();
        newAccountDetails.Id=oldAccount.Id;
        newAccountDetails.Account_Type__c=oldAccount.Account_Type__c;
        newAccountDetails.Designation__c=oldAccount.Designation__c;
        newAccountDetails.Account_Status__c=oldAccount.Account_Status__c;
        newAccountDetails.Name=oldAccount.Name;
        newAccountDetails.Note__c=oldAccount.Note__c;
        newAccountDetails.Business_Phone_Ext__c=oldAccount.Business_Phone_Ext__c;
        newAccountDetails.Business__c=oldAccount.Business__c;
        newAccountDetails.RecordTypeId=oldAccount.RecordTypeId;
        newAccountDetails.Religious_Observance__c=oldAccount.Religious_Observance__c;
        newAccountDetails.BillingPostalCode=oldAccount.BillingPostalCode;
        newAccountDetails.Experian_Verified__c=oldAccount.Experian_Verified__c;
        newAccountDetails.Bill_Month__c=oldAccount.Bill_Month__c; 
        newAccountDetails.Practice_Area__c=oldAccount.Practice_Area__c;
        newAccountDetails.Offlist_Reason__c=oldAccount.Offlist_Reason__c;
        newAccountDetails.Giving_Status__c=oldAccount.Giving_Status__c;
        newAccountDetails.Offlist_Date__c=oldAccount.Offlist_Date__c;
        newAccountDetails.DO_officer__c=oldAccount.DO_officer__c;
        newAccountDetails.Fax=oldAccount.Fax;
        newAccountDetails.Business_Email__c=oldAccount.Business_Email__c;
        newAccountDetails.npe01__One2OneContact__c = oldAccount.npe01__One2OneContact__c;
        newAccountDetails.npo02__Informal_Greeting__c = oldAccount.npo02__Informal_Greeting__c;
        newAccountDetails.npo02__HouseholdPhone__c = oldAccount.npo02__HouseholdPhone__c;
        newAccountDetails.Industry = oldAccount.Industry;
        newAccountDetails.Campaign_Division__c = oldAccount.Campaign_Division__c;
        return newAccountDetails;
    }
}
