
:- module(mergeDRT,[mergeDrs/2]).

:- use_module(library(lists),[append/3]).


/*========================================================================
   DRS-merge
========================================================================*/

mergeDrs(drs(D,C1),drs(D,C2)):- !, mergeConds(C1,C2).

mergeDrs(B:drs(D,C1),B:drs(D,C2)):- !, mergeConds(C1,C2).

mergeDrs(merge(drs([],[]),B),M):- !, mergeDrs(B,M).

mergeDrs(merge(_:drs([],[]),B),M):- !, mergeDrs(B,M).

mergeDrs(merge(B,drs([],[])),M):- !, mergeDrs(B,M).

mergeDrs(merge(B,_:drs([],[])),M):- !, mergeDrs(B,M).

mergeDrs(merge(B1,B2),M):- !,
   mergeDrs(B1,R1),
   mergeDrs(B2,R2),
   (
      R1 = drs(D1,C1), 
      R2 = drs(D2,C2), !,
      append(D1,D2,D3),
      append(C1,C2,C3), 
      M = drs(D3,C3)
   ;
      R1 = K:drs(D1,C1), 
      R2 = K:drs(D2,C2), !,
      append(D1,D2,D3),
      append(C1,C2,C3), 
      M = K:drs(D3,C3)
   ;
      R1 = K:drs(D1,C1), 
      R2 = sdrs([sub(lab(A,K:drs(D2,C2)),B)|L],C), !,
      append(D1,D2,D3),
      append(C1,C2,C3), 
      M = sdrs([sub(lab(A,K:drs(D3,C3)),B)|L],C)
   ;
      R1 = sdrs([sub(lab(A,K:drs(D1,C1)),B)|L],C),
      R2 = K:drs(D2,C2), !,
      append(D1,D2,D3),
      append(C1,C2,C3), 
      M = sdrs([sub(lab(A,K:drs(D3,C3)),B)|L],C)
   ;
      M = merge(R1,R2)
   ).

mergeDrs(smerge(B1,B2),smerge(B3,B4)):- !,
   mergeDrs(B1,B3),
   mergeDrs(B2,B4).

mergeDrs(alfa(top,drs([],[]),B2),B4):- !,
   mergeDrs(B2,B4).

mergeDrs(alfa(_,B1,B2),M):-
   option('--semantics',pdrs),
   mergeDrs(B1,R1),
   mergeDrs(B2,R2),
   R1 = _:drs(D1,C1), 
   R2 = K:drs(D2,C2), !,
   append(D1,D2,D3),
   append(C1,C2,C3), 
   M = K:drs(D3,C3).

mergeDrs(alfa(Type,B1,B2),alfa(Type,B3,B4)):- !,
   mergeDrs(B1,B3),
   mergeDrs(B2,B4).

mergeDrs(lab(K,B1),lab(K,B2)):- !,
   mergeDrs(B1,B2).

mergeDrs(sdrs([],C),sdrs([],C)):- !.

mergeDrs(sdrs([sub(A1,B1)|L1],C1),sdrs([sub(A2,B2)|L2],C2)):- !,
   mergeDrs(A1,A2),
   mergeDrs(B1,B2),
   mergeDrs(sdrs(L1,C1),sdrs(L2,C2)).

mergeDrs(sdrs([lab(K,B1)|L1],C1),sdrs([lab(K,B2)|L2],C2)):- !,
   mergeDrs(B1,B2),
   mergeDrs(sdrs(L1,C1),sdrs(L2,C2)).


/*========================================================================
   DRS-merge (Conditions)
========================================================================*/

mergeConds([B:F:Cond1|C1],[B:F:Cond2|C2]):- !,
   mergeConds([Cond1|C1],[Cond2|C2]).

mergeConds([F:Cond1|C1],[F:Cond2|C2]):- !,
   mergeConds([Cond1|C1],[Cond2|C2]).

mergeConds([imp(B1,B2)|C1],[imp(B3,B4)|C2]):- !,
   mergeDrs(B1,B3),
   mergeDrs(B2,B4),
   mergeConds(C1,C2).

mergeConds([whq(B1,B2)|C1],[whq(B3,B4)|C2]):- !,
   mergeDrs(B1,B3),
   mergeDrs(B2,B4),
   mergeConds(C1,C2).

mergeConds([whq(Type,B1,Var,B2)|C1],[whq(Type,B3,Var,B4)|C2]):- !,
   mergeDrs(B1,B3),
   mergeDrs(B2,B4),
   mergeConds(C1,C2).

mergeConds([or(B1,B2)|C1],[or(B3,B4)|C2]):- !,
   mergeDrs(B1,B3),
   mergeDrs(B2,B4),
   mergeConds(C1,C2).

mergeConds([not(B1)|C1],[not(B2)|C2]):- !,
   mergeDrs(B1,B2),
   mergeConds(C1,C2).

mergeConds([nec(B1)|C1],[nec(B2)|C2]):- !,
   mergeDrs(B1,B2),
   mergeConds(C1,C2).

mergeConds([pos(B1)|C1],[pos(B2)|C2]):- !,
   mergeDrs(B1,B2),
   mergeConds(C1,C2).

mergeConds([prop(X,B1)|C1],[prop(X,B2)|C2]):- !,
   mergeDrs(B1,B2),
   mergeConds(C1,C2).

mergeConds([pred(A,B,C,D)|C1],[pred(A,B,C,D)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([rel(A,B,C,D)|C1],[rel(A,B,C,D)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([role(A,B,C,D)|C1],[role(A,B,C,D)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([card(A,S,T)|C1],[card(A,S,T)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([named(A,S,T,U)|C1],[named(A,S,T,U)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([timex(A,S)|C1],[timex(A,S)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([eq(X,Y)|C1],[eq(X,Y)|C2]):- !,
   mergeConds(C1,C2).

mergeConds([],[]).

