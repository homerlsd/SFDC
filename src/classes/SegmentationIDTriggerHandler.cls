public class SegmentationIDTriggerHandler {
	
	public static void afterInsert(Segmentation_ID__c[] newSegs) {

		if(!case_validator.hasAlreadyDone()){
			system.debug('TRIGGER SIZE IN AFTER INSERT SEGMENTATION ID ' + newSegs.size());

			List<Client_Affiliation__c> updateCAs = new List<Client_Affiliation__c>();
			Set<ID> clientAffs = new Set<ID>();

			for(Segmentation_ID__c s : newSegs){   
				clientAffs.add(s.Client_Affiliation__c);
			}

			for(Client_Affiliation__c ca : [select id, name, Implementation__r.Partner__r.name,Segmentation_IDs__c, Post_Approval_Change_Control__c, Implementation__r.Initial_Approval_Date__c, (select id, Segmentation_ID__c from Segmentation_IDs__r) from Client_Affiliation__c WHERE ID IN : clientAffs]){
				string namey = '';
				integer indy = 0;
				for(Segmentation_ID__c s : ca.Segmentation_IDs__r){   
					indy++;
		           	
		           	if(ca.Implementation__r.Partner__r.name != 'Optum')
		           		namey += 'Segmentation ID #' + indy + ': ';

		           	namey += s.Segmentation_ID__c + '\n';
				}
				ca.segmentation_ids__c = namey;


					if(ca.Implementation__r.Initial_Approval_Date__c != null)
						ca.Post_Approval_Change_Control__c = 'Update to Segmentation IDs related to this record.';
				

				updateCAs.add(ca);
			}
		
			if(!updateCAs.isEmpty())
				update updateCAs;

			case_validator.setAlreadyDone();
		}
	}
}