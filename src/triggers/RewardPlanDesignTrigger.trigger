trigger RewardPlanDesignTrigger on Reward_Plan_Design__c (after insert) {
	if(trigger.isAfter && trigger.isInsert){
		RewardPlanDesignHandler.afterInsert(trigger.new);
	}
}