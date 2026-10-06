unit uthr_cupons;

interface

uses
  Classes, SysUtils, IdHTTP, System.JSON, System.IniFiles;

type
  TOnRetorno = procedure(ASender : TObject; AJson : string; var AUltimoCodigo : integer) of object;
  TOnMsgErro = procedure(ASender : TObject; AErro : string) of object;
  TOnValidacao = procedure(ASender : TObject) of object;

  TThrCupons = class(TThread)
  private
    FOnRetorno : TOnRetorno;
    FRetorno : string;

    FOnMsgErro: TOnMsgErro;
    FMsgErro : string;

    FUltimoCodigo : integer;
    FUltConsulta : TDateTime;
    FContaConsulta : integer;
    FHttp : TIdHTTP;
    FOnValidacao: TOnValidacao;

  protected
    procedure Execute; override;

    procedure lerPedidos(AData : boolean = false);

    function  repetirValidacao : boolean;
    function  validarToken : boolean;
    procedure atualizarToken;

    procedure DoRetorno;
    procedure DoMsgErro;
    procedure DoValidacao;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property OnRetorno : TOnRetorno read FOnRetorno write FOnRetorno;
    property OnMsgErro : TOnMsgErro read FOnMsgErro write FOnMsgErro;
    property OnValidacao : TOnValidacao read FOnValidacao write FOnValidacao;
    property UltimoCodigo : integer read FUltimoCodigo write FUltimoCodigo;
  end;

implementation

uses
  uglobal_vars;

const
  cSegConsulta = 30/60/60/24; // 30 segundos;

{ TThrCupons }

procedure TThrCupons.atualizarToken;
var
  vResponse, j, vPath : string;
  vJsonToSend : TStringStream;
  vObj : TJSONObject;
  vConfig : TIniFile;
begin
  vPath := gb_defaultdir + 'config.ini';
  vConfig := TIniFile.Create(vPath);
  try
//      j:= '{ "email": "' + gb_username + '",' +
//            '"senha": "' + gb_password + '" }';

    j:= '{ "email": "teste@gmail.com",' +
          '"senha": "123123" }';

    vJsonToSend := TStringStream.Create(j, TEncoding.UTF8);

    FHttp.Request.ContentType := 'application/json';
    FHttp.Request.CharSet := 'utf-8';
    FHttp.Request.Accept := 'application/json';

    vResponse := FHttp.Post(gb_base_url + '/login/token', vJsonToSend);

    vObj := TJSONObject(TJSONObject.ParseJSONValue(vResponse));
    gb_token := vObj.GetValue('token').Value;

    vConfig.WriteString('conexao', 'token', gb_token);
  finally
    FreeAndNil(vConfig);
  end;
end;

constructor TThrCupons.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;

  FHttp := TIdHTTP.Create(nil);

  FHttp.ConnectTimeout := 30000;
  FHttp.ReadTimeout := 30000;

  FContaConsulta := 0;
  FUltConsulta := 0;
end;

destructor TThrCupons.Destroy;
begin
  FreeAndNil(FHttp);
  inherited;
end;

procedure TThrCupons.DoMsgErro;
begin
  if Assigned(FOnMsgErro) then
    FOnMsgErro(Self, FMsgErro);
end;

procedure TThrCupons.DoRetorno;
begin
  if Assigned(FOnRetorno) then
    FOnRetorno(Self, FRetorno, FUltimoCodigo);
end;

procedure TThrCupons.DoValidacao;
begin
  if Assigned(FOnValidacao) then
    FOnValidacao(Self);
end;

procedure TThrCupons.Execute;
begin
  while not Terminated do begin
    if Now-FUltConsulta >= cSegConsulta then begin
      FUltConsulta := Now;
      try
        if not repetirValidacao then begin
          Synchronize(DoValidacao);
          Exit;
        end;
        lerPedidos(FContaConsulta mod 10 = 0);
        FContaConsulta := FContaConsulta + 1;
      except
        on E: Exception do begin
          FMsgErro := 'Falha de conexão com o servidor.' + #13#10 + E.Message;
          Synchronize(DoMsgErro);
          Exit;
        end;
      end;
    end;
    Sleep(1);
  end;
end;

procedure TThrCupons.lerPedidos(AData : boolean = false);
var
  j : string;
  vJsonToSend: TStringStream;
  vResponseStream: TStringStream;
begin
  FHttp.Request.ContentType := 'application/json; charset=utf-8';
  FHttp.Request.CacheControl := 'no-cache';
  FHttp.Response.CharSet := 'utf-8';
  FHttp.Request.CharSet := 'utf-8';

  if not AData then begin
    j := '{"id_estabelecimento": "'+IntToStr(gb_estabelecimento)+'",'+
        '"ultimo_id": "'+ IntToStr(FUltimoCodigo) +'",'+
        '"token": "'+gb_token+'"}';

    vJsonToSend := TStringStream.Create(j, TEncoding.UTF8);
    vResponseStream := TStringStream.Create('', TEncoding.UTF8);
    try
      try
        FHttp.Post(gb_base_url + '/cupons_apos_id', vJsonToSend, vResponseStream);
        FRetorno := vResponseStream.DataString;
      except
        on E: Exception do begin
          raise Exception.Create('Falha de conexão com o servidor.' + #13#10 + E.Message);
          Exit;
        end;
      end;

    finally
      FreeAndNil(vJsonToSend);
      FreeAndNil(vResponseStream);
    end;
  end
  else begin
    j := '{"id_estabelecimento": "'+IntToStr(gb_estabelecimento)+'",'+
        '"token": "'+gb_token+'"}';

    vJsonToSend := TStringStream.Create(j, TEncoding.UTF8);
    vResponseStream := TStringStream.Create('', TEncoding.UTF8);
    try
      try
        FHttp.Post(gb_base_url + '/cupons', vJsonToSend, vResponseStream);
        FRetorno := vResponseStream.DataString;
      except
        on E: Exception do begin
          raise Exception.Create('Falha de conexão com o servidor.' + #13#10 + E.Message);
          Exit;
        end;
      end;
    finally
      FreeAndNil(vJsonToSend);
      FreeAndNil(vResponseStream);
    end;
  end;

  Synchronize(DoRetorno);
end;

function TThrCupons.repetirValidacao : boolean;
var
  vInt: Integer;
  vValido : boolean;
begin
  vValido := False;
  for vInt := 0 to 4 do begin
    vValido := validarToken;
    if vValido then
      Break;

    atualizarToken;
    Sleep(2000);
  end;

  Result := vValido;
end;

function TThrCupons.validarToken: boolean;
var
  j, vResponse, teste : string;
  vJsonToSend : TStringStream;
  vObj : TJSONObject;
begin
  j := '{"token":"'+gb_token+'"}';
  vJsonToSend := TStringStream.Create(j, TEncoding.UTF8);
  try
    try
      FHttp.Request.ContentType := 'application/json';
      FHttp.Request.CharSet := 'utf-8';
      FHttp.Request.Accept := 'application/json';

      vResponse := FHttp.Post(gb_base_url + '/validate_token', vJsonToSend);
      vObj := TJSONObject(TJSONObject.ParseJSONValue(vResponse));
      Result := StrToBoolDef(vObj.GetValue('valid').Value, False);
    except
//      on E: Exception do begin
//        raise Exception.Create('Falha de conexão com o servidor.' + #13#10 + E.Message);
//        Exit;
//      end;
    end;
  finally
    FreeAndNil(vJsonToSend);
  end;
end;

end.
