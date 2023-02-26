# AsyncProcList

Пример:

```pascal

uses dlAsyncProcList;

//Выполнение процедуры
AsyncProcList.Add(TAsyncObject.Create(
  procedure
  begin
    ...
  end)
);

Для оповещения завершения выполнения через Windows Messages
AsyncProcList.Add(TAsyncObject.Create(
  procedure
  begin
    ...
  end,
  Handle,
  WM...
);

```
