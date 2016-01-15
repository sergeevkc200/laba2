unit Unit3;

interface

uses
  Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF}, Unit1;

type
  MyThread2 = class(TThread)
  private
   index : integer;
  protected
    procedure SetName;
    procedure UbdateLabel;
    procedure Execute; override;
  end;

implementation

uses SysUtils;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure MyThread2.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

{ MyThread2 }

procedure MyThread2.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'tnew2';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

procedure MyThread2.Execute;
begin
  index:=1;
  while index>0 do
    begin
    sleep(50);
    Synchronize(UbdateLabel);
        Inc(index);
        if index>100000 then
      index:=0;
    if terminated then exit;
  end;
end;

procedure MyThread2.UbdateLabel;
begin
Form1.Label2.Caption:=IntToStr(index);
end;


end.
 