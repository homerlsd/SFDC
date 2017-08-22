/** Ultima CSS Reset **/
html,body,div,dl,dt,dd,hr,
h1,h2,h3,h4,h5,h6,pre,p,ul,ol,
form,fieldset,table,th,td,iframe,
embed,object{margin:0;padding:0}
fieldset,img,abbr,iframe,hr{border:0}
h1,h2,h3,h4,h5,h6{font-size:1em}
hr { display: none }
.unstyled { list-style-type: none }

/** BASICS **/
input, textarea, select, dropdown, button, a {
  outline: none;
}


.wrapper {
  height: auto;
  min-height: 100%;
}

.content {
  padding-bottom: 150px;
}

input, select {
  font-family: sans-serif;
  font-weight: 300;
  color: #666666;
}

.placeholder { color: #666; }
.placeholderFocus { color: #000; }

ul li {
  line-height: 2em;
}

h1,h2,h3 {
  font-weight: normal;
  line-height: 1em;
}

h2 {
  font-weight: 200;
  font-size: 2em;
}

h3 {
  font-weight: 200;
  font-size: 1.2em;
}

h2 {
  margin-bottom: 30px;
  padding-bottom: 30px;
}

h3 a {
  text-decoration: none;
  color: inherit;
}

h3 + p {
  margin-top: 20px;
}

h2 small, h3 small, h4 small {
  display: block;
  text-transform: none;
}

h2 small .count, 
h3 small .count {
  display: block;
}

a {
  text-decoration: none;
  -moz-transition-duration: 0.2s;
  -webkit-transition-duration: 0.2s;
  transition-duration: 0.2s;
}

a:hover {
  color: #6dc3ff;
  text-decoration: underline;
}

::-moz-selection {
  color: #fff;
  background: #1e8ede;
}

::selection {
  color: #fff;
  background: #1e8ede;
}

.hide { display: none }
.muted, .well p.condensed { opacity: .5; }

.well {
  background: rgba(0,0,0,.05);
  margin: 20px 0;
  padding: 20px;
}


/** Ajax flash **/

#flash {
  display: none;
  text-align: center;
  padding: 20px;
  background: #fff881;  
}

/** FORMS **/
/** BUTTONS BASE **/
input, .btn, textarea, button {
  padding: 12px;
  border-radius: 6px;
  background-color: #eee;
  color: #000;
  text-decoration: none;
  margin-bottom: 10px;
  -moz-transition-duration: 0.2s;
  -webkit-transition-duration: 0.2s;
  transition-duration: 0.2s;
}

a.btn:hover {
  text-decoration: none;
  color: black;
  background-color: #e8e8e8;
}

select {
  margin-bottom: 10px;
}

input[type=submit], .btn.btn-primary, button {
  color: #fff;
  border-color: #333;
  background: #1e8ede;
  text-transform: uppercase;
  -webkit-appearance: none;
}

form hr {
  display: block;
  clear: both;
  margin-bottom: 20px;
  visibility: hidden;
}

label {
  display: block;
}

label.invalid {
  color: red;
  margin: -5px 0 10px 0;
  font-size: .9em;
}

input.invalid, textarea.invalid, button.invalid {
  border-color: red;
}

input[type=text]:hover, input[type=text]:focus, 
textarea:hover, textarea:focus, 
button:focus, button:hover, 
.btn:hover {

}

input[type=submit]:hover, input[type=submit]:focus, 
.btn.btn-primary:hover, button:hover, button:focus {

}

/** BUTTONS...EXTENDED **/
.btn.btn-small, 
.btn.btn-short {
  display: inline-block;
}

.btn.btn-short {
 padding: 2px 10px 1px 10px;
}

.btn-block {
  display: block;
  width: 100%;
  padding-left: 0;
  padding-right: 0;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}



/** LAYOUT **/
.container {
 position: relative;
 padding: 30px 0;
}



/** SIMPLE LAYOUT **/
html.simple #desk-support-header-nav, 
html.simple #desk-rightcol, 
html.simple #desk-search, 
html.simple .breadcrumb {
 display: none;
}

html.simple #desk-content, 
html.simple #desk-header {
 background: transparent;
}
html.simple #desk-header {
 padding-top: 100px;
}
html.simple #desk-leftcol {
 width: 100%;
 background: #fff;
 padding: 30px;
}




