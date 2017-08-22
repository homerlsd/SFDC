public class CaseDependencyComponentController {

    public Boolean noProds {get;set;}
    public string pageMess {get;set;}

    public Integer requiredStep {get;set;}
    public Boolean disableStep1 {get;set;}
    public Boolean disableStep2 {get;set;}
    public Boolean disableStep3 {get;set;}
    public Boolean disableStep4 {get;set;}
    public Boolean disableStep5 {get;set;}
    public Boolean disableStep6 {get;set;}

    public List<SelectOption> step1options {get;set;}
    public List<SelectOption> step2options {get;set;}
    public List<SelectOption> step3options {get;set;}
    public List<SelectOption> step4options {get;set;}
    public List<SelectOption> step5options {get;set;}
    public List<SelectOption> step6options {get;set;}

    public List<Schema.FieldSetMember> getCaseFields() {
        return SObjectType.Case.FieldSets.CSR_DependencyFields.getFields();
    }

    public Case c {get;set;}

    public string cid {get;set;}
    
    public CaseDependencyComponentController(ApexPages.StandardController controller) {
        requiredStep = 6;

        disableStep1 = false;
        disableStep2 = false;
        disableStep3 = false;
        disableStep4 = false;
        disableStep5 = false;
        disableStep6 = false;

        string tempID = ApexPages.currentPage().getParameters().get('id');

        system.debug('CASE ID IS ' + tempid);

        id userID = UserInfo.getUserId();
            
        //DYNAMIC CASE QUERY WORK
        List<string> caseStandardFieldList = new List<string>{'id', 'Record_Type_Name__c'};
        string queryString_case = '';
        
        for(Schema.FieldSetMember fsm: this.getCaseFields()){
            caseStandardFieldList.add(fsm.getfieldPath());
        }

        // Add to set to de-dup field listing
        Set<string> fieldSet_case = new Set<string>();
        for(string s: caseStandardFieldList){
            fieldSet_case.add(s.toLowerCase());
        }
        
        // Build SOQL query (for ContactInformation)
        List<string> fieldList_case = new List<string>(fieldSet_case);
        for (Integer i=0; i<fieldList_case.size(); i++) {
            if(i == 0) {
                    queryString_case = 'select ' + fieldList_case[i];
            } else {
                    queryString_case += ', ' + fieldList_case[i];
            }
        }

        queryString_case += ', Channel__r.name, First_Time_Contact__c from Case where ID = \'' + tempID +'\' ORDER BY CreatedDate DESC LIMIT 1';

        system.debug('QUERY CASE FIELDS ARE ' + queryString_case);

        c = Database.query(queryString_case);

        system.debug('QUERIED CASE FIELDS ARE ' + c);

        if(c.step_1__c == '-Select-')
            disableStep1 = true;
        if(c.step_2__c == '-Select-')
            disableStep2 = true;
        if(c.step_3__c == '-Select-')
            disableStep3 = true;
        if(c.step_4__c == '-Select-')
            disableStep4 = true;
        if(c.step_5__c == '-Select-')
            disableStep5 = true;
        if(c.step_6__c == '-Select-')
            disableStep6 = true;

        system.debug('DISABLED STEPS ARE ' + disableStep4 + disableStep5 + disableStep6);
        findStep1();
        findStep2();
        findStep3();
        findStep4();
        findStep5();
        findStep6();

        //Set<string> perms = Utils.findUserPermissions(userID);       
    }

    public void enableAllSteps(){
        disableStep1 = false;
        disableStep2 = false;
        disableStep3 = false;
        disableStep4 = false;
        disableStep5 = false;
        disableStep6 = false;
    }

    public void setSelectedStep1(){
        enableAllSteps();
        requiredStep = 6;
        system.debug('SETTING STEP 1 VALUE ' + c.step_1__c);
        c.step_2__c = '';
        c.step_3__c = '';
        c.step_4__c = '';
        c.step_5__c = '';
        c.step_6__c = '';

        findStep2();
        findStep3();
        findStep4();
        findStep5();
        findStep6();

        if(step2options.size() == 1)
            requiredStep = 1;
    }

    public void setSelectedStep2(){
        enableAllSteps();
        requiredStep = 6;
        system.debug('SETTING STEP 2 VALUE ' + c.step_2__c);

        c.step_3__c = '';
        c.step_4__c = '';
        c.step_5__c = '';
        c.step_6__c = '';

        findStep3();
        findStep4();
        findStep5();
        findStep6();

        if(step3options.size() == 1)
            requiredStep = 2;

    }

    public void setSelectedStep3(){
        enableAllSteps();
        requiredStep = 6;
        system.debug('SETTING STEP 3 VALUE ' + c.step_3__c);

        c.step_4__c = '';
        c.step_5__c = '';
        c.step_6__c = '';

        findStep4();
        findStep5();
        findStep6();

        if(step4options.size() == 1)
            requiredStep = 3;
    }

    public void setSelectedStep4(){
        enableAllSteps();
        requiredStep = 6;
        system.debug('SETTING STEP 4 VALUE ' + c.step_4__c);

        c.step_5__c = '';
        c.step_6__c = '';

        findStep5();
        findStep6();

        if(step5options.size() == 1)
            requiredStep = 4;

    }

    public void setSelectedStep5(){
        enableAllSteps();
        requiredStep = 6;
        system.debug('SETTING STEP 5 VALUE ' + c.step_5__c);

        c.step_6__c = '';

        findStep6();

        if(step6options.size() == 1)
            requiredStep = 5;

    }

    public List<SelectOption> findStep1(){
        system.debug('STEP 1 SELECTION OPTIONS METHOD ');
        step1options = new List<SelectOption>();
        step1options.add( new SelectOption('-Select-', '-Select-'));

        List<SelectOption> tempSelects = Utils.findxxOptions('MagentoWasRight', '1',c.Record_Type_Name__c, c.Channel__r.name);

        if(tempSelects != null)
            step1options.addAll(tempSelects);
        
        system.debug('STEP 1 SELECTION OPTIONS ARE ' + step1options);

        return step1options;
    }

    public List<SelectOption> findStep2(){
        system.debug('STEP 2 SELECTION OPTIONS METHOD ');
        step2options = new List<SelectOption>();
        step2options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_1__c != null && c.Step_1__c != '' ? c.Step_1__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '2',c.Record_Type_Name__c, c.Channel__r.name);

        if(tempSelects != null)
            step2options.addAll(tempSelects);
        
        system.debug('STEP 2 SELECTION OPTIONS ARE ' + step2options);

        return step2options;
    }

    public List<SelectOption> findStep3(){
        system.debug('STEP 3 SELECTION OPTIONS METHOD ');
        step3options = new List<SelectOption>();
        step3options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_2__c != null && c.Step_2__c != '' ? c.Step_2__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '3',c.Record_Type_Name__c, c.Channel__r.name);

        if(tempSelects != null)
            step3options.addAll(tempSelects);
        
        system.debug('STEP 3 SELECTION OPTIONS ARE ' + step3Options);

        return step3options;
    }

    public List<SelectOption> findStep4(){
        system.debug('STEP 4 SELECTION OPTIONS METHOD ');
        step4options = new List<SelectOption>();
        step4options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_3__c != null && c.Step_3__c != '' ? c.Step_3__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '4',c.Record_Type_Name__c, c.Channel__r.name);

        if(tempSelects != null)
            step4options.addAll(tempSelects);
        
        system.debug('STEP 4 SELECTION OPTIONS ARE ' + step4Options);

        return step4options;
    }

    public List<SelectOption> findStep5(){
        system.debug('STEP 5 SELECTION OPTIONS METHOD ');
        step5options = new List<SelectOption>();
        step5options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_4__c != null && c.Step_4__c != '' ? c.Step_4__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '5',c.Record_Type_Name__c, c.Channel__r.name);

        if(tempSelects != null)
            step5options.addAll(tempSelects);
        
        system.debug('STEP 5 SELECTION OPTIONS ARE ' + step5Options);

        return step5options;
    }

    public List<SelectOption> findStep6(){
        system.debug('STEP 6 SELECTION OPTIONS METHOD ');
        step6options = new List<SelectOption>();
        step6options.add( new SelectOption('-Select-', '-Select-'));

        String tempString = c.Step_5__c != null && c.Step_5__c != '' ? c.Step_5__c : '';
        List<SelectOption> tempSelects = Utils.findxxOptions(tempString, '6',c.Record_Type_Name__c, c.Channel__r.name);

        if(tempSelects != null)
            step6options.addAll(tempSelects);
        
        system.debug('STEP 6 SELECTION OPTIONS ARE ' + step6Options);

        return step6options;
    }

    public void saveCase(){

        string stepString = 'Step_'+string.valueOf(requiredStep)+'__c';

        if(c.get(stepString) == null || c.get(stepString) == '' || c.get(stepString) == '-Select-'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.CaseDependencyComponent_FieldRequired));
            return;
        }
        else{
            
            try{
                if(c.Step_1__c == null || c.Step_1__c == '')
                    c.Step_1__c = '-Select-';
                if(c.Step_2__c == null || c.Step_2__c == '')
                    c.Step_2__c = '-Select-';
                if(c.Step_3__c == null || c.Step_3__c == '')
                    c.Step_3__c = '-Select-';
                if(c.Step_4__c == null || c.Step_4__c == '')
                    c.Step_4__c = '-Select-';
                if(c.Step_5__c == null || c.Step_5__c == '')
                    c.Step_5__c = '-Select-';
                if(c.Step_6__c == null || c.Step_6__c == '')
                    c.Step_6__c = '-Select-';

                update c;
            }
            catch(exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
                return ;
            }
        }


    }
}