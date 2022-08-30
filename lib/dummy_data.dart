import 'package:flutter/material.dart';

import './models/category.dart';
import './models/book.dart';

const dummyCategories = [
  Category(
    id: 'c1',
    title: 'Romanzo',
    color: Colors.purple,
  ),
  Category(
    id: 'c2',
    title: 'Saggio',
    color: Colors.red,
  ),
  Category(
    id: 'c3',
    title: 'Manuale',
    color: Colors.orange,
  ),
];

const dummyBooks = [
  Book(
    id: 'b1',
    category: 'c1',
    title: 'Opinioni di un clown',
    author: 'Heinrich Boll',
    description: 'Romanzo appassionante',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg',
  ),
  Book(
    id: 'b2',
    category: 'c2',
    title: 'Apologia della matematica',
    author: 'G. H. Hardy',
    description: 'Saggio sull\'importanza e il valore della matematica',
    imageUrl:
        'https://cdn.pixabay.com/photo/2018/07/11/21/51/toast-3532016_1280.jpg',
  ),
];
