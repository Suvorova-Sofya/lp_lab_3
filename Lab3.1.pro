member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

move([W, G, C, B], [W1, G, C, B1]) :- 
	opposite(B, B1), 
	opposite(W, W1),
	opposite(W, B),
	opposite(W1, B1),
	unsafe([W1, G, C, B1]).

move([W, G, C, B], [W, G1, C, B1]) :- 
	opposite(B, B1), 
	opposite(G, G1),
	opposite(G, B),
	opposite(G1, B1), 
	unsafe([W, G1, C, B1]).

move([W, G, C, B], [W, G, C1, B1]) :- 
	opposite(B, B1), 
	opposite(C, C1),
	opposite(C, B),
	opposite(C1, B1), 
	unsafe([W, G, C1, B1]).

move([W, G, C, B], [W, G, C, B1]) :- opposite(B, B1), unsafe([W, G, C, B1]).

opposite(left, right).
opposite(right, left).
	
unsafe([W, W, C, B]) :- 
	B \== W.

unsafe([W, G, G, B]) :- 
	B \== G.

solve(Node, Solution) :- depth([], Node, Solution).

depth(Path, Node, [Node | Path]) :- goal(Node).

depth(Path, Node, Sol) :- 
	move(Node, Node1), 
	member(Node1, Path),
	depth([Node | Path], Node1, Sol).
	
goal([right, right, right, right]).



path(Node, Node, [Node]).

path(FirstNode, Last, [Last | Path]) :- 
	path(FirstNode, OneButLast, Path),
	move(OneButLast, Last),
	member(Last, Path).

depth_iterative(Node, Solution) :-
	path(Node, Goal, Solution),	
	goal(Goal).



solve_breadth(Start, Solution) :- 
	breadth([[Start]], Solution).

breadth([[Node | Path] | _], [Node | Path]) :-
	goal(Node).

breadth([Path | Paths], Solution) :-
	extend(Path, NewPaths),
	append(Paths, NewPaths, Paths1),
	breadth(Paths1, Solution).

extend([Node | Path], NewPaths) :-
	bagof([New | [Node | Path]], (move(Node, New), member(New, [Node | Path])), NewPaths), !.
extend(Path, []).