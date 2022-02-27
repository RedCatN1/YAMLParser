unit YAMLParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type
CatYAMLObject = record
Caption:String;
Value:String;
Level:Integer;
IsList:Boolean;
ParentName:String;
HasChild:boolean;
IsComment:Boolean;
Comment:string;
IsMarked:Boolean;
IsEmptyLine:Boolean;
end;

Function ParseYAMLDocument(YAMLDocument:String):Integer;
Function EmitYAMLDocument:String;
Function DeleteYAMLParam(ParamFromPosition,ParamToPosition:Integer):integer;
Function InsertYAMLParam(ParamCaption,ParamValue,ParamComment:String;ParamLevel,ParamPosition:Integer):integer;

var
  YAMLConfig:TStringList;
  YAMLObjects:array of CatYAMLObject;
  YAMLObjectsCount:Integer;
implementation

Function ParseYAMLDocument(YAMLDocument:String):Integer;
var
i,u,z:integer;
ProcessingStr,ProcessingSubStr:String;
ParamParsed:Boolean;
ValList:TStringList;
begin
SetLength(YAMLObjects,0);
YAMLObjectsCount:=0;
YAMLConfig:=TStringList.Create;
YAMLConfig.Text:=YAMLDocument;
ValList:=TStringList.Create;
for i:=0 to YAMLConfig.Count-1 do
begin
ProcessingStr:=YAMLConfig[i];
ParamParsed:=False;
if copy(ProcessingStr,0,3)='---' then
begin
ParamParsed:=True;
//ProcessingStr:='';
//StreamStart
end;

if copy(ProcessingStr,0,3)='...' then
begin
ParamParsed:=True;
//ProcessingStr:='';
//StreamEnd
end;

