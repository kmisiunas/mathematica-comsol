mathematica-comsol
==================

A link between from Wolfram Mathematica to COMSOL Multiphysics.

At present it imports table data from COMSOL export or parameter files.

## Usage

A [guide](http://mathematica.stackexchange.com/questions/669/how-to-install-packages) on installing packages.

`Import[file_ , \"COMSOL\"]` imports data from the comsol expor txt file.
`Import[file, {\"COMSOL\",\"Info\"}]` gives the additional information stored in the file.
`Import[file, {\"COMSOL\",\"Headers\"}]` gives the hearers of the table.
`Import[file, {\"COMSOL\",\"Parameters\"}]` special import function for importing paraters file.
