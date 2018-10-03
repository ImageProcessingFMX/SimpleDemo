unit Unit_Imageprocessing_functions;

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

procedure AlphaColorImage(
  Bit              : TBitmap;
  OpacityThreshold : integer );

procedure BlackWhiteThresholdImage(
  Bit : TBitmap;
  c   : integer );

procedure SingleColorChannelImage(
  Bit : TBitmap;
  c   : integer );

Function GetPixel(
  i, j        : integer;
  bitdata     : TBitmapData;
  PixelFormat : TPixelFormat ) : TAlphaColor;
procedure SetPixel(
  color       : TAlphaColor;
  i, j        : integer;
  bitdata     : TBitmapData;
  PixelFormat : TPixelFormat );

implementation

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

procedure AlphaColorImage(
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

procedure SingleColorChannelImage(
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

procedure BlackWhiteThresholdImage(
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

end.
