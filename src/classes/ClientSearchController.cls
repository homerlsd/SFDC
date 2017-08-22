/*
* Controller to implement the auto-complete feature on the Visualforce page
*/
public with sharing class ClientSearchController {
    
    // Instance fields
    public String searchTerm                                                                        {get; set;}
    public String selectedRecordId                                                                  {get; set;}
    public Account selectedClientID                                                                 {get; set;}
    public String errorMessage                                                                      {get; set;}
    public String accID                                                                             {get; set;}
    public boolean showError                                                                        {get; set;}
    public boolean showInput                                                                        {get; set;}
    public string chanID                                                                            {get; set;}
    
    public List<SelectOption> newSelects                                                            {get; set;}
    public Sales_Channel__c[] chans                                                                 {get; set;}
    public Sales_Channel__c selectedchan                                                            {get; set;}
    public Map<Id,Sales_Channel__c> channelMap                                                      {get; set;}
    public Rally_Order_Form_FS_Mapping__mdt mappy                                                   {get; set;}
    
    public boolean showImpLinks                                                                     {get; set;}
    public boolean showOrderForm                                                                    {get; set;}
    // Constructor
    public ClientSearchController() {
        errorMessage = '';
        showError = false;
        showInput = false;

        string partnerName = '';
        string channelName = '';

        channelMap = new Map<Id,Sales_Channel__c>();
        selectedchan = new Sales_Channel__c();

        findChannelOptions();

        accID = Apexpages.currentPage().getParameters().get('accID');
        
        if(accID != null && accID != ''){
            List<Account> accs = [select id, name from Account where ID = :accID];
            if(accs.isEmpty()){
                showError = true;
                errorMessage = Label.ClientLinks_NoAccountsError;
            }
            else{
                system.debug('CONTROLLER FOR EXISTING ACCOUNT ' + accID);
                chanID = Apexpages.currentPage().getParameters().get('chan');
                selectedRecordId = accID;
                searchTerm = accs[0].name;
                getLinkStuff();
            }
        }
    }
    
    // JS Remoting action called when searching for a movie name
    @RemoteAction
    public static List<Account> getAccount(String searchString, String partnerid) {
        searchString = '%'+searchString+'%';
        List<Account> accts = [select id, name from Account where Name LIKE :searchString AND Partner__c = :partnerid];
        return accts;
    }

    public List<SelectOption> findChannelOptions(){
        newSelects = new List<SelectOption>();
        newSelects.add( new SelectOption('-Please Select-','-Please Select-'));
        chans = [select id, name from Sales_Channel__c where Public_Forms_Available__c = true];
        for(Sales_Channel__c ch : chans){
            newSelects.add( new SelectOption(ch.id, ch.name));
            channelMap.put(ch.id, ch);
        }
        return newSelects;
    }

    public void setupChannels(){
        selectedChan = channelMap.get(chanID);
        showInput = true;
        system.debug('Selected Channel is ' + selectedChan);
    }
    
    public void getLinkStuff(){

        showError = false;

        try{
            //Rally_Order_Form_FS_Mapping__mdt[] mappys = [select id, Record_Type_ID__c, Form_ID__c from Rally_Order_Form_FS_Mapping__mdt where Record_Type_ID__c = : ];            
            List<string> tempIds = new List<String>();
            tempIds.add(selectedRecordId);

            List<string> chanIDs = new List<String>();
            chanIDs.add(chanID);

            String searchString = '%'+searchTerm+'%';
            string query = 'select id, name, Partner__c,Partner__r.Name, (select id, name, Channel__c from Rally_Implementations__r where Channel__c IN : chanIDs) from Account where Id IN :tempIds';

            system.debug('QUERY IS ' + query);

            Account[] selectAccounts = database.query(query);
            
            if(!selectAccounts.isEmpty()){
                selectedClientID = selectAccounts[0];
                //if we get here we got a channel ID from the url and we can set the channel here instead of 
                if(selectedChan.id == null){
                    setupChannels();
                }
                setBools();
            }
            else{
                showError = true;
                errorMessage = Label.ClientLinks_NoAccountsError;
            }
        } catch(Exception e) {
            showError = true;
            errorMessage = e.getMessage();
            return;
        }
    }

    public void setBools(){
        showImpLinks = true;
        
        if(selectedClientID.Rally_Implementations__r.isEmpty() && selectedChan.name == 'Engage'){
             showError = true;
             errorMessage = Label.ClientLinkController_NoImplementationsError;
             return;
        }
        else if(selectedClientID.Rally_Implementations__r.isEmpty() && selectedChan.name == 'Digital Health Plan'){
            showImpLinks = false;
            showOrderForm = true;
        }
        else if(!selectedClientID.Rally_Implementations__r.isEmpty() && selectedChan.name == 'Digital Health Plan'){
            showOrderForm = true;
        }

        system.debug('CHannel ID IS ' + chanID);

    }

    public pageReference goLink(){
        system.debug('FORM ID ' + Apexpages.currentPage().getParameters().get('linkType'));
        system.debug('IMPL ID ' + Apexpages.currentPage().getParameters().get('impID'));

        string formID1 = Apexpages.currentPage().getParameters().get('linkType');
        string impID1 = Apexpages.currentPage().getParameters().get('impID');

        pageReference pg = page.RallyRequirements;
        pg.getParameters().put('formID', formID1);
        pg.getParameters().put('impID', impID1);
        pg.setRedirect(true);
        return pg;
    }
}