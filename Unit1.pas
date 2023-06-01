unit Unit1;

interface

uses
  Winapi.Windows
  , Winapi.Messages
  , System.SysUtils
  , System.Variants
  , System.Classes
  , Vcl.Graphics
  , Vcl.Controls
  , Vcl.Forms
  , Vcl.Dialogs
  , DBGridEhGrouping
  , ToolCtrlsEh
  , DBGridEhToolCtrls
  , DynVarsEh
  , MemTableDataEh
  , Data.DB
  , System.Actions
  , Vcl.ActnList
  , Vcl.StdCtrls
  , MemTableEh
  , EhLibVCL
  , GridsEh
  , DBAxisGridsEh
  , DBGridEh
  ;

type
  TRoamingRecType = (rrtSelected, rrtAll);

  TForm1 = class(TForm)
    gr_src: TDBGridEh;
    gr_dest: TDBGridEh;
    mds_src: TMemTableEh;
    mds_dest: TMemTableEh;
    btnToSrcSel: TButton;
    btnToDestSel: TButton;
    ActList: TActionList;
    ds_src: TDataSource;
    ds_dest: TDataSource;
    ActToDestSel: TAction;
    ActToSrcSel: TAction;
    ActToggle: TAction;
    Label1: TLabel;
    btnToSrcAll: TButton;
    btnToDestAll: TButton;
    ActToDestAll: TAction;
    ActToSrcAll: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActToDestSelExecute(Sender: TObject);
    procedure ActToSrcSelExecute(Sender: TObject);
    procedure gr_srcSelectionChanged(Sender: TObject);
    procedure ActToDestAllExecute(Sender: TObject);
    procedure ActToSrcAllExecute(Sender: TObject);
    procedure mds_srcAfterScroll(DataSet: TDataSet);
    procedure mds_destAfterScroll(DataSet: TDataSet);
    procedure mds_srcBeforeScroll(DataSet: TDataSet);
    procedure mds_destBeforeScroll(DataSet: TDataSet);
    procedure gr_srcDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure gr_srcDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure gr_destDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure gr_destDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    FAllowScroll: Boolean;
    procedure MoveSelectedRows(GridSource, GridDestin: TDBGridEh; RoamingRec: TRoamingRecType = rrtSelected);
    procedure GetBtnStatus;
  public
    property AllowScroll: Boolean read FAllowScroll;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ActToSrcAllExecute(Sender: TObject);
begin
  MoveSelectedRows(gr_dest,gr_src, rrtAll);
  GetBtnStatus;
end;

procedure TForm1.ActToSrcSelExecute(Sender: TObject);
begin
  if (gr_dest.SelectedRows.Count = 0) then gr_dest.SelectedRows.CurrentRowSelected:= True;

  MoveSelectedRows(gr_dest,gr_src, rrtSelected);
  GetBtnStatus;
end;

procedure TForm1.ActToDestAllExecute(Sender: TObject);
begin
  MoveSelectedRows(gr_src,gr_dest, rrtAll);
  GetBtnStatus;
end;

procedure TForm1.ActToDestSelExecute(Sender: TObject);
begin
  if (gr_src.SelectedRows.Count = 0) then gr_src.SelectedRows.CurrentRowSelected:= True;
  MoveSelectedRows(gr_src,gr_dest, rrtSelected);
  GetBtnStatus;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DBGridEhCenter.UseExtendedScrollingForMemTable:= False;
  FAllowScroll:= False;

  with mds_src do
  begin
    FieldDefs.Add('No', ftInteger);
    FieldDefs.Add('SomeString', ftString, 15);
    CreateDataSet;
    Filtered := False;
    Active := False;
  end;

  with mds_dest do
  begin
    FieldDefs.Add('No', ftInteger);
    FieldDefs.Add('SomeString', ftString, 15);
    CreateDataSet;
    Filtered := False;
    Active := False;
  end;

  gr_src.Options:= gr_src.Options + [dgRowSelect, dgAlwaysShowSelection, dgMultiSelect];
  gr_dest.Options:= gr_dest.Options + [dgRowSelect, dgAlwaysShowSelection, dgMultiSelect];
  gr_src.DragMode:= TDragMode.dmAutomatic;
  gr_dest.DragMode:= TDragMode.dmAutomatic;
  gr_src.OddRowColor:= clBtnFace;
  gr_dest.EvenRowColor:= clBtnFace;
