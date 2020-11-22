-module(pizza).
-compile(export_all).


% accept two types only margherita and calzone. 
cook(PizzaType) ->
    case PizzaType of
        margherita ->
            timer:sleep(500);
        calzone ->
            timer:sleep(600)
    end.




pizzeria(OrdersList) ->
    register(client, self()),
    receive
        {order, ClientPid, Pizza} ->
            spawn_monitor(?MODULE, cook, [Pizza]);
        %{what_takes_so_long, ClientPid} -> 
        close -> 
            colse
    end.
 

open() ->
    Order = [],
    PizzaPid = spawn(?MODULE, pizzeria, [Order]),
    register(pizzeria, PizzaPid),
    true.



close() ->
    pizzeria ! close.


order(PizzaOrder) ->
    ClientPid = self(),
    pizzeria ! PizzaOrder.


where_is_my_pizza() ->
        Client = whereis(client).

