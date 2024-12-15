import 'dart:math';

class PasteleriaBL {
  List<Map<String, dynamic>> PasteleriaSimulacion(
    int diasDelMes,
    double precioPastelPequeno,
    double precioPastelMediano,
    double precioPastelGrande,
    int diasEntregaProveedor,
    int vidaUtilPasteles,
    Map<String, List<Map<String, dynamic>>> costosAdquisicion,
    int cantidadSimulaciones,
    List<int> detalleOrdenes,
  ) {
    // Imprimir cada variable con su nombre
    print('Días del Mes: $diasDelMes');
    print('Precio Pastel Pequeño: $precioPastelPequeno');
    print('Precio Pastel Mediano: $precioPastelMediano');
    print('Precio Pastel Grande: $precioPastelGrande');
    print('Días de Entrega del Proveedor: $diasEntregaProveedor');
    print('Vida Útil de los Pasteles: $vidaUtilPasteles');

    print('Costos de Adquisición:');
    costosAdquisicion.forEach((tipo, costos) {
      print('  $tipo:');
      for (var costo in costos) {
        print('    Rango: ${costo['rango']}, Precio: ${costo['precio']}');
      }
    });

    print('Cantidad de Simulaciones: $cantidadSimulaciones');

    // CAMBIO DE NOMBRE DE VARIABLES PARA HACER MATCH CON EL DIAGRAMA DE FLUJO:

    int D = diasDelMes;
    double PVPP = precioPastelPequeno;
    double PVPM = precioPastelPequeno;
    double PVPG = precioPastelPequeno;
    int CDE = diasEntregaProveedor;
    int VUP = vidaUtilPasteles;

    int CPLPP = detalleOrdenes[0];
    int CPLPM = detalleOrdenes[1];
    int CPLPG = detalleOrdenes[2];
    int CPJPP = detalleOrdenes[3];
    int CPJPM = detalleOrdenes[4];
    int CPJPG = detalleOrdenes[5];
    int CPSPP = detalleOrdenes[6];
    int CPSPM = detalleOrdenes[7];
    int CPSPG = detalleOrdenes[8];

    int CD = 1;

    int DIPP = 0;
    int CT = 0;
    int DIPM = 0;
    int DIPG = 0;
    int GN = 0;
    int CPP = 0;
    int CPM = 0;
    int CPG = 0;
    int DESPP = 0;
    int DESPM = 0;
    int DESPG = 0;
    bool EP = false;
    int DRE = -1;
    int CVS = 0;
    int CVSP = 0;

    int SPP = CPSPP;
    int SPM = CPSPM;
    int SPG = CPSPG;

    int SPPP = 0;
    int SPPM = 0;
    int SPPG = 0;

    int CPPP = 0;
    int CPPM = 0;
    int CPPG = 0;

    int DPP = 0;
    int DPM = 0;
    int DPG = 0;
    double CO = 0;

    CT = CPSPP * obtenerCostoPP(CPSPP) +
        CPSPM * obtenerCostoPM(CPSPP) +
        CPSPG * obtenerCostoPG(CPSPP);

    List<Map<String, dynamic>> simulationData = [];

    //inital data:
    simulationData.add({
      'CT': CT,
      'SPP': SPP,
      'SPM': SPM,
      'SPG': SPG,
    });

    while (CD <= D ) {
      //LLEGADA DE PASTELES ORDENADOS

      if (EP == true && DRE == 1) {
        SPPP = SPPP + SPP;
        SPPM = SPPM + SPM;
        SPPG = SPPG + SPG;

        SPP = CPPP;
        SPM = CPPM;
        SPG = CPPG;

        CVSP = CVS;
        CVS = 0;

        EP = false;
      } else {
        if (EP = true) {
          DRE = DRE - 1;
        }
      }

      // TODO: GENERAR LAS DEMANDAS:
      Random seed1 = Random();
      Random seed2 = Random();
      Random seed3 = Random();
      Random seed4 = Random();
      Random seed5 = Random();
      double ALE1 =
          double.parse((seed1.nextDouble() * (1 - 0) + 0).toStringAsFixed(3));
      double ALE2 =
          double.parse((seed2.nextDouble() * (1 - 0) + 0).toStringAsFixed(3));
      double ALE3 =
          double.parse((seed3.nextDouble() * (1 - 0) + 0).toStringAsFixed(3));
      double ALE4 =
          double.parse((seed4.nextDouble() * (1 - 0) + 0).toStringAsFixed(3));
      double ALE5 =
          double.parse((seed5.nextDouble() * (1 - 0) + 0).toStringAsFixed(3));

      if (CD % 7 == 6 || CD % 7 == 0) {
        DPP = ObtenerDemandaPastelPequenoFinDeSemana(ALE3);
        DPM = (3 + 4 * ALE4).round();
      } else {
        DPP = ObtenerDemandaPastelPequenoSemana(ALE1);
        DPM = ObtenerDemandaPastelMedianoSemana(ALE2);
      }

      DPG = ObtenerDemandaPastelGrande(ALE5);

      //ANALIZAR SI SE CUMPLE CON LA DEMANDA DE PASTEL PEQUEÑO:

      if (DPP <= (SPPP + SPP)) {
        CPP = CPP + DPP;
        if (SPPP >= 1) {
          if (SPPP >= DPP) {
            SPPP = SPPP - DPP;
          } else {
            DPP = DPP - SPPP;
            SPPP = 0;
            SPP = SPP - DPP;
          }
        } else {
          SPP = SPP - DPP;
        }
      } else {
        DIPP = DIPP + DPP - (SPPP + SPP);
        CPP = CPP + SPP + SPPP;
        SPPP = 0;
        SPP = 0;
      }

      //ANALIZAR SI SE CUMPLE CON LA DEMANDA DE PASTEL MEDIANO:

      if (DPM <= (SPPM + SPM)) {
        CPM = CPM + DPM;
        if (SPPM >= 1) {
          if (SPPM >= DPM) {
            SPPM = SPPM - DPM;
          } else {
            DPM = DPM - SPPM;
            SPPM = 0;
            SPM = SPM - DPM;
          }
        } else {
          SPM = SPM - DPM;
        }
      } else {
        DIPM = DIPM + DPM - (SPPM + SPM);
        CPM = CPM + SPM + SPPM;
        SPPM = 0;
        SPM = 0;
      }

      //ANALIZAR SI SE CUMPLE CON LA DEMANDA DE PASTEL GRANDE:

      if (DPG <= (SPPG + SPG)) {
        CPG = CPG + DPG;
        if (SPPG >= 1) {
          if (SPPG >= DPG) {
            SPPG = SPPG - DPG;
          } else {
            DPG = DPG - SPPG;
            SPPG = 0;
            SPG = SPG - DPG;
          }
        } else {
          SPG = SPG - DPG;
        }
      } else {
        DIPG = DIPG + DPG - (SPPG + SPG);
        CPG = CPG + SPG + SPPG;
        SPPG = 0;
        SPG = 0;
      }

      // ANALIZAR SI ES DIA DE ORDEN O NO:

      if ((CD % 7 == 1) || (CD % 7 == 4) || (CD % 7 == 6)) {
        if (CD % 7 == 1) {
          CPPP = CPLPP;
          CPPM = CPLPM;
          CPPG = CPLPG;
        } else if (CD % 7 == 4) {
          CPPP = CPJPP;
          CPPM = CPJPM;
          CPPG = CPJPG;
        } else {
          CPPP = CPSPP;
          CPPM = CPSPM;
          CPPG = CPSPG;
        }

        int CAPP = obtenerCostoPP(CPPP);
        int CAPM = obtenerCostoPP(CPPM);
        int CAPG = obtenerCostoPP(CPPG);

        CO = (CPPP * CAPP + CPPM * CAPM + CPPG * CAPG) as double;
        CT = (CT + CO) as int;

        DRE = CDE;
        EP = true;
      } else {
        CO = 0;
      }

      // EVALUAR PASTELES PEQUEÑOS:

      if (CVSP == VUP) {
        DESPP = DESPP + SPPP;
        DESPM = DESPM + SPPM;
        DESPG = DESPG + SPPG;
        SPPP = 0;
        SPPM = 0;
        SPPG = 0;
        CVSP = 0;
        CVS = CVS + 1;
      } else {
        CVS = CVS + 1;
        CVSP = CVSP + 1;
      }

      simulationData.add({
        'day': CD,
        'DPP': DPP,
        'DPM': DPM,
        'DPG': DPG,
        'SPP': SPP,
        'SPM': SPM,
        'SPG': SPG,
        'SPPP': SPPP,
        'SPPM': SPPM,
        'SPPG': SPPG,
        'CPP': CPP,
        'CPM': CPM,
        'CPG': CPG,
        'DESPP': DESPP,
        'DESPM': DESPM,
        'DESPG': DESPG,
        'DIPP': DIPP,
        'DIPM': DIPM,
        'DIPG': DIPG,
        'CT': CT,
      });

      CD++;
    }

    GN = ( -CT + CPP * PVPP + CPM * PVPM + CPG * PVPG) as int;

    simulationData.add({
      'final_data_to_avg': true,

        'Cantidad pasteles pequeños en stock': SPP+SPPP,// Cantidad pasteles pequeños en stock
        'Cantidad pasteles medianos en stock': SPM + SPPM,// Cantidad pasteles medianos en stock
        'Cantidad pasteles grandes en stock': SPG + SPPG,// Cantidad pasteles grandes en stock
        'Cantidad pasteles pequeños vendidos': CPP, // Cantidad pasteles pequeños vendidos
        'Cantidad pasteles medianos vendidos': CPM,// Cantidad pasteles medianos vendidos
        'Cantidad pasteles grandes vendidos': CPG,// Cantidad pasteles grandes vendidos
        'Cantidad pasteles pequeños deshechados': DESPP, // Cantidad pasteles pequeños deshechados
        'Cantidad pasteles medianos deshechados': DESPM,// Cantidad pasteles medianos deshechados
        'Cantidad pasteles grandes deshechados': DESPG,// Cantidad pasteles grandes deshechados
        'Demanda insatisfecha Pastel pequeño': DIPP, // Demanda insatisfecha Pastel pequeño
        'Demanda insatisfecha Pastel mediano': DIPM,// Demanda insatisfecha Pastel mediano
        'Demanda insatisfecha Pastel grande': DIPG,// Demanda insatisfecha Pastel grande
      'Ganancia Neta mensual': GN, //ganancia mensual
    });

    return simulationData;
  }

