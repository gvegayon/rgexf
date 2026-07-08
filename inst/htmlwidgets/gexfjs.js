HTMLWidgets.widget({

  name: "gexfjs",

  type: "output",

  factory: function(el, width, height) {

    return {
      renderValue: function(x) {

        var w = (width  > 0 ? width  : el.offsetWidth)  || 800;
        var h = (height > 0 ? height : el.offsetHeight) || 500;

        // JSON.stringify safely escapes GEXF content for embedding as a JS literal
        var gexfDataJS = JSON.stringify(x.data);

        // Build a fully self-contained HTML document for the iframe.
        // All scripts/styles are inlined so the iframe's CSS cannot leak
        // into the parent document, and global IDs (#carte, #overview, etc.)
        // are scoped to the iframe's own document.
        var srcdoc = [
          '<!DOCTYPE html><html>',
          '<head>',
          '<style>', x.css1, '</style>',
          '<style>', x.css2, '</style>',
          '</head>',
          '<body>',
          '<div id="gexf-container"></div>',
          // 1. Load jQuery and plugins
          '<script>', x.jquery, '<\/script>',
          '<script>', x.jqmw,   '<\/script>',
          '<script>', x.jqui,   '<\/script>',
          // 2. Define setGexfDoc
          '<script>', x.setup,  '<\/script>',
          // 3. Build the DOM structure (creates #carte, #overview, etc.)
          '<script>setGexfDoc("gexf-container", ', w, ', ', h, ');<\/script>',
          // 4. Load GexfJS library (registers $(document).ready auto-init
          //    which checks for #carte — created above — so it will fire)
          '<script>', x.gexfjs, '<\/script>',
          // 5. Apply default params (zoomLevel, showEdges, ...) — without
          //    these, globalScale = SQRT2^undefined = NaN and the main
          //    canvas renders nothing
          '<script>', x.config, '<\/script>',
          // 6. Set graphFile param before ready fires
          '<script>',
          '  var blob = new Blob([', gexfDataJS, '], {type: "application/xml"});',
          '  var blobUrl = URL.createObjectURL(blob);',
          '  GexfJS.setParams({graphFile: blobUrl});',
          '  $(document).one("ajaxComplete", function() { URL.revokeObjectURL(blobUrl); });',
          '<\/script>',
          '</body></html>'
        ].join('');

        var iframe = document.createElement('iframe');
        iframe.style.width  = '100%';
        iframe.style.height = '100%';
        iframe.style.border = 'none';
        iframe.srcdoc = srcdoc;

        el.innerHTML = '';
        el.appendChild(iframe);
      },

      resize: function(newWidth, newHeight) {
        var iframe = el.querySelector('iframe');
        if (iframe) {
          iframe.style.width  = newWidth  + 'px';
          iframe.style.height = newHeight + 'px';
        }
      }
    };
  }
});
