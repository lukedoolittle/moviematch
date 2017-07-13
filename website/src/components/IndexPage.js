'use strict';

import React from 'react';
import MoviePreview from './MoviePreview';
import movies from '../data/movies';

export default class IndexPage extends React.Component {
  render() {
    return (
      <div className="home">
        <div className="movies-selector">
          {movies.map(movieData => <MoviePreview key={movieData.id} {...movieData} />)}
        </div>
      </div>
    );
  }
}