/** desk-rightcol **/
#desk-rightcol {
  border-left: 1px solid rgba(134, 134, 134, 0.25);
  padding-left: 30px;
  min-height: 500px;
}
#desk-rightcol h2 {
 white-space: nowrap;
}
#desk-rightcol ul {
 list-style-type: none;
 margin: 0;
 padding: 0;
}

/** HEADER **/
#desk-header {
 background: #fff;
}
#desk-header h1 a {
}

#desk-support-header-nav {
 text-align: right;
 list-style-type: none;
 font-size: .9em;
}
#desk-support-header-nav li {
 display: inline;
 padding-left: 20px;
}

#desk-support-header-nav {
  text-align: right;
}
#desk-support-header-nav li {
  display: inline;
  padding-left: 20px;
}
span.desk-guestMessage:after {
  content: '\2022';
  padding: 0 2px 0 6px;
}
#desk-lang-dropdown {
  position: relative;
}
#desk-lang-dropdown a {
  color: #333;
}
#desk-lang-dropdown select {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  height: 100%;
  width: 100%;
  opacity: 0;
  display: block;
  border: 0 none;
  outline: none;
  
  -webkit-appearance: none;
  -moz-appearance: none;
}


/** SEARCH **/
#desk-search {
 height: 120px;
}
#desk-search #q {
  background: white;
  border: 0;
  position: absolute;
  top: 30px;
  left: 0;
  right: 20%;
  width: 70%;
  font-size: 20px;
  padding: 20px 20px 18px 20px;
}
#desk-search #support-search-submit {
 position: absolute;
 top: 30px;
 left: 75%;
 right: 0;
 width: 25%;
 font-size: 20px;
 padding: 20px 20px 18px 20px;
}


/** CONTENT **/
#desk-content {
 background: #fff;
}




/** FOOTER **/

#desk-footer {
 color: #fff;
  height: 150px;
  margin-top: -150px;
}

#desk-footer .attribution a {
 color: inherit;
 text-decoration: none;
}


/** Pagination **/
.pagination {
 position: relative;
 text-align: center;
 padding: 10px 0;
 margin-top: -20px;
}
.pagination * {
 text-decoration: none;
 font-style: normal;
 padding: 5px 5px;
}
.current {
background: rgba(139, 139, 139, 0.1);
border-radius: 4px;
}
.previous_page, .next_page {
 display: block;
 position: absolute;
 top: 0;
 left: 0;
 padding: 10px 30px;
}
.next_page {
 left: auto;
 right: 0;
}


/** Breadcrumbs **/
.breadcrumb {
  margin: 0;
  padding: 0 20px 0px 20px;
  background: transparent;
  border-radius: 0;
  opacity: .5;
  -moz-transition-duration: 0.2s;
  -webkit-transition-duration: 0.2s;
  transition-duration: 0.2s;
}
.breadcrumb, .breadcrumb a {
 text-decoration: none;
 color: inherit;
}
.breadcrumb:hover {
 opacity: 1;
}


/** --------- **/



/** page-index **/
.desk-topic, 
.desk-qna {
 float: left;
 width: 50%;

 -moz-box-sizing: border-box;
 -webkit-box-sizing: border-box;
 box-sizing: border-box;
}
.desk-topic:nth-child(odd) , 
.desk-qna:nth-child(odd)  {
 padding: 0 20px 0 0;
 clear:left;
}
.coldiv1 {
 display: none;
}
.coldiv2 {
 clear: both;
}
.desk-topic a, 
.desk-qna a {
  overflow: hidden;
  text-overflow: ellipsis;
}
.desk-topic li, 
.desk-qna li { 
  margin-left: 17px;
}
.desk-topic h3 a, 
.desk-qna h3 a {
  text-decoration: none;
}

.desk-topic-view-all {
 margin-top: 20px;
}

.desk-topic, .desk-qna {
 margin-bottom: 30px;
}


/** Login **/
#login_form {
  margin-bottom: 20px;
}
#login_form .actions {
 margin-right: 20px;
}
#login_form .newaccount, 
#login_form .forgotpw {
 display: block;
}
.leftside .alternatelogins, 
.rightside #login_form div {
  display: none;
}
.alternatelogins div {
  display: block;
  clear: both;
  margin-bottom: 20px;
}


/** portal topics **/
.desk-snippit-article {
 margin-bottom: 20px;
 padding-bottom: 20px;
 border-bottom: 1px solid rgba(0,0,0,.1);
}
.desk-snippit-article:last-child {
 border-bottom: none;
}