  int ObtenerDemandaPastelPequenoSemana(double ALE) {
    if (ALE >= 0.0 && ALE <= 0.01) {
      return 0; // DEMANDA = 0
    } else if (ALE > 0.01 && ALE <= 0.07) {
      return 1; // DEMANDA = 1
    } else if (ALE > 0.07 && ALE <= 0.18) {
      return 2; // DEMANDA = 2
    } else if (ALE > 0.18 && ALE <= 0.35) {
      return 3; // DEMANDA = 3
    } else if (ALE > 0.35 && ALE <= 0.55) {
      return 4; // DEMANDA = 4
    } else if (ALE > 0.55 && ALE <= 0.72) {
      return 5; // DEMANDA = 5
    } else if (ALE > 0.72 && ALE <= 0.84) {
      return 6; // DEMANDA = 6
    } else if (ALE > 0.84 && ALE <= 0.92) {
      return 7; // DEMANDA = 7
    } else if (ALE > 0.92 && ALE <= 0.96) {
      return 8; // DEMANDA = 8
    } else if (ALE > 0.96 && ALE <= 0.99) {
      return 9; // DEMANDA = 9
    } else if (ALE > 0.99 && ALE <= 1.0) {
      return 10; // DEMANDA = 10
    } else {
      throw ArgumentError('ALE debe estar entre 0 y 1');
    }
  }

