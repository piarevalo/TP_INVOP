param n := 10;
param c := 5;
param d:= 13;
set I :={1..n}; #10 equipos
set K := {1..2*n-2}; #18 rondas
set K_Odd := {1,3,5,7,9,11,13,15,17}; # Rondas impares

set IS :={1,2}; #argentina y brasil

set NonIS := {3..10}; # todos menos argentina y brasil


var x[I*I*K] binary; # x[i,j,k] vale 1 si equipo i juega de local contra j en ronda k

var y[I*K_Odd] binary; #y(i,k) vale 1 si i tiene secuencia H-A en la doble ronda empezada  en k

var w[I*K_Odd] binary; #w(i,k) vale 1 si i tiene un away break en la doble ronda empezada en k


minimize breaks: sum <i,k> in I*K_Odd : w[i,k]; 

subto r1: forall <i,j> in I*I with i!=j do
   sum <k> in K with k<=9 : (x[i,j,k] + x[j,i,k]) == 1;

subto r2: forall <i,j> in I*I with i!=j : sum <k> in K with 10 <=k : (x[i,j,k] + x[j,i,k]) == 1;  

subto r3: forall <i,j> in I*I with i!=j : sum <k> in K : (x[i,j,k]) == 1;  

subto r4 : forall <j,k> in I*K:  sum <i> in I : (x[i,j,k] + x[j,i,k]) == 1;  

subto r5: forall <i,k> in NonIS*K with k<18: sum <j> in IS: (x[i,j,k] + x[j,i,k] + x[i,j,k+1] + x[j,i,k+1]) <= 1;

subto r6: forall <i> in I : n/2-1 <= sum <k> in K_Odd: y[i,k] <= n/2;

subto r7: forall <i,k> in I*K_Odd : sum <j> in I with j != i : (x[i,j,k] + x[j,i,k+1])<= y[i,k] + 1;

subto r8: forall <i,k> in I*K_Odd: sum <j> in I with j != i: (x[i,j,k]) >= y[i,k];

subto r9: forall <i,k> in I*K_Odd: sum <j> in I with j != i: (x[j,i,k+1]) >= y[i,k];


subto r10: forall <i,k> in I*K_Odd: sum <j> in I with j !=i : (x[j,i,k] + x[j,i,k+1]) <= 1 + w[i,k];

subto r11: forall <i,k> in I*K_Odd: w[i,k] <= sum <j> in I with j !=i : (x[j,i,k]);

subto r12: forall <i,k> in I*K_Odd: w[i,k] <= sum <j> in I with j !=i : (x[j,i,k+1]);

#subto r14_Mirrored_Scheme : forall <i,j,k> in I*I*K with i!= j and k<=n-1: x[i,j,k] == x[j,i,k+n-1];

subto r15_French_Scheme : forall <i,j,k> in I*I*K with i!=j and 2<=k and k<=(n-1) : x[i,j,1] == x[j,i,2*n-2];
subto r15_French_Scheme_b: forall <i,j,k> in I*I*K with i!=j and 2<=k and k <= (n-1) : x[i,j,k] == x[j,i,k+n-2];

#subto r16_English_Scheme_a: forall <i,j,k> in I*I*K with i!=j and 2<=k and k<=(n-2): x[i,j,n-1]== x[j,i,n];

#subto r16_English_Scheme_b: forall <i,j,k> in I*I*K with i!=j and 2<=k and k<=(n-2): x[i,j,k] == x[j,i,k+n];

#subto r17_Inverted_Scheme : forall <i,j,k> in I*I*K with i!=j and 2<=k and k <= (n-1): x[i,j,k] == x[j,i,2*n-1-k];

#subto r18_BTB_Scheme: forall <i,j,k> in I*I*K_Odd with i!=j: x[i,j,k] == x[j,i,k+1];

#subto r19_min: forall <i,j,k> in I*I*K with i!=j and k<= 18 - c do
#  sum <k_b> in K with k<=k_b and k_b <= k+c: (x[i,j,k_b] + x[j,i,k_b]) <= 1;

#subto r20_max : forall <i,j,k> in I*I*K with i!=j do
#  sum <k_b> in K with k!=k_b and k-d<= k_b and 1 <= k_b and (k_b <=k+d or k_b <= 2*(n-1)): x[i,j,k_b] >=x[j,i,k];