// add this file to /WebRoot/
// come from index.html

function writeCookie(name, value, hours)
{
  var expire = "";
  if(hours != null)
  {
    expire = new Date((new Date()).getTime() + hours * 3600000);
    expire = "; expires=" + expire.toGMTString();
  }
  document.cookie = name + "=" + escape(value) + expire;
}
// as above this function may cause performance issue
function readCookie(name)
{
  var cookieValue = "" ;
  var search = name + "=";
  if(document.cookie.length > 0)
  { 
    offset = document.cookie.indexOf(search);
    if (offset != -1)
    { 
      offset += search.length;
      end = document.cookie.indexOf(";", offset);
      if (end == -1) end = document.cookie.length;
      cookieValue = unescape(document.cookie.substring(offset, end))
    }
  }
  return cookieValue;
}
// get a element's x
function getX(e) {
	var l = e.offsetLeft;
	while (e = e.offsetParent) {
		l += e.offsetLeft;
	}
	return l;
}

var theCell;
var sensitiveW = 5;
var oldX;
var theTable;
var oldCursor = false;
var str = "test ajax";
var amarListSrc = document.getElementById("amarList").src;
var parameterMark = amarListSrc.split("?");
var parameter = parameterMark[1].split("=");
var curPage = parameter[1];

// mouse out
function mo() {
	col = event.srcElement;
	if (col.tagName == 'IMG')
		return false;
	if (oldCursor) {
		col.style.cursor = oldCursor;
	}
}
// mouse over
function detect() {
	col = event.srcElement;
	if (col.tagName == 'IMG') {
		return false;
	}
	var W = col.clientWidth;
	var X = getX(col);
	var minX = X + W - sensitiveW;
	if (event.x > minX) {
		theCell = col;
		oldX = event.x;
		oldCursor = theCell.currentStyle.cursor;
		theCell.style.cursor = 'col-resize';
		theCell.onmousedown = _md;
	}
}
// mouse down
function _md() {
	document.body['onmousemove'] = _mm;
	document.body['onmouseup'] = _mu;
}
// mouse move
function _mm() {
	if (theCell != null && oldX != null) {
		var len = event.x - oldX;
		oldX = event.x;
		var w = parseInt(theCell.width) + len;
		if (w > 0) {
			theCell.width = w;
			theTable.width = parseInt(theTable.width) + len;
		}
	}
}
// mouse up
function _mu() {
	document.body['onmousemove'] = null;
	document.body['onmouseup'] = null;
	if(theCell != null){
		writeCookie(curPage+theCell.name,theCell.width,100*24);
		writeCookie(curPage,theTable.width,100*24);
	}
	theCell = null;
	oldX = null;
}

theTable = document.getElementById('dataTable');
if(readCookie(curPage)!=""){
	theTable.width = readCookie(curPage);
}else{
	theTable.width = theTable.offsetWidth;
}

for ( var i = 2; i < theTable.rows.length; i++) {
	for ( var j = 1; j < theTable.rows[i].cells.length; j++) {
		var currentCell = theTable.rows[i].cells[j];
		currentCell.childNodes[0].removeAttribute('maxLength');
		currentCell.childNodes[0].style.width = '100%';
	}
}

for ( var k = 1; k < theTable.rows[1].cells.length; k++) {
	var currentCell = theTable.rows[1].cells[k];
	currentCell.name = 'HeaderCell' + k;
	if(readCookie((curPage+currentCell.name))!=""){
		currentCell.width = readCookie(curPage+currentCell.name);
	}else{
		currentCell.width = currentCell.offsetWidth;
	}
	currentCell.onmouseover = detect;
	
	currentCell.ondblclick = currentCell.onclick;
	currentCell.onclick = null;
	currentCell.onmouseout = mo;
}
