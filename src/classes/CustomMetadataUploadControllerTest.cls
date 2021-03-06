@isTest(SeeAllData=true)
public class CustomMetadataUploadControllerTest {
    
    public static testmethod void testUploadNoFile() {
		CustomMetadataUploadController ctrl = setup(null);
        invokeCreateCMAndValidateError(ctrl, AppConstants.FILE_MISSING);
    }
    
    public static testmethod void testUploadEmptyFile() {
		CustomMetadataUploadController ctrl = setup(Blob.valueOf(''));
        invokeCreateCMAndValidateError(ctrl, AppConstants.EMPTY_FILE);
    }
    
    public static testmethod void testSelectedTypeMissing() {
		CustomMetadataUploadController ctrl = setup(Blob.valueOf('Text__c'), AppConstants.SELECT_STRING);
        invokeCreateCMAndValidateError(ctrl, AppConstants.TYPE_OPTION_NOT_SELECTED);
    }
    
    public static testmethod void testInvalidHeaderMissingFields() {
		CustomMetadataUploadController ctrl = setup(Blob.valueOf('Text__c'));
        invokeCreateCMAndValidateError(ctrl, AppConstants.HEADER_MISSING_DEVNAME_AND_LABEL);
    }
    
    public static testmethod void testInvalidHeaderWrongFields() {
		CustomMetadataUploadController ctrl = setup(Blob.valueOf('Label,Text__c'));
        ctrl.selectedType = 'Dependent_Picklist1__mdt';
        ctrl.createCustomMetadata();
        ApexPages.Message[] msgs=ApexPages.getMessages();
		System.assert(msgs.size() == 1);
        System.assert(msgs[0].getSummary().contains('Header must contain the api names of the fields.'), 'Actual message:' + msgs[0]);
    }
    
    public static testmethod void testCreateCustomMetadata() {
		CustomMetadataUploadController ctrl = setup(Blob.valueOf('Label,Object_Name_for_Dependent_Picklist__c,Controlling_field_API_Name__c'));
        ctrl.selectedType = 'Dependent_Picklist1__mdt';
        
        ctrl.createCustomMetadata();
        
        ApexPages.Message[] msgs = ApexPages.getMessages();
        System.assert(msgs.size() == 0, 'Error messages:' + msgs);
    }
    
    public static testmethod void testCreateCustomMetadataWithDevName() {
        String countryLabel = 'AmericaTest'+Math.random();
		CustomMetadataUploadController ctrl = setup(Blob.valueOf('DeveloperName,Object_Name_for_Dependent_Picklist__c,Controlling_field_API_Name__c'));
        ctrl.selectedType = 'Dependent_Picklist1__mdt';
        
        ctrl.createCustomMetadata();
        
        ApexPages.Message[] msgs = ApexPages.getMessages();
        System.assert(msgs.size() == 0, 'Error messages:' + msgs);
    }
    
    static CustomMetadataUploadController setup(Blob file) {
        return setup(file, 'CountryMapping__mdt');
    }

    static CustomMetadataUploadController setup(Blob file, String selectedType) {
        Test.setMock(WebServiceMock.class, new MDWrapperWebServiceMock());
        CustomMetadataUploadController ctrl = new CustomMetadataUploadController();
        ctrl.setSelectedTypeForTest(selectedType);
        ctrl.setCsvBlobForTest(file);
        return ctrl;
    }
    
    static void invokeCreateCMAndValidateError(CustomMetadataUploadController ctrl, String errorMsg) {
        ctrl.createCustomMetadata();
        ApexPages.Message[] msgs = ApexPages.getMessages();
		System.assert(msgs.size() == 1);
        System.assert(msgs[0].getSummary().equals(errorMsg), 'Actual message:' + msgs[0]);
    }
}