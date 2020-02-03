function writePage(id) {

  var node = document.createElement("canvas");
  
  node.id = "carte";
  node.width = 0;
  node.height = 0;
  
  var hdr  = document.createElement("h1");
  hdr.innerHTML = "It Works!";
  node.appendChild(hdr);

  document.getElementById(id).appendChild(node);

}
