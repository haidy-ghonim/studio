import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Songs Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //variable
  Color? bgColor = Colors.lime[200];
  //player
  final AudioPlayer _player = AudioPlayer();

  //******
  bool   isPlaying = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  int all=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: bgColor,
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString("AssetManifest.json"),
        builder: (context, item) {
          if (item.hasData) {
            Map? jsonMap = jsonDecode(item.data!);
            List? songs = jsonMap?.keys.toList();
            //  List? songs = jsonMap?.keys.where((element) => element.endswith(".mp3")).toList();

            return ListView.builder(
              itemCount: songs?.length,
              itemBuilder: (context, index) {
                var path = songs![index].toString();
                var title = path.split("/").last.toString(); //get file name
                title = title.replaceAll("%20", ""); //remove %20 characters
                title = title.split(".").first;

                return Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.lime,
                    borderRadius: BorderRadius.circular(20.0),
                    // border: Border.all(color: Colors.cyan,width: 1.0,style: BorderStyle.solid),
                  ),
                  child: ListTile(
                    textColor: Colors.grey[700],
                    title: Text(title),
                    // subtitle: Text("path: $path",
                    //   style: const TextStyle(color: Colors.blueAccent,fontSize: 12),),
                    //trailing: Icon(Icons.pause),
                    // leading: const Icon(
                    //   Icons.audiotrack,
                    //   size: 20,
                    //   color: Colors.pink,
                    // ),
                    trailing: IconButton(
                      onPressed: () async {

                           toast(context, "You selected: $title");
                            await _player.setAsset(path);
                            await _player.play();


                        if(assetsAudioPlayer.isPlaying.value)
                          {
                            assetsAudioPlayer.pause();
                          } else{
                          assetsAudioPlayer.play();
                          // assetsAudioPlayer.playlistPlayAtIndex(index);
                        }
                        setState(() {
                          isPlaying=!isPlaying;
                          all=index;
                        });
                      },
                      icon: isPlaying  && all==index? Icon(Icons.pause) : Icon(Icons.play_arrow)),

                   iconColor: Colors.pink,

                   // onTap: () async {
                   // // toast(context, "You selected: $title");
                   // //  await _player.setAsset(path);
                   // //  await _player.play();
                   //  }
                         ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("NO SONGS in the Assets"),
            );
          }
        },
      ),
    );
  }
}

//a toast method
void toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    ),
  );
}
