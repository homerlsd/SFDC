public class Implentationaffiliationcontr {
	public Id Implid{get; set;}
	public List<Affilwrapper> lstwrapper{get; set;}
	public string fieldSetName {get;set;}
	
	public Milestone1_Project__c getobjimp(){
		system.debug('ImplId' +ImplId);
		Milestone1_Project__c objimp = new Milestone1_Project__c();

		 //DYNAMIC CASE QUERY WORK
        List<string> impStandardFieldList = new List<string>{'id'};
        string queryString_imp = '';
        
        for(Schema.FieldSetMember fsm: this.getimpFields()){
            impStandardFieldList.add(fsm.getfieldPath());
        }

        // Add to set to de-dup field listing
        Set<string> fieldSet_imp = new Set<string>();
        for(string s: impStandardFieldList){
            fieldSet_imp.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList_imp = new List<string>(fieldSet_imp);
        for (Integer i=0; i<fieldList_imp.size(); i++) {
            if(i == 0) {
                    queryString_imp = 'select ' + fieldList_imp[i];
            } else {
                    queryString_imp += ', ' + fieldList_imp[i];
            }
        }

        queryString_imp += ' from Milestone1_Project__c where ID = \'' + Implid +'\'';

        system.debug('QUERY imp FIELDS ARE ' + queryString_imp);

        objimp = Database.query(queryString_imp);

		system.debug('objimp' +objimp);
		return objimp;
	}
	

	public List<Schema.FieldSetMember> getImpFields() {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Milestone1_Project__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }

	public List<Affilwrapper> getpullrelated(){
		List<Client_Affiliation__c> clntlst=new List<Client_Affiliation__c>();
		Set<Id> clientid = new set<Id>();
		lstwrapper=new List<Affilwrapper>();
		
		
		clntlst=[select Id, Segmentation_IDs__c,Bluesteel_Affiliation_String__c,Production_Affiliation_String__c,name from Client_Affiliation__c where Implementation__c=:Implid];
		
		system.debug('clntlst' +clntlst);
		clientid = (new Map<Id,SObject>(clntlst)).keySet();
		list<Segmentation_ID__c> lstseg=new List<Segmentation_ID__c>();
		Map<Id, List<Segmentation_ID__c>> cs = new Map<Id, List<Segmentation_ID__c>>();
		lstseg = [select id, Segmentation_ID__c, Name, Segmentation_Prefix__c, Client_Affiliation__c from Segmentation_ID__c where Client_Affiliation__c IN:clientid];
		if(lstseg.size()>0){
			for(Segmentation_ID__c segite: lstseg){
				if(!cs.containsKey(segite.Client_Affiliation__c)){
					cs.put(segite.Client_Affiliation__c, new List<Segmentation_ID__c>{segite});
				}
				else{
					cs.get(segite.Client_Affiliation__c).add(segite);
				}	
			}
		}

		system.debug('map of cs' +cs);
		
		
		for(Client_Affiliation__c claff:clntlst){
			if(cs.get(claff.Id)!=null){
				lstwrapper.add(new Affilwrapper(claff.Name, cs.get(claff.Id)));	
			}
			else
				lstwrapper.add(new Affilwrapper(claff.Name, new List<Segmentation_ID__c>()));	
			
		}

			system.debug('lstwrapper' +lstwrapper);
			return lstwrapper;
	}

	public class Affilwrapper{
		public string affilfrndlyname{get; set;}
		public List<Segmentation_ID__c> lstseg {get; set;}

		public Affilwrapper(string affilfrnd, List<Segmentation_ID__c> selglst){
			this.affilfrndlyname = affilfrnd;
			this.lstseg = new List<Segmentation_ID__c>();
			this.lstseg.addall(selglst);
		}

	}
}