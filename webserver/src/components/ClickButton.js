'use strict';

import React from 'react';

export default class ClickButton extends React.Component {
  constructor() {
      super();
      this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
        this.props.onClick(this.props.value);
  }
      
  render() {
    return (
      <button className="my-button" onClick={this.handleClick}>
          {this.props.text}
      </button>
    );
  }
}
