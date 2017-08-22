////////////////////////////////////////////////////////////////////
//Type             : Apex Class
//Name             : ctrlUpdateallrecFromCSV
//Company          : 
//Created By       :AMR
//Last Modified By :AMR 4.5.2017
///////////////////////////////////////////////////////////////////

public class ctrlUpdateallrecFromCSV{
  
    public Id strBatchId {get; set;}
    public static string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public Static Blob contentFile1{get;set;}
     
    
    // constructor
    public ctrlUpdateallrecFromCSV() {
        if(contentFile1 != null) {
            nameFile = contentFile1.toString();
        }
    }
 
    public static void ReadFile() {
        String CheckString = contentFile1.toString();
        System.Debug('##### File to be uploaded' + nameFile ); 
        System.Debug('##### CSV lines to be uploaded' + CheckString); 

        ReadandPopulateBatch objBatchProcess= new ReadandPopulateBatch(CheckString);
        String strBatchId = Database.executeBatch(objBatchProcess, 200);
        System.Debug('##### Batch ID is ' + strBatchId  );
    }
}