/** article **/
.support-head {
  position: relative;
}

.meta-bar {
  font-style: italic;
  position: relative; 
  margin: 15px 0 30px 0;
  padding: 10px;
  border: 1px solid rgba(119, 119, 119, 0.15);;
  border-left: 0;
  border-right: 0;
}

.last-updated {
  font-size: 12px;
  opacity: 0.5;
}

.support-article.support-head h2,
.qna-top h2 {
  margin-bottom: 0;
  padding-bottom: 0;
}

.support-body img {
 max-width: 100%; height: auto;
}
.support-body h1 {
 font-size: 2em;
}
.support-body h1, 
.support-body h2, 
.support-body h3, 
.support-body h4, 
.support-body h5 {
 margin-top: 40px;
 margin-bottom: 10px;
}
.support-social {
  float: right;
}
.support-social:hover .rndbtn {

}
.rndbtn {
  opacity: 0.8;
  transition: none;
  font-size: 12px;
  line-height: 1em;
  display: inline-block;
  padding: 4px;
  background: white;
  color: black;
  text-decoration: none;
  border-radius: 2px;
  margin-right: 0;
  position: relative;
  z-index: 100;
  text-align: center;
  width: 13px;
}
.rndbtn:hover {
  opacity: 1;
  color: #fff;
  z-index: 200;
  text-decoration: none;
}
.rndbtn.btn-facebook:hover {
  background: #4f76c6;
}
.rndbtn.btn-twitter:hover {
  background: #00abec;
}
.rndbtn.btn-gplus:hover {
  background: #d85b34;
}
.rndbtn.btn-email:hover {
  background: #666;
}

.rndbtn.btn-youtube:hover {
background: #DA3636;
}

.support-body ul, 
.support-body ol, 
.support-body blockquote {
 padding: 10px 30px;
}

#attachments {
  clear: both;
  padding: 20px 20px 10px 20px;
}

#rate_article_container {
  margin-top: 20px;
  padding-top: 20px;
}


/** qna **/
.gravatar-wrapper {
  display: block;
}
.gravatar-wrapper img {
  border-radius: 100%;
}
.qna-top .gravatar-wrapper {
  margin-top: 6px;
}
.qna-replies .gravatar-wrapper {
  margin-top: 0px;
}

.qna-reply, .qna-top {
  position: relative;
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(0,0,0,.1);
}
.qna-top {
 margin-bottom: 30px;
 padding-bottom: 30px;
}
.qna-reply .gravatar-wrapper {
  margin-top: 70px;
}

.answer-rating {
  font-size: 10px;
  white-space: nowrap;
  text-align: center;
  position: relative;
  background: rgba(0,0,0,.05);
  clear: both;
  margin-top: 10px;
  box-shadow: inset 1px 1px 0 rgba(0,0,0,.1);
  border-radius: 3px;
}
.answer-rating .dialog {
  display: none;
}
.answer-rating .rate {
  text-decoration: none;
  color: inherit;
  display: inline-block;
  text-align: center;
  padding: 0px 5px;
  width: 8px;
  white-space: nowrap;
}
.answer-rating .rate.increment:hover, 
.rate_link:hover {
  color: #73ab77;
}
.answer-rating .rate.decrement:hover, 
.rate-link-down .rate_link:hover {
  color: #b16161;
}


/** Article Listing **/
.search-result, .desk-snippit-qna {
 padding-bottom: 20px;
 margin-bottom: 20px;
 border-bottom: 1px solid rgba(0,0,0,.05);
}


/** Portal **/
.support-menu {
  position: absolute;
  top: 0px;
  right: 0;
}
.support-menu li {
  padding-left: 10px;
  display: inline;
}
.support-menu li * {
  vertical-align: baseline;
}
.support-menu label {
  display: inline;
}
table {
  width: 100%;
}
th {
  text-align: left;
  border-bottom: 2px solid rgba(0,0,0,.1);
}

.interaction .gravatar-wrapper {
  margin-top: 5px;
}
.interaction {
  border-bottom: 1px solid rgba(0,0,0,.1);
  padding-bottom: 20px;
  margin-bottom: 20px;
}
.interaction-body {
 padding-top: 10px;
}

.well h3 {
  padding: 0;
  margin: 0 20px -10px 20px;
}
.well form {
  text-align: center;
  padding: 0 0 12px 0;
}

