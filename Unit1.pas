unit Unit1;
{
There are so many possible ways to implement this import.
Even just reading the file, I could have assumed the worst and read it as a binary file.
Or read it as a normal file, and handled the deliminations and error trapping.
I could have built in reading from the web, or svn, I suppose.
I've gone for a neat, if limited use, TStringList read from file.

V2:
So for each route, an object is created that can be referenced later.
The Companies themselves could have been created as Company objects.
The structure could be extended, for stops, times, costs, drivers.
We could have added images to the tree.

Could have added a ProgressBar, or an option to cancel mid process.
Or far more enhaned error handling / messaging.

I may also have cheated, by holding the top three nodes as private variables,
rather than looking for them each time.
And the ListBox was simply for debugging, easy to remove.

Note, I have also not included any unit testing.

Morris Evans
30/08/22
}


interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus,
  Vcl.Buttons;

type
  TfrmImportFile = class(TForm)
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    TreeView1: TTreeView;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    mnuImport: TMenuItem;
    lblImportFile: TLabel;
    edtImportFile: TEdit;
    btnBrowse: TBitBtn;
    btnImport: TBitBtn;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
  private
    { Private declarations }
    WeekNode, SatNode, SunNode : TTreeNode;
    procedure AddTopNodes;
    procedure AddToNode(iTop : integer; strCompany, strRoute, strDays : string);
    function FindCompany(topNode : TTreeNode; strCompany : string) : TTreeNode;
    function NodePosition(aNode : TTreeNode) : integer;
  public
    { Public declarations }
  end;

var
  frmImportFile: TfrmImportFile;

implementation

{$R *.dfm}

uses Unit2;

//Locate the import file:
procedure TfrmImportFile.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edtImportFile.Text := OpenDialog1.FileName;

end;

//Main process of file:
procedure TfrmImportFile.btnImportClick(Sender: TObject);
var
  fileData : TStringList;
  sArray : TArray<string>;
  strLine, strRoute, strCompany, strDays : String;
  lines, i : Integer;
begin
  if treeView1.Items.Count > 3 then
  begin
    if MessageDlg('Clear existing ?',mtConfirmation, [mbYes,mbNo],0) = mrYes then
    begin
       TreeView1.Items.Clear;
       AddTopNodes;
    end;
  end;

  //prevent double hit
  btnImport.Enabled := false;
  treeView1.Items.BeginUpdate;

  fileData := TStringList.Create;       // Create the TSTringList object
  fileData.QuoteChar := '"';
  try
    try
      fileData.LoadFromFile(edtImportFile.Text);    // Load from Testing.txt file

      lines := fileData.Count;

      for i := 0 to lines-1
      do
      begin
        strLine := fileData[i];
        sArray := strLine.Split([','],'"');
        //(',');
        strCompany := sArray[0].DeQuotedString('"');
        strRoute := sArray[1].DeQuotedString('"');
        strDays := sArray[2].DeQuotedString('"');

        ListBox1.AddItem(strCompany,nil);
        ListBox1.AddItem(strRoute,nil);
        ListBox1.AddItem(strDays,nil);

        if (Pos('1',strDays.Substring(0,5)) > 0 ) then //Weekday
        begin
            AddToNode(0, strCompany, strRoute, strDays);
            ListBox1.AddItem('Weekday', nil);
        end;
        if (strDays.Substring(5,1) = '1') then
        begin
            AddToNode(1, strCompany, strRoute, strDays);
            ListBox1.AddItem('Sat', nil);
        end;
        if (strDays.Substring(6,1) = '1') then   // Sunday
        begin
            AddToNode(2, strCompany, strRoute, strDays);
            ListBox1.AddItem('Sun', nil);
        end;
      end;
    except on E: Exception do
      ShowMessage(e.Message);
    end;
  finally
    fileData.free;
    treeView1.Items.EndUpdate;
    btnImport.Enabled := true;
  end;
end;

//Add a record to the tree:
procedure TfrmImportFile.About1Click(Sender: TObject);
begin
     ShowMessage('Created by Morris Evans.');
end;

procedure TfrmImportFile.AddToNode(iTop : integer; strCompany, strRoute, strDays : string);
var nodeTop, nodeCompany : TTreeNode;
  ThisRoute: TRoute;
begin
  case iTop of
   0 : nodeTop := WeekNode;
   1 : nodeTop := SatNode;
   2 : nodeTop := SunNode;
  else
    raise Exception.Create('Unknown group');
  end;
  // locate the company under the top node.
  nodeCompany := FindCompany(nodeTop, strCompany);
  if nodeCompany = nil then
    nodeCompany := TreeView1.Items.AddChild(nodeTop, strCompany);
  //then add the route
//  TreeView1.Items.AddChild(nodeCompany, strRoute);

  ThisRoute := TRoute.Create();
  ThisRoute.RouteName := strRoute;
  ThisRoute.OperatorName := strCompany;
  ThisRoute.DaysOfWeek := strDays;

  TreeView1.Items.AddChildObject(nodeCompany, strRoute, ThisRoute);

end;

//Locate existing company record for the day selection
function TfrmImportFile.FindCompany(topNode : TTreeNode; strCompany : string) : TTreeNode;
var i : integer;
    resultNode : TTreeNode;
begin
  resultNode := nil;
  for i := NodePosition(topNode)+1 to treeView1.items.Count-1 do
  begin
    if (treeview1.items[i].Parent <> topNode) AND
       ( (treeview1.items[i].Parent = WeekNode) OR
         (treeview1.items[i].Parent = SatNode) OR
         (treeview1.items[i].Parent = SunNode) )
       then break;
    if treeview1.items[i].Text = strCompany then
    begin
      resultNode := treeview1.items[i];
      break;
    end;
  end;
  Result := resultNode;
end;

//Locate the position of a node in the tree
function TfrmImportFile.NodePosition(aNode : TTreeNode) : integer;
var i : integer;
begin
  result := 0;
  for i := 0 to treeView1.items.Count-1 do
  begin
    if treeview1.items[i] = aNode then
    begin
      result := i;
      break;
    end;
  end;
end;


procedure TfrmImportFile.TreeView1DblClick(Sender: TObject);
var i : integer;
begin
    if assigned(TreeView1.Selected.Data) then
      ShowMessage( 'Operator : ' + TRoute(TreeView1.Selected.Data).OperatorName  + #13#10 +
                   'Route:' + TRoute(TreeView1.Selected.Data).RouteName + #13#10 +
                   'Days :' + TRoute(TreeView1.Selected.Data).DaysOfWeek );
end;

procedure TfrmImportFile.Exit1Click(Sender: TObject);
begin
    Close;
end;

//Tidy up any objects created:
procedure TfrmImportFile.FormClose(Sender: TObject; var Action: TCloseAction);
var i : integer;
begin
//
  for i := 0 to treeview1.Items.Count-1 do
    if assigned(treeview1.Items[i].Data) then
      FreeAndNil(treeview1.Items[i].Data);
end;

//Initialise
procedure TfrmImportFile.FormCreate(Sender: TObject);
begin
//
  AddTopNodes;
end;

procedure TfrmImportFile.AddTopNodes;
begin
  WeekNode := TreeView1.Items.add(nil,'Monday - Friday');
  SatNode := TreeView1.Items.add(nil,'Saturday');
  SunNode := TreeView1.Items.add(nil,'Sunday');
end;

end.
