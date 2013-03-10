
var current_picture = 0;
var current_cattegory = 0;

var categories = new Object();
var cat_array = new Array();

jQuery(function(){
    initialize_page();
    jQuery('.link_list > ul').mouseenter(function(){
      jQuery(this).addClass("hover");
      });

    jQuery('.link_list > ul').mouseleave(function(){
      jQuery(this).removeClass("hover");
      });
    jQuery('*.ovw a').unbind('click');
    jQuery('*.ovw a').click(
      function(e){
         e.preventDefault();
         jQuery('.inner_div').load( jQuery(this).attr('href') );	
	 return;
      }  
    );
  
});

function initialize_page(){
  jQuery('div.category').each(function(){
      var this_div = jQuery(this);
      var name = this_div.children('.category_name').html();
      categories[name] = this_div;
      cat_array.unshift(name);
      });


  var grepper = /#(.+)$/;
  var match = grepper.exec( document.location.href );
  if( match ){
    var elements = match[1].split(/#/);
    next_image(undefined,elements[0] );
  }else{
    next_image(undefined,0);
  }
}


function next_image(back,picture) {
   
   var picture_slide  = jQuery('.picture_slide');
   //var real_content = jQuery('.real_content_picture');
   var current_cat_name = cat_array[current_cattegory];
   var real_content = categories[current_cat_name].find('.real_content_picture');
   if( picture != undefined ){
      current_picture = picture;
   }else{
     if(back){
	current_picture--;
     }else{
	current_picture++;
     }
     if( current_picture >= real_content.length ){
	current_picture = 0;
     }else if( current_picture < 0) {
	current_picture = real_content.length -1;
     }
   }
   
   var next_pixture_element = jQuery( real_content[ current_picture ] ).children('img');
   var next_description = jQuery( real_content[ current_picture ] ).children('span').html();

   var current_element = picture_slide.children();
   var new_picture = jQuery('<div style="height:100%;width:100%"></div>').append( next_pixture_element.clone());
   //new_picture.hide();
   //new_picture.fadeIn();

   picture_slide.append( new_picture );
   jQuery('.description').html( next_description );
   
   current_element.detach();
}

function switch_category(name){
   current_cattegory++; 
   if( current_cattegory >= cat_array.length ){
      current_cattegory = 0;
   }else if( current_cattegory < 0) {
      current_cattegory = cat_array.length -1;
   }
   var current_cat_name = cat_array[current_cattegory];
   if(name){
     current_cat_name = name;
     current_cattegory = cat_array.indexOf(name);
   }else{
     current_picture = -1;
     next_image();
   }
   jQuery('.cat_link').html( current_cat_name );

}


if (!Array.prototype.indexOf) {
  Array.prototype.indexOf = function(elt /*, from*/) {
    var len = this.length;

    var from = Number(arguments[1]) || 0;
    from = (from < 0)
      ? Math.ceil(from)
      : Math.floor(from);
    if (from < 0)
      from += len;

    for (; from < len; from++) {
      if (from in this &&
	  this[from] === elt)
	return from;
    }
    return -1;
  };
}




