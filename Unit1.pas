unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient,
  IdSMTP, IdBaseComponent, IdMessage, StdCtrls, Buttons, WinSkinData,
  GravaIni;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtPara: TEdit;
    edtCC: TEdit;
    edtCCO: TEdit;
    edtAssunto: TEdit;
    cbxPrioridade: TComboBox;
    BitBtn1: TBitBtn;
    mmMensagem: TMemo;
    BitBtn2: TBitBtn;
    cbxConfirmaLeitura: TCheckBox;
    OpenDialog1: TOpenDialog;
    IdMessage: TIdMessage;
    IdSMTP: TIdSMTP;
    SkinData1: TSkinData;
    ListBox1: TListBox;
    GravaIni1: TGravaIni;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
ListBox1.Items.Add(OpenDialog1.FileName);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var xAnexo : Integer;
begin
IdMessage.Recipients.EMailAddresses := edtPara.Text;
IdMessage.CCList.EMailAddresses := edtCC.Text;
IdMessage.BccList.EMailAddresses := edtCCO.Text;

//Trata a Prioridade da mensagem
case cbxPrioridade.ItemIndex of
0 : IdMessage.Priority := mpHigh;
1 : IdMessage.Priority := mpNormal;
2 : IdMessage.Priority := mpLow;
end;

IdMessage.Subject := edtAssunto.Text;
IdMessage.Body := mmMensagem.Lines;

if cbxConfirmaLeitura.Checked then
IdMessage.ReceiptRecipient.Text := IdMessage.From.Text; // Auto Resposta

//Tratando os arquivos anexos
for xAnexo := 0 to ListBox1.Items.Count-1 do
TIdAttachment.create(idmessage.MessageParts, TFileName(ListBox1.Items.Strings[xAnexo]));

IdSMTP.Connect;
try
IdSMTP.Send(IdMessage);
finally
IdSMTP.Disconnect;
end;
Application.MessageBox('Email enviado com sucesso!', 'Confirmação', MB_ICONINFORMATION + MB_OK);

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
GravaIni1.Grava(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
GravaIni1.Le(Self);
end;

end.
