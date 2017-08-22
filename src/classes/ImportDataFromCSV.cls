public class ImportDataFromCSV {
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public string SelectedOpt{get; set;}
    public boolean objbln{get; set;}
    public boolean Uploadbln{get; set;}
    public boolean resultbln{get; set;}
    public String recordID {get; set;}
    public Affiliation_Mapping__c affMapping {get; set;}
    
    public ImportDataFromCSV(){

        recordID = ApexPages.currentPage().getParameters().get('id');

        try{
            affMapping = [select id, Identifier_Values__c, Affiliation_Logic_Source__c, Client_Affiliation__c, Client_Affiliation__r.Implementation__c from Affiliation_Mapping__c where ID = : recordID];
        }
        catch(Exception e){
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'This record ID is no longer valid.  This record could have been deleted.  Please see a Salesforce Admin.');
            ApexPages.addMessage(errorMessage);
        }

        csvFileLines = new String[]{};
        Uploadbln = False;
        resultbln = False;
        objbln = true;
    }
      
    public void importCSVFile(){

        objbln = true;
        Uploadbln = true;
        resultbln = true;
        
        try{
           csvAsString = csvFileBody.toString();
           
           system.debug('CSV FILE ' + csvAsString);
           
           csvFileLines = csvAsString.split('\r'); 
           string str='';

           system.debug('CSV FILE LINES ' + csvFileLines.size());

           for(Integer i=0;i<csvFileLines.size();i++){
               system.debug('WHAT IS i ' + i);
               system.debug('WHAT IS the value ' + csvFileLines[i].split('\n'));

               if(i>0){
                   string[] csvRecordData = csvFileLines[i].split(',');
                   str += csvRecordData[0] +'\n';
               }
            }
        
           affMapping.Identifier_Values__c = str ;  
                                                                                  
           update affMapping;
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
    }

    public PageReference gotoRecord(){
        system.debug('WHAT IS THE RECORD ID ' + Apexpages.currentPage().getParameters().get('g'));
        string recID = Apexpages.currentPage().getParameters().get('g');
        
        PageReference pg = new PageReference('/'+recid);
        pg.setRedirect(true);
        return pg;
    }
}