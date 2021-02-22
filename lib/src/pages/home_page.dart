import 'package:flutter/material.dart';
import '../widgets/movie_horizontal.dart';
//import 'package:peliculas/src/models/pelicula_model.dart';
import '../providers/peliculas_provider.dart';
import '../widgets/card_swiper_widget.dart';
import '../search/search_delegate.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
              icon: Icon( Icons.search), 
              onPressed: (){
                showSearch(
                  context: context , 
                  delegate: DataSearch(),
                  //query: 'Hola'
                  );
              }
              )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:[
                _swipeTarjetas(),
                _footer(context),
            ]
          ),
        )
    );
  }

  Widget _swipeTarjetas(){

    return FutureBuilder(
      future: peliculasProvider.getEncines(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        
        if (snapshot.hasData){
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 300.0,
            child: Center(
              child: CircularProgressIndicator()
              )
              );
        }
      
      },
    );
    //final peliculasProvider = new PeliculasProvider();
    
    /*return CardSwiper(
      peliculas: [1,2,3,4,5]
      );*/
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
              style: Theme.of(context).textTheme.subtitle1),
            ),
            SizedBox(height: 2.0),

            StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data , 
                  siguientePagina: peliculasProvider.getPopulares
                  );
              } else {
                return Center(child: CircularProgressIndicator());
              }
              },
            ),
          ],
      ),
    );
  }
}