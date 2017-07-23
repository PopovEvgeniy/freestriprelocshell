unit freestriprelocshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, LazUTF8;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    LabeledEdit1: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

   var Form1: TForm1;
   function get_path(): string;
   function check_input(input:string):Boolean;
   function convert_file_name(source:string): string;
   function execute_program(executable:string;argument:string):Integer;
   procedure window_setup();
   procedure interface_setup();
   procedure dialog_setup();
   procedure find_stripreloc();
   function parse_arguments(): string;
   procedure common_setup();
   procedure language_setup();
   procedure setup();

implementation

 function get_path(): string;
begin
get_path:=ExtractFilePath(Application.ExeName);
end;

function check_input(input:string):Boolean;
var target:Boolean;
begin
target:=True;
if input='' then
begin
target:=False;
end;
check_input:=target;
end;

function convert_file_name(source:string): string;
var target:string;
begin
target:=source;
if Pos(' ',source)>0 then
begin
target:='"'+source+'"';
end;
convert_file_name:=target;
end;

function execute_program(executable:string;argument:string):Integer;
var code:Integer;
begin
try
code:=ExecuteProcess(UTF8ToWinCP(executable),UTF8ToWinCP(argument),[]);
except
On EOSError do code:=-1;
end;
execute_program:=code;
end;

procedure window_setup();
begin
 Application.Title:='Free Strip Reloc Shell';
 Form1.Caption:='Free Strip Reloc Shell 1.0.1';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure interface_setup();
begin
Form1.LabeledEdit1.Text:='';
Form1.LabeledEdit1.LabelPosition:=lpLeft;
Form1.LabeledEdit1.Enabled:=False;
Form1.Button1.ShowHint:=False;
Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
Form1.Button2.Enabled:=False;
Form1.CheckBox1.Checked:=True;
end;

procedure dialog_setup();
begin
Form1.OpenDialog1.FileName:='*.exe';
Form1.OpenDialog1.DefaultExt:='*.exe';
Form1.OpenDialog1.Filter:='Executable files|*.exe';
end;

procedure find_stripreloc();
var check:string;
begin
check:=get_path()+'StripReloc.exe';
if FileExists(check)=False then
begin
ShowMessage('Put StripReloc.exe to program directory');
Application.Terminate();
end;

end;

function parse_arguments(): string;
var target:string;
begin
target:='';
if Form1.CheckBox1.Checked=True then
begin
target:=target+'/B ';
end;
if Form1.CheckBox2.Checked=True then
begin
target:=target+'/C ';
end;
if Form1.CheckBox3.Checked=True then
begin
target:=target+'/F ';
end;
parse_arguments:=target;
end;

procedure common_setup();
begin
window_setup();
dialog_setup();
interface_setup();
end;

procedure language_setup();
begin
Form1.LabeledEdit1.EditLabel.Caption:='File';
Form1.Button1.Caption:='Open';
Form1.Button2.Caption:='Start';
Form1.CheckBox1.Caption:='Calculate checksum';
Form1.CheckBox2.Caption:='Dont create backup';
Form1.CheckBox3.Caption:='Force processing';
Form1.OpenDialog1.Title:='Open existing file';
end;

procedure setup();
begin
common_setup();
find_stripreloc();
language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
Form1.Button2.Enabled:=check_input(Form1.LabeledEdit1.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if Form1.OpenDialog1.Execute()=True then Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
var host,job:string;
begin
host:=get_path()+'StripReloc.exe';
job:=parse_arguments()+convert_file_name(Form1.LabeledEdit1.Text);
execute_program(host,job);
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
if Form1.CheckBox3.Checked=True then
begin
Form1.CheckBox2.Checked:=False;
Form1.CheckBox2.Enabled:=False;
end
else
begin
Form1.CheckBox2.Enabled:=True;
end;

end;

{$R *.lfm}

end.
