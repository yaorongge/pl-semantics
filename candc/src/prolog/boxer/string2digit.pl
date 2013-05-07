
:- module(string2digit,[string2digit/2]).

:- use_module(library(lists),[append/3]).

/*========================================================================
   Converting strings to digits
========================================================================*/

string2digit(X,Y):-
   atom(X),
   ( atomic_list_concat([Tens,Ones],'-',X),
     s2d(Tens,TensNum), TensNum < 91, TensNum > 19, 
     s2d(Ones,OnesNum), OnesNum < 10, !,
     Y is TensNum+OnesNum, !
   ; s2d(X,Y) ), !.

string2digit(X,Y):-       %%% remove comma's from number expressions
   name(X,Codes1), 
   append(Codes0,[44,A,B,C],Codes1),
   append(Codes0,[A,B,C],Codes2),
   name(Y,Codes2),
   number(Y), !.

string2digit(X,Y):-       %%% trick to convert atoms into numbers
   name(X,Codes), 
   name(Y,Codes),
   number(Y), !.


/*========================================================================
   Look-up table
========================================================================*/

s2d(zero,0).
s2d(one,1).
s2d(two,2).
s2d(three,3).
s2d(four,4).
s2d(five,5).
s2d(six,6).
s2d(seven,7).
s2d(eight,8).
s2d(nine,9).
s2d(ten,10).
s2d(eleven,11).
s2d(twelve,12).
s2d(thirteen,13).
s2d(fourteen,14).
s2d(fifteen,15).
s2d(sixteen,16).
s2d(seventeen,17).
s2d(eighteen,18).
s2d(nineteen,19).
s2d(twenty,20).
s2d(thirty,30).
s2d(forty,40).
s2d(fifty,50).
s2d(sixty,60).
s2d(seventy,70).
s2d(eighty,80).
s2d(ninety,90).
s2d(hundred,100).
s2d(thousand,1000).
s2d(million,1000000).
s2d(billion,1000000000).
s2d(trillion,1000000000000).
