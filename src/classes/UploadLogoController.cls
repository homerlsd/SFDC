public without sharing class UploadLogoController {

    private Milestone1_Project__c impl;

    public sObject sObj                         {get;set;}
    public string recordID                      {get;set;}
    public string currentLogoID                 {get;set;}
    
    public Attachment attch {
        get {
          if (attch == null)
            attch = new Attachment();
          return attch;
        }
        set;
    }
   
    public UploadLogoController() {

        recordID = Apexpages.currentPage().getParameters().get('ID');
        string objName = Utils_Implementation.findObjectNameFromRecordIdPrefix(recordID);

        Set<string> recs = new Set<String>{recordID};
        string query = 'select id, Client_logo_ID__c from ' + objName + ' where ID IN : recs';
        
        system.debug('QUERY IS ' + query);

        sObj = Database.Query(query);

        if(sObj.get('Client_logo_ID__c') != null && sObj.get('Client_logo_ID__c') != '')
            currentLogoID = string.valueOf(sObj.get('Client_logo_ID__c'));

    }
    
    public PageReference upload() {
    
        if(currentLogoID != null){
        
            try {
            
            Attachment doctodelete = [select id from Attachment where id = : currentLogoID];
           
            delete doctodelete;
            } catch ( exception ex ) {
            
            }
        
        }
        
        attch.ownerID = UserInfo.getUserId();
        attch.ParentID = recordID;    
                
        try {
            insert attch;
            sObj.put('Client_logo_ID__c', attch.id);
            update sObj;
        } 
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,''+'Error Uploading file: ' + e.getMessage()));
            return null;
        }
        finally {
            attch.body = null; // clears the viewstate
            attch = new Attachment();
        } 
     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,''+'File Uploaded Succesfully'));
        
        pagereference redirect = new PageReference('/'+recordID);
        redirect.setredirect(true);
        return redirect;
        
        return null;
    }

  public pagereference Cancel(){
    pagereference redirect = new PageReference('/'+recordID);
    redirect.setredirect(true);
    return redirect;
  }
  

}