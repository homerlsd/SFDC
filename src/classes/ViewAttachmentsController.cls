public with sharing class ViewAttachmentsController {
	public String impID { get; set; }
	public Attachment[] Atts { get; set; }

	public ViewAttachmentsController(){
		impID = ApexPages.currentPage().getParameters().get('id');

		system.debug('IMP ID IS ' + impID);

		Atts =[select id, name, ParentID, CreatedBy.Name, LastModifiedDate from Attachment where ParentID = :impID];

		system.debug('atts are ' + atts);

	}

	public pageReference goHome(){
		PageReference pg = new PageReference('/'+impID);
		pg.setRedirect(true);
		return pg;
	}
}