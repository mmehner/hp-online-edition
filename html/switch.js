var dev = true;
var ltn = false;
var altrec = false;

document.addEventListener("DOMContentLoaded", () => {

    var devbutton = document.getElementById("switchdev");
    var ltnbutton = document.getElementById("switchltn");
    var alternchar = document.getElementById("altern");

    var altrecbutton = document.getElementById("switchaltrec");

    setbuttons();
    hide("altrec"); /*entbehrlich durch css?*/
    
    devbutton.addEventListener('click', ()=> {
	if ( dev && !ltn ) {
	    
	} else if ( dev ) {
	    hide("versdev");
	    dev=false;
	    setbuttons();
	} else {
	    show("versdev");
	    dev=true;
	    setbuttons();
	};
    });

    ltnbutton.addEventListener('click', () => {
	if ( ltn && !dev ) {
	    
	} else if ( ltn ) {
	    hide("versltn");
	    ltn=false;
	    setbuttons();
	} else {
	    show("versltn");
	    ltn=true;
	    setbuttons();
	};
    });

    altrecbutton.addEventListener('click', () => {
	if ( altrec ) {
	    hide("altrec");
	    altrec=false;
	    setbuttons();
	} else {
	    show("altrec");
	    altrec=true;
	    setbuttons();
	};
    });

    function setbuttons() {
	if ( dev && ltn ) { alternchar.textContent="&";}
	else { alternchar.textContent="/";};
	
	if ( dev ) {devbutton.className="toggleon"; }
	else { devbutton.className="toggleoff"; };
	
	if ( ltn ) { ltnbutton.className="toggleon"; }
	else { ltnbutton.className="toggleoff"; }
	
	if ( altrec ) { altrecbutton.className="toggleon"; }
	else { altrecbutton.className="toggleoff"; }
    }

    function hide(scriptclass) {
	let class_a = document.getElementsByClassName(scriptclass);
	
	for (var i = class_a.length -1 ; i >= 0; i--) {
	    let div=class_a[i];
	    div.style.display="none";
	} 
    }

    function show(scriptclass) {
	let class_a = document.getElementsByClassName(scriptclass);

	for (var i = class_a.length -1 ; i >= 0; i--) {
	    let div=class_a[i];
	    div.style.display="block";
	    
	}
    }
});
