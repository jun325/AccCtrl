unit AccCTRLs;

interface

uses
  Windows, Messages, Graphics, Dialogs, Types, UITypes, SysUtils, Classes, Controls, ActiveX, StdCtrls, ComObj, Variants,
  oleacc, comctrls, commctrl, ActnList, Menus, Forms, CheckLst, Buttons, ExtCtrls, mask, multimon, math;

type
  
  TColorButton = class(TCustomPanel)
  private
    FColorChange: Boolean;
    FPicture: TPicture;
    FInColor: TColor;
    FOutColor: TColor;
    FStretch: Boolean;
    FOnMouseEnter: TMouseMoveEvent;
    FOnMouseExit: TMouseMoveEvent;
    FMouseDownNow: Boolean;
    FMouseLeave: Integer;
    FCaptionLeft: Integer;
    FPictureLeft: Integer;
    FPictureTop: Integer;
    FCaptionTop: Integer;
    procedure SetCaptionLeft(const Value: Integer);
    procedure SetCaptionTop(const Value: Integer);
    procedure SetPictureLeft(const Value: Integer);
    procedure SetPictureTop(const Value: Integer);
    procedure SetPicture(Value: TPicture);
    procedure SetOutColor(Value: TColor);
    procedure SetStretch(Value: Boolean);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetColorChange(const Value: Boolean);
    procedure PictureChanged(Sender: TObject);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure MouseEnter(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseLeave(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure Paint; override;
    function MouseIn: Boolean;
    procedure SetBevel(Down: Boolean);
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    property Align;
    property Caption;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Hint;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
    property ColorChange: Boolean read FColorChange write SetColorChange default True;
    property Picture: TPicture read FPicture write SetPicture;
    property InColor: TColor read FInColor write FInColor default cl3DLight;
    property Color: TColor read FOutColor write SetOutColor default clBtnFace;
    property PictureLeft: Integer read FPictureLeft write SetPictureLeft default -1;
    property PictureTop: Integer read FPictureTop write SetPictureTop default -1;
    property CaptionLeft: Integer read FCaptionLeft write SetCaptionLeft default -1;
    property CaptionTop: Integer read FCaptionTop write SetCaptionTop default -1;
    property Stretch: Boolean read FStretch write SetStretch;
    property OnMouseEnter: TMouseMoveEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TMouseMoveEvent read FonMouseExit write FOnMouseExit;
  end;

  TAccClrBtn = class(TColorButton, IDispatch, IAccessible)

  private
    FPickerColor:TColor;

    FName, FDesc, FAcDesc, FHelpPath, FShortCut: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    procedure SetPickerColor(Value:TColor);
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    procedure WndProc(var Msg: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;

  published
    property PickerColor:TColor read FPickerColor write SetPickerColor;
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property AccShortCut: string read FShortCut write FShortCut;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TTransCheckBox = class(TCheckBox, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure SetButtonStyle;
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    DrawH, DrawW: integer;
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TAccRadioButton = class(TRadioButton, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TAccButton = class(TButton, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath, FShortCut: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property AccShortCut: string read FShortCut write FShortCut;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;


  TAccBitBtn = class(TBitBtn, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath, FShortCut: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property AccShortCut: string read FShortCut write FShortCut;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TAccGroupBox = class(TGroupBox, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlFChild, FCtrlLChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected éŒ¾ }

    procedure WndProc(var Msg: TMessage); override;
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;

    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TAccToolbar = class(TToolbar, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlFChild, FCtrlLChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected éŒ¾ }

    procedure WndProc(var Msg: TMessage); override;
  public
    { Public éŒ¾ }
    iFocus: integer;
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;

    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;


  TAccMemo = class(TMemo, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlFChild, FCtrlLChild: IAccessible;

    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;

  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;

    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TAccEdit = class(TEdit, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlFChild, FCtrlLChild: IAccessible;

    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;

  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;

    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TAccMaskEdit = class(TMaskEdit, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlFChild, FCtrlLChild: IAccessible;

    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;

  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;

    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;


  TAccLabeledEdit = class(TLabeledEdit, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlFChild, FCtrlLChild: IAccessible;

    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;

  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;

    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;


   TAccComboBox = class(TComboBox, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;


  TAccTrackBar = class(TTrackBar, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;
  TAccTreeView = class(TTreeView, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    AccNode: TTreeNode;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
    function   GetAccNode(varChild: integer): boolean;
  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;
  TAccCheckList = class(TCheckListBox, IDispatch, IAccessible)
  private
    { Private éŒ¾ }
    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;

  protected
    { Protected éŒ¾ }
    procedure WndProc(var Msg: TMessage); override;

  public
    { Public éŒ¾ }
    constructor Create(AOwner: TComponent);override;
  published
    { Published éŒ¾ }
    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TColorDrop = class(TCustomComboBox, IDispatch, IAccessible)
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    { Private}
    FDropDnColor, FActiveColor:TColor;
    FOnChanged:TNotifyEvent;
    FOnEnter:TNotifyEvent;
    FItems:TStringlist;
    FFont: TFont;
    FOtherBtn: String;

    FName, FDesc, FAcDesc, FHelpPath: string;
    FCtrlNext, FCtrlPrev,FCtrlRight, FCtrlLeft, FCtrlUp, FCtrlDown, FCtrlLChild, FCtrlFChild: IAccessible;
    procedure SetActiveColor(Value:TColor);
    procedure JCDropDown(Sender:TObject);

    function Get_accParent(out ppdispParent: IDispatch): HResult; stdcall;
    function Get_accChildCount(out pcountChildren: Integer): HResult; stdcall;
    function Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult; stdcall;
    function Get_accName(varChild: OleVariant; out pszName: widestring): HResult; stdcall;
    function Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult; stdcall;
    function Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult; stdcall;
    function Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult; stdcall;
    function Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult; stdcall;
    function Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult; stdcall;
    function Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                              out pidTopic: Integer): HResult; stdcall;
    function Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult; stdcall;
    function Get_accFocus(out pvarChild: OleVariant): HResult; stdcall;
    function Get_accSelection(out pvarChildren: OleVariant): HResult; stdcall;
    function Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult; stdcall;
    function accSelect(flagsSelect: Integer; varChild: OleVariant): HResult; stdcall;
    function accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer;
                         out pcyHeight: Integer; varChild: OleVariant): HResult; stdcall;
    function accNavigate(navDir: Integer; varStart: OleVariant; out pvarEndUpAt: OleVariant): HResult; stdcall;
    function accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult; stdcall;
    function accDoDefaultAction(varChild: OleVariant): HResult; stdcall;
    function Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
    function Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult; stdcall;
    {IDispatch}
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount: Integer; LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index: Integer; LocaleID: Integer;
      out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult: Pointer; ExcepInfo: Pointer;
      ArgErr: Pointer): HRESULT; stdcall;
  protected
    { Protected}
    procedure CreateWnd; override;
    procedure DrawItem(Index:Integer;Rect:TRect;State:TOwnerDrawState); override;
    procedure SetFont(Value: TFont);
    procedure SetOtherBtnCaption(Value: String);
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public}

  published
    { Published}
    procedure Drop;
    property ActiveColor:TColor read FActiveColor write SetActiveColor;
    property OnChanged:TNotifyEvent read FOnChanged write FOnChanged;
    property OnEnter:TNotifyEvent read FOnEnter write FOnEnter;
    property DropDnColor:TColor read FDropDnColor write FDropDnColor;
    property Enabled;
    property Hint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Constraints;
    property Anchors;
    property ParentShowHint;
    property ParentFont;
    property Itemheight;
    property PopupMenu;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property Color;
    property Font: TFont read FFont write SetFont;
    property Other: String read FOtherBtn write SetOtherBtnCaption;

    property AccName: string read FName write FName;
    property AccDesc: string read FDesc write FDesc;
    property AccActionDesc: string read FAcDesc write FAcDesc;
    property AccHelpPath: string read FHelpPath write FHelpPath;
    property CtrlNext: IAccessible read FCtrlNext write FCtrlNext;
    property CtrlPrev: IAccessible read FCtrlPrev write FCtrlPrev;
    property CtrlRight: IAccessible read FCtrlRight write FCtrlRight;
    property CtrlLeft: IAccessible read FCtrlLeft write FCtrlLeft;
    property CtrlUp: IAccessible read FCtrlUp write FCtrlUp;
    property CtrlDown: IAccessible read FCtrlDown write FCtrlDown;
    property CtrlFirstChild: IAccessible read FCtrlFChild write FCtrlFChild;
    property CtrlLastChicl: IAccessible read FCtrlLChild write FCtrlLChild;
  end;

  TJColorPickFrm2 = class(TForm)
    ColorDialog1: TColorDialog;
    Shape1: TShape;
    BtnOther: TButton;

    procedure BtnOtherClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private}
    FPickColor:TColor;
    FDlgOpen: Boolean;
    AssignedCombo : TColorDrop;
    arBtns:  array[0..55] of TAccClrBtn;
    arBtns2:  array[0..9] of TAccClrBtn;
    procedure BtnClick(Sender:TObject);
    procedure PBtnClick(Sender:TObject);
    function RGBtoHex(Color: TColor; ResIsRGB: Boolean = True): String;
    procedure SetPickColor(Value:TColor);
    function GetConvColor(Color: TColor; BlendPer: Single; BlendColor: Boolean): TColor;
  public
    { Public}
    property PickColor:TColor read FPickColor write SetPickColor;
  end;


  procedure Register;
var
  JColorPickFrm2: TJColorPickFrm2;
const
  BtnIMGW=14;
  BtnW=20;

   Colors:array[0..55] of TColor
     =($000000,$808080,$000040,$004040,$004000,$404000,$400000,$400040,
       $202020,$909090,$000080,$008080,$008000,$808000,$800000,$800080,
       $303030,$A0A0A0,$0000C0,$00C0C0,$00C000,$C0C000,$C00000,$C000C0,
       $404040,$B0B0B0,$0000FF,$00FFFF,$00FF00,$FFFF00,$FF0000,$FF00FF,
       $505050,$C0C0C0,$4040FF,$40FFFF,$40FF40,$FFFF40,$FF4040,$FF40FF,
       $606060,$D0D0D0,$8080FF,$80FFFF,$80FF80,$FFFF80,$FF8080,$FF80FF,
       $707070,$FFFFFF,$C0C0FF,$C0FFFF,$C0FFC0,$FFFFC0,$FFC0C0,$FFC0FF);
implementation
{$R *.dfm}

procedure Register;
begin
  RegisterComponents('Samples', [TAccTreeView]);
  RegisterComponents('Samples', [TAccCheckList]);
  RegisterComponents('Samples', [TTransCheckBox]);
  RegisterComponents('Samples', [TACCMemo]);
  RegisterComponents('Samples', [TACCGroupBox]);
  RegisterComponents('Samples', [TACCToolbar]);
  RegisterComponents('Samples', [TAccButton]);
  RegisterComponents('Samples', [TAccComboBox]);
  RegisterComponents('Samples', [TAccBitBtn]);
  RegisterComponents('Samples', [TAccRadioButton]);
  RegisterComponents('Samples', [TAccEdit]);
  RegisterComponents('Samples', [TAccMaskEdit]);
  RegisterComponents('Samples', [TAccLabeledEdit]);
  RegisterComponents('Samples', [TAccTrackBar]);
  RegisterComponents('Samples', [TAccClrBtn]);
  RegisterComponents('Samples', [TColorDrop]);
end;



function ErrDLG(MSG: string; iIndex: integer): HRESULT;
begin
    Result := E_FAIL;
    {$IFDEF DEBUG}
    MessageDlg(MSG + ' - ' + InttoStr(iIndex + 30), mtError, [mbOK], 0);
    {$ENDIF}
end;

function GetShiftState: TShiftState;
var
  KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  Result := [];
  if KeyState[VK_MENU]    shr 7 = 1 then Include(Result, ssAlt);
  if KeyState[VK_SHIFT]   shr 7 = 1 then Include(Result, ssShift);
  if KeyState[VK_CONTROL] shr 7 = 1 then Include(Result, ssCtrl);
  if KeyState[VK_LBUTTON] shr 7 = 1 then Include(Result, ssLeft);
  if KeyState[VK_RBUTTON] shr 7 = 1 then Include(Result, ssRight);
  if KeyState[VK_MBUTTON] shr 7 = 1 then Include(Result, ssMiddle);
end;

constructor TColorButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle-[csSetCaption];
  ColorChange := True;
  Ctl3D := false;
  BevelInner:=bvNone;
  BevelOuter:=bvNone;
  FInColor := cl3DLight;
  FOutColor := clBtnFace;
  Height := 36;
  Width := 36;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPictureLeft := -1;
  FPictureTop := -1;
  FCaptionLeft := -1;
  FCaptionTop := -1;
end;

procedure TColorButton.PictureChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TColorButton.Loaded;
begin
  inherited Loaded;
  inherited Color := FOutColor;
end;

destructor TColorButton.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;


procedure TColorButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Enabled then
    if Key = VK_SPACE then begin
      if not FMouseDownNow then
      begin
        FMouseDownNow := True;
        SetBevel(True);
        Invalidate;
      end;
    end else
    if Key = VK_RETURN then begin
      SetBevel(True);
      FMouseDownNow := True;
      Invalidate;
      try
        Click;
      finally
        SetBevel(False);
        FMouseDownNow := False;
        Invalidate;
      end;
    end else
      if FMouseDownNow then begin
        FMouseDownNow := False;
        SetBevel(False);
        Invalidate;
      end;
end;

procedure TColorButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if FMouseDownNow and (Key = VK_SPACE) then begin
    FMouseDownNow := False;
    SetBevel(False);
    Invalidate;
    try
      Click;
    finally
      Invalidate;
    end;
  end;
end;

procedure TColorButton.Click;
begin
  FMouseDownNow := False;
  SetBevel(False);
  Invalidate;
  inherited;
end;

procedure TColorButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TColorButton.CMMouseEnter(var Message: TMessage);
var
  Shift: TShiftState;
  Pos: TPoint;
begin
  inherited;
  Shift := GetShiftState;
  GetCursorPos(Pos);
  Pos := ScreenToClient(Pos);
  MouseEnter(Shift, Pos.X, Pos.Y);
end;

procedure TColorButton.MouseEnter(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self, Shift, X, Y);

  if GetKeyState(VK_LBUTTON)<-126 then BevelOuter:=bvLowered
                                    else BevelOuter:=bvRaised;
  FMouseLeave := 0;
  Refresh;
  if ColorChange then
    inherited Color := FInColor;
end;

procedure TColorButton.CMMouseLeave(var Message: TMessage);
var
  Shift: TShiftState;
  Pos: TPoint;
begin
  inherited;
  Shift := GetShiftState;
  GetCursorPos(Pos);
  Pos := ScreenToClient(Pos);
  MouseLeave(Shift, Pos.X, Pos.Y);
end;

procedure TColorButton.MouseLeave(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(FOnMouseExit) then FOnMouseExit(Self, Shift, X, Y);

  if GetKeyState(VK_LBUTTON)<-126 then BevelOuter:=bvRaised
                                      else BevelOuter:=bvNone;
  FMouseLeave := -Ord(FMouseDownNow);
  Refresh;
  if ColorChange then
    inherited Color := FOutColor;
end;

procedure TColorButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X,Y: Integer);
begin
  if Button=mbLeft then begin
    SetBevel(True);
    FMouseDownNow := True;
    Repaint;
  end;
  inherited MouseDown(Button,Shift,X,Y);
end;

procedure TColorButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X,Y: Integer);
begin
  if Button=mbLeft then begin
    SetBevel(False);
    FMouseDownNow := False;
    FMouseLeave := 0;
    Refresh;
  end;
  inherited MouseUp(Button,Shift,X,Y);
end;

procedure TColorButton.Paint;
var
  Bmp: TBitmap;
  BevelFrame: Integer;
  rc: TRect;
  X, Y: Integer;
  Center: TPoint;
  Temp: TBitmap;

  procedure DrawCanvas(Canvas: TCanvas);
  var
    R: TRect;
    SvFontColor: TColor;
  begin
    rc := ClientRect;
    case BevelOuter of
    bvLowered: Frame3D(Canvas, rc, clBtnShadow, clBtnHighlight, 1);
    bvRaised:  Frame3D(Canvas, rc, clBtnHighlight, clBtnShadow, 1);
    end;
    case BevelInner of
    bvLowered: Frame3D(Canvas, rc, clBtnShadow, clBtnHighlight, 1);
    bvRaised:  Frame3D(Canvas, rc, clBtnHighlight, clBtnShadow, 1);
    end;

    if FMouseDownNow then
    begin
      if FMouseLeave <> 0 then
        Canvas.Brush.Color := FOutColor
      else
        Canvas.Brush.Color := FInColor;
    end else begin
      Canvas.Brush.Color := (inherited Color);
    end;
    Canvas.Brush.Style := bsSolid;


    BevelFrame := Ord(BevelOuter<>bvNone) + Ord(BevelInner<>bvNone);
    Canvas.FillRect(rc);
    if FPicture.Graphic <> nil then
    begin
      if not FPicture.Graphic.Transparent then
        FPicture.Graphic.Transparent := True;

      if Stretch then begin
        Bmp:= TBitmap.Create;
        try
          BevelFrame := 2;
          Bmp.Height := FPicture.Height;
          Bmp.Width := FPicture.Width;
          Bmp.Canvas.Brush.Color := Canvas.Brush.Color;
          Bmp.Canvas.FillRect(ClientRect);
          SendMessage(Handle, WM_ERASEBKGND, Bmp.Canvas.Handle, 0);
          Bmp.Canvas.Draw(0, 0, FPicture.Graphic);
          Canvas.StretchDraw(
            Classes.Rect(
              BevelFrame + Ord(FMouseDownNow) + FMouseLeave,
              BevelFrame + Ord(FMouseDownNow) + FMouseLeave,
              Width - BevelFrame * 2,
              Height - BevelFrame * 2
            ),
            Bmp
          );
        finally
          Bmp.Free;
        end;
      end else begin
        if FPictureLeft = -1 then
          X := Round((Width - FPicture.Width)/2)
        else
          X := FPictureLeft;
        if FPictureTop = -1 then
          Y := Round((Height - FPicture.Height)/2)
        else
          Y := FPictureTop;
        Canvas.Draw(
          X + Ord(FMouseDownNow) + FMouseLeave,
          Y + Ord(FMouseDownNow) + FMouseLeave,
          FPicture.Graphic
        );
      end;
    end;
    if Caption <> '' then
    begin
      Canvas.Font.Assign(Font);
      Brush.Style := bsClear;

      SetRectEmpty(R);
      DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_CALCRECT or DT_LEFT);
      Center.x := (Width - R.Right) div 2;
      Center.y := (Height - R.Bottom) div 2;

      if FCaptionLeft = -1 then
        X := Center.x
      else
        X := FCaptionLeft;
      if FCaptionTop = -1 then
        Y := Center.y
      else
        Y := FCaptionTop;
      rc.Left := X + Ord(FMouseDownNow) + FMouseLeave;
      rc.Top := Y + Ord(FMouseDownNow) + FMouseLeave;
      rc.Right := Width;
      rc.Bottom := Height;
      Canvas.Brush.Style := bsClear;
      DrawText(Canvas.Handle, PChar(Caption), -1, rc, DT_LEFT);
    end;

    rc := ClientRect;
    InflateRect(rc, -(Ord(FMouseDownNow) + FMouseLeave), -(Ord(FMouseDownNow) + FMouseLeave));

    if (Self=Screen.ActiveControl) then
    begin
      InflateRect(rc, -2, -2);
      SvFontColor := Canvas.Font.Color;
      try

        Canvas.Brush.Style := bsClear;
        Canvas.Font.Color := clWhite;
        Canvas.TextOut(-1000, -1000, ' ');
        Canvas.DrawFocusRect(rc);
      finally
        Canvas.Font.Color := SvFontColor;
      end;
    end;
  end;
begin
  if DoubleBuffered then
  begin
    DrawCanvas(Canvas);
  end else begin
    Temp := TBitmap.Create;
    try
      Temp.Width := Width;
      Temp.Height := Height;
      DrawCanvas(Temp.Canvas);
      Canvas.Draw(0, 0, Temp);
    finally
      Temp.Free;
    end;
  end;
end;

procedure TColorButton.SetBevel(Down: Boolean);
begin
  if Down then begin
    BevelOuter := bvLowered;
  end
  else
  begin
    if BevelOuter=bvRaised then BevelOuter := bvNone
    else BevelOuter := bvRaised;
  end;
end;

function TColorButton.MouseIn: Boolean;
var
  Pos: TPoint;
begin
  GetCursorPos(Pos);
  Pos := ScreenToClient(Pos);
  Result := PtInRect(ClientRect, Pos);
end;

procedure TColorButton.SetPicture(Value: TPicture);
begin
  if Value <> FPicture then
  begin
    FPicture.Assign(Value);

    if FPicture.Graphic <> nil then
    begin
      FPicture.Graphic.Transparent := True;
    end;

    Invalidate;
  end;
end;

procedure TColorButton.SetOutColor(Value: TColor);
begin
  if Value <> FOutColor then begin
    FOutColor := Value;
    inherited Color := FOutColor;
    Invalidate;
  end;
end;

procedure TColorButton.SetStretch(Value: Boolean);
begin
  if Value <> FStretch then begin
    FStretch := Value;
    Invalidate;
  end;
end;



procedure TColorButton.SetCaptionLeft(const Value: Integer);
begin
  if FCaptionLeft <> Value then
  begin
    FCaptionLeft := Value;
    Invalidate;
  end;
end;

procedure TColorButton.SetCaptionTop(const Value: Integer);
begin
  if FCaptionTop <> Value then
  begin
    FCaptionTop := Value;
    Invalidate;
  end;
end;

procedure TColorButton.SetPictureLeft(const Value: Integer);
begin
  if FPictureLeft <> Value then
  begin
    FPictureLeft := Value;
    Invalidate;
  end;
end;

procedure TColorButton.SetPictureTop(const Value: Integer);
begin
  if FPictureTop <> Value then
  begin
    FPictureTop := Value;
    Invalidate;
  end;
end;

procedure TColorButton.DoEnter;
begin
  Invalidate;
  inherited;
end;

procedure TColorButton.DoExit;
begin
  Invalidate;
  inherited;
end;


procedure TColorButton.SetColorChange(const Value: Boolean);
begin
  if FColorChange <> Value then
  begin
    FColorChange := Value;
    Invalidate;
  end;
end;

constructor TAccClrBtn.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Width:=BtnIMGW;
    Height:=BtnIMGW;
    TabStop := True;
    Picture.Bitmap.TransparentMode:=tmFixed;
    Picture.Bitmap.TransparentColor:=Color;
    Parent  := AOwner as TWinControl;
    FName := Caption;
end;

destructor TAccClrBtn.Destroy;
begin
    inherited Destroy;
end;

procedure TAccClrBtn.SetPickerColor(Value:TColor);
begin
    FPickerColor:=Value;
    Color := FPickerColor;
    InColor := FPickerColor;
end;

function TAccClrBtn.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Click;
    end
    else
        Result := S_OK;
end;

function TAccClrBtn.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccClrBtn.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccClrBtn.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];

                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
    end;
end;

function TAccClrBtn.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;


function TAccClrBtn.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccClrBtn.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccClrBtn.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccClrBtn.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccClrBtn.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;
    Result := S_OK;
end;

function TAccClrBtn.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccClrBtn.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccClrBtn.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_DISPATCH;
    pvarChild := self as iDispatch;
    result := S_OK;
end;

function TAccClrBtn.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccClrBtn.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccClrBtn.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := FShortCut;
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccClrBtn.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        pszName := '';
        Result := S_OK;
    end;
end;

function TAccClrBtn.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccClrBtn.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_PUSHBUTTON;
    end
    else
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_WINDOW;
   result := S_OK;
end;

function TAccClrBtn.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        self.SetFocus;
    end;
    Result := S_OK;
end;


function TAccClrBtn.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;

        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccClrBtn.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := ColorToString(FPickerColor);
        result := S_OK;
    end
    else
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
end;

function TAccClrBtn.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccClrBtn.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
        Result := S_OK;
end;

function TAccClrBtn.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
        Result := S_OK;
end;




procedure TAccClrBtn.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;




function TTransCheckBox.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Checked := not Checked;
    end
    else
        Result := S_OK;
end;

function TTransCheckBox.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TTransCheckBox.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TTransCheckBox.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TTransCheckBox.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

constructor TTransCheckBox.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TTransCheckBox.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TTransCheckBox.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TTransCheckBox.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TTransCheckBox.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    iDis: IDISPATCH;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        try
        iDis := Controls[varChild - 1] as IDISPATCH;
        except
            iDis := nil;
        end;
        if Assigned(iDis) then
        begin
            ppdispChild := iDis;
        end
        else
            ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TTransCheckBox.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := ControlCount;
    Result := S_OK;
end;

function TTransCheckBox.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TTransCheckBox.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TTransCheckBox.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TTransCheckBox.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TTransCheckBox.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TTransCheckBox.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TTransCheckBox.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        pszName := '';
        Result := S_OK;
    end;
end;

function TTransCheckBox.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TTransCheckBox.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_CHECKBUTTON;
    end
    else
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_WINDOW;
   result := S_OK;
end;

function TTransCheckBox.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
        end;
    end;
    Result := S_OK;
end;


function TTransCheckBox.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
        if Checked then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_CHECKED;

        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TTransCheckBox.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := self.Caption;
        result := S_OK;
    end
    else
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
end;

function TTransCheckBox.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TTransCheckBox.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
        Result := S_OK;
end;

function TTransCheckBox.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
        Result := S_OK;
end;

procedure TTransCheckBox.SetButtonStyle;
begin

end;

procedure TTransCheckBox.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;


destructor TAccMemo.Destroy;
begin

    inherited destroy;
end;


procedure TAccMemo.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;

constructor TAccMemo.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Parent  := AOwner as TWinControl;

    FName := Name;

end;

function TAccMemo.accDoDefaultAction(varChild: OleVariant): HResult;
begin
  Result := S_OK;//FAcc.accDoDefaultAction(varChild);
end;

function TAccMemo.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := CHILDID_SELF;
    Result := S_OK;
end;

function TAccMemo.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
        Result := S_FALSE;
end;

function TAccMemo.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccMemo.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

function TAccMemo.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccMemo.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccMemo.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccMemo.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    iDis: IDISPATCH;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        try
        iDis := Controls[varChild - 1] as IDISPATCH;
        except
            iDis := nil;
        end;
        if Assigned(iDis) then
        begin
            ppdispChild := iDis;
        end
        else
            ppdispChild := nil;
        result := S_OK;
    end;
end;

function TAccMemo.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;

    Result := S_OK;
end;

function TAccMemo.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
end;

function TAccMemo.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccMemo.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    Result := S_OK;
end;

function TAccMemo.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;
end;

function TAccMemo.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
  pszHelpFile := FHelpPath;
  pidTopic := HelpContext;
  result := S_OK;
end;

function TAccMemo.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
  Result := S_OK;
end;

function TAccMemo.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

  if varChild = CHILDID_SELF then
  begin
     pszName := FName;
     Result := S_OK;
  end
  else
    Result := S_OK;
end;

function TAccMemo.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        result := S_OK;
    end;
end;

function TAccMemo.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
  TVarData(pvarRole).VType := VT_I4;
  pvarRole := ROLE_SYSTEM_TEXT;
  Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accRole(varChild, pvarRole);
end;

function TAccMemo.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
        end;
    end;
    Result := S_OK;
end;


function TAccMemo.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_HASPOPUP;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
        if ReadOnly then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_READONLY;
        if SelLength > 0 then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_SELECTED;
        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccMemo.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := text;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;

function TAccMemo.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccMemo.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        FName := pszName;
    end
    else
        Result := S_OK;
end;

function TAccMemo.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        TExt := pszValue;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;



//////Groupbox##############
procedure TAccGroupBox.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;

constructor TAccGroupBox.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Parent  := AOwner as TWinControl;


    FName := Caption;

end;

function TAccGroupBox.accDoDefaultAction(varChild: OleVariant): HResult;
begin
  Result := DISP_E_MEMBERNOTFOUND;//FAcc.accDoDefaultAction(varChild);
end;

function TAccGroupBox.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
  p:pointer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True, True);
    if Assigned(Control) then
    begin
        if Control is TWinControl then
        begin
            if SUCCEEDED(AccessibleObjectFromWindow((Control as TWinControl).Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
            begin
                VariantInit(pvarChild);
                TVarData(pvarChild).VType := VT_DISPATCH;
                pvarChild := IDISPATCH(p);
                result := S_OK;
            end;
        end
        else
        begin
            for i := 0 to ControlCount - 1 do
            begin
                if Controls[i] = control then
                begin
                    pvarChild := i + 1;
                    result := S_OK;
                    break;
                end;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccGroupBox.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    Ctrl: TControl;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
        Ctrl := self
    else
    begin
        if varChild <= ControlCount then
        begin
            Ctrl := Controls[varChild - 1];
        end
        else
            Ctrl := nil;
    end;
    if Ctrl <> nil then
    begin
        p := Ctrl.ClientToScreen(Ctrl.ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
        Result := S_FALSE;
end;

function TAccGroupBox.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end
                else
                begin
                    if ControlCount > 0 then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_I4;
                        pvarEndUpAt := 1;
                        result := S_OK;
                    end;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end
                else
                begin
                    if ControlCount > 0 then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_I4;
                        pvarEndUpAt := ControlCount;
                        result := S_OK;
                    end;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccGroupBox.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
  Result := DISP_E_MEMBERNOTFOUND;//FAcc.Get_accSelection(pvarChildren);
end;

function TAccGroupBox.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccGroupBox.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccGroupBox.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccGroupBox.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    dis: idispatch;
begin
     if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        dis := nil;
        try
        dis := self.Controls[varChild - 1] as iDispatch;
        except
            dis := nil;
        end;
        if Assigned(Dis) then
        begin
            ppdispChild := dis;
            result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
        end
        else
        begin
            ppdispChild := nil;
            result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
        end;
    end;
end;

function TAccGroupBox.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := controlcount;

    Result := S_OK;
    //result := FAcc.Get_accChildCount(pcountChildren);
end;

function TAccGroupBox.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
end;

function TAccGroupBox.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  Result := S_FALSE;
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
  if Length(pszDescription) > 0 then
    Result := S_OK;
end;

function TAccGroupBox.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
  Result := DISP_E_MEMBERNOTFOUND;
end;

function TAccGroupBox.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;
end;

function TAccGroupBox.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
  pszHelpFile := FHelpPath;
  pidTopic := HelpContext;
  result := S_OK;
end;

function TAccGroupBox.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
  Result := S_OK;
end;

function TAccGroupBox.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

  if varChild = CHILDID_SELF then
  begin
     pszName := FName;
     Result := S_OK;
  end
  else
    Result := S_OK;
end;

function TAccGroupBox.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        result := S_OK;
    end;
end;

function TAccGroupBox.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
  TVarData(pvarRole).VType := VT_I4;
  pvarRole := ROLE_SYSTEM_GROUPING;
  Result := S_OK;
end;

function TAccGroupBox.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
var
    i: integer;
begin
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
            for i := 0 to ControlCount - 1 do
            begin
                if Controls[i] is TWinControl then
                begin
                    (Controls[i] as TWinControl).SetFocus;
                    Break;
                end;
            end;
        end;
    end
    else
    begin
        if ((flagsSelect and SELFLAG_TAKESELECTION) <> 0) then
        begin
            if Controls[varChild - 1] is TWinControl then
            begin
                (Controls[varChild - 1] as TWinControl).SetFocus;
            end;
        end;
        if ((flagsSelect and SELFLAG_ADDSELECTION) <> 0) then
        begin
            if Controls[varChild - 1] is TWinControl then
            begin
                (Controls[varChild - 1] as TWinControl).SetFocus;
            end;
        end;

        if ((flagsSelect and SELFLAG_TAKEFOCUS) <> 0) then
        begin
            if Controls[varChild - 1] is TWinControl then
            begin
                (Controls[varChild - 1] as TWinControl).SetFocus;
            end;
        end;
        if ((flagsSelect and SELFLAG_EXTENDSELECTION) <> 0) then
        begin
            if Controls[varChild - 1] is TWinControl then
            begin
                (Controls[varChild - 1] as TWinControl).SetFocus;
            end;
        end;
    end;
    Result :=  S_OK;
end;


function TAccGroupBox.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_NORMAL;
        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;
    end
     else
        Result := S_OK;
end;

function TAccGroupBox.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := caption;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;

function TAccGroupBox.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccGroupBox.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        FName := pszName;
    end
    else
        Result := S_OK;
end;

function TAccGroupBox.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        caption := pszValue;
        Result := S_OK;
    end
    else
        Result :=S_OK;
end;




//////Toolbar##############
procedure TAccToolbar.WndProc(var Msg: TMessage);
var
    nmHot: TNMTBHOTITEM;
const
    TB_SETHOTITEM2 = WM_USER+94;
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else if Msg.Msg = WM_KEYUP then
    begin
        if Msg.WParam = VK_RIGHT then
        begin
            Inc(iFocus);

            if iFocus > self.ButtonCount then
                iFocus := 1;
            if (self.Buttons[iFOcus - 1].Style = tbsdivider) or (self.Buttons[iFOcus - 1].Style = tbsseparator) then
            begin
                SendMessage(self.Handle, WM_KEYUP, Msg.WParam, Msg.LParam);
                exit;
            end
            else if self.Buttons[iFOcus - 1].Enabled = false then
            begin
                SendMessage(self.Handle, WM_KEYUP, Msg.WParam, Msg.LParam);
                exit;
            end
            else
            begin
                nmHot.dwFlags := HICF_ARROWKEYS;
                SendMessage(self.Handle,  TB_SETHOTITEM2, iFocus - 1, Lparam(@nmHot));
            end;
        end
        else if Msg.WParam = VK_Left then
        begin
            Dec(iFocus);

            if iFocus < 1 then
                iFocus := self.ButtonCount;
            if (self.Buttons[iFOcus - 1].Style = tbsdivider) or (self.Buttons[iFOcus - 1].Style = tbsseparator) then
            begin
                SendMessage(self.Handle, WM_KEYUP, Msg.WParam, Msg.LParam);
                exit;
            end
            else if self.Buttons[iFOcus - 1].Enabled = false then
            begin
                SendMessage(self.Handle, WM_KEYUP, Msg.WParam, Msg.LParam);
                exit;
            end
            else
            begin
                nmHot.dwFlags := HICF_ARROWKEYS;
                SendMessage(self.Handle,  TB_SETHOTITEM2, iFocus - 1, Lparam(@nmHot));
            end;
        end
        else if Msg.WParam = VK_SPACE then
        begin
            self.Buttons[iFocus - 1].OnClick(self);
        end;
    end
    else
        inherited;
end;

constructor TAccToolbar.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Parent  := AOwner as TWinControl;


    FName := Name;

end;

function TAccToolbar.accDoDefaultAction(varChild: OleVariant): HResult;
var
    ctrl: TControl;
    ttb: TToolButton;
begin
    Result := S_OK;
    try
    if varChild = CHILDID_SELF then
        Result := DISP_E_MEMBERNOTFOUND
    else
    begin
        if varChild - 1 <= controlcount - 1 then
        begin
            Ctrl := Controls[varChild - 1];
            if Ctrl is TToolButton then
            begin
                ttb := ctrl as TToolButton;
                if (ttb.Style <> tbsDivider) and (ttb.Style <> tbsSeparator) then
                begin
                    ttb.OnClick(Self);
                    Result := S_OK;
                end;
            end
            else
                Result := S_OK;
        end
        else
            Result := S_FALSE;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 11);

    end;
end;

function TAccToolbar.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    try
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 12);

    end;
end;

function TAccToolbar.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    Ctrl: TControl;
var
    p: tpoint;
begin
    try
    if varChild = CHILDID_SELF then
        Ctrl := self
    else
    begin
        if varChild <= ControlCount then
        begin
            Ctrl := Controls[varChild - 1];
        end
        else
            Ctrl := nil;
    end;
    if Ctrl <> nil then
    begin
        p := Ctrl.ClientToScreen(Ctrl.ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;
    end
    else
        Result := S_FALSE;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 13);

    end;
end;

function TAccToolbar.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    try
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
      Result := S_FALSE;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 14);

    end;
end;

function TAccToolbar.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
  pvarChildren := 0;
  Result := S_OK;
end;

function TAccToolbar.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccToolbar.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccToolbar.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccToolbar.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
begin
    try
     if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
      Result := S_FALSE;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 15);

    end;
end;

function TAccToolbar.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := self.ButtonCount;

    Result := S_OK;
    //result := FAcc.Get_accChildCount(pcountChildren);
end;

function TAccToolbar.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
var
    ctrl: TControl;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        pszDefaultAction := FacDesc;
    end
    else
    begin
        if varChild - 1 <= controlcount - 1 then
        begin
            ctrl := Controls[varChild - 1];
            if Ctrl is TToolButton then
            begin
                if (Buttons[varChild - 1].Style <> tbsDivider) and (Buttons[varChild - 1].Style <> tbsSeparator) then
                begin
                    Result := S_OK;
                    pszDefaultAction := 'Press';
                end
                else
                    Result := S_OK;
            end
            else
                Result := S_OK;
        end
        else
            result := S_FALSE;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 16);

    end;
end;

function TAccToolbar.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  Result := S_FALSE;
  try
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
  begin
    if varChild - 1 <= controlcount - 1 then
        pszDescription := GetLongHint(Controls[varChild - 1].Hint);
  end;
  if Length(pszDescription) > 0 then
    Result := S_OK;
  except
        on E: Exception do
            result := ErrDLG(E.Message, 17);

    end;
end;

function TAccToolbar.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
  Result := DISP_E_MEMBERNOTFOUND;//FAcc.Get_accFocus(pvarChild);
end;

function TAccToolbar.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    Result := S_FALSE;
    try
    if varChild = CHILDID_SELF then
    begin
        pszHelp := GetLongHInt(Hint);
        Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
    end
    else
    begin
        pszHelp := GetShortHint(Buttons[varChild - 1].Hint);
        if Length(pszHelp) > 0 then
            Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 18);

    end;
end;

function TAccToolbar.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pidTopic := Buttons[varChild - 1].HelpContext;
        result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 19);

    end;
end;

function TAccToolbar.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        pszKeyboardShortcut := '';
        Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
    end
    else
    begin
        if Buttons[varChild - 1].Action <> nil then
        begin
            pszKeyboardShortcut := ShortCutToText((Buttons[varChild - 1].Action as TAction).ShortCut);
            Result := S_OK;
        end
        else
        begin
            pszKeyboardShortcut := '';
            Result := S_OK;
        end;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 20);

    end;
