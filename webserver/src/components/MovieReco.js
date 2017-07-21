'use strict';

import React from 'react';

export default class MovieReco extends React.Component {
  render() {
    return (
        <div className="movie-reco">
          <img src={`img/${this.props.movie_id}.jpg`}/>
          {this.props.rating}% match
        </div>
    );
  }
}
