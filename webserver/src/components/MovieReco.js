'use strict';

import React from 'react';
import ReactTooltip from 'react-tooltip'

export default class MovieReco extends React.Component {
  render() {
    return (
        <div className="movie-reco">
          <p data-class='movie-tooltip' data-tip={`${this.props.title}`}>
              <img src={`http://image.tmdb.org/t/p/w185/${this.props.path}`}/>
          </p>
          <ReactTooltip />
          {this.props.rating}% match
        </div>
    );
  }
}
