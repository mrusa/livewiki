var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: "./entry.coffee",
  output: {
      path: __dirname + '/build/',
      filename: "livewiki.js"
  },
  module: {
    loaders: [
        { test: /\.coffee$/, loader: "coffee-loader" },
        { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" },
        { test: /\.html$/, loader: "html" },
        { test: /\.css$/, loader: ExtractTextPlugin.extract("css-loader") },
        { test: /\.(jpe?g|png|gif|svg|json)(?:\?.*|)$/i, loader: 'file?name=[path][name].[ext]' }
    ]
  },
  plugins: [
    new ExtractTextPlugin("./livewiki.css")
  ]
};