end;

function TAccToolbar.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin
    try
  if varChild = CHILDID_SELF then
  begin
     pszName := FName;
     Result := S_OK;
  end
  else
  begin
    pszName := Buttons[varChild - 1].Caption;
    Result := S_OK;//FAcc.Get_accName(varChild, pszName);
  end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 21);

    end;
end;

function TAccToolbar.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    {Result := S_FALSE;
    if Parent <> nil then
    begin
        if SUCCEEDED(AccessibleObjectFromWindow(ParentWindow, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end;
    end; }
    //ppdispParent := self.Parent as iDispatch;
    //result := S_OK;
    try
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
            ppdispParent := self;
            result := S_OK;

        //result := FAcc.Get_accParent(ppdispParent);
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 22);

    end;
end;

function TAccToolbar.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
var
    bs: TToolButtonStyle;
begin
    try
    VariantInit(pvarRole);
  TVarData(pvarRole).VType := VT_I4;
  if varChild = CHILDID_SELF then
  begin
    pvarRole := ROLE_SYSTEM_TOOLBAR;
    Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accRole(varChild, pvarRole);
  end
  else
  begin
    bs := Buttons[varChild - 1].Style;
    if bs = tbsButton then
        pvarRole := ROLE_SYSTEM_PUSHBUTTON
    else if bs = tbsCheck then
        pvarRole := ROLE_SYSTEM_CHECKBUTTON
    else if (bs = tbsDivider) or (bs = tbsSeparator) then
        pvarRole := ROLE_SYSTEM_SEPARATOR
    else if bs = tbsDropdown then
        pvarRole := ROLE_SYSTEM_BUTTONDROPDOWN
    else
        pvarRole := ROLE_SYSTEM_PUSHBUTTON;
    result := S_OK;
  end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 23);

    end;
