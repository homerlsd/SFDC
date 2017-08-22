public with sharing class ParentCaseActionController {
    public case child {get;set;}
    public Case theCase {get; set;}
    public String lastError {get; set;}
    public String selectedParent {get; set;}
    public String selectedClient {get; set;}
    public String selectedRtype {get; set;}
    public String caseType {get; set;}
    public Map<id,String> RtypeMap {get; set;}
    public case parentC {get; set;}
    public boolean needsParent {get; set;}
    public Map <id,case> parentMap {get; set;}

    public ParentCaseActionController() {
        string childID = ApexPages.currentPage().getParameters().get('ID');
        theCase = new Case(RecordTypeID=CC_Constants.DEFAULT_TIER2_RECORDTYPE_ID);
        lastError = '';
        caseType = '';
        needsParent = false;
        parentMap = new Map <id,case>();
        parentc = new Case();
        RtypeMap = new Map<id,string>();

        try{
        	child = [select id,casenumber, parentid from case where ID = : childID];
        }
        catch(Exception ex){
        	child = new Case();
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No case found with referring ID.  Please contact your administrator.'));
            return;
        }
    }

    public List<SelectOption> getParentCases() {
        List<SelectOption> Options = new List<SelectOption>();

        Options.add(new SelectOption('Select...','Select...'));

        for (Case c: [select id, status, casenumber, Subject, Jira__c, Contact_Name__c from Case where RecordType.name = 'Tier 2' AND isClosed = false]) {
            Options.add(new SelectOption(c.id, c.casenumber + ' - JIRA: ' + c.JIRA__c  + ' - Subject: ' + c.Subject));
            parentMap.put(c.id, c);
        }

        System.debug('Tier 2 Options is' + Options);

        return Options;
    }

    public List<SelectOption> getClientCases() {
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('Select...','Select...'));

        for (Case c: [select id, status, casenumber, Subject, Jira__c, Contact_Name__c from Case where RecordType.name = 'Client Support' AND isClosed = false]) {
            Options.add(new SelectOption(c.id, c.casenumber + ' - JIRA: ' + c.JIRA__c  + ' - Subject: ' + c.Subject));
            parentMap.put(c.id, c);
        }

        System.debug('Client Support Options is' + Options);

        return Options;
    }

    public List<SelectOption> getRtypes() {
        List<SelectOption> Options = new List<SelectOption>();

        Options.add(new SelectOption('Select...','Select...'));

        for (RecordType rt: [select id, Name from RecordType where (name = 'Client Support' OR NAME = 'Tier 2') and sObjectType = 'Case']) {
            Options.add(new SelectOption(rt.id, rt.name));
            RtypeMap.put(rt.id, rt.name);
        }

        System.debug('Rtype Options is' + Options);

        return Options;
    }

    public void showDetails(){
        system.debug('SELECTED PARENT ID IS  ' + parentc);
        parentc = parentMap.get(selectedParent);
        system.debug('SELECTED PARENT IS  ' + parentc);
    }

    public void showClientDetails(){
        system.debug('SELECTED PARENT ID IS  ' + parentc);
        parentc = parentMap.get(selectedClient);
        system.debug('SELECTED PARENT IS  ' + parentc);
    }

    public void showNewCase(){
       caseType = RtypeMap.get(selectedRtype);
       system.debug('CASE TYPE IS ' + caseType);
    }

   	public void setUpCase(){
        child.status = Label.CaseScheduler_Tier2AssignedStatus;
   	}
    public PageReference save() {
    	id tempid = createNewCase();
        child.ParentID = tempid;
        if(caseType == 'Tier 2')
            setUpCase();

        update child;
        
        if(theCase.Comments__c != null){
        	caseComment cc = new caseComment(commentbody=theCase.comments__c, ParentID = child.id, ispublished = false);
        	insert cc;
        }
        PageReference pg = new PageReference('/'+tempid);
    	pg.setRedirect(true);
    	return pg;
    }

    public PageReference linkParentCase() {
       	if(selectedParent != 'Select...'){
            child.ParentID = selectedParent;
            setUpCase();
        }
        else{
            child.ParentID = selectedClient;
        }
        
        try{
        	update child;
        	PageReference pg = new PageReference('/'+child.parentid);
        	pg.setRedirect(true);
        	return pg;
    	}
    	catch(System.Exception ex){
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        	return null;
        }
    }

    public PageReference cancel() {
        try{
            PageReference pg = new PageReference('/'+child.id);
            pg.setRedirect(true);
            return pg;
        }
        catch(System.Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
    }

    private id createNewCase() {
        try {
            theCase.is_parent_case__c = true;
        	theCase.RecordTypeID = selectedRtype;
            insert theCase;
            return theCase.id;
        } catch(System.Exception ex){
            lastError = ex.getMessage();
            return null;
        }
    }
}