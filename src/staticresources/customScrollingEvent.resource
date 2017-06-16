var scrollPosition;
/*window.onscroll = function(){
	scrollPosition = window.innerHeight;
	var elem = document.getElementById("sideMenu");
	elem.style.position = "absolute";
	elem.style.top = scrollPosition +"px";
	elem.style.display = "block";
}*/

document.addEventListener('touchmove',function(){
//scrollPosition = window.innerHeight + window.pageYOffset-45;
scrollPosition = window.scrollHeight;
console.log("doucmentElement Object::" +document.documentElement);
var elem = document.getElementById("sideMenu");
var topy = elem.scrollTop;
elem.style.position = "absolute";
elem.style.top = scrollPosition +"px";
elem.style.display = "block";
});
