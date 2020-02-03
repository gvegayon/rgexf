HTMLWidgets.widget({

  name: "gexfjs",
  
  type: "output",
  
  factory: function(el, width, height) {
  
    // create our sigma object and bind it to the element
    // The GexFJS object is created before hand.
    // var gf = new GexfJS(el.id);
    
    return {
      renderValue: function(x) {
          
        // parse gexf data
        var parser = new DOMParser();
        var data = parser.parseFromString(x.data, "application/xml");
        
        // Setting parameters
        GexfJS.setParams({graphFile: x.path});
        
        setGexfDoc(el.id, width, height);
      },
      
      resize: function(width, height) {
        
        // forward resize on to sigma renderers
        // for (var name in gf.renderers)
           // gf.renderers[name].resize(width, height);  
      },
      
      // Make the sigma object available as a property on the widget
      // instance we're returning from factory(). This is generally a
      // good idea for extensibility--it helps users of this widget
      // interact directly with sigma, if needed.
      s: GexfJS
    };
  }
});