end;

function TAccToolbar.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
        end;
    end;
    Result := S_OK;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 24);

    end;
end;


function TAccToolbar.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    try
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_NORMAL;
        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
     begin
        if (Buttons[varChild - 1].Style = tbsDivider) or (Buttons[varChild - 1].Style = tbsSeparator) then
        begin
            TVarData(pvarState).VInteger := STATE_SYSTEM_NORMAL;
            Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
        end
        else
        begin
            //TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
            if Buttons[varChild - 1].Enabled then
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
            else
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
            if Buttons[varChild - 1].Down then
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_CHECKED;
            Result := S_OK;
        end;
     end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 25);

    end;
end;

function TAccToolbar.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        pszValue := caption;
        Result := S_OK;
    end
    else
    begin
        pszValue := Buttons[varChild - 1].Caption;
        Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 26);

    end;
end;

function TAccToolbar.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccToolbar.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        FName := pszName;
    end
    else
    begin
        Buttons[varChild - 1].Caption :=  pszName;
        Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 27);

    end;
end;

function TAccToolbar.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        caption := pszValue;
        Result := S_OK;
    end
    else
    begin
        Buttons[varChild - 1].Caption :=  pszValue;
        Result := S_OK;//FAcc.Set_accValue(varChild, pszValue);//FAcc.Set_accValue(varChild, pszValue);
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 28);

    end;
