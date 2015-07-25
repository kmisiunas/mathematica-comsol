mathematica-comsol
==================

A link between from Wolfram Mathematica to COMSOL Multiphysics.

At present it imports table data from COMSOL export.

## Usage

A [guide](http://mathematica.stackexchange.com/questions/669/how-to-install-packages) on installing packages.

`COMSOLImport[file path]` imports the .txt file with table results exported by COMSOL.
    
`COMSOLImport[file, "Headers"]` gives the hearers of the table.
    
`COMSOLImport[file, "Info"]` gives the additional information stored in the file.
