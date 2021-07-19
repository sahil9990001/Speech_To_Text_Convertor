import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button & Start Speaking';
  double _confidence = 1.0;
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
        onTap: () => print('flutter'),
        textStyle:
            const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
    'youTube': HighlightedWord(
        onTap: () => print('youtube'),
        textStyle: const TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold)),
    'google': HighlightedWord(
        onTap: () => print('google'),
        textStyle:
            const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
    'search': HighlightedWord(
        onTap: () => print('search'),
        textStyle:
            const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
    'SahilBansal': HighlightedWord(
        onTap: () => print('Sahil Bansal'),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
  };

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'));
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                }));
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0.0,
        title: Center(
            child: Text(
                'Confidance: ${(_confidence * 100.0).toStringAsFixed(1)}%')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        repeat: true,
        animate: _isListening,
        shape: BoxShape.circle,
        endRadius: 80.0,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          elevation: 0.5,
          child: Icon(_isListening ? Icons.mic : Icons.mic),
          onPressed: _listen,
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Container(
            color: Colors.white,
            child: TextHighlight(
              // _text,
              text: _text,
              words: _highlights,
              textStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w400,
                color: Colors.teal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
