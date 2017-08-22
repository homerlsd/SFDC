public class RallyIntegratedcontroller {

public Milestone1_Project__c imp {get;set;}
public List<Product2> lstproduct{get; set;}
public string impid;
public Map<string, Product2> mapprod;
public boolean showSuccess {get;set;}
public Map<string, Partner_Integrated_Product__c> mapparintprd {get; set;}
public List<Partner_Integrated_Product__c> lstpint{get; set;}
public List<productwrpper> lstprodwrapper {get; set;}
public Map<string, string> descriptionMap  {get;set;}
public List<String> fieldnames  {get;set;}


    public RallyIntegratedcontroller() {
    	this.impid=Apexpages.currentPage().getParameters().get('ID');
    	showSuccess = False;
    	
        imp=[select Partner__c, Id, Name, Initial_Approval_Date__c, Post_Approval_Change_Control__c from Milestone1_Project__c where Id=:impid];
    	lstproduct=[select Id, Name from Product2 where Partner__c=:imp.Partner__c order by Order__c Asc];
        fieldnames = new List<String>();

        mapprod = new Map<String,Product2>();
        mapparintprd = new Map<string, Partner_Integrated_Product__c>();
        lstpint= new List<Partner_Integrated_Product__c>();
        lstprodwrapper = new List<productwrpper>();

        //Map of product name with product
        for(product2 prdite:lstproduct){
            if(mapprod.isEmpty() || !mapprod.containsKey(prdite.name)){
                mapprod.put(prdite.name, prdite);
            }
            fieldnames.add(prdite.Name);
        }

        //Map of Partner product name with partner product
        for(Partner_Integrated_Product__c prinpite:[select Id, Name, product__r.Name, Start_Date__c, Implementation__r.Biometric_Affiliations__c, Implementation__r.Quit_for_Life_Affiliations__c, Implementation__r.Real_Appeal_Affiliations__c,vendor__c, Notes__c , Product_Name__c, Implementation__c, CTA_Type__c, Phone_Number_URL__c, Product__c, Yes_No__c from Partner_Integrated_Product__c where Implementation__c =:impid]){
            if(mapparintprd.isEmpty() || !mapparintprd.containsKey(prinpite.Product_Name__c)){
                mapparintprd.put(prinpite.Product_Name__c, prinpite);
            }
        }
        
        System.debug('MAP ON LOAD IS ' + mapparintprd);

        for(Product2 proite:lstproduct){
            Partner_Integrated_Product__c  prdint;
            if(mapparintprd.get(proite.name)!=Null){
                prdint = mapparintprd.get(proite.name);
                //prdint.Product_Name__c=proite.name;
                //prdint.Product__c=mapprod.get(proite.Name).Id;
            }
            else{
                 prdint = new Partner_Integrated_Product__c();
                 prdint.Product_Name__c=proite.name;
                 prdint.Implementation__c = impid;
                 prdint.Product__c=mapprod.get(proite.Name).Id;
             }
            //proddet.add(new productdetails(proite.name, prdint));
            lstpint.add(prdint);
        }

       List<SelectOption> optiondummy = new List<SelectOption>();
        string dummy ='';
        for(Partner_Integrated_Product__c prite:  lstpint){
            
            if(!prite.product_Name__c.contains('Biometric') && !prite.product_Name__c.contains('Biometrics') ){
               lstprodwrapper.add(new productwrpper(prite, getPhoneoptions(), prite.CTA_Type__c, optiondummy, dummy, dummy, false, false));
               //system.debug('lstprodwrapper in loop' +lstprodwrapper);  
            }
            if(prite.product_Name__c.contains('Biometric') || prite.product_Name__c.contains('Biometrics')){
                if(prite.product_Name__c.contains('Optum Biometric')){
                    lstprodwrapper.add(new productwrpper(prite, getBiometricoptions(), prite.CTA_Type__c, getSSOoptions(), prite.vendor__c, dummy, True, False));
                    system.debug('lstprodwrapper from loop1' +lstprodwrapper);
                }
                else{
                   lstprodwrapper.add(new productwrpper(prite, getThirdPartyoptions(), prite.CTA_Type__c, optiondummy, dummy, prite.vendor__c, False, True)); 
                    system.debug('lstprodwrapper from loop2' +lstprodwrapper);
                }
                
                system.debug('lstprodwrapper from loop' +lstprodwrapper);
            }
           
        }

        findFieldDescription();

    }

    

    public void findFieldDescription(){

        try{
            descriptionMap = new Map<String, String>();
            descriptionMap = Utils_Implementation.getFieldInfoMap_ROF('Partner_Integrated_Product__c',fieldnames, descriptionMap);
           
           system.debug('DESC MAP IS ' + descriptionMap);
           
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return;
        }
        
    }

    public class productwrpper{
        public Partner_Integrated_Product__c prodint{get; set;}
        public List<SelectOption> lstopt{get; set;}
        public String SelectedValue {get;set;}
        public List<SelectOption> lstvendor{get; set;}
        public String Selectedvendor {get;set;}
        public string vendorName{get; set;}
        public boolean bln1{get; set;}
        public boolean bln2{get; set;}

        public productwrpper(Partner_Integrated_Product__c proite, List<SelectOption> lstopt, string selopt, List<SelectOption> lstvend, string selven, string vendorNm, boolean bool1, boolean bool2){
            this.prodint=proite;
            this.lstopt=new List<SelectOption>();
            this.lstopt.addall(lstopt);
            this.Selectedvalue=selopt;
            this.lstvendor=new List<SelectOption>();
            this.lstvendor.addall(lstvend);
            this.Selectedvendor=selven;
            this.vendorName=vendorNm;
            this.bln1=bool1;
            this.bln2=bool2;

        }
    }

    public pageReference Save(){
        try{

            List<Partner_Integrated_Product__c>lstprod=new List<Partner_Integrated_Product__c>();   

            system.debug('lstproductwrapper from save' +lstprodwrapper);

            boolean apped = false;
            if(imp.Initial_Approval_Date__c != null)
                apped = true;

            integer index = 0;
            string namey = 'Updated Integrated Products related to this record:' +'\n';

        	for(productwrpper pdite: lstprodwrapper){
        		index++;
                if(mapparintprd.get(pdite.prodint.product_name__c)!=Null){
                    
                        Partner_Integrated_Product__c  pro= mapparintprd.get(pdite.prodint.product_name__c);
                        //pro.product__c=mapprod.get(pdite.prodint.product_name__c).Id;
                        pro.CTA_Type__c=pdite.Selectedvalue;
                        pro.Phone_Number_URL__c=pdite.prodint.Phone_Number_URL__c;
                        pro.Start_Date__c = pdite.prodint.Start_Date__c;
                        if(pdite.prodint.Yes_No__c=='Yes'){
                            if( pdite.prodint.Phone_Number_URL__c == Null || pdite.selectedvalue == 'None'){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RallyIntegrated_ErrorMess));
                                return null;
                            } 
                            else{
                               pro.Yes_No__c=pdite.prodint.Yes_No__c; 
                            }   
                        }
                        else
                        {
                           pro.Yes_No__c=pdite.prodint.Yes_No__c; 
                       }
                       if(pdite.prodint.product_Name__c.contains('Optum Biometric')){
                            pro.vendor__c=pdite.Selectedvendor;
                       }
                       else{
                        pro.vendor__c=pdite.prodint.vendor__c;
                       }
                       
                        pro.Notes__C = pdite.prodint.Notes__c;
                        pro.product_Name__c = pdite.prodint.product_Name__c;

                        namey+= 'Product #'+index+': ' + pro.product_name__c + ' - CTA: ' + pro.CTA_Type__c + ' - Phone/Url: ' + pro.Phone_Number_URL__c +  '\n';

                        lstprod.add(pro);

                }
                else{     
                    Partner_Integrated_Product__c  prot= new Partner_Integrated_Product__c();
                    prot.product__c=mapprod.get(pdite.prodint.product_name__c).ID;
                    prot.Implementation__c =impid;
                    prot.CTA_Type__c=pdite.Selectedvalue;
                    prot.Phone_Number_URL__c=pdite.prodint.Phone_Number_URL__c;
                    prot.Start_Date__c = pdite.prodint.Start_Date__c;
                    if(pdite.prodint.Yes_No__c=='Yes'){
                        if( pdite.prodint.Phone_Number_URL__c == Null && pdite.selectedvalue != 'None'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RallyIntegrated_ErrorMess));
                            return null;
                        } 
                        else{
                           prot.Yes_No__c=pdite.prodint.Yes_No__c; 
                        }   
                    }
                    else{
                       prot.Yes_No__c=pdite.prodint.Yes_No__c; 
                    }
                       prot.Notes__c = pdite.prodint.Notes__c;
                    prot.product_Name__c = pdite.prodint.product_Name__c;
                    if(pdite.prodint.product_Name__c.contains('Optum Biometric')){
                                prot.vendor__c=pdite.Selectedvendor;
                    }
                    else{
                        prot.vendor__c=pdite.prodint.vendor__c;
                    }
                    
                    namey+= 'Product #'+index+': ' + prot.product_name__c + '\n';
                    
                    lstprod.add(prot);

                } 
            }

        	if(lstprod.size()>0){
        		upsert lstprod;
                system.debug('size of partner int product' +lstprod.size());
        	}

            if(apped){
                imp.Post_Approval_Change_Control__c = namey;
                update imp;
            }
        	
        	PageReference pgref=new PageReference('/'+impId);
        	pgref.setRedirect(true);
        	return pgref;

    	}
    	catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage()));
            return null;
        }
        

    }

    public List<SelectOption> getPhoneoptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Phone - Default','Phone - Default'));
        options.add(new SelectOption('Phone - Customer Defined','Phone - Customer Defined'));

        return options;

    }

    public List<SelectOption> getBiometricoptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('SSO','SSO'));
        options.add(new SelectOption('URL','URL'));
        options.add(new SelectOption('Both','Both'));

        return options;

    }

    public List<SelectOption> getSSOoptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Quest','Quest'));
        options.add(new SelectOption('Wellness','Wellness'));
        options.add(new SelectOption('Both','Both'));
        

        return options;

    }

    public List<SelectOption> getThirdpartyoptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('URL','URL'));
        return options;
    }

    public pageReference Cancel(){
    	PageReference pgref=new PageReference('/'+impId);
    	pgref.setRedirect(true);
    	return pgref;
    	
    }
}