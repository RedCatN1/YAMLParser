unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ComCtrls, YAMLParser;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.Button1Click(Sender: TObject);
var
  tmpstrlst:TStringList;
begin
tmpstrlst:=TStringList.Create;
tmpstrlst.LoadFromFile(ExtractFilePath(ParamStr(0))+'/TestConf.yaml');
ParseYAMLDocument(tmpstrlst.Text);
tmpstrlst.Free;
InsertYAMLParam('AddedParam','tst_add_param','is comment',4,8);
Memo1.Lines.Text:=EmitYAMLDocument;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Form1.Close;
end;

end.

