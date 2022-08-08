facts_creator:-csv_read_file('C:/Users/SPEED/OneDrive/Desktop/MyWork/roaddistance1.csv',
Rows,[functor(citydist), arity(21)]),
maplist(assert, Rows),
setof([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U],
citydist(A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U),Z),nl,
get_header_dfs(Z).


head_initializer_dfs([H|_],H).

head_deallocator_dfs([_|T],T).

get_header_dfs(Data):-
head_initializer_dfs(Data,H),
head_deallocator_dfs(Data,NewData),
head_deallocator_dfs(H,Header),
multi_place_predicate(NewData,Header).

get_distances_dfs([Cityname|Distances],Cityname,Distances).

single_place_predicate_dfs(_,[]).

% evaluating distance from source to detination, same as destination to
% source
single_place_predicate_dfs([City1name|[CurDist|OtherDist]],[City2name|Tcity2]):-
asserta(distance_gen(City1name,City2name,CurDist)),
asserta(distance_gen(City2name,City1name,CurDist)),
single_place_predicate_dfs([City1name|OtherDist],Tcity2).


single_place_printer_dfs([H|_],Distances):-
	single_place_predicate_dfs(H,Distances).

multi_place_predicate([],_):-
write('').

multi_place_predicate([H|T],Distances):-
single_place_predicate_dfs(H,Distances),
multi_place_predicate(T,Distances).


dfs_path_evaluation(Start,Goal):-
open_in_empty_dfs(Start_open),
mystack_dfs([Start,nil,0],Start_open,Open),
closed_in_empty_dfs(Closed),
finder(Open,Closed,Goal).

finder(Open,_,_):-
open_in_empty_dfs(Open),
write('Sorry, Cannot Find Any Path').

finder(Open,Closed,Goal):-
mystack_dfs([St,Pr,Cost],_,Open),
St=Goal,
write('Finding Path:'),nl,
dfs_path_printer([St,Pr,Cost],Closed),nl,
write('Evaluated Cost Is:'),nl,
print(Cost).

finder(Open,Closed,Goal):-
mystack_dfs([St,Pr,D],Po,Open),
next_child_evaluation([St,Pr,D],Po,Closed,Children),
add_to_mystack_dfs(Children, Po, Updated_open),
closed_insertion([[St,Pr,D]],Closed,Uc),
finder(Updated_open,Uc,Goal),!.

%in case if current child failed to provide path, finding in next child
next_child_evaluation([St,_,D],RSD, Closed_set, Children) :-
findall(Child, dfs_next_step([St,_,D], RSD, Closed_set, Child), Children).

dfs_next_step([St,_,Od], RSD, Closed_set, [Next,St,NewDist]) :-
distance_gen(St,Next,Dist),
NewDist is Od+Dist,
not(member_mystack_dfs([Next,_,_], RSD)),
not(member_list([Next,_,_], Closed_set)).


dfs_path_printer([St, nil,_], _) :-
write(St),nl.

dfs_path_printer([St, Pr,_], Closed_set) :-
not(same_place_dfs(St,Pr)),
member_list([Pr, GrandPr,_], Closed_set),
dfs_path_printer([Pr, GrandPr,_], Closed_set),
write(St),nl.


same_place_dfs(X1,X1).

open_in_empty_dfs([]).

%stack functions

mystack_dfs(Start,Es,[Start|Es]).

closed_in_empty_dfs([]).

members(X, [X | _]).
members(X, [_ | T]) :-
member(X, T).

member_list(St,Closed):-
members(St,Closed).


add_to_mystack_dfs(List, Mystack_dfs, Result) :-
append(List, Mystack_dfs, Result).

member_mystack_dfs(Element, Mystack_dfs) :-
members(Element, Mystack_dfs).

member_closed_dfs(St,Closed):-
members(St,Closed).

not_in_set_addition_dfs(X, S, S) :-
members(X, S), !.

not_in_set_addition_dfs(X, S, [X | S]).

closed_insertion([], S, S).

closed_insertion([H | T], S, S_new) :-
closed_insertion(T, S, S2),
not_in_set_addition_dfs(H, S2, S_new),!.
















