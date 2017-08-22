public class ManageRewardActivitiesController {

    public SelectOption[] selectedPlanIDs { get; set; }
    public SelectOption[] allPlanIDs { get; set; }
    
    public string message { get; set; }
    public string recID { get; set; }
    public string impID { get; set; }
    public string sObjName { get; set; }

    public List<Reward_Plan_Activity__c> newRPAs {get;set;}

    public Set<string> initialplanIDs {get;set;}

    public Map<id,Reward_Plan_Activity__c> initialMap {get;set;}    

    public ManageRewardActivitiesController() {

        impID = Apexpages.currentPage().getParameters().get('impID');
        recID = Apexpages.currentPage().getParameters().get('recID');

        initialplanIDs = new Set<string>();
        initialMap = new Map<id,Reward_Plan_Activity__c>();

        List<Reward_Plan_Activity__c> planIDs =  [select Id, Reward_Activity_ID__c, Reward_Plan_Design__c from Reward_Plan_Activity__c where Reward_Plan_Design__c = :recID];
        

        for(Reward_Plan_Activity__c rpa : planIDs){
            initialplanIDs.add(rpa.id);
            initialMap.put(rpa.Reward_Activity_ID__c, rpa);
        }

        system.debug('INITIAL Plan activities ARE ' + initialplanIDs);

        selectedPlanIDs = new List<SelectOption>();

        List<Reward_Activity_ID__c> raIDs = [select id, name from Reward_Activity_ID__c WHERE Implementation__c = :impID];

        Set<ID> clientAffilIDs = new Set<ID>();

        allPlanIDs = new List<SelectOption>();
        
        for ( Reward_Activity_ID__c c : raIDs ) {
            if(initialplanIDs.isEmpty() || !initialplanIDs.contains(c.name))
                allPlanIDs.add(new SelectOption(c.Id, c.Name));
            else if(initialplanIDs.contains(c.name))
                selectedPlanIDs.add(new SelectOption(c.id, c.name));
        }
    }

    public PageReference cancel(){
        PageReference pg = new PageReference('/'+recID);
        pg.setRedirect(true);
        return pg;
    }

    public PageReference save() {

    	newRPAs = new List<Reward_Plan_Activity__c>();

        List<Reward_Plan_Activity__c> deleteRPAs = new List<Reward_Plan_Activity__c>();

        system.debug('ALL NON SELECTED AFFILIATIONS ' + allPlanIDs);

        for ( SelectOption so : allPlanIDs ) {
            system.debug('ARE WE DELETING ' + so.getValue());

            if(!initialplanIDs.isEmpty() && initialplanIDs.contains(so.getValue())){
                system.debug('DO WE FIND A DELETE ROW ' + initialMap.get(so.getValue()));
                deleteRPAs.add(initialMap.get(so.getValue()));
            }
        }

        for ( SelectOption so : selectedPlanIDs ) {
            if(initialplanIDs.isEmpty() || (!initialplanIDs.isEmpty() && !initialplanIDs.contains(so.getValue()))){
                Reward_Plan_Activity__c rp = new Reward_Plan_Activity__c();
                rp.Reward_Activity_ID__c = so.getValue();
                rp.Reward_Plan_Design__c = recID;
                newRPAs.add(rp);
            }
        }

        if(!newRPAs.isEmpty())
            upsert newRPAs;
        
        if(!deleteRPAs.isEmpty()){
        	delete deleteRPAs;
        }
        
        PageReference pg = new PageReference('/'+recID);
        pg.setRedirect(true);
        return pg;       
    }
}