public class TasksAssignmentClass implements AssignmentClass { 
        public static List<Task> reassignRecords2NewUsers(List<Task> taskList)
        {
           Account acc = new Account();
           User us  = new User(); 
           String kindOfSobject = 'Account';
           List<ID> newIdTaskList = new List<ID>();
           List<Task> newTasksList = new List<Task>();  
           
            if (!Trigger.isExecuting){
               for (Task tId:  taskList){    
					newIdTaskList.add(tId.id);
             	}
                newTasksList = [SELECT id, WhatId, OwnerId FROM Task WHERE id IN :newIdTaskList AND WhatId != NULL];
            } else {
                
				newTasksList.addAll(taskList);                
            }

           List<ID> tasksId = new List<ID>();  
            	for (Task item: newTasksList) 
                {
                    if(! newTasksList.isEmpty() &&  SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(item.WhatId) == kindOfSobject) 
                    {
            			 tasksId.add(item.WhatId);
                    }
                    else{ 
                       return newTasksList;
                    }
             	}
            List<Account> accountList = [SELECT ID, Sales_Associate_Number__c FROM Account 
                                    	    WHERE (ID IN :tasksId) AND (Sales_Associate_Number__c != NULL)];
            List<String> numberAccountList = new List<String>();
                 for (Account a: accountList) 
                 {
                     if(!accountList.isEmpty())
                     {
                         numberAccountList.add(a.Sales_Associate_Number__c); 
                     } 
      			 }
            List<User> userList = [SELECT Id, Sales_Associate_Number__c FROM User 
                                  WHERE (Sales_Associate_Number__c IN :numberAccountList) AND (Sales_Associate_Number__c != NULL)];
           	Map<Id, Account> accountsMap = new Map<Id, Account>();
          	Map<String, User> usersMap = new Map<String, User>();
                for(Account ac: accountList ) 
                {
                	accountsMap.put(ac.id, ac);
           		}
                for(User use: userList ) 
                { 
                    if(!userList.isEmpty())
                    {
                        usersMap.put(use.Sales_Associate_Number__c, use);
                   }
           		}
                for(Task t:  newTasksList)
                {
                   acc = accountsMap.get(t.WhatId);
                   us = usersMap.get(acc.Sales_Associate_Number__c);
                    t.OwnerId = us.Id; } 
                    
       			if (!Trigger.isExecuting){	 
              	  update  newTasksList;
           		 }	
           // taskList = newTasksList;
         		 return  newTasksList;
        }	

   
}