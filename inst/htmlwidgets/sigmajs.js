/* sigmajs htmlwidget binding for rgexf
 * Renders GEXF graphs using sigma.js v3 + graphology.
 *
 * Globals expected (loaded via sigmajs.yaml dependencies):
 *   window.graphology  — graphology UMD bundle (exposes .Graph, .MultiGraph, …)
 *   window.Sigma       — sigma UMD bundle (exposes .rendering.createNodeBorderProgram)
 *
 * Widget x payload:
 *   x.data        {string}  GEXF XML
 *   x.borderColor {string}  CSS color for the node border ring (default "#ffffff")
 *   x.borderSize  {number}  Border ring size as a fraction of node radius (0–1, default 0.15)
 */

HTMLWidgets.widget({

  name: "sigmajs",

  type: "output",

  factory: function(el, width, height) {

    var sigmaInstance = null;

    return {

      renderValue: function(x) {

        // Tear down any previous sigma instance
        if (sigmaInstance) {
          sigmaInstance.kill();
          sigmaInstance = null;
        }
        el.innerHTML = "";

        // Sigma reads the container's CSS dimensions, so ensure they are set.
        el.style.width  = ((width  > 0 ? width  : el.offsetWidth)  || 800) + "px";
        el.style.height = ((height > 0 ? height : el.offsetHeight) || 500) + "px";

        var borderColor = (x.borderColor && x.borderColor !== "transparent") ? x.borderColor : null;
        var borderSize  = (typeof x.borderSize === "number") ? Math.max(0, Math.min(1, x.borderSize)) : 0.15;

        // ── Parse GEXF ──────────────────────────────────────────────────────
        var parser = new DOMParser();
        var xmlDoc;
        try {
          xmlDoc = parser.parseFromString(x.data, "application/xml");
        } catch (e) {
          el.textContent = "sigmajs: failed to parse GEXF XML – " + e.message;
          return;
        }

        // DOMParser does not throw on invalid XML; check for a <parsererror> element.
        var parseError = xmlDoc.querySelector("parsererror");
        if (parseError) {
          el.textContent = "sigmajs: failed to parse GEXF XML – " + parseError.textContent;
          return;
        }

        var graphEl = xmlDoc.querySelector("graph");
        if (!graphEl) {
          el.textContent = "sigmajs: no <graph> element found in GEXF.";
          return;
        }

        var defaultEdgeType = (graphEl.getAttribute("defaultedgetype") || "undirected").toLowerCase();
        var isDirected      = defaultEdgeType === "directed";

        // ── Build graphology Graph ───────────────────────────────────────────
        var Graph = window.graphology.MultiGraph;
        var graph = new Graph({ type: isDirected ? "directed" : "undirected" });

        // Namespace URIs used by GEXF viz attributes.
        var VIZ_NS = [
          "http://www.gexf.net/1.3/viz",
          "http://gexf.net/1.3/viz",
          "http://www.gexf.net/1.2draft/viz",
          "http://gexf.net/1.2/viz"
        ];

        /** Return the first child element matching localName in any viz namespace. */
        function getVizEl(parentEl, localName) {
          for (var i = 0; i < VIZ_NS.length; i++) {
            var els = parentEl.getElementsByTagNameNS(VIZ_NS[i], localName);
            if (els.length > 0) return els[0];
          }
          return null;
        }

        /** Convert GEXF viz:color r/g/b integers to a CSS hex string. */
        function vizColor(colorEl, fallback) {
          if (!colorEl) return fallback;
          var r = parseInt(colorEl.getAttribute("r") || 0, 10);
          var g = parseInt(colorEl.getAttribute("g") || 0, 10);
          var b = parseInt(colorEl.getAttribute("b") || 0, 10);
          return "#" +
            ("0" + r.toString(16)).slice(-2) +
            ("0" + g.toString(16)).slice(-2) +
            ("0" + b.toString(16)).slice(-2);
        }

        // ── Nodes ────────────────────────────────────────────────────────────
        var nodeEls = xmlDoc.querySelectorAll("nodes > node");

        nodeEls.forEach(function(nodeEl) {
          var id    = nodeEl.getAttribute("id");
          var label = nodeEl.getAttribute("label") || id;

          var posEl   = getVizEl(nodeEl, "position");
          var sizeEl  = getVizEl(nodeEl, "size");
          var colorEl = getVizEl(nodeEl, "color");

          var nodeX, nodeY;
          if (posEl) {
            nodeX = parseFloat(posEl.getAttribute("x") || 0);
            nodeY = parseFloat(posEl.getAttribute("y") || 0);
          } else {
            nodeX = Math.random() * 200 - 100;
            nodeY = Math.random() * 200 - 100;
          }

          var size  = sizeEl  ? parseFloat(sizeEl.getAttribute("value")  || 5) : 5;
          var color = vizColor(colorEl, "#6c8ebf");

          // Clamp node size to a visible but not overwhelming range
          size = Math.max(2, Math.min(size, 30));

          var nodeAttrs = {
            label: label,
            x:     nodeX,
            y:     nodeY,
            size:  size,
            color: color,
            type:  "circle"
          };
          if (borderColor) nodeAttrs.borderColor = borderColor;
          graph.addNode(id, nodeAttrs);
        });

        // ── Edges ────────────────────────────────────────────────────────────
        var edgeEls = xmlDoc.querySelectorAll("edges > edge");

        edgeEls.forEach(function(edgeEl) {
          var id      = edgeEl.getAttribute("id");
          var source  = edgeEl.getAttribute("source");
          var target  = edgeEl.getAttribute("target");
          var colorEl = getVizEl(edgeEl, "color");
          var color   = vizColor(colorEl, "#aaa");
          var weight  = parseFloat(edgeEl.getAttribute("weight") || 1);

          try {
            if (id && id.length > 0) {
              graph.addEdgeWithKey(id, source, target, { color: color, size: Math.max(0.5, weight) });
            } else {
              graph.addEdge(source, target, { color: color, size: Math.max(0.5, weight) });
            }
          } catch (e) {
            // Skip edges whose key or source/target already exists
          }
        });

        // ── Renderer options ─────────────────────────────────────────────────
        // When borderColor is set, use NodeBorderProgram (outer ring + fill).
        // Otherwise fall back to sigma's default NodeCircleProgram (plain fill).
        var sigmaOpts = {
          renderEdgeLabels:               false,
          defaultEdgeColor:               "#aaa",
          defaultNodeColor:               "#6c8ebf",
          labelDensity:                   0.07,
          labelGridCellSize:              60,
          labelRenderedSizeThreshold:     6
        };

        if (borderColor) {
          var NodeBorderProgram = Sigma.rendering.createNodeBorderProgram({
            borders: [
              { size: { value: borderSize }, color: { attribute: "borderColor" } },
              { size: { fill: true },        color: { attribute: "color" } }
            ]
          });
          sigmaOpts.nodeProgramClasses = { circle: NodeBorderProgram };
        }

        // ── Render with sigma ────────────────────────────────────────────────
        sigmaInstance = new Sigma(graph, el, sigmaOpts);
      },

      resize: function(newWidth, newHeight) {
        el.style.width  = newWidth  + "px";
        el.style.height = newHeight + "px";
        if (sigmaInstance) sigmaInstance.refresh();
      }

    };
  }
});
