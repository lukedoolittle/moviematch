'use strict';

import React from 'react';
import MovieRating from './MovieRating';
import MovieReco from './MovieReco';
import Loadable from 'react-loading-overlay'
import TransitionGroup from 'react-transition-group/TransitionGroup';
import CSSTransition from 'react-transition-group/CSSTransition';

export default class IndexPage extends React.Component {
  constructor() {
    super();
    this.state = {
      movies: [],
      ratings: [],
      recommendations: [],
      loading: false
    };
    this.onStarClick = this.onStarClick.bind(this);
    this.onRecosReceived = this.onRecosReceived.bind(this);
    this.onSkipClick = this.onSkipClick.bind(this);
  }

  componentDidMount() {
    fetch('/api/movies/ids/5317,15124,6287,1905,11283,16242,12470,15582,9340,6972,457,2152,3860,15107,1220,5496,1962,571,8644,14538')
      .then(response => { return response.json(); })
      .then(result => {
        this.setState({movies: result,
                       ratings: this.state.ratings, 
                       recommendations: this.state.recommendations,
                       loading: this.state.loading});
    });
  }

  onRecosReceived(recommendations){
    this.setState({movies: this.state.movies,
                   ratings: this.state.ratings, 
                   recommendations: recommendations,
                   loading: false});
  }

  onSkipClick(name) {
    this.state.movies.splice(this.state.movies.findIndex(i => i.movie_id === name), 1);
    this.setState({movies: this.state.movies,
                   ratings: this.state.ratings, 
                   recommendations: this.state.recommendations,
                   loading: this.state.loading});
  }

  onStarClick(nextValue, prevValue, name) {
    this.state.ratings.push({movie_id: name, rating: nextValue})
    this.state.movies.splice(this.state.movies.findIndex(i => i.movie_id === name), 1);
    this.setState({movies: this.state.movies,
                   ratings: this.state.ratings, 
                   recommendations: this.state.recommendations,
                   loading: this.state.loading});
    if(this.state.ratings.length === 5) {
      this.setState({movies: this.state.movies,
                     ratings: this.state.ratings, 
                     recommendations: this.state.recommendations,
                     loading: true});
      fetch('/api/predict',
        {
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          method: "POST",
          body: JSON.stringify(this.state.ratings)
        })
        .then(response => { return response.json(); })
        .then(this.onRecosReceived);
    }
  }

  render() {
    const {recommendations} = this.state;
    const movies = this.state.movies.slice(0,5).map(movieData => 
        <CSSTransition 
          key={movieData.movie_id} 
          classNames="movie" 
          timeout={{ enter: 300, exit: 300 }}> 
        <MovieRating key={movieData.movie_id}
                     data={movieData}
                     onStarClick={this.onStarClick}
                     onSkipClick={this.onSkipClick}/>
        </CSSTransition>
    );
    return (
      <div className="home">
        <div className="movies-selector">
          <div className="category-header">ratings</div>
          <div className="movies-ratings">
            <Loadable
              active={this.state.loading}
              spinner={true}
              animate={true}
              text='Generating recommendations...'>
              <TransitionGroup> 
                {movies}
              </TransitionGroup>
            </Loadable>
          </div>
        </div>
        <div className="movies-selector">
          <div className="category-header">recommendations</div>
          {recommendations.slice(0,5).map(recoData => <MovieReco key={recoData.movie_id} {...recoData } />)}
        </div>
      </div>
    );
  }
}