end;


function TAccButton.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Click;
    end
    else
        Result := S_OK;
end;

function TAccButton.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccButton.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccButton.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];

                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
    end;
end;

function TAccButton.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

constructor TAccButton.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TAccButton.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccButton.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccButton.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccButton.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccButton.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;
    Result := S_OK;
end;

function TAccButton.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccButton.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccButton.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_DISPATCH;
    pvarChild := self as iDispatch;
    result := S_OK;
end;

function TAccButton.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccButton.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccButton.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := FShortCut;
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccButton.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        pszName := '';
        Result := S_OK;
    end;
end;

function TAccButton.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccButton.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_PUSHBUTTON;
    end
    else
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_WINDOW;
   result := S_OK;
end;

function TAccButton.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        self.SetFocus;
    end;
    Result := S_OK;
end;


function TAccButton.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;

        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccButton.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := self.Caption;
        result := S_OK;
    end
    else
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
end;

function TAccButton.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccButton.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
        Result := S_OK;
end;

function TAccButton.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
        Result := S_OK;
end;



procedure TAccButton.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;


function TAccComboBox.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        //Checked := not Checked;
    end
    else
    begin
        if VarChild - 1 <= Items.Count - 1 then
        begin
          ItemIndex := varChild - 1;
        end;
        Result := S_OK;
    end;
end;

function TAccComboBox.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccComboBox.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccComboBox.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;

    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                {if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;}
                TVarData(pvarEndUpAt).VType := VT_I4;
                pvarEndUpAt := 1;
                result := S_OK;
            end;
            NAVDIR_LASTCHILD:
            begin
                {if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;}
                TVarData(pvarEndUpAt).VType := VT_I4;
                pvarEndUpAt := Items.Count;
                result := S_OK;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := E_NOTIMPL;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > Items.count - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= Items.count - 1)  and (varstart >= 0) then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    pvarEndUpAt := varStart+1;
                    Result := S_OK;
                    //Ctrl := Controls[varStart];
                    {if Ctrl <> nil then
                    begin
                        iDis := Ctrl as iDispatch;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end; }
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= Items.count - 1) and (varstart >= 0) then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    pvarEndUpAt := varStart - 1;
                    Result := S_OK;
                    {Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        iDis := Ctrl as iDispatch;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end; }
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := E_NOTIMPL;
            end;
        end;
    end;
    iDis := nil;
end;

function TAccComboBox.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin

    pvarChildren := 0;
    Result := S_OK;

end;

constructor TAccComboBox.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TAccComboBox.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccComboBox.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccComboBox.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccComboBox.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;

begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccComboBox.Get_accChildCount(out pcountChildren: Integer): HResult;
begin

    pcountChildren := Items.Count;
    Result := S_OK;
end;

function TAccComboBox.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    if varChild = CHILDID_SELF then
    begin
        pszDefaultAction := FacDesc;
    end
    else
    begin
        pszDefaultAction := 'Check or Uncheck';
    end;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccComboBox.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccComboBox.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TAccComboBox.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelp := GetLongHInt(Hint);
        Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
    end
    else
    begin
        pszHelp := '';
        Result := S_OK;
    end;
end;

function TAccComboBox.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccComboBox.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccComboBox.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        if VarChild - 1 <= Items.Count - 1 then
            pszName := Items[varChild - 1]
        else
            pszName := '';
        Result := S_OK;
    end;
end;

function TAccComboBox.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccComboBox.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_COMBOBOX;
    end
    else
    begin
       TVarData(pvarRole).VInteger := ROLE_SYSTEM_LISTITEM;
    end;
   result := S_OK;
end;

function TAccComboBox.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    Result :=  S_OK;
    if varChild = CHILDID_SELF then
    begin
        if (flagsSelect <> SELFLAG_REMOVESELECTION) and (flagsSelect <> SELFLAG_NONE) then
            self.SetFocus;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
        begin
            Itemindex := -1;
        end;

    end
    else
    begin
        if ((flagsSelect and SELFLAG_TAKESELECTION) <> 0) then
        begin
            Itemindex := varChild - 1;

        end;
        if ((flagsSelect and SELFLAG_ADDSELECTION) <> 0) then
            Itemindex := varChild - 1;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
            Itemindex :=  - 1;
        if ((flagsSelect and SELFLAG_TAKEFOCUS) <> 0) then
            Itemindex := varChild - 1;
        if ((flagsSelect and SELFLAG_EXTENDSELECTION) <> 0) then
            Itemindex := varChild - 1;
    end;
end;


function TAccComboBox.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;


        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
     begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_SELECTABLE;

        Result := S_OK;
     end;
end;

function TAccComboBox.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := Text;
        result := S_OK;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            pszValue := Items[varChild - 1];
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
    end;
end;

function TAccComboBox.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccComboBox.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            Items[varChild - 1] := pszName;
        Result := S_OK;
    end;
end;

function TAccComboBox.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            Items[varChild - 1] := pszValue;
        Result := S_OK;
    end;
end;





procedure TAccComboBox.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited WndProc(Msg);
end;



function TAccBitBtn.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Click;
    end
    else
        Result := S_OK;
end;

function TAccBitBtn.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccBitBtn.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccBitBtn.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];

                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
    end;
end;

function TAccBitBtn.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

constructor TAccBitBtn.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TAccBitBtn.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccBitBtn.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccBitBtn.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccBitBtn.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccBitBtn.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;
    Result := S_OK;
end;

function TAccBitBtn.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccBitBtn.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccBitBtn.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_DISPATCH;
    pvarChild := self as iDispatch;
    result := S_OK;
end;

function TAccBitBtn.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccBitBtn.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccBitBtn.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := FShortCut;
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccBitBtn.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        pszName := '';
        Result := S_OK;
    end;
end;

function TAccBitBtn.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccBitBtn.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_PUSHBUTTON;
    end
    else
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_WINDOW;
   result := S_OK;
end;

function TAccBitBtn.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
        end;
    end;
    Result := S_OK;
end;


function TAccBitBtn.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;

        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccBitBtn.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := self.Caption;
        result := S_OK;
    end
    else
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
end;

function TAccBitBtn.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccBitBtn.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
        Result := S_OK;
end;

function TAccBitBtn.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
        Result := S_OK;
end;




procedure TAccBitBtn.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;



function TAccRadioButton.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Checked := not Checked;
    end
    else
        Result := S_OK;
end;

function TAccRadioButton.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccRadioButton.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccRadioButton.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccRadioButton.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

constructor TAccRadioButton.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TAccRadioButton.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccRadioButton.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccRadioButton.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccRadioButton.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    iDis: IDISPATCH;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        try
        iDis := Controls[varChild - 1] as IDISPATCH;
        except
            iDis := nil;
        end;
        if Assigned(iDis) then
        begin
            ppdispChild := iDis;
        end
        else
            ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccRadioButton.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := ControlCount;
    Result := S_OK;
end;

function TAccRadioButton.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccRadioButton.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccRadioButton.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TAccRadioButton.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccRadioButton.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccRadioButton.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccRadioButton.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        pszName := '';
        Result := S_OK;
    end;
end;

function TAccRadioButton.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccRadioButton.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_RADIOBUTTON;
    end
    else
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_WINDOW;
   result := S_OK;
end;

function TAccRadioButton.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
        end;
    end;
    Result := S_OK;
end;


function TAccRadioButton.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
        if Checked then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_CHECKED;

        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccRadioButton.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := self.Caption;
        result := S_OK;
    end
    else
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
end;

function TAccRadioButton.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccRadioButton.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
        Result := S_OK;
end;

function TAccRadioButton.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
        Result := S_OK;
end;

procedure TAccRadioButton.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin
        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;



destructor TAccEdit.Destroy;
begin

    inherited destroy;
end;


procedure TAccEdit.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;

constructor TAccEdit.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Parent  := AOwner as TWinControl;


    FName := Name;

end;

function TAccEdit.accDoDefaultAction(varChild: OleVariant): HResult;
begin
  Result := S_OK;//FAcc.accDoDefaultAction(varChild);
end;

function TAccEdit.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := CHILDID_SELF;
    Result := S_OK;
end;

function TAccEdit.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
        Result := S_FALSE;
end;

function TAccEdit.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccEdit.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

function TAccEdit.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccEdit.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccEdit.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccEdit.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    iDis: IDISPATCH;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        try
        iDis := Controls[varChild - 1] as IDISPATCH;
        except
            iDis := nil;
        end;
        if Assigned(iDis) then
        begin
            ppdispChild := iDis;
        end
        else
            ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccEdit.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;

    Result := S_OK;
    //result := FAcc.Get_accChildCount(pcountChildren);
end;

function TAccEdit.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
end;

function TAccEdit.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccEdit.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    Result := S_OK;//FAcc.Get_accFocus(pvarChild);
end;

function TAccEdit.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccEdit.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
  pszHelpFile := FHelpPath;
  pidTopic := HelpContext;
  result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
end;

function TAccEdit.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
  Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccEdit.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

  if varChild = CHILDID_SELF then
  begin
     pszName := FName;
     Result := S_OK;
  end
  else
    Result := S_OK;
end;

function TAccEdit.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;

end;

function TAccEdit.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
  TVarData(pvarRole).VType := VT_I4;
  pvarRole := ROLE_SYSTEM_TEXT;
  Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accRole(varChild, pvarRole);
end;

function TAccEdit.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        self.SetFocus;
    end;
    Result := S_OK;
end;


function TAccEdit.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_HASPOPUP;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
        if ReadOnly then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_READONLY;
        if SelLength > 0 then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_SELECTED;
        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccEdit.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    pszValue := text;
    Result := S_OK;
end;

function TAccEdit.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccEdit.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        FName := pszName;
    end
    else
        Result := S_OK;
end;

function TAccEdit.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        TExt := pszValue;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;



destructor TAccLabeledEdit.Destroy;
begin

    inherited destroy;
end;


procedure TAccLabeledEdit.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;

constructor TAccLabeledEdit.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Parent  := AOwner as TWinControl;

    FName := Name;

end;

function TAccLabeledEdit.accDoDefaultAction(varChild: OleVariant): HResult;
begin
  Result := S_OK;//FAcc.accDoDefaultAction(varChild);
end;

function TAccLabeledEdit.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := CHILDID_SELF;
    Result := S_OK;
end;

function TAccLabeledEdit.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
        Result := S_FALSE;
end;

function TAccLabeledEdit.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccLabeledEdit.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

