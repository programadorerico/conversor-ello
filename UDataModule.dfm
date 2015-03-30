object Datam1: TDatam1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 545
  Top = 320
  Height = 375
  Width = 734
  object sConnection: TEllConnection
    ConnectionName = 'IBLocal'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbexpint.dll'
    LoginPrompt = False
    Params.Strings = (
      'BlobSize=-1'
      'CommitRetain=False'
      'Database='
      'VarTemp='
      'DriverName=Interbase'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Password=masterkey'
      'RoleName=RoleName'
      'ServerCharSet='
      'SQLDialect=3'
      'Interbase TransIsolation=ReadCommited'
      'User_Name=sysdba'
      'WaitOnLocks=True')
    VendorLib = 'GDS32.DLL'
    Empresa = 0
    Left = 36
    Top = 16
  end
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=sete;' +
      'Mode=ReadWrite;'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 340
    Top = 92
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from CPPRAZO')
    Left = 189
    Top = 24
  end
  object QueryPesquisa: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      
        'SELECT S.RDB$FIELD_NAME       fName,                            ' +
        '                  S.RDB$FIELD_POSITION   fPosition              ' +
        '                                                                ' +
        '                                 FROM   RDB$RELATION_CONSTRAINTS' +
        ' C                                                 JOIN RDB$INDE' +
        'X_SEGMENTS S ON (S.RDB$INDEX_NAME = C.RDB$INDEX_NAME)  WHERE  C.' +
        'RDB$RELATION_NAME = '#39#39'  AND                                     ' +
        '         C.RDB$CONSTRAINT_TYPE = '#39'PRIMARY KEY'#39'                  ' +
        '           ORDER BY S.RDB$FIELD_POSITION                        ' +
        '                      ')
    SQLConnection = sConnection
    Left = 188
    Top = 136
  end
  object QueryTrabalho: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = sConnection
    Left = 188
    Top = 82
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection
    TableName = 'setor'
    Left = 40
    Top = 152
  end
  object OriginConnection: TEllConnection
    ConnectionName = 'IBConnection'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbexpint.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Interbase'
      'Database=c:\dev\dados\hf.fdb.ello'
      'RoleName=RoleName'
      'User_Name=sysdba'
      'Password=masterkey'
      'ServerCharSet='
      'SQLDialect=1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'BlobSize=-1'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'Interbase TransIsolation=ReadCommited'
      'Trim Char=False')
    VendorLib = 'GDS32.DLL'
    Empresa = 0
    Left = 324
    Top = 24
  end
  object ProdutosConnection: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\dev\dados\Casara' +
      'o\Base\ESTOQUE.MDB;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 588
    Top = 20
  end
  object ClientesConnection: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=C:\de' +
      'v\dados\Casarao\Base\CLIENTES.MDB;Mode=ReadWrite;Persist Securit' +
      'y Info=False;Jet OLEDB:System database="";Jet OLEDB:Registry Pat' +
      'h="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet ' +
      'OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=' +
      '2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Pa' +
      'ssword="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encry' +
      'pt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False;J' +
      'et OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=Fals' +
      'e;'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 588
    Top = 76
  end
end
