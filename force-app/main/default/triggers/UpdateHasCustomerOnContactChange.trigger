trigger UpdateHasCustomerOnContactChange on Contact (after update) {
    List<Account> accountsToUpdate = new List<Account>();

    // Iterate through updated Contacts
    for (Contact updatedContact : Trigger.new) {
        // Get the old Contact record
        Contact oldContact = Trigger.oldMap.get(updatedContact.Id);

        // Check if 'Contact Type' has changed to 'Customer'
        if (updatedContact.Contact_Type__c == 'Customer' && oldContact.Contact_Type__c != 'Customer') {
            // Retrieve the related Account
            Account relatedAccount = [SELECT Id, HasCustomer__c FROM Account WHERE Id = :updatedContact.AccountId LIMIT 1];
            
            // Update 'Has Customer' to true on the Account
            if (relatedAccount != null) {
                relatedAccount.HasCustomer__c = true;
                accountsToUpdate.add(relatedAccount);
            }
        }
        // Consider a scenario for when 'Contact Type' is not 'Customer'
        else if (oldContact.Contact_Type__c == 'Customer' && updatedContact.Contact_Type__c != 'Customer') {
            // Retrieve the related Account
            Account relatedAccount = [SELECT Id, HasCustomer__c FROM Account WHERE Id = :updatedContact.AccountId LIMIT 1];
            
            // Update 'Has Customer' to false on the Account
            if (relatedAccount != null) {
                relatedAccount.HasCustomer__c = false;
                accountsToUpdate.add(relatedAccount);
            }
        }
    }

    // Update the affected Account records
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}