.myaccount-form {
 margin-top: 20px;
 padding-top: 20px;
  border-top: 2px solid rgba(0,0,0,.1);
}
.myaccount-form div {
  border-bottom: 1px solid rgba(0,0,0,.1);
  padding-bottom: 20px;
  margin-bottom: 20px;
}
.myaccount-form div div {
  border-bottom: 0 none;
  padding-bottom: 0;
  margin-bottom: 0;
}
.myaccount-form .verified {
  display: inline;
  padding-left: 10px;
  margin: 0;
  font-style: italic;
}
.myaccount-form button {
  vertical-align: top;
}

.support-topic-body, 
.topicContainer {
  margin-bottom: 40px;
}


/** Tablet **/
@media (max-width: 980px) {

.desk-topic, 
.desk-qna {
 float: none;
 width: auto;

 -moz-box-sizing: border-box;
 -webkit-box-sizing: border-box;
 box-sizing: border-box;
}
.support-menu {
 display: none;
}

}

/** Mobile **/
@media (max-width: 767px) {

  .row.logo-section {
    margin: 10px 0;
  }

  .support-topic-body,
  .topicContainer.row-fluid {
    
  }

  /** Hidden features **/
  #desk-search, #desk-support-header-nav, 
  .gravatar-wrapper, .answer-rating { display: none; }

  /** Layout **/
  body{min-width:0; overflow-x: hidden;}
  .container{
    width:auto; 
    padding: 0;
  }

.desk-topic, 
.desk-qna, 
.support-menu {
 float: none;
 width: auto;

 -moz-box-sizing: border-box;
 -webkit-box-sizing: border-box;
 box-sizing: border-box;
}

.page-header {
  text-align: center;
}

/** Mobile Menu **/

  .mobile-hat {
    background: rgba(133, 133, 133, 0.3);
    padding: 15px 20px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  }

  .mobile-hat a {
    color: rgba(122, 122, 122, 1);
    background: transparent;
    width: auto;
    display: inline-block !important;
    margin: 0;
    padding: 0;
    font-size: 21px;
  }

  .mobile-hat a:hover {
    background: transparent;
  }

  #desk-mobile-header, 
  #desk-mobile-search {
    max-height: 0px;
    overflow: hidden;
    -moz-transition-duration: 0.25s;
    -webkit-transition-duration: 0.25s;
    transition-duration: 0.25s;
  }

  #desk-mobile-header,
  #desk-mobile-header a, 
  #desk-mobile-header select,
  #desk-mobile-header input,
  #desk-mobile-search,
  #desk-mobile-search a, 
  #desk-mobile-search select,
  #desk-mobile-search input, {
    color: black;
  }

  body.desk-mobile-menu #desk-mobile-header {
    max-height: 600px;
  }

  body.desk-mobile-search #desk-mobile-search {
    max-height: 600px;
  }

  #desk-mobile-header .container,
  #desk-mobile-search .container {
    padding: 0 !important;
  }
  #desk-mobile-header li {
    padding: 15px 20px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  }
  #desk-mobile-header li:first-child {
  }
  #desk-mobile-header li a {
    padding: 20px;
    display: block;
    margin: -20px;
  }
  #desk-mobile-header form,
  #desk-mobile-search form {
    position: relative;
  }
  #desk-mobile-header input,
  #desk-mobile-search input {
    display: block;
    width: 100%;
  }

  #desk-mobile-lang-list select {
    display: block;
    width: 100%;
    margin: 0;
  }

  #desk-header {
    padding: 0px 0;
  }

}


