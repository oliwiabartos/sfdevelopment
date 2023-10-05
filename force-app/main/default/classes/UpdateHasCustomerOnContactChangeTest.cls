@isTest
public class UpdateHasCustomerOnContactChangeTest {
    @isTest
    static void testContactTypeChangeToCustomer() {
        // Create test Account and Contact records
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = testAccount.Id,
            Contact_Type__c = 'Partner'
        );
        insert testContact;

        // Ensure 'Has Customer' is initially false
        testAccount = [SELECT HasCustomer__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(false, testAccount.HasCustomer__c);

        // Change Contact Type to 'Customer'
        testContact.Contact_Type__c = 'Customer';
        update testContact;

        // Verify 'Has Customer' is now true
        testAccount = [SELECT HasCustomer__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(true, testAccount.HasCustomer__c);
    }
    
    @isTest
    static void testContactTypeChangeFromCustomer() {
        // Create test Account and Contact records
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            AccountId = testAccount.Id,
            Contact_Type__c = 'Customer'
        );
        insert testContact;

        // Ensure 'Has Customer' is initially true
        testAccount = [SELECT HasCustomer__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(true, testAccount.HasCustomer__c);

        // Change Contact Type from 'Customer' to something else
        testContact.Contact_Type__c = 'Partner';
        update testContact;

        // Verify 'Has Customer' is now false
        testAccount = [SELECT HasCustomer__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(false, testAccount.HasCustomer__c);
    }
}