public class IntegratedProductRedirectController {

    Id impID;

    // we are extending the OpportunityLineItem controller, so we query to get the parent OpportunityId
    public IntegratedProductRedirectController(ApexPages.StandardController controller) {
        impID = [select Id, Implementation__c from Partner_Integrated_Product__c where Id = :controller.getRecord().Id limit 1].Implementation__c;
    }
    
    // then we redirect to our desired page with the Opportunity Id in the URL
    public pageReference redirect(){
        return new PageReference('/apex/RallyIntegratedPage?id=' + impID);
    }

}