  int ObtenerDemandaPastelMedianoSemana(double ALE) {
    if (ALE >= 0.0 && ALE <= 0.08) {
      return 0; // DEMANDA = 0
    } else if (ALE > 0.08 && ALE <= 0.20) {
      return 1; // DEMANDA = 1
    } else if (ALE > 0.20 && ALE <= 0.49) {
      return 2; // DEMANDA = 2
    } else if (ALE > 0.49 && ALE <= 0.65) {
      return 3; // DEMANDA = 3
    } else if (ALE > 0.65 && ALE <= 0.82) {
      return 4; // DEMANDA = 4
    } else if (ALE > 0.82 && ALE <= 0.92) {
      return 5; // DEMANDA = 5
    } else if (ALE > 0.92 && ALE <= 0.97) {
      return 6; // DEMANDA = 6
    } else if (ALE > 0.97 && ALE <= 0.98) {
      return 7; // DEMANDA = 7
    } else if (ALE > 0.98 && ALE <= 1.0) {
      return 8; // DEMANDA = 8
    } else {
      throw ArgumentError('ALE debe estar entre 0 y 1');
    }
  }

  int ObtenerDemandaPastelPequenoFinDeSemana(double ALE) {
    if (ALE >= 0.0 && ALE <= 0.01) {
      return 2; // DEMANDA = 2
    } else if (ALE > 0.01 && ALE <= 0.05) {
      return 3; // DEMANDA = 3
    } else if (ALE > 0.05 && ALE <= 0.12) {
      return 4; // DEMANDA = 4
    } else if (ALE > 0.12 && ALE <= 0.23) {
      return 5; // DEMANDA = 5
    } else if (ALE > 0.23 && ALE <= 0.36) {
      return 6; // DEMANDA = 6
    } else if (ALE > 0.36 && ALE <= 0.51) {
      return 7; // DEMANDA = 7
    } else if (ALE > 0.51 && ALE <= 0.64) {
      return 8; // DEMANDA = 8
    } else if (ALE > 0.64 && ALE <= 0.77) {
      return 9; // DEMANDA = 9
    } else if (ALE > 0.77 && ALE <= 0.84) {
      return 10; // DEMANDA = 10
    } else if (ALE > 0.84 && ALE <= 0.92) {
      return 11; // DEMANDA = 11
    } else if (ALE > 0.92 && ALE <= 0.96) {
      return 12; // DEMANDA = 12
    } else if (ALE > 0.96 && ALE <= 0.98) {
      return 13; // DEMANDA = 13
    } else if (ALE > 0.98 && ALE <= 0.99) {
      return 14; // DEMANDA = 14
    } else if (ALE > 0.99 && ALE <= 1.0) {
      return 15; // DEMANDA = 15
    } else {
      throw ArgumentError('ALE debe estar entre 0 y 1');
    }
  }

