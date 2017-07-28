'use strict';

import React from 'react';

export default class MovieReco extends React.Component {
  render() {
    return (
        <div className="movie-reco">
          <img src={`http://image.tmdb.org/t/p/w185//${this.props.path}`}/>
          {this.props.rating}% match
        </div>
    );
  }
}