/** DEFAULT COLOURS **/

  #desk-header, #desk-content, html.simple #desk-leftcol {
  color: #535353;
  background-color: transparent;
  }
  
  h1 {
  border: 0 none;
  color: #333333;
  }
  h1 a {
  text-decoration: none;
  }
  
  h2, .pagination, .breadcrumb, .desk-snippit-article, 
  #rate_article_container, .qna-reply, .qna-top, 
  .answer-rating, .search-result, .desk-snippit-qna, 
  th, .interaction, .myaccount-form, .myaccount-form div {
  border-color: rgba(0,0,0,.1);
  }
  
  a, a:active, a:visited {
  color: #666;
  }
  a:hover {
  color: #606060;
  }
  
  ::-moz-selection {
  color: #ffffff;
  background-color: #535353;
  }
  ::selection {
  color: #ffffff;
  background-color: #535353;
  }
  
  .well, .answer-rating {
  background-color: rgba(0,0,0,.05);
  }
  
  input, textarea, button {
  background-color: #ffffff;
  color: #535353;
  }
  #desk-lang-dropdown a {
  color: #535353;
  }
  input[type=submit], .btn.btn-primary, button {
  color: #ffffff;
  border-color: #535353;
  background-color: #535353;
  }
  input[type=text]:hover, input[type=text]:focus, 
  textarea:hover, textarea:focus, 
  button:focus, button:hover, 
  .btn:hover {
  
  }
  input[type=submit]:hover, input[type=submit]:focus, 
  .btn.btn-primary:hover, button:hover, button:focus {
  background-color: #535353;
  }
  
  label.invalid {
  color: #FF0000;
  }
  input.invalid, textarea.invalid, button.invalid {
  border-color: #FF0000;
  }
  
 #desk-header h1 a {
  display: table-cell;
  padding-left: 100px;
  background: url('//desk-customers.s3.amazonaws.com/shared/v5-logo.png') no-repeat scroll 0 center transparent;
  height: 100px;
  width: 100px;
  vertical-align: middle;
  }
  
  
  .top-menu .menu-item {
  display: block;
  margin: 0;
  border-bottom: 1px solid #e6e8e9;
  background: transparent;
  }

  #desk-mobile-header,
  #desk-mobile-search {
    background: rgba(114, 114, 114, 0.35);
  }
  
  #desk-mobile-header li a {
  display: inline; 
  }
  
  desk-mobile-lang-list select {
  padding: 15px;
  }

  #desk-mobile-lang-list select {
    border: 0;
  }
  
  #desk-mobile-lang-list select, 
  #desk-mobile-header input,
  #desk-mobile-search input {
    background: transparent;
    background-color: transparent;
    outline: none;
    width: 100%;
    -webkit-appearance: none;
    margin: 0;
  }
  
  .top-menu a.menu-item, .menu-item #a-content-select, .menu-item #q {
    padding: 15px;
  }
  
  .menu-item #q, .menu-item #q2 {
    margin: 0;
    width: 100%;
    box-sizing: border-box;
    ms-box-sizing: border-box;
    webkit-box-sizing: border-box;
    moz-box-sizing: border-box;
    outline: none;
    float: left; 
  }
  
  #q, #q2 {
    outline: none;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
  }

  #q2 {
    border: 0;
    border-radius: 0;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1); 
    width: 100%;
    padding: 15px 20px; 
    background: transparent; 
    padding: 20px;
  }

  .desk-topic h3,
  .desk-qna h3 {
  text-transform: uppercase;
  font-weight: 500;
  letter-spacing: 1px;
  }


.desk-topic h3,
.desk-qna h3 {
  margin-bottom: 20px; 
}

#desk-search { 
  background-color: #e5e5e5; 
}
#desk-footer { 
  background-color: #535355; 
}
  
#desk-search #support-search-submit { 
  top: 42px;
  border: 0; 
  left: 85%;
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
  border-top-right-radius: 6px;
  border-bottom-right-radius: 6px;
  padding: 22px 20px 23px 20px;
  width: 15%;
  color: #c7c7c7;
}
  
input[type=submit]:hover, input[type=submit]:focus, 
.btn.btn-primary:hover, button:hover, button:focus {
 opacity: 1;
}
  

#desk-search {
  height: 160px;
}
  
#desk-search #q {
  top: 42px;
  width: 85%;
  padding: 25px 20px 23px 20px;
}
  
#desk-lang-dropdown a.btn {
  background-color: transparent;
  outline: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  border: 0;
  padding: 0;
  margin: 0;
}
  
::-webkit-input-placeholder {
   color: #535353;
   transition: opacity 0.25s ease; 
}

:-moz-placeholder { /* Firefox 18- */
   color: #535353;  
   transition: opacity 0.25s ease; 
}

::-moz-placeholder {  /* Firefox 19+ */
   color: #535353;  
   transition: opacity 0.25s ease; 
}

:-ms-input-placeholder {  
   color: #535353;  
   transition: opacity 0.25s ease; 
}

[placeholder]:focus::-webkit-input-placeholder {
  transition: opacity 0.25s ease; 
  opacity: 0.33;
}

desk-index-subheader.span12 {
  padding-left: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  background-color: #FFFFFF !important;
}

