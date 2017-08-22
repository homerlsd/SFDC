@isTest
private class Test_ImportData {
	
	@isTest static void test_upload() {
		Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;
        
        Client_Affiliation__c ca = new Client_Affiliation__c(account__c=a.id,Implementation__c=imp.id,Affiliation_Roles__c='Biometrics',name='someaffil');
        insert ca;

        Affiliation_Mapping__c affmap = new Affiliation_Mapping__c(Client_Affiliation__c = ca.id, Affiliation_Logic_Source__c = 'PVRC');
        insert affmap;

   
        PageReference ref = new PageReference('/apex/ImportDataPage?id=' + affmap.id);
        Test.setCurrentPage(ref);
        
        importDataFromCSV cont=new importDataFromCSV();

        string tt = 'Pols'+'\r'+'123,12345,123456';
        
		cont.csvfilebody=Blob.valueOf(tt);       

        cont.importcsvfile();
	}
	
}