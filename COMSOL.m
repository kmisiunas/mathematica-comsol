(* ::Package:: *)

(* Package for interaction with COMSOL software and it's outputs
 * Author Karolis Misiunas (k.misiunas@gmail.com)
 *)

BeginPackage["COMSOL`"]

COMSOLImport::usage = 
	"COMSOLImport[file path] imports the .txt file with table results exported by COMSOL.
	 COMSOLImport[file, \"Headers\"] gives the hearers of the table.
	 COMSOLImport[file, \"Info\"] gives the additional information stored in the file."



Begin["`Private`"]

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
]


(* Implementations *)

COMSOLImport[file_String?FileExistsQ] := COMSOLImport[file, "Table"] ;

(* import file, but skip unnecessary information *)
COMSOLImport[file_String?FileExistsQ, "Table"] := Import[file, "Table"][[ CountCommentLines[file] ;; ]] ;

(* import only headers *)
COMSOLImport[file_String?FileExistsQ, "Headers"] := 
	ImportString[ StringDrop[ 
		Import[file, {"Text", "Lines", CountCommentLines[file] -1}],
	1], "Table" , "FieldSeparators"-> "  "];

(* get files information *)
COMSOLImport[file_String?FileExistsQ, "Info"|"Information"] := 
	StringDrop[# , 1] &/@ Import[file, {"Text", "Lines", Range[CountCommentLines[file] -2]}] ;


End[ ]

EndPackage[ ]