.breadcrumb>li {
  text-shadow: none;
}

.breadcrumb {
  padding: 0;
  margin-bottom: 15px;
}

.breadcrumb .pull-right {
    display: none;
}

input, textarea, select {
  outline: none;
}

.support-head .span6 h2 {
  padding: 15px 20px;
}

.new_email label {
  margin: 20px 0 10px 0;
}

.btn-primary, input[type=submit], .btn.btn-primary, button {
  color: #fff;
  text-shadow: 1px 1px rgba(0,0,0,0.1);
  border: 0;
  box-shadow: 0 1px 0 #2F4994;
  text-transform: none;
}

#desk-search #support-search-submit {
  box-shadow: none;
}


.btn-primary:hover, .btn-primary:active, .btn-primary.active, .btn-primary.disabled, .btn-primary[disabled], #desk-search #support-search-submit:hover, input[type=submit]:hover, .btn.btn-primary:hover, button:hover {
  background-color: #4b6bc2;
  color: #fff;
}

textarea, input[type="text"], input[type="password"], input[type="datetime"], input[type="datetime-local"], input[type="date"], input[type="month"], input[type="time"], input[type="week"], input[type="number"], input[type="email"], input[type="url"], input[type="search"], input[type="tel"], input[type="color"], .uneditable-input {
  box-shadow: 0 1px 0px #eee inset;
  border-radius: 2px;
  padding: 9px 9px;
  border-color: #ddd;
  background-color: transparent;
  border: 1px solid #ccc;
  -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
  -moz-box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
  box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
  -webkit-transition: border linear 0.2s,box-shadow linear 0.2s;
  -moz-transition: border linear 0.2s,box-shadow linear 0.2s;
  -o-transition: border linear 0.2s,box-shadow linear 0.2s;
  transition: border linear 0.2s,box-shadow linear 0.2s;
}

#support-topic-page h2 {
  margin: 0 0 15px 0;
  padding: 0 0 15px 0;
}

.article-autocomplete-body {
  display: none;
}

.ui-corner-all {
  -moz-border-radius: 0;
  -webkit-border-radius: 0;
  border-radius: 0;
}

.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus {
  border: 0;
  background: #EAF3FA;
}

.ui-menu .ui-menu-item a.ui-state-hover, .ui-menu .ui-menu-item a.ui-state-active {
  margin: 0;
}

.ui-menu {
  font-family: sans-serif;
}

.ui-menu .ui-menu-item a.ui-state-hover, .ui-menu .ui-menu-item a.ui-state-active {
  font-weight: 300;
}


/** Mobile **/

@media screen and (min-width:150px) and (max-width:767px) { 

  #support-topic-page h2 {
    margin: 0;
    padding: 15px 20px 10px 20px;
  }

  .desk-snippit-qna .span1 {
    display: none;
  }

  .qna-top .span1 {
    display: none;
  }

  #desk-footer {
    font-size: 12px;
  }

  #desk-support-index {
    margin-top: 30px;
  }

  #desk-rightcol {
    min-height: 0;
    margin-bottom: 30px;
    padding-left: 0;
  }

  #desk-footer .span12 {
    padding: 15px 30px;
  }

  .breadcrumb {
    font-size: 14px;
    margin: 15px 20px;
  }

  .breadcrumb>li {
    text-shadow: none;
  }

  .breadcrumb .pull-right {
    display: none;
  }

  #desk-support-kb-content .desk-topic a.btn.btn-small, 
  #desk-support-kb-content .desk-topic a.btn.btn-short, 
  #desk-support-kb-content .desk-qna a.btn.btn-small, 
  #desk-support-kb-content .desk-qna a.btn.btn-short,
  #desk-support-kb-content .desk-topic ul, 
  #desk-support-kb-content .desk-qna ul,
  .meta.muted, .search-result .muted {
    display: none; 
  }

  .desk-topic h3 {
    margin-bottom: 0;
  }

  #desk-rightcol h2 {
    padding: 15px 20px;
  }

  #desk-leftcol .support-article h2 {
    padding: 15px 20px;
    font-size: 21px;
  }

  .desk-snippit-article div.span12 p {
    display: none;
  }

  #desk-support-kb-content .desk-topic h3 a, 
  #desk-support-kb-content .desk-qna h3 a,
  #desk-content .container #desk-rightcol ul li a,
  #desk-content .desk-snippit-article h3 a {
    display: block;
    text-decoration: none;
    background: transparent;
    border-bottom: 1px solid rgba(165, 165, 165, 0.25);
    padding: 15px 20px;
    font-size: 15px;
    font-weight: 300;
    text-transform: none;
  }

  #desk-support-kb-content .desk-topic:first-child h3 a, 
  #desk-support-kb-content .desk-qna:first-child h3 a, 
  #desk-content .desk-snippit-article:first-child h3 a {
    border-top: 1px solid rgba(165, 165, 165, 0.25);
  }

  #desk-content .container{
    padding-left: 0px !important;
    padding-right: 0px !important; 
  }

  #desk-support-index h2, 
  .support-head h2 {
    padding-left: 20px
  }

  #desk-content .support-body.row-fluid .span12, 
  .support-head form,
  .row-fluid .span11 {
    padding: 15px 20px;
  }

  #support-topic-page .desk-snippit-article {
    margin: 0;
    padding: 0;
    border: 0;
  }

  #support-topic-page .support-head {
    margin-bottom: 10px;
  }

  .email-submitted .support-body.row-fluid {
    padding-bottom: 40px;
  }

  html.simple #desk-header {
    padding-top: 0px;
  }

  .search-result .support-body h3 {
    margin-top: 20px;
  }

  .search-result, .desk-snippit-qna {
    margin-bottom: 0px;
  }  

  .desk-topic:nth-child(odd), .desk-qna:nth-child(odd) {
    padding: 0px;
  }

  .desk-topic, .desk-qna {
    margin-bottom: 0px;
  }

  h2 {
    margin-bottom: 0px !important;
  }


  #desk-content .container #desk-rightcol ul li {
    position: relative;
  }

}

