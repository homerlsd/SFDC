public class AccountHeader {
    
    public Account acct {get; set;}
    private final Account editacct;
    public Id UserId = userInfo.getUserId();
    public User u {get; set;}

    public String AMname {get; set;}

    public String ConnectActive {get; set;} 
    public String ChoiceActive {get; set;}
    public String EngageActive {get; set;}

    public User ActiveConnectOwner {get; set;}
    public User ActiveEngageOwner {get; set;}
    public User ActiveChoiceOwner {get; set;}

    public String ProfileId = userInfo.getProfileID();
    public Profile pfile {get; set;}
    
    public Utils_Sales.salesTaskOrEvent recentEvent {get;set;}
    public Utils_Sales.salesTaskOrEvent recentTask {get;set;}

    public AccountHeader(ApexPages.StandardController controller) {
        
		pfile = [select id, Name from Profile where Id = :ProfileId];

        //addding some notes test save
        
        this.editAcct = (Account)controller.getRecord();
        acct = [select id,
        			   name,
        			   ownerId,
        			   recordtype.name,
        			   account_manager__c,
        			   account_manager__r.name,
        			   current_rally_member__c,
        			   (select id, ownerId, recordtype.name from Opportunities)
        			   from Account where Id = :editAcct.id LIMIT 1];

        AMname = (acct.account_manager__c != null ? acct.account_manager__r.name : 'N/A');

        u = [select Id, Name, Profile.Name from User where Id = :UserId];
        
        recentEvent = Utils_Sales.getMostRecentActivty(acct.id, 'Event');
        recentTask = Utils_Sales.getMostRecentActivty(acct.id, 'Task');

        //Check if there is an active Connect Deal Opportunity

        ConnectActive = Utils_Sales.ActiveOwnerId(Acct.Id, 'Connect', UserId);
        
        if (ConnectActive != 'false') {
            ActiveConnectOwner = [select Id, Name from User where Id = :ConnectActive];

        }
        
        //Check if there is an active Engage Opportunity

        EngageActive = Utils_Sales.ActiveOwnerId(Acct.Id, 'Engage', UserId);

        if (EngageActive != 'false') {
            ActiveEngageOwner = [select Id, Name from User where Id = :EngageActive];
        }

        //Check if there is an active Choice Opportunity

        ChoiceActive = Utils_Sales.ActiveOwnerid(Acct.Id, 'Choice', UserId);
        
        if (ChoiceActive != 'false') {
            ActiveChoiceOwner = [select Id, Name from User where Id = :ChoiceActive];
        }
        
    }

}