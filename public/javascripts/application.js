// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
		$("#search_date_open_gte").focus(function(){ 
			if (this.value == 'From'){
			this.value='' }
		});
		$("#search_date_open_gte").blur(function(){ 
			if (this.value == ''){
			this.value='From' }
		});
		$("#search_date_close_lte").focus(function(){ 
			if (this.value == 'To'){
			this.value='' }
		});
		$("#search_date_close_lte").blur(function(){ 
			if (this.value == ''){
			this.value='To' }
		});
});