@media (min-width: 1200px) {
  .row {
  margin-left: -20px;
  }
}


html {
    overflow:hidden;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;   
}
   
body {  
    overflow:hidden;
    background-color: transparent;
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


.rc_chatBlock_SV{
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


.rc_chatWindow_SV{

    overflow-y: hidden;  
    overflow-x: hidden;

    height: 100%;
    width: 100%;                                
    box-sizing: border-box;
    
    background-color: transparent;
    
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

.rc_errorMsgChatBlock{
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
                    
    background-color: #f2f2f2;

    margin-left: 0px;
    margin-right: 0px;       
    margin-top: 0px;
    margin-bottom: 0px;

    padding-top: 0px;     
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 0px;                 
    
}
            
.rc_errorMsgContainer{
    overflow-y:auto;
    overflow-x:hidden;
    
    width: 100%;
    height: 100%;
                                                   
    max-width: 100vw;
    max-height:calc(98vh -80px);                    
    
    background-color: #f2f2f2;
    color: #4d4d4d;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight:300;
    font-size: 14pt; 
    
    text-align: center; 
    vertical-align: middle;                    
     
    margin-left: auto; 
    margin-right: auto;        
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: 10px;     
    padding-bottom: auto; 
    padding-left: 10px; 
    padding-right: 10px;                       
}


 #desk-content{
    overflow-y:auto;
    overflow-x:hidden;
     
    max-width: 100vw;
    max-height:calc(98vh -80px); 
    
    width: 100%;
    height: 100%;
                                    
    max-width: 98vw;
    max-height:98vh;
    max-height:calc(98% -80px);
    max-height:calc(98vh - 80px);
                        
                           
 
 }


.rc_survey_container{
    overflow-y:auto;
    overflow-x:hidden;
    
    width: 100%;
    height: 100%;
                                                   
    max-width: 100vw;
    max-height:calc(98vh -80px);                    
    
    background-color: #ffffff;
    color: #4d4d4d;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight:300;
    font-size: 14pt; 

    vertical-align: middle;                    
     
    margin-left: auto; 
    margin-right: auto;        
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: 10px;     
    padding-bottom: auto; 
    padding-left: 10px; 
    padding-right: 10px;                 

}

#rc_survey_container::-webkit-scrollbar{
    width: 10px;
}
#rc_survey_container::-webkit-scrollbar-track{
    -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
    border-radius: 5px;
    background-color: #ccc;
    opacity: 40%;
}

#rc_survey_container::-webkit-scrollbar-thumb{
    border-radius: 5px;
    -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
    background-color: #4d4d4d;
    opacity: 40%;
}                



