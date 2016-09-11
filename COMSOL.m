(* ::Package:: *)

(* Package for interaction with COMSOL software and it's outputs
 * Author Karolis Misiunas (k.misiunas@gmail.com)
 *
 * ## Versions
 *
 * 2016-06-19  --  Moved to Mathematica's Import[] extension
 * 2016-09-11  --  support for reading parameter file and removed old ways
 *)

BeginPackage["COMSOL`"]

COMSOL::usage =
	"Import[file_ , \"COMSOL\"] imports data from the comsol expor txt file.
	 Import[file, {\"COMSOL\",\"Info\"}] gives the additional information stored in the file.
	 Import[file, {\"COMSOL\",\"Headers\"}] gives the hearers of the table.
	 Import[file, {\"COMSOL\",\"Parameters\"}] special import function for importing paraters file.";

importParametersFile::usage = ""

Begin["`Private`"]

(* Extending Import[] *)


ImportExport`RegisterImport[
  "COMSOL",
  {
    "Headers" :> importComsolHeaders ,
    "Info" :> importComsolInfo,
		"Parameters" :> importParametersFile,
    importComsolTable (*default importer *)
  }
];

importComsolTable[ filename_String, options___ ] :=
    Import[filename, "Table"][[ CountCommentLines[filename] ;; ]]

importComsolHeaders[ filename_String, options___ ] := {
  "Headers" ->
      ImportString[ StringDrop[
        Import[filename, {"Text", "Lines", CountCommentLines[filename] - 1}],
        1], "Table" , "FieldSeparators" -> "  "]
};

importComsolInfo[ filename_String, options___ ] := {
  "Info" -> StringDrop[# , 1] &/@ Import[file, {"Text", "Lines", Range[CountCommentLines[filename] -2]}]
};


importParametersFile[ filename_String, options___ ] := {
  "Parameters" ->
     <| (#1 -> interpretQuantity[#2]) & @@@ Import[filename, "Table"][[ All, {1, 2}]] |>
};



(*Secret helper methods*)

(* count of comment lines in exported file *)
CountCommentLines[file_String] := Module[{st, line, i},
	st = OpenRead[file];
	line = Read[st, String];
	i = 1;
	While[ StringMatchQ[line, StartOfString ~~ "%" ~~ __] && line =!= EndOfFile, 
		line = Read[st, String];
		i = i + 1;
	];
	Close[st];
	i
];

numericValueQ[ st_] := NumberQ@ToExpression[st] || NumberQ@extractValue[st];

getIfNotEmpty[list_] := If[Length[list] == 1 , First[list], list];

extractUnits[st_] := getIfNotEmpty@StringCases[st, "[" ~~ __ ~~ "]"];

extractValue[st_] := getIfNotEmpty@ToExpression@StringCases[st, num__ ~~ "[" ~~ __ ~~ "]" -> num];

interpretQuantity[st_] := Which[
  Not@numericValueQ[ st], Return[st],
  NumberQ@ToExpression[st], ToExpression[st],
  True, Quantity[ extractValue[st], extractUnits[st]]
];



End[ ]

EndPackage[ ]
