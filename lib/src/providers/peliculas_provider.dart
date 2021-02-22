import 'dart:async';

import 'package:http/http.dart' as http;
import '../models/actores_model.dart';
import 'dart:convert';
import '../models/pelicula_model.dart';


class PeliculasProvider{
    String _apikey = '049a14d9e1ead6108841dd5f2f8ca955';
    String _url = 'api.themoviedb.org';
    String _language = 'es-ES';
    int _popularespage = 0;
    bool _cargando = false;
    List<Pelicula> _populares = [];
    final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();


    Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
    Stream<List<Pelicula>> get popularesStream  => _popularesStreamController.stream;


    void disposeStreams(){
      _popularesStreamController?.close();
    }


    Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
        final resp = await  http.get(url);
        final decodeData = json.decode(resp.body);
        final peliculas = new Peliculas.fromJsonList(decodeData['results']);
        return peliculas.items;
    }

    Future<List<Pelicula>>getEncines() async {
      final url = Uri.https(_url, '3/movie/now_playing' , {
          'api_key' : _apikey,
          'language': _language
      });
    
      return await _procesarRespuesta(url);
    }


    Future<List<Pelicula>>getPopulares() async {  
      
      if( _cargando) return [];
      _cargando = true;
      _popularespage++;
      
      final url = Uri.https(_url, '3/movie/popular' , {
            'api_key' : _apikey,
            'language': _language,
            'page': _popularespage.toString()
        });
    
        final resp = await _procesarRespuesta(url);
        _populares.addAll(resp);
        popularesSink(_populares);
        _cargando = false;
        return resp;
    }

    Future<List<Actor>>getCast(String peliId) async {
      final url = Uri.https(_url, '3/movie/$peliId/credits' , {
            'api_key' : _apikey,
            'language': _language
      });

      final resp = await http.get(url);
      final decodedData = json.decode(resp.body);

      final cast = new Cast.fromJsonList(decodedData['cast']);

      return cast.actores;

    }

    Future<List<Pelicula>>buscarPelicula( String query) async {
      final url = Uri.https(_url, '3/search/movie' , {
          'api_key' : _apikey,
          'language': _language,
          'query': query
      });
    
      return await _procesarRespuesta(url);
    }
}