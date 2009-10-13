// provides pure javascript that is further metafied by eschaton

// Draw a clean circle! Modified copy from http://esa.ilmari.googlepages.com/circle.htm
function drawCircle(center, radius, nodes, liColor, liWidth, liOpa, fillColor, fillOpa){
	//calculating km/degree
	var latConv = center.distanceFrom(new GLatLng(center.lat() +0.1, center.lng()))/100;
	var lngConv = center.distanceFrom(new GLatLng(center.lat(), center.lng()+0.1))/100;

	var points = [];
	var step = parseInt(360/nodes);
	for(var i=0; i<=360; i+=step){
  	var pint = new GLatLng(center.lat() + (radius/latConv * Math.cos(i * Math.PI/180)), center.lng() + 
	                        (radius/lngConv * Math.sin(i * Math.PI/180)));
	  points.push(pint);
	
	  if (track_bounds){
	    track_bounds.extend(pint);
	  }
	}

	var poly = new GPolygon(points, liColor, liWidth, liOpa, fillColor, fillOpa);
	map.addOverlay(poly);
	
	return poly;
}

/* Modified by yawningman to work with eschaton
 * For original see  http://onemarco.com/2007/05/16/custom-tooltips-for-google-maps/ 
 *
 * Original Author =  Marco Alionso Ramirez, marco@onemarco.com
 */
function Tooltip(base_type, base, html, css_class, padding){
  this.base_type_ = base_type;
	this.base_ = base;
	this.html_ = html;
	this.padding_ = padding;

	var div = document.createElement("div");
	div.innerHTML = this.html_;
	div.className = css_class;
	div.style.position = 'absolute';
	div.style.visibility = 'hidden';
	
	this.div_ = div;	
}

Tooltip.prototype = new GOverlay();

Tooltip.prototype.initialize = function(map){
	map.getPane(G_MAP_FLOAT_PANE).appendChild(this.div_);
	this.map_ = map;
}

Tooltip.prototype.updateHtml = function(html){
  this.div_.innerHTML = html;
  this.redraw(true);  
}

Tooltip.prototype.markerPickedUp = function(){
  this.previous_padding = this.padding_
  this.padding_ = 20;
}

Tooltip.prototype.markerDropped = function(){
  this.padding_ = this.previous_padding;
  this.redraw(true);
}

Tooltip.prototype.remove = function(){
	this.div_.parentNode.removeChild(this.div_);
}

Tooltip.prototype.copy = function(){
	return new Tooltip(this.base_,this.html_,this.padding_);
}

Tooltip.prototype.redraw = function(force){
	if (!force) return;
  if(this.base_type_ == 'google::marker'){
    this.redraw_for_marker();
  } else if(this.base_type_ == 'google::polygon'){
    this.redraw_for_polygon();
  } else if(this.base_type_ == 'google::line'){
    this.redraw_for_line();
  } else { // fall through for custom markers
    this.redraw_for_marker();    
  }
}

Tooltip.prototype.redraw_for_marker = function(){
	var markerPos = this.map_.fromLatLngToDivPixel(this.base_.getLatLng());
	var iconAnchor = this.base_.getIcon().iconAnchor;

	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - iconAnchor.y - this.div_.clientHeight - this.padding_;

	this.position_div(xPos, yPos)
}

Tooltip.prototype.redraw_for_polygon = function(){
	var markerPos = this.map_.fromLatLngToDivPixel(this.base_.getBounds().getCenter());
	
	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - this.div_.clientHeight - this.padding_;

	this.position_div(xPos, yPos)
}

Tooltip.prototype.redraw_for_line = function(){
  mid_vertex_index = Math.round(this.base_.getVertexCount() / 2);
	var markerPos = this.map_.fromLatLngToDivPixel(this.base_.getVertex(mid_vertex_index));
	
	var xPos = Math.round(markerPos.x - this.div_.clientWidth / 2);
	var yPos = markerPos.y - this.div_.clientHeight - this.padding_;

	this.position_div(xPos, yPos)
}

Tooltip.prototype.position_div = function(x, y){
	this.div_.style.left = x + 'px';  
	this.div_.style.top = y + 'px';
}

Tooltip.prototype.show = function(){
	this.div_.style.visibility = 'visible';
}

Tooltip.prototype.hide = function(){
	this.div_.style.visibility = 'hidden';
}
/* end tooltip */

/* GooglePane - A simple pane for google maps
   by yawningman */
function GooglePane(options){
  this.default_position = options['position']

  this.panel = document.createElement('div');
  this.panel.id = options['id'];
  this.panel.className = options['cssClass']
  this.panel.innerHTML = options['text']
}

GooglePane.prototype = new GControl;
GooglePane.prototype.initialize = function(map) {
  map.getContainer().appendChild(this.panel);

  return this.panel;
};

GooglePane.prototype.getDefaultPosition = function() {
  return this.default_position;
};

/* end pane */