function TAccLabeledEdit.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccLabeledEdit.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccLabeledEdit.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccLabeledEdit.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    iDis: IDISPATCH;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        try
        iDis := Controls[varChild - 1] as IDISPATCH;
        except
            iDis := nil;
        end;
        if Assigned(iDis) then
        begin
            ppdispChild := iDis;
        end
        else
            ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccLabeledEdit.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;

    Result := S_OK;
    //result := FAcc.Get_accChildCount(pcountChildren);
end;

function TAccLabeledEdit.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
end;

function TAccLabeledEdit.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccLabeledEdit.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    Result := S_OK;//FAcc.Get_accFocus(pvarChild);
end;

function TAccLabeledEdit.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccLabeledEdit.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
  pszHelpFile := FHelpPath;
  pidTopic := HelpContext;
  result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
end;

function TAccLabeledEdit.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
  Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccLabeledEdit.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

  if varChild = CHILDID_SELF then
  begin
     pszName := FName;
     Result := S_OK;
  end
  else
    Result := S_OK;
end;

function TAccLabeledEdit.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;

end;

function TAccLabeledEdit.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
  TVarData(pvarRole).VType := VT_I4;
  pvarRole := ROLE_SYSTEM_TEXT;
  Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accRole(varChild, pvarRole);
end;

function TAccLabeledEdit.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        if ((flagsSelect and SELFLAG_REMOVESELECTION) = 0) and ((flagsSelect and SELFLAG_NONE) = 0) then
        begin
            self.SetFocus;
        end;
    end;
    Result := S_OK;
end;


function TAccLabeledEdit.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_HASPOPUP;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
        if ReadOnly then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_READONLY;
        if SelLength > 0 then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_SELECTED;
        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccLabeledEdit.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := text;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;

function TAccLabeledEdit.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccLabeledEdit.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        FName := pszName;
    end
    else
        Result := S_OK;
end;

function TAccLabeledEdit.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        TExt := pszValue;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;

function TAccTrackbar.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        if Position < Max then
          Position := Position + 1
        else
          Position := 0;
        //Checked := not Checked;
    end
    else
    begin
        {if VarChild - 1 <= Items.Count - 1 then
        begin
          ItemIndex := varChild - 1;
        end;    }
        Result := S_OK;
    end;
end;

function TAccTrackbar.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccTrackbar.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccTrackbar.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccTrackbar.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin

    pvarChildren := 0;
    Result := S_OK;

end;

constructor TAccTrackbar.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TAccTrackbar.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTrackbar.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTrackbar.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTrackbar.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;

begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccTrackbar.Get_accChildCount(out pcountChildren: Integer): HResult;
begin

    pcountChildren := ControlCount;
    Result := S_OK;
end;

function TAccTrackbar.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    if varChild = CHILDID_SELF then
    begin
        pszDefaultAction := FacDesc;
    end
    else
    begin
        pszDefaultAction := 'Check or Uncheck';
    end;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccTrackbar.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccTrackbar.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TAccTrackbar.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelp := GetLongHInt(Hint);
        Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
    end
    else
    begin
        pszHelp := '';
        Result := S_OK;
    end;
end;

function TAccTrackbar.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccTrackbar.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccTrackbar.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        pszName := '';
        Result := S_OK;
    end;
end;

function TAccTrackbar.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccTrackbar.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_SLIDER;
    end
    else
    begin
       //TVarData(pvarRole).VInteger := ROLE_SYSTEM_LISTITEM;
    end;
   result := S_OK;
end;

function TAccTrackbar.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        self.SetFocus;
    end;
    Result := S_OK;
end;


function TAccTrackbar.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;


        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
     begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_SELECTABLE;

        Result := S_OK;
     end;
end;

function TAccTrackbar.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    pszValue := InttoStr(Position);
    result := S_OK;
end;

function TAccTrackbar.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTrackbar.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin

  Result := S_OK;
end;

function TAccTrackbar.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    result := S_OK;
    Position := StrToIntDef(pszValue, 0);
end;





procedure TAccTrackbar.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited WndProc(Msg);
end;


destructor TAccMaskEdit.Destroy;
begin

    inherited destroy;
end;


procedure TAccMaskEdit.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited;
end;

constructor TAccMaskEdit.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Parent  := AOwner as TWinControl;


    FName := Name;

end;

function TAccMaskEdit.accDoDefaultAction(varChild: OleVariant): HResult;
begin
  Result := S_OK;//FAcc.accDoDefaultAction(varChild);
end;

function TAccMaskEdit.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := CHILDID_SELF;
    Result := S_OK;
end;

function TAccMaskEdit.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
        Result := S_FALSE;
end;

function TAccMaskEdit.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
    Ctrl: TControl;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= ControlCount - 1)  and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= ControlCount - 1) and (varstart >= 0) then
                begin

                    Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        try
                            iDis := Ctrl as iDispatch;
                        except
                            iDis := nil;
                        end;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;
end;

function TAccMaskEdit.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    pvarChildren := 0;
    Result := S_OK;
end;

function TAccMaskEdit.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccMaskEdit.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := S_OK;
end;

function TAccMaskEdit.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TAccMaskEdit.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;
var
    iDis: IDISPATCH;
begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        try
        iDis := Controls[varChild - 1] as IDISPATCH;
        except
            iDis := nil;
        end;
        if Assigned(iDis) then
        begin
            ppdispChild := iDis;
        end
        else
            ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccMaskEdit.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    pcountChildren := 0;

    Result := S_OK;
    //result := FAcc.Get_accChildCount(pcountChildren);
end;

function TAccMaskEdit.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    pszDefaultAction := FacDesc;
end;

function TAccMaskEdit.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccMaskEdit.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    Result := S_OK;//FAcc.Get_accFocus(pvarChild);
end;

function TAccMaskEdit.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    pszHelp := GetLongHInt(Hint);
    Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
end;

function TAccMaskEdit.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
  pszHelpFile := FHelpPath;
  pidTopic := HelpContext;
  result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
end;

function TAccMaskEdit.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
  Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccMaskEdit.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

  if varChild = CHILDID_SELF then
  begin
     pszName := FName;
     Result := S_OK;
  end
  else
    Result := S_OK;
end;

function TAccMaskEdit.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;

end;

function TAccMaskEdit.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
  TVarData(pvarRole).VType := VT_I4;
  pvarRole := ROLE_SYSTEM_TEXT;
  Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accRole(varChild, pvarRole);
end;

function TAccMaskEdit.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        self.SetFocus;
    end;
    Result := S_OK;
end;


function TAccMaskEdit.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_HASPOPUP;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;
        if ReadOnly then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_READONLY;
        if SelLength > 0 then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_SELECTED;
        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
        Result := S_OK;
end;

function TAccMaskEdit.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := text;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;

function TAccMaskEdit.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := S_OK;
end;

function TAccMaskEdit.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        FName := pszName;
    end
    else
        Result := S_OK;
end;

function TAccMaskEdit.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        TExt := pszValue;
        Result := S_OK;
    end
    else
        Result := S_OK;
end;

function TAccTreeView.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    Result := E_INVALIDARG;
    try
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        //Checked := not Checked;
    end
    else
    begin
        //AccNode := GetAccNode;
        if (GetAccNode(varChild)) and (AccNode.Index<= Items.Count - 1) then
        begin
            if AccNode.HasChildren then
            begin
                if AccNode.Expanded then
                    AccNode.Collapse(True)
                else
                    AccNode.Expand(True);
                Result := S_OK;
            end;
        end;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 1);

    end;
end;

function TAccTreeView.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
{var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end; }
    var
    p: tpoint;
    tvh: TTVHITTESTINFO;
    hi: HTreeItem;
begin

    try
    p.X := xLeft;
    p.Y := yTop;
    p := ScreenToClient(p);
    FillChar(tvh, SizeOf(tvh), 0);
    tvh.pt := p;

    hi := TreeView_HitTest(Handle, tvh);
    //HT := Self.GetHitTestInfoAt(p.X, p.Y);
    //if (HT <= [htOnItem, htOnIcon, htOnLabel, htOnStateIcon]) then
    if hi <> nil then
    begin
        //node := GetNodeAt(p.X, p.Y);
        VariantInit(pvarChild);
        TVarData(pvarChild).VType := VT_I4;
        pvarChild := TreeView_MapHTREEITEMtoAccID(handle, hi);

        Result := S_OK;

    end
    else
    begin
        VariantInit(pvarChild);
        TVarData(pvarChild).VType := VT_I4;
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 2);
    end;
end;

function TAccTreeView.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
    rc:TRect;
begin
    Result := E_INVALIDARG;
    try
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        if GetAccNode(varChild) then
        begin
            if AccNode.Index <= Items.COunt then
            begin

                RC := Accnode.DisplayRect(false);
                //TreeView_GetItemRect(Handle, node.ItemId, RC, False);
                p.X := RC.Left;
                p.Y := RC.Top;
                p := ClientToScreen(p);
                //GetWindowRect(Items[varChild - 1].Handle, RC);
                pxLeft := P.X;
                pyTop := P.Y;
                pcxWidth := RC.Right - RC.Left;
                pcyHeight := RC.Bottom - RC.Top;
                Result := S_OK;
            end;
        end;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 2);

    end;
end;

function TAccTreeView.GetAccNode(varChild: integer): boolean;
var
    hTree: HTREEITEM;
begin
    Result := False;
    try
    hTree := TreeView_MapAccIDToHTREEITEM(Handle, varChild);
    Accnode := nil;
    Accnode := Items.GetNode(hTree);
    if Assigned(Accnode) then
        Result := True;
    except
        on E: Exception do
            ErrDLG(E.Message, 4);
    end;

end;

function TAccTreeView.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := E_INVALIDARG;
    try
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                {if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;}
                if Items.Count > 0 then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    //pvarEndUpAt := 1 + Fcnt;
                    pvarEndUpAt := TreeView_MapHTREEITEMtoAccID(handle, Items[0].itemid);
                    result := S_OK;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                {if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;}
                if Items.Count > 0 then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    //pvarEndUpAt := Items.Count + Fcnt;
                    pvarEndUpAt := TreeView_MapHTREEITEMtoAccID(handle, Items[Items.Count - 1].itemid);
                    result := S_OK;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        //hTree := TreeView_MapAccIDToHTREEITEM(Handle, varStart);
        //node := Items.GetNode(hTree);
        if not GetAccNode(varStart) then
            Exit;
        //showmessage(inttostr(varStart - FCnt) + '/'+ inttostr(Items.count - 1));
        //if varStart - FCnt > Items.count - 1 then
        if Accnode.Index > Items.count - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if Accnode.HasChildren then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    //pvarEndUpAt := Items[varstart - 1 - FCnt].getFirstChild.AbsoluteIndex + 1 + Fcnt; //Items[varstart - 1].AbsoluteIndex + 2;
                    pvarEndUpAt := TreeView_MapHTREEITEMtoAccID(handle, Accnode.getFirstChild.ItemId);
                    Result := S_OK;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if Accnode.HasChildren then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    //pvarEndUpAt := Items[varstart - FCnt].GetLastChild.AbsoluteIndex + 1 + Fcnt;  //Items[varstart - 1].GetLastChild.AbsoluteIndex + 1;
                    pvarEndUpAt := TreeView_MapHTREEITEMtoAccID(handle, Accnode.getLastChild.ItemId);
                    Result := S_OK;
                end;
            end;
            NAVDIR_NEXT:
            begin
                //node.Text := (inttostr(Integer(node.ItemId)));
                //if (varStart  - FCnt <= Items.count)  and (varstart >= 0) then
                //begin
                if Accnode.getNextSibling <> NIL then
                begin
                    //if Items[varstart - FCnt + 1] <> nil then
                    //begin
                        TVarData(pvarEndUpAt).VType := VT_I4;
                        //pvarEndUpAt := Items[varstart - FCnt].AbsoluteIndex + 1 + Fcnt;
                        pvarEndUpAt := TreeView_MapHTREEITEMtoAccID(handle, Accnode.getNextSibling.ItemId);
                        Result := S_OK;
                    //end;
                end;
                    //Ctrl := Controls[varStart];
                    {if Ctrl <> nil then
                    begin
                        iDis := Ctrl as iDispatch;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end; }
                //end;
            end;
            NAVDIR_PREVIOUS:
            begin
                //if (varStart - 2  - FCnt <= Items.count) and (varstart >= 0) then
                if Accnode.getPrevSibling <> NIL then
                begin
                    //if Items[varstart - FCnt - 1] <> nil then
                    //begin
                        TVarData(pvarEndUpAt).VType := VT_I4;
                        //pvarEndUpAt := Items[varstart - FCnt].AbsoluteIndex - 1 + Fcnt;
                        pvarEndUpAt := TreeView_MapHTREEITEMtoAccID(handle, Accnode.getPrevSibling.ItemId);
                        Result := S_OK;
                    //end;
                    {Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        iDis := Ctrl as iDispatch;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end; }
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
    end;

    iDis := nil;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 5);

    end;
end;

function TAccTreeView.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin
    Result := S_OK;
    try
    if self.SelectionCount = 0 then
        pvarChildren := 0
    else
    begin
        pvarChildren := TreeView_MapHTREEITEMtoAccID(Handle, Selected.ItemId);
    end;

    except
        on E: Exception do
            result := ErrDLG(E.Message, 6);

    end;
