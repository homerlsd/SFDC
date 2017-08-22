public class LA_Authenticated {
	
	public Case c 															{get;set;}
	public boolean showError 												{get;set;}
	public boolean isAuthed 												{get;set;}
	public boolean showUnauths 		 										{get;set;}
	public string selectedAuth 												{get;set;}
	public string showAuthError 											{get;set;}
	
	public CaseComment cc 													{get;set;}

	public LA_Authenticated() {
		isAuthed = false;
		showError = false;
		showUnauths = false;

		showAuthError = '';

		string caseID = ApexPages.currentPage().getParameters().get('id');

		system.debug('WHAT IS THE ID ' + caseID);

		Case[] cs = [select id, Authenticated__c from Case where ID =: caseID];

		if(!cs.isEmpty()){
			c = cs[0];
			cc = new CaseComment(parentid=c.id,ispublished=false);
		}
		else{
			showError = true;
		}
	}

	public void showUnauthFields(){
    	if(selectedAuth == 'No'){
    		showUnauths = true;
    	}
    	system.debug('IS IT UNAUTHED - ' + showUnauths);
    }

	public PageReference saveAnd(){

		if(selectedAuth == '--Select One--'){
			showAuthError = Label.LA_Authenticated_SelectOneError;
			return null;
		}
		else if(selectedAuth == 'No' && (cc.commentBody == null || cc.commentBody == '')){
			showAuthError = Label.LA_Authenticated_UnauthedSaveError;
			return null;
		}
		else{
			
			try{
				c.Authenticated__c = (selectedAuth == 'Yes' ? true : false);
				
				if(c.Authenticated__c == false){
					c.status = Label.LA_Authenticated_ClosedNoResponseStatus;
				}
				
				update c;

				try{
					insert cc;

					system.debug('DO WE SAVE THE CASE ' + c.Authenticated__c);
				
					if(c.Authenticated__c){
						PageReference pg = Page.CreateCasev2;
						pg.getParameters().put('existing', 'true');
			            pg.getParameters().put('Case_ID', c.id);
			            return pg;
					}
					else{
						PageReference pg = new PageReference('/'+c.id);
			            return pg;
					}
				}
				catch(exception ex){
					showAuthError = ex.getmessage();
		    		return null;
				}
			}
			catch(exception ex){
				showAuthError = ex.getmessage();
	    		return null;
			}
		}
	}

	public List<SelectOption> getAuthValues(){
        List<SelectOption> lisValues = new List<SelectOption>();
        lisValues.add(new SelectOption('', '--Select One--'));
        lisValues.add(new SelectOption('Yes', 'Yes'));
        lisValues.add(new SelectOption('No', 'No'));
        return lisValues;
    }	
}