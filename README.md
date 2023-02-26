# AsyncProcList

#### uses dlAsyncProcList;

---
`AsyncProcList.Add(TAsyncObject.Create(
  procedure
  begin
    ...
  end)
 );`
 
 ---
 Use wm_... for return completed procedure
 
 ---
 AsyncProcList.Add(TAsyncObject.Create(
   procedure
   begin
     ...
   end,
   Handle,
   WM...
 );
 
 ---
 ...
 procedure OnCompleted(var Msg: TMessage); message WM_...;