end;

constructor TAccTreeView.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
    //if not SUCCEEDED(CreateStdAccessibleProxy(Handle, WC_TREEVIEW, OBJID_CLIENT, IID_IAccessible, Pointer(iAcc))) then
    {if not SUCCEEDED(CreateStdAccessibleObject( Handle, OBJID_CLIENT, IID_IAccessible, Pointer(iAcc))) then
        showmessage('ERROR')
    else
    begin
        if not Assigned(iAcc) then
            showmessage('ERROR2');
    end;  }
    FName := Caption;
end;

function TAccTreeView.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTreeView.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTreeView.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTreeView.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;

begin
    result := S_FALSE;
    try
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        //S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 7);

    end;
end;

function TAccTreeView.Get_accChildCount(out pcountChildren: Integer): HResult;
begin
    Result := S_OK;
    try
    pcountChildren := Items.Count;

    except
        on E: Exception do
            result := ErrDLG(E.Message, 8);

    end;
end;

function TAccTreeView.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    {Result := S_OK;
    if varChild = CHILDID_SELF then
    begin
        pszDefaultAction := FacDesc;
    end
    else
    begin
        pszDefaultAction := 'Expand or Collapse';
    end;  }
    Result := E_INVALIDARG;
    try
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        pszDefaultAction := FacDesc;
    end
    else
    begin
        if GetAccNode(VarChild) then
        begin
        if AccNode.Index <= Items.COunt then
        begin
            if AccNode.HasChildren then
            begin
                if AccNode.Expanded then
                    pszDefaultAction := 'Collapse'
                else
                    pszDefaultAction := 'Expand';
                Result := S_OK;
            end;

        end;
        end;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 9);

    end;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccTreeView.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
    Result := S_OK;
    try
    if varChild = CHILDID_SELF then
    begin
        pszDescription := FDesc;
    end
    else
        pszDescription := '';
    except
        on E: Exception do
            result := ErrDLG(E.Message, 10);

    end;

end;

function TAccTreeView.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TAccTreeView.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        pszHelp := GetLongHInt(Hint);
        Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
    end
    else
    begin
        pszHelp := '';
        Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 11);

    end;
end;

function TAccTreeView.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 12);

    end;
end;


function TAccTreeView.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccTreeView.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin
    try
    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        if GetAccNode(VarChild) then
        begin
            if AccNode.Index <= Items.Count - 1 then
                pszName := AccNode.Text
            else
                pszName := '';
        end;
        Result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 13);

    end;
end;

function TAccTreeView.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    try
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 14);

    end;
end;

function TAccTreeView.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    result := S_OK;
    try
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_OUTLINE;
    end
    else
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_OUTLINEITEM;

    except
        on E: Exception do
            result := ErrDLG(E.Message, 15);

    end;
end;

function TAccTreeView.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    try
    Result :=  S_OK;
    if varChild = CHILDID_SELF then
    begin
        if (flagsSelect <> SELFLAG_REMOVESELECTION) and (flagsSelect <> SELFLAG_NONE) then
            self.SetFocus;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
        begin
            self.Selected.Selected := false;
        end;

    end
    else
    begin
        if GetAccNode(VarChild) then
        begin
            AccNode.Selected := True;
        //self.SetFocus;
        if ((flagsSelect and SELFLAG_TAKESELECTION) <> 0) then
        begin
            AccNode.Selected := True;

        end;
        if ((flagsSelect and SELFLAG_ADDSELECTION) <> 0) then
            AccNode.Selected := True;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
            AccNode.Selected := False;
        if ((flagsSelect and SELFLAG_TAKEFOCUS) <> 0) then
            AccNode.Selected := True;
        if ((flagsSelect and SELFLAG_EXTENDSELECTION) <> 0) then
            AccNode.Selected := True;
        end;
        OnChange(self, self.Selected);
    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 16);

    end;
end;


function TAccTreeView.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    Result := E_INVALIDARG;
    try
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;
  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;


        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
     begin
        if GetAccNode(VarChild) then
        begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_SELECTABLE;
        if (AccNode.Index) <= (Items.Count - 1) then
        begin

            if AccNode.Enabled then
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
            else
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;

            if AccNode.HasChildren then
            begin
                if AccNode.Expanded then
                    TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_EXPANDED
                else
                    TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_COLLAPSED;
            end;
            if AccNode.Selected then
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_SELECTED;
        end;
        Result := S_OK;
        end;

     end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 17);

    end;
end;

function TAccTreeView.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    Result := E_INVALIDARG;
    try
    if varChild = CHILDID_SELF then
    begin
        pszValue := '';
        result := S_OK;
    end
    else
    begin
        if GetAccNode(VarChild) then
        begin
            if (AccNode.Index) <= (Items.Count - 1) then
                pszValue := IntToStr(AccNode.Level); //AccNode.Text;
            Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
        end;

    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 18);

    end;
end;

function TAccTreeView.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccTreeView.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    Result := E_INVALIDARG;
    try
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
    begin
        if GetAccNode(VarChild) then
        begin
            if (AccNode.Index) <= (Items.Count - 1) then
                AccNode.Text := pszName;
            Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
        end;


    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 19);

    end;
end;

function TAccTreeView.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    Result := E_INVALIDARG;
    try
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
    begin
        if GetAccNode(VarChild) then
        begin
            if (AccNode.Index) <= (Items.Count - 1) then
                AccNode.Text := pszValue;
            Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
        end;


    end;
    except
        on E: Exception do
            result := ErrDLG(E.Message, 20);

    end;
end;

{procedure TAccTreeView.CNDrawItem(var Msg: TWMDrawItem);
var
  XCanvas: TCanvas;
  XCaptionRect, XGlyphRect: TRect;
  cRes: cardinal;
  procedure xxDrawBitMap(ACanvas: TCanvas);
  const
    xx_h = 13;
    xx_w = 13;
  var
    xxGlyph: TBitmap;
    xxX, xxY, xxStepY, xxStepX: integer;
  begin
    xxGlyph := TBitmap.Create;
    try
      xxGlyph.Handle := LoadBitmap(0, PChar(OBM_CHECKBOXES));
      xxY := XGlyphRect.Top +
        (XGlyphRect.Bottom - XGlyphRect.Top - xx_h) div 2;
      xxX := 2;
      xxStepX := 0;
      xxStepY := 0;
      case State of
        cbChecked: xxStepX := xxStepX + xx_w;
        cbGrayed:  xxStepX := xxStepX + xx_w * 3;
        end;
      ACanvas.CopyRect(
        Rect(xxX, xxY, xxX + xx_w,  xxY + xx_h),
        xxGlyph.Canvas,
        Rect(xxStepX, xxStepY, xx_w + xxStepX, xx_h + xxStepY)
      );
    finally
      xxGlyph.Free;
    end;
  end;

  procedure xxDrawCaption;
  var
    xXFormat: longint;
  begin

    xXFormat := DT_VCENTER + DT_SINGLELINE + DT_LEFT;
    xXFormat := DrawTextBiDiModeFlags(xXFormat);
    DrawTextW(
      Msg.DrawItemStruct.hDC,
      PWideChar(Caption),
      Length(Caption),
      XCaptionRect,
      xXFormat
    );
  end;

begin
  XGlyphRect := Msg.DrawItemStruct.rcItem;
  XGlyphRect.Right := 20;
  XCaptionRect := Msg.DrawItemStruct.rcItem;
  XCaptionRect.Left := XGlyphRect.Right;
  XCanvas := TCanvas.Create;
  try
    DrawW := Msg.DrawItemStruct.rcItem.Right;
    DrawH := Msg.DrawItemStruct.rcItem.Bottom;
    if (Msg.DrawItemStruct.itemState and ODS_FOCUS) <> 0 then
    begin
        DrawFocusRect(Msg.DrawItemStruct.hDC, Msg.DrawItemStruct.rcItem);
        Frect := True;
    end
    else
    begin
        if FRect then
        begin

            DrawFocusRect(Msg.DrawItemStruct.hDC, Msg.DrawItemStruct.rcItem);
        end;
        FRect := false;
    end;
    XCanvas.Handle := Msg.DrawItemStruct.hDC;
    XCanvas.Brush.Style := bsClear;
    xxDrawBitMap(XCanvas);
    cRes := SelectObject(Msg.DrawItemStruct.hDC, Font.Handle);
    xxDrawCaption;
    SelectObject(Msg.DrawItemStruct.hDC, cRes);

  finally
    XCanvas.Free;
  end;
end;   }

{procedure TAccTreeView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FRect := false;
  Params.ExStyle := Params.ExStyle or WS_EX_Transparent;

end;

procedure TAccTreeView.CreateWnd;
begin
  inherited CreateWnd;
  SetButtonStyle;
end;}



procedure TAccTreeView.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited WndProc(Msg);
end;



function TAccCheckList.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        //Checked := not Checked;
    end
    else
    begin
        if VarChild - 1 <= Items.Count - 1 then
        begin
            Checked[varChild - 1] := not Checked[varChild - 1];
        end;
        Result := S_OK;
    end;
end;

function TAccCheckList.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TAccCheckList.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TAccCheckList.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;

    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                {if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;}
                TVarData(pvarEndUpAt).VType := VT_I4;
                pvarEndUpAt := 1;
                result := S_OK;
            end;
            NAVDIR_LASTCHILD:
            begin
                {if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;}
                TVarData(pvarEndUpAt).VType := VT_I4;
                pvarEndUpAt := Items.Count;
                result := S_OK;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := E_NOTIMPL;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > Items.count - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];
        case navDir of
            NAVDIR_NEXT:
            begin
                if (varStart <= Items.count - 1)  and (varstart >= 0) then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    pvarEndUpAt := varStart+1;
                    Result := S_OK;
                    //Ctrl := Controls[varStart];
                    {if Ctrl <> nil then
                    begin
                        iDis := Ctrl as iDispatch;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end; }
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if (varStart - 2 <= Items.count - 1) and (varstart >= 0) then
                begin
                    TVarData(pvarEndUpAt).VType := VT_I4;
                    pvarEndUpAt := varStart - 1;
                    Result := S_OK;
                    {Ctrl := Controls[varStart - 2];
                    if Ctrl <> nil then
                    begin
                        iDis := Ctrl as iDispatch;
                    end;
                    if iDis <> nil then
                    begin
                        TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                        pvarEndUpAt := iDis;
                        Result := S_OK;
                    end; }
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := E_NOTIMPL;
            end;
        end;
    end;
    iDis := nil;
end;

function TAccCheckList.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin

    pvarChildren := 0;
    Result := S_OK;

end;

constructor TAccCheckList.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

function TAccCheckList.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccCheckList.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccCheckList.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccCheckList.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;

begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TAccCheckList.Get_accChildCount(out pcountChildren: Integer): HResult;
begin

    pcountChildren := Items.Count;
    Result := S_OK;
end;

function TAccCheckList.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    if varChild = CHILDID_SELF then
    begin
        pszDefaultAction := FacDesc;
    end
    else
    begin
        pszDefaultAction := 'Check or Uncheck';
    end;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TAccCheckList.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TAccCheckList.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TAccCheckList.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelp := GetLongHInt(Hint);
        Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
    end
    else
    begin
        pszHelp := '';
        Result := S_OK;
    end;
end;

function TAccCheckList.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TAccCheckList.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TAccCheckList.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        if VarChild - 1 <= Items.Count - 1 then
            pszName := Items[varChild - 1]
        else
            pszName := '';
        Result := S_OK;
    end;
end;

function TAccCheckList.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TAccCheckList.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_LIST;
    end
    else
    begin
        if Header[varChild - 1] then
            TVarData(pvarRole).VInteger := ROLE_SYSTEM_COLUMNHEADER//ROLE_SYSTEM_LISTITEM
        else
            TVarData(pvarRole).VInteger := ROLE_SYSTEM_CHECKBUTTON;
    end;
   result := S_OK;
end;

function TAccCheckList.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;
begin
    Result :=  S_OK;
    if varChild = CHILDID_SELF then
    begin
        if (flagsSelect <> SELFLAG_REMOVESELECTION) and (flagsSelect <> SELFLAG_NONE) then
            self.SetFocus;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
        begin
            Itemindex := -1;
        end;

    end
    else
    begin
        if ((flagsSelect and SELFLAG_TAKESELECTION) <> 0) then
        begin
            Itemindex := varChild - 1;

        end;
        if ((flagsSelect and SELFLAG_ADDSELECTION) <> 0) then
            Itemindex := varChild - 1;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
            Itemindex :=  - 1;
        if ((flagsSelect and SELFLAG_TAKEFOCUS) <> 0) then
            Itemindex := varChild - 1;
        if ((flagsSelect and SELFLAG_EXTENDSELECTION) <> 0) then
            Itemindex := varChild - 1;
    end;
end;


function TAccCheckList.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;


        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
     begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_SELECTABLE;
        if (VarChild - 1) <= (Items.Count - 1) then
        begin

            if Checked[varChild - 1] then
                TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_CHECKED;
        end;
        Result := S_OK;
     end;
end;

function TAccCheckList.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := '';
        result := S_OK;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            pszValue := Items[varChild - 1];
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
    end;
end;

