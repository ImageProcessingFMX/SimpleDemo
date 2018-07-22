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
  FMX.SpinBox;

type
  TForm2 = class( TForm )
    btn1 : TButton;
    memo1 : TMemo;
    img_analysis : TImage;
    btn2 : TButton;
    OutImage : TImage;
    btn3_alphaColor : TButton;
    spnbx1 : TSpinBox;
    btn3_RGB : TButton;
    btn_BlackWhite : TButton;
    dlgOpen1: TOpenDialog;
    procedure FormCreate( Sender : TObject );
    procedure btn1Click( Sender : TObject );
    procedure btn2Click( Sender : TObject );
    procedure btn3_alphaColorClick( Sender : TObject );
    procedure btn3_RGBClick( Sender : TObject );
    procedure btn_BlackWhiteClick(Sender: TObject);
    private
      procedure SingleChImage(
        Bit              : TBitmap;
        OpacityThreshold : integer );
      procedure SingleChannelImage(
        Bit : TBitmap;
        c   : integer );
      procedure BlackWhiteThresholdImage(
        Bit : TBitmap;
        c   : integer );
      { Private declarations }
    public
      { Public declarations }
      testbmp : TBitmap;
      bmpFilename : String ;
  end;

var
  Form2 : TForm2;

implementation

{$R *.fmx}

procedure TForm2.FormCreate( Sender : TObject );
  begin
    testbmp := TBitmap.Create;
  end;

procedure TForm2.btn1Click( Sender : TObject );
  begin

    if dlgOpen1.Execute then

       begin
            bmpFilename :=  dlgOpen1.FileName;

            img_analysis.Bitmap.LoadFromFile(bmpfilename);
       end;


    {$IFDEF FrameWork_VCL}
    memo1.Lines.Add( 'guess you are using VCL framework' );
    {$ENDIF}
    {$IFDEF FrameWork_FMX}
    memo1.Lines.Add( 'guess you are using FMX framework' );
    {$ENDIF}

  end;

procedure TForm2.btn2Click( Sender : TObject );
  begin
    testbmp.Assign( img_analysis.Bitmap );
    testbmp.Rotate( 180 );
    OutImage.Bitmap.Assign( testbmp );

  end;

procedure TForm2.btn3_alphaColorClick( Sender : TObject );
  begin
    testbmp.Assign( img_analysis.Bitmap );
    SingleChImage( testbmp, round( spnbx1.value ) );
    OutImage.Bitmap.Assign( testbmp );
  end;

procedure TForm2.btn3_RGBClick( Sender : TObject );
  begin
    testbmp.Assign( img_analysis.Bitmap );
    SingleChannelImage( testbmp, round( spnbx1.value ) );
    OutImage.Bitmap.Assign( testbmp );
  end;

Function GetPixel(
  i, j        : integer;
  bitdata     : TBitmapData;
  PixelFormat : TPixelFormat ) : TAlphaColor;
  begin

    result := PixelToAlphaColor( @PAlphaColorArray( bitdata.Data )
      [ j * ( bitdata.Pitch div PixelFormatBytes[ PixelFormat ] ) + 1 * i ],
      PixelFormat );
  end;

procedure SetPixel(
  color       : TAlphaColor;
  i, j        : integer;
  bitdata     : TBitmapData;
  PixelFormat : TPixelFormat );
  begin
    AlphaColorToPixel( color, @PAlphaColorArray( bitdata.Data )
      [ j * ( bitdata.Pitch div PixelFormatBytes[ PixelFormat ] ) + 1 * i ],
      PixelFormat );

  end;

procedure TForm2.SingleChImage(
  Bit              : TBitmap;
  OpacityThreshold : integer );
  var
    bitdata1 : TBitmapData;
    i : integer;
    j : integer;
    color : TAlphaColor;
  begin
    if ( Bit.Map( TMapAccess.maReadWrite, bitdata1 ) )
    then
      try
        for i := 0 to Bit.width - 1 do
          for j := 0 to Bit.height - 1 do
            begin
              begin
                color := GetPixel( i, j, bitdata1, Bit.PixelFormat );

                if TAlphaColorRec( color ).A < OpacityThreshold
                then
                  begin
                    TAlphaColorRec( color ).A := 0;

                    SetPixel( color, i, j, bitdata1, Bit.PixelFormat );
                  end;
              end;
            end;
      finally
        Bit.Unmap( bitdata1 );
      end;
  end;

procedure TForm2.SingleChannelImage(
  Bit : TBitmap;
  c   : integer );
  var
    bitdata1 : TBitmapData;
    i : integer;
    j : integer;
    color : TAlphaColor;
  begin
    if ( Bit.Map( TMapAccess.maReadWrite, bitdata1 ) )
    then
      try
        for i := 0 to Bit.width - 1 do
          for j := 0 to Bit.height - 1 do
            begin
              begin
                color := GetPixel( i, j, bitdata1, Bit.PixelFormat );

                case c of
                  1 :
                    begin
                      TAlphaColorRec( color ).B := 0;
                      TAlphaColorRec( color ).G := 0;
                    end;
                  2 :
                    begin
                      TAlphaColorRec( color ).R := 0;
                      TAlphaColorRec( color ).G := 0;
                    end;

                  3 :
                    begin
                      TAlphaColorRec( color ).B := 0;
                      TAlphaColorRec( color ).R := 0;
                    end;

                end;

                SetPixel( color, i, j, bitdata1, Bit.PixelFormat );

              end;
            end;
      finally
        Bit.Unmap( bitdata1 );
      end;
  end;

procedure TForm2.BlackWhiteThresholdImage(
  Bit : TBitmap;
  c   : integer );
  var
    bitdata1 : TBitmapData;
    i : integer;
    j : integer;
    color : TAlphaColor;
    Cquer : integer;
  begin
    if ( Bit.Map( TMapAccess.maReadWrite, bitdata1 ) )
    then
      try
        for i := 0 to Bit.width - 1 do
          for j := 0 to Bit.height - 1 do
            begin
              begin
                color := GetPixel( i, j, bitdata1, Bit.PixelFormat );

                Cquer := round( TAlphaColorRec( color ).B * 0.3 +
                  TAlphaColorRec( color ).R * 0.59 + TAlphaColorRec( color )
                  .G * 0.11 );

                if ( Cquer ) > c
                then
                  begin
                    TAlphaColorRec( color ).R := 255;
                    TAlphaColorRec( color ).G := 255;
                    TAlphaColorRec( color ).B := 255;
                  end
                else
                  begin
                    TAlphaColorRec( color ).R := 0;
                    TAlphaColorRec( color ).G := 0;
                    TAlphaColorRec( color ).B := 0;
                  end;

                SetPixel( color, i, j, bitdata1, Bit.PixelFormat );

              end;

            end;

      finally
        Bit.Unmap( bitdata1 );
      end;
  end;

procedure TForm2.btn_BlackWhiteClick(Sender: TObject);
begin
        testbmp.Assign( img_analysis.Bitmap );
   BlackWhiteThresholdImage( testbmp, round( spnbx1.value ) );
    OutImage.Bitmap.Assign( testbmp );
end;

end.
