public class SubActivityIDHandler {
	
	public static void afterInsert(Sub_Activity_ID__c[] newsubs) {

		system.debug('TRIGGER SIZE IN AFTER INSERT subMENTATION ID ' + newsubs.size());

		List<Reward_Plan_Activity__c> updaterpas = new List<Reward_Plan_Activity__c>();
		Set<ID> rpaIDs = new Set<ID>();

		for(Sub_Activity_ID__c s : newsubs){   
			rpaIDs.add(s.Reward_Plan_Activity__c);
		}

		for(Reward_Plan_Activity__c rpa : [select id,
												  name,
												  Sub_Activity_Info__c,
												  Post_Approval_Change_Control__c,
												  Implementation__r.Initial_Approval_Date__c,
												  (select id,
										  		  Activity_ID__c,
										  		  Activity_Id__r.name,
										  		  Activity_Id__r.Activity_Name__c,
										  		  Custom_Activity_ID__r.name,
										  		  Custom_Activity_ID__r.Activity_Name__c
										  		  from Sub_Activity_IDs__r)
										  		  from Reward_Plan_Activity__c
										  		  WHERE ID IN : rpaIDs]){
			string namey = '';
			integer indy = 0;
			for(Sub_Activity_ID__c s : rpa.Sub_Activity_IDs__r){   
				indy++;
				if(s.Activity_ID__c != null)
	           		namey += 'Sub-Activity #' + indy + ': ' + s.Activity_Id__r.name + ' - ' + s.Activity_Id__r.Activity_Name__c + '\n';
	           	else
	           		namey += 'Sub-Activity #' + indy + ': ' + s.Custom_Activity_ID__r.name + ' - ' + s.Custom_Activity_ID__r.Activity_Name__c + '\n';
			}
			rpa.Sub_Activity_Info__c = namey;

			if(rpa.Implementation__r.Initial_Approval_Date__c != null){
				string ccontrol = 'Updated/Added Sub Activities:' +'\n';
				ccontrol += namey;
				rpa.Post_Approval_Change_Control__c = ccontrol;
			}

			updaterpas.add(rpa);
		}
	
		if(!updaterpas.isEmpty())
			update updaterpas;
	}

	public static void afterDelete(Sub_Activity_ID__c[] oldSubs) {

		system.debug('TRIGGER SIZE IN AFTER INSERT subMENTATION ID ' + oldSubs.size());

		List<Reward_Plan_Activity__c> updaterpas = new List<Reward_Plan_Activity__c>();
		Set<ID> rpaIDs = new Set<ID>();

		for(Sub_Activity_ID__c s : oldSubs){   
			rpaIDs.add(s.Reward_Plan_Activity__c);
		}

		for(Reward_Plan_Activity__c rpa : [select id,
												  name,
												  Sub_Activity_Info__c,
												  Post_Approval_Change_Control__c,
												  Implementation__r.Initial_Approval_Date__c,
												  (select id,
										  		  Activity_ID__c,
										  		  Activity_Id__r.name,
										  		  Activity_Id__r.Activity_Name__c,
										  		  Custom_Activity_ID__r.name,
										  		  Custom_Activity_ID__r.Activity_Name__c
										  		  from Sub_Activity_IDs__r)
										  		  from Reward_Plan_Activity__c
										  		  WHERE ID IN : rpaIDs]){
			string namey = '';
			integer indy = 0;
			for(Sub_Activity_ID__c s : rpa.Sub_Activity_IDs__r){   
				indy++;
				if(s.Activity_ID__c != null)
	           		namey += 'Sub-Activity #' + indy + ': ' + s.Activity_Id__r.name + ' - ' + s.Activity_Id__r.Activity_Name__c + '\n';
	           	else
	           		namey += 'Sub-Activity #' + indy + ': ' + s.Custom_Activity_ID__r.name + ' - ' + s.Custom_Activity_ID__r.Activity_Name__c + '\n';
			}
			rpa.Sub_Activity_Info__c = namey;

			if(rpa.Implementation__r.Initial_Approval_Date__c != null){
				string ccontrol = 'Updated/Added Sub Activities:' +'\n';
				ccontrol += namey;
				rpa.Post_Approval_Change_Control__c = ccontrol;
			}

			updaterpas.add(rpa);
		}
	
		if(!updaterpas.isEmpty())
			update updaterpas;
	}
}