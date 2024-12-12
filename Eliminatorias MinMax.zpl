#read Eliminatorias.zpl
# Parametros:
param n := 10;

#MINMAX
#param M := 3*n;
#param eps := 1/M;
#param a := (n-1) - r;
#param b := (n-1) + r;

#para correr min max descomentar esto:
param r := 4;           #relajacion: restriccion inicial (se que en (5, 13) funciona) 
param d := (n-1) + r;
param c := (n-1) - r;

set I := {1..n};
set K := {1..2*(n-1)};
set K_odd := {<k> in K with k mod 2 == 1};
set IJK := I * I * K;


# para Arg Bra
set I_s := {1, 2};



#Variables
var x[IJK] binary;      #Partido i local, j visitante, fecha k
var y[I*K_odd] binary;      #H-A sequence
var w[I*K_odd] binary;      #away break in the double round
var f[I*I] integer;     #fecha en la que se jugo i vs j

#MINMAX
# var a integer >= 1 <= n - r;
# var b integer >= n + r <= 2*(n-1);
# var t_min[I*I] binary;


#Funcion Objetivo (Minimizar el intervalo de distancias)
# No Breaks:                   :    sum <i, k> in I*K: w[i, k]
# Minimo intervalo:            :    eps*(b-a)
# Mitad del intervalo cercano a:    (n-1)

minimize breaks: sum <i, k> in I*K_odd: w[i, k];
#Intervalo ideal a = b = (n-1)
#Peor caso posible a = 1, b = 2(n-1)


# Restricciones
# Double round robin constraints.
subto r1: forall <i, j> in I*I with i != j: (sum <k> in K with k <= n-1: (x[i, j, k] + x[j, i, k])) == 1;
subto r2: forall <i, j> in I*I with i != j: (sum <k> in K with k > n-1: (x[i, j, k] + x[j, i, k])) == 1;
# Home-away balance with opponent
subto r3: forall <i, j> in I*I with i != j: (sum <k> in K: x[i, j, k]) == 1;
#Compactness.
subto r4: forall <j, k> in I*K: (sum <i> in I with i != j: (x[i, j, k] + x[j, i, k])) == 1;


#Top team constraints.
subto r5: 
   forall <i, k> in I*K with i != 1 and i != 2 and k != 2*(n-1): 
       (sum <j> in I_s: (x[i, j, k]  + x[j, i, k] + x[i, j, k+1] + x[j, i, k+1])) <= 1;


# 3..N son todos los equipos menos arg y brasil
# 1..2*(n-1) son todas las fechas menos la ultima
# Lo que hicimos fue definir a brasil y argentina como el 1 y el 2 y hacer la restriccion con ese I_s


#Balance constraints.
# Home-away balance within double rounds
subto r6_1: forall <i> in I: n/2 - 1 <= (sum <k> in K_odd: y[i, k]); 
subto r6_2: forall <i> in I: (sum <k> in K_odd: y[i, k]) <= n/2;
#Logical relationships
subto r7: forall <i, k> in I*K_odd: (sum <j> in I with i !=j: (x[i, j, k] + x[j, i, k+1])) <= 1 + y[i, k];
subto r8: forall <i, k> in I*K_odd: y[i, k] <= (sum <j> in I with i != j: x[i, j, k]);
subto r9: forall <i, k> in I*K_odd: y[i, k] <= (sum <j> in I with i != j: x[j, i, k+1]);

#Objective function. (minimizing away breaks)
subto r10: forall <i, k> in I*K_odd: (sum <j> in I with i != j: (x[j, i, k] + x[j, i, k+1])) <= 1 + w[i, k];
subto r11: forall <i, k> in I*K_odd: w[i, k] <= (sum <j> in I with i != j: x[j, i, k]);
subto r12: forall <i, k> in I*K_odd: w[i, k] <= (sum <j> in I with i != j: x[j, i, k+1]);

#Ligamiento fechas
subto fechas: forall <i, j> in I*I with i != j: f[i, j] == (sum <k> in K: k * x[i, j, k]);

#---------------------------------------------------------------------------------------
#Esquemas:

# Mirrored scheme
# subto mirrored: forall <i, j, k> in I*I*K with i != j and 1 <= k and k <= n-1: x[i, j, k] == x[j, i, k+n-1];

# French scheme.
# subto French1: forall <i, j, k> in I*I*K with i != j: x[i, j, 1] == x[j, i, 2*n-2];
# subto French2: forall <i, j, k> in I*I*K with i !=j and 2 <= k and k <= n-1: x[i, j, k] == x[j, i, k+n-2];

# English Scheme 
# subto English1: forall <i, j, k> in I*I*K with i != j and 2 <= k and k <= n-2 : x[i, j, n-1] == x[j, i, n]; 
# subto English2: forall <i, j, k> in I*I*K with i != j and 2 <= k and k <= n-2 : x[i, j, k] == x[j, i, k+n]; 

# Inverted Scheme
# subto Inverted: forall <i, j, k> in I*I*K with i != j and 1 <= k and k <= n-1: x[i, j, k] == x[j, i, 2*n-1-k];

# Back-to-back Scheme
# subto BackToBack: forall <i, j, k> in I*I*K_odd with i != j: x[i, j, k] == x[j, i, k+1]; 

#minmax de los chicos
subto Min: forall <i,j,k> in I*I*K with i!=j and k<= 18 - c:
     (sum <k_prima> in K with k <= k_prima and k_prima <= k+c: (x[i,j,k_prima] + x[j,i,k_prima])) <= 1;

subto Max : forall <i,j,k> in I*I*K with i!=j:
     (sum <k_prima> in K with k!=k_prima and k-d<= k_prima and 1 <= k_prima and (k_prima <=k+d or k_prima <= 2*(n-1)): x[i,j,k_prima])>=x[j,i,k];

#intervalo MINMAX alternativo de batu
#a < |f[i, j] - f[j, i]|
#b > |f[i, j] - f[j, i]|
#subto minimo1: forall <i, j> in I*I with i < j: (a - t_min[i, j]*M) <= (f[i, j] - f[j, i]);
#subto minimo2: forall <i, j> in I*I with i < j: - a + (1-t_min[i, j])*M >= f[i, j] - f[j, i];
#subto maximo1: forall <i, j> in I*I with i < j: b >= f[i, j] - f[j, i];
#subto maximo2: forall <i, j> in I*I with i < j: b >= f[j, i] - f[i, j];
