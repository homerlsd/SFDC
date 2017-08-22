


  
    html {
        overflow:hidden;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;   
    }
       
    body {  
        overflow:hidden;
        background-color: #ffffff;
        color: #4d4d4d;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight:300;
        font-size: 14pt;  
        margin-left: auto; 
        margin-right: auto;        
        margin-top: auto; 
        margin-bottom: auto; 
        padding-top: auto;     
        padding-bottom: auto; 
        padding-left: auto; 
        padding-right: auto; 
    }


	/** ~~~~~ Placeholder Text ~~~~~ **/
	.rallyChat_Placeholder{
	   color: #999999;
	}    

	/*Set the input placeholder text color */
	::-webkit-input-placeholder { /* Chrome/Opera/Safari */
	    color: #999999;
	}
	::-moz-placeholder { /* Firefox 19+ */
	      color: #999999;
	}
	:-ms-input-placeholder { /* IE 10+ */
	      color: #999999;
	}
	:-moz-placeholder { /* Firefox 18- */
	      color: #999999;
	}


	body::-webkit-scrollbar{
		width: 10px;
	}
	body::-webkit-scrollbar-track{
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		border-radius: 5px;
		background-color: #ccc;
		opacity: 40%;
	}
	body::-webkit-scrollbar-thumb{
		border-radius: 5px;
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		background-color: #4d4d4d;
		opacity: 40%;
	}


	#prechatForm::-webkit-scrollbar{
		width: 10px;
	}
	#prechatForm::-webkit-scrollbar-track{
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		border-radius: 5px;
		background-color: #ccc;
		opacity: 40%;
	}

	#prechatForm::-webkit-scrollbar-thumb{
		border-radius: 5px;
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		background-color: #4d4d4d;
		opacity: 40%;
	}


	#rc_chatBlock::-webkit-scrollbar{
		width: 10px;
	}
	#rc_chatBlock::-webkit-scrollbar-track{
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		border-radius: 5px;
		background-color: #ccc;
		opacity: 40%;		
	}
	#rc_chatBlock::-webkit-scrollbar-thumb{
		border-radius: 5px;
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		background-color: #4d4d4d;
		opacity: 40%;	
	}


	#liveAgentChatLog::-webkit-scrollbar{
		width: 10px;
	}
	#liveAgentChatLog::-webkit-scrollbar-track{
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		border-radius: 5px;
		background-color: #ccc;
		opacity: 40%;		
	}
	#liveAgentChatLog::-webkit-scrollbar-thumb{
		border-radius: 5px;
		-webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
		background-color: #4d4d4d;
		opacity: 40%;	
	}


