# AsyncProcList

Пример:

```pascal

uses dlAsyncProcList;

//Выполнение процедуры, без callback функции
AsyncProcList.Add(
  TAsyncObject.Create(
    procedure (out AData: Pointer)
    begin
      //code
    end,
    nil //callback proc
  );

//С использованием Windows Messages
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
