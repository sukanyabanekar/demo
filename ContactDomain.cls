public class ContactDomain {
   public static Contact insertContact(Contact con){
        if(con.Id != null){
            Contact contactObj = new Contact(Id = con.Id);
            contactObj.Salutation = con.Salutation;
            contactObj.Giving_Status__c = con.Giving_Status__c;
            contactObj.npe01__Primary_Address_Type__c = con.npe01__Primary_Address_Type__c;
            contactObj.Experian_Verified__c = con.Experian_Verified__c;
            contactObj.FirstName = getTrimmedData(con.FirstName);
            contactObj.LastName = getTrimmedData(con.LastName);
            contactObj.MaidenName__c = getTrimmedData(con.MaidenName__c);
            contactObj.Nickname__c = getTrimmedData(con.Nickname__c);
            contactObj.Gender__c = con.Gender__c;
            contactObj.Giving_Status__c = con.Giving_Status__c;
            contactObj.Note__c = getTrimmedData(con.Note__c);
            contactObj.MiddleName__c = getTrimmedData(con.MiddleName__c);
            contactObj.Sub_Title__c = con.Sub_Title__c;
            contactObj.npe01__PreferredPhone__c = con.npe01__PreferredPhone__c;
            contactObj.Cell__c = getTrimmedData(con.Cell__c);
            contactObj.npe01__WorkPhone__c = con.npe01__WorkPhone__c;
            contactObj.Business_Phone_Ext__c = con.Business_Phone_Ext__c;
            contactObj.Residence__c = getTrimmedData(con.Residence__c);
            contactObj.npe01__Preferred_Email__c = con.npe01__Preferred_Email__c;
            contactObj.npe01__HomeEmail__c = getTrimmedData(con.npe01__HomeEmail__c);
            contactObj.npe01__WorkEmail__c = getTrimmedData(con.npe01__WorkEmail__c);
            contactObj.Birthdate = con.Birthdate;
            contactObj.Formal_Name__c = con.Formal_Name__c;
            contactObj.Informal_Name__c = con.Informal_Name__c;
            contactObj.DO_Donor__c = con.DO_Donor__c;
            contactObj.Nationality__c = con.Nationality__c;    
            contactObj.Religious_Observance__c = con.Religious_Observance__c;    
            contactObj.Identity_Type__c = con.Identity_Type__c;    
            contactObj.Practice_Area__c = con.Practice_Area__c;    
            contactObj.Marital_Status__c = con.Marital_Status__c;    
            contactObj.Account_Status__c = con.Account_Status__c;    
            contactObj.Offlist_Reason__c = con.Offlist_Reason__c;    
            contactObj.Offlist_Date__c = con.Offlist_Date__c;
            contactObj.Deceased_Date__c = con.Deceased_Date__c;
            contactObj.Campaign_Division__c = con.Campaign_Division__c;
            contactObj.Industry__c = con.Industry__c;
            contactObj.Facebook_URL__c = con.Facebook_URL__c;
            contactObj.LinkedIN_URL__c = con.LinkedIN_URL__c;
	    contactObj.Deceased_Date__c = con.Deceased_Date__c;
            contactObj.Contribute_Other_Account__c = con.Contribute_Other_Account__c;    
            contactObj.Marketable_Other_Account__c = con.Marketable_Other_Account__c;    
            contactObj.Legacy_Endowment__c = con.Legacy_Endowment__c;
            contactObj.Mission_Candidate__c = con.Mission_Candidate__c;    
            contactObj.Centennial_Annonymous__c = con.Centennial_Annonymous__c;    
            Database.UpsertResult  lsr = Database.upsert(contactObj,true);
        }
        else{
            con.npsp__is_Address_Override__c = true;
            con.FirstName = getTrimmedData(con.FirstName);
            con.LastName = getTrimmedData(con.LastName);
            con.MiddleName__c = getTrimmedData(con.MiddleName__c);
            con.Nickname__c = getTrimmedData(con.Nickname__c);
            con.MailingCity = getTrimmedData(con.MailingCity);
            con.MailingCountry = getTrimmedData(con.MailingCountry);
            con.MailingPostalCode = getTrimmedData(con.MailingPostalCode);
            con.MailingState = getTrimmedData(con.MailingState);
            con.MailingStreet = getTrimmedData(con.MailingStreet);
            con.Street_2__c = getTrimmedData(con.Street_2__c);
            con.Note__c = getTrimmedData(con.Note__c);
            con.MaidenName__c = getTrimmedData(con.MaidenName__c);
            if(String.isEmpty(String.valueOf(con.Address_Start_Date__c))){
                con.Address_Start_Date__c = system.today();         
            }
            Database.UpsertResult  lsr = Database.upsert(con,true);
        }
        return con;
    }
    
    public static string getTrimmedData(String data){
        
        if(data != null && !String.isBlank(data)){
        	data = data.replaceAll('\\s+',' ').trim();    
        }
        return data;
    }
    public static void updateContactAttachement(String contactID, String attachmentID){
        Contact contactObj = new Contact(id = contactID);
        contactObj.Attachment_Id__c = attachmentID; 
        database.update(contactObj);
    }
    
    //method called when user creates contact to set household name
    public static void afterInsertHouseholdNaming (List<Contact> newList, List<Contact> oldList){
        List<Contact> newContactList =new List<Contact>();
        Set<Id> contactIdSet= new Set<Id>();
        Set<Id> accountIdSet= new Set<Id>();
        for (Contact objContact : newList) {
            contactIdSet.add(objContact.Id);
            accountIdSet.add(objContact.AccountId);
        }
        newContactList= ContactSelector.getAccount(contactIdSet);
        householdNaming(newContactList,accountIdSet,true);
    }
        public static void afterUpdateHouseholdNaming (List<Contact> newList, List<Contact> oldList){
        List<Contact> updatedContactList = (List<Contact>)newlist;
        List<Contact> newContactList = new List<Contact>(); 
        map<Id,Contact> oldMap= new map<Id,Contact>((List<Contact>) oldList);
        Set<Id> contactIdSet= new Set<Id>();
        Set<Id> accountIdSet= new Set<Id>();
        Set<Id> accountIdSetOld= new Set<Id>();
        for (Contact objContact : updatedContactList ) {
            newContactList = new List<Contact>();
            if((objContact.FirstName <> oldMap.get(objContact.Id).FirstName ||
                objContact.LastName <> oldMap.get(objContact.Id).LastName
                || objContact.Salutation <> oldMap.get(objContact.Id).Salutation)
                || objContact.AccountId <> oldMap.get(objContact.Id).AccountId
                || objContact.Gender__c <> oldMap.get(objContact.Id).Gender__c){
                   contactIdSet.add(objContact.Id);
                   accountIdSet.add(objContact.AccountId);
                   accountIdSetOld.add(oldMap.get(objContact.Id).AccountId);
               }
        }
        if(contactIdSet <> NULL && !contactIdSet.isEmpty()){
            newContactList= ContactSelector.getAccount(contactIdSet);
        }
        if(newContactList <> NULL && !newContactList.isEmpty()){
            householdNaming(newContactList,accountIdSet,false);
        }
        if(accountIdSetOld <> NULL && !accountIdSetOld.isEmpty()){
            List<npe4__Relationship__c> relationList  =  new List<npe4__Relationship__c> ();
            list<Contact> contactList= new list<Contact>();
            relationList = getRelationship(accountIdSetOld);
            if(relationList <> NULL && !relationList.isEmpty()){
                applyHouseholdNamingRule(relationList);
            }
            else{
                contactList= ContactSelector.getPrimaryContact(accountIdSetOld);
                if(contactList <> NULL && !contactList.isEmpty()){
                    updateHouseholdName(contactList);
                }
            }            
        }
    }

    // method to check the criteria of Contact to set household name
    public static void householdNaming(list<Contact> newContactList,Set<Id> accountIdSet,Boolean InsertOperation){
        list<Contact> contactList= new list<Contact>();
        Set<Id> contactId= new Set<Id>();
        List<npe4__Relationship__c> relationList  =  new List<npe4__Relationship__c> ();
        if(newContactList <> NULL && !newContactList.isEmpty()){
            for(Contact objCon: newContactList){
                contactId.add(objCon.Id);
                if(objCon.Account.npsp__Number_of_Household_Members__c == 1 
                   || objCon.Account.npsp__Number_of_Household_Members__c == NULL){ // if only one household memmber is available
                       contactList.add(objCon);
                   }
                else{
                    if(accountIdSet <> NULL && !accountIdSet.isEmpty() && InsertOperation == false){ // after update if relationship exist
                        relationList= getRelationship(accountIdSet);
                    }
                }
            }
        }
        if(relationList <> NULL && !relationList.isEmpty()){ //  relationship found
            applyHouseholdNamingRule(relationList);
        }
        else if(contactList <> NULL && !contactList.isEmpty()){ //  a single Contact
            updateHouseholdName(contactList);
        }
        else{
            if(contactId <> NULL && !contactId.isEmpty()){
                contactList= ContactSelector.getAccount(contactId);
            }
            if(contactList <> NULL && !contactList.isEmpty()){
                updateHouseholdName(contactList);
            }
        }
    }

    //query on relationship
    public static List<npe4__Relationship__c> getRelationship(Set<Id> accountIdSet){
        List<npe4__Relationship__c> relationShipList =new List<npe4__Relationship__c>();
        Id householdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.label.ContactSelector_Household).getRecordTypeId();
        if(householdRecordTypeId <> NULL && String.isNotBlank(householdRecordTypeId)){
        	relationShipList = RelationShipSelector.fetchRelationShip(accountIdSet,householdRecordTypeId);
        }
        return relationShipList;
    }
    // check if relationship exist to set the household name
    public static void applyHouseholdNamingRule(List <npe4__Relationship__c> newRelationShipList){
        map<Id,Id> mapMaster_RelatedConId= new map<Id,Id>();
        List<Contact> contactList= new List<Contact>();
        Set<Id> contactIdSet= new Set<Id>();
        for (npe4__Relationship__c objRelation : newRelationShipList) {
            if((objRelation.npe4__Type__c == system.label.AccountSelector_Spouse 
                || objRelation.npe4__Type__c == system.label.AccountSelector_significant) 
               && objRelation.npe4__Status__c == system.label.RelationshipSelector_Active){
                   mapMaster_RelatedConId.put(objRelation.npe4__Contact__c, objRelation.npe4__RelatedContact__c);
               }
            else if((objRelation.npe4__Type__c == system.label.AccountSelector_Spouse 
                     || objRelation.npe4__Type__c == system.label.AccountSelector_significant) 
                    && objRelation.npe4__Status__c == system.label.RelationshipSelector_InActive){
                        contactIdSet.add(objRelation.npe4__Contact__c);
                        contactIdSet.add(objRelation.npe4__RelatedContact__c);
                    }
        }
        if(contactIdSet <> NULL && !contactIdSet.isEmpty()){
            contactList= ContactSelector.getAccount(contactIdSet);
        }
        if(contactList <> NULL && !contactList.isEmpty()){
            updateHouseholdName(contactList);
        }
        Set<String> normalTitle= new Set<String>();
        Set<String> specialTitles= new Set<String>();
        List<String> titleList= new List<String>();
        List<ContactTitles__c> customSettingList = ContactTitles__c.getAll().values();
        for(ContactTitles__c cont :customSettingList){
            titleList= cont.Normal_Title__c.trim().split(',');
            normalTitle.addAll(titleList);
            titleList= new List<String>();
            titleList= cont.Normal_Special_Titles__c.trim().split(',');
            specialTitles.addAll(titleList);
            titleList= new List<String>();
            titleList= cont.Special_Titles__c.trim().split(',');
            specialTitles.addAll(titleList);
        }
        List<Account> listAccount = new List <Account>();
        List<Contact> masterContactList = new List <Contact>();
        List<Contact> relatedContactList = new List <Contact>();
        if(mapMaster_RelatedConId <> NULL && !mapMaster_RelatedConId.isEmpty()){
            masterContactList= ContactSelector.getAccount(mapMaster_RelatedConId.keySet());
            
            relatedContactList= ContactSelector.getAccount(new Set<Id>(mapMaster_RelatedConId.values()));
            map<Id,Contact> mapMasterContact= new map<Id,Contact>();
            map<Id,Contact> mapRelatedContact= new map<Id,Contact>();
            if(masterContactList <> NULL && !masterContactList.isEmpty()){
                for(Contact objConMaster: masterContactList){
                    mapMasterContact.put(objConMaster.AccountId,objConMaster);
                }
            }
            if(relatedContactList <> NULL && !relatedContactList.isEmpty()){
                for(Contact objConRelated: relatedContactList){
                    mapRelatedContact.put(objConRelated.AccountId,objConRelated);
                }
            }
            if(mapMasterContact <> NULL && !mapMasterContact.isEmpty()
               && mapRelatedContact <> NULL && !mapRelatedContact.isEmpty()){
                   listAccount= ContactDomain.changeHouseHoldName(mapMasterContact,mapRelatedContact,
                                                                  normalTitle,specialTitles);
                   if(listAccount <> NULL && !listAccount.isEmpty()){
                       updateAccount(listAccount);
                   }
               }
        }    
    }
    // update the household name
    public static void updateHouseholdName(List<Contact> conList){
        list<Account> accountList= new list<Account>();
        accountList= ContactDomain.assignAccount(conList);
        updateAccount(accountList);
    }
    // this method is to check what formal and household name to be set depending upon gender 
    public static List<Account> changeHouseHoldName(map<Id,Contact> mapMasterContact, map<Id,Contact> mapRelatedContact, set<String> normalTitle,set<String> specialTitles){
        List<Account> accountList= new List<Account>();
        String houseHoldSalutation='',householdName='',formalName='';
        for(Contact objCon: mapMasterContact.values()){
            Account objAccount = new Account();
            if(objCon <> NULL && mapRelatedContact.get(objCon.AccountId).Account.Id <> NULL){
              if(objCon.AccountId == mapRelatedContact.get(objCon.AccountId).AccountId){
                objAccount.Id= objCon.AccountId;
                    if(normalTitle.contains(objCon.Salutation) &&
                       normalTitle.contains(mapRelatedContact.get(objCon.AccountId).Salutation)){
                           if(objCon.Id == objCon.Account.npe01__One2OneContact__c){ // contact is primary
                               if(objCon.LastName == mapRelatedContact.get(objCon.AccountId).LastName){ // both have got same surname
                                   if(objCon.Gender__c == system.label.ContactDomain_Male){
                                       houseHoldSalutation = objCon.Salutation;
                                       houseHoldSalutation += ' & '+mapRelatedContact.get(objCon.AccountId).Salutation;
                                       householdName = objCon.Name;
                                   }
                                   else{
                                       houseHoldSalutation = mapRelatedContact.get(objCon.AccountId).Salutation;
                                       houseHoldSalutation += ' & '+objCon.Salutation;
                                       householdName = mapRelatedContact.get(objCon.AccountId).Name;
                                   }
                                   objAccount.Name = houseHoldSalutation +' '+householdName;
                                   objAccount.npo02__Formal_Greeting__c = houseHoldSalutation + ' '+objCon.LastName;
                                   accountList.add(objAccount);
                               }
                               else{
                                   if(objCon.Gender__c == system.label.ContactDomain_Male){
                                       houseHoldSalutation = objCon.Salutation + ' '+objCon.Name;
                                       houseHoldSalutation += ' & '+mapRelatedContact.get(objCon.AccountId).Salutation +' '+ mapRelatedContact.get(objCon.AccountId).Name;
                                       formalName = objCon.Salutation + ' '+objCon.LastName; 
                                       formalName+= ' & '+mapRelatedContact.get(objCon.AccountId).Salutation +' '+ mapRelatedContact.get(objCon.AccountId).LastName;
                                   }
                                   else{
                                       houseHoldSalutation = mapRelatedContact.get(objCon.AccountId).Salutation + '' +mapRelatedContact.get(objCon.AccountId).Name;
                                       houseHoldSalutation += ' & '+objCon.Salutation +' '+objCon.Name;
                                       formalName = mapRelatedContact.get(objCon.AccountId).Salutation +' '+ mapRelatedContact.get(objCon.AccountId).LastName;
                                       formalName+= ' & '+objCon.Salutation +' '+ objCon.LastName;
                                   }
                                   objAccount.Name = houseHoldSalutation ;
                                   objAccount.npo02__Formal_Greeting__c = formalName;
                                   accountList.add(objAccount);     
                               }
                           }
                           else if(mapRelatedContact.get(objCon.AccountId).Id == objCon.Account.npe01__One2OneContact__c){
                               if(objCon.LastName == mapRelatedContact.get(objCon.AccountId).LastName){ // both have got same surname
                                   if(mapRelatedContact.get(objCon.AccountId).Gender__c == system.label.ContactDomain_Male){
                                       houseHoldSalutation = mapRelatedContact.get(objCon.AccountId).Salutation;
                                       houseHoldSalutation += ' & '+objCon.Salutation;
                                       householdName = mapRelatedContact.get(objCon.AccountId).Name;
                                   }
                                   else{
                                       houseHoldSalutation =objCon.Salutation;
                                       houseHoldSalutation += ' & '+mapRelatedContact.get(objCon.AccountId).Salutation;
                                       householdName =objCon.Name;
                                   }
                                   objAccount.Name = houseHoldSalutation +' '+householdName;
                                   objAccount.npo02__Formal_Greeting__c = houseHoldSalutation + ' '+objCon.LastName;
                                   accountList.add(objAccount);
                               }
                               else{
                                   if(mapRelatedContact.get(objCon.AccountId).Gender__c == system.label.ContactDomain_Male){
                                       houseHoldSalutation = mapRelatedContact.get(objCon.AccountId).Salutation + ' '+mapRelatedContact.get(objCon.AccountId).Name;
                                       houseHoldSalutation += ' & '+objCon.Salutation +' '+ objCon.Name;
                                       formalName = mapRelatedContact.get(objCon.AccountId).Salutation + ' '+mapRelatedContact.get(objCon.AccountId).LastName; 
                                       formalName+= ' & '+objCon.Salutation +' '+objCon.LastName;
                                   }
                                   else{
                                       houseHoldSalutation = objCon.Salutation + ' ' +objCon.Name;
                                       houseHoldSalutation += ' & '+mapRelatedContact.get(objCon.AccountId).Salutation +' '+mapRelatedContact.get(objCon.AccountId).Name;
                                       formalName = objCon.Salutation +' '+objCon.LastName;
                                       formalName+= ' & '+mapRelatedContact.get(objCon.AccountId).Salutation +' '+ mapRelatedContact.get(objCon.AccountId).LastName;
                                   }
                                   objAccount.Name = houseHoldSalutation ;
                                   objAccount.npo02__Formal_Greeting__c = formalName;
                                   accountList.add(objAccount);     
                               }
                           }
                       }
                    else if(specialTitles.contains(objCon.Salutation) && 
                            normalTitle.contains(mapRelatedContact.get(objCon.AccountId).Salutation)){
                                if(objCon.LastName == mapRelatedContact.get(objCon.AccountId).LastName){
                                    householdName = objCon.Formal_Name__c;
                                    householdName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                    formalName=  objCon.Gender__c == system.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                    formalName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Salutation;
                                    formalName+= ' '+objCon.LastName;
                                }
                                else{
                                    householdName = objCon.Formal_Name__c;
                                    householdName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                    formalName= objCon.Gender__c == system.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                    formalName+= objCon.LastName+ ' & '+ mapRelatedContact.get(objCon.AccountId).Salutation +' '+mapRelatedContact.get(objCon.AccountId).LastName;
                                }
                                objAccount.Name = householdName ;
                                objAccount.npo02__Formal_Greeting__c = formalName;
                                accountList.add(objAccount);
                            }
                    else if(normalTitle.contains(objCon.Salutation) && 
                            specialTitles.contains(mapRelatedContact.get(objCon.AccountId).Salutation)){
                                if(objCon.LastName == mapRelatedContact.get(objCon.AccountId).LastName){
                                    householdName = mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                    householdName+= ' & '+ objCon.Formal_Name__c;
                                    formalName=  mapRelatedContact.get(objCon.AccountId).Gender__c== System.label.ContactDomain_Male?'Mr.':'Mrs.';
                                    formalName += ' & '+ objCon.Salutation;
                                    formalName += ' '+mapRelatedContact.get(objCon.AccountId).LastName;
                                }
                                else{
                                    householdName = mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                    householdName+= ' & '+ objCon.Formal_Name__c;
                                    formalName=  mapRelatedContact.get(objCon.AccountId).Gender__c== System.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                    formalName+= mapRelatedContact.get(objCon.AccountId).LastName +' & '+ objCon.Salutation +' '+objCon.LastName;
                                }
                                objAccount.Name = householdName ;
                                objAccount.npo02__Formal_Greeting__c = formalName;
                                accountList.add(objAccount);
                            }
                    else if(specialTitles.contains(objCon.Salutation.trim()) && 
                            specialTitles.contains(mapRelatedContact.get(objCon.AccountId).Salutation.trim())){
                                if(objCon.LastName == mapRelatedContact.get(objCon.AccountId).LastName){
                                    if(objCon.Gender__c == system.label.ContactDomain_Male){
                                        householdName = objCon.Formal_Name__c;
                                        householdName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                        formalName=  'Mr.' + ' & ';
                                        formalName +=mapRelatedContact.get(objCon.AccountId).Gender__c == System.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                        formalName += objCon.LastName;
                                    }
                                    else if(mapRelatedContact.get(objCon.AccountId).Gender__c == system.label.ContactDomain_Male) {
                                        householdName = mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                        householdName+= ' & '+ objCon.Formal_Name__c;
                                        formalName=  'Mr.' + ' & ';
                                        formalName+= objCon.Gender__c == System.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                        formalName+= mapRelatedContact.get(objCon.AccountId).LastName;
                                    }
                                    else{
                                        if(objCon.Account.npe01__One2OneContact__c == objCon.Id){
                                            householdName = objCon.Formal_Name__c;
                                            householdName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                            formalName=  'Mrs.' + ' & '+ 'Mrs.';
                                            formalName+= objCon.LastName;
                                        }
                                        else {
                                            householdName = mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                            householdName+= ' & '+ objCon.Formal_Name__c;
                                            formalName=  'Mr.' + ' & ';
                                            formalName+= objCon.Gender__c == System.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                            formalName+= mapRelatedContact.get(objCon.AccountId).LastName; 
                                        }
                                    }
                                    objAccount.Name = householdName ;
                                    objAccount.npo02__Formal_Greeting__c = formalName;
                                    accountList.add(objAccount);
                                }
                                else{
                                    if(objCon.Gender__c == system.label.ContactDomain_Male){
                                        householdName = objCon.Formal_Name__c;
                                        householdName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                        formalName=  'Mr.' +objCon.LastName+ ' & ';
                                        formalName+= mapRelatedContact.get(objCon.AccountId).Gender__c == System.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                        formalName+= mapRelatedContact.get(objCon.AccountId).LastName;
                                    }
                                    else if(mapRelatedContact.get(objCon.AccountId).Gender__c == system.label.ContactDomain_Male) {
                                        householdName = mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                        householdName+= ' & '+ objCon.Formal_Name__c;
                                        formalName=  'Mr.' + mapRelatedContact.get(objCon.AccountId).LastName +' & ';
                                        formalName+= objCon.Gender__c == System.label.ContactDomain_Male ? 'Mr.':'Mrs.';
                                        formalName+= objCon.LastName;
                                    }
                                    else{
                                        if(objCon.Account.npe01__One2OneContact__c == objCon.Id){
                                            householdName = objCon.Formal_Name__c;
                                            householdName+= ' & '+ mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                            formalName=  'Mrs.' +objCon.LastName+ ' & '+ 'Mrs.';
                                            formalName+= mapRelatedContact.get(objCon.AccountId).LastName;
                                        }
                                        else {
                                            householdName = mapRelatedContact.get(objCon.AccountId).Formal_Name__c;
                                            householdName+= ' & '+ objCon.Formal_Name__c;
                                            formalName= 'Mrs.' +mapRelatedContact.get(objCon.AccountId).LastName+ ' & '+ 'Mrs.';
                                            formalName+= objCon.LastName;
                                        }
                                    } 
                                    objAccount.Name = householdName ;
                                    objAccount.npo02__Formal_Greeting__c = formalName;
                                    accountList.add(objAccount);
                                }
                            }
                }
                else{
                    if(mapMasterContact <> NULL && !mapMasterContact.isEmpty()){
                        assignAccount(new List<Contact>{objCon});
                    }
                }
            }
        }
        return accountList;
    }
    
    //this method is to change the household name if primary contact name is changed
    public static List<Account> assignAccount(List<Contact> lstContact){
        list<Account> accountList= new list<Account>();
        Account accountObj;
        for(Contact objCon: lstContact){
            if(objCon.Id == objCon.Account.npe01__One2OneContact__c){
                accountObj= new Account();
                accountObj.Id = objCon.AccountId;
                accountObj.Name= objCon.Formal_Name__c;
                accountObj.npo02__Formal_Greeting__c = objCon.Formal_Name__c;
                accountList.add(accountObj);
            }
            else if(objCon.Account.npsp__Number_of_Household_Members__c == 1) {
                accountObj= new Account();
                accountObj.Id = objCon.AccountId;
                accountObj.Name= objCon.Formal_Name__c;
                accountObj.npo02__Formal_Greeting__c = objCon.Formal_Name__c;
                accountList.add(accountObj);
            }
        }
        return accountList;
    }
    //Assign the account as deceased
    public static List<Account> assignDeceasedAccount(List<Contact> lstContact){
        List<Account> lstAccount= new List<Account>();
        for(Contact objCon: lstContact){
            Account accountObj= new Account();
            accountObj.Id= objCon.AccountId;
            accountObj.Deceased__c = true;
            accountObj.Deceased_Date__c = objCon.Deceased_Date__c;
            lstAccount.add(accountObj);
        }
        return lstAccount;
    }
    //Check if the existing contact is deceased or not
    public static void checkContactDeceased(List <sObject> newList, List<sObject> oldList){
        List<Contact> updatedContactList = (List<Contact>)newlist;
        List<Account> lstAccount= new List<Account>();
        map<Id,Contact> oldMap= new map<Id,Contact>((List<Contact>) oldList);
        Set<Id> oldContactSetId= new Set<Id>();
        Set<Id> oldAccountId= new Set<Id>();
        Set<Id> existingContactIdSet= new Set<Id>();
        List<Contact> newContactList = new List<Contact>();
        List<Contact> lstExistingContact= new List<Contact>();
        List<npe4__Relationship__c> relationshipListUpdate =  new List<npe4__Relationship__c>();
        for (Contact objContact : updatedContactList) {
            if(objContact.npsp__Deceased__c == true && objContact.npsp__Deceased__c <> oldMap.get(objContact.Id).npsp__Deceased__c){
                oldContactSetId.add(objContact.Id);// contact Id to check if relationship exist
                oldAccountId.add(objContact.AccountId);//OLD ACCOUNT OF A CONTACT IN CASE IF IT IS CHANGED
            }
        }
        if(oldContactSetId <> NULL && !oldContactSetId.isEmpty()){
            List<Contact> lstContact = new List<Contact>();
            Set<Id> contactId= ContactSelector.getPrimaryContactId(oldContactSetId);
            lstContact= ContactSelector.getContactWithRelationShip(oldContactSetId);
            if(lstContact <> NULL && !lstContact.isEmpty()){
                for(Contact conObject: lstContact){
                    for(npe4__Relationship__c objRelation : conObject.npe4__Relationships__r){
                        objRelation.End_Date__c= date.today();
                        relationshipListUpdate.add(objRelation);
                    }
                }
            }
            if(oldAccountId <> NULL && !oldAccountId.isEmpty()){
                // if there is no relationship then just check the count of Contact for that Account 
                lstExistingContact = ContactSelector.getNoOfContactForAccount(oldAccountId);
                if(lstExistingContact.size() > 1 && contactId <> NULL && !contactId.isEmpty()){ // create task if there are more that 2 Contacts for Account
                    ShowErrorMessage(updatedContactList,contactId);
                }
                else if(lstExistingContact.size() ==  1){ // if only one primary contact exist in household, marked as deceased
                    lstAccount= assignDeceasedAccount(updatedContactList);
                    if(lstAccount <> NULL && !lstAccount.isEmpty()){
                    	updateAccount(lstAccount);    
                    }
                }
            }
            if(relationshipListUpdate <> NULL && !relationshipListUpdate.isEmpty()){
                RelationshipDomain.updateRelationshipStatus(relationshipListUpdate);
            }
        }
    }    
   
    //method called when user remove primary contact to set add/update address record from household
    public static void afterUpdateRemoveContact(List<sObject> newlist, List<sObject> oldlist){
        List<Contact> updatedContactList = (List<Contact>)newlist;
        List<Contact> contactList = new List<Contact>();
        map<Id,Contact> oldMap= new map<Id,Contact>((List<Contact>) oldList);
        Set<Id> oldAccountId= new Set<Id>();
        Set<Id> setOtherAddressId= new Set<Id>(); 
        map<Id,Id> mapContact_AccountId= new Map<Id,Id>();
        Set<Id> existingContactIdSet= new Set<Id>();
        Map<Id,Id> mapAccount_AddressId= new Map<Id,Id>();
        Map<Id,Contact> mapAddressId_Contact= new Map<Id,Contact>();
        for (Contact objContact : updatedContactList) {
            if(objContact.AccountId <> oldMap.get(objContact.Id).AccountId){
                mapContact_AccountId.put(objContact.Id,objContact.AccountId);
                oldAccountId.add(oldMap.get(objContact.Id).AccountId); // to get other Contact Address Id
                mapAddressId_Contact.put(objContact.npsp__Current_Address__c,objContact);
            }
        }
        if(oldAccountId <> NULL && !oldAccountId.isEmpty()){
            List<Contact_Address__c> contactAddressList=ContactAddressSelector.getAddressId(oldAccountId);
            if(contactAddressList <> NULL && !contactAddressList.isEmpty()){
                for(Contact_Address__c objConAdd: contactAddressList){
                    setOtherAddressId.add(objConAdd.Address__c); // address id from other contact of old household
                }    
            }
        }

        if(mapContact_AccountId <> NULL && !mapContact_AccountId.isEmpty()){
            List<Contact_Address__c> lstContactAddress= 
                ContactAddressSelector.getAddress(mapContact_AccountId.keySet()); // get Contact of removed Contact
			Set<Id> addressIdFromOldAccount = AddressSelector.getAddressIdOldAccount(oldAccountId); //address if it is primary id from old household
            map<Id,npsp__Address__c> mapAddressAccount = AddressSelector.getAddressFromAccount(mapContact_AccountId.values()); //get the Address of new Account  
            for(npsp__Address__c addressObject: mapAddressAccount.values()){
                mapAccount_AddressId.put(addressObject.npsp__Household_Account__c,addressObject.Id);
            }
            if(lstContactAddress <> NULL && !lstContactAddress.isEmpty()){
                setAddressesToNewHousehold(lstContactAddress,mapContact_AccountId,setOtherAddressId,mapAccount_AddressId, addressIdFromOldAccount,mapAddressId_Contact);
            }
        }
    }

    //method to set address to new household
	public static void setAddressesToNewHousehold (List<Contact_Address__c> lstContactAddress,Map<Id,Id> mapContact_AccountId,
    Set<Id> setOtherAddressId, Map<Id,Id> mapAccount_AddressId,Set<Id> addressIdFromOldAccount, Map<Id, Contact>mapAddressId_Contact){
        List<npsp__Address__c> deleteAddressRecordList= new List<npsp__Address__c>();
        List<Contact_Address__c> updateContactAddressPrimary= new List<Contact_Address__c>();
        Map<Id,npsp__Address__c> contactAddressId_addressMap= new Map<Id,npsp__Address__c>();
        List<npsp__Address__c> listAddress= new List<npsp__Address__c>();
        for(Contact_Address__c objContactAddress: lstContactAddress){
            if(objContactAddress.Primary__c == false){
                if(setOtherAddressId.contains(objContactAddress.Address__c) ||
                   addressIdFromOldAccount.Contains(objContactAddress.Address__c)){ // if contactAddress exist in another contact or is the primary address for household
                       // create new address for new houshold and assign that to Contact address
                       npsp__Address__c newAddressObj= new npsp__Address__c();
                       newAddressObj.npsp__Household_Account__c= mapContact_AccountId.get(objContactAddress.Donor__c);
                       newAddressObj.npsp__MailingCountry__c = objContactAddress.Address__r.npsp__MailingCountry__c;
                       newAddressObj.npsp__MailingCity__c = objContactAddress.Address__r.npsp__MailingCity__c;
                       newAddressObj.npsp__MailingState__c = objContactAddress.Address__r.npsp__MailingState__c;
                       newAddressObj.npsp__MailingStreet__c = objContactAddress.Address__r.npsp__MailingStreet__c;
                       newAddressObj.npsp__MailingStreet2__c = objContactAddress.Address__r.npsp__MailingStreet2__c;
                       newAddressObj.npsp__MailingPostalCode__c = objContactAddress.Address__r.npsp__MailingPostalCode__c;
                       newAddressObj.npsp__Verified__c = objContactAddress.Address__r.npsp__Verified__c;
                       newAddressObj.Override__c = objContactAddress.Address__r.Override__c;
                       newAddressObj.Apartment_Number__c = objContactAddress.Address__r.Apartment_Number__c;
                       newAddressObj.Do_Not_Mail__c = objContactAddress.Address__r.Do_Not_Mail__c;
                       newAddressObj.Zip_4_Code__c = objContactAddress.Address__r.Zip_4_Code__c;
                       newAddressObj.npsp__Default_Address__c = objContactAddress.Address__r.npsp__Default_Address__c;
                       newAddressObj.npsp__Latest_Start_Date__c = date.today();
                       newAddressObj.npsp__Address_Type__c = objContactAddress.Address__r.npsp__Address_Type__c;
                       contactAddressId_addressMap.put(objContactAddress.Id,newAddressObj);
                   }
                else{ // does not exist update Address of Account lookup to new household Account
                    npsp__Address__c updateAddressObj= new npsp__Address__c();
                	updateAddressObj.Id = objContactAddress.Address__c;
                	updateAddressObj.npsp__Household_Account__c = mapContact_AccountId.get(objContactAddress.Donor__c);
                	listAddress.add(updateAddressObj);
                }
            }
            else{
				if(setOtherAddressId.contains(objContactAddress.Address__c)
                  || addressIdFromOldAccount.Contains(objContactAddress.Address__c)){ // if primary contactAddress exist in another contact 
                }
                else{ // does not exist then delete the address from old household
                    npsp__Address__c deleteAddress= new npsp__Address__c();
                    deleteAddress.Id = objContactAddress.Address__c;
                    deleteAddressRecordList.add(deleteAddress);
                }
                if(mapAccount_AddressId.containsKey(objContactAddress.Donor__r.AccountId)){
                    objContactAddress.Address__c = mapAccount_AddressId.get(objContactAddress.Donor__r.AccountId);
                    updateContactAddressPrimary.add(objContactAddress); // update Contact Address's address to houshold address 
                }
            }
        }
        insertAddress(contactAddressId_addressMap.values()); // insert address
         //Changdes address lookup of the Contact Address where new address has been created  
        List<Contact_Address__c> listContactAddress= new List<Contact_Address__c>();
        if(contactAddressId_addressMap <> NULL && !contactAddressId_addressMap.isEmpty()){
            for(Id conAddId: contactAddressId_addressMap.keySet()){
                Contact_Address__c conAddressObject = new Contact_Address__c();
                conAddressObject.Id= conAddId;
                conAddressObject.Address__c = contactAddressId_addressMap.get(conAddId).Id; // to change the address lokkup on Contact Address
                listContactAddress.add(conAddressObject);
            }
        }
        listContactAddress.addAll(updateContactAddressPrimary);
        updateContactAddress(listContactAddress); // update contact address 
        deleteAddress(deleteAddressRecordList); // deletes address from old household
		// Set primary primary Address and Do not mail and Zip 4 code fields for new houshold address and update the Account fields Do not mail and zip 4 code
        list<npsp__Address__c> addressList= new List<npsp__Address__c>();    
        list<Account> lstAccount= new List<Account>();    
        List<Contact_Address__c> listContactPrimaryAddress = ContactAddressSelector.getAddresswithPrimary(mapContact_AccountId.keySet());
        if(listContactPrimaryAddress <> NULL && !listContactPrimaryAddress.isEmpty()){
            for(Contact_Address__c conAddressObject: listContactPrimaryAddress){
                npsp__Address__c updateAddressObj= new npsp__Address__c();
                Contact contactObject = new Contact();
                
                if(mapAddressId_Contact <> NULL && !mapAddressId_Contact.isEmpty()){
                	contactObject= mapAddressId_Contact.get(conAddressObject.Address__c);
                }
                updateAddressObj.Id = conAddressObject.Address__c;
                updateAddressObj.npsp__Default_Address__c = true;
                if(contactObject <> NULL){
                    updateAddressObj.Zip_4_Code__c = contactObject.Zip_4_Code__c;
                    updateAddressObj.Apartment_Number__c = contactObject.Apartment_Number__c;
                    updateAddressObj.Do_Not_Mail__c = contactObject.Do_not_mail_Primary_Address__c;
                    if(contactObject.Experian_Verified__c.Contains('Address')){
                        updateAddressObj.npsp__Verified__c = true;
                        updateAddressObj.Override__c = false;
                    }
                    else{
                        updateAddressObj.npsp__Verified__c = false;
                        updateAddressObj.Override__c = true;
                    }
                }
                
				//update Account
				Account objAccount = new Account();
                objAccount.Id = conAddressObject.Address__r.npsp__Household_Account__c;
                objAccount.Address_Type__c =  conAddressObject.Address__r.npsp__Address_Type__c;
                if(contactObject <> NULL){
                    objAccount.Do_not_mail__c = contactObject.Do_not_mail_Primary_Address__c;
                    objAccount.Zip4Code__c =  contactObject.Zip_4_Code__c;
                    objAccount.Apartment_Number__c = contactObject.Apartment_Number__c;
                }
                //objAccount.Do_not_mail__c = conAddressObject.Address__r.Do_Not_Mail__c;
                // conAddressObject.Address__r.Zip_4_Code__c;
                addressList.add(updateAddressObj);
                lstAccount.add(objAccount);   
            }
        }
        listAddress.addAll(addressList);
        updateAddress(listAddress);
        updateAccount(lstAccount);
    }

    //Show warning to user if marking any Contact as deceased which is primary Contact
    public static void ShowErrorMessage(List<Contact> lstContact,Set<Id> primaryContactId){
        for(Contact contactObject: lstContact){
            if(primaryContactId.contains(contactObject.Id)){
                contactObject.addError(system.label.JUF_Contact_DeceasedError);
            }
        }
    }
    //update Account 
    public static void updateAccount (List<Account> accountList){
        try{
            if(accountList <> NULL && !accountList.isEmpty()){
                update accountList;
            }
        }
        catch(Exception e){
            system.debug('Stack Trace - '+ e.getStackTraceString());
        }
    }
    //update Address
    public static void updateAddress(List<npsp__Address__c> listAddress){
        try{
            if(listAddress <> NULL && !listAddress.isEmpty()){
                update listAddress;
            }
        }
        catch(Exception e){
            system.debug('Stack Trace - '+ e.getStackTraceString());
        }
    }
    
    //Insert Address
    public static void insertAddress(List<npsp__Address__c> listAddress){    
        try{
            if(listAddress <> NULL && !listAddress.isEmpty()){
                insert listAddress;
            }
        }
        catch(Exception e){
            system.debug('Stack Trace - '+ e.getStackTraceString());
        }
    }
    //update Contact Address
    public static void updateContactAddress(List<Contact_Address__c> listContactAddress){
        try{
            if(listContactAddress <> NULL && !listContactAddress.isEmpty()){
                update listContactAddress;
            }
        }
        catch(Exception e){
            system.debug('Stack Trace - '+ e.getStackTraceString());
        }
    }
    //Delete Address
    public static void deleteAddress(List<npsp__Address__c> listAddress){
        try{
            if(listAddress <> NULL && !listAddress.isEmpty()){
                delete listAddress;
            }
        }
        catch(Exception e){
            system.debug('Stack Trace - '+ e.getStackTraceString());
        }
    }
    
    //assign Contact record to update Address fields
    public static Contact assignContact(npsp__Address__c addressRecord, Contact contactObj){
        List<Contact> contactList = new List<Contact>();
        Contact contactObject = new Contact();
        contactObject.Id= contactObj.Id;
        contactObject.npsp__Current_Address__c = addressRecord.Id;
        contactObject.Address_Start_Date__c = addressRecord.npsp__Latest_Start_Date__c;
        contactObject.Address_End_Date__c= addressRecord.npsp__Latest_End_Date__c;
        contactObject.npe01__Primary_Address_Type__c = addressRecord.npsp__Address_Type__c;
        contactObject.MailingCity = addressRecord.npsp__MailingCity__c;
        contactObject.MailingCountry = addressRecord.npsp__MailingCountry__c;
        contactObject.MailingPostalCode = addressRecord.npsp__MailingPostalCode__c;
        contactObject.MailingState = addressRecord.npsp__MailingState__c;
        contactObject.MailingStreet = addressRecord.npsp__MailingStreet__c;
        contactObject.Apartment_Number__c = addressRecord.Apartment_Number__c;
        if(addressRecord.npsp__MailingStreet2__c <> NULL && String.isNotBlank(addressRecord.npsp__MailingStreet2__c))
            contactObject.MailingStreet += '\n'+addressRecord.npsp__MailingStreet2__c;
        
        contactObject.Do_not_mail_Primary_Address__c = addressRecord.Do_Not_Mail__c;
        contactObject.Zip_4_Code__c = addressRecord.Zip_4_Code__c;
        contactObject.Experian_Override__c = addressRecord.Override__c;
        if(addressRecord.npsp__Verified__c == true){
            if(contactObj.Experian_Verified__c <> NULL 
               && String.isNotBlank(contactObj.Experian_Verified__c)){
                   if(!contactObj.Experian_Verified__c.Contains(system.Label.AddressService_AddressVerified)){
                       contactObject.Experian_Verified__c =system.Label.AddressService_AddressVerified +';'+ contactObj.Experian_Verified__c;
                   }
               }
            else{
                contactObject.Experian_Verified__c =system.Label.AddressService_AddressVerified;
            }
        }
        else if(addressRecord.npsp__Verified__c == false ){
            if(contactObj.Experian_Verified__c <> NULL 
               && String.isNotBlank(contactObj.Experian_Verified__c)){
                   if(contactObj.Experian_Verified__c.Contains(system.Label.AddressService_AddressVerified)) {
                       contactObject.Experian_Verified__c = contactObj.Experian_Verified__c.remove(system.Label.AddressService_AddressVerified );
                   }
                   else if(contactObj.Experian_Verified__c.Contains(system.Label.AddressService_AddressVerified + ';')){
                       contactObject.Experian_Verified__c = contactObj.Experian_Verified__c.remove(system.Label.AddressService_AddressVerified +';' );
                   }
               }
        }
        contactList.add(contactObject);
        if(contactList <> NULL && !contactList.isEmpty()){
            update contactList;
            return contactList[0];
        }
        return NULL;
    }
}