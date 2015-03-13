unit Interfaces;

interface

uses DB;

type
   IRegistroConvertido = interface(IInterface)
     procedure CarregaDoDataset(DataSet: TDataSet);
   end;

implementation

end.
