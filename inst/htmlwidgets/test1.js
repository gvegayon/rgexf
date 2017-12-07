HTMLWidgets.widget({

  name: "test1",
  
  type: "output",
  
  factory: function(el, width, height) {
  
    // create our sigma object and bind it to the element
    var t1 = new Object(el.id);
    
    return {
      renderValue: function(x) {
          
        // parse gexf data
        var parser = new DOMParser();
        var data = parser.parseFromString(x.data, "application/xml");
        
        writePage(el.id);
      },
      
      resize: function(width, height) {
        
        // forward resize on to sigma renderers
        for (var name in t1.renderers)
          t1.renderers[name].resize(width, height);  
      },
      
      // Make the sigma object available as a property on the widget
      // instance we're returning from factory(). This is generally a
      // good idea for extensibility--it helps users of this widget
      // interact directly with sigma, if needed.
      s: t1
    };
  }
});
