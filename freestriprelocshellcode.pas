unit freestriprelocshellcode;

{
 This software was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls;

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
    function parse_arguments(): string;
    procedure do_job(const target:string);
    procedure window_setup();
    procedure interface_setup();
    procedure dialog_setup();
    procedure language_setup();
    procedure setup();
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

function TMainWindow.parse_arguments(): string;
var target:string;
begin
 target:='';
 if Self.FixCheckBox.Checked=True then target:=target+'/B ';
 if Self.DontBackupCheckBox.Checked=True then target:=target+'/C ';
 if Self.ForceCheckBox.Checked=True then target:=target+'/F ';
 parse_arguments:=target;
end;

procedure TMainWindow.do_job(const target:string);
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

procedure TMainWindow.window_setup();
begin
 Application.Title:='Free Strip Reloc Shell';
 Self.Caption:='Free Strip Reloc Shell 1.2.9';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.interface_setup();
begin
 Self.FileField.Text:='';
 Self.FileField.LabelPosition:=lpLeft;
 Self.FileField.Enabled:=False;
 Self.OpenButton.ShowHint:=False;
 Self.StartButton.ShowHint:=False;
 Self.StartButton.Enabled:=False;
 Self.FixCheckBox.Checked:=True;
 Self.DontBackupCheckBox.Checked:=False;
 Self.ForceCheckBox.Checked:=False;
end;

procedure TMainWindow.dialog_setup();
begin
 Self.OpenDialog.InitialDir:='';
 Self.OpenDialog.FileName:='*.exe';
 Self.OpenDialog.DefaultExt:='*.exe';
 Self.OpenDialog.Filter:='An executable files|*.exe';
end;

procedure TMainWindow.language_setup();
begin
 Self.FileField.EditLabel.Caption:='File';
 Self.OpenButton.Caption:='Open';
 Self.StartButton.Caption:='Start';
 Self.FixCheckBox.Caption:='Fix the checksum';
 Self.DontBackupCheckBox.Caption:='Dont create a backup';
 Self.ForceCheckBox.Caption:='Force processing';
 Self.OpenDialog.Title:='Open an executable file';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.dialog_setup();
 Self.interface_setup();
 Self.language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 Self.StartButton.Enabled:=Self.FileField.Text<>'';
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then Self.FileField.Text:=Self.OpenDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 do_job(Self.FileField.Text);
end;

{$R *.lfm}

end.
