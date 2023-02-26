# AsyncProcList

Пример:

```pascal

uses dlAsyncProcList;

//Выполнение процедуры
AsyncProcList.Add(
  TAsyncObject.Create(
    procedure (out AData: Pointer)
    begin
      //code
    end,
    nil //callback proc
  );

Для оповещения завершения выполнения через Windows Messages
AsyncProcList.Add(
  TAsyncObject.Create(
    procedure (out AData: Pointer)
    begin
      //code
    end,
    Handle,
    WM...)
);

```
