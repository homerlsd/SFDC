@istest
public class Test_RequirementFormController {

    /*@isTest(SeeAllData=true) static void testCreateDigital() {  
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
        insert p;


        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
                insert imp;
                
                Client_Affiliation__c ca=new Client_Affiliation__c(affiliation__c=aa.Id, Account__c=a.Id, Name='test ca', Implementation__c=imp.Id);
         insert ca;

                Digital_Campaign_Requirement__c digi = new Digital_Campaign_Requirement__c(Implementation__c = imp.id);
                insert digi;
                
                PageReference pageRef = page.RequirementForm;
                pageRef.getParameters().put('id', imp.id);
                pageRef.getParameters().put('recPrefix', digi.id);
                Test.setCurrentPage(pageRef);

                RequirementFormController cont = new RequirementFormController();
                
                System.assert(cont.objName == 'digital_campaign_requirement__c');
                System.assert(cont.fieldsetName != null);

                //check for affiliations since we have child affiliation joins for digi campaigns
                System.assert(cont.allAffiliations != null);
                System.assertEquals(true,cont.hasAffils);

                cont.selectedAffiliation.addAll(cont.allAffiliations);

                system.debug('SELECTED AFFILS ARE ' + cont.selectedAffiliation);

                cont.submitResults();

    }*/

    @isTest(SeeAllData=true) static void testCreateChallenge() {    
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;

        Challenge_Requirement__c tc = new Challenge_Requirement__c(Implementation__c = imp.id, RecordTypeID=label.ChallengeRequirement_TeamRTID);
        insert tc;
        
        PageReference pageRef = page.RequirementForm;
        pageRef.getParameters().put('impID', imp.id);
        pageRef.getParameters().put('recPrefix', tc.id);
        pageRef.getParameters().put('rtype', Label.ChallengeRequirement_TeamRTID);
        Test.setCurrentPage(pageRef);

        RequirementFormController cont = new RequirementFormController();
        
        System.assert(cont.objName == 'challenge_requirement__c');
        System.assert(cont.fieldsetName.contains('TeamChallenge'));

        cont.newObject.put('Challenge_Start_DateString__c','02/07/1984');

        cont.submitResults();

    }

    @isTest(SeeAllData=true) static void testSweeps() {    
        Account a = new Account(name='test');
        insert a;

        Partner__c p = new Partner__c(name='testp',partner_string__c='testp');
        insert p;

        Milestone1_Project__c imp = new Milestone1_Project__c(account__c = a.id, Partner__c=p.id);
        insert imp;

        Private_Sweepstakes_Requirement__c tc = new Private_Sweepstakes_Requirement__c(Implementation__c = imp.id);
        insert tc;
                
        PageReference pageRef = page.RequirementForm;
        pageRef.getParameters().put('impID', imp.id);
        pageRef.getParameters().put('recPrefix', tc.id);
        Test.setCurrentPage(pageRef);

        RequirementFormController cont = new RequirementFormController();
        
        System.assert(cont.objName == 'Private_Sweepstakes_Requirement__c');

        cont.newObject.put('Reward_Type__c', 'Rally Catalog');
        cont.setRewardType();

        cont.newObject.put('Reward_Entry_Method__c', 'Coins');
        cont.setEntryMethod();

        cont.newObject.put('Reward_Entry_Type__c', 'Direct Exchange');
        cont.setEntryType();

        cont.submitResults();

    }
}