'use strict';

import React from 'react';
import MoviePreview from './MoviePreview';
import movies from '../data/movies';


export default class IndexPage extends React.Component {
  constructor() {
      super();

      this.state = {
        ratings:{someMovie:1},
        recommendations:{}
        //,gotSomeRecommendations: 'No'
      };

      this.onStarClick = this.onStarClick.bind(this);
      this.onRecosReceived = this.onRecosReceived.bind(this);
  }

  onRecosReceived(recommendations){
    this.setState({recommendations: recommendations});
    //console.log('I was triggered during fetch callback')
    //this.setState({gotSomeRecommendations: 'yes'})
  }

  onStarClick(nextValue, prevValue, name) {
    this.state.ratings[name] = nextValue
    this.forceUpdate();
    if(Object.keys(this.state.ratings).length > 2) {
      //this.setState({gotSomeRecommendations: 'waiting...'})
      fetch('/api').then(this.onRecosReceived);
    }
  }

  render() {
    const {gotSomeRecommendations} = this.state;
    return (
      <div className="home">
        <div className="movies-selector">
          {movies.map(movieData => <MoviePreview key={movieData.id} {...{data: movieData, onStarClick: this.onStarClick} } />)}
          {/*<h2>Got some recos: {gotSomeRecommendations}</h2>*/}
        </div>
      </div>
    );
  }
}
