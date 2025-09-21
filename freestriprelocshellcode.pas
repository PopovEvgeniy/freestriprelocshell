unit freestriprelocshellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    StartButton: TButton;
    FixCheckBox: TCheckBox;
    DontBackupCheckBox: TCheckBox;
    ForceCheckBox: TCheckBox;
    FileField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    procedure OpenButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileFieldChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

  var MainWindow: TMainWindow;

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
 if MainWindow.FixCheckBox.Checked=True then target:=target+'/B ';
 if MainWindow.DontBackupCheckBox.Checked=True then target:=target+'/C ';
 if MainWindow.ForceCheckBox.Checked=True then target:=target+'/F ';
 parse_arguments:=target;
end;

procedure do_job(const target:string);
var job:string;
begin
 job:=parse_arguments()+convert_file_name(target);
 if execute_program(get_backend(),job)<>0 then
 begin
  ShowMessage('The operation failed');
 end
 else
 begin
  ShowMessage('The operation was successfully completed');
 end;

end;

procedure window_setup();
begin
 Application.Title:='Free Strip Reloc Shell';
 MainWindow.Caption:='Free Strip Reloc Shell 1.2.8';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure interface_setup();
begin
 MainWindow.FileField.Text:='';
 MainWindow.FileField.LabelPosition:=lpLeft;
 MainWindow.FileField.Enabled:=False;
 MainWindow.OpenButton.ShowHint:=False;
 MainWindow.StartButton.ShowHint:=MainWindow.OpenButton.ShowHint;
 MainWindow.StartButton.Enabled:=False;
 MainWindow.FixCheckBox.Checked:=True;
 MainWindow.DontBackupCheckBox.Checked:=False;
 MainWindow.ForceCheckBox.Checked:=False;
end;

procedure dialog_setup();
begin
 MainWindow.OpenDialog.InitialDir:='';
 MainWindow.OpenDialog.FileName:='*.exe';
 MainWindow.OpenDialog.DefaultExt:='*.exe';
 MainWindow.OpenDialog.Filter:='An executable files|*.exe';
end;

procedure language_setup();
begin
 MainWindow.FileField.EditLabel.Caption:='File';
 MainWindow.OpenButton.Caption:='Open';
 MainWindow.StartButton.Caption:='Start';
 MainWindow.FixCheckBox.Caption:='Fix the checksum';
 MainWindow.DontBackupCheckBox.Caption:='Dont create a backup';
 MainWindow.ForceCheckBox.Caption:='Force processing';
 MainWindow.OpenDialog.Title:='Open an executable file';
end;

procedure setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
 language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 MainWindow.StartButton.Enabled:=MainWindow.FileField.Text<>'';
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then MainWindow.FileField.Text:=MainWindow.OpenDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 do_job(MainWindow.FileField.Text);
end;

{$R *.lfm}

end.
