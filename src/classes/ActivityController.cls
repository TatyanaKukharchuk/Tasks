public with sharing class ActivityController{

    public WrapperActivity wrapperActivity { get; set; }
    List<WrapperActivity> wrapperActivitiesList { get; set; }
    private String sortColumnTask = 'WhatId';
    private String sortColumnEvent = 'WhatId';
    private String sortOrder = ' ASC ';
    public string searchString { get; set; }
    private String querySearchStringTask = '';
    private String querySearchStringEvent = '';
    public Integer counter {
        get {
            if (counter == null) {
                counter = 0;
            }
            return counter;
        }
        set;

    }
    public Integer pageSize {
        get {
            if (pageSize == null) {
                pageSize = 5;
            }
            return pageSize;
        }
        set;
    }
    public String phone;
    public Integer totalSize;
    public Integer sizeTask;
    public Integer sizeEvent;
    public List<Task> tasksList { get; set; }
    public List<Event> eventsList { get; set; }
    public List<Task> tasksListDel { get; set; }
    public List<Event> eventsListDel { get; set; }
    public List<Task> taskListEdit { get; set; }
    public List<Event> eventListEdit { get; set; }
    public Map<Id, String> phoneMap {get;set;}
    public Map<Id, String> phoneMapEdit {get;set;}
    public ActivityController() {
        wrapperActivity = new WrapperActivity();
        sizeTask = [Select count() From Task];
        sizeEvent = [Select count() FROM Event];
        totalSize = sizeTask + sizeEvent;
    }
    public String filterColumn {
        get {
            if (filterColumn == null) {
                filterColumn = ' ';
            }
            return filterColumn;
        }
        set;
    }


    public List<WrapperActivity> getActivities() {

        if (searchString != ' ' & searchString != NULL) {
            querySearchStringTask = ' Where what.Name like \'%' + searchString + '%\' OR owner.Name like \'%' + searchString + '%\' ' +
                    'OR subject like \'%' + searchString + '%\' OR type like \'%' + searchString + '%\' OR taskSubtype like \'%' + searchString + '%\'';
            querySearchStringEvent = ' Where what.Name like \'%' + searchString + '%\' OR owner.Name like \'%' + searchString + '%\' ' +
                    'OR subject like \'%' + searchString + '%\' OR type like \'%' + searchString + '%\' OR status__c like \'%' + searchString + '%\' OR eventSubtype like \'%' + searchString + '%\' ';
        }
        String query_sort_task = ' ORDER BY ' + sortColumnTask + sortOrder ;
        String query_sort_event = ' ORDER BY ' + sortColumnEvent + sortOrder ;
        String query_pagination = 'LIMIT ' + pageSize + 'OFFSET ' + counter;
        try {


            String queryFromTask = 'Select id, whatId, what.Name, ownerId, owner.Name, whoId, subject, type, status__c, createdDate, activityDate, taskSubtype From Task '
                    + querySearchStringTask
                    + filterColumn + query_sort_task
                    + query_pagination;
            String queryFromEvent = 'Select id, whatId, what.Name, ownerId, owner.Name, whoId, subject, type, status__c, startDateTime, endDateTime,eventSubtype From Event'
                    + querySearchStringEvent
                    + filterColumn + query_sort_event
                    + query_pagination ;


            sortOrder = (sortOrder == ' ASC ') ? ' DESC ' : ' ASC ';
            wrapperActivitiesList = new List<WrapperActivity>();
            tasksList = Database.query(queryFromTask);
            eventsList = Database.query(queryFromEvent);
            Set<Id> leadId = new Set<Id>();
            Set<id> contactId = new Set<Id>();
            system.debug(tasksList);
            system.debug(eventsList);
                for (Task t : tasksList) {
                    if ((t.whoId !=Null) && (t.whoId.getSObjectType().getDescribe().getName() == 'Lead')) {
                        leadId.add(t.whoId);
                    }
                    if((t.whoId !=Null) && (t.whoId.getSObjectType().getDescribe().getName() == 'Contact'))
                    {
                        contactId.add(t.whoid);
                    }
                }
                for (Event e : eventsList) {
                    if ( (e.whoId !=Null) && (e.whoId.getSObjectType().getDescribe().getName() == 'Lead')) {
                        leadId.add(e.whoId);
                    }
                    if ((e.whoId !=Null) && (e.whoId.getSObjectType().getDescribe().getName() == 'Contact')) {
                        contactId.add(e.whoid);
                    }
                }

                phoneMap = new Map<Id, String>();
                List<Lead> newListLead = [SELECT Id, Phone FROM Lead WHERE id = :leadId];
                List<Contact> newListContact = [Select id, Phone From Contact WHERE id = :contactId];
                if (!newListLead.isEmpty()) {
                    for (Lead l : newListLead) {
                        phoneMap.put(l.id, l.phone);
                    }
                }
                if (!newListContact.isEmpty()) {
                    for (Contact c : newListContact) {
                        phoneMap.put(c.id, c.phone);
                    }
                }

            System.debug('sortColumnTask: ' + sortColumnTask);
            System.debug('sortColumnEvent: ' + sortColumnEvent);
            System.debug('queryFromTask: ' + queryFromTask);
            System.debug('queryFromEvent: ' + queryFromEvent);

            if (!tasksList.isEmpty() || !eventsList.isEmpty()) {

                for (Task t : tasksList) {
                    wrapperActivitiesList.add(new WrapperActivity( t.id,
                            t.whatId, t.what.Name, t.OwnerId, t.Owner.Name, t.whoId, t.subject,
                            t.type, t.status__c, phone = phoneMap.get(t.whoid), t.createdDate, t.activityDate, t.taskSubtype));
                }
                for (Event e : eventsList) {
                    wrapperActivitiesList.add(new WrapperActivity( e.id,
                            e.whatId, e.what.Name, e.ownerId, e.Owner.Name, e.whoId, e.subject,
                            e.type, e.status__c,  phone = phoneMap.get(e.whoid), e.startDateTime, e.endDateTime, e.eventSubtype));
                }

                for (WrapperActivity w : wrapperActivitiesList) {
                    System.debug('wrapperActivitiesList: ' + w);
                }
            }

            return wrapperActivitiesList;
        } catch (QueryException e) {
            ApexPages.addMessages(e);
            return null;
        }
    }


    public List<SelectOption> getPageSizeList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('10', '10'));
        options.add(new SelectOption('20', '20'));
        options.add(new SelectOption('50', '50'));
        options.add(new SelectOption('100', '100'));
        return options;
    }


    public PageReference Beginning() {
        counter = 0;
        return null;
    }


    public PageReference Previous() {
        counter -= pageSize;
        return null;
    }


    public PageReference Next() {
        counter += pageSize;
        return null;
    }


    public PageReference End() {
        counter = totalSize - math.mod(totalSize, pageSize);
        return null;
    }


    public Boolean getDisablePrevious() {
        if (counter > 0) {
            return false;
        } else {
            return true;
        }
    }


    public Boolean getDisableNext() {
        if (counter + pageSize < totalSize) {
            return false;
        } else {
            return true;
        }
    }


    public Integer getTotal_size() {
        return totalSize;
    }


    public Integer getPageNumber() {
        return counter / pageSize + 1;
    }

    public Integer getTotalPages() {
        if (math.mod(totalSize, pageSize) > 0) {
            return totalSize / pageSize + 1;
        } else {
            return(totalSize / pageSize);
        }

    }

    public void sortByWhatId() {
        sortColumnTask = 'WhatId';
        sortColumnEvent = 'WhatId';
        getActivities();
    }


    public void sortByOwnerId() {
        sortColumnTask = 'OwnerId';
        sortColumnEvent = 'OwnerId';
        getActivities();
    }


    public void sortBySubject() {
        sortColumnTask = 'Subject';
        sortColumnEvent = 'Subject';
        getActivities();
    }


    public void sortByType() {
        sortColumnTask = 'Type';
        sortColumnEvent = 'Type';
        getActivities();
    }
    public void sortByStatus() {
        sortColumnTask = 'Status__c';
        sortColumnEvent = 'Status__c' ;
        getActivities();
    }
    public void sortByPhone() {
        sortColumnTask = 'whoId';
        sortColumnEvent = 'whoId' ;
        getActivities();
    }


    public void sortByStartDate() {
        sortColumnTask = 'CreatedDate';
        sortColumnEvent = 'StartDateTime';
        getActivities();
    }

    public void sortByEndDate() {
        sortColumnTask = 'ActivityDate';
        sortColumnEvent = 'EndDateTime';
        getActivities();
    }

    public void sortBySubtype() {
        sortColumnTask = 'TaskSubtype';
        sortColumnEvent = 'EventSubtype';
        getActivities();
    }
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);
    }
    public void delActivity() {
        String del = getParam('del');
        try {
            String taskDelQuery = 'Select id, whatId, what.Name, ownerId, owner.Name, subject, type, status__c,' +
                    ' createdDate, activityDate,' + ' taskSubtype From Task Where id =:del';
            String eventDelQuery = 'Select id, whatId, what.Name, ownerId, owner.Name, subject, type,' +
                    ' status__c, startDateTime, endDateTime,eventSubtype From Event Where id =: del';
            tasksListDel = Database.query(taskDelQuery);
            eventsListDel = Database.query(eventDelQuery);
            if (!tasksListDel.isEmpty() || !eventsListDel.isEmpty()) {

                delete tasksListDel;
                delete eventsListDel;

            }


        } catch (DmlException e) {
            ApexPages.addMessages(e);
        }

    }

    public PageReference saveEdit() {
        taskListEdit = new List<Task>();
        eventListEdit = new List<Event>();
        Set<Id> leadIdEdit = new Set<Id>();
        Set<id> contactIdEdit = new Set<Id>();
        for(WrapperActivity wa :wrapperActivitiesList) {
            if (wa.SubType == 'Task') {
                Task t = new Task(
                       Id = wa.Id,
                        WhatId = wa.WhatId,
                        whoId = wa.WhoId,
                        OwnerId = wa.OwnerId,
                        Subject = wa.Subject,
                        Type = wa.Type,
                        Status__c = wa.Status,
                        TaskSubtype = wa.SubType,
                        ActivityDate = Date.valueOf(wa.endDateTime));
                taskListEdit.add(t);

            }
            if (wa.SubType == 'Event') {
                Event e = new Event(
                        Id = wa.Id,
                        WhatId = wa.WhatId,
                        whoId = wa.WhoId,
                        OwnerId = wa.OwnerId,
                        Subject = wa.Subject,
                        Type = wa.Type,
                        Status__c = wa.status,
                        EventSubtype = wa.SubType,
                        ActivityDate = Date.valueOf(wa.endDateTime));
                eventListEdit.add(e);
            }

        }

        system.debug(taskListEdit);
        for (Task t : taskListEdit) {
            if ((t.whoId !=Null) && (t.whoId.getSObjectType().getDescribe().getName() == 'Lead')) {
                leadIdEdit.add(t.whoId);
            }
            if((t.whoId !=Null) && (t.whoId.getSObjectType().getDescribe().getName() == 'Contact'))
            {
                contactIdEdit.add(t.whoid);
            }
        }
        for (Event e : eventListEdit) {
            if ( (e.whoId !=Null) && (e.whoId.getSObjectType().getDescribe().getName() == 'Lead')) {
                leadIdEdit.add(e.whoId);
            }
            if ((e.whoId !=Null) && (e.whoId.getSObjectType().getDescribe().getName() == 'Contact')) {
                contactIdEdit.add(e.whoid);
            }
        }

        List<Lead> newListLeadEdit = [SELECT id, Phone FROM Lead WHERE id = :leadIdEdit];
        List<Contact> newListContactEdit = [Select id, Phone From Contact WHERE id = :contactIdEdit];
        update newListContactEdit;
        update newListLeadEdit;
        update taskListEdit;
        update eventListEdit;
        return null;
    }
    public List<SelectOption> getUserForEdit() {
        List<User> newUserList = new List<User>();
        newUserList = [Select id, name From User];
        List<SelectOption> options = new List<SelectOption>();
        for(User u :newUserList){
            options.add(new SelectOption(u.id, u.name));

        }

        return options;
    }
    public List<SelectOption> getAccountForEdit() {
        List<Account> newAccountList = new List<Account>();
        newAccountList = [Select id, name From Account];
        List<SelectOption> options = new List<SelectOption>();
        for(Account a :newAccountList){
            options.add(new SelectOption(a.id, a.name)) ;

        }
        return options;
    }

    public List<SelectOption> getSubjectForEdit() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Call', 'Call'));
        options.add(new SelectOption('Email', 'Email'));
        options.add(new SelectOption('Send Letter', 'Send Letter'));
        options.add(new SelectOption('Send Quote', 'Send Quote'));
        options.add(new SelectOption('Other', 'Other'));
        return options;
    }
    public List<SelectOption> getTypeForEdit() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Call', 'Call'));
        options.add(new SelectOption('Email', 'Email'));
        options.add(new SelectOption('Send Letter', 'Send Letter'));
        options.add(new SelectOption('Send Quote', 'Send Quote'));
        options.add(new SelectOption('Other', 'Other'));
        return options;
    }
    public List<SelectOption> getStatusForEdit() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Not Started', 'Not Started'));
        options.add(new SelectOption('In Progress', 'In progress'));
        options.add(new SelectOption('Completed', 'Completed'));
        options.add(new SelectOption('Waiting on someone else', 'Waiting on someone else'));
        options.add(new SelectOption('Deferred', 'Deferred'));
        return options;
    }







}