import 'package:flutter/material.dart';

import '../../data/remote/pet_fact_remote_source.dart';
import '../../models/pet_fact.dart';
import '../../services/sensor_service.dart';
import '../../utils/theme.dart';

class PetFactsScreen extends StatefulWidget {
  const PetFactsScreen({super.key});

  @override
  State<PetFactsScreen> createState() => _PetFactsScreenState();
}

class _PetFactsScreenState extends State<PetFactsScreen> {
  final _remoteSource = PetFactRemoteSource();
  final _sensorService = SensorService();

  PetFact? _fact;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFact();
    _sensorService.onShake.listen((_) => _loadFact());
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  Future<void> _loadFact() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final fact = await _remoteSource.fetchRandomFact();
      if (!mounted) return;
      setState(() {
        _fact = fact;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load a fact right now. Check your connection and try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Facts')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loading)
                const CircularProgressIndicator()
              else if (_error != null)
                Text(_error!, textAlign: TextAlign.center)
              else if (_fact != null) ...[
                if (_fact!.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _fact!.imageUrl!,
                      height: 220,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                          progress == null ? child : const SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
                      errorBuilder: (context, error, stack) => const SizedBox(
                        height: 220,
                        child: Center(child: Icon(Icons.pets, size: 64, color: AppColors.tintDeep)),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  _fact!.fact,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
              const SizedBox(height: 24),
              const Text('Shake your device for another fact', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loading ? null : _loadFact,
                icon: const Icon(Icons.refresh),
                label: const Text('NEW FACT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
