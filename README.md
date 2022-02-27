# YAMLParser
A simple YAML parser, without using any third party libraries.
This parser can parse the structure of a yaml file, understands comments, processes both Latin and Cyrillic.
Aliases and escape characters have not yet been implemented.
The parser works on the principle that any line from a yaml file is an object, even if it is a comment or an empty line. For comfortable processing, a structure has been created where data about the line is stored.

Structure(record):

type
CatYAMLObject = record
Caption:String; 
Parameter name
Value:String; 
Parameter value
Level:Integer; 
Level in yaml structure
IsList:Boolean; 
If the parameter is a list, the value is "true"
ParentName:String; 
Currently not in use
HasChild:boolean; 
Currently not in use
IsComment:Boolean; 
If the entire line is a comment, set to true
comment:string; 
the line comment is stored here, if the entire line is a comment, then this value is stored here
Ismarked:Boolean; 
Currently not in use
IsEmptyLine:Boolean; If the entire string is empty, set to true
end;


Function ParseYAMLDocument(YAMLDocument:String):Integer; 
Takes the value of the yaml document in the string, always returns 0
Function EmitYAMLDocument:String;
Returns the assembled yaml document in a string
Function DeleteYAMLParam(ParamFromPosition,ParamToPosition:Integer):integer; 
Deletes parameters, From position - start To position - end, always returns 0
Function InsertYAMLParam(ParamCaption,ParamValue,ParamComment:String;ParamLevel,ParamPosition:Integer):integer; 
Inserts a parameter, always returns 0
