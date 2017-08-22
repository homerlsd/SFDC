public class OpportunityRelatedListController {

	public Boolean noProds {get;set;}
	public Boolean isDirector {get;set;}
	public string pageMess {get;set;}
	public string deleteRecordId {get;set;}

	public Opportunity oppy {get; set;}
	public List<OpportunityLineItem> showOlis {get; set;}
	
   public OpportunityRelatedListController(ApexPages.StandardController controller) {	

   			id userID = UserInfo.getUserId();

   			showOlis = new List<OpportunityLineItem>();	
   			noProds = false;
   			isDirector = false;
   			pageMess = '';

            oppy = [select Id,
            			   Fee_Type__c,
            			   Record_Type_Name__c,
            			   Pricebook2Id,
            			   PriceBook2.Name,
            			   Total_Covered_Members__c,
            			   Total_Covered_Employees__c,
            			   account.type,
            			   account.recordtype.name,
            			   (select id,
            			   	quantity,
            			   	totalprice,
            			   	unitprice,
            			   	description,
            			   	Implementation_Fee__c,
            			   	pricebookentryid,
            			   	pricebookentry.product2ID,
            			   	pricebookentry.product2.name,
            			   	pricebookentry.product2.Product_Type__c,
            			   	pricebookentry.product2.Product_Family__c
            			   	from OpportunityLineItems ORDER BY Opportunity_Product_Order__c ASC, Effective_Date__c ASC, TotalPrice DESC)
            			    from Opportunity
            			    where Id = :controller.getRecord().Id limit 1];

           	//TODO - REPLACE WITH USER/PROFILE PROPERTIES EVENTUALLY
            Set<string> perms = Utils.findUserPermissions(userID);

            system.debug('PERMS IS ' + perms);
            
            if(!perms.isEmpty() && perms.contains('Price Opportunities'))
            	isDirector = true;

			if(oppy.OpportunityLineItems.isEmpty()){
				pageMess = 'No Selected Products or Packages';
				noProds = true;
			}
			else{
				for(OpportunityLineItem oli : oppy.OpportunityLineItems){
					if(oli.pricebookentry.product2.Product_Type__c == 'Package' || oli.pricebookentry.product2.Product_Type__c == 'Add-On')
						showOlis.add(oli);
				}
			}
	}

	public pageReference editOpptyProds(){
		PageReference pg = new PageReference('/oppitm/multilineitem.jsp');
		Map<string,string> params = pg.getParameters();
		params.put('oppId',oppy.id);
		params.put('retURL',oppy.id);
		pg.setRedirect(true);
		return pg;
	}

	public pageReference pricebook(){
		pageReference pg = new PageReference('/oppitm/choosepricebook.jsp');
		Map<string,string> params = pg.getParameters();
		params.put('id',oppy.id);
		pg.setRedirect(true);
		return pg;

	}

	public pageReference deleteRecord(){
		list<OpportunityLineItem> oliDel = [select id from OpportunityLineItem where ID = : deleteRecordId];

		if(!oliDel.isEmpty()){

			delete oliDel;

			pageReference pg = new pageReference('/'+oppy.id);
			pg.setRedirect(true);
			return pg;

		}

		return null;
	}
	
	
}