  int ObtenerDemandaPastelGrande(double ALE) {
    if (ALE >= 0.0 && ALE <= 0.13) {
      return 0; // DEMANDA = 0
    } else if (ALE > 0.13 && ALE <= 0.4) {
      return 1; // DEMANDA = 1
    } else if (ALE > 0.4 && ALE <= 0.67) {
      return 2; // DEMANDA = 2
    } else if (ALE > 0.67 && ALE <= 0.85) {
      return 3; // DEMANDA = 3
    } else if (ALE > 0.85 && ALE <= 0.94) {
      return 4; // DEMANDA = 4
    } else if (ALE > 0.94 && ALE <= 0.98) {
      return 5; // DEMANDA = 5
    } else if (ALE > 0.98 && ALE <= 0.99) {
      return 6; // DEMANDA = 6
    } else {
      return 7; // DEMANDA = 7
    }
  }

  int obtenerCostoPP(int cantidad) {
    if (cantidad >= 0 && cantidad <= 6) {
      return 60;
    } else if (cantidad >= 7 && cantidad <= 12) {
      return 55;
    }
    return 50;
  }

  int obtenerCostoPM(int cantidad) {
    if (cantidad >= 0 && cantidad <= 6) {
      return 80;
    } else if (cantidad >= 7 && cantidad <= 12) {
      return 75;
    }
    return 70;
  }

  int obtenerCostoPG(int cantidad) {
    if (cantidad >= 0 && cantidad <= 6) {
      return 95;
    } else if (cantidad >= 7 && cantidad <= 12) {
      return 90;
    }
    return 85;
  }
}