//  gr_src.TitleFont.Color:= clHotLight;
  gr_src.TitleParams.Color:= clBtnFace;
//  gr_src.TitleParams.BorderInFillStyle:= True;
  gr_src.TitleParams.Font.Color:= clHotLight;
  gr_src.Flat:= True;

  btnToDestSel.OnClick:= ActToDestSelExecute;
  btnToDestAll.OnClick:= ActToDestAllExecute;
  btnToSrcSel.OnClick:= ActToSrcSelExecute;
  btnToSrcAll.OnClick:= ActToSrcAllExecute;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  I: Integer;
begin
  mds_src.Active:= True;
  mds_dest.Active:= True;

  for I := 0 to 10 do
  mds_src.AppendRecord([i,'строка_' + IntToStr(i)]);

  mds_dest.AppendRecord([1,'строка_11']);

  GetBtnStatus;
  FAllowScroll:= True;
end;

procedure TForm1.GetBtnStatus;
begin
  ActToSrcSel.Enabled:= not mds_dest.IsEmpty;
  ActToSrcAll.Enabled:= not mds_dest.IsEmpty;
  btnToSrcSel.Enabled:= ActToSrcSel.Enabled;
  btnToSrcAll.Enabled:= ActToSrcSel.Enabled;

  ActToDestSel.Enabled:= not mds_src.IsEmpty;
  ActToDestAll.Enabled:= not mds_src.IsEmpty;
  btnToDestSel.Enabled:= ActToDestSel.Enabled;
  btnToDestAll.Enabled:= ActToDestSel.Enabled;
end;

procedure TForm1.gr_destDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if mds_src.IsEmpty then Exit;

  if (gr_src.SelectedRows.Count = gr_src.DataRowCount)
    then //все записи
      MoveSelectedRows(gr_src,gr_dest, rrtAll)
    else //выбранные
      MoveSelectedRows(gr_src,gr_dest, rrtSelected);

  GetBtnStatus;
end;

procedure TForm1.gr_destDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:= (Source = gr_src);
end;

procedure TForm1.gr_srcDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if mds_dest.IsEmpty then Exit;

  if (gr_dest.SelectedRows.Count = gr_dest.DataRowCount)
    then //все записи
      MoveSelectedRows(gr_dest,gr_src, rrtAll)
    else //выбранные
      MoveSelectedRows(gr_dest,gr_src, rrtSelected);

  GetBtnStatus;
end;

procedure TForm1.gr_srcDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:= (Source = gr_dest);
end;

procedure TForm1.gr_srcSelectionChanged(Sender: TObject);
begin
  Caption:= IntToStr(gr_src.SelectedRows.Count);
  Caption:= Format('SelectedRows.Count: %d | Grid.DataRowCount: %d | Grid.RowLines: %d',
                  [gr_src.SelectedRows.Count,
                   gr_src.DataRowCount,
                   gr_src.RowLines]);
end;

procedure TForm1.mds_destAfterScroll(DataSet: TDataSet);
begin
//  if not AllowScroll then Exit;
//
//  mds_dest.DisableControls;
//  try
//    if mds_dest.IsEmpty
//      then
//        begin
//          if gr_src.CanFocus then gr_src.SetFocus;
//          gr_src.SelectedRows.CurrentRowSelected:= True;
//        end
//      else
//        begin
//          if gr_dest.CanFocus then gr_dest.SetFocus;
//          gr_dest.SelectedRows.CurrentRowSelected:= True;
//        end;
//  finally
//    mds_dest.EnableControls;
//  end;
end;

procedure TForm1.mds_destBeforeScroll(DataSet: TDataSet);
begin
//  if not AllowScroll then Exit;
//  gr_dest.SelectedRows.CurrentRowSelected:= False;
end;