function TAccCheckList.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAccCheckList.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            Items[varChild - 1] := pszName;
        Result := S_OK;
    end;
end;

function TAccCheckList.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszValue;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            Items[varChild - 1] := pszValue;
        Result := S_OK;
    end;
end;

{procedure TAccCheckList.CNDrawItem(var Msg: TWMDrawItem);
var
  XCanvas: TCanvas;
  XCaptionRect, XGlyphRect: TRect;
  cRes: cardinal;
  procedure xxDrawBitMap(ACanvas: TCanvas);
  const
    xx_h = 13;
    xx_w = 13;
  var
    xxGlyph: TBitmap;
    xxX, xxY, xxStepY, xxStepX: integer;
  begin
    xxGlyph := TBitmap.Create;
    try
      xxGlyph.Handle := LoadBitmap(0, PChar(OBM_CHECKBOXES));
      xxY := XGlyphRect.Top +
        (XGlyphRect.Bottom - XGlyphRect.Top - xx_h) div 2;
      xxX := 2;
      xxStepX := 0;
      xxStepY := 0;
      case State of
        cbChecked: xxStepX := xxStepX + xx_w;
        cbGrayed:  xxStepX := xxStepX + xx_w * 3;
        end;
      ACanvas.CopyRect(
        Rect(xxX, xxY, xxX + xx_w,  xxY + xx_h),
        xxGlyph.Canvas,
        Rect(xxStepX, xxStepY, xx_w + xxStepX, xx_h + xxStepY)
      );
    finally
      xxGlyph.Free;
    end;
  end;

  procedure xxDrawCaption;
  var
    xXFormat: longint;
  begin

    xXFormat := DT_VCENTER + DT_SINGLELINE + DT_LEFT;
    xXFormat := DrawTextBiDiModeFlags(xXFormat);
    DrawTextW(
      Msg.DrawItemStruct.hDC,
      PWideChar(Caption),
      Length(Caption),
      XCaptionRect,
      xXFormat
    );
  end;

begin
  XGlyphRect := Msg.DrawItemStruct.rcItem;
  XGlyphRect.Right := 20;
  XCaptionRect := Msg.DrawItemStruct.rcItem;
  XCaptionRect.Left := XGlyphRect.Right;
  XCanvas := TCanvas.Create;
  try
    DrawW := Msg.DrawItemStruct.rcItem.Right;
    DrawH := Msg.DrawItemStruct.rcItem.Bottom;
    if (Msg.DrawItemStruct.itemState and ODS_FOCUS) <> 0 then
    begin
        DrawFocusRect(Msg.DrawItemStruct.hDC, Msg.DrawItemStruct.rcItem);
        Frect := True;
    end
    else
    begin
        if FRect then
        begin

            DrawFocusRect(Msg.DrawItemStruct.hDC, Msg.DrawItemStruct.rcItem);
        end;
        FRect := false;
    end;
    XCanvas.Handle := Msg.DrawItemStruct.hDC;
    XCanvas.Brush.Style := bsClear;
    xxDrawBitMap(XCanvas);
    cRes := SelectObject(Msg.DrawItemStruct.hDC, Font.Handle);
    xxDrawCaption;
    SelectObject(Msg.DrawItemStruct.hDC, cRes);

  finally
    XCanvas.Free;
  end;
end;   }

{procedure TAccCheckList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FRect := false;
  Params.ExStyle := Params.ExStyle or WS_EX_Transparent;

end;

procedure TAccCheckList.CreateWnd;
begin
  inherited CreateWnd;
  SetButtonStyle;
end;}



procedure TAccCheckList.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited WndProc(Msg);
end;

function IsHex(RGBHex: String): Boolean;
var
    d, R, G, B: String;
    i: Integer;
begin
    d := RGBHex;
    if (Copy(d, 1, 1) = '#') or (Copy(d, Length(d), 1) = '$') then
        Delete(d, 1, 1);
    R := '$' + Copy(d, 1, 2);
    G := '$' + Copy(d, 3, 2);
    B := '$' + Copy(d, 5, 2);
    try
        i := StrToInt(R);
        if (i > 255) and (i < 0) then
        begin
            Result := False;
            Exit;
        end;
    except
        on EConvertError do
        begin
            Result := False;
            Exit;
        end;
    end;
    try
        i := StrToInt(G);
        if (i > 255) and (i < 0) then
        begin
            Result := False;
            Exit;
        end;
    except
        on EConvertError do
        begin
            Result := False;
            Exit;
        end;
    end;
    try
        i := StrToInt(B);
        if (i > 255) and (i < 0) then
        begin
            Result := False;
            Exit;
        end;
    except
        on EConvertError do
        begin
            Result := False;
            Exit;
        end;
    end;
    Result := True;
end;

function HexToColor(RGBHex: String; HexIsRGB: Boolean = True): TColor;
var
    d, R, G, B: String;
begin
    if not IsHex(RGBHex) then
        Raise EConvertError.Create('This value is invalid hex value.: ' + RGBHex);
    d := RGBHex;
    if (Copy(d, 1, 1) = '#') or (Copy(d, 1, 1) = '$') then
        Delete(d, 1, 1);
    R := Copy(d, 1, 2);
    G := Copy(d, 3, 2);
    B := Copy(d, 5, 2);
    if not HexIsRGB then
        Result := StringToColor('$' + R + G + B)
    else
        Result := StringToColor('$' + B + G + R);
end;

function ColortoHex(Color: TColor; ResIsRGB: Boolean = True): String;
var
    RGBColor : LongInt;
    R, G, B: Integer;
begin
    RGBColor := ColorToRGB(Color);
    R := ($000000FF and RGBColor);
    G := ($0000FF00 and RGBColor) shr 8;
    B := ($00FF0000 and RGBColor) shr 16;
    if ResIsRGB Then
        Result := '#' + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2)
    else
        Result := '#' + IntToHex(B, 2) + IntToHex(G, 2) + IntToHex(R, 2);
end;

function TColorDrop.accDoDefaultAction(varChild: OleVariant): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        //Checked := not Checked;
    end
    else
    begin
        if VarChild - 1 <= Items.Count - 1 then
        begin
          ItemIndex := varChild - 1;
        end;
        Result := S_OK;
    end;
end;

function TColorDrop.accHitTest(xLeft: Integer; yTop: Integer; out pvarChild: OleVariant): HResult;
var
  Pt: TPoint;
  Control: TControl;
  i: integer;
begin
    VariantInit(pvarChild);
    TVarData(pvarChild).VType := VT_I4;
    pvarChild := 0;
    Result := S_false;
    Pt := ScreenToClient(Point(xLeft, yTop));
    Control := ControlAtPos(Pt, True);
    if Assigned(Control) then
    begin
        for i := 0 to ControlCount - 1 do
        begin
            if Controls[i] = control then
            begin
                pvarChild := i + 1;
                result := S_OK;
                break;
            end;
        end;
    end
    else
    begin
        pvarChild := CHILDID_SELF;
        Result := S_OK;
    end;
end;

function TColorDrop.accLocation(out pxLeft: Integer;
  out pyTop: Integer; out pcxWidth: Integer;
  out pcyHeight: Integer; varChild: OleVariant): HResult;
var
    p: tpoint;
begin
    if varChild = CHILDID_SELF then
    begin
        p := ClientToScreen(ClientRect.TopLeft);
        pxLeft := P.X;
        pyTop := P.Y;
        pcxWidth := Width;
        pcyHeight := Height;
        Result := S_OK;//FAcc.accLocation(pxLeft, pyTop, pcxWidth, pcyHeight, varChild);
    end
    else
    begin
        Result := S_FALSE;
    end;
end;

function TColorDrop.accNavigate(navDir: Integer; varStart: OleVariant;
  out pvarEndUpAt: OleVariant): HResult;
var
    iDis: IDISPATCH;
begin
    VariantInit(pvarEndUpAt);
    iDIs := nil;
    pvarEndUpAt := unassigned;
    Result := S_False;
    if varStart = 0 then
    begin
        case navDir of
            NAVDIR_FIRSTCHILD:
            begin
                if FCtrlFChild <> nil then
                begin
                    iDis := FCtrlFChild as iDispatch;
                end;
            end;
            NAVDIR_LASTCHILD:
            begin
                if FCtrlLChild <> nil then
                begin
                    iDis := FCtrlLChild as iDispatch;
                end;
            end;
            NAVDIR_NEXT:
            begin
                if FCtrlNext <> nil then
                begin
                    iDis := FCtrlNext as iDispatch;
                end;
            end;
            NAVDIR_PREVIOUS:
            begin
                if FCtrlPrev <> nil then
                begin
                    iDis := FCtrlPrev as iDispatch;
                end;
            end;
            NAVDIR_UP:
            begin
                if FCtrlUP <> nil then
                begin
                    iDis := FCtrlUP as iDispatch;
                end;
            end;
            NAVDIR_DOWN:
            begin
                if FCtrlDown <> nil then
                begin
                    iDis := FCtrlDown as iDispatch;
                end;
            end;
            NAVDIR_RIGHT:
            begin
                if FCtrlRIGHT <> nil then
                begin
                    iDis := FCtrlRIGHT as iDispatch;
                end;
            end;
            NAVDIR_Left:
            begin
                if FCtrlLeft <> nil then
                begin
                    iDis := FCtrlLeft as iDispatch;
                end;
            end;
            else
            begin
                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
            end;
        end;
        if iDis <> nil then
        begin
            TVarData(pvarEndUpAt).VType := VT_DISPATCH;
            pvarEndUpAt := iDis;
            result := S_OK;
        end;
    end
    else
    begin
        if varStart - 1 > ControlCount - 1 then
            Exit;
        //Ctrl := Controls[varStart - 1];

                TVarData(pvarEndUpAt).VType := VT_DISPATCH;
                pvarEndUpAt := unassigned;
                Result := S_OK;
    end;
end;

function TColorDrop.Get_accSelection(out pvarChildren: OleVariant): HResult;
begin

    pvarChildren := 0;
    Result := S_OK;

end;

