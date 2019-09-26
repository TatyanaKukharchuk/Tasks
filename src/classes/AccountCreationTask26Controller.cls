public with sharing class AccountCreationTask26Controller {

    public Account newAccounts          { get; set; }
    public List<Account> createdAccount { get; set; }
    public Id accountId                 { get; set; }
    public String accountType           { get; set; }
    public String accountName           { get; set; }
    public Boolean displayCreated       { get; set; }
    public List<Attachment> newListAttachments  { get; set; }
    public Boolean displayCreateAccount {
        get {
            if (displayCreateAccount == null) {
                displayCreateAccount = true;
            }
            return displayCreateAccount;
        }
        set;
    }
    public Boolean displayButtonShow {
        get {
            if (displayButtonShow == null) {
                displayButtonShow = true;
            }
            return displayButtonShow;
        }
        set;
    }
    public Boolean displayHideButton    { get; set; }
    public Boolean displayBlock         { get; set; }
    public String selectedType          { get; set; }
    public String createdAccountDate    { get; set; }
    public String nameAttachment {
        get {
            if (nameAttachment == null) {
                nameAttachment = '';
            }
            return nameAttachment;
        }
        set;
    }
    public String userTime  { get; set; }
    public Double offset {
        get {
            TimeZone tz = UserInfo.getTimeZone();
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
    }
    public Attachment AttachmentFile    { get; set; }
    public Attachment attachment        { get; set; }

    public AccountCreationTask26Controller() {
        newAccounts = new Account();
    }

    public PageReference saveAttachment() {
        attachment = new Attachment(parentId = accountId, name = AttachmentFile.Name, body = AttachmentFile.Body);

        try {
            insert attachment;
        } catch (DmlException de) {
            ApexPages.addMessages(de);
        }

        return null;
    }

    public String getNameAtachmentString() {
        String title = '';
        newListAttachments = [
                SELECT name
                FROM Attachment
                WHERE parentId = :accountId
        ];

        if (newListAttachments.size() != 0) {
            for (Attachment a : newListAttachments) {
                title += a.name + ' ';
            }
            nameAttachment=  accountName + ' '+ 'with' + ' ' + title;
        }

        return  nameAttachment;
    }

    public Attachment getMyAttachmentFile(){
        AttachmentFile = new Attachment();
        return AttachmentFile;
    }

    public List<Account> getCreatedAccounts(){
        accountId = newAccounts.id;
        accountType = newAccounts.type;
        accountName = newAccounts.name;
        createdAccount = [
                SELECT id, name, type, CreatedDate
                FROM Account
                WHERE Id = :accountId
        ];

        createdAccountDate = String.valueOf(createdAccount[0].CreatedDate.format('MM/dd/yy'+ ' ' + 'HH:mm:ss'));
        userTime = String.valueOf(createdAccount[0].CreatedDate.addHours(10).format('dd/MMMMM/yyyy'+ ' ' + 'HH:mm:ss'));

        return  createdAccount;
    }

    public PageReference save() {
        try {
            insert newAccounts;
        } catch (DmlException de) {
            ApexPages.addMessages(de);
        }
        displayCreated = true;
        displayCreateAccount = false;

        return null;
    }

    public PageReference cancel() {
        newAccounts.clear();
        return null;
    }

    public PageReference back()  {
        displayCreated = false;
        displayCreateAccount = true;
        nameAttachment = '';
        newAccounts.clear();
        return null;
    }

    public void selectedTypeAccount() {
        selectedType = newAccounts.Type;
    }

    public PageReference showHide() {
        displayButtonShow = false;
        displayBlock = true;
        displayHideButton = true;
        return null;
    }

    public PageReference hideShow() {
        displayBlock = false;
        displayHideButton = false;
        displayButtonShow = true;
        return null;
    }
}