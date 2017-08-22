@istest(seealldata=false)
public class Test_CaseRedirectController {
    //CREATE PAGE TESTS
    @isTest(SeeAllData=false) static void testCreate() {        
        case ca = new case(subject='test');

        ApexPAges.StandardController sc = new ApexPages.StandardController(ca);
        OverrideRedirectController tes = new  OverrideRedirectController (sc);
        PageReference pageRef = Page.CaseOverride;
        Test.setCurrentPage(pageRef);
        tes.redirect();

    }

    @isTest(SeeAllData=false) static void testCreateNew() {     
        case ca = new case(subject='test');
        
        string props = label.USER_PROPERTY_New_Case_Override_CSR_CreateCase;
        
        Metadata_Property__c mp = new Metadata_Property__c(Metadata_Type__c = 'Profile', Properties__c = props, Metadata_Name__c = 'System Administrator');
        insert mp;

        ApexPAges.StandardController sc = new ApexPages.StandardController(ca);
        OverrideRedirectController tes = new  OverrideRedirectController (sc);
        PageReference pageRef = Page.CaseOverride;
        test.setCurrentPage(pageRef);

        tes.redirect();

    }

    @isTest(SeeAllData=false) static void testCreatePerms() {     
        case ca = new case(subject='test');
        
        string props = label.USER_PROPERTY_New_Case_Override_CreateCasev2;
        
        Metadata_Property__c mp = new Metadata_Property__c(Metadata_Type__c = 'Profile', Properties__c = props, Metadata_Name__c = 'System Administrator');
        insert mp;

        ApexPAges.StandardController sc = new ApexPages.StandardController(ca);
        OverrideRedirectController tes = new  OverrideRedirectController (sc);
        PageReference pageRef = Page.CaseOverride;
        test.setCurrentPage(pageRef);

        tes.redirect();

    }
}