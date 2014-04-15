%% Ex 5.4
%% Implementar fatorial em Prolog.

%% Exemplo de query:
%% ?- fat(10, X)

fat(0, 1).
fat(N, NF) :-
	B is N - 1,
	fat(B, NB),
	NF is N * NB.

?-