#qList::-webkit-scrollbar{
    width: 10px;
}
#qList::-webkit-scrollbar-track{
    -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
    border-radius: 5px;
    background-color: #ccc;
    opacity: 40%;
}

#qList::-webkit-scrollbar-thumb{
    border-radius: 5px;
    -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
    background-color:#4d4d4d;
    opacity: 40%;
}               


#desk-content::-webkit-scrollbar{
    width: 10px;
}
#desk-content::-webkit-scrollbar-track{
    -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
    border-radius: 5px;
    background-color: #ccc;
    opacity: 40%;
}

#desk-content::-webkit-scrollbar-thumb{
    border-radius: 5px;
    -webkit-box-shadow: inset 0 0 5px rgba(0,0,0,0.3);
    background-color:#4d4d4d;
    opacity: 40%;
}                   


label{
    display: inline;
}

.rc_container {
    overflow-y:auto;
    overflow-x:hidden;
    
    width: 100%;
    height: 100%;

    border: none;

    text-align: justify;
    vertical-align: middle;
    background-color: #ffffff;
    
    margin-left: auto; 
    margin-right: auto;        
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: auto;      
    padding-bottom: auto; 
    padding-left: auto;  
    padding-right: auto;                     
}


.rc_survey_qList {
    overflow-y:auto;
    overflow-x:hidden;
    
    width: 100%;
    height: 98%;
    max-height:calc(98% -80px);
                                            
    max-width: 98vw;
    max-height:calc(98vh - 80px);
    
    border: none;

    text-align: center;
    vertical-align: middle;
    background-color: #ffffff;
    
    margin-left: auto; 
    margin-right: auto;        
    margin-top: auto; 
    margin-bottom: 5px; 
    padding-top: auto;      
    padding-bottom: 5px; 
    padding-left: auto;  
    padding-right: auto;                     
}




 h3{
 
    width:98%;

    color: #4d4d4d;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight:300;
    font-size: 16pt; 

    text-align: left;
    vertical-align: middle;
    
    margin-left: 5px; 
    margin-right: 5px;        
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: auto;      
    padding-bottom: auto; 
    padding-left: auto;  
    padding-right: auto;                        
     
 }

 tbody{
    margin-left: auto;  
    margin-right: auto;
    padding-left: 2px;  
    padding-right: 2px;    
 }

 tr{
    margin-left: auto;  
    margin-right: auto;   
 }
 
 td{ 
    display:inline-block;               
    color: #4d4d4d;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight:300;
    font-size: 14pt; 

    text-align: justify;
    vertical-align: middle;
    
    margin-left: 5px; 
    margin-right: 5px;        
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: auto;      
    padding-bottom: auto; 
    padding-left: auto;  
    padding-right: auto;                        
     
 }                 
               
label{
    display:inline-block;
    color: #4d4d4d;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight:300;
    font-size: 12pt;
                        
    word-wrap: normal;
    
    
    text-align: center;
    vertical-align: middle;
    
    margin-left: 5px; 
    margin-right: 5px;        
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: auto;      
    padding-bottom: auto; 
    padding-left: auto;  
    padding-right: auto;                 
}

textarea{

    width:95%;
    height:60px;
    
    color: #4d4d4d;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-weight:300;
    font-size: 75%;                     
    word-wrap: normal;
    white-space: normal;
    margin-left: auto;  
    margin-right: auto;         
    margin-top: auto; 
    margin-bottom: auto; 
    padding-top: auto;      
    padding-bottom: auto; 
    padding-left: auto;  
    padding-right: auto;                 
}            

.rc_GreenBtn{
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
    outline:none;                 
                
}

input[type="button"].rc_GreenBtn{
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
    outline:none;                 

}


                    
      
input[type="button"]:focus.rc_GreenBtn{
    border: solid #3fab6d 1px;
    -webkit-border-radius: 3;
    -moz-border-radius: 3;
    border-radius: 3px;  
    outline:none;   
}                      
            
input[type="button"]:disabled.rc_GreenBtn{
    opacity: 0.5; 
    outline:none; 
}
    
    
    
input[type="button"]{
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
    outline:none;                  

}
                
    
                    
      
input[type="button"]:focus{
    border: solid #3fab6d 1px;
    -webkit-border-radius: 3;
    -moz-border-radius: 3;
    border-radius: 3px;     
}                      
            
input[type="button"]:disabled{
    opacity: 0.5;  
}

                
           
                