/* Marker clusterer */
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('7 37(n,v,w){4 o=[];4 m=n;4 t=z;4 q=3;4 r=20;4 x=[36,30,2R,2E,2z];4 s=[];4 u=[];4 p=z;4 i=0;A(i=1;i<=5;++i){s.O({\'18\':"1V://35-31-2Z.2W.2Q/2K/2C/2B/2y/m"+i+".2u",\'S\':x[i-1],\'Z\':x[i-1]})}6(F w==="X"&&w!==z){6(F w.1f==="13"&&w.1f>0){r=w.1f}6(F w.1y==="13"){t=w.1y}6(F w.14==="X"&&w.14!==z&&w.14.9!==0){s=w.14}}7 1t(){6(u.9===0){8}4 a=[];A(i=0;i<u.9;++i){q.Q(u[i],G,z,z,G)}u=a}3.1s=7(){8 s};3.12=7(){A(4 i=0;i<o.9;++i){6(F o[i]!=="1Y"&&o[i]!==z){o[i].12()}}o=[];u=[];17.1W(p)};7 1p(a){8 m.1b().34(a.1o())}7 1S(a){4 c=a.9;4 b=[];A(4 i=c-1;i>=0;--i){q.Q(a[i].C,G,a[i].I,b,G)}1t()}3.Q=7(g,j,b,h,a){6(a!==G){6(!1p(g)){u.O(g);8}}4 f=b;4 d=h;4 e=m.M(g.1o());6(F f!=="2A"){f=T}6(F d!=="X"||d===z){d=o}4 k=d.9;4 c=z;A(4 i=k-1;i>=0;i--){c=d[i];4 l=c.1L();6(l===z){1I}l=m.M(l);6(e.x>=l.x-r&&e.x<=l.x+r&&e.y>=l.y-r&&e.y<=l.y+r){c.Q({\'I\':f,\'C\':g});6(!j){c.L()}8}}c=R 1J(3,n);c.Q({\'I\':f,\'C\':g});6(!j){c.L()}d.O(c);6(d!==o){o.O(c)}};3.1C=7(a){A(4 i=0;i<o.9;++i){6(o[i].1K(a)){o[i].L();8}}};3.L=7(){4 a=3.1j();A(4 i=0;i<a.9;++i){a[i].L(G)}};3.1j=7(){4 b=[];4 a=m.1b();A(4 i=0;i<o.9;i++){6(o[i].1n(a)){b.O(o[i])}}8 b};3.1N=7(){8 t};3.1M=7(){8 m};3.1e=7(){8 r};3.Y=7(){4 a=0;A(4 i=0;i<o.9;++i){a+=o[i].Y()}8 a};3.29=7(){8 o.9};3.1A=7(){4 d=3.1j();4 e=[];4 f=0;A(4 i=0;i<d.9;++i){4 c=d[i];4 b=c.1x();6(b===z){1I}4 a=m.W();6(a!==b){4 h=c.1w();A(4 j=0;j<h.9;++j){4 g={\'I\':T,\'C\':h[j].C};e.O(g)}c.12();f++;A(j=0;j<o.9;++j){6(c===o[j]){o.1v(j,1)}}}}1S(e);3.L()};3.1u=7(a){A(4 i=0;i<a.9;++i){3.Q(a[i],G)}3.L()};6(F v==="X"&&v!==z){3.1u(v)}p=17.27(m,"26",7(){q.1A()})}7 1J(h){4 o=z;4 n=[];4 m=h;4 j=h.1M();4 l=z;4 k=j.W();3.1w=7(){8 n};3.1n=7(c){6(o===z){8 T}6(!c){c=j.1b()}4 g=j.M(c.25());4 a=j.M(c.24());4 b=j.M(o);4 e=G;4 f=h.1e();6(k!==j.W()){4 d=j.W()-k;f=23.22(2,d)*f}6(a.x!==g.x&&(b.x+f<g.x||b.x-f>a.x)){e=T}6(e&&(b.y+f<a.y||b.y-f>g.y)){e=T}8 e};3.1L=7(){8 o};3.Q=7(a){6(o===z){o=a.C.1o()}n.O(a)};3.1C=7(a){A(4 i=0;i<n.9;++i){6(a===n[i].C){6(n[i].I){j.1c(n[i].C)}n.1v(i,1);8 G}}8 T};3.1x=7(){8 k};3.L=7(b){6(!b&&!3.1n()){8}k=j.W();4 i=0;4 a=h.1N();6(a===z){a=j.21().1Z()}6(k>=a||3.Y()===1){A(i=0;i<n.9;++i){6(n[i].I){6(n[i].C.11()){n[i].C.1a()}}N{j.1r(n[i].C);n[i].I=G}}6(l!==z){l.1k()}}N{A(i=0;i<n.9;++i){6(n[i].I&&(!n[i].C.11())){n[i].C.1k()}}6(l===z){l=R E(o,3.Y(),m.1s(),m.1e());j.1r(l)}N{6(l.11()){l.1a()}l.1q(G)}}};3.12=7(){6(l!==z){j.1c(l)}A(4 i=0;i<n.9;++i){6(n[i].I){j.1c(n[i].C)}}n=[]};3.Y=7(){8 n.9}}7 E(a,c,d,b){4 f=0;4 e=c;1X(e!==0){e=V(e/10,10);f++}6(d.9<f){f=d.9}3.16=d[f-1].18;3.H=d[f-1].S;3.P=d[f-1].Z;3.19=d[f-1].1U;3.D=d[f-1].32;3.15=a;3.1T=f;3.1R=d;3.1m=c;3.1l=b}E.J=R 2Y();E.J.2X=7(i){3.1P=i;4 j=1O.2V("2U");4 h=3.15;4 f=i.M(h);f.x-=V(3.P/2,10);f.y-=V(3.H/2,10);4 g="";6(1O.2T){g=\'2S:2P:2O.2M.2L(2J=2I,2H="\'+3.16+\'");\'}N{g="2G:18("+3.16+");"}6(F 3.D==="X"){6(F 3.D[0]==="13"&&3.D[0]>0&&3.D[0]<3.H){g+=\'S:\'+(3.H-3.D[0])+\'B;1H-1g:\'+3.D[0]+\'B;\'}N{g+=\'S:\'+3.H+\'B;1G-S:\'+3.H+\'B;\'}6(F 3.D[1]==="13"&&3.D[1]>0&&3.D[1]<3.P){g+=\'Z:\'+(3.P-3.D[1])+\'B;1H-1i:\'+3.D[1]+\'B;\'}N{g+=\'Z:\'+3.P+\'B;1F-1E:1D;\'}}N{g+=\'S:\'+3.H+\'B;1G-S:\'+3.H+\'B;\';g+=\'Z:\'+3.P+\'B;1F-1E:1D;\'}4 k=3.19?3.19:\'2x\';j.U.2w=g+\'2v:2t;1g:\'+f.y+"B;1i:"+f.x+"B;2D:"+k+";2s:2F;1h-2r:2q;"+\'1h-2p:2o,2n-2m;1h-2N:2l\';j.2k=3.1m;i.2j(2i).2h(j);4 e=3.1l;17.2g(j,"2f",7(){4 a=i.M(h);4 d=R 1Q(a.x-e,a.y+e);d=i.1B(d);4 b=R 1Q(a.x+e,a.y-e);b=i.1B(b);4 c=i.2e(R 2d(d,b),i.2c());i.2b(h,c)});3.K=j};E.J.1K=7(){3.K.2a.33(3.K)};E.J.28=7(){8 R E(3.15,3.1T,3.1m,3.1R,3.1l)};E.J.1q=7(a){6(!a){8}4 b=3.1P.M(3.15);b.x-=V(3.P/2,10);b.y-=V(3.H/2,10);3.K.U.1g=b.y+"B";3.K.U.1i=b.x+"B"};E.J.1k=7(){3.K.U.1d="1z"};E.J.1a=7(){3.K.U.1d=""};E.J.11=7(){8 3.K.U.1d==="1z"};',62,194,'|||this|var||if|function|return|length||||||||||||||||||||||||||null|for|px|marker|anchor_|ClusterMarker_|typeof|true|height_|isAdded|prototype|div_|redraw_|fromLatLngToDivPixel|else|push|width_|addMarker|new|height|false|style|parseInt|getZoom|object|getTotalMarkers|width||isHidden|clearMarkers|number|styles|latlng_|url_|GEvent|url|textColor_|show|getBounds|removeOverlay|display|getGridSize_|gridSize|top|font|left|getClustersInViewport_|hide|padding_|text_|isInBounds|getLatLng|isMarkerInViewport_|redraw|addOverlay|getStyles_|addLeftMarkers_|addMarkers|splice|getMarkers|getCurrentZoom|maxZoom|none|resetViewport|fromDivPixelToLatLng|removeMarker|center|align|text|line|padding|continue|Cluster|remove|getCenter|getMap_|getMaxZoom_|document|map_|GPoint|styles_|reAddMarkers_|index_|opt_textColor|http|removeListener|while|undefined|getMaximumResolution|60|getCurrentMapType|pow|Math|getNorthEast|getSouthWest|moveend|addListener|copy|getTotalClusters|parentNode|setCenter|getSize|GLatLngBounds|getBoundsZoomLevel|click|addDomListener|appendChild|G_MAP_MAP_PANE|getPane|innerHTML|bold|serif|sans|Arial|family|11px|size|position|pointer|png|cursor|cssText|black|images|90|boolean|markerclusterer|trunk|color|78|absolute|background|src|scale|sizingMethod|svn|AlphaImageLoader|Microsoft|weight|DXImageTransform|progid|com|66|filter|all|div|createElement|googlecode|initialize|GOverlay|library|56|utility|opt_anchor|removeChild|containsLatLng|gmaps|53|MarkerClusterer'.split('|'),0,{}))