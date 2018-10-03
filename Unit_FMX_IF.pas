unit Unit_FMX_IF;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ScrollBox,
  FMX.Utils,
  FMX.Memo,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Edit,
  FMX.EditBox,
  FMX.SpinBox,
  Unit_Imageprocessing_functions;

type
  TFMXImageProcessinForm = class( TForm )
    btn_Load : TButton;
    memo1 : TMemo;
    btn2 : TButton;
    btn3_alphaColor : TButton;
    spnbx_parameter1: TSpinBox;
    btn3_RGB : TButton;
    btn_BlackWhite : TButton;
    dlgOpen1 : TOpenDialog;
    pnl1 : TPanel;
    img_analysis : TImage;
    OutImage : TImage;
    Label1: TLabel;
    procedure FormCreate( Sender : TObject );
    procedure btn_LoadClick( Sender : TObject );
    procedure btn2Click( Sender : TObject );
    procedure btn3_alphaColorClick( Sender : TObject );
    procedure btn3_RGBClick( Sender : TObject );
    procedure btn_BlackWhiteClick( Sender : TObject );
    private

      { Private declarations }
    public
      { Public declarations }
      testbmp : TBitmap;
      bmpFilename : String;
  end;

var
  FMXImageProcessinForm : TFMXImageProcessinForm;

implementation

{$R *.fmx}

procedure TFMXImageProcessinForm.FormCreate( Sender : TObject );
  begin
    testbmp := TBitmap.Create;
  end;

procedure TFMXImageProcessinForm.btn_LoadClick( Sender : TObject );
  begin

    if dlgOpen1.Execute
    then

      begin
        bmpFilename := dlgOpen1.FileName;

        img_analysis.Bitmap.LoadFromFile( bmpFilename );

        memo1.Lines.Add( 'Image file name : ' + bmpFilename );

        memo1.Lines.Add( 'Bitmap Width x Height  : ' + img_analysis.Bitmap.Width.ToString + ' x' + img_analysis.Bitmap.Height.ToString + 'pixel' );

      end;

    {$IFDEF FrameWork_VCL}
    memo1.Lines.Add( 'guess you are using VCL framework' );
    {$ENDIF}
    {$IFDEF FrameWork_FMX}
    memo1.Lines.Add( 'guess you are using FMX framework' );
    {$ENDIF}
  end;

procedure TFMXImageProcessinForm.btn2Click( Sender : TObject );
var  rotMode : Integer  ;
  begin
   memo1.Lines.Add( 'rotate the image ...' );

    testbmp.Assign( img_analysis.Bitmap );

    rotMode := Round( spnbx_parameter1.Value ) ;
    case rotMode  of
    0:  testbmp.Rotate( 0 );
    1:  testbmp.Rotate( 90 );
    2:  testbmp.Rotate( 180 );
    3:  testbmp.Rotate( 270 );
    else
        testbmp.Rotate( 0 );
    end;

    OutImage.Bitmap.Assign( testbmp );

  end;

procedure TFMXImageProcessinForm.btn3_alphaColorClick( Sender : TObject );
  begin
      memo1.Lines.Add( 'adjust alpha color image ...' );
    testbmp.Assign( img_analysis.Bitmap );
    AlphaColorImage( testbmp, round( spnbx_parameter1.value ) );
    OutImage.Bitmap.Assign( testbmp );
  end;

procedure TFMXImageProcessinForm.btn3_RGBClick( Sender : TObject );
  begin
     memo1.Lines.Add( 'select RGB channel  [Value 1...3]' );
    testbmp.Assign( img_analysis.Bitmap );
    SingleColorChannelImage( testbmp, round( spnbx_parameter1.value ) );
    OutImage.Bitmap.Assign( testbmp );
  end;

procedure TFMXImageProcessinForm.btn_BlackWhiteClick( Sender : TObject );
  begin
    memo1.Lines.Add( 'set image threshold  [Value 0...255]' );
    testbmp.Assign( img_analysis.Bitmap );
    BlackWhiteThresholdImage( testbmp, round( spnbx_parameter1.value ) );
    OutImage.Bitmap.Assign( testbmp );
  end;

end.
