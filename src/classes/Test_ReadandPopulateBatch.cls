@istest(seealldata=true)
public class Test_ReadandPopulateBatch {

    @isTest(SeeAllData=true) static void Test_ReadandPopulateBatch(){

    	string docID = Label.Test_ReadandPopulateBatch_DocumentID;
    	
    	system.debug('##### DOC ID IS  ' + docID);

		Document csvUpload = [select id, body from Document where ID = : docID];

		system.debug('##### DOCUMENT IS  ' + csvUpload);
		
		String csvLines = csvUpload.body.toString();
        System.Debug('##### CSV lines to be uploaded' + csvLines); 

        ReadandPopulateBatch objBatchProcess= new ReadandPopulateBatch(csvLines);
        String strBatchId = Database.executeBatch(objBatchProcess, 200);
        System.Debug('##### Batch ID is ' + strBatchId  );

	}
}