const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const path = require('path');

module.exports = {
  entry: {
    'screenconnect': './static/js/screenconnect.coffee',
    'settings': './static/js/settings.coffee',
  },
  output: {
    path: path.resolve(__dirname, 'static/dist'),
    filename: 'js/[name].js',
    clean: true,
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'css/screenconnect.css'
    })
  ],
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: ['coffee-loader']
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  },
};

