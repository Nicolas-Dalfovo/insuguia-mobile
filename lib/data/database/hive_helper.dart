import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/entities/prescricao.dart';

// Helper para gerenciar o Hive (banco de dados local compatível com Web)
class HiveHelper {
  static final HiveHelper instance = HiveHelper._init();
  
  bool _initialized = false;

  HiveHelper._init();

  // Inicializa o Hive
  Future<void> initialize() async {
    if (_initialized) {
      print('DEBUG: Hive já inicializado');
      return;
    }
    
    try {
      print('DEBUG: Inicializando Hive...');
      // Usa um subDir fixo para garantir persistência independente da porta
      await Hive.initFlutter('insuguia_db');
      print('DEBUG: Hive inicializado com subDir fixo: insuguia_db');
      
      print('DEBUG: Registrando adaptadores...');
      // Registra os adaptadores
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(PacienteAdapter());
        print('DEBUG: PacienteAdapter registrado');
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TipoInsulinaBasalAdapter());
        print('DEBUG: TipoInsulinaBasalAdapter registrado');
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(TipoInsulinaRapidaAdapter());
        print('DEBUG: TipoInsulinaRapidaAdapter registrado');
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(HorarioInsulinaAdapter());
        print('DEBUG: HorarioInsulinaAdapter registrado');
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(EscalaCorrecaoAdapter());
        print('DEBUG: EscalaCorrecaoAdapter registrado');
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(PrescricaoAdapter());
        print('DEBUG: PrescricaoAdapter registrado');
      }
      
      _initialized = true;
      print('DEBUG: Hive inicializado com sucesso');
    } catch (e) {
      print('ERRO ao inicializar Hive: $e');
      rethrow;
    }
  }

  // Abre uma box (equivalente a uma tabela)
  // Usa nome prefixado para garantir isolamento do app
  Future<Box<T>> openBox<T>(String boxName) async {
    final fullBoxName = 'insuguia_$boxName';
    if (!_initialized) {
      print('DEBUG: Hive não inicializado, inicializando...');
      await initialize();
    }
    
    if (Hive.isBoxOpen(fullBoxName)) {
      print('DEBUG: Box $fullBoxName já está aberta');
      return Hive.box<T>(fullBoxName);
    }
    
    print('DEBUG: Abrindo box $fullBoxName...');
    final box = await Hive.openBox<T>(fullBoxName);
    print('DEBUG: Box $fullBoxName aberta com ${box.length} itens');
    return box;
  }

  // Fecha todas as boxes
  Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}
