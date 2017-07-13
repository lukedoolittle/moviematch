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

  onStarClick(nextValue, prevValue, name) {
      this.setState({rating: nextValue});
  }
  render() {
    const { rating } = this.state;
    return (
        <div className="movie-preview">
          <img src={`img/${this.props.image}`}/>
          <h2 className="name">{this.props.name}</h2>
          <StarRatingComponent 
                    name="rate1" 
                    starCount={5}
                    value={rating}
                    onStarClick={this.onStarClick.bind(this)}
                />
        </div>
    );
  }
}
