'use strict';

import React from 'react';
import StarRatingComponent from 'react-star-rating-component';

export default class MovieRating extends React.Component {
  constructor() {
      super();

      this.state = {
          rating: 0
      };
  }

  render() {
    const { rating } = this.state;
    return (
        <div className="movie-rating"  style={{fontSize: 30}}>
          <img src={`http://image.tmdb.org/t/p/w185/${this.props.data.path}`}/>
          <StarRatingComponent 
                    name={this.props.data.movie_id}
                    starCount={5}
                    value={rating}
                    starColor="#ffffff"
                    onStarClick={this.props.onStarClick.bind(this)}
                />
        </div>
    );
  }
}
