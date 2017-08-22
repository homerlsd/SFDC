public with sharing class MultiOpptyEditController {
	
	public opportunity oppy {get;set;}
	public boolean hasProducts {get;set;}
	public string messg {get;set;}

	public MultiOpptyEditController(ApexPages.StandardController controller) {
		oppy = [select Id,
					   name,
					   account.type,
					   Record_Type_Name__c,
					   account.recordtype.name,
					   Pricebook2Id,
					   PriceBook2.Name,
					   Total_Covered_Members__c,
					   Total_Covered_Employees__c,
					   Fee_Type__c,
					   (select id,
					   		   name,
					   		   quantity,
					   		   unitprice,
					   		   implementation_fee__c,
					   		   pricebookentry.product2.name,
					   		   pricebookentry.product2id
					   		   from opportunitylineitems
					   		   WHERE (pricebookentry.product2.Product_Type__c = 'Package' OR pricebookentry.product2.Product_Type__c = 'Add-On' OR pricebookentry.product2.Product_Sub_Type__c = 'Upsell Feature'))
					   		   from Opportunity where Id = :controller.getRecord().Id limit 1];

		if(!oppy.opportunitylineitems.isEmpty()){
			hasProducts = true;
		}
		else{
			messg = 'There are no products available for pricing';
		}
	}	

	public pageReference save(){
		try{
			update oppy.opportunitylineitems;

			pageReference pg = new pageReference('/'+oppy.id);
			pg.setRedirect(true);
			return pg;
		}
		catch(exception ex){
			messg = 'Error saving product lines: ' + ex.getMessage();
			return null;
		}
	}

	public pageReference cancel(){
		pageReference pg = new pageReference('/'+oppy.id);
		pg.setRedirect(true);
		return pg;
	}
}