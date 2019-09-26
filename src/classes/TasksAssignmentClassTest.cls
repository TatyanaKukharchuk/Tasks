@isTest(SeeAllData=false)
public class TasksAssignmentClassTest {
     static testMethod void reassignRecords2NewUsers() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User saaUser = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='satandardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert saaUser;
            User s = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='saatandardSA_User@testorg.com',
            Sales_Associate_Number__c = '00000'
        );
        insert s;
        Account acc1 = new Account (
            Name = 'testAcco',
            Sales_Associate_Number__c = '19860'
        );
        insert acc1;
         
        Account acc2 = new Account (
            Name = 'testAccount2ecwfew',
            Sales_Associate_Number__c = '00000'
        );
        
        insert acc2;
       
        List<Task> tasks = new List<Task>();
         
        Task t1 = new Task (
            Subject = 'task1',
            WhatId = acc1.Id
        );
        insert t1;
        tasks.add(t1);
         
        Task t2 = new Task (
            Subject = 'task2',
            WhatId = acc2.Id
        );
         
        insert t2;
        tasks.add(t2);
         
 	  Test.startTest();    
       TasksAssignmentClass.reassignRecords2NewUsers(tasks);
        Task task1Result = [SELECT OwnerId FROM Task WHERE Id = : t1.Id];
        system.debug('task1Result'+task1Result);
        Task task2Result = [SELECT OwnerId FROM Task WHERE Id = : t2.Id];
        system.debug('task2Result'+task2Result);
        system.assertEquals(task1Result.OwnerId, saaUser.id);
        system.assertNotEquals(task2Result.OwnerId, saaUser.id);

        Test.stopTest();
        
     }
    static testMethod void EmptyTask() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User saaUser = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='satandardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert saaUser;
            User s = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='saatandardSA_User@testorg.com',
            Sales_Associate_Number__c = '00000'
        );
        insert s;
        Account acc1 = new Account (
            Name = 'testAcco',
            Sales_Associate_Number__c = '19860'
        );
        insert acc1;
         
        Account acc2 = new Account (
            Name = 'testAccount2ecwfew',
            Sales_Associate_Number__c = '00000'
        );
         List<Task> tasks = new List<Task>();
         Boolean t = TasksAssignmentClass.reassignRecords2NewUsers(tasks).isEmpty();
          Test.startTest();   
         TasksAssignmentClass.reassignRecords2NewUsers(tasks);
        	system.Assert(t);
       	 Test.stopTest();        
    }
         static testmethod void OppId() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User saaUser = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='satandardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert saaUser;
            User s = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='saatandardSA_User@testorg.com',
            Sales_Associate_Number__c = '00000'
        );
        insert s;
        Opportunity opp = new  Opportunity (
            Name = 'test',
            StageName = 'Prospecting',
            CloseDate = Date.TODAY() 
            
        );
        insert opp;       
        List<Task> tasks = new List<Task>();      
        Task t1 = new Task (
            Subject = 'task1',
            WhatId = opp.Id
        );
        insert t1;
        tasks.add(t1);
         
 	  Test.startTest();    
       TasksAssignmentClass.reassignRecords2NewUsers(tasks);
        Task task1Result = [SELECT OwnerId FROM Task WHERE Id = : t1.Id];
         Integer size = TasksAssignmentClass.reassignRecords2NewUsers(tasks).size();
        system.debug('task1Result'+task1Result);
        	system.Assert(tasks.size()== size);
        Test.stopTest();
     }
    static testMethod void oneAccountTwoUsers() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User saaUser = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='satandardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert saaUser;
            User s = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='saatandardSA_User@testorg.com',
            Sales_Associate_Number__c = '00000'
        );
        insert s;
           User sa = new User (
            Alias = 'standt', 
            Email='standardugser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='saatanndardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert sa;
        Account acc1 = new Account (
            Name = 'testAcco',
            Sales_Associate_Number__c = '19860'
        );
        insert acc1;
         
        Account acc2 = new Account (
            Name = 'testAccount2ecwfew',
            Sales_Associate_Number__c = '00000'
        );
        
        insert acc2;
       
        List<Task> tasks = new List<Task>();
         
        Task t1 = new Task (
            Subject = 'task1',
            WhatId = acc1.Id
        );
        insert t1;
        tasks.add(t1);
         
 	  Test.startTest();    
       TasksAssignmentClass.reassignRecords2NewUsers(tasks);
        Task task1Result = [SELECT OwnerId FROM Task WHERE Id = : t1.Id];
        system.debug('task1Result'+task1Result);
        system.assert(task1Result.OwnerId == sa.id || task1Result.OwnerId == saaUser.id);
     }
     static testMethod void onlyID() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User saaUser = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='satandardSA_User@testorg.com',
            Sales_Associate_Number__c = '19860'
        );
        insert saaUser;
            User s = new User (
            Alias = 'standt', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles',
            UserName='saatandardSA_User@testorg.com',
            Sales_Associate_Number__c = '00000'
        );
        insert s;
        Account acc1 = new Account (
            Name = 'testAcco',
            Sales_Associate_Number__c = '19860'
        );
        insert acc1;
         
        Account acc2 = new Account (
            Name = 'testAccount2ecwfew',
            Sales_Associate_Number__c = '00000'
        );
        
        insert acc2;
       
        List<Task> tasks = new List<Task>();
        Task t1 = new Task (
            Subject = 'task1',
            WhatId = acc1.Id
        );
        insert t1;
        tasks.add(t1);
         
        Task t2 = new Task (
            Subject = 'task2',
            WhatId = acc2.Id
        );
         
        insert t2;
        tasks.add(t2);   
 	   Test.startTest();
       tasks = [SELECT Id FROM Task];
       TasksAssignmentClass.reassignRecords2NewUsers(tasks);          
        Task task1Result = [SELECT OwnerId FROM Task WHERE Id = : t1.Id];
        system.debug('task1Result'+task1Result);
        Task task2Result = [SELECT OwnerId FROM Task WHERE Id = : t2.Id];
        system.debug('task2Result'+task2Result);
        system.assertEquals(task1Result.OwnerId, saaUser.id);
        system.assertNotEquals(task2Result.OwnerId, saaUser.id);

        Test.stopTest();
        
     }
    
    
}