/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
/** 		Header					**/
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/

	.rc_HeaderContainer{    
		display: block;        
		position: fixed;

		top: 0px;
		left: 0px;
		right: 0px;    

		height:80px;
		min-height: 80px;
		max-height: 80px;
		width: 100%;
		min-width:320px;            

		background-color: #f26c32;
		border: 1px solid #f26c32;

		margin-top: 0px;
		margin-bottom: 0px;
		margin-left: 0px;
		margin-right: 0px;

        padding-top: 0px;      
        padding-bottom: 0px;
        padding-left: 0px;
        padding-right: 0px;

		white-space: normal;
		text-align: left; 

		z-index: 1;                     
	}




	/** ~~~~~	Chat Icon	~~~~~ **/

	.rc_chatIconContainer{ 
		position: fixed;
		top: 0px;
		left: 0px;
		                
		margin-left: 0px;
		margin-right: 0px;     
		margin-top: 0px; 
		margin-bottom: 0px;

		padding-top: 15px;       
		padding-bottom: 10px;  
		padding-left: 10px;  
		padding-right: 10px;            
		z-index: 1;
	}   

	#rc_chatIcon{ 
		position: fixed;
		top: 0px;
		left: 0px;
		                
		margin-left: 0px;
		margin-right: 0px;     
		margin-top: 0px; 
		margin-bottom: 0px;

		padding-top: 0px;     
		padding-bottom: 0px; 
		padding-left: 0px;  
		padding-right: 0px;  
		           
		z-index: 2;
	}


	/** ~~~~~	Header Title	~~~~~ **/
	.rc_headerTextContainer{     
		position: fixed;
		top: 0px;
		left: 81px;
		right: 0px;   
		        
		margin-left: 0px; 
		margin-right: 0px;       
		margin-top: 0px;
		margin-bottom: 0px;

		padding-top: 25px;       
		padding-bottom: auto; 
		padding-left: 0px; 
		padding-right: 0px;               
		         
		z-index: 1;
	}

	.rc_headerText{ 
		color:#ffffff;
		font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;
		font-size: 24pt;
		font-weight:300;    

		white-space: normal;
		text-align: left; 
		vertical-align: middle;
		margin-left: auto;
		margin-right: 1px;      
		margin-top: auto;
		margin-bottom: auto;

		padding-top: auto;      
		padding-bottom: auto;  
		padding-left: auto;  
		padding-right: 2px; 

		z-index: 2;               
	}            


	/** ~~~~~	Header End Chat Button	~~~~~ **/
	.rc_EndChatBtnContainer{
	    position: fixed;
	    top: 0px;
	    right: 0px;
	    
	    
		margin-left: 0px;
		margin-right: 0px;     
		margin-top: 0px; 
		margin-bottom: 0px;

		padding-top: 20px;       
		padding-bottom: auto;  
		padding-left: 10px;  
		padding-right: 10px;                 
	             
	    z-index: 1;        

	}
	 
	   
	#liveAgentEndButton, .liveAgentEndButton {

	    height:40px;
	    width:auto;              
	    min-width:120px;

	    margin-left: auto;
	    margin-right: auto;      
	    margin-top: auto;
	    margin-bottom: auto;
	   
	    padding-top: auto;      
	    padding-bottom: auto;  
	    padding-left: 20px;  
	    padding-right: 20px;                
	    
	    background: #e5e5e5;
	    background-image: -webkit-linear-gradient(top, #e5e5e5, #e5e5e5);
	    background-image: -moz-linear-gradient(top, #e5e5e5, #e5e5e5);
	    background-image: -ms-linear-gradient(top, #e5e5e5, #e5e5e5);
	    background-image: -o-linear-gradient(top, #e5e5e5, #e5e5e5);
	    background-image: linear-gradient(to bottom, #e5e5e5, #e5e5e5);

	    border: solid #cccccc 1px;
	    -webkit-border-radius: 3;
	    -moz-border-radius: 3;
	    border-radius: 3px;


	    font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;
	    color: #4d4d4d;
	    font-size: 14pt;
	    font-weight:300;
	    text-decoration: none;
	    word-wrap: nowrap;

	    opacity: 1.0; 
	    
	    z-index: 2;   
	}





/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
/** 		Body Container 			**/
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/   



    .rc_chat{

        overflow-y: hidden;  
        overflow-x: hidden;

        margin-left: 0px;
        margin-right: 0px;       
        margin-top: 0px;
        margin-bottom: 0px;

        padding-top: 0px;     
        padding-bottom: 0px;
        padding-left: 0px;
        padding-right: 0px;         
        
        color:#4d4d4d;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 14pt;
        font-weight:300;    

        white-space: normal;
        text-align: left;               
    }
    
    
    .rc_chatBlock{
        overflow-y: hidden;  
        overflow-x: hidden;

        display: block;        
        position: fixed;
        box-sizing: border-box;

        top: 81px;
        left: 0px;
        right: 0px;
         
        height: 100%;
        width: 100%;                                
        
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                        
        background-color: transparent;

        margin-left: 0px;
        margin-right: 0px;       
        margin-top: 0px;
        margin-bottom: 0px;

        padding-top: 0px;     
        padding-bottom: 10px;
        padding-left: 0px;
        padding-right: 0px;                 
        
    }


    .rc_chatWindow{
        overflow-y: hidden;  
        overflow-x: hidden;

        height: 100%;
        width: 100%;                                
        box-sizing: border-box;
        
        background-color: #f2f2f2;
        
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 14pt;
        font-weight:300;
        
        color: #4d4d4d;
        font-size: 14pt;  
        font-weight:300;
        
        margin-left: 0px;
        margin-right: 0px;       
        margin-top: 0px; 
        margin-bottom: 5px;

        padding-top: 10px;     
        padding-bottom: 10px;
        padding-left: 10px;
        padding-right: 10px;                   
   
    }

    

/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
/** 		Pre Chat 				**/
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/   

	.prechatForm{
        overflow-y: auto;  
        overflow-x: hidden;

        height: 90%; 
        width: 100%;                                
        
        background-color: #f2f2f2;
        
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-size: 14pt;
        font-weight:300;
        
        color: #4d4d4d;
        font-size: 14pt;  
        font-weight:300;
        
        margin-left: 0px;
        margin-right: 0px;       
        margin-top: 0px; 
        margin-bottom: 5px;

        padding-top: 0px;     
        padding-bottom: 1px;
        padding-left: 2px;
        padding-right: 2px;  		
	}


	.rc_prechatFormTitleBlock{
	    color:#4d4d4d;
	    font-weight:300;
	    white-space: normal;
	    text-align: left; 
	    
	    margin-top: 0px;
	    margin-bottom: 0px;
	    margin-left: 0px;
	    margin-right: 0px;
	    
	    padding-top: 10px;      
	    padding-bottom: 20px;
	    padding-left: auto;
	    padding-right: auto;           
	}            

	.rc_prechatFormTitle{
	    color:#4d4d4d;
	    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	    font-size: 16pt;
	    font-weight:300;
	    white-space: normal;
	    text-align: left; 
	    
	    margin-top: auto; 
	    margin-bottom: auto; 
	    margin-left: auto; 
	    margin-right: auto; 
	    
	    padding-top: auto;      
	    padding-bottom: auto;
	    padding-left: auto;
	    padding-right: auto;           
	}            


	.rc_prechatFormSubTitle{
	    color:#4d4d4d;
	    font-family: "Helvetica Neue Italic", Helvetica, Arial, sans-serif;
	    font-style: italic;
	    font-size: 14pt;
	    font-weight:300;
	    white-space: normal;
	    text-align: left; 
	    
	    margin-top: auto; 
	    margin-bottom: auto; 
	    margin-left: auto; 
	    margin-right: auto; 
	    
	    padding-top: auto;      
	    padding-bottom: auto;
	    padding-left: auto;
	    padding-right: auto;           
	}            


/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
/** 		Form Elements			**/
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/

	.rc_InputBlock{ 
		height:auto;
	    width: 98%;

		margin-left: 0px;
		margin-right: 0px;       
		margin-top: 0px;
		margin-bottom: 0px;

		padding-top: 0px;     
		padding-bottom: 0px;
		padding-left: 0px;
		padding-right: 0px;             
	}

	.rc_InputGroup{         
		margin-left: auto;
		margin-right: auto;       
		margin-top: auto;
		margin-bottom: auto;

		padding-top: auto;     
		padding-bottom: auto;
		padding-left: auto;
		padding-right: auto;             
	}
	            
	.rc_InputRow{
		margin-left: 0px;
		margin-right: 0px;       
		margin-top: 0px;
		margin-bottom: 0px;

		padding-top: 0px;     
		padding-bottom: 0px;
		padding-left: 20px;
		padding-right: auto;           
	}


	.rc_inputLabel{
		color:#4d4d4d;
		font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		font-size: 16pt;
		font-weight:300;
		white-space: normal;
		text-align: left; 

		margin-top: 30px;
		margin-bottom: 10px;
		margin-left: 0px;
		margin-right: 0px;

		padding-top: auto;      
		padding-bottom: auto;
		padding-left: 0px;
		padding-right: auto;             
	}


	.rc_input{
		margin-left: 0px;
		margin-right: 0px;      
		margin-top: auto;
		margin-bottom: auto;

		padding-top: auto;     
		padding-bottom: auto;
		padding-left: auto;
		padding-right: auto;  
	}    


	input.rc_input{                
		max-height: 30px;
		width:98%;

		font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;  
		font-weight: 300;
		font-size: 14px;    
		color:#4d4d4d;

		background: #ffffff;
		border: solid #b2b2b2 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;                      
	}   


	input:focus.rc_input{ 
		background: #ffffff;
		border: solid #49c57e 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;                        
	}   


	select.rc_input{
		height: 30px;
		width:98%;

		font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;     
		font-weight:300;
		font-size: 14px;    
		color:#4d4d4d;

		background: #f2f2f2;
		border: solid #b2b2b2 1px;
		-webkit-border-radius: 0;
		-moz-border-radius: 0;
		border-radius: 0px;
	}

	select:focus.rc_input{
		background: #f2f2f2;
		border: solid #49c57e 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;   
	}


	textarea.rc_input{
		height: auto;
		min-height:60px;                
		width:98%;

		font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;     
		font-weight:300;
		font-size: 14px;    
		color:#4d4d4d;

		background: #ffffff;
		border: solid #b2b2b2 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;       
	}

	textarea:focus.rc_input{
		background: #ffffff;
		border: solid #b2b2b2 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;       
	}


	input[type="button"]{
		outline:none;
	}
	input[type="button"]::-moz-focus-inner {
		outline:none;
		border: 0;
	}

	button:focus{            
		text-decoration: none;
		outline:none;
		border: none;
		box-shadow: none;                   
	}

	button:active {
	    text-decoration: none;
	    outline:none;
	    border: none;
	    box-shadow: none;               
	}



	button:focus.rallyChat-green{
		border: solid #3fab6d 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;                         
	}

	button.rallyChat-green{         
		max-height:40px;
		width: auto;
		                               
		background: #49c57e;
		background-image: -webkit-linear-gradient(top, #49c57e, #49c57e);
		background-image: -moz-linear-gradient(top, #49c57e, #49c57e);
		background-image: -ms-linear-gradient(top, #49c57e, #2980b9);
		background-image: -o-linear-gradient(top, #49c57e, #49c57e);
		background-image: linear-gradient(to bottom, #49c57e, #49c57e);

		border: solid #3fab6d 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;

		font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;
		color: #ffffff;
		font-size: 14pt;
		font-weight: 300;
		text-decoration: none;

		opacity: 1.0;

		margin-left: 25px;
		margin-right: auto;       
		margin-top: 30px;
		margin-bottom: 30px;

		padding-top: 10px;
		padding-bottom: 40px;
		padding-left: auto;
		padding-right: auto;              
	}

	button[deactivated].rallyChat-green{
	    opacity: 0.5;            
	}


	button.rallyChat-grey{
		max-height:40px;
		width:auto;

		background: #e5e5e5;
		background-image: -webkit-linear-gradient(top, #e5e5e5, #e5e5e5);
		background-image: -moz-linear-gradient(top, #e5e5e5, #e5e5e5);
		background-image: -ms-linear-gradient(top, #e5e5e5, #e5e5e5);
		background-image: -o-linear-gradient(top, #e5e5e5, #e5e5e5);
		background-image: linear-gradient(to bottom, #e5e5e5, #e5e5e5);

		border: solid #cccccc 1px;
		-webkit-border-radius: 3;
		-moz-border-radius: 3;
		border-radius: 3px;


		font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;
		color: #4d4d4d;
		font-size: 14pt;
		font-weight: 300;
		text-decoration: none;

		opacity: 1.0;

		padding-top: 10px;
		padding-bottom: 40px;
		padding-left: auto;
		padding-right: auto;   
		                 
		margin-left: 25px;
		margin-right: auto;    
		margin-top: 30px;
		margin-bottom: 30px;               
	}


    button:hover.rallyChat-grey{
        color: #f26c32;
        border: solid #cccccc 1px;
        -webkit-border-radius: 3;
        -moz-border-radius: 3;
        border-radius: 3px;
        outline:none;                         
    } 
                   
    button:focus.rallyChat-grey{
        color: #f26c32;
        border: solid #cccccc 1px;
        -webkit-border-radius: 3;
        -moz-border-radius: 3;
        border-radius: 3px; 
        outline:none;                        
    }       



/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
/** 	Live Agent Elements			**/
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/

    

	/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
	/** 	Chat Window 				**/
	/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
    

        /** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
            			Chat Window State Changes 
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/


		#liveAgentChatLogText{
		    overflow-x: auto;     
		    overflow-y: auto;
		    border:none; 
		    font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif; 
		}

		#liveAgentChatElement{
		    border:none; 
		    font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;    
		}

		.liveAgentChatElement{
		    border:none;   
		    font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;  
		}



		/** Hide chat elements prior to the chat starting **/
			#liveAgentClientChat.liveAgentStateWaiting .rc_chatInputWindow { display: none; }
	        #liveAgentClientChat.liveAgentStateWaiting #rc_chatLogContainer{display:none;}
	        #liveAgentClientChat.liveAgentStateWaiting #liveAgentChatLog{display:none;}
        	/** set the background color prior to chat starting **/
        	#liveAgentClientChat.liveAgentStateWaiting body{ background-color: #f2f2f2; }


        	/** visibility: collapse; **/
	        #liveAgentClientChat.liveAgentState .rc_waitingMessageWindow{  
	            display: none;       
	        }
	        #liveAgentClientChat.liveAgentState #rc_waitingMessageWindow{
	            display: none;    
	        }
	            
	        .rc_waitingMessageWindow{  
	            display: none;       
	        }
	        
	        #rc_waitingMessageWindow{
	            display: none;    
	        }


	        #liveAgentClientChat.liveAgentState .rc_chatBlock {
			    overflow-y: auto;
			    overflow-x: hidden;
			    display: block;
			    position: fixed;
			    box-sizing: border-box;
			    top: 81px;
			    left: 0px;
			    right: 0px;
			    height: 100%;
			    width: 100%;
			    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
			    background-color: transparent;
			    margin-left: 0px;
			    margin-right: 0px;
			    margin-top: 0px;
			    margin-bottom: 0px;
			    padding-top: 0px;
			    padding-bottom: 0px;
			    padding-left: 0px;
			    padding-right: 0px;
	        }

			#liveAgentClientChat.liveAgentState  .rc_chatWindow {
			    overflow-y: auto;
			    overflow-x: auto;
			    height: calc(100% - 160px);
			    width: 100%;
			    box-sizing: border-box;
			    background-color: #f2f2f2;
			    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
			    font-size: 14pt;
			    font-weight: 300;
			    color: #4d4d4d;
			    font-size: 14pt;
			    font-weight: 300;
			    margin-left: 0px;
			    margin-right: 0px;
			    margin-top: 0px;
			    margin-bottom: 0px;
			    padding-top: 10px;
			    padding-bottom: 10px;
			    padding-left: 10px;
			    padding-right: 10px;
			}

			#liveAgentClientChat.liveAgentState  #rc_chatLogContainer {
			    border: none;
			    height: 95%;
			    max-height: 100%;
			    padding-bottom: 30px;
			    font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;
			}	        



		/** Hide chat input elements during alert message display **/  
			#liveAgentClientChat.liveAgentStateStatusMessage .rc_chatInputWindow { display: none; }
	        #liveAgentClientChat.liveAgentStateStatusMessage #rc_chatLogContainer{display:none;}


		/** Hide chat input elements on chat completion **/  
			#liveAgentClientChat.liveAgentStateEnded .rc_chatInputWindow { display: none; }
	        #liveAgentClientChat.liveAgentStateEnded #rc_chatLogContainer{display:none;}


		/** Hide chat input elements during time out alert message display **/
			#liveAgentClientChat.liveAgentStateIdleAlert #rc_chatLogContainer{display:none;}


		/** Hide chat input elements where -no chat- is set **/
			.no_chat .rc_chatInputWindow { display: none; }  
			#liveAgentClientChat.no_chat .rc_chatInputWindow { display: none; }
	        #liveAgentClientChat.no_chat #rc_chatLogContainer{display:none;}
	        #liveAgentClientChat.no_chat #liveAgentChatLog{display:none;}




        /*  
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
                Chat Log 
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        */
        

        #rc_chatLogContainer{
            border: none;
            height: calc(100vh - 30px);
            max-height: calc(100% - 10px);
            padding-bottom: 30px;
            font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;
        }
        
        #liveAgentChatLog{
        
            overflow-x: auto;     
            overflow-y: auto; 

            height:calc(100% - 20px);
            
            min-height:380px;
            
            width:100%;
            min-width:320px;
            
            padding: auto; 
            margin: auto;
            
            background-color: #f2f2f2;
            border: none;
            
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-weight: 300;

            margin-left: auto;
            margin-right: auto;       
            margin-top: 20px; 
            margin-bottom: 60px; 
        
            padding-top: 10px;      
            padding-bottom: 20px;
            padding-left: auto;
            padding-right: auto;              
            
        }
        
                 
        #liveAgentChatLogTyping .system{
            float:left;
            clear:both;

            color:#666666;
            font-family: font-family: "Helvetica Neue Italic", Helvetica, Arial, sans-serif;
            font-weight: 300;
            font-size: 14pt; 
            line-height:22pt;        
        }    
        
        #liveAgentChatLogText .system{
        	float:left;
            clear:both;

            color:#666666;
            font-family: font-family: "Helvetica Neue Italic", Helvetica, Arial, sans-serif;
            font-weight: 300;
            font-size: 14pt; 
            line-height:22pt;        
        }    

        #liveAgentChatLogText .name{
            color:#4d4d4d;
            font-family: font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;
            font-weight: 300;
            font-size: 14pt; 

            margin-left: auto;
            margin-right: auto;       
            margin-top: auto; 
            margin-bottom: 0px;  
        
            padding-top: auto;      
            padding-bottom: 0px; 
            padding-left: auto;
            padding-right: auto; 

            text-align:left;                 
        }
        


        #liveAgentChatLogText .client{
            float:right;
            clear:both;

            width: auto;
            max-width:75%; 

            font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif; 
            text-align:left; 

            padding-left:1px;
            padding-right:1px;
        }
        
        #liveAgentChatLogText .operator{
            float:left;
            clear:both;

            width: auto;
            max-width:75%; 

            font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;

            padding-left:1px;
            padding-right:1px;
        }
        


        #liveAgentChatLogTyping{
            float:left;
            clear:both;

            width: auto;
            max-width:75%; 

            font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;    
        }
        
        #liveAgentChatLogText .system{

            width: auto;
            max-width:75%; 

            color:#666666;
            font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;
        }
        
        
        
        #liveAgentChatLogText .messageText{
            display: block;
            position: relative;

        	width: auto;

            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
           
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14pt; 
            font-weight:300;
            
            margin-left: 2px;
            margin-right: 2px;       
            margin-top: 0px; 
            margin-bottom: 0px;  
        

            word-wrap: break-word;         
        }
        
        #liveAgentChatLogText .operator .messageText{

        	width: auto;
 
            background-color: #ffffff;
            color:#4d4d4d;  
            
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14pt; 
            font-weight: 300;

            text-align: left;
            word-wrap: break-word;	
            
            margin-left: 2px;
            margin-right: auto;       
            margin-top: 2px; 
            margin-bottom: 5px; 
        
            padding-top: 5px;     
            padding-bottom: 5px;
            padding-left: 5px;
            padding-right: 5px;                     
        }
        
        #liveAgentChatLogText .client .messageText{

        	width: auto;
  

            background-color: #4d4d4d;
            color: #ffffff; 
            
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14pt; 
            font-weight: 300;

            text-align: left; 
            word-wrap: break-word;	
            
            margin-left: auto;
            margin-right: 2px;       
            margin-top: 2px; 
            margin-bottom: 2px; 
        
            padding-top: 5px;     
            padding-bottom: 5px;
            padding-left: 5px;
            padding-right: 5px;                             
        }             
        
        .rc_agentTimeStamp{
            float:right;
            color:#666666;
            font-family: "Helvetica Neue Italic", Helvetica, Arial, sans-serif;
            font-size: 14pt; 
            font-weight: 300;
            
            text-align: right;

            margin-left: auto;
            margin-right: 0px;       
            margin-top: 5px 
            margin-bottom: 5px 
        
            padding-top: 5px     
            padding-bottom: 5px
            padding-left: 0px;
            padding-right: 0px;  
        }
        
        .rc_clientTimeStamp{
            float:right;
            color:#666666;
            font-family: "Helvetica Neue Italic", Helvetica, Arial, sans-serif;
            font-size: 14pt; 
            font-weight: 300;
            
            margin-left: 5px;
            margin-right: 5px;       
            margin-top: 5px 
            margin-bottom: 5px 
        
            padding-top: 5px     
            padding-bottom: 5px
            padding-left: auto;
            padding-right: 0px;
            text-align:right;   
        }



		/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		    			Chat Input Window 
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
		    

			/* #rc_chatInputWindow */
			.rc_chatInputWindow{                                 
			    position: fixed; /* fixed to bottom during scroll to keep chat entry constant in the viewport */
			    bottom:0px;
			    left:0px;
			    right:0px;

			    display:block;
			    height:auto;
			    min-height:80px;
			    width:100%;
			    min-width:320px;

			    background-color: #ffffff;
			    border: 1px inset #f0f0f0;
			    
			    vertical-align: middle; 
			    text-align: center;    

			    margin-left: 0px; 
			    margin-right: 0px;       
			    margin-top: 0px; 
			    margin-bottom: 0px;  
			    
			    padding-top: 0px;      
			    padding-bottom: 0px; 
			    padding-left: 0px; 
			    padding-right: 0px;                            
			}


			/* #rc_chatInputWindow */
			#liveAgentClientChat.liveAgentStateIdleAlert .rc_chatInputWindow{                                 
			    position: fixed; /* fixed to bottom during scroll to keep chat entry constant in the viewport */
			    bottom:0px;
			    left:0px;
			    right:0px;

			    display:block;
			    height:auto;
			    min-height:80px;
			    width:100%;

			    background-color: #ffffff;
			    border: 1px inset #f0f0f0;
			    
			    vertical-align: middle; 
			    text-align: center;   

			    font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;

			    margin-left: 0px; 
			    margin-right: 0px;       
			    margin-top: 0px; 
			    margin-bottom: 0px;  
			    
			    padding-top: 0px;      
			    padding-bottom: 0px; 
			    padding-left: 0px; 
			    padding-right: 0px;                          
			}

			#liveAgentChatInput{
			    position: fixed; /* fixed to bottom during scroll to keep chat entry constant in the viewport */
			    bottom:20px;
			    left:10px;
			    
			    height:auto; 
			    min-height:40px;  
			    
			    width:80%;
			    max-width: calc(100vw - 90px); 
			    border: none;
			    resize: none;    
			    white-space: normal;
			    overflow-y: auto;
			    overflow-x: hidden;    
			    line-height: 18px;
			    -webkit-line-break: after-white-space;
			    word-wrap: break-word;
			    outline-style:none;

			    padding: 1px;
			    margin: 1px;
			    
			    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
			    font-weight:300;
			    color: #4d4d4d;
			    font-size: 14pt;
			    text-decoration: none;
			    
			    background-color: #ffffff;
			    border: solid #b2b2b2 1px;
			    -webkit-border-radius: 3;
			    -moz-border-radius: 3;
			    border-radius: 3px; 


			    margin-left: 25px;
			    margin-right: auto;       
			    margin-top: 0px;
			    margin-bottom: auto;  

			    padding-top: 1px;      
			    padding-bottom: 1px;
			    padding-left: 5px;
			    padding-right: 5px;                  
			}


			#liveAgentChatInput input:focus{       
			    background-color: #ffffff;
			    border: solid #49c57e 1px;
			    -webkit-border-radius: 3;
			    -moz-border-radius: 3;
			    border-radius: 3px; 
			    font-family: "Helvetica Neue Light", Helvetica, Arial, sans-serif;   
			}
			        


			.liveAgentSendButton{         
			    position: fixed; /* fixed to bottom during scroll to keep chat entry constant in the viewport */
			    bottom:20px;
			    right:10px;
			    
			    height:auto;
			    min-height:30px; 
			    
			    width:auto;
			    max-width:90px;

			    margin-left: 25px;
			    margin-right: auto;       
			    margin-top: 25px;
			    margin-bottom: auto;    

			    padding-top: 3px;      
			    padding-bottom: 4px;
			    padding-left: 10px;
			    padding-right: 10px;    

			    background-color: #49c57e;
			    background-image: -webkit-linear-gradient(top, #49c57e, #49c57e);
			    background-image: -moz-linear-gradient(top, #49c57e, #49c57e);
			    background-image: -ms-linear-gradient(top, #49c57e, #2980b9);
			    background-image: -o-linear-gradient(top, #49c57e, #49c57e);
			    background-image: linear-gradient(to bottom, #49c57e, #49c57e);

			    border: solid #3fab6d 1px;
			    -webkit-border-radius: 3;
			    -moz-border-radius: 3;
			    border-radius: 3px;

			    font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;
			    color: #ffffff;
			    font-size: 14pt;
			    font-weight:300;
			    text-decoration: none;

			    opacity: 1.0;            
			}






/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
/** 		Pre and Post Chat 		**/
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/
           
        /*  
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
            Waiting to Connect Window 
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        */

        #liveAgentClientChat.liveAgentStateWaiting .rc_waitingMessageWindow{ 
            display: block;
            clear: both;
            overflow: hidden;
            visibility: visible;  
            
        
            height: auto; 
            max-height: calc(100%-80px);
            width: 100%; 
            vertical-align: middle; 
            text-align: center;
        
            background-color: #f2f2f2;   
        
            width:100%;
            min-width:320px;
        
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            margin-left: auto;
            margin-right: auto;       
            margin-top: auto; 
            margin-bottom: auto; 
        
            padding-top: 5%;      
            padding-bottom: auto;
            padding-left: auto;
            padding-right: auto;          
        }    
        

        #liveAgentClientChat.liveAgentStateWaiting #rc_waitingMessageIcon{
                height:100%;
                width:100%;
                
                padding-top: 5%;      
                padding-bottom: auto;
                padding-left: 2%;
                padding-right: 2%;                   
        }
                             
        /* #rc_waitingMessageTextContainer */
        #liveAgentClientChat.liveAgentStateWaiting .rc_waitingMessageTextContainer{
                height:100%;
                width:100%;
                
                color: #4d4d4d;
                font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
                font-size: 18pt; 
                font-size: 4.5vmin; 
                        
                padding-top: 5%;      
                padding-bottom: auto;
                padding-left: 2%;
                padding-right: 2%;     
        }
        
        
        
        /* #rc_waitingMessageText */
        #liveAgentClientChat.liveAgentStateWaiting .rc_waitingMessageText{
                 
            box-sizing: border-box;
            text-align:center;
            white-space: normal;
             
            color:#4d4d4d;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-weight: 300;
            font-size: 18pt;
            font-size: 4.5vmin; 
        
            margin-left: 5px;
            margin-right: 5px;       
            margin-top: 5px; 
            margin-bottom: 5px;                
        }             
        

                
        
        #liveAgentCancelButton, .liveAgentCancelButton {
        
            margin-left: auto;
            margin-right: 10px;       
            margin-top: 20px;
            margin-bottom: auto;
            
            z-index: 1;       
        
            min-height:40px;
            width:auto;
            
            padding-top: 5px;
            padding-bottom: 5px;
            padding-left: 10px;
            padding-right: 10px;                
            
            background-color: #e5e5e5;
            background-image: -webkit-linear-gradient(top, #e5e5e5, #e5e5e5);
            background-image: -moz-linear-gradient(top, #e5e5e5, #e5e5e5);
            background-image: -ms-linear-gradient(top, #e5e5e5, #e5e5e5);
            background-image: -o-linear-gradient(top, #e5e5e5, #e5e5e5);
            background-image: linear-gradient(to bottom, #e5e5e5, #e5e5e5);
        
            border: solid #cccccc 1px;
            -webkit-border-radius: 3;
            -moz-border-radius: 3;
            border-radius: 3px;
        
        
            font-family: "Helvetica Neue Bold", Helvetica, Arial, sans-serif;
            color: #4d4d4d;
            font-size: 14pt;
            font-weight: 300;
            text-decoration: none;
        
            opacity: 1.0;       
        } 
        


        
	/*  
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
	    Alerts and Messages
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	*/

		#rc_chatSessionEnded{
		    display:none;
		}

		#rc_connectionIssue{
		    display:none;
		}
		#rc_retryChat{
		    display:none;
		}


		#rc_connectionTimeoutWarning{
		    display:none;
		}

		#rc_surveyThankYou{
		    display:none;
		}
		            
		/** Alert Message **/
		#liveAgentChatLogAlertMessage{

		}



		#liveAgentClientChat.liveAgentStateIdleAlert #liveAgentChatLogAlertMessage {

		    overflow: hidden;
		    
		    text-align: center;
		    
		    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		    color: #4d4d4d;
		    font-size: 18pt;
		    font-weight:300;
		    text-decoration: none; 
		    
		    /**            
		    background-color: #ef5b4b;              
		    -webkit-animation: pulse 2s infinite alternate;
		    -moz-animation: pulse 2s infinite alternate;
		    -o-animation: pulse 2s infinite alternate;
		    animation: pulse 2s infinite alternate; 
		    **/

		    background-color: #f2f2f2; 
		    -webkit-animation-name: none;
		    -moz-animation-name: none;
		    -o-animation-name: none;
		    animation-name: none;
		    
		    margin-left: auto;
		    margin-right: auto;       
		    margin-top: auto; 
		    margin-bottom: auto; 

		    padding-top: auto;     
		    padding-bottom: auto; 
		    padding-left: auto;
		    padding-right: auto;                                    
		}


		#liveAgentChatLogAlertMessage.chasitorTyping {

		    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		    color: #4d4d4d;
		    font-size: 18pt;
		    font-weight:300;
		    text-decoration: none; 
		                
		    background-color: #f2f2f2; 
		    -webkit-animation-name: none;
		    -moz-animation-name: none;
		    -o-animation-name: none;
		    animation-name: none;
		    
		    margin-left: auto;
		    margin-right: auto;       
		    margin-top: auto; 
		    margin-bottom: auto; 

		    padding-top: auto;     
		    padding-bottom: auto; 
		    padding-left: auto;
		    padding-right: auto;                          
		}




		#liveAgentClientChat.liveAgentStateIdleAlert  #rc_connectionTimeoutWarning{
		    position: fixed;            
		    top: 81px;
		    left: 0px;

		    height: calc(100% - 160px);
		    width:100%;

            border: none;

		    display: block;
		    overflow: auto;
		    visibility: visible;  

		    vertical-align: middle; 
		    text-align: center;

		    background-color: #f2f2f2;   

		    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		    color: #4d4d4d;
		    font-size: 18pt;
		    font-weight:300;
		    text-decoration: none; 
		                
		    background-color: #f2f2f2;        
		        
		    margin-left: 0px;
		    margin-right: 0px;       
		    margin-top: 0px; 
		    margin-bottom: 0px; 

		    padding-top: 10%;     
		    padding-bottom: auto;
		    padding-left: auto;
		    padding-right: auto;                             
		}


		#liveAgentClientChat.liveAgentStateIdleAlert  #liveAgentChatLogAlertMessageTimer {
		    background-color: #f2f2f2;

		    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		    color: #4d4d4d;
		    font-size: 18pt;
		    font-weight:300;
		    text-decoration: none; 

		    background-color: #f2f2f2; 
		    -webkit-animation-name: none;
		    -moz-animation-name: none;
		    -o-animation-name: none;
		    animation-name: none;

		    margin-left: auto;
		    margin-right: auto;       
		    margin-top: auto; 
		    margin-bottom: auto; 

		    padding-top: auto;     
		    padding-bottom: auto; 
		    padding-left: auto; 
		    padding-right: auto;                           
		}


		#liveAgentMessageContainer {
		    background-color: #f2f2f2;
		    border:none;
		    
		    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		    color: #4d4d4d;
		    font-size: 18pt;
		    font-weight:300;
		    text-decoration: none; 

		    background-color: #f2f2f2; 
		    -webkit-animation-name: none;
		    -moz-animation-name: none;
		    -o-animation-name: none;
		    animation-name: none;

		    padding-top: auto;     
		    padding-bottom: auto; 
		    padding-left: auto;
		    padding-right: auto;                   
		}




		/** Chat Ended **/


		    #liveAgentClientChat.liveAgentStateEnded #rc_chatSessionEnded{
		        overflow-y: auto;  
		        overflow-x: auto;

		        display: block;        
		        position: fixed;
		        box-sizing: border-box;

		        top: 81px;
		        left: 0px;
		        right: 0px;
		         
		        height: 100%;
		        width: 100%;                                
		        
		        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		                        
		        background-color: transparent;

		        margin-left: 0px;
		        margin-right: 0px;       
		        margin-top: 0px;
		        margin-bottom: 0px;

		        padding-top: 5%;     
		        padding-bottom: auto;
		        padding-left: 10px;
		        padding-right: 10px;   
		    }		
 
        
/** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ **/

@media only screen and (max-width : 225px) {
	.prechatForm{
	    overflow-y: auto;
	    overflow-x: auto;
	}	
	.rc_chatBlock {
	    overflow-y: auto;
	    overflow-x: auto;
	}

	#liveAgentClientChat.liveAgentState .rc_headerText{
		 color: #f26c32;
	}

}

@media only screen and (max-width : 575px) {
	.rc_headerText {
		font-size: 4vw;
	}
}

