jQuery(function(){
    jQuery('.inner_div').show();
    jQuery('.inner_div a').click(function(e){
	e.preventDefault();
	document.location.href = jQuery(this).attr("href");
	initialize_page();
	jQuery('.inner_div').hide();
      }
      
    );

});
