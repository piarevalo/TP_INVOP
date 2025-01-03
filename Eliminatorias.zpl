# Parametros:
param n := 10; # Para la cantidad de paises

set I := {1..n};
set K := {1..2*(n-1)};
set K_odd := {<k> in K with k mod 2 == 1};
set IJK := I * I * K;

# Para Argentina - Brasil
# set I_s := {1, 2};

# Para Min-Max
# param r := 4;           #relajacion: restriccion inicial (sabemos que en (5, 13) funciona) 
# param c := (n-1) - r;
# param d := (n-1) + r;

# Para un MIN MAX alternativo que hicimos
#param M := 3*n;
#param eps := 1/M;
#param a := (n-1) - r;
#param b := (n-1) + r;

#Variables
var x[IJK] binary;      #Partido i local, j visitante, fecha k
var y[I*K_odd] binary;      #H-A sequence
var w[I*K_odd] binary;      #away break in the double round
var f[I*I] integer;     #fecha en la que se jugo i vs j

#Funcion Objetivo (Minimizar el intervalo de distancias)
minimize breaks: sum <i, k> in I*K_odd: w[i, k];

# Restricciones
# Double round robin constraints.
subto r1: forall <i, j> in I*I with i != j: (sum <k> in K with k <= n-1: (x[i, j, k] + x[j, i, k])) == 1;
subto r2: forall <i, j> in I*I with i != j: (sum <k> in K with k > n-1: (x[i, j, k] + x[j, i, k])) == 1;
# Home-away balance with opponent
subto r3: forall <i, j> in I*I with i != j: (sum <k> in K: x[i, j, k]) == 1;
#Compactness.
subto r4: forall <j, k> in I*K: (sum <i> in I with i != j: (x[i, j, k] + x[j, i, k])) == 1;

#Top team constraints.
# subto r5: 
#    forall <i, k> in I*K with i != 1 and i != 2 and k != 2*(n-1): 
#        (sum <j> in I_s: (x[i, j, k]  + x[j, i, k] + x[i, j, k+1] + x[j, i, k+1])) <= 1;

# Comentario :
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

 # Comentario: esto lo agregamos para usarlo en python

#---------------------------------------------------------------------------------------
#Esquemas: Para correrlos, descomentar las restricciones correspondientes al esquema que se quiera

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

# Min-Max
# subto Min: forall <i,j,k> in I*I*K with i!=j and k<= 18 - c:
#     (sum <k_prima> in K with k <= k_prima and k_prima <= k+c: (x[i,j,k_prima] + x[j,i,k_prima])) <= 1;
# subto Max: forall <i,j,k> in I*I*K with i!=j:
#     (sum <k_prima> in K with k!=k_prima and k-d<= k_prima and 1 <= k_prima and (k_prima <=k+d or k_prima <= 2*(n-1)): x[i,j,k_prima])>=x[j,i,k];

# Intervalo MINMAX alternativo
#a < |f[i, j] - f[j, i]|
#b > |f[i, j] - f[j, i]|
# subto minimo1: forall <i, j> in I*I with i < j: (a - t_min[i, j]*M) <= (f[i, j] - f[j, i]);
# subto minimo2: forall <i, j> in I*I with i < j: - a + (1-t_min[i, j])*M >= f[i, j] - f[j, i];
# subto maximo1: forall <i, j> in I*I with i < j: b >= f[i, j] - f[j, i];
# subto maximo2: forall <i, j> in I*I with i < j: b >= f[j, i] - f[i, j];
