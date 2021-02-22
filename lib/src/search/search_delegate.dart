import 'package:flutter/material.dart';
import '../models/pelicula_model.dart';
import '../providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String  seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  final peliculas  = [
      'Spiderman 2' ,
      'godzilla',
      'dragon ball  '
  ];

  final pelicularecientes = [
    'spiderman',
    'Capitan america'
      ];

  @override
  List<Widget> buildActions(BuildContext context) {
      // Las acciones de nuestro appbar
      return [
            IconButton(
              icon: Icon(Icons.clear), 
              onPressed: (){
                query = '';
              }),
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icono a la izquierda del appbar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ), 
          onPressed: (){
            close(context , null);
          }
        ) ;
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Crea los resultados que vamos a mostrar
      return Center(
            child: Container(
              height: 100,
              color: Colors.cyanAccent,
              child: Text(seleccion),
            ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando las personas escriben
    if(query.isEmpty) {
      return Container();
    }
 
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
            if (snapshot.hasData){
              final peliculas = snapshot.data;
              return ListView(
                    children: peliculas.map((pelicula) {
                      return ListTile(
                            leading: FadeInImage(
                              image: NetworkImage(pelicula.getPosterImg()),
                              placeholder: AssetImage('assets/img/no-image.jpg'),
                              width: 50.0,
                              fit: BoxFit.contain,
                            ),
                            title: Text(pelicula.title),
                            subtitle: Text(pelicula.originalTitle),
                            onTap: (){
                              close(context, null);
                              pelicula.uniqueId = '';
                              Navigator.pushNamed(context, 'detalle' , arguments: pelicula);
                            },
                      );
                    }).toList(),
                    );
            }else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
      
      }
    );
    
  }



 /*  @override
    Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando las personas escriben
    
    final listaSugerida = ( query.isEmpty) 
                            ? pelicularecientes
                            : peliculas.where(
                              (p) => p.toLowerCase().startsWith(query.toLowerCase())
                              ).toList();
    
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: (){
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  } */

}