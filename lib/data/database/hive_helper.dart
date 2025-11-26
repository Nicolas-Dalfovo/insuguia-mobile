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
    if (_initialized) return;
    
    try {
      await Hive.initFlutter();
      
      // Registra os adaptadores
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(PacienteAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TipoInsulinaBasalAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(TipoInsulinaRapidaAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(HorarioInsulinaAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(EscalaCorrecaoAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(PrescricaoAdapter());
      }
      
      _initialized = true;
    } catch (e) {
      print('Erro ao inicializar Hive: $e');
      rethrow;
    }
  }

  // Abre uma box (equivalente a uma tabela)
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!_initialized) {
      await initialize();
    }
    
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    
    return await Hive.openBox<T>(boxName);
  }

  // Fecha todas as boxes
  Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}
