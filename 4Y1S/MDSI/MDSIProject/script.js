function openTab(e, tab) {
    var contents = document.getElementsByClassName("tabContent");
    for (var i = 0; i < contents.length; ++i) {
        contents[i].style.display = "none";
    }
    document.getElementById(tab).style.display = "block";

    var links = document.getElementsByClassName("tabLink");
    for (var i = 0; i < links.length; ++i) {
         links[i].className = links[i].className.replace(" active", "");
    }
    e.currentTarget.className += " active";
}

window.onload = function() {
	document.getElementsByClassName('tabLink')[0].click();
};
