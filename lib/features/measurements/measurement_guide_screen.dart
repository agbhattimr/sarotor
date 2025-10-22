import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

class MeasurementPoint {
  final String name;
  final Offset position;
  final String description;
  final String tip;
  
  const MeasurementPoint({
    required this.name,
    required this.position,
    required this.description,
    required this.tip,
  });
}

class BodyDiagram extends CustomPainter {
  final List<MeasurementPoint> points;
  final MeasurementPoint? activePoint;
  final double scale;

  BodyDiagram({
    required this.points,
    this.activePoint,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw body outline
    final bodyPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.1) // Head
      ..lineTo(size.width * 0.5, size.height * 0.3) // Neck
      ..lineTo(size.width * 0.3, size.height * 0.4) // Left shoulder
      ..lineTo(size.width * 0.7, size.height * 0.4) // Right shoulder
      ..lineTo(size.width * 0.5, size.height * 0.3) // Back to neck
      ..lineTo(size.width * 0.5, size.height * 0.6) // Torso
      ..lineTo(size.width * 0.4, size.height * 0.9) // Left leg
      ..moveTo(size.width * 0.5, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.9); // Right leg

    canvas.drawPath(bodyPath, paint);

    // Draw measurement points
    for (final point in points) {
      final isActive = point == activePoint;
      final pointPaint = Paint()
        ..color = isActive ? Colors.blue : Colors.red
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          point.position.dx * size.width,
          point.position.dy * size.height,
        ),
        8 * scale,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MeasurementGuideScreen extends StatefulWidget {
  const MeasurementGuideScreen({super.key});

  @override
  State<MeasurementGuideScreen> createState() => _MeasurementGuideScreenState();
}

class _MeasurementGuideScreenState extends State<MeasurementGuideScreen> {
  late PageController _pageController;
  late VideoPlayerController _videoController;
  MeasurementPoint? _activePoint;
  int _currentStep = 0;

  final _measurementPoints = [
    const MeasurementPoint(
      name: 'Chest',
      position: Offset(0.5, 0.4),
      description: 'Measure around the fullest part of your chest',
      tip: 'Keep the tape measure parallel to the ground',
    ),
    const MeasurementPoint(
      name: 'Waist',
      position: Offset(0.5, 0.5),
      description: 'Measure around your natural waistline',
      tip: 'Find the narrowest part of your waist',
    ),
    // Add other measurement points...
  ];

  final _measurementSteps = [
    {
      'title': 'Preparation',
      'subtitle': 'What you\'ll need',
      'content': 'Get a flexible measuring tape and wear light clothing',
      'asset': 'assets/animations/preparation.json',
    },
    {
      'title': 'Chest Measurement',
      'subtitle': 'Around the fullest part',
      'content': 'Wrap the tape measure around your chest under your armpits',
      'asset': 'assets/animations/chest_measurement.json',
    },
    // Add other steps...
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _videoController = VideoPlayerController.asset('assets/videos/guide.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildInteractiveDiagram() {
    return AspectRatio(
      aspectRatio: 0.6,
      child: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              // Find closest point to tap
              final renderBox = context.findRenderObject() as RenderBox;
              final localPosition = renderBox.globalToLocal(details.globalPosition);
              final size = renderBox.size;
              
              MeasurementPoint? closest;
              var minDistance = double.infinity;
              
              for (final point in _measurementPoints) {
                final dx = point.position.dx * size.width - localPosition.dx;
                final dy = point.position.dy * size.height - localPosition.dy;
                final distance = dx * dx + dy * dy;
                
                if (distance < minDistance) {
                  minDistance = distance;
                  closest = point;
                }
              }
              
              if (minDistance < 400) { // Tap threshold
                setState(() => _activePoint = closest);
              }
            },
            child: CustomPaint(
              painter: BodyDiagram(
                points: _measurementPoints,
                activePoint: _activePoint,
              ),
            ),
          ),
          if (_activePoint != null)
            Positioned(
              left: _activePoint!.position.dx * context.size!.width,
              top: _activePoint!.position.dy * context.size!.height,
              child: Tooltip(
                message: _activePoint!.tip,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(33, 150, 243, 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _activePoint!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _activePoint!.description,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepByStepGuide() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _measurementSteps.length,
      itemBuilder: (context, index) {
        final step = _measurementSteps[index];
        return ExpansionTile(
          initiallyExpanded: index == _currentStep,
          onExpansionChanged: (expanded) {
            if (expanded) {
              setState(() => _currentStep = index);
            }
          },
          title: Text(step['title']!),
          subtitle: Text(step['subtitle']!),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(step['content']!),
                  const SizedBox(height: 16),
                  Lottie.asset(
                    step['asset']!,
                    height: 200,
                    repeat: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: [
          for (var i = 1; i <= 3; i++)
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/measurement_$i.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoGuide() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _videoController.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoController),
                if (!_videoController.value.isPlaying)
                  IconButton(
                    icon: const Icon(
                      Icons.play_circle_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _videoController.play();
                      });
                    },
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tips for Accurate Measurements'),
                  content: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Wear light, fitted clothing'),
                        Text('• Stand straight with arms relaxed'),
                        Text('• Keep the measuring tape parallel to the ground'),
                        Text('• Don\'t pull the tape too tight'),
                        Text('• Measure twice for accuracy'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileLayout(),
        tabletBody: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInteractiveDiagram(),
          const Divider(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildInteractiveDiagram(),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video Tutorial',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildVideoGuide(),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step-by-Step Guide',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildStepByStepGuide(),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visual References',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildImageCarousel(),
            ],
          ),
        ),
      ],
    );
  }
}
