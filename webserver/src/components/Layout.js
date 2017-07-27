'use strict';

import React from 'react';
import { Link } from 'react-router';

export default class Layout extends React.Component {
  render() {
    return (
      <div className="app-container">
        <header>
            movie_match
        </header>
        <div className="app-content">{this.props.children}</div>
        <footer>
          <p>
            This is a demo app built to showcase the output from our UCB W205 final project
          </p>
        </footer>
      </div>
    );
  }
}