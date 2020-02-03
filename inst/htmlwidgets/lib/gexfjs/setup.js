if (typeof jQuery == 'undefined') {
                document.write(unescape("%3Cscript type='text/javascript' src='js/jquery-2.0.2.min.js'%3E%3C/script%3E"));
}

function setGexfDoc(id, width, height) {

  // Creating zonecentre -------------------------------------------------------
  var zonecentre   = document.createElement("div");
  zonecentre.id    = "zonecentre";
  
  zonecentre.setAttribute(
      "style",
      "top: 45px; margin:auto; overflow: hidden;" +
      "width:" + width + "px; height:" + height +"px;"  
    );
  
    // Creating canvans
    var canvas    = document.createElement("canvas");
    canvas.id     = "carte";
    canvas.width  = width;
    canvas.height = height;
    
      // Creating links
      var ctlzoom = document.createElement("ul");
      ctlzoom.id = "ctlzoom";
      
        // -------
        var li1 = document.createElement("li");
        
          var a1 = document.createElement("a");
          a1.href  = "#";
          a1.id    = "zoomPlusButton";
          a1.title = "S'approcher";
          
        li1.appendChild(a1);
        
        // -------
        var li2 = document.createElement("li");
        li2.id = "zoomSliderzone";
        
          var zoomSlider = document.createElement("div");
          zoomSlider.id = "zoomSlider";
          
        li2.appendChild(zoomSlider);
        
        // -------
        var li3 = document.createElement("li");
        
          var a2 = document.createElement("a");
          a2.href  = "#";
          a2.id    = "zoomMinusButton";
          a2.title = "S'éloigner";
          
        li3.appendChild(a2);
        
        
        // -------
        var li4 = document.createElement("li");
        
          var a4 = document.createElement("a");
          a4.href  = "#";
          a4.id    = "lensButton";
          
        li4.appendChild(a4);
        
        // -------
        var li5 = document.createElement("li");
        
          var a5 = document.createElement("a");
          a5.href  = "#";
          a5.id    = "edgesButton";
          
        li5.appendChild(a5);
        
      ctlzoom.appendChild(li1);
      ctlzoom.appendChild(li2);
      ctlzoom.appendChild(li3);
      ctlzoom.appendChild(li4);
      ctlzoom.appendChild(li5);
      
    
  zonecentre.appendChild(canvas);
  zonecentre.appendChild(ctlzoom);
  
  // Creating overview ---------------------------------------------------------
  var overviewzone   = document.createElement("div");
  overviewzone.id    = "overviewzone";
  overviewzone.setAttribute("class", "gradient");
  
    var overview    = document.createElement("canvas");
    overview.id     = "overview";
    overview.width  = 0;
    overview.height = 0;
    
  overviewzone.appendChild(overview);
  
  // Creating leftcolumn -------------------------------------------------------
  var leftcolumn = document.createElement("div");
  leftcolumn.id  = "leftcolumn";
  
    var unfold = document.createElement("div");
    unfold.id  = "unfold";
    
      var aUnfold   = document.createElement("a");
      aUnfold.href  = "#";
      aUnfold.id    = "aUnfold";
      aUnfold.setAttribute("class", "rightarrow");
      
    unfold.appendChild(aUnfold);
  
  leftcolumn.appendChild(unfold);
  
  // Creating the title --------------------------------------------------------
  var titlebar = document.createElement("div");
  titlebar.id  = "titlebar";
  
    var maintitle = document.createElement("div");
    maintitle.id  = "maintitle";
    
    // -----------
    var reacherche = document.createElement("form");
    reacherche.id  = "reacherche";
    
      var searchinput = document.createElement("input");
      
      searchinput.id = "searchinput";
      searchinput.setAttribute("class", "grey");
      searchinput.setAttribute("autocomplete", "off");
      
      var searchsubmit = document.createElement("input");
      
      searchsubmit.id = "searchsubmit";
      searchsubmit.setAttribute("type", "submit");
        
    reacherche.appendChild(searchinput);
    reacherche.appendChild(searchsubmit);
    
    // ----
    var autocomplete = document.createElement("ul");
    autocomplete.id = "autocomplete";
    
  titlebar.appendChild(maintitle);
  titlebar.appendChild(reacherche);
  titlebar.appendChild(autocomplete);
  
  
  // Putting all together ------------------------------------------------------
  
  
  document.getElementById(id).appendChild(zonecentre);
  document.getElementById(id).appendChild(overviewzone);
  document.getElementById(id).appendChild(leftcolumn);
  document.getElementById(id).appendChild(titlebar);
  
  // Updating the CSS
  
  
  // var st = "overflow:hidden;";
  // document.getElementById(id).setAttribute("style", st);

}
