'use strict';

import React from 'react';
import MovieRating from './MovieRating';
import MovieReco from './MovieReco';
import movies from '../data/movies';

export default class IndexPage extends React.Component {
  constructor() {
      super();

      this.state = {
        ratings:{someMovie:1},
        recommendations:[{movie_id:1, rating: 10}, {movie_id:2, rating:0}]
      };

      this.onStarClick = this.onStarClick.bind(this);
      this.onRecosReceived = this.onRecosReceived.bind(this);
  }

  onRecosReceived(recommendations){
    this.setState({ratings: this.state.ratings, recommendations: recommendations});
    //console.log('I was triggered during fetch callback')
    //this.setState({gotSomeRecommendations: 'yes'})
  }

  onStarClick(nextValue, prevValue, name) {
    this.state.ratings[name] = nextValue
    this.forceUpdate();
    if(Object.keys(this.state.ratings).length > 2) {
      //fetch('/api').then(this.onRecosReceived);
      this.onRecosReceived([{movie_id: 1, rating: 97}, {movie_id: 2, rating: 80}, {movie_id: 3, rating: 99}, {movie_id: 4, rating: 40}, {movie_id: 5, rating: 2}])
    }
  }

  render() {
    const {recommendations} = this.state;
    return (
      <div className="home">
        <div className="movies-selector">
          <div className="category-header">ratings</div>
          {movies.map(movieData => <MovieRating key={movieData.id} {...{data: movieData, onStarClick: this.onStarClick} } />)}
        </div>
        <div className="movies-selector">
          <div className="category-header">recommendations</div>
          {recommendations.map(recoData => <MovieReco key={recoData.movie_id} {...recoData } />)}
        </div>
      </div>
    );
  }
}
