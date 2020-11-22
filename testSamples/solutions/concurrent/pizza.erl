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
        {order, Client, Pizza} ->
           {Ref, Client} = spawn_monitor(?MODULE, cook, [Pizza]),
           OrderList = [{Ref, Client}];

        {'DOWN', order, Ref,  _Client, Pizza} ->
            io:format("Pizza delivered~p~n");

        {what_takes_so_long, _Client, Pizza} 
                -> {cooking, Pizza};

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
    Client = self(),
    pizzeria ! {order, Client, PizzaOrder}.


where_is_my_pizza() ->
        Client = self(),
        pizzeria ! {what_takes_so_long, Client, 'margherita'}.


