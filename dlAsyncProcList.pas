unit dlAsyncProcList;

interface

uses SysUtils, Classes, Messages, Windows;

type
  IAsyncResult = interface
    ['{F9491DFA-3EBD-4395-BA87-D78BC15AC136}']
    function GetError: String;
  end;

  TAsyncResult = class(TInterfacedObject, IAsyncResult)
    strict private
      FError: String;
    public
      constructor Create(AError: String = '');
    public
      function GetError: String;
  end;

  IAsyncObject = interface
    ['{047D5C4D-E4F4-4024-B1DC-7659625096A5}']
    procedure Run;
  end;

  TAsyncProcRef         = reference to procedure;
  TAsyncProcRefCallBack = reference to procedure(Sender: IAsyncObject);

  TAsyncObject = class(TInterfacedObject, IAsyncObject)
    strict private
      FProcRef        : TAsyncProcRef;
      FProcRefCallBack: TAsyncProcRefCallBack;

      FMessage: Cardinal;
      FHandle : THandle;
    public
      constructor Create(AProcRef: TAsyncProcRef; AHandle: THandle = INVALID_HANDLE_VALUE;
        AMessage: Cardinal = 0); overload;
      constructor Create(AProcRef: TAsyncProcRef; ACallBack: TAsyncProcRefCallBack = nil); overload;
    public
      procedure Run;
  end;

  TAsyncListOnError = procedure(Sender: IAsyncResult) of Object;
  TAsyncProcList = class(TThread)
    strict private
      FList: TInterfaceList;
    public
      constructor Create;
      destructor Destroy; override;
    public
      procedure Execute; override;
    public
      OnError: TAsyncListOnError;
    public
      procedure Add(AAsyncObject: IAsyncObject);
  end;

var AsyncProcList: TAsyncProcList;
implementation

{ TAsyncProcList }

procedure TAsyncProcList.Add(AAsyncObject: IAsyncObject);
begin
  FList.Add(AAsyncObject);
end;

constructor TAsyncProcList.Create;
begin
  inherited Create(False);
  FreeOnTerminate:= False;
  FList:= TInterfaceList.Create;
end;

destructor TAsyncProcList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TAsyncProcList.Execute;
var Item: IAsyncObject;
begin
  while not Terminated do
  begin
    for var i := FList.Count - 1 downto 0 do
      if Supports(FList[i], IAsyncObject, Item) then
      begin
        try
          Item.Run;
        except
          on e: exception do
            OnError(TAsyncResult.Create(Format('TAsyncProcList.Execute: %s', [e.Message])));
        end;

        FList.Remove(Item);
      end;

    sleep(1);
  end;

end;

{ TAsyncObject }

constructor TAsyncObject.Create(AProcRef: TAsyncProcRef;
  AHandle: THandle = INVALID_HANDLE_VALUE; AMessage: Cardinal = 0);
begin
  FProcRef:= AProcRef;
  FProcRefCallBack:= nil;
  FMessage:= AMessage;
  FHandle:= AHandle;
end;

constructor TAsyncObject.Create(AProcRef: TAsyncProcRef;
  ACallBack: TAsyncProcRefCallBack);
begin
  FProcRef:= AProcRef;
  FProcRefCallBack:= ACallBack;
  FMessage:= 0;
  FHandle := INVALID_HANDLE_VALUE;
end;

procedure TAsyncObject.Run;
begin
  if not Assigned(FProcRef) then
    raise Exception.Create('Error call procedure');

  FProcRef;

  if (FHandle <> INVALID_HANDLE_VALUE) and (FMessage > 0) then
    PostMessage(FHandle, FMessage, 0, 0);

  if Assigned(FProcRefCallBack) then
    FProcRefCallBack(Self);
end;

{ TAsyncResult }

constructor TAsyncResult.Create(AError: String);
begin
  FError:= AError;
end;

function TAsyncResult.GetError: String;
begin
  Result:= FError;
end;

initialization
  AsyncProcList:= TAsyncProcList.Create;

finalization
  if Assigned(AsyncProcList) then
  begin
    AsyncProcList.Terminate;
    AsyncProcList.WaitFor;
    FreeAndNil(AsyncProcList);
  end;

end.
