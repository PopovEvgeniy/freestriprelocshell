unit freestriprelocshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, LazFileUtils;

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
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

  var Form1: TForm1;

implementation

function get_backend(): string;
begin
 get_backend:=ExtractFilePath(Application.ExeName)+'StripReloc.exe';
end;

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 execute_program:=code;
end;

function parse_arguments(): string;
var target:string;
begin
 target:='';
 if Form1.CheckBox1.Checked=True then target:=target+'/B ';
 if Form1.CheckBox2.Checked=True then target:=target+'/C ';
 if Form1.CheckBox3.Checked=True then target:=target+'/F ';
 parse_arguments:=target;
end;

procedure do_job(const target:string);
var job:string;
begin
 job:=parse_arguments()+convert_file_name(target);
 if execute_program(get_backend(),job)<>0 then
 begin
  ShowMessage('Operation was failed');
 end
 else
 begin
  ShowMessage('Operation was successfully completed');
 end;

end;

procedure window_setup();
begin
 Application.Title:='Free Strip Reloc Shell';
 Form1.Caption:='Free Strip Reloc Shell 1.2.5';
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
 Form1.CheckBox2.Checked:=False;
 Form1.CheckBox3.Checked:=False;
end;

procedure dialog_setup();
begin
 Form1.OpenDialog1.InitialDir:='';
 Form1.OpenDialog1.FileName:='*.exe';
 Form1.OpenDialog1.DefaultExt:='*.exe';
 Form1.OpenDialog1.Filter:='An executable files|*.exe';
end;

procedure language_setup();
begin
 Form1.LabeledEdit1.EditLabel.Caption:='File';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Start';
 Form1.CheckBox1.Caption:='Fix the checksum';
 Form1.CheckBox2.Caption:='Dont create a backup';
 Form1.CheckBox3.Caption:='Force processing';
 Form1.OpenDialog1.Title:='Open an executable file';
end;

procedure setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
 language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button2.Enabled:=Form1.LabeledEdit1.Text<>'';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Form1.OpenDialog1.Execute()=True then Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 do_job(Form1.LabeledEdit1.Text);
end;

{$R *.lfm}

end.
