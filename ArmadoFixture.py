from sys import stdin
def leer_input():
    fechas = []
    entrada = stdin.readline().strip().split()
    while entrada:
        fechas.append((entrada[0], int(round(float(entrada[1]), 0))))
        entrada = stdin.readline().strip().split()
    fechas = sorted(fechas, key=lambda x: x[1])
    return fechas



def fixture():
    fechas = leer_input()
    
    fechas_limpias_dict = {}
    for partido, fecha in fechas:
        partido_split = partido.split("#")
        eq1, eq2 = int(partido_split[1]), int(partido_split[2])
        if fecha in fechas_limpias_dict:
            fechas_limpias_dict[fecha].append((eq1, eq2))
        else:
            fechas_limpias_dict[fecha] = [(eq1, eq2)]
    
    for key in fechas_limpias_dict.keys():
        if key <= 9:
            # pass
            print(key, " : ", sorted(fechas_limpias_dict[key]))
        else:
            # pass
            print(key, ": ", sorted(fechas_limpias_dict[key]))
    
    return fechas_limpias_dict