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
    hideID("hpx4");

    
    devbutton.addEventListener('click', ()=> {
	if ( dev && !ltn ) {
	    
	} else if ( dev ) {
	    hide("versdev");
	    hide("jyotsnadev");
	    dev=false;
	    setbuttons();
	} else {
	    show("versdev");
	    show("jyotsnadev");
	    dev=true;
	    setbuttons();
	};
    });

    ltnbutton.addEventListener('click', () => {
	if ( ltn && !dev ) {
	    
	} else if ( ltn ) {
	    hide("versltn");
	    hide("jyotsnaltn");
	    ltn=false;
	    setbuttons();
	} else {
	    show("versltn");
	    show("jyotsnaltn");
	    ltn=true;
	    setbuttons();
	};
    });

    altrecbutton.addEventListener('click', () => {
	if ( altrec ) {
	    show("notaltrec");
	    showID("hp4");
	    hide("altrec");
	    hideID("hpx4");
	    altrec=false;
	    setbuttons();
	} else {
	    hide("notaltrec");
	    hideID("hp4");
	    show("altrec");
	    showID("hpx4");
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
	    if (div.tagName === "A") {
		div.style.display="inline-block";
	    } else {
		div.style.display="block";
	    }
	}
    }

    function hideID(id) {
	let div = document.getElementById(id);
	div.style.display="none";
    }

    function showID(id) {
	let div = document.getElementById(id);
	div.style.display="block";
    }

});
