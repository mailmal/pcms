
var current_picture = 0;
var current_cattegory = 1;

var categories = new Object();
var cat_array = new Array();

jQuery(function(){
	jQuery('div.category').each(function(){
		var this_div = jQuery(this);
		var name = this_div.children('.category_name').html();
		categories[name] = this_div;
                cat_array.push(name);
	});
  
});


function next_image(back) {
   
   var picture_slide  = jQuery('.picture_slide');
   //var real_content = jQuery('.real_content_picture');
   var current_cat_name = cat_array[current_cattegory];
   var real_content = categories[current_cat_name].find('.real_content_picture');
   
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
   
   var next_pixture_element = jQuery( real_content[ current_picture ] ).children('img');
   var next_description = jQuery( real_content[ current_picture ] ).children('span').html();
   
   var current_element = picture_slide.children('img');
   picture_slide.append( next_pixture_element.clone() );
   jQuery('.description').html( next_description );
   
   current_element.detach();
}

function switch_category(){
   current_cattegory++; 
   if( current_cattegory >= cat_array.length ){
      current_cattegory = 0;
   }else if( current_cattegory < 0) {
      current_cattegory = cat_array.length -1;
   }
console.log(cat_array);
   var current_cat_name = cat_array[current_cattegory];
   jQuery('.cat_link').html( current_cat_name );
   current_picture = -1;
   next_image();
   
}

