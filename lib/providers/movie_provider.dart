import 'package:flutter/material.dart';
import '../models/movie.dart';

// Provider for managing movie data and filtering
class MovieProvider extends ChangeNotifier {
  MovieCategory _selectedCategory = MovieCategory.all;

  MovieCategory get selectedCategory => _selectedCategory;

  void setCategory(MovieCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Sample movie data based on the original website
  final List<Movie> _movies = [
    const Movie(
      id: '1',
      title: 'Adam',
      originalTitle: 'آدم',
      director: 'Maryam Touzani',
      year: 2019,
      duration: '1h38min',
      rating: 4.8,
      genre: 'Drame',
      synopsis: 'A Casablanca, une jeune veuve enceinte et une fille mariee qui attendnt un enfant developpent une amitie improbable.',
      posterUrl: 'https://images.unsplash.com/photo-1533613220915-609f21a20fea?w=300&h=450&fit=crop',
      price: 60,
      category: MovieCategory.moroccan,
      language: 'AR/FR',
      showtimes: ['14:30', '17:00', '20:00'],
    ),
    const Movie(
      id: '2',
      title: 'Les Chevaux de Dieu',
      originalTitle: 'خيول الله',
      director: 'Nabil Ayouch',
      year: 2012,
      duration: '1h55min',
      rating: 4.7,
      genre: 'Drame',
      synopsis: 'A Sidi Moumen, un quartier pauvre de Casablanca, quatre adolescents vivent entre le foot, la musique et leurs reves.',
      posterUrl: 'https://images.unsplash.com/photo-1542200188-7bcf17241fd3?w=300&h=450&fit=crop',
      price: 65,
      category: MovieCategory.moroccan,
      language: 'AR',
      showtimes: ['15:00', '18:00', '21:00'],
    ),
    const Movie(
      id: '3',
      title: 'Much Loved',
      originalTitle: 'زين الليال',
      director: 'Nabil Ayouch',
      year: 2015,
      duration: '1h44min',
      rating: 4.5,
      genre: 'Drame',
      synopsis: 'L\'histoire de quatre prostituees a Marrakech, entre reves et realite.',
      posterUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=300&h=450&fit=crop',
      price: 55,
      category: MovieCategory.moroccan,
      language: 'AR/FR',
      showtimes: ['16:00', '19:00'],
    ),
    const Movie(
      id: '4',
      title: 'Goodbye Morocco',
      originalTitle: 'وداعا المغرب',
      director: 'Ismael Ferroukhi',
      year: 2012,
      duration: '2h10min',
      rating: 4.6,
      genre: 'Drame/Thriller',
      synopsis: 'Un road movie intense a travers le Maroc contemporain.',
      posterUrl: 'https://images.unsplash.com/photo-1489599849228-eb342f283348?w=300&h=450&fit=crop',
      price: 60,
      category: MovieCategory.moroccan,
      language: 'FR',
      showtimes: ['14:00', '17:30', '20:30'],
    ),
    const Movie(
      id: '5',
      title: 'Casanegra',
      originalTitle: 'كازانكروا',
      director: 'Nour-Eddine Lakhmari',
      year: 2008,
      duration: '2h11min',
      rating: 4.7,
      genre: 'Drame/Noir',
      synopsis: 'Deux amis d\'enfance tentent de survivre dans les rues de Casablanca.',
      posterUrl: 'https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?w=300&h=450&fit=crop',
      price: 55,
      category: MovieCategory.classics,
      language: 'AR/FR',
      showtimes: ['18:00'],
    ),
    const Movie(
      id: '6',
      title: 'Dune: Part Two',
      originalTitle: 'Dune: Part Two',
      director: 'Denis Villeneuve',
      year: 2024,
      duration: '2h46min',
      rating: 4.9,
      genre: 'Sci-Fi/Epic',
      synopsis: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against those who destroyed his family.',
      posterUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=300&h=450&fit=crop',
      price: 70,
      category: MovieCategory.newReleases,
      language: 'EN/FR',
      showtimes: ['14:00', '17:00', '20:00', '21:30'],
    ),
    const Movie(
      id: '7',
      title: 'Oppenheimer',
      originalTitle: 'Oppenheimer',
      director: 'Christopher Nolan',
      year: 2023,
      duration: '3h00min',
      rating: 4.8,
      genre: 'Biopic/Drame',
      synopsis: 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.',
      posterUrl: 'https://images.unsplash.com/photo-1512070679280-1f029bf13ff3?w=300&h=450&fit=crop',
      price: 70,
      category: MovieCategory.newReleases,
      language: 'EN/FR',
      showtimes: ['15:00', '19:00'],
    ),
    const Movie(
      id: '8',
      title: 'The Godfather',
      originalTitle: 'The Godfather',
      director: 'Francis Ford Coppola',
      year: 1972,
      duration: '2h55min',
      rating: 4.9,
      genre: 'Crime/Drame',
      synopsis: 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      posterUrl: 'https://images.unsplash.com/photo-1533613220915-609f21a20fea?w=300&h=450&fit=crop',
      price: 50,
      category: MovieCategory.classics,
      language: 'EN',
      showtimes: ['19:00'],
    ),
  ];

  List<Movie> get movies => _movies;

  List<Movie> get filteredMovies {
    if (_selectedCategory == MovieCategory.all) {
      return _movies;
    }
    return _movies.where((movie) => movie.category == _selectedCategory).toList();
  }

  List<Movie> get featuredMovies => _movies.take(4).toList();

  Movie? getMovieById(String id) {
    try {
      return _movies.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}
