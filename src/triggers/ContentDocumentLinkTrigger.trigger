trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) { 
    
    system.debug('DO WE GET IN THE TRIGGER' + trigger.new);

    for(ContentDocumentLink l : Trigger.new){
        
        system.debug('ID SUBSTRING IS ' + string.valueOf(l.LinkedEntityId).subString(0,3));

        if(string.valueOf(l.LinkedEntityId).subString(0,3) == Label.ContentDocumentLink_ImpObjectID || string.valueOf(l.LinkedEntityId).subString(0,3) == '001')
            l.Visibility='AllUsers'; 
    }
}