def fechas_iguales(fecha1, fecha2):
    partidos1 = {tuple(sorted(partido)) for partido in fecha1}
    partidos2 = {tuple(sorted(partido)) for partido in fecha2}
    return partidos1 == partidos2

def mirrored(fixture):
    if (fechas_iguales(fixture[1], fixture[10]) and 
           fechas_iguales(fixture[2], fixture[11]) and 
           fechas_iguales(fixture[3], fixture[12]) and
           fechas_iguales(fixture[4], fixture[13]) and 
           fechas_iguales(fixture[5], fixture[14]) and
           fechas_iguales(fixture[6], fixture[15]) and 
           fechas_iguales(fixture[7], fixture[16]) and 
           fechas_iguales(fixture[8], fixture[17]) and 
           fechas_iguales(fixture[9], fixture[18])) : 
        return True
    return False

def french(fixture):
    if (fechas_iguales(fixture[1], fixture[18]) and 
           fechas_iguales(fixture[2], fixture[10]) and 
           fechas_iguales(fixture[3], fixture[11]) and
           fechas_iguales(fixture[4], fixture[12]) and 
           fechas_iguales(fixture[5], fixture[13]) and
           fechas_iguales(fixture[6], fixture[14]) and 
           fechas_iguales(fixture[7], fixture[15]) and 
           fechas_iguales(fixture[8], fixture[16]) and 
           fechas_iguales(fixture[9], fixture[17])) : 
        return True
    return False

def english(fixture):
    if (fechas_iguales(fixture[1], fixture[11]) and 
           fechas_iguales(fixture[2], fixture[12]) and 
           fechas_iguales(fixture[3], fixture[13]) and
           fechas_iguales(fixture[4], fixture[14]) and 
           fechas_iguales(fixture[5], fixture[15]) and
           fechas_iguales(fixture[6], fixture[16]) and 
           fechas_iguales(fixture[7], fixture[17]) and 
           fechas_iguales(fixture[8], fixture[18]) and 
           fechas_iguales(fixture[9], fixture[10])) : 
        return True
    return False

def inverted(fixture):
    if (fechas_iguales(fixture[1], fixture[18]) and 
           fechas_iguales(fixture[2], fixture[17]) and 
           fechas_iguales(fixture[3], fixture[16]) and
           fechas_iguales(fixture[4], fixture[15]) and 
           fechas_iguales(fixture[5], fixture[14]) and
           fechas_iguales(fixture[6], fixture[13]) and 
           fechas_iguales(fixture[7], fixture[12]) and 
           fechas_iguales(fixture[8], fixture[11]) and 
           fechas_iguales(fixture[9], fixture[10])) : 
        return True
    return False

def back_to_back(fixture):
    if (fechas_iguales(fixture[1], fixture[2]) and 
           fechas_iguales(fixture[3], fixture[4]) and 
           fechas_iguales(fixture[5], fixture[6]) and
           fechas_iguales(fixture[7], fixture[8]) and 
           fechas_iguales(fixture[9], fixture[10]) and
           fechas_iguales(fixture[11], fixture[12]) and 
           fechas_iguales(fixture[13], fixture[14]) and 
           fechas_iguales(fixture[15], fixture[16]) and 
           fechas_iguales(fixture[17], fixture[18])) : 
        return True
    return False

def esquema(fixture) :
    if(mirrored(fixture)) :
        print("Mirrored Scheme")
    if(french(fixture)) :
        print("French Scheme")
    if(english(fixture)) :
        print("English Scheme")
    if(inverted(fixture)) :
        print("Inverted Scheme")
    if(back_to_back(fixture)) :
        print("Back-to-Back Scheme")
    return 0
    
