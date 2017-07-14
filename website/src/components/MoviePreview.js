'use strict';

import React from 'react';
import StarRatingComponent from 'react-star-rating-component';

export default class MoviePreview extends React.Component {
  constructor() {
      super();

      this.state = {
          rating: 0
      };
  }

  render() {
    const { rating } = this.state;
    return (
        <div className="movie-preview">
          <img src={`img/${this.props.data.image}`}/>
          <StarRatingComponent 
                    name={this.props.data.id}
                    starCount={5}
                    value={rating}
                    onStarClick={this.props.onStarClick.bind(this)}
                />
        </div>
    );
  }
}