if copy(ProcessingStr,0,1)=' ' then
begin
SetLength(YAMLObjects,Length(YAMLObjects)+1);
Inc(YAMLObjectsCount,1);
u:=0;
while Pos(' ',ProcessingStr)<>0 do
begin
if Copy(ProcessingStr,1,1)=' ' then
Delete(ProcessingStr,1,1)
//Delete(ProcessingStr,1,1)
//ProcessingStr[u]:=Char('')
else
Break;
inc(u,1);
end;
{for u:=0 to Length(ProcessingStr) do
begin
if ProcessingStr[u]=#0 then

//Delete(ProcessingStr,1,1)
//ProcessingStr[u]:=Char('')
else
Break;
end;}
ProcessingSubStr:='';
YAMLObjects[Length(YAMLObjects)-1].Level:=u;
//Delete(ProcessingStr,1,u+1);
{if (Copy(ProcessingStr,u,1)='#') or (Copy(ProcessingStr,u,2)=' #') then
begin
YAMLObjects[Length(YAMLObjects)-1].Caption:=Copy(ProcessingStr,u,Length(ProcessingStr));
YAMLObjects[Length(YAMLObjects)-1].IsComment:=True;
end;}
If Pos('#',ProcessingStr)<>0 then
begin
ProcessingSubStr:=Copy(ProcessingStr,Pos('#',ProcessingStr),Length(ProcessingStr));
Delete(ProcessingStr,Pos('#',ProcessingStr),Length(ProcessingStr));
end;
if (ProcessingStr='') or (ProcessingStr=#0) then
begin
YAMLObjects[Length(YAMLObjects)-1].Caption:=ProcessingSubStr;
YAMLObjects[Length(YAMLObjects)-1].IsComment:=True;
//Break;
end;
if ProcessingSubStr<>'' then
YAMLObjects[Length(YAMLObjects)-1].Comment:=ProcessingSubStr;
YAMLObjects[Length(YAMLObjects)-1].Caption:=Copy(ProcessingStr,0,Pos(':',ProcessingStr)-1);
Delete(ProcessingStr,1,Pos(':',ProcessingStr));

if i+1 < YAMLConfig.Count then
If (Pos('-',YAMLConfig[i+1])<>0) and (Copy(YAMLConfig[i+1],Pos('-',YAMLConfig[i+1])-1,1)=' ') then //(Copy(YAMLConfig[i+1],0,Pos('-',YAMLConfig[i+1])-1)<>'/') then
begin
for z:=i+1 to YAMLConfig.Count-1 do
begin
if Pos('-',YAMLConfig[Z])<>0 then
begin
ValList.Add(Copy(YAMLConfig[Z],Pos('-',YAMLConfig[Z]),Length(YAMLConfig[Z])));
YAMLConfig.Delete(Z);
YAMLConfig.Insert(Z,'');
end
else
begin
YAMLObjects[Length(YAMLObjects)-1].Value:=ValList.DelimitedText;
ValList.Clear;
Break;
end;
end;
YAMLObjects[Length(YAMLObjects)-1].IsList:=True;
//Pos('/-',YAMLConfig[i+1])+1<>Pos('-',YAMLConfig[i+1])
end
else
YAMLObjects[Length(YAMLObjects)-1].Value:=Copy(ProcessingStr,0,Length(ProcessingStr));
ParamParsed:=True;
//ProcessingStr:='';
//ChangeLevel
end;

if Pos('#',ProcessingStr)<>0 then //copy(YAMLConfig[i],0,1)='#' then
begin
SetLength(YAMLObjects,Length(YAMLObjects)+1);
Inc(YAMLObjectsCount,1);
YAMLObjects[Length(YAMLObjects)-1].Comment:=ProcessingStr;
YAMLObjects[Length(YAMLObjects)-1].IsComment:=True;
ParamParsed:=True;
//ProcessingStr:='';
//Comment
end;

if (ParamParsed=False) and (ProcessingStr<>'') then
begin
SetLength(YAMLObjects,Length(YAMLObjects)+1);
Inc(YAMLObjectsCount,1);
u:=0;
while Pos(' ',ProcessingStr)<>0 do
begin
if Copy(ProcessingStr,1,1)=' ' then
Delete(ProcessingStr,1,1)
//Delete(ProcessingStr,1,1)
//ProcessingStr[u]:=Char('')
else
Break;
inc(u,1);
end;
{for u:=0 to Length(ProcessingStr) do
begin
if ProcessingStr[u]=#0 then

//Delete(ProcessingStr,1,1)
//ProcessingStr[u]:=Char('')
else
Break;
end;}
ProcessingSubStr:='';
YAMLObjects[Length(YAMLObjects)-1].Level:=u;
//Delete(ProcessingStr,1,u+1);
{if (Copy(ProcessingStr,u,1)='#') or (Copy(ProcessingStr,u,2)=' #') then
begin
YAMLObjects[Length(YAMLObjects)-1].Caption:=Copy(ProcessingStr,u,Length(ProcessingStr));
YAMLObjects[Length(YAMLObjects)-1].IsComment:=True;
end;}
If Pos('#',ProcessingStr)<>0 then
begin
ProcessingSubStr:=Copy(ProcessingStr,Pos('#',ProcessingStr),Length(ProcessingStr));
Delete(ProcessingStr,Pos('#',ProcessingStr),Length(ProcessingStr));
end;
if (ProcessingStr='') or (ProcessingStr=#0) then
begin
YAMLObjects[Length(YAMLObjects)-1].Caption:=ProcessingSubStr;
YAMLObjects[Length(YAMLObjects)-1].IsComment:=True;
//Break;
end;
if ProcessingSubStr<>'' then
YAMLObjects[Length(YAMLObjects)-1].Comment:=ProcessingSubStr;
YAMLObjects[Length(YAMLObjects)-1].Caption:=Copy(ProcessingStr,0,Pos(':',ProcessingStr)-1);
Delete(ProcessingStr,1,Pos(':',ProcessingStr));
{If Pos('#',ProcessingStr)<>0 then
begin
ProcessingSubStr:=Copy(ProcessingStr,Pos('#',ProcessingStr),Length(ProcessingStr));
Delete(ProcessingStr,Pos('#',ProcessingStr),Length(ProcessingStr));
end;
if ProcessingSubStr<>'' then
YAMLObjects[Length(YAMLObjects)-1].Comment:=ProcessingSubStr; }
if i+1 < YAMLConfig.Count then
If (Pos('-',YAMLConfig[i+1])<>0) and (Copy(YAMLConfig[i+1],Pos('-',YAMLConfig[i+1])-1,1)=' ') then //(Copy(YAMLConfig[i+1],0,Pos('-',YAMLConfig[i+1])-1)<>'/') then
begin
for z:=i+1 to YAMLConfig.Count-1 do
begin
if Pos('-',YAMLConfig[Z])<>0 then
begin
ValList.Add(Copy(YAMLConfig[Z],Pos('-',YAMLConfig[Z]),Length(YAMLConfig[Z])));
YAMLConfig.Delete(Z);
YAMLConfig.Insert(Z,'');
end
else
begin
YAMLObjects[Length(YAMLObjects)-1].Value:=ValList.DelimitedText;
ValList.Clear;
Break;
end;
end;
YAMLObjects[Length(YAMLObjects)-1].IsList:=True;
//Pos('/-',YAMLConfig[i+1])+1<>Pos('-',YAMLConfig[i+1])
end
else
YAMLObjects[Length(YAMLObjects)-1].Value:=Copy(ProcessingStr,0,Length(ProcessingStr));
//ProcessingStr:='';
ParamParsed:=True;
end;

if (ParamParsed=False) and (ProcessingStr='') then
begin
SetLength(YAMLObjects,Length(YAMLObjects)+1);
Inc(YAMLObjectsCount,1);
YAMLObjects[Length(YAMLObjects)-1].IsEmptyLine:=True;
ParamParsed:=True;
end;

end;
YAMLConfig.Free;
ValList.Free;
Result:=0;
end;

Function EmitYAMLDocument:String;
var
i,u,z:integer;
ProcessingStr,ProcessingSpacesStr,CommentStr:String;
ValList:TStringList;
begin
YAMLConfig:=TStringList.Create;
ProcessingStr:='';
YAMLConfig.Add('---');
For i:=0 to YAMLObjectsCount-1 do
begin
ProcessingSpacesStr:='';
if YAMLObjects[i].IsEmptyLine =true then
YAMLConfig.Add('') else
begin
if YAMLObjects[i].IsComment=false then
ProcessingStr:=YAMLObjects[i].Caption
else
ProcessingStr:=YAMLObjects[i].Comment;

if YAMLObjects[i].IsComment=false then
begin
if YAMLObjects[i].Comment<>'' then
if (Copy(YAMLObjects[i].Comment,0,1)='#') or (Copy(YAMLObjects[i].Comment,0,2)=' #') then
CommentStr:=YAMLObjects[i].Comment
else
CommentStr:=' #'+YAMLObjects[i].Comment;
end
else
CommentStr:='';
for z:=0 to YAMLObjects[i].Level-1 do
ProcessingSpacesStr:=' '+ProcessingSpacesStr;
if YAMLObjects[i].IsList = False then
YAMLConfig.add(ProcessingSpacesStr+ProcessingStr+':'+YAMLObjects[i].Value+CommentStr)
else
begin
ValList:=TStringList.Create;
ValList.DelimitedText:=YAMLObjects[i].Value;
YAMLConfig.add(ProcessingSpacesStr+ProcessingStr+': ');
for u:=0 to ValList.Count-1 do
begin
YAMLConfig.add(ProcessingSpacesStr+''+ValList[u])
end;
ValList.Free;
end;
end;

end;
YAMLConfig.Add('...');
Result:=YAMLConfig.Text;
YAMLConfig.Free;
end;

Function InsertYAMLParam(ParamCaption,ParamValue,ParamComment:String;ParamLevel,ParamPosition:Integer):integer;
var
InsObject:CatYAMLObject;
ValList:TStringList;
begin
if ParamCaption<>'' then
begin
InsObject.Caption:=ParamCaption;
ValList:=TStringList.Create;
ValList.DelimitedText:=ParamValue;
if ValList.Count>1 then
InsObject.Value:=ValList.DelimitedText;
ValList.Free;
InsObject.Value:=' '+ParamValue;
InsObject.Comment:=ParamComment;
end else
begin
InsObject.Comment:=ParamComment;
InsObject.IsComment:=True;
end;
InsObject.Level:=ParamLevel;
Insert(InsObject,YAMLObjects,ParamPosition);
Result:=0;
end;

Function DeleteYAMLParam(ParamFromPosition,ParamToPosition:Integer):integer;
begin
Delete(YAMLObjects,ParamFromPosition,ParamToPosition);
Result:=0;
end;

end.