procedure TForm1.mds_srcAfterScroll(DataSet: TDataSet);
begin
//  if not AllowScroll then Exit;
//
//  mds_src.DisableControls;
//  try
//    if mds_src.IsEmpty
//      then
//        begin
//          if gr_dest.CanFocus then gr_dest.SetFocus;
//          gr_dest.SelectedRows.CurrentRowSelected:= True;
//        end
//      else
//        begin
//          if gr_src.CanFocus then gr_src.SetFocus;
//          gr_src.SelectedRows.CurrentRowSelected:= True;
//        end;
//  finally
//    mds_src.EnableControls;
//  end;
end;

procedure TForm1.mds_srcBeforeScroll(DataSet: TDataSet);
begin
//  if not AllowScroll then Exit;
//  gr_src.SelectedRows.CurrentRowSelected:= False;
end;

procedure TForm1.MoveSelectedRows(GridSource, GridDestin: TDBGridEh; RoamingRec: TRoamingRecType);
var
  i, j: Integer;
begin
  if TDBGridEh(GridSource).DataSource.DataSet.IsEmpty then Exit;

//  FAllowScroll:= False;
  try
    TDBGridEh(GridSource).DataSource.DataSet.DisableControls;
    TDBGridEh(GridDestin).DataSource.DataSet.DisableControls;
//    TDBGridEh(GridSource).SaveBookmark;

    case RoamingRec of
      rrtSelected://выбранные записи
        begin
          TDBGridEh(GridSource).SaveBookmark;
          for i := 0 to Pred(TDBGridEh(GridSource).SelectedRows.Count)do
          begin
            TDBGridEh(GridSource).DataSource.DataSet.Bookmark := TDBGridEh(GridSource).SelectedRows[i];
            TDBGridEh(GridDestin).DataSource.DataSet.Append;
            TDBGridEh(GridDestin).DataSource.DataSet.Edit;

            for j := 0 to Pred(TDBGridEh(GridDestin).DataSource.DataSet.FieldCount) do
              TDBGridEh(GridDestin).DataSource.DataSet.Fields[j].Value := TDBGridEh(GridSource).DataSource.DataSet.Fields[j].Value;
            TDBGridEh(GridDestin).DataSource.DataSet.Post;
            TDBGridEh(GridSource).DataSource.DataSet.Delete;
          end;

          TDBGridEh(GridSource).RestoreBookmark;

//          if not TDBGridEh(GridSource).DataSource.DataSet.IsEmpty
//            then
//              begin
//                if TDBGridEh(GridSource).CanFocus then TDBGridEh(GridSource).SetFocus;
////                TDBGridEh(GridSource).SelectedRows.CurrentRowSelected:= True;
//              end
//            else
//              begin
//                if TDBGridEh(GridDestin).CanFocus then TDBGridEh(GridDestin).SetFocus;
////                TDBGridEh(GridDestin).SelectedRows.CurrentRowSelected:= True;
//              end;
        end;
      rrtAll://все записи
        begin
          for i := 0 to Pred(TDBGridEh(GridSource).DataSource.DataSet.RecordCount) do
          begin
            TDBGridEh(GridDestin).DataSource.DataSet.Append;
            TDBGridEh(GridDestin).DataSource.DataSet.Edit;

            for j := 0 to Pred(TDBGridEh(GridDestin).DataSource.DataSet.FieldCount) do
              TDBGridEh(GridDestin).DataSource.DataSet.Fields[j].Value :=
                                    TDBGridEh(GridSource).DataSource.DataSet.Fields[j].Value;
            TDBGridEh(GridDestin).DataSource.DataSet.Post;
            TDBGridEh(GridSource).DataSource.DataSet.Delete;
          end;

          if TDBGridEh(GridSource).DataSource.DataSet.IsEmpty then
            if TDBGridEh(GridDestin).CanFocus then
            begin
              TDBGridEh(GridDestin).SetFocus;
              TDBGridEh(GridDestin).SelectedRows.CurrentRowSelected:= True;
            end;
        end;
    end;
  finally
//    TDBGridEh(GridSource).RestoreBookmark;
    TDBGridEh(GridDestin).DataSource.DataSet.EnableControls;
    TDBGridEh(GridSource).DataSource.DataSet.EnableControls;
//    TDBGridEh(GridDestin).DataSource.DataSet.Refresh;
//    TDBGridEh(GridSource).DataSource.DataSet.Refresh;
//  FAllowScroll:= True;
  end;
end;

end.
