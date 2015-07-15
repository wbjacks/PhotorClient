'use strict';

var React = require('react-native');
var {
  AppRegistry,
  Image,
  ListView,
  StyleSheet,
  Text,
  View,
} = React;

var REQUEST_URL = "http://localhost:4567";

var PhotorClient = React.createClass({
  getInitialState: function() {
    return {
        hello_text: null,
        loaded: false
    };
  },

  componentDidMount: function() {
    this.fetchData();
  },

  fetchData: function() {
    fetch(REQUEST_URL)
      .then((response) => response.json())
      .then((responseData) => {
        this.setState({
            hello_text: responseData,
            loaded: true
        });
      })
      .done();
  },

  render: function() {
    if (!this.state.loaded) {
      return this.renderLoadingView();
    }

    return (
      <View style={styles.content}>
            <Text style={styles.container}>{this.state.hello_text}</Text>
        </View>
    );
  },

  renderLoadingView: function() {
    return (
      <View style={styles.content}>
        <Text style={styles.container}>
          Loading...
        </Text>
      </View>
    );
  },
});

var styles = StyleSheet.create({
    text: {
        textAlign: 'center',
    },
    content: {
        marginTop: 300
    }
});

AppRegistry.registerComponent('PhotorClient', () => PhotorClient);
