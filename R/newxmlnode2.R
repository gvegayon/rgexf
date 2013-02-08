# New function
newXMLNode2 <- function(tmp, parent) {
  doc = xmlParse(tmp, asText = TRUE)
  
  invisible(.Call("R_insertXMLNode", xmlChildren(xmlRoot(doc)), 
                  parent, -1L, FALSE, PACKAGE = "XML"))
}

# New way
mynode <- "<Placemark><Point><coordinates>%.3f,%.3f,0</coordinates></Point></Placemark>"
f <- newXMLNode("Folder")
system.time(for (i in 1:5000) newXMLNode2(mynode, f))
#user  system elapsed 
#1.89    0.02    1.90 

# Old way
f2 <- newXMLNode("Folder")
system.time(for (i in 1:5000) newXMLNode("Point", parent=f2, newXMLNode("coordinates", "%.3f,%.3f,0")))
#  user  system elapsed 
#179.26    0.49  179.91 

# Are the same?
saveXML(f) == saveXML(f2)
# TRUE