function TColorDrop.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TColorDrop.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TColorDrop.GetTypeInfoCount(
  out Count: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TColorDrop.Get_accChild(varChild: OleVariant; out ppdispChild: IDispatch): HResult;

begin
    if varChild = CHILDID_SELF then
    begin
        Result := S_OK;
        ppdispChild := self;
    end
    else
    begin
        ppdispChild := nil;
        result := S_OK;//FAcc.Get_accChild(varChild, ppdispChild);
    end;
end;

function TColorDrop.Get_accChildCount(out pcountChildren: Integer): HResult;
begin

    pcountChildren := 0;
    Result := S_OK;
end;

function TColorDrop.Get_accDefaultAction(varChild: OleVariant; out pszDefaultAction: widestring): HResult;
begin
    Result := S_OK;
    if varChild = CHILDID_SELF then
    begin
        pszDefaultAction := FacDesc;
    end
    else
    begin
        pszDefaultAction := 'Check or Uncheck';
    end;
    //Result := FAcc.Get_accDefaultAction(varChild, pszDefaultAction);
end;

function TColorDrop.Get_accDescription(varChild: OleVariant; out pszDescription: widestring): HResult;
begin
  if varChild = CHILDID_SELF then
  begin
    pszDescription := FDesc;
  end
  else
    pszDescription := '';
    Result := S_OK;
end;

function TColorDrop.Get_accFocus(out pvarChild: OleVariant): HResult;
begin
    pvarChild := 0;
    Result := S_OK;
end;

function TColorDrop.Get_accHelp(varChild: OleVariant; out pszHelp: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelp := GetLongHInt(Hint);
        Result := S_OK;//FAcc.Get_accHelp(varChild, pszHelp);
    end
    else
    begin
        pszHelp := '';
        Result := S_OK;
    end;
end;

function TColorDrop.Get_accHelpTopic(out pszHelpFile: widestring; varChild: OleVariant;
                          out pidTopic: Integer): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszHelpFile := FHelpPath;
        pidTopic := HelpContext;
        result := S_OK;//FAcc.Get_accHelpTopic(pszHelpFile, varChild,pidTopic );
    end
    else
    begin
        pszHelpFile := '';
        pidTopic := 0;
        result := S_OK;
    end;
end;


function TColorDrop.Get_accKeyboardShortcut(varChild: OleVariant; out pszKeyboardShortcut: widestring): HResult;
begin
    pszKeyboardShortcut := '';
    Result := S_OK;//FAcc.Get_accKeyboardShortcut(varChild, pszKeyboardShortcut);
end;

function TColorDrop.Get_accName(varChild: OleVariant; out pszName: widestring): HResult;
begin

    if varChild = CHILDID_SELF then
    begin
        pszName := FName;
        Result := S_OK;

    end
    else
    begin
        if VarChild - 1 <= Items.Count - 1 then
            pszName := Items[varChild - 1]
        else
            pszName := '';
        Result := S_OK;
    end;
end;

function TColorDrop.Get_accParent(out ppdispParent: IDispatch): HResult;
var
    ac: iaccessible;
    p: pointer;
begin
    if SUCCEEDED(AccessibleObjectFromWindow(self.Parent.Handle, OBJID_CLIENT, IID_IACCESSIBLE, p)) then
        begin
            ac := IAccessible(p);
            ppdispParent := ac;
            result := S_OK;
        end
    else
    begin
        ppdispParent := self;
        result := S_OK;
    end;
end;

function TColorDrop.Get_accRole(varChild: OleVariant; out pvarRole: OleVariant): HResult;
begin
    VariantInit(pvarRole);
    TVarData(pvarRole).VType := VT_I4;
    if varChild = CHILDID_SELF then
    begin
        TVarData(pvarRole).VInteger := ROLE_SYSTEM_COMBOBOX;
    end
    else
    begin
       TVarData(pvarRole).VInteger := ROLE_SYSTEM_LISTITEM;
    end;
   result := S_OK;
end;

function TColorDrop.accSelect(flagsSelect: Integer; varChild: OleVariant): HResult;

begin
    Result :=  S_OK;
    if varChild = CHILDID_SELF then
    begin
        if (flagsSelect <> SELFLAG_REMOVESELECTION) and (flagsSelect <> SELFLAG_NONE) then
            self.SetFocus;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
        begin
            Itemindex := -1;
        end;

    end;
    {else
    begin
        if ((flagsSelect and SELFLAG_TAKESELECTION) <> 0) then
        begin
            Itemindex := varChild - 1;

        end;
        if ((flagsSelect and SELFLAG_ADDSELECTION) <> 0) then
            Itemindex := varChild - 1;
        if ((flagsSelect and SELFLAG_REMOVESELECTION) <> 0) then
            Itemindex :=  - 1;
        if ((flagsSelect and SELFLAG_TAKEFOCUS) <> 0) then
            Itemindex := varChild - 1;
        if ((flagsSelect and SELFLAG_EXTENDSELECTION) <> 0) then
            Itemindex := varChild - 1;
    end;  }
end;


function TColorDrop.Get_accState(varChild: OleVariant; out pvarState: OleVariant): HResult;
const
  IsEnabled: array[Boolean] of Integer = (STATE_SYSTEM_UNAVAILABLE, 0);
  HasPopup: array[Boolean] of Integer = (0, STATE_SYSTEM_HASPOPUP);
  IsVisible: array[Boolean] of Integer = (STATE_SYSTEM_INVISIBLE, 0);
  IsChecked: array[Boolean] of Integer = (0, STATE_SYSTEM_CHECKED);
begin
    VariantInit(pvarState);
  TVarData(pvarState).VType := VT_I4;

  if varChild = CHILDID_SELF then
    begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE;
        if Enabled then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_NORMAL
        else
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_UNAVAILABLE;


        if self.Focused then
            TVarData(pvarState).VInteger := TVarData(pvarState).VInteger or STATE_SYSTEM_FOCUSED;
        Result := S_OK;//DISP_E_MEMBERNOTFOUND;//FAcc.Get_accState(varChild, pvarState);
    end
     else
     begin
        TVarData(pvarState).VInteger := STATE_SYSTEM_FOCUSABLE or STATE_SYSTEM_SELECTABLE;

        Result := S_OK;
     end;
end;

function TColorDrop.Get_accValue(varChild: OleVariant; out pszValue: widestring): HResult;
begin
    if varChild = CHILDID_SELF then
    begin
        pszValue := ColorToHex(FActiveColor);
        result := S_OK;
    end
    else
    begin
        pszValue := ColorToHex(FActiveColor);
        Result :=  S_OK;//FAcc.Get_accValue(varChild, pszValue);
    end;
end;

function TColorDrop.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TColorDrop.Set_accName(varChild: OleVariant; const pszName: widestring): HResult; stdcall;
begin
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        Caption := pszName;
    end
    else
    begin
        if (VarChild - 1) <= (Items.Count - 1) then
            Items[varChild - 1] := pszName;
        Result := S_OK;
    end;
end;



function TColorDrop.Set_accValue(varChild: OleVariant; const pszValue: widestring): HResult;
begin
  Result := E_NOTIMPL;
    if varChild = CHILDID_SELF then
    begin
        result := S_OK;
        if IsHEX(pszValue) then
          SetActiveColor(HexToColor(pszValue));
    end;
end;





procedure TColorDrop.WndProc(var Msg: TMessage);
begin
    if msg.Msg = WM_GETOBJECT then
    begin

        msg.result := LResultFromObject(IID_IACCESSIBLE, msg.wParam, self);
    end
    else
        inherited WndProc(Msg);
end;

constructor TColorDrop.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FOtherBtn := '&Others...';
    FFont := TFont.Create;
    if not Assigned(JColorPickFrm2) then
    begin
        JColorPickFrm2:=TJColorPickFrm2.Create(Application);
        SetWindowLong(JColorPickFrm2.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
        JColorPickFrm2.Close;
    end;

    Height :=22;
    Style:=csOwnerDrawFixed;
    FItems:=TStringList.Create;
    FItems.Add('1');
    OnDropDown := JCDropDown;
    FDropDnColor:=clBtnFace;
    Parent  := AOwner as TWinControl;
  FName := Caption;
end;

procedure TColorDrop.SetFont(Value: TFont);
begin
    FFont.Assign(Value);
    JColorPickFrm2.Font := FFont;
end;

procedure TColorDrop.SetOtherBtnCaption(Value: String);
begin
    FOtherBtn := Value;
    JColorPickFrm2.BtnOther.Caption := FOtherBtn;
end;

destructor TColorDrop.Destroy;
begin
    FItems.Free;
    FFont.Free;
    inherited Destroy;
end;
procedure TColorDrop.CreateWnd;
begin
    inherited CreateWnd;
    Items:=FItems;
    ItemIndex:=0;
end;

procedure TColorDrop.DrawItem(Index:Integer;Rect:TRect;State:TOwnerDrawState);
begin
    with Canvas do
    begin
        Brush.Style:=bsSolid;
        Brush.Color:=Color;
        FillRect(Rect);
        Pen.color:=clgray;
        Brush.Color:=FActiveColor;
        Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
    end;
end;

procedure TColorDrop.Drop;
begin
    JCDropDown(Self);
end;

procedure TColorDrop.JCDropDown(Sender:TObject);
var
    P: TPoint;
    hm: HMONITOR;
    monEx: TMonitorInfoEx;
    i: integer;
begin
    P.X:=0;
    P.Y:=Height;
    P:=ClientToScreen(P);
    for i := 0 to Screen.MonitorCount - 1 do
    begin


      GetMonitorInfo(Screen.Monitors[i].Handle, @monEx);
      hm := MonitorFromWindow(Handle, MONITOR_DEFAULTTONEAREST);
      if hm = Screen.Monitors[i].Handle then
      begin
        P.X := P.X - Screen.Monitors[i].Left;
        P.Y := P.Y - Screen.Monitors[i].Top;
      end;
    end;
    with JColorPickFrm2 do
    begin
        Color:=FDropDnColor;
        Left:=P.X;
        Top:=P.Y;
        AssignedCombo:=Self;

        Show;
        PickColor := Self.ActiveColor;
    end;
end;

procedure TColorDrop.SetActiveColor(Value:TColor);
begin
  if Value<>FActiveColor then
  begin
    FActiveColor:=Value;
    if Assigned(FOnChanged) then FOnChanged(Self);
    invalidate;
  end;
end;






function TJColorPickFrm2.GetConvColor(Color: TColor; BlendPer: Single; BlendColor: Boolean): TColor;
var
    R, G, B: Double;
    rR, rG, rB, BC: Integer;
    RGBColor : LongInt;
begin
    RGBColor := ColorToRGB(Color);
    If BlendColor then BC := 0
    else BC := 255;
    R := ($000000FF and RGBColor) + 0.0;
    G := ($0000FF00 and RGBColor) shr 8 + 0.0;
    B := ($00FF0000 and RGBColor) shr 16 + 0.0;
    rR := Round(R * BlendPer) + Round(BC * (1.0 - BlendPer));
    if rR > 255 then rR := 255;
    if rR < 0 then rR := 0;
    rG := Round(G * BlendPer) + Round(BC * (1.0 - BlendPer));
    if rG > 255 then rG := 255;
    if rG < 0 then rG := 0;
    rB := Round(B * BlendPer) + Round(BC * (1.0 - BlendPer));
    if rB > 255 then rB := 255;
    if rB < 0 then rB := 0;
    Result := StringToColor('$00' + IntToHex(rB, 2) + IntToHex(rG, 2) + IntToHex(rR, 2));
end;

procedure TJColorPickFrm2.SetPickColor(Value:TColor);
var
    i: integer;
    cBlendBlack: Boolean;
    sFocus: Boolean;
const
    ColorPerArray: array [0..9] of Single = (1.0, 0.75, 0.50, 0.25, 0.10, 0.85, 0.75, 0.50, 0.25, 0.10);
begin
    FPickColor:=Value;
    sFocus := False;
    for i := 0 to 55 do
    begin
        if arBtns[i].Color = FPickColor then
        begin
            (arBtns[i] as TAccClrBtn).SetFocus;
            sFocus := True;
            break;
        end;
    end;
    for i := 0 to 9 do
    begin
        if i < 5 then cBlendBlack := False
        else cBlendBlack := True;
        (arBtns2[i] as TAccClrBtn).Color:= GetConvColor(FPickColor, ColorPerArray[i], cBlendBlack);
        (arBtns2[i] as TAccClrBtn).InColor := (arBtns2[i] as TAccClrBtn).Color;
        (arBtns2[i] as TAccClrBtn).Hint := RGBToHex((arBtns2[i] as TAccClrBtn).Color, True);
        if (not sFocus) and (FPickColor = (arBtns2[i] as TAccClrBtn).Color) then
            (arBtns2[i] as TAccClrBtn).SetFocus;
    end;
end;
procedure TJColorPickFrm2.BtnOtherClick(Sender: TObject);
begin
    FDlgOpen := True;
    if ColorDialog1.Execute then
    begin
        FPickColor:=ColorDialog1.Color;
        AssignedCombo.ActiveColor:=FPickColor;
        Close;
    end;
    FDlgOpen := False;
end;

function TJColorPickFrm2.RGBtoHex(Color: TColor; ResIsRGB: Boolean = True): String;
var
    RGBColor : LongInt;
    R, G, B: Integer;
begin
    RGBColor := ColorToRGB(Color);
    R := ($000000FF and RGBColor);
    G := ($0000FF00 and RGBColor) shr 8;
    B := ($00FF0000 and RGBColor) shr 16;
    if ResIsRGB Then
        Result := '#' + IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2)
    else
        Result := '#' + IntToHex(B, 2) + IntToHex(G, 2) + IntToHex(R, 2);
end;

function DoubleToInt(d: double): integer;
begin
  SetRoundMode(rmUP);
  Result := Trunc(SimpleRoundTo(d));
end;

procedure TJColorPickFrm2.FormCreate(Sender: TObject);
var
    i: Integer;
    X,Y:Integer;
    cBlendBlack: Boolean;
const
  ColorPerArray: array [0..9] of Single = (1.0, 0.75, 0.50, 0.25, 0.10, 0.85, 0.75, 0.50, 0.25, 0.10);
begin
    FDlgOpen := False;
    Color := clBlack;
    clientWidth := 176;
    ClientHeight := 206;

    for i := 0 to 55 do
    begin
        arBtns[i] :=TAccClrBtn.Create(Self);
        with arBtns[i] do
        begin
        Parent:=Self;
        PickerColor:=Colors[i];
        Anchors:=[akBottom];
        OnClick:=BtnClick;
        TabOrder := i;
        Hint := RGBToHex(PickerColor, True);
        X:=5+(i mod 8)*(BtnW + 1);
        Y:=5+(BtnW + 1)*(i div 8);

        SetBounds(X,Y,BtnW,BtnW);
        end;
    end;
    for i := 0 to 9 do
    begin
        arBtns2[i] :=TAccClrBtn.Create(Self);
        with arBtns2[i] do
        begin
          Parent:=Self;
          if i < 5 then cBlendBlack := False
          else cBlendBlack := True;
          Color:= GetConvColor(FPickColor, ColorPerArray[i], cBlendBlack);
          //InColor := Btn.Color;
          Anchors:=[akBottom];
          OnClick:=PBtnClick;
          TabOrder := i + 56;
          Hint := RGBToHex(Color, True);
          X:=5+(i mod 5)*(BtnW + 1);
          Y:=160+(BtnW + 1)*(i div 5);

          SetBounds(X,Y,BtnW,BtnW);
        end;
    end;

    BtnOther.Left := arBtns2[4].Left + arBtns2[4].Width + 1;
    BtnOther.Top := 160;
    BtnOther.Width := BtnW * 3 + 2;
    BtnOther.Height := BtnW * 2 + 1;
end;

procedure TJColorPickFrm2.BtnClick(Sender:TObject);
begin
    FPickColor:=TAccClrBtn(Sender).PickerColor;
    AssignedCombo.ActiveColor:=FPickColor;
    Close;
end;

procedure TJColorPickFrm2.PBtnClick(Sender:TObject);
begin
    FPickColor:=TAccClrBtn(Sender).Color;
    AssignedCombo.ActiveColor:=FPickColor;
    Close;
end;

procedure TJColorPickFrm2.FormDeactivate(Sender: TObject);
begin
    if not FDlgOpen then JColorPickFrm2.Close;
end;

procedure TJColorPickFrm2.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27{Esc} then JColorPickFrm2.close;
end;

end.

