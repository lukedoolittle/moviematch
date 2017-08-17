'use strict';

import React from 'react';
import ReactTooltip from 'react-tooltip'
import ClickButton from './ClickButton'
import Rater from 'react-rater'

export default class MovieRating extends React.Component {
  constructor(props) {
      super(props);

      this.state = {
          rating: 0,
          id: props.data.movie_id,
          onClick: props.onStarClick
      };
  }

  handleRate({ rating, type }) {
    this.setState({
      rating: rating
    })
    if (type === 'click') {
      this.state.onClick(rating, this.state.id);
    }
  }
  render() {
    const { rating } = this.state;
    return (
        <div className="movie-rating" style={{fontSize: 30}}>
          <p data-class='movie-tooltip' data-tip={`${this.props.data.title}`}>
              <img src={`http://image.tmdb.org/t/p/w185/${this.props.data.path}`}/>
          </p>
          <ReactTooltip delayShow={300} />
          <Rater
              total={5}
              rating={this.state.rating}
              onRate={this.handleRate.bind(this)}
          />
          <ClickButton
                    text='skip'
                    onClick={this.props.onSkipClick}
                    value={this.props.data.movie_id}/>
        </div>
    );
  }
}
