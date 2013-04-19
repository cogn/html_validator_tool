// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
$(document).ready(function(){  
 $("#validate_url").submit(function(e){
    value=$("#uri").val()
    if (value.length>0)
    {
    var url_check=0
       $.each(value.split(","), function(index, arr_value) {
	if((arr_value.indexOf("www.") > -1) && url_check==0)
	{
	url_check=0
	}
	else
	{
	url_check=1
	}	
	});
	if (url_check==1)
	{
	url_check=0
	 alert("Please enter valid Url");
	e.preventDefault();
	}
	else
	{
		return true
	}
    }
    else
    {
    alert("Please enter URL");
     e.preventDefault();
    }
    });
    
    
$('#files_attachment').change(function (e) {
var input = document.getElementById("files_attachment");
console.log(input)
			var ul = document.getElementById("fileList");
			while (ul.hasChildNodes()) {
				ul.removeChild(ul.firstChild);
			}
			for (var i = 0; i < input.files.length; i++) {
				var li = document.createElement("li");
				li.innerHTML = input.files[i].name;
				li.className = 'blink';
				ul.appendChild(li);
			}
			if(!ul.hasChildNodes()) {
				var li = document.createElement("li");
				li.innerHTML = 'No Files Selected';
				li.className = 'blinkselect';
				ul.appendChild(li);
			}
			$("#fileList").animate({width: "70%",opacity: 1.5,marginLeft: "0.6in",fontSize: "3em",borderWidth: "10px"}, 1500 );
			
});

$("#validate_file").submit(function(e){
    var input_val = document.getElementById("files_attachment");
    if (input_val.files.length>0)
    {
        var url_check=0
    for (var i = 0; i < input_val.files.length; i++) {
				 
				 if((input_val.files[i].name.indexOf(".html") > -1) && url_check==0)
				{
				url_check=0
				}
				else
				{
				url_check=1
				}	
				
			}
			if (url_check==1)
				{
				url_check=0
				 alert("Please upload html files");
				e.preventDefault();
				}
				else
				{
					return true
				}
   }
   else
   {
   alert("No file have been uploaded")
   e.preventDefault();
   }
       });
});