object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 300
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    470
    300)
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 278
    Width = 34
    Height = 15
    Anchors = [akLeft, akBottom]
    Caption = 'Label1'
  end
  object gr_src: TDBGridEh
    Left = 8
    Top = 8
    Width = 193
    Height = 252
    Anchors = [akLeft, akTop, akBottom]
    DataSource = ds_src
    DragMode = dmAutomatic
    DynProps = <>
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleParams.MultiTitle = True
    TitleParams.RowLines = 3
    OnDragDrop = gr_srcDragDrop
    OnDragOver = gr_srcDragOver
    OnSelectionChanged = gr_srcSelectionChanged
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object gr_dest: TDBGridEh
    Left = 288
    Top = 8
    Width = 166
    Height = 252
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = ds_dest
    DragMode = dmAutomatic
    DynProps = <>
    TabOrder = 1
    OnDragDrop = gr_destDragDrop
    OnDragOver = gr_destDragOver
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object btnToSrcSel: TButton
    Left = 207
    Top = 41
    Width = 75
    Height = 25
    Caption = '<<'
    TabOrder = 2
  end
  object btnToDestSel: TButton
    Left = 207
    Top = 103
    Width = 75
    Height = 25
    Caption = '>>'
    TabOrder = 3
  end
  object btnToSrcAll: TButton
    Left = 207
    Top = 10
    Width = 75
    Height = 25
    Caption = '<<<<<'
    TabOrder = 4
  end
  object btnToDestAll: TButton
    Left = 207
    Top = 72
    Width = 75
    Height = 25
    Caption = '>>>>>'
    TabOrder = 5
  end
  object mds_src: TMemTableEh
    Params = <>
    BeforeScroll = mds_srcBeforeScroll
    AfterScroll = mds_srcAfterScroll
    Left = 88
    Top = 24
  end
  object mds_dest: TMemTableEh
    Params = <>
    BeforeScroll = mds_destBeforeScroll
    AfterScroll = mds_destAfterScroll
    Left = 376
    Top = 32
  end
  object ActList: TActionList
    Left = 232
    Top = 136
    object ActToDestSel: TAction
      Caption = 'ActToDestSel'
      OnExecute = ActToDestSelExecute
    end
    object ActToSrcSel: TAction
      Caption = 'ActToSrcSel'
      OnExecute = ActToSrcSelExecute
    end
    object ActToggle: TAction
      Caption = 'ActToggle'
    end
    object ActToDestAll: TAction
      Caption = 'ActToDestAll'
      OnExecute = ActToDestAllExecute
    end
    object ActToSrcAll: TAction
      Caption = 'ActToSrcAll'
      OnExecute = ActToSrcAllExecute
    end
  end
  object ds_src: TDataSource
    DataSet = mds_src
    Left = 96
    Top = 88
  end
  object ds_dest: TDataSource
    DataSet = mds_dest
    Left = 376
    Top = 96
  end
end
