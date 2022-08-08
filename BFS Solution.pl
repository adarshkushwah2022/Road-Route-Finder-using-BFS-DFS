:-dynamic(distance_Gen/3).
:-dynamic(heuristics/3).
:-[depth].

heuristic_creater_function:-csv_read_file('C:/Users/SPEED/OneDrive/Desktop/MyWork/heuristic_data.csv',Rows1,[functor(heuristic_data), arity(48)]),
maplist(assert, Rows1),
setof([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV],
heuristic_data(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV), AZ),nl,
get_header(AZ).


head_initializer([H|_],H).

head_deallocator([_|T],T).

get_header(Data):-
head_initializer(Data,H),
head_deallocator(Data,NewData),
head_deallocator(H,Header),
multi_place_printer(NewData,Header).

get_distances([Cityname|Distances],Cityname,Distances).

place_predicate(_,[]).
place_predicate([City1name|[CurDist|OtherDist]],[City2name|Tcity2]):-
asserta(heuristics(City1name,City2name,CurDist)),
asserta(heuristics(City2name,City1name,CurDist)),
place_predicate([City1name|OtherDist],Tcity2).


single_place_printer([H|_],Distances):-
place_predicate(H,Distances).

multi_place_printer([],_):-
write('').

multi_place_printer([H|T],Distances):-
place_predicate(H,Distances),
multi_place_printer(T,Distances).

%driver function
main:-
write('Enter Source City Of Your Choice:'),
read(City1),
write('Enter Destination City Of Your Choice:'),
read(City2),
%giving choice to the user for selecting path finding technique
write('Enter 1 for Implementing Depth First Search'),nl,
write('Enter 2 for Implementing Best First Search'),nl,
read(X),
display_methods(X,City1,City2).

%start implementing through DFS
display_methods(1,City1,City2):-
write('Finding Path Through Depth First Search:'),nl,nl,
find_dfs(City1,City2).

%start implementing through BFS
display_methods(2,City1,City2):-
write('Finding Path Through Best First Search'),nl,nl,
path_evaluator(City1,City2).

%start evaluating through current node in BFS
path_evaluator(Main,Target):-
closed_my_stackk(Closed),
my_stackk_open(Open),
heuristics(Main,Target,H),
state_insert_in_open([Main,nil,0,H],Open,New_open),
recursive_search(New_open,Closed,Target).

closed_my_stackk([]).

my_stackk_open([]).

path_printer_reverse(S) :-
empty_my_stackk(S).

path_printer_reverse(S) :-
my_stack([St,_,_,_], _, S),
write(St), nl.

empty_my_stackk([]).

my_stack(Main,Es,[Main|Es]).

%in case if none child can provide path
recursive_search(Open,_,_):-
my_stackk_open(Open),
write('Sorry,Cannot Find Any Path.'),nl.

%recursivly search in child nodes if present
recursive_search(Open,Closed,Target):-
open_pop_operation([Cur_St,Par,Cb,_],Open,_),
Cur_St=Target,
write('Finding Path:'),nl,
final_path_printer([Cur_St, Par,_, _],Closed),
open_pop_operation([Last_St,_,Cost,_],Closed,_),
distance_gen(Last_St,Target,X),
_ is X + Cost,nl,
write('Evaluated Cost Of The Path:'),nl,
print(Cb),!.

recursive_search(Open,Closed,Target):-
open_pop_operation([Cur_St,Par,D,H],Open,New_open),
search_child_nodes([Cur_St,Par,D,H],New_open,Closed,Children,Target),
list_insert_in_open(Children,New_open,Uo),
close_insertion([[Cur_St,Par,D,H]],Closed,New_closed),
recursive_search(Uo,New_closed,Target),!.


search_child_nodes([Par_node,_,Par_dist, _],Uo,Uc,Children,Target) :-
findall(Child, find_child([Par_node,_,Par_dist, _],Uo, Uc, Child,Target),Children).

find_child([Par_node,_,Par_dist, _],Uo,Uc,[Next,Par_node,New_Dist,H], Target) :-
distance_gen(Par_node,Next,Dist),
not(member_in_open([Next,_,_,_],Uo)),
not(member_in_close([Next,_,_, _],Uc)),
New_Dist is Par_dist + Dist ,
heuristics(Next, Target, H).

comparator([_,_,_,H1], [_,_,_,H2]):-
	H1=<H2.

%open stack and close stack functions

state_insert_in_open(Cur_St,[],[Cur_St]):-!.

state_insert_in_open(Cur_St,[H|T],[Cur_St,H|T]):-
comparator(Cur_St,H).

state_insert_in_open(Cur_St,[H|T],[H|T1]):-
state_insert_in_open(Cur_St,T,T1).

list_insert_in_open([],L,L).

list_insert_in_open([St|T],L,Lnew):-
state_insert_in_open(St,L,Lmid),
list_insert_in_open(T,Lmid,Lnew).

member_in_open(St,Open):-
membe(St,Open).

member_in_close(St,Closed):-
membe(St,Closed).

not_in_set_addition(X, S, S) :-
membe(X, S),!.

not_in_set_addition(X, S, [X | S]).

close_insertion([], S, S).

close_insertion([H | T], S, SN) :-
close_insertion(T, S, S2),
not_in_set_addition(H, S2, SN),!.

open_pop_operation(E, [E | T], T).

open_pop_operation(E, [E | _], _).

membe(X, [X | _]).

membe(X, [_ | T]) :- membe(X, T).

final_path_printer([St, nil,_, _], _) :-
write(St), nl,!.

final_path_printer([St, Par, _, _], CS):-
not(same_place(St,Par)),
member_in_close([Par, GrPar, _, _],CS),
final_path_printer([Par, GrPar,_, _],CS),
write(St), nl.

same_